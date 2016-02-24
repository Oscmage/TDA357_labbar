

DROP TABLE IF EXISTS
departments,programs,branches,classification,courses,
students,is_prerequisite,has_classification,limited_course,
waiting_for,course_completed,is_registered_for,
additional_mandatory,belongs_to,
is_recommended,
is_mandatory,
host_programs CASCADE;

DROP VIEW IF EXISTS
StudentsFollowing,FinishedCourses,Registrations,PassedCourses,
UnreadMandatory,PathToGraduation, CourseQueuePosition,registered_students_for_limited_course CASCADE;

/*<----------------------------TABLE START--------------------------->*/
CREATE TABLE departments (
	abbreviation TEXT,
	name TEXT NOT NULL UNIQUE,
	PRIMARY KEY (abbreviation)
);


CREATE TABLE programs (
	name TEXT,
	abbreviation TEXT NOT NULL,
	PRIMARY KEY (name)
);


CREATE TABLE branches (
	name TEXT,
	program_name TEXT,
	PRIMARY KEY (name,program_name),
	FOREIGN KEY (program_name) REFERENCES programs (name) ON DELETE CASCADE
);

CREATE TABLE classification (
	name TEXT,
	PRIMARY KEY (name)
);

CREATE TABLE courses (
	code TEXT ,
	name TEXT NOT NULL,
	credit FLOAT NOT NULL CHECK (credit > 0),
	department TEXT,
	PRIMARY KEY (code),
	FOREIGN KEY (department) REFERENCES departments (abbreviation) ON DELETE SET NULL
);

CREATE TABLE students (
	personal_number CHAR(10), /*CHECK (personal_number LIKE '%[0-9]%'), Personal number in format '94 11 13 1340' NOT '1994 11 13 1340' */
	name TEXT NOT NULL,
	student_id TEXT NOT NULL,
	program_name TEXT,
	unique (personal_number, program_name),
	unique (student_id),
	PRIMARY KEY (personal_number),
	FOREIGN KEY (program_name) REFERENCES programs (name) ON DELETE SET NULL
);

CREATE TABLE is_prerequisite (
	code TEXT,
	prerequisite TEXT,
	PRIMARY KEY (code,prerequisite),
	FOREIGN KEY (code) REFERENCES courses (code) ON DELETE CASCADE,
	FOREIGN KEY (prerequisite)  REFERENCES courses (code) ON DELETE CASCADE
);

CREATE TABLE has_classification (
	name TEXT,
	code TEXT,
	PRIMARY KEY (name,code),
	FOREIGN KEY (name) REFERENCES classification (name) ON DELETE CASCADE,
	FOREIGN KEY (code) REFERENCES courses (code) ON DELETE CASCADE
);

CREATE TABLE limited_course (
	code TEXT,
	max_amount INT CHECK (max_amount > 0) NOT NULL,
	PRIMARY KEY (code),
	FOREIGN KEY (code) REFERENCES courses (code) ON DELETE CASCADE
);

CREATE TABLE waiting_for (
	code TEXT,
	personal_number CHAR(10),
	since_date TIMESTAMP NOT NULL,
	unique (code, since_date),
	PRIMARY KEY (code,personal_number),
	FOREIGN KEY (code) REFERENCES courses (code) ON DELETE CASCADE,
	FOREIGN KEY (personal_number) REFERENCES students (personal_number) ON DELETE CASCADE
);


CREATE TABLE course_completed (
	personal_number CHAR(10),
	course_code CHAR(6),
	grade CHAR(1) CHECK (grade IN ('3','4','5','U')) NOT NULL,
	PRIMARY KEY (personal_number,course_code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),--No delete here or anything like that since we probably wanna keep a register of finished students
	FOREIGN KEY (course_code) REFERENCES courses (code) --Same thinking as comment above
);

CREATE TABLE is_registered_for (
	personal_number CHAR(10),
	course_code CHAR(6),
	PRIMARY KEY (personal_number,course_code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number) ON DELETE CASCADE,
	FOREIGN KEY (course_code) REFERENCES courses (code) ON DELETE CASCADE
);

CREATE TABLE additional_mandatory (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	PRIMARY KEY (course_code,branch_name,program_name),
	FOREIGN KEY (course_code) REFERENCES courses (code) ON DELETE CASCADE,
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) ON DELETE CASCADE
);

CREATE TABLE is_recommended (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	PRIMARY KEY (course_code,branch_name,program_name),
	FOREIGN KEY (course_code) REFERENCES courses (code) ON DELETE CASCADE,
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) ON DELETE CASCADE
);

CREATE TABLE is_mandatory (
	course_code CHAR(6),
	program TEXT,
	PRIMARY KEY (course_code,program),
	FOREIGN KEY (course_code) REFERENCES courses (code) ON DELETE CASCADE,
	FOREIGN KEY (program) REFERENCES programs (name) ON DELETE CASCADE
);

CREATE TABLE belongs_to ( 
	personal_number CHAR(10),
	branch_name TEXT NOT NULL,
	program_name TEXT NOT NULL,
	PRIMARY KEY (personal_number),
	FOREIGN KEY (personal_number,program_name) REFERENCES students (personal_number,program_name) ON DELETE CASCADE,
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name,program_name) ON DELETE CASCADE
);

CREATE TABLE host_programs (
	abbreviations TEXT,
	program_name TEXT,
	PRIMARY KEY (abbreviations,program_name),
	FOREIGN KEY (abbreviations) REFERENCES departments (abbreviation) ON DELETE CASCADE,
	FOREIGN KEY (program_name) REFERENCES programs (name) ON DELETE CASCADE
);

/*<----------------------------TABLE END--------------------------->*/


/*<------------------------------------INSERTION START--------------------------------->*/



	/*DEPTS*/
	INSERT INTO departments VALUES ('CS', 'Computer Science');
	INSERT INTO departments VALUES ('CE', 'Computer Engineering');
	INSERT INTO departments VALUES ('KAPPA', 'Serious Society');
	INSERT INTO departments VALUES ('MA', 'Mathematical');
	INSERT INTO departments VALUES ('DE', 'Design');

	/*Classifications*/	
	INSERT INTO classification VALUES ('Math');
	INSERT INTO classification VALUES ('Research');
	INSERT INTO classification VALUES ('Language');
	INSERT INTO classification VALUES ('Seminar');
	INSERT INTO classification VALUES ('Physics');

	/*Programs*/
	INSERT INTO programs VALUES ('Informationsteknik','IT');
	INSERT INTO programs VALUES ('Datateknik', 'D');
	INSERT INTO programs VALUES ('Industriell Ekonomi', 'I');
	INSERT INTO programs VALUES ('Maskinteknik', 'M');
	INSERT INTO programs VALUES ('Flipperteknik', 'F');

	/*Host Program*/
	INSERT INTO host_programs VALUES ('CS','Informationsteknik');

	/*Branches*/
	INSERT INTO branches VALUES ('Algorithms', 'Datateknik');	
	INSERT INTO branches VALUES ('Awesomeness', 'Flipperteknik');
	INSERT INTO branches VALUES ('Software Engineering','Informationsteknik');
	INSERT INTO branches VALUES ('Computer Science & Algorithms','Datateknik');
	/*
	Duplicate
	INSERT INTO branches VALUES ('Software Engineering','Informationsteknik');

	error Informationsteknk finns inte
	INSERT INTO branches VALUES ('Software Engineering','Informationsteknk'); 
	*/
	
	/*Courses*/
	INSERT INTO courses VALUES ('TDA357', 'Databaser', '7.5', 'CS');
	INSERT INTO courses VALUES ('DAT205', 'Advanced Computer Graphics', '15.0', 'CE');
	INSERT INTO courses VALUES ('DRU101', 'Pinball Theory', '7.5', 'CS');
	INSERT INTO courses VALUES ('DRU102', 'Advanced Pinball Physics', '7.5', 'CS');
	INSERT INTO courses VALUES ('DRU103', 'Quantum Pinball Theory', '15.0', 'KAPPA');
	INSERT INTO courses VALUES ('TDA416', 'Datastrukturer', '7.5', 'CS');
	INSERT INTO courses VALUES ('TDA545', 'Objektorienterad programmering', '7.5', 'CS');
	INSERT INTO courses VALUES ('EDA433', 'Grundläggande datorteknik', '7.5', 'CS');
	INSERT INTO courses VALUES ('TMV200', 'Diskret matematik', '7.5', 'MA');
	INSERT INTO courses VALUES ('TMV206', 'Linjär algebra', '7.5', 'MA');
	INSERT INTO courses VALUES ('DAT216', 'Design', '7.5', 'DE');
	INSERT INTO courses VALUES ('MVE045', 'Matematisk analys', '7.5', 'MA');
	insert into courses (code, name, credit, department) values ('RQI213', 'Mysis', 4.0, 'CS');
	insert into courses (code, name, credit, department) values ('JUO414', 'Sales Effectiveness', 11.9, 'KAPPA');
	insert into courses (code, name, credit, department) values ('SDM960', 'Turbomachinery', 6.6, 'CE');
	insert into courses (code, name, credit, department) values ('YXU113', 'Information Architecture', 8.2, 'MA');
	insert into courses (code, name, credit, department) values ('RCL799', 'JSLint', 13.8, 'CE');
	insert into courses (code, name, credit, department) values ('XMP106', 'Motion Graphics', 11.1, 'MA');
	insert into courses (code, name, credit, department) values ('ZNU284', 'Komodo Edit', 5.4, 'DE');
	insert into courses (code, name, credit, department) values ('OFY724', 'BMP', 6.9, 'DE');
	insert into courses (code, name, credit, department) values ('RTV242', 'FX Hedging', 9.5, 'MA');
	insert into courses (code, name, credit, department) values ('DBC858', 'vBlock', 10.7, 'DE');
	insert into courses (code, name, credit, department) values ('TDB522', 'Lyophilization', 12.0, 'CS');
	insert into courses (code, name, credit, department) values ('ANP395', 'FTTx', 10.6, 'MA');
	insert into courses (code, name, credit, department) values ('QNH597', 'NCMR', 8.3, 'MA');
	insert into courses (code, name, credit, department) values ('NVU081', 'SAP SD', 11.2, 'CE');
	insert into courses (code, name, credit, department) values ('FXZ953', 'SBRT', 10.8, 'CE');
	insert into courses (code, name, credit, department) values ('CEO347', 'German', 2.9, 'CE');
	insert into courses (code, name, credit, department) values ('XOJ382', 'Food &amp; Beverage', 14.5, 'CS');
	insert into courses (code, name, credit, department) values ('AZL030', 'Intercollegiate Athletics', 10.6, 'MA');
	insert into courses (code, name, credit, department) values ('GEC412', 'Music Publishing', 3.0, 'DE');
	insert into courses (code, name, credit, department) values ('LIH199', 'Sustainable Development', 14.8, 'DE');
	insert into courses (code, name, credit, department) values ('XJQ776', 'EGPRS', 3.6, 'DE');
	insert into courses (code, name, credit, department) values ('KLP368', 'DFR', 3.3, 'DE');



	/*Prereqs*/
	INSERT INTO is_prerequisite VALUES ('DRU102','DRU101');
	INSERT INTO is_prerequisite VALUES ('DRU103','DRU102');
	INSERT INTO is_prerequisite VALUES ('TDA545','ANP395');

	/*Course classification*/
	INSERT INTO has_classification VALUES ('Physics','DRU101');
	INSERT INTO has_classification VALUES ('Math','DRU101');
	INSERT INTO has_classification VALUES ('Math','DRU102');
	INSERT INTO has_classification VALUES ('Math','DRU103');
	INSERT INTO has_classification VALUES ('Seminar','DAT205');
	INSERT INTO has_classification VALUES ('Research','LIH199');

	/*Limited course*/
	INSERT INTO limited_course VALUES ('TDA357','1');
	INSERT INTO limited_course VALUES ('DAT205','1');
	INSERT INTO limited_course VALUES ('KLP368','1');

	/*Students*/
	INSERT INTO students VALUES ('9411131230','Oscar Evertsson', 'oscarev', 'Informationsteknik');
	INSERT INTO students VALUES ('9206031111','Victor Olausson', 'vicola', 'Datateknik');
	INSERT INTO students VALUES ('9311131230','Lars Larssson', 'larsla', 'Informationsteknik');
	INSERT INTO students VALUES ('9211131230','Bruce Springsteen', 'bruces', 'Informationsteknik');
	INSERT INTO students VALUES ('9111131230','Sven Svensson', 'svensv', 'Industriell Ekonomi');
	INSERT INTO students VALUES ('8811131230','Bon jovi', 'bonj', 'Flipperteknik');
	INSERT INTO students VALUES ('4206120001','Old Man', 'gammal', 'Flipperteknik');

	/*Mandatory for program*/
	INSERT INTO is_mandatory VALUES ('TDA357','Informationsteknik');
	INSERT INTO is_mandatory VALUES ('DAT205','Informationsteknik');
	INSERT INTO is_mandatory VALUES ('TDA357','Datateknik');
	INSERT INTO is_mandatory VALUES ('DAT205','Datateknik');
	INSERT INTO is_mandatory VALUES ('DRU101','Datateknik');
	INSERT INTO is_mandatory VALUES ('DRU102','Datateknik');
	INSERT INTO is_mandatory VALUES ('DRU103','Flipperteknik');

	/*Student is waiting to get into course*/
	/* Three waiting students for two different limited courses.*/
	INSERT INTO waiting_for VALUES ('TDA357','9206031111', '1992-06-03');
	INSERT INTO waiting_for VALUES ('TDA357','9211131230', '1992-06-05');


	
	INSERT INTO waiting_for VALUES ('DAT205','9206031111', '1992-06-03');
	
	INSERT INTO waiting_for VALUES ('DAT205','9311131230', '1992-06-04 07:40:10');
	
	INSERT INTO waiting_for VALUES ('DAT205','8811131230', '1992-06-04');
	INSERT INTO waiting_for VALUES ('DAT205','9211131230', '1992-06-05');
	
	/* Oscar Evertsson is allowed to graduate. changing any value to U changes qualify */
	INSERT INTO course_completed VALUES ('9411131230','TDA357','5');
	INSERT INTO course_completed VALUES ('9411131230','DAT205','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU101','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU102','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU103','3');
	INSERT INTO course_completed VALUES ('9411131230','LIH199','3');

	/*Victor Olausson has only 1 mandatory_left*/
	INSERT INTO course_completed VALUES ('9206031111','TDA357','5');
	INSERT INTO course_completed VALUES ('9206031111','DRU101','U'); --This needs to be done (tested)
	INSERT INTO course_completed VALUES ('9206031111','DRU102','5');
	INSERT INTO course_completed VALUES ('9206031111','DRU103','3');
	INSERT INTO course_completed VALUES ('9206031111','DAT205','4');
	INSERT INTO course_completed VALUES ('9206031111','LIH199','3');
	
	/*Bon Jovi has too few seminar courses*/
	INSERT INTO course_completed VALUES ('8811131230','TDA357','5');
	INSERT INTO course_completed VALUES ('8811131230','DRU101','3'); 
	INSERT INTO course_completed VALUES ('8811131230','DRU102','5');
	INSERT INTO course_completed VALUES ('8811131230','DRU103','3');
	INSERT INTO course_completed VALUES ('8811131230','DAT205','U'); --This needs to be done (tested)
	INSERT INTO course_completed VALUES ('8811131230','LIH199','3');
	
	/*Lars Larsson has too few research credits*/
	INSERT INTO course_completed VALUES ('9311131230','TDA357','5');
	INSERT INTO course_completed VALUES ('9311131230','DAT205','5');
	INSERT INTO course_completed VALUES ('9311131230','DRU101','5');
	INSERT INTO course_completed VALUES ('9311131230','DRU102','5');
	INSERT INTO course_completed VALUES ('9311131230','DRU103','3');
	INSERT INTO course_completed VALUES ('9311131230','LIH199','U'); --This needs to be done (tested)

	/*Bruce Springsteen has too few math credits*/
	INSERT INTO course_completed VALUES ('9211131230','TDA357','5');
	INSERT INTO course_completed VALUES ('9211131230','DAT205','5');
	INSERT INTO course_completed VALUES ('9211131230','DRU101','5');
	INSERT INTO course_completed VALUES ('9211131230','DRU102','5');
	INSERT INTO course_completed VALUES ('9211131230','DRU103','U'); --This needs to be done (tested)
	INSERT INTO course_completed VALUES ('9211131230','LIH199','5');


	/*Registered for*/
	INSERT INTO is_registered_for VALUES ('9206031111', 'DRU102');
	INSERT INTO is_registered_for VALUES ('9411131230', 'EDA433');
	INSERT INTO is_registered_for VALUES ('9311131230', 'TDA357');
	INSERT INTO is_registered_for VALUES ('9211131230', 'MVE045');
	INSERT INTO is_registered_for VALUES ('9111131230', 'DAT216');
	/*Additional Mandatory*/
	INSERT INTO additional_mandatory VALUES ('DRU101','Software Engineering','Informationsteknik');
	INSERT INTO additional_mandatory VALUES ('DRU102','Software Engineering','Informationsteknik');

	/*Recommended*/
	INSERT INTO is_recommended VALUES ('DAT205','Software Engineering','Informationsteknik');
	
	
	/*BelongsTo*/ 
	INSERT INTO belongs_to VALUES ('9411131230','Software Engineering','Informationsteknik');
/*<------------------------------------INSERTION END--------------------------------->*/

/*<------------------------------------VIEW START--------------------------------->*/

	CREATE VIEW StudentsFollowing AS
		SELECT  students.personal_number,name,student_id,students.program_name,branch_name
		FROM students
		LEFT JOIN belongs_to
		ON students.personal_number=belongs_to.personal_number;
	
	CREATE VIEW FinishedCourses AS
		SELECT students.personal_number,courses.code,courses.name,courses.credit,course_completed.grade
		FROM students,courses,course_completed
		WHERE students.personal_number = course_completed.personal_number AND courses.code = course_completed.course_code;

	CREATE VIEW Registrations AS
			(SELECT students.personal_number,students.name,courses.code,'waiting' AS status
			FROM students,courses,waiting_for
			WHERE students.personal_number = waiting_for.personal_number AND courses.code = waiting_for.code)
		UNION
			(SELECT students.personal_number,students.name,courses.code,'registered' AS status
			FROM students,courses,is_registered_for
			WHERE students.personal_number = is_registered_for.personal_number AND courses.code = is_registered_for.course_code
			ORDER BY name,status);


	CREATE VIEW PassedCourses AS
		SELECT students.personal_number,students.name,courses.code,courses.name AS course_name,courses.credit,course_completed.grade
		FROM students,courses,course_completed
		WHERE students.personal_number = course_completed.personal_number AND
			courses.code = course_completed.course_code
			AND course_completed.grade <> 'U';

		
	CREATE VIEW UnreadMandatory AS
		--First retrieves all mandatory courses for a program but then also for branches. After that removes all courses that a student already completed (Where statement).
		SELECT DISTINCT * FROM (
			(
				--Get mandatory courses for program
				SELECT students.personal_number,students.name as student_name,courses.name,is_mandatory.course_code as mandatory
				FROM students,is_mandatory,courses
				WHERE students.program_name = is_mandatory.program 
					AND courses.code = is_mandatory.course_code
			)
			UNION
			(
				--Get mandatory courses for branch
				SELECT students.personal_number,students.name as student_name,courses.name,additional_mandatory.course_code as mandatory
				FROM students,additional_mandatory,courses
				WHERE students.program_name = additional_mandatory.program_name 
					AND courses.code = additional_mandatory.course_code 
					AND additional_mandatory.branch_name = 
					(SELECT belongs_to.branch_name FROM belongs_to WHERE students.personal_number = belongs_to.personal_number)
			)
		) AS resultTable WHERE NOT EXISTS (
					--Get courses which student has passed
					SELECT course_completed.personal_number
					FROM course_completed
					WHERE (course_completed.personal_number = resultTable.personal_number 
						AND resultTable.mandatory = course_completed.course_code
						AND grade <> 'U'
					)
		);

	CREATE VIEW PathToGraduation AS
	  WITH credits_in_seminar_courses AS 
		(SELECT personal_number, Count(credit) AS nbr_seminar_courses
				FROM PassedCourses
				JOIN has_classification
				ON PassedCourses.code = has_classification.code
				WHERE has_classification.name = 'Seminar'
				GROUP BY (personal_number)),
		credits_in_research AS		
		(SELECT personal_number, SUM(credit) AS credits_in_research
				FROM PassedCourses
				JOIN has_classification
				ON PassedCourses.code = has_classification.code
				WHERE has_classification.name = 'Research'
				GROUP BY (personal_number)),
		credits_in_math AS
		 (SELECT personal_number, SUM(credit) AS credits_in_math
				FROM PassedCourses
				JOIN has_classification
				ON PassedCourses.code = has_classification.code
				WHERE has_classification.name = 'Math'
				GROUP BY (personal_number)),
		unread_mandatory AS
			(SELECT personal_number, COUNT(mandatory) as mandatory_left
			FROM UnreadMandatory
			GROUP BY (personal_number)),
		completed_courses AS
			(SELECT personal_number, SUM(credit) AS total_credits
			FROM PassedCourses
			GROUP BY (personal_number))
	SELECT s.personal_number,s.name,s.program_name,credits_in_seminar_courses.nbr_seminar_courses,
	credits_in_research.credits_in_research,credits_in_math.credits_in_math,unread_mandatory.mandatory_left,completed_courses.total_credits,
	CASE 
		WHEN( 
			credits_in_math >= 20 AND
			credits_in_research >= 10 AND
			nbr_seminar_courses >= 1 AND 
			mandatory_left IS NULL
		) 
		THEN 'Yes'
		ELSE 'No'
	END AS qualified_for_graduation
	FROM students AS s
	LEFT JOIN unread_mandatory ON s.personal_number = unread_mandatory.personal_number
	LEFT JOIN credits_in_math ON s.personal_number = credits_in_math.personal_number
	LEFT JOIN credits_in_research ON s.personal_number =  credits_in_research.personal_number
	LEFT JOIN credits_in_seminar_courses ON s.personal_number =  credits_in_seminar_courses.personal_number
	LEFT JOIN completed_courses ON s.personal_number = completed_courses.personal_number;
	
	CREATE VIEW CourseQueuePositions AS
		SELECT personal_number,code,since_date,ROW_NUMBER() OVER (PARTITION BY code ORDER BY since_date) AS position
		FROM waiting_for;

	
/*<------------------------------------VIEW END---------------------------------> */





/*<------------------------------------Triggers--------------------------------->  */


CREATE OR REPLACE FUNCTION register() RETURNS trigger AS $emp_stamp$

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
			RAISE EXCEPTION 'asdfghjkl';
			INSERT INTO is_registered_for VALUES (NEW.personal_number, NEW.code);
		END IF;
		RETURN NEW;
         END;
$emp_stamp$ LANGUAGE plpgsql;



CREATE TRIGGER register INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE register();


--Trigger two
CREATE OR REPLACE VIEW StudentsFirstInQueue AS
	SELECT cqp.code,cqp.personal_number,name 
	FROM CourseQueuePositions AS cqp
	JOIN students ON students.personal_number = cqp.personal_number
	WHERE cqp.position = '1'; 

CREATE OR REPLACE FUNCTION unregister() RETURNS trigger AS $emp_stamp$
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

			firstPersNum := (SELECT personal_number FROM StudentsFirstInQueue AS SFIQ WHERE OLD.code = SFIQ.code);
			firstPersName := (SELECT name FROM StudentsFirstInQueue AS SFIQ WHERE OLD.code = SFIQ.code);

		
			
			IF totWaitingStudents > 0 THEN
	
				-- Delete the first student from waiting list
				DELETE FROM waiting_for WHERE code = OLD.code AND personal_number = OLD.personal_number;

				-- Insert the old first in queue student into registrations
				INSERT INTO Registrations VALUES (firstPersNum, firstPersName, OLD.code,'registered');
			END IF;
		END IF;
		RETURN OLD;
         END;
$emp_stamp$ LANGUAGE plpgsql;



CREATE TRIGGER unregister INSTEAD OF DELETE ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE unregister();

    

/*
<--------------	TESTING--------->
*/

--SELECT * FROM StudentsFollowing;

--SELECT * FROM FinishedCourses;

--SELECT * FROM Registrations;

--SELECT * FROM PassedCourses;

--SELECT * FROM PathToGraduation;

--SELECT * FROM CourseQueuePositions;

--SELECT * FROM UnreadMandatory;



/*
<--------------END TESTING----->
*/

/*
<--------------	TRIGGERTESTING--------->
*/

--testing already completed course VERIFIED
--INSERT INTO registrations VALUES ('9411131230','Oscar Evertsson','DRU101','waiting');

--testing prerequisites VERIFIED
--INSERT INTO registrations VALUES ('9411131230','Oscar Evertsson','TDA545','waiting');

--testing already registered VERIFIED
--INSERT INTO registrations VALUES ('9411131230','Oscar Evertsson','EDA433','waiting');

--testing is waiting for  (or if full) (KLP368 max amount = 1) VERIFIED



INSERT INTO registrations VALUES ('9411131230','Oscar Evertsson','KLP368','waiting');
INSERT INTO registrations VALUES ('9206031111','Victor Olausson','KLP368','waiting');
--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368' AND iwf.personal_number = '9206031111'; --Victor should appear here
--INSERT INTO registrations VALUES ('9206031111','Victor Olausson','KLP368','waiting');


--testing unregister from course when registered, and when not
DELETE FROM registrations WHERE personal_number = '9411131230';

--testing so that first place in waiting_for gets registered when a student unregisters

--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368' AND iwf.personal_number = '9206031111'; --This table should now be empty


--testing so that first place in waiting_for does NOT get registered if student unregisters and course is overfull

/*
<--------------END TRIGGERTESTING----->
*/