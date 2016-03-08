/*

	###################
	#IMPORTANT COMMENT#
	###################

	If you run the tests all at once you'll receieve an error due to the fact we're using timestamp.
	This is since the insert is done at the exact same time. 
	Getting this error in the real world would not be likely but, since it could happen it's a flaw
	in our design from the begining. 
	We consider this database to be on a small scale and find it resonable to keep it this way
	even though it could cause possible errors.
	If we would redesign our database this is something we would change. 
*/

/*
	###################
	#RESET FOR TESTING#
	###################
*/

DELETE FROM is_registered_for WHERE (personal_number = '9411131230' AND course_code = 'ANP395') OR (personal_number = '9411131230' AND course_code = 'KLP368');
DELETE FROM is_registered_for WHERE course_code = 'ANP395' OR course_code = 'KLP368';
DELETE FROM courses WHERE code = 'RTV242';

DELETE FROM waiting_for WHERE (personal_number = '9411131230' AND code = 'ANP395') OR (personal_number = '9411131230' AND code = 'KLP368');
DELETE FROM waiting_for WHERE code = 'ANP395' OR code = 'KLP368';

/*
	###############
	#Register test#
	###############
*/

--testing already completed course, should give exception
INSERT INTO registrations VALUES ('9411131230','DRU101','waiting');

--testing prerequisites, should give exception
INSERT INTO registrations VALUES ('9411131230','TDA545','waiting');

--testing already registered, should give exception
INSERT INTO registrations VALUES ('9411131230','EDA433','waiting');

--Test adding student to a none limited_course, should be no problem.
INSERT INTO registrations VALUES ('9411131230','ANP395','waiting');
--SELECT * FROM registrations WHERE personal_number = '9411131230' AND code = 'ANP395';

--Test adding same student twice, should give error that student already exists. 
INSERT INTO registrations VALUES ('9411131230','ANP395','waiting');
INSERT INTO registrations VALUES ('9411131230','ANP395','waiting');

--Testing is waiting for  (or if full) (KLP368 max amount = 1) */

INSERT INTO registrations VALUES ('9411131230','KLP368','waiting');
INSERT INTO registrations VALUES ('9206031111','KLP368','waiting'); 	

--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368' AND iwf.personal_number = '9206031111'; --Victor should appear here
--SELECT * FROM is_registered_for AS irf WHERE irf.course_code = 'KLP368' AND irf.personal_number = '9411131230'; --Oscar should appear here
INSERT INTO registrations VALUES ('9311131230','KLP368','waiting');


/*

	#################
	#Unregister test#
	#################
	
	Since we've come so far in testing the register, we here assume it's correct.
*/


--Testing if the deletes works.	

INSERT INTO registrations VALUES ('9411131230','KLP368','waiting');
DELETE FROM registrations WHERE personal_number = '9411131230' AND code = 'KLP368';
--SELECT * FROM registrations AS iwf WHERE iwf.code = 'KLP368'; --9411131230 should not be found within the table.



-- Inserting some students to wait for a course with a maxAmount 1. 

INSERT INTO courses VALUES ('RTV242', 'FX Hedging', 9.5, 'MA');
INSERT INTO limited_course VALUES ('RTV242','1');

INSERT INTO is_registered_for VALUES ('9411131230', 'RTV242');

INSERT INTO waiting_for VALUES ('RTV242', '9206031111', '1992-02-04');
INSERT INTO waiting_for VALUES ('RTV242', '9311131230', '1993-06-05');

DELETE FROM registrations WHERE personal_number = '9411131230' AND code = 'RTV242';

--Now 9206031111 should be the registered student
SELECT * FROM registrations WHERE code = 'RTV242';



