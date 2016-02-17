
DROP VIEW IF EXISTS
StudentsFollowing,FinishedCourses, Registrations, 
PassedCourses, UnreadMandatory, PathToGraduation;

DROP TABLE IF EXISTS
departments,programs,branches,classification,courses,
students,is_prerequisite,has_classification,limited_course,
waiting_for,course_completed,is_registered_for,
additional_mandatory,belongs_to,
is_recommended,
is_mandatory,
host_programs;

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
	FOREIGN KEY (program_name) REFERENCES programs (name)
);

CREATE TABLE classification (
	name TEXT,
	PRIMARY KEY (name)
);

CREATE TABLE courses (
	code TEXT ,
	name TEXT NOT NULL,
	credit FLOAT NOT NULL,
	department TEXT NOT NULL,
	PRIMARY KEY (code),
	FOREIGN KEY (department) REFERENCES departments (abbreviation)
);

CREATE TABLE students (
	personal_number CHAR(10), /*CHECK (personal_number LIKE '%[0-9]%'), Personal number in format '94 11 13 1340' NOT '1994 11 13 1340' */
	name TEXT NOT NULL,
	student_id TEXT NOT NULL,
	program_name TEXT,
	unique (personal_number, program_name),
	PRIMARY KEY (personal_number),
	FOREIGN KEY (program_name) REFERENCES programs (name)
);

CREATE TABLE is_prerequisite (
	code TEXT,
	prerequisite TEXT,
	PRIMARY KEY (code,prerequisite),
	FOREIGN KEY (code) REFERENCES courses (code),
	FOREIGN KEY (prerequisite)  REFERENCES courses (code)
);

CREATE TABLE has_classification (
	name TEXT,
	code TEXT,
	PRIMARY KEY (name,code),
	FOREIGN KEY (name) REFERENCES classification (name),
	FOREIGN KEY (code) REFERENCES courses (code)
);

CREATE TABLE limited_course (
	code TEXT,
	max_amount INT CHECK (max_amount > 0) NOT NULL,
	PRIMARY KEY (code),
	FOREIGN KEY (code) REFERENCES courses (code)
);

CREATE TABLE waiting_for (
	code TEXT,
	personal_number CHAR(10),
	since_date DATE NOT NULL,
	unique (code, since_date),
	PRIMARY KEY (code,personal_number),
	FOREIGN KEY (code) REFERENCES courses (code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number)
);


CREATE TABLE course_completed (
	personal_number CHAR(10),
	course_code CHAR(6),
	grade CHAR(1) CHECK (grade IN ('3','4','5','U')) NOT NULL,
	PRIMARY KEY (personal_number,course_code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),
	FOREIGN KEY (course_code) REFERENCES courses (code)
);

CREATE TABLE is_registered_for (
	personal_number CHAR(10),
	course_code CHAR(6),
	PRIMARY KEY (personal_number,course_code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),
	FOREIGN KEY (course_code) REFERENCES courses (code)
);

CREATE TABLE additional_mandatory (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	PRIMARY KEY (course_code,branch_name,program_name),
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) 
);

CREATE TABLE is_recommended (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	PRIMARY KEY (course_code,branch_name,program_name),
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) 
);

CREATE TABLE is_mandatory (
	course_code CHAR(6),
	program TEXT,
	PRIMARY KEY (course_code,program),
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (program) REFERENCES programs (name)
);

CREATE TABLE belongs_to ( 
	personal_number CHAR(10),
	branch_name TEXT NOT NULL,
	program_name TEXT NOT NULL,
	PRIMARY KEY (personal_number),
	FOREIGN KEY (personal_number,program_name) REFERENCES students (personal_number,program_name),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name,program_name)
);

CREATE TABLE host_programs (
	abbreviations TEXT,
	program_name TEXT,
	PRIMARY KEY (abbreviations,program_name),
	FOREIGN KEY (abbreviations) REFERENCES departments (abbreviation),
	FOREIGN KEY (program_name) REFERENCES programs (name)
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

/*
	Duplicate
	INSERT INTO courses VALUES ('TDA357', 'Databaser', '7.5', 'CS'); 

	error: credit is not a number, and dept does not exist
	INSERT INTO courses VALUES ('DAT206', 'Advanced Computer Graphics', 'Blargh', 'CF'); error: char credit + non-existing dept.
*/

	/*Prereqs*/
	INSERT INTO is_prerequisite VALUES ('DRU102','DRU101');
	INSERT INTO is_prerequisite VALUES ('DRU103','DRU102');

	/*Course classification*/
	INSERT INTO has_classification VALUES ('Physics','DRU101');
	INSERT INTO has_classification VALUES ('Math','DRU101');
	INSERT INTO has_classification VALUES ('Seminar','DAT205');

	/*Limited course*/
	INSERT INTO limited_course VALUES ('TDA357','1');
	INSERT INTO limited_course VALUES ('DAT205','1');

	/*Students*/
	INSERT INTO students VALUES ('9411131230','Oscar Evertsson', 'oscarev', 'Informationsteknik');
	INSERT INTO students VALUES ('9206031111','Victor Olausson', 'vicola', 'Datateknik');
	INSERT INTO students VALUES ('9311131230','Lars Larssson', 'larsla', 'Informationsteknik');
	INSERT INTO students VALUES ('9211131230','Bruce Springsteen', 'bruces', 'Informationsteknik');
	INSERT INTO students VALUES ('9111131230','Sven Svensson', 'svensv', 'Industriell Ekonomi');
	INSERT INTO students VALUES ('8811131230','Bon jovi', 'bonj', 'Flipperteknik');
/*
	INSERT INTO students VALUES ('9206031111','Victor Olausson', 'vicola', 'Datateknik'); check pers_no & cid. borde inte finnas 2.
	INSERT INTO students VALUES ('90111312301','Bertil Åkesson', 'bertåk', 'Maskinteknik'); pers_no too long
	
*/
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
	INSERT INTO waiting_for VALUES ('TDA357','9311131230', '1992-06-04');
	INSERT INTO waiting_for VALUES ('TDA357','9211131230', '1992-06-05');
	
	INSERT INTO waiting_for VALUES ('DAT205','9206031111', '1992-06-03');
	INSERT INTO waiting_for VALUES ('DAT205','9311131230', '1992-06-04');
	INSERT INTO waiting_for VALUES ('DAT205','9211131230', '1992-06-05');

	/*Course completed*/
	INSERT INTO course_completed VALUES ('9206031111','DRU101','5');
	INSERT INTO course_completed VALUES ('9206031111','DRU102','U');
	
	/* This student has completed the req for mandatory and additional mandatory */
	INSERT INTO course_completed VALUES ('9411131230','TDA357','5');
	INSERT INTO course_completed VALUES ('9411131230','DAT205','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU101','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU102','4');
	INSERT INTO course_completed VALUES ('9411131230','DRU103','3');

	/*Registered for*/
	INSERT INTO is_registered_for VALUES ('9206031111', 'DRU102');
	INSERT INTO is_registered_for VALUES ('9411131230', 'TDA416');
	INSERT INTO is_registered_for VALUES ('9411131230', 'EDA433');
	INSERT INTO is_registered_for VALUES ('9311131230', 'DRU102');
	INSERT INTO is_registered_for VALUES ('9211131230', 'MVE045');
	INSERT INTO is_registered_for VALUES ('9111131230', 'DAT216');

/*
	INSERT INTO is_registered_for VALUES ('9411131230', 'DRU101'); SHOULD return error: student already completed course
*/
	
	/*Additional Mandatory*/
	INSERT INTO additional_mandatory VALUES ('DRU101','Software Engineering','Informationsteknik');
	INSERT INTO additional_mandatory VALUES ('DRU102','Software Engineering','Informationsteknik');
	INSERT INTO additional_mandatory VALUES ('DRU103','Algorithms','Datateknik');

	/*Recommended*/
	INSERT INTO is_recommended VALUES ('DAT205','Software Engineering','Informationsteknik');
	
	/*BelongsTo*/
	
	INSERT INTO belongs_to VALUES ('9411131230','Software Engineering','Informationsteknik');
	INSERT INTO belongs_to VALUES ('9206031111','Algorithms','Datateknik');
/*<------------------------------------INSERTION END--------------------------------->*/

/*<------------------------------------VIEW START--------------------------------->*/

	CREATE VIEW StudentsFollowing AS
		SELECT  students.personal_number,name,student_id,students.program_name,branch_name
		FROM students
		LEFT JOIN belongs_to
		ON students.personal_number=belongs_to.personal_number;
	/*
	SELECT * FROM StudentsFollowing;
	*/
	
	CREATE VIEW FinishedCourses AS
		SELECT students.personal_number, students.name AS student_name, courses.code,courses.name AS course_name, courses.credit,course_completed.grade
		FROM students,courses,course_completed
		WHERE students.personal_number = course_completed.personal_number AND courses.code = course_completed.course_code;
/*		
	SELECT * FROM FinishedCourses;
*/
	CREATE VIEW Registrations AS
		SELECT students.personal_number, students.name AS student_name, courses.code, courses.name AS course_name, 'registered' as status
		FROM students, courses, is_registered_for
		WHERE (students.personal_number = is_registered_for.personal_number AND courses.code = is_registered_for.course_code) 
		UNION
		SELECT students.personal_number, students.name AS student_name, courses.code, courses.name AS course_name, 'waiting' as status
		FROM students, courses, waiting_for
		WHERE students.personal_number = waiting_for.personal_number AND courses.code = waiting_for.code
		ORDER BY student_name, status;
/*		
	SELECT * FROM Registrations;
*/
	CREATE VIEW PassedCourses AS
		SELECT students.personal_number, students.name AS student_name, courses.code,courses.name AS course_name, courses.credit,course_completed.grade
		FROM students,courses,course_completed
		WHERE students.personal_number = course_completed.personal_number 
			AND courses.code = course_completed.course_code 
			AND course_completed.grade <> 'U' ;
/*
	SELECT * FROM PassedCourses;
*/

	CREATE VIEW UnreadMandatory AS
		/*SELECT students.program_name AS program_name, students.name AS student_name, is_mandatory.course_code AS mand
		FROM students, is_mandatory
		WHERE students.program_name = is_mandatory.program;
		UNION*/
		SELECT course_completed.personal_number, additional_mandatory.course_code, additional_mandatory.branch_name
		FROM additional_mandatory, course_completed, belongs_to
		WHERE additional_mandatory.course_code <> course_completed.course_code
			AND additional_mandatory.branch_name = belongs_to.branch_name;

	SELECT * FROM UnreadMandatory;

/*<------------------------------------VIEW END--------------------------------->*/