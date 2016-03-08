
DROP TRIGGER IF EXISTS register ON Registrations CASCADE;
DROP TRIGGER IF EXISTS unregister ON Registrations CASCADE;


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

		-- Make sure we're not already waiting for or registered for the course.
		IF EXISTS (SELECT * FROM registrations AS reg WHERE NEW.code = reg.code AND reg.personal_number = NEW.personal_number) THEN
			RAISE EXCEPTION 'Student already registered or in waiting queue';
		END IF;
		
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

CREATE OR REPLACE FUNCTION unregister() RETURNS trigger AS $$
	DECLARE
		isLimitedCourse int;
		maximumAmount int;
		currentReg int;
		totWaitingStudents int;
		firstPersNum TEXT;	
	BEGIN
		-- Delete student from both possible table
		DELETE FROM waiting_for WHERE code = OLD.code AND personal_number = OLD.personal_number;
		DELETE FROM is_registered_for WHERE personal_number = OLD.personal_number AND course_code = OLD.code;

		isLimitedCourse := (SELECT Count(*) FROM limited_courses WHERE OLD.code = limited_courses.code);
		IF isLimitedCourse > 0 THEN
			-- Get maximum amount for the course
			maximumAmount := (SELECT max_amount FROM limited_course AS lc WHERE OLD.code = lc.code);
			
			-- Get current registered for the course
			SELECT Count(*) INTO currentReg FROM Registrations AS reg WHERE OLD.code = reg.code AND reg.status = 'registered'; 
			-- Make sure we're not adding a student if there isn't place for one.
			IF currentReg < maximumAmount THEN

				-- Count the amount of waiting students.
				SELECT Count (*) INTO totWaitingStudents FROM Registrations WHERE code = OLD.code AND status = 'waiting';
				-- Make sure we have someone waiting in queue.
				IF totWaitingStudents > 0 THEN
					-- we now know there's someone to register.

					-- Get the student which is first in queue.
					firstPersNum := (SELECT personal_number FROM Registrations AS REG WHERE OLD.code = REG.code AND position = '1');

					-- Delete the student which is first in queue from the waiting list
					DELETE FROM waiting_for WHERE code = OLD.code AND personal_number = firstPersNum;

					-- Insert the student which was first in the waiting list to registered.
					INSERT INTO is_registered_for VALUES (firstPersNum, OLD.code);
				END IF;
			END IF;
		END IF;
		RETURN OLD;
         END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER unregister INSTEAD OF DELETE ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE unregister();
