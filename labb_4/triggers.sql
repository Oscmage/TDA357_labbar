
CREATE OR REPLACE FUNCTION register() RETURNS trigger AS $$

	DECLARE
		maximumAmount int;
		currentReg int;
	BEGIN
		-- Has already passed course
		IF exists(SELECT * FROM PassedCourses AS pc WHERE NEW.personal_number = pc.personal_number AND NEW.code = pc.code) THEN
			RAISE EXCEPTION 'Student has already passed this course';
		END IF;
		
		-- Check if student hasn't read prerequisite
		IF EXISTS (
				SELECT prerequisite as course
				FROM is_prerequisite AS ip 
				WHERE ip.code = NEW.code

				EXCEPT 

				SELECT code as course 
				FROM PassedCourses AS pc
				WHERE NEW.personal_number = pc.personal_number AND NEW.code = pc.code
			) 
		THEN
			--You havn't read all prerequisite
			RAISE EXCEPTION 'Student hasnt read the prerequisite courses for this course';
		END IF; 


		maximumAmount := (SELECT max_amount FROM limited_course AS lc WHERE NEW.code = lc.code);
		
		-- Get current registered for the course
		SELECT Count(*) INTO currentReg FROM Registrations AS reg WHERE NEW.code = reg.code AND reg.status = 'registered'; 

 		-- Is course a limited course?
		IF maximumAmount IS NOT NULL THEN
			-- Is course full?
			IF (currentReg >= maximumAmount) THEN
				-- Put student on waiting list
				INSERT INTO waiting_for VALUES (NEW.code, NEW.personal_number, CURRENT_TIMESTAMP);
			ELSE 
				-- Put student is_registered_for
				INSERT INTO is_registered_for VALUES (NEW.personal_number, NEW.code);
			END IF;
		ELSE
			-- Put student in is_registered_for
			INSERT INTO is_registered_for VALUES (NEW.personal_number, NEW.code);
		END IF;
		RETURN NEW;
         END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER register INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE register();


--Trigger two
CREATE OR REPLACE VIEW StudentsFirstInQueue AS
	SELECT cqp.code,cqp.personal_number,name 
	FROM CourseQueuePositions AS cqp
	JOIN students ON students.personal_number = cqp.personal_number
	WHERE cqp.position = '1'; 

CREATE OR REPLACE FUNCTION unregister() RETURNS trigger AS $$
	DECLARE
		maximumAmount int;
		currentReg int;
		totWaitingStudents int;
		firstPersNum TEXT;	
		firstPersName TEXT;
	BEGIN
		-- Delete student from both possible table
		DELETE FROM waiting_for WHERE code = OLD.code AND personal_number = OLD.personal_number;
		DELETE FROM is_registered_for WHERE personal_number = OLD.personal_number AND course_code = OLD.code;

		-- Get maximum amount for the course
		maximumAmount := (SELECT max_amount FROM limited_course AS lc WHERE OLD.code = lc.code);
		
		-- Get current registered for the course
		SELECT Count(*) INTO currentReg FROM Registrations AS reg WHERE OLD.code = reg.code AND reg.status = 'registered'; 

		IF currentReg < maximumAmount THEN

				-- Count the amount of waiting students.
			SELECT Count (*) INTO totWaitingStudents FROM StudentsFirstInQueue AS SFIQ WHERE OLD.code = SFIQ.code;

			IF totWaitingStudents > 0 THEN

				firstPersNum := (SELECT personal_number FROM StudentsFirstInQueue AS SFIQ WHERE OLD.code = SFIQ.code);

				-- Delete the first student from waiting list
				DELETE FROM waiting_for WHERE code = OLD.code AND personal_number = firstPersNum;

				-- Insert the old first in queue student into registrations
				INSERT INTO is_registered_for VALUES (firstPersNum, OLD.code);
			END IF;
		END IF;
		RETURN OLD;
         END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER unregister INSTEAD OF DELETE ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE unregister();
