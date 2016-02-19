
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
	INSERT INTO is_prerequisite VALUES ('DRU101','DRU102');
	INSERT INTO is_prerequisite VALUES ('DRU103','DRU102');

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
	INSERT INTO is_registered_for VALUES ('9411131230', 'TDA357');
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