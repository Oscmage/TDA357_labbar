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
	personal_number CHAR(10) CHECK (personal_number LIKE '%[0-9]%'), /* Personal number in format '94 11 13 1340' NOT '1994 11 13 1340' */
	name TEXT NOT NULL,
	student_id TEXT NOT NULL,
	program_name TEXT NOT NULL,
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
	FOREIGN KEY (name) REFERENCES classification (name),
	FOREIGN KEY (code) REFERENCES courses (code)
);

CREATE TABLE limited_course (
	code TEXT,
	max_amount INT CHECK (max_amount > 0),
	FOREIGN KEY (code) REFERENCES courses (code)
);

CREATE TABLE waiting_for (
	code TEXT,
	personal_number CHAR(10),
	since_date DATE,
	FOREIGN KEY (code) REFERENCES courses (code),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number)
);


CREATE TABLE course_completed (
	personal_number CHAR(10), /*CHECK (LIKE '%[0-9]%'),*/
	course_code CHAR(6),
	grade CHAR(1) /*CHECK ((grade >= 3 AND grade <=5) OR grade = ‘U’)*/,
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),
	FOREIGN KEY (course_code) REFERENCES courses (code)
);

CREATE TABLE is_registered_for (
	personal_number CHAR(10),
	course_code CHAR(6),
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),
	FOREIGN KEY (course_code) REFERENCES courses (code)
);

CREATE TABLE additional_mandatory (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) 
);

CREATE TABLE is_recommended (
	course_code CHAR(6),
	branch_name TEXT,
	program_name TEXT,
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (name, program_name) 
);

CREATE TABLE is_mandatory (
	course_code CHAR(6),
	program TEXT,
	FOREIGN KEY (course_code) REFERENCES courses (code),
	FOREIGN KEY (program) REFERENCES programs (name)
);

CREATE TABLE belongs_to ( 
	personal_number CHAR(10),
	branch_name TEXT,
	program_name TEXT,
	FOREIGN KEY (personal_number) REFERENCES students (personal_number),
	FOREIGN KEY (branch_name, program_name) REFERENCES branches (program_name, name)
);

CREATE TABLE host_programs (
	abbreviations TEXT,
	program_name TEXT,
	FOREIGN KEY (abbreviations) REFERENCES departments (name),
	FOREIGN KEY (program_name) REFERENCES programs (name)
);



