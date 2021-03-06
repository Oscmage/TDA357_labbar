﻿DROP VIEW IF EXISTS
StudentsFollowing,FinishedCourses,Registrations,PassedCourses,
UnreadMandatory,PathToGraduation, CourseQueuePosition,registered_students_for_limited_course CASCADE;


/*<------------------------------------VIEW START--------------------------------->*/

	CREATE VIEW StudentsFollowing AS
		SELECT  students.personal_number,name,student_id,students.program_name,branch_name
		FROM students
		LEFT JOIN belongs_to
		ON students.personal_number=belongs_to.personal_number;
	
	CREATE VIEW FinishedCourses AS
		SELECT students.personal_number,courses.code,courses.name,courses.credit,course_completed.grade
		FROM students 
		NATURAL JOIN course_completed
		INNER JOIN courses ON courses.code = course_completed.course_code;
	
	
	CREATE VIEW Registrations AS
			(SELECT students.personal_number,courses.code,'waiting' AS status
			FROM students,courses,waiting_for
			WHERE students.personal_number = waiting_for.personal_number AND courses.code = waiting_for.code)
		UNION
			(SELECT students.personal_number, courses.code,'registered' AS status
			FROM students,courses,is_registered_for
			WHERE students.personal_number = is_registered_for.personal_number AND courses.code = is_registered_for.course_code
			ORDER BY status);


	CREATE VIEW PassedCourses AS
		SELECT *
		FROM FinishedCourses
		WHERE grade <> 'U';

		
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
					SELECT *
					FROM PassedCourses AS PS
					WHERE (resultTable.personal_number = PS.personal_number 
						AND resultTable.mandatory = PS.code)
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
			GROUP BY (personal_number)),
		credits_in_recommended AS
			(SELECT personal_number, SUM(PC.credit) AS total_credits_rec
			FROM is_recommended AS isr
			INNER JOIN PassedCourses AS PC ON isr.course_code = PC.code
			GROUP BY (personal_number)),
		belongs_to_branch AS
			(SELECT personal_number, COUNT(branch_name) AS belongs_to_branch
			FROM StudentsFollowing
			GROUP BY (personal_number))
	SELECT s.personal_number,s.name,s.program_name,credits_in_seminar_courses.nbr_seminar_courses,
	unread_mandatory.mandatory_left, completed_courses.total_credits,
	credits_in_research.credits_in_research, belongs_to_branch.belongs_to_branch, credits_in_math.credits_in_math,
	CASE 
		WHEN( 
			credits_in_math >= 20 AND
			credits_in_research >= 10 AND
			nbr_seminar_courses >= 1 AND 
			total_credits_rec >= 10 AND
			belongs_to_branch >= 1 AND
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
	LEFT JOIN completed_courses ON s.personal_number = completed_courses.personal_number
	LEFT JOIN credits_in_recommended AS CIR ON s.personal_number = CIR.personal_number
	LEFT JOIN belongs_to_branch ON s.personal_number = belongs_to_branch.personal_number;
