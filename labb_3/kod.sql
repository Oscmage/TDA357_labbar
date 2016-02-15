DROP TABLE IF EXISTS 
departments,programs,branches,classification,courses,
students,is_prerequisite,has_classification,limited_course,
waiting_for,course_completed,is_registered_for,
additional_mandatory,belongs_to,
is_recommended,
is_mandatory,
host_programs;

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



/*<------------------------------------INSERTION START--------------------------------->*/



	/*DEPTS*/
	INSERT INTO departments VALUES ('CS', 'Computer Science');
	INSERT INTO departments VALUES ('CE', 'Computer Engineering');
	INSERT INTO departments VALUES ('KAPPA', 'Serious Society');

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

	/*Branches*/
	INSERT INTO branches VALUES ('Software Engineering','Informationsteknik');
	INSERT INTO branches VALUES ('Computer Science & Algorithms','Datateknik');
	
	/*Courses*/
	INSERT INTO courses VALUES ('TDA357', 'Databaser', '7.5', 'CS');
	INSERT INTO courses VALUES ('DAT205', 'Advanced Computer Graphics', '15.0', 'CE');
	INSERT INTO courses VALUES ('DRU101', 'Pinball Theory', '7.5', 'CS');
	INSERT INTO courses VALUES ('DRU102', 'Advanced Pinball Physics', '7.5', 'CS');
	INSERT INTO courses VALUES ('DRU103', 'Quantum Pinball Theory', '15.0', 'KAPPA');

	/*Prereqs*/
	INSERT INTO is_prerequisite VALUES ('DRU102','DRU101');
	INSERT INTO is_prerequisite VALUES ('DRU103','DRU102');

	/*Course classification*/
	INSERT INTO has_classification VALUES ('Physics','DRU101');
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
	INSERT INTO students VALUES ('9011131230','Bertil Åkesson', 'bertåk', 'Maskinteknik');
	INSERT INTO students VALUES ('8911131230','Johan Eklund', 'johanek', 'Datateknik');
	INSERT INTO students VALUES ('8811131230','Bon jovi', 'bonj', 'Flipperteknik');

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
	/* This student have completed the req for mandatory and additional mandatory */
	INSERT INTO course_completed VALUES ('9411131230','TDA357','5');
	INSERT INTO course_completed VALUES ('9411131230','DAT205','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU101','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU102','5');
	INSERT INTO course_completed VALUES ('9411131230','DRU103','5');

	/*Registered for*/
	INSERT INTO is_registered_for VALUES ('9206031111', 'DRU102');

	/*Additional Mandatory*/
	INSERT INTO additional_mandatory VALUES ('DRU101','Software Engineering','Informationsteknik');
	INSERT INTO additional_mandatory VALUES ('DRU102','Software Engineering','Informationsteknik');

	/*Recommended*/
	INSERT INTO is_recommended VALUES ('DAT205','Software Engineering','Informationsteknik');
	
	/*BelongsTo*/
	INSERT INTO belongs_to VALUES ('9411131230','Software Engineering','Informationsteknik');
	