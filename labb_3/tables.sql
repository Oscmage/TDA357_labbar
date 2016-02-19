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