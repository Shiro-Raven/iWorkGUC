-------------------------------
-- USE Database iWork_team54_v1
-------------------------------
USE iWork_team54_v1
GO
-------------------------------
-------------------------------


---------------------------------------------
-- QUERY TO MAKE DATABASE RUN COMPLEX QUERIES
---------------------------------------------
EXEC sp_updatestats
GO
---------------------------------------------
---------------------------------------------


-----------------------------------------------------------------------------------------------------
-- view_all_companies Procedure: Used For Getting All The Companies To Store Them In The DropDownList
-----------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_all_companies
@output_message INT OUTPUT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM dbo.Company_Profiles)
			SET @output_message = 1
		ELSE
			BEGIN
				SELECT *
					FROM dbo.Company_Profiles
				SET @output_message = 2
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
-- view_certain_Company_Department Procedure: Used For Retrieving All Departments Of A Certain Company
------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_certain_Company_Department
@domain_name VARCHAR(120), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @domain_name = ''
			SET @output_message = 1
		ELSE IF @domain_name = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @domain_name = CP.domain_name)
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT CP.*, D.*, D.name AS 'dep_name'
					FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
					WHERE @domain_name = CP.domain_name
				SET @output_message = 4
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


-----------------------------------------------------------
-- iwork_login Procedure: Used For Logging Into The Website
-----------------------------------------------------------
CREATE OR ALTER PROC iwork_login
@username VARCHAR(100), @password VARCHAR(200), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @password = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @password = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Users WHERE @username = username AND @password = password)
			SET @output_message = 3
		ELSE IF EXISTS (SELECT * FROM dbo.Job_Seekers WHERE @username = username)
			SET @output_message = 4
		ELSE IF EXISTS (SELECT * FROM dbo.Managers WHERE @username = username)
			SET @output_message = 5
		ELSE IF EXISTS (SELECT * FROM dbo.Hr_Employees WHERE @username = username)
			SET @output_message = 6
		ELSE IF EXISTS (SELECT * FROM dbo.Regular_Employees WHERE @username = username)
			SET @output_message = 7
		ELSE IF EXISTS (SELECT * FROM dbo.Staff_Members WHERE @username = username)
			SET @output_message = 8
		ELSE
			SET @output_message = 9
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-----------------------------------------------------------
-----------------------------------------------------------


-----------------------------------------------------
-- register_User Procedure: Used For Registering User
-----------------------------------------------------
CREATE OR ALTER PROC register_User
@username VARCHAR(100), @password VARCHAR(200), @first_name VARCHAR(60), @middle_name VARCHAR(60), @last_name VARCHAR(60), @birthdate DATETIME, @email VARCHAR(120), @years_of_experience INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @password = '' OR @first_name = '' OR @middle_name = '' OR @last_name = '' OR @birthdate = '' OR @email = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @password = NULL OR @first_name = NULL OR @middle_name = NULL OR @last_name = NULL OR @birthdate = NULL OR @email = NULL OR @years_of_experience = NULL
			SET @output_message = 2
		ELSE IF EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF EXISTS (SELECT * FROM Users U WHERE @email = U.email)
			SET @output_message = 4
		ELSE IF LEN(@password) < 8
			SET @output_message = 5
		ELSE IF DATEDIFF(YEAR, @birthdate, GETDATE()) < 18
			SET @output_message = 6
		ELSE IF @years_of_experience < 0
			SET @output_message = 7
		ELSE
			BEGIN
				INSERT INTO Users
					VALUES (@username, @password, @first_name, @middle_name, @last_name, @birthdate, @email, @years_of_experience)
				INSERT INTO Job_Seekers
					VALUES (@username)
				SET @output_message = 8
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-----------------------------------------------------
-----------------------------------------------------

---------------------------------------------------------------------------------
-- search_for_Company_by_Name Procedure: Used For Searching For A Company By Name
---------------------------------------------------------------------------------
CREATE OR ALTER PROC search_for_Company_by_Name
@name VARCHAR(120), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @name = ''
			SET @output_message = 1
		ELSE IF @name = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE CP.name LIKE '%' + @name + '%')
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT *
					FROM Company_Profiles CP
					WHERE CP.name LIKE '%' + @name + '%'
				SET @output_message = 4
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
-- search_for_Company_by_Address Procedure: Used For Searching For A Company By Address
---------------------------------------------------------------------------------------
CREATE OR ALTER PROC search_for_Company_by_Address
@address VARCHAR(200), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @address = ''
			SET @output_message = 1
		ELSE IF @address = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE CP.address LIKE '%' + @address + '%')
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT *
					FROM Company_Profiles CP
					WHERE CP.address LIKE '%' + @address + '%'
				SET @output_message = 4
			end
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- search_for_Company_by_Type Procedure: Used For Searching For A Company By Type
---------------------------------------------------------------------------------
CREATE OR ALTER PROC search_for_Company_by_Type
@type VARCHAR(120), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @type = ''
			SET @output_message = 1
		ELSE IF @type = NULL
			SET @output_message = 2
		ELSE IF @type <> 'national' AND @type <> 'international'
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT *
					FROM Company_Profiles CP
					WHERE @type = CP.type
				SET @output_message = 4
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- view_Phone_Numbers Procedure: Used For Viewing All Companies Phone Numbers
-----------------------------------------------------------------------------
CREATE OR ALTER PROC view_Phone_Numbers
@company_domain VARCHAR(120), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @company_domain = ''
			SET @output_message = 1
		ELSE IF @company_domain = NULL
			SET @output_message = 2
		ELSE
			BEGIN
				SELECT *
					FROM dbo.Company_Profiles_have_Phone_Numbers CPP
					WHERE @company_domain = CPP.domain_name
				SET @output_message = 3
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------
-- view_certain_Company_Department_Job Procedure: Used For Viewing Information About Certain Department Along With The Available Jobs In It
-------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_certain_Company_Department_Job
@company_domain VARCHAR(120), @dep_code VARCHAR(120), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @company_domain = '' OR @dep_code = ''
			SET @output_message = 1
		ELSE IF @company_domain = NULL OR @dep_code = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @company_domain = CP.domain_name)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Departments D WHERE @dep_code = D.code)
			SET @output_message = 4
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name)
			SET @output_message = 5
		ELSE IF NOT EXISTS (
					SELECT CP.*, D.*, J.*, D.name AS 'dep_name'
						FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
												INNER JOIN Jobs J ON D.code = J.dep_code
						WHERE @company_domain = CP.domain_name
							AND @dep_code = D.code
							AND J.number_of_vacancies > 0
					)
			SET @output_message = 6
		ELSE
			BEGIN
				SELECT CP.*, D.*, J.*, D.name AS 'dep_name'
					FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
											INNER JOIN Jobs J ON D.code = J.dep_code
					WHERE @company_domain = CP.domain_name
						AND @dep_code = D.code
						AND J.number_of_vacancies > 0
				SET @output_message = 7
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
-- search_for_Job_with_Vacancies_by_Keyword Procedure: Used For Searching For A Job With Vacancies
--------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC search_for_Job_with_Vacancies_by_Keyword
@keyword VARCHAR(1500), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @keyword = ''
			SET @output_message = 1
		ELSE IF @keyword = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (
					SELECT J.*, CP.name, D.name AS 'dep_name'
						FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
													INNER JOIN Jobs J ON D.code = J.dep_code
						WHERE J.number_of_vacancies > 0
							AND (J.short_description LIKE '%' + @keyword + '%'
								OR J.detailed_description LIKE '%' + @keyword + '%')
					)
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT J.*, CP.name, D.name AS 'dep_name'
					FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
												INNER JOIN Jobs J ON D.code = J.dep_code
					WHERE J.number_of_vacancies > 0
						AND (J.short_description LIKE '%' + @keyword + '%'
							OR J.detailed_description LIKE '%' + @keyword + '%')
				SET @output_message = 4
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
--view_Company_by_highest_Average_Salary Procedure: Used For Viewing Companies With Highest Average Salary
----------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_Company_by_highest_Average_Salary
@output_message INT OUTPUT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM Company_Profiles CP)
			SET @output_message = 1
		ELSE
			BEGIN
				SELECT CP.name, AVG(J.salary) AS 'AVG'
					FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
												INNER JOIN Jobs J ON D.code = J.dep_code
					GROUP BY CP.name
					ORDER BY AVG(J.salary) DESC
				SET @output_message = 2
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------


-------------------------------------------------------
-- get_staff_type Procedure: Used For Getting User Type
-------------------------------------------------------
CREATE OR ALTER PROC get_staff_type
@username VARCHAR(100), @type INT OUTPUT 
AS
	BEGIN
		IF EXISTS (SELECT * FROM dbo.Job_Seekers WHERE username = @username)
			SET @type = 5
		ELSE IF EXISTS (SELECT * FROM dbo.Managers WHERE username = @username)
			SET @type = 4
		ELSE IF EXISTS (SELECT * FROM dbo.Hr_Employees WHERE username = @username)
			SET @type = 3
		ELSE IF EXISTS (SELECT * FROM dbo.Regular_Employees WHERE username = @username)
			SET @type = 2
		ELSE IF EXISTS (SELECT * FROM dbo.Staff_Members WHERE username = @username)
			SET @type = 1
		ELSE
			SET @type = 0
	END
GO
-------------------------------------------------------
-------------------------------------------------------


--------------------------------------------------------------------------------------------------------
-- get_User_info Procedure: Used For Retrieving ALl Information About A Certain User From The Users Table
--------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC get_User_info
@username VARCHAR(100), @password VARCHAR(200) OUTPUT, @first_name VARCHAR(60) OUTPUT, @middle_name VARCHAR(60) OUTPUT, @last_name VARCHAR(60) OUTPUT, @birth_date DATETIME OUTPUT, @age INT OUTPUT, @email VARCHAR(120) OUTPUT, @years_of_experience INT OUTPUT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = ''
			SET @output_message = 1
		ELSE IF @username = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Users WHERE @username = username)
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT @password = U.password, @first_name = U.first_name, @middle_name = U.middle_name, @last_name = U.last_name, @birth_date = U.birth_date, @age = U.age, @email = U.email, @years_of_experience = U.years_of_experience
					FROM dbo.Users U
					WHERE @username = U.username
				SET @output_message = 5
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0;
	END CATCH
GO
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------


------------------------------------------------------------------
-- update_User_info Procedcure: Used For Updating user Information
------------------------------------------------------------------
CREATE OR ALTER PROC update_User_info
@username VARCHAR(100), @password VARCHAR(200), @first_name VARCHAR(60), @middle_name VARCHAR(60), @last_name VARCHAR(60), @birthdate DATETIME, @email VARCHAR(120), @years_of_experience INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @password = '' OR @first_name = '' OR @middle_name = '' OR @last_name = '' OR @birthdate = '' OR @email = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @password = NULL OR @first_name = NULL OR @middle_name = NULL OR @last_name = NULL OR @birthdate = NULL OR @email = NULL OR @years_of_experience = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF EXISTS (SELECT * FROM Users U WHERE @email = U.email AND @username <> U.username)
			SET @output_message = 4
		ELSE IF LEN(@password) < 8
			SET @output_message = 5
		ELSE IF DATEDIFF(YEAR, @birthdate, GETDATE()) < 18
			SET @output_message = 6
		ELSE IF @years_of_experience < 0
			SET @output_message = 7
		ELSE
			BEGIN
				UPDATE dbo.Users
					SET password = @password, first_name = @first_name, middle_name = @middle_name, last_name = @last_name, birth_date = @birthdate, email = @email, years_of_experience = @years_of_experience
					WHERE @username = username
				SET @output_message = 8
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------
------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- view_all_Jobs_with_Vacancies Procedure: Used For Retrieving All Available Jobs In The Database
-------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_all_Jobs_with_Vacancies
@output_message INT OUTPUT
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM dbo.Jobs WHERE number_of_vacancies > 0)
			SET @output_message = 1
		ELSE
			BEGIN
				SELECT *, D.name AS 'dep_name'
					FROM dbo.Company_Profiles CP INNER JOIN dbo.Departments D ON CP.domain_name = D.company_domain_name
													INNER JOIN dbo.Jobs J ON D.code = J.dep_code
					WHERE J.number_of_vacancies > 0
					ORDER BY CP.name, D.name, J.job_id
				SET @output_message = 2
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------


------------------------------------------------------------------------
-- view_Certain_Job Procedure: Used To View Certain Job Given Its Job ID
------------------------------------------------------------------------
CREATE OR ALTER PROC view_Certain_Job
@job_id INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @job_id = ''
			SET @output_message = 1
		ELSE IF @job_id = NULL
			SET @output_message = 2
		IF NOT EXISTS (SELECT * FROM dbo.Jobs WHERE @job_id = job_id)
			SET @output_message = 3
		ELSE
			BEGIN
				SELECT *, D.name AS 'dep_name'
					FROM dbo.Company_Profiles CP INNER JOIN dbo.Departments D ON CP.domain_name = D.company_domain_name
													INNER JOIN dbo.Jobs J ON D.code = J.dep_code
					WHERE @job_id = J.job_id
					ORDER BY CP.name, D.name, J.job_id
				SET @output_message = 4
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------
------------------------------------------------------------------------


--------------------------------------------------------
-- apply_for_Job Procedure: Used For Applying For A Job
--------------------------------------------------------
CREATE OR ALTER PROC apply_for_Job
@username VARCHAR(100), @job_id INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @job_id = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @job_id = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			SET @output_message = 4
		ELSE IF EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id AND A.status = 'pending')
			SET @output_message = 5
		ELSE
			BEGIN
				DECLARE @years_of_experience INT, @minimum_years_of_experience INT
				SELECT @years_of_experience = U.years_of_experience
					FROM Users U
					WHERE @username = U.username
				SELECT @minimum_years_of_experience = J.minimum_years_of_experience
					FROM Jobs J
					WHERE @job_id = J.job_id
				IF @minimum_years_of_experience > @years_of_experience
					SET @output_message = 6
				ELSE
					BEGIN
						DELETE FROM Applications
							WHERE @username = seeker_username AND @job_id = job_id
						INSERT INTO Applications (seeker_username, job_id, status)
							VALUES (@username, @job_id, 'pending')
						SET @output_message = 7
					END
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------------------------------------------
-- view_Status_of_all_Applications Procedure: Used For Viewing All Job Seeker's Applcaitions
--------------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_Status_of_all_Applications
@username VARCHAR(100), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = ''
			SET @output_message = 1
		ELSE IF @username = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username)
			SET @output_message = 4
		ELSE
			BEGIN
				SELECT *, D.name AS 'dep_name'
					FROM dbo.Company_Profiles CP INNER JOIN dbo.Departments D ON CP.domain_name = D.company_domain_name
													INNER JOIN dbo.Jobs J ON D.code = J.dep_code
													INNER JOIN dbo.Applications A ON J.job_id = A.job_id
					WHERE @username = A.seeker_username
					ORDER BY CP.name, D.name, J.job_id
				SET @output_message = 5
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


------------------------------------------------------------------------
-- delete_Job_Application Procedure: Used For Deleting Job's Application
------------------------------------------------------------------------
CREATE OR ALTER PROC delete_Application
@username VARCHAR(100), @job_id INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @job_id = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @job_id = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Users WHERE @username = username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Jobs WHERE @job_id = job_id)
			SET @output_message = 4
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Applications WHERE @username = seeker_username AND @job_id = job_id)
			SET @output_message = 5
		ELSE IF EXISTS (SELECT * FROM dbo.Applications WHERE @username = seeker_username AND @job_id = job_id AND status <> 'pending')
			SET @output_message = 6
		ELSE
			BEGIN
				DELETE FROM dbo.Applications
					WHERE @username = seeker_username
						AND @job_id = job_id
				SET @output_message = 7
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------
------------------------------------------------------------------------


------------------------------------------------
-- choose_Job Procedure: Used For Choosing A Job
------------------------------------------------
CREATE OR ALTER PROC choose_Job
@username VARCHAR(100), @job_id INT, @day_off VARCHAR(9), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @job_id = '' OR @day_off = '' 
			SET @output_message = 1
		ELSE IF @username = NULL OR @job_id = NULL OR @day_off = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			SET @output_message = 4
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id)
			SET @output_message = 5
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id AND A.status = 'accepted')
			SET @output_message = 6
		ELSE IF @day_off LIKE '%Friday%'
			SET @output_message = 7
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Jobs WHERE @job_id = job_id AND number_of_vacancies > 0)
			SET @output_message = 8
		ELSE
			BEGIN
				DECLARE @salary INT, @job_title VARCHAR(120)
				SELECT @salary = J.salary
					FROM Departments D INNER JOIN Jobs J ON D.code = J.dep_code
					WHERE @job_id = J.job_id
				SELECT @job_title = J.title
					FROM Jobs J
					WHERE @job_id = J.job_id
				INSERT INTO Staff_Members
					VALUES (@username, @salary, @day_off, 30, @job_id)
				UPDATE dbo.Jobs
					SET number_of_vacancies = number_of_vacancies - 1
					WHERE @job_id = job_id
				DELETE FROM Applications
					WHERE @username = seeker_username
				DELETE FROM Job_Seekers
					WHERE @username = username
				IF @job_title LIKE 'Manager - %'
					INSERT INTO Managers VALUES (@username, 'Techincal')
				ELSE IF @job_title LIKE 'HR Employee - %'
					INSERT INTO Hr_Employees VALUES (@username)
				ELSE IF @job_title LIKE 'Regular Employee - %'
					INSERT INTO Regular_Employees VALUES (@username)
				SET @output_message = 9
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------
------------------------------------------------


------------------------------------------------------------------------------
-- view_Interview_Questions Procedure: Used For Retrieving Interview Questions
------------------------------------------------------------------------------
CREATE OR ALTER PROC view_Interview_Questions
@job_id INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @job_id = ''
			SET @output_message = 1
		ELSE IF @job_id = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM dbo.Interview_Questions WHERE @job_id = job_id)
			SET @output_message = 4
		ELSE
			BEGIN
				SELECT *
					FROM Jobs J INNER JOIN Interview_Questions IQ ON J.job_id = IQ.job_id
					WHERE @job_id = J.job_id
				SET @output_message = 5
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------------
------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- save_Score_for_certain_Job Procedure: Used For Saving Score For Certain Job Application
------------------------------------------------------------------------------------------
CREATE OR ALTER PROC save_Score_for_certain_Job
@username VARCHAR(100), @job_id INT, @score INT, @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @job_id = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @job_id = NULL OR @score = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			SET @output_message = 4
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id)
			SET @output_message = 5
		ELSE IF @score > 100 OR @score < 0
			SET @output_message = 6
		ELSE
			BEGIN
				UPDATE Applications
					SET score = @score
					WHERE @username = seeker_username
						AND @job_id = job_id
				SET @output_message = 7
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------
-- view_Projects Procedure: Used For Viewing All Tasks Assigned To Specific Employee
------------------------------------------------------------------------------------
CREATE OR ALTER PROC view_Projects
@username varchar(100), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = ''
			SET @output_message = 1
		ELSE IF @username = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users WHERE @username = username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Managers_assign_Projects_Regular_Employees MAPRE INNER JOIN Projects P ON MAPRE.company_domain = P.company_domain AND MAPRE.project_name = P.name WHERE @username = MAPRE.employee_username)
			SET @output_message = 4
		ELSE
			BEGIN
				SELECT *
					FROM Managers_assign_Projects_Regular_Employees MAPRE INNER JOIN Projects P ON MAPRE.company_domain = P.company_domain AND MAPRE.project_name = P.name
					WHERE @username = MAPRE.employee_username
				SET @output_message = 5
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- view_Tasks Procedure: Used For Viewing All Tasks Assigned To Specific Employee
---------------------------------------------------------------------------------
CREATE OR ALTER PROC view_Tasks
@username VARCHAR(100), @project_name VARCHAR(200), @output_message INT OUTPUT
AS
	BEGIN TRY
		IF @username = '' OR @project_name = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @project_name = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users WHERE @username = username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Managers_create_assign_Regular_Employees_Tasks MCATRE INNER JOIN Tasks T ON MCATRE.company_domain = T.company_domain AND MCATRE.project_name = T.project_name AND MCATRE.task_name = T.name WHERE @username = MCATRE.employee_username AND @project_name = MCATRE.project_name)
			SET @output_message = 4
		ELSE
			BEGIN
				SELECT *
					FROM Managers_create_assign_Regular_Employees_Tasks MCATRE INNER JOIN Tasks T ON MCATRE.company_domain = T.company_domain AND MCATRE.project_name = T.project_name AND MCATRE.task_name = T.name
					WHERE @username = MCATRE.employee_username
						AND @project_name = MCATRE.project_name
				SET @output_message = 5
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


----------------------------------------------------------
-- set_Task_status Procedure: Used For Setting Task Status
----------------------------------------------------------
CREATE OR ALTER PROC set_Task_status
@username VARCHAR(100), @project_name VARCHAR(200), @task_name VARCHAR(200), @status varchar(20), @output_message INT OUTPUT
AS
	BEGIN TRY
		DECLARE @company_domain VARCHAR(120), @deadline DATETIME, @status2 VARCHAR(20)
		IF @username = '' OR @project_name = '' OR @task_name = ''
			SET @output_message = 1
		ELSE IF @username = NULL OR @project_name = NULL OR @task_name = NULL
			SET @output_message = 2
		ELSE IF NOT EXISTS (SELECT * FROM Users WHERE @username = username)
			SET @output_message = 3
		ELSE IF NOT EXISTS (SELECT * FROM Managers_create_assign_Regular_Employees_Tasks MCATRE INNER JOIN Tasks T ON MCATRE.company_domain = T.company_domain AND MCATRE.project_name = T.project_name WHERE @username = MCATRE.employee_username AND @project_name = MCATRE.project_name)
			SET @output_message = 4
		ELSE
			BEGIN
				SELECT @company_domain = MCATRE.company_domain
					FROM Managers_create_assign_Regular_Employees_Tasks MCATRE
					WHERE @username = MCATRE.employee_username
						AND @project_name = MCATRE.project_name
						AND @task_name = MCATRE.task_name
				SELECT @deadline = T.deadline, @status2 = T.status
					FROM Tasks T
					WHERE @project_name = T.project_name
						AND @task_name = T.name
						AND @company_domain = T.company_domain
				IF @deadline < CURRENT_TIMESTAMP
					SET @output_message = 5
				ELSE IF @status2 = 'Closed'
					SET @output_message = 6
				ELSE
					BEGIN
						UPDATE Tasks
							SET status = @status
							WHERE @project_name = project_name
								AND @task_name = name
								AND @company_domain = company_domain
						SET @output_message = 7
					END
			END
	END TRY
	BEGIN CATCH
		SET @output_message = 0
	END CATCH
GO
----------------------------------------------------------
----------------------------------------------------------

