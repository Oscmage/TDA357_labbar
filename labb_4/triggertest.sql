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



--testing already completed course VERIFIED
--INSERT INTO registrations VALUES ('9411131230','DRU101','waiting');

--testing prerequisites VERIFIED
--INSERT INTO registrations VALUES ('9411131230','TDA545','waiting');

--testing already registered VERIFIED
--INSERT INTO registrations VALUES ('9411131230','EDA433','waiting');

--testing is waiting for  (or if full) (KLP368 max amount = 1) VERIFIED



--INSERT INTO registrations VALUES ('9411131230','KLP368','waiting');
--INSERT INTO registrations VALUES ('9206031111','KLP368','waiting');
--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368' AND iwf.personal_number = '9206031111'; --Victor should appear here
--SELECT * FROM is_registered_for AS irf WHERE irf.course_code = 'KLP368' AND irf.personal_number = '9411131230'; --Oscar should appear here
--INSERT INTO registrations VALUES ('9311131230','KLP368','waiting');

--testing unregister from course when registered, and when notDELETE FROM registrations WHERE personal_number = '9411131230' AND code = 'KLP368'; --Deletes Oscar. If this row is active, Oscar should not appear in registered
--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368'; --Victor should NOT appear here

--testing so that first place in waiting_for gets registered when a student unregisters
--SELECT * FROM is_registered_for AS irf WHERE irf.course_code = 'KLP368'; --Victor should appear here


--SELECT * FROM waiting_for AS iwf WHERE iwf.code = 'KLP368' AND iwf.personal_number = '9206031111'; --This table should now be empty


--testing so that first place in waiting_for does NOT get registered if student unregisters and course is overfull
