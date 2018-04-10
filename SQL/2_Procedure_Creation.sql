----------------------------------
-- Registered / Unregistered Users

--------------------------------
-- USE: iWork_team54_v1 Database
USE iWork_team54_v1
GO

-------------------------------------------------------------------------------------
-- 1) Search for any company by its name or address or its type (national/international)

-- CREATE: search_for_Company_by_Name Procedure
CREATE OR ALTER PROC search_for_Company_by_Name
@name VARCHAR(120)
AS
	BEGIN TRY
		IF @name = ''
			PRINT 'Empty Input(s)'
		ELSE IF @name = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @name = CP.name)
			PRINT 'Company With Such Name Does Not Exist'
		ELSE
			SELECT *
				FROM Company_Profiles CP
				WHERE @name = CP.name
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: search_for_Company_by_Name Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)



-- CREATE: search_for_Company_by_Address Procedure
CREATE OR ALTER PROC search_for_Company_by_Address
@address VARCHAR(200)
AS
	BEGIN TRY
		IF @address = ''
			PRINT 'Empty Input(s)'
		ELSE IF @address = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @address LIKE '%' + @address + '%')
			PRINT 'No Company Exists In The Specified Location'
		ELSE
			SELECT *
				FROM Company_Profiles CP
				WHERE CP.address LIKE '%' + @address + '%'
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: search_for_Company_by_Address Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)


-- CREATE: search_for_Company_by_Type Procedure
CREATE OR ALTER PROC search_for_Company_by_Type
@type VARCHAR(120)
AS
	BEGIN TRY
		IF @type = ''
			PRINT 'Empty Input(s)'
		ELSE IF @type = NULL
			PRINT 'NULL Input(s)'
		ELSE IF @type <> 'national' AND @type <> 'international'
			PRINT 'Type Must Be "national" or "international"'
		ELSE
			SELECT *
				FROM Company_Profiles CP
				WHERE @type = CP.type
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: search_for_Company_by_Type Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)


------------------------------------------------------------------------------------------------
-- 2) View a list of all available companies on the system along with all information of the company

-- CREATE: show_all_Companies Procedure
CREATE OR ALTER PROC show_all_Companies
AS
	IF NOT EXISTS (SELECT * FROM Company_Profiles CP)
		PRINT 'No Companies In The Database Yet'
	ELSE
		SELECT *
			FROM Company_Profiles
GO

-- INSERTION: show_all_Companies Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

---------------------------------------------------------------------------------------
-- 3) View the information of a certain company along with the departments in that company

-- CREATE: view_certain_Company_Department Procedure
CREATE OR ALTER PROC view_certain_Company_Department
@company_name VARCHAR(120)
AS
	BEGIN TRY
		IF @company_name = ''
			PRINT 'Empty Input(s)'
		ELSE IF @company_name = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @company_name = CP.name)
			PRINT 'Company With Such Name Does Not Exist'
		ELSE
			SELECT CP.*, D.*
				FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
				WHERE @company_name = CP.name
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: view_certain_Company_Department Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)


------------------------------------------------------------------------------------------------------------------
-- 4) View the information of a certain department in a certain company along with the jobs that have vacancies in it

-- CREATE: view_certain_Company_Department_Job_with_Vacancies Procedure
CREATE OR ALTER PROC view_certain_Company_Department_Job_with_Vacancies
@company_name VARCHAR(120), @department_name VARCHAR(120)
AS
	BEGIN TRY
		IF @company_name = '' OR @department_name = ''
			PRINT 'Empty Input(s)'
		ELSE IF @company_name = NULL OR @department_name = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP WHERE @company_name = CP.name)
			PRINT 'Company With Such Name Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Departments D WHERE @department_name = D.name)
			PRINT 'Department With Such Name Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name)
			PRINT 'Department With Such Name Within This Company Does Not Exist'
		ELSE
			SELECT CP.*, D.*, J.*
				FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
										INNER JOIN Jobs J ON D.code = J.dep_code
				WHERE @company_name = CP.name
					AND @department_name = D.name
					AND J.number_of_vacancies > 0
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: view_certain_Company_Department_Job_with_Vacancies Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5) Register to the website to be able to apply for any job later on. Any user has to register in the website with a unique username and a password, along with all the needed information

-- CREATE: register_User Procedure
CREATE OR ALTER PROC register_User
@username VARCHAR(100), @password VARCHAR(200), @first_name VARCHAR(60), @middle_name VARCHAR(60), @last_name VARCHAR(60), @birthdate DATETIME, @email VARCHAR(120), @years_of_experience INT
AS
	BEGIN TRY
		IF @username = '' OR @password = '' OR @first_name = '' OR @middle_name = '' OR @last_name = '' OR @birthdate = '' OR @email = '' OR @years_of_experience = ''
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL OR @password = NULL OR @first_name = NULL OR @middle_name = NULL OR @last_name = NULL OR @birthdate = NULL OR @email = NULL OR @years_of_experience = NULL
			PRINT 'NULL Input(s)'
		ELSE IF EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'Username Already Used'
		ELSE IF EXISTS (SELECT * FROM Users U WHERE @email = U.email)
			PRINT 'EMAIL ALREADY USED'
		ELSE
			BEGIN
				INSERT INTO Users
					VALUES (@username, @password, @first_name, @middle_name, @last_name, @birthdate, @email, @years_of_experience)
				INSERT INTO Job_Seekers
					VALUES (@username)
			END
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: register_User Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

 

-- CREATE: add_Job_Title Procedure
CREATE OR ALTER PROC add_Job_Title
@username VARCHAR(100), @job_title VARCHAR(120)
AS
	BEGIN TRY
		IF @username = '' OR @job_title = ''
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL OR @job_title = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'User Does Not Exist'
		ELSE IF EXISTS (SELECT * FROM Users_have_Previous_Job_Titles UJT WHERE @username = UJT.username AND @job_title = UJT.job_title)
			PRINT 'Record With Such Interies Already Exists'
		ELSE
			INSERT INTO Users_have_Previous_Job_Titles
				VALUES (@username, @job_title)
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: add_Job_Title Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6) Search for jobs that have vacancies on the system and their short description or title contain a string of keywords entered by the user. All information of the job should be displayed along with the company name and the department it belongs to

-- CREATE: search_for_Job_with_Vacancies_by_Keyword Procedure
CREATE OR ALTER PROC search_for_Job_with_Vacancies_by_Keyword
@keyword VARCHAR(1500)
AS
	BEGIN TRY
		IF @keyword = ''
			PRINT 'Empty Input(s)'
		ELSE IF @keyword = NULL
			PRINT 'NULL Input(s)'
		ELSE
			SELECT J.*, CP.name, D.name
				FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
											INNER JOIN Jobs J ON D.code = J.dep_code
				WHERE J.number_of_vacancies > 0
					AND (J.short_description LIKE '%' + @keyword + '%'
						OR J.detailed_description LIKE '%' + @keyword + '%')
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

-- INSERTION: search_for_Job_with_Vacancies_by_Keyword Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

---------------------------------------------------------------------
-- 7) View companies in the order of having the highest average salaries

-- CREATE: view_Company_by_highest_Average_Salary Procedure
CREATE OR ALTER PROC view_Company_by_highest_Average_Salary
AS
	IF NOT EXISTS (SELECT * FROM Company_Profiles CP)
		PRINT 'No Companies In The Database Yet'
	ELSE
		SELECT CP.name
			FROM Company_Profiles CP INNER JOIN Departments D ON CP.domain_name = D.company_domain_name
										INNER JOIN Jobs J ON D.code = J.dep_code
			GROUP BY CP.name
			ORDER BY AVG(J.salary) DESC
GO

-- INSERTION: view_Company_by_highest_Average_Salary Procedure
-- NOTHING TO BE ADDED (DEFAULT INSERTIONS GOT THIS)

---------------------------------------------------------------------

-- REGISTERED USER PROCEDURES

-- 1) Login to the website using my username and password which checks that i am an existing user, and
-- whether i am job seeker, HR employee, Regular employee or manager.
CREATE PROC Log_in
@user varchar(100)=null, @password varchar(200)=null
AS
DECLARE @result varchar(100)
if( @user is not null and EXISTS (SELECT * FROM Users Where username = @user and password = @password))
	Begin
		if( exists(SELECT * FROM Job_Seekers Where username = @user))
			set @result = 'Job Seeker'
		else if( exists(SELECT * FROM Hr_Employees Where username = @user))
			set @result = 'Hr Employee'
		else if( exists(SELECT * FROM Managers Where username = @user))
			set @result = 'Manager'
		else if( exists(SELECT * FROM Regular_Employees  Where username = @user))
			set @result = 'Regular Employee'
		print('Login successful! You are one of the '+ @result)
	End
else
	print('Username or/and Password wrong. Or You are not a registered user.')
GO

--------------------------------------------------------------------------------------------------------------------------------

-- 2 View all of my possible information.

-- This procedure shows the general information of a user, we assume that the user logged in successfully
-- The second procedure can be used to view previous job titles user had
CREATE PROC View_Personal_Info_of_User
@user varchar(100)
AS
SELECT *
FROM Users
WHERE username = @user
GO

Create PROC View_prev_job_titles
@user varchar(100)
AS
Select job_title
FROM Users_have_Previous_Job_Titles
WHERE username = @user
GO

--------------------------------------------------------------------------------------------------------------------------------

-- 3 Edit all of my personal information.

-- This procedure allows the user to edit whatever attribute he wants, except the username
CREATE OR ALTER PROC Edit_Personal_Info
@user varchar(100), 
@pass varchar(200)=null, 
@first varchar(60)=null,
@middle varchar(60)=null, 
@last varchar(60)=null,
@birth datetime=null,
@email varchar(120)=null,
@years int=null
AS
if(@pass is not null)
	UPDATE Users
	set password = @pass
	WHERE username = @user
if(@first is not null)
	UPDATE Users
	set first_name = @first
	WHERE username = @user
if(@middle is not null)
	UPDATE Users
	set middle_name = @middle
	WHERE username = @user
if(@last is not null)
	UPDATE Users
	set last_name = @last
	WHERE username = @user
if(@birth is not null)
	UPDATE Users
	set birth_date = @birth
	WHERE username = @user
if(@email is not null)
Begin
if(not exists(Select * FROM Users WHERE email = @email))
	UPDATE Users
	set email = @email
	WHERE username = @user
else
	print('Email is already used')
end
if(@years is not null)
	UPDATE Users
	set years_of_experience = @years
	WHERE username = @user
GO

-- Here it is assumed that the user chooses one of his previous titles so the first two
-- paramters are never null
CREATE OR ALTER PROC Edit_Prev_Titles
@user varchar(100), @oldtitle varchar(120), @newtitle varchar(120)=null
AS
if(@newtitle is not null)
Update Users_have_Previous_Job_Titles
set job_title = @newtitle
WHERE job_title = @oldtitle and username = @user
else
print('Please enter value of the new job title')
GO

-- This procedure allows user to delete one of his previous job titles
CREATE PROC Delete_Prev_title
@user varchar(100), @oldtitle varchar(120)
AS 
DELETE FROM Users_have_Previous_Job_Titles
Where job_title = @oldtitle and username = @user
GO

----------------------------------
-- Job Seeker Users

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) Apply for any job as long as I have the needed years of experience for the job. Make sure that ajob seeker can’t apply for a job, if he/she applied for it before and the application is still pending

-- CREATE: apply_for_Job Procedure
CREATE OR ALTER PROC apply_for_Job
@username VARCHAR(100), @job_id INT
AS
DECLARE @years_of_experience INT, @minimum_years_of_experience INT
	BEGIN TRY
		IF @username = '' OR @job_id = ''
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL OR @job_id = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'User Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			PRINT 'Job Does Not Exist'
		ELSE IF EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id AND A.status = 'pending')
			PRINT 'The Application Is Still In Progress'
		ELSE IF EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id AND A.status <> 'pending')
			BEGIN
			DELETE FROM Applications
				WHERE @username = seeker_username AND @job_id = job_id
				SELECT @years_of_experience = U.years_of_experience
					FROM Users U
					WHERE @username = U.username
				SELECT @minimum_years_of_experience = J.minimum_years_of_experience
					FROM Jobs J
					WHERE @job_id = J.job_id
				IF @minimum_years_of_experience > @years_of_experience
					PRINT 'NOT ENOUGH Years Of Experience'
				ELSE
					INSERT INTO Applications (seeker_username, job_id, status)
						VALUES (@username, @job_id, 'pending')
			END
		ELSE
			BEGIN
				SELECT @years_of_experience = U.years_of_experience
					FROM Users U
					WHERE @username = U.username
				SELECT @minimum_years_of_experience = J.minimum_years_of_experience
					FROM Jobs J
					WHERE @job_id = J.job_id
				IF @minimum_years_of_experience > @years_of_experience
					PRINT 'NOT ENOUGH Years Of Experience'
				ELSE
					INSERT INTO Applications (seeker_username, job_id, status)
						VALUES (@username, @job_id, 'pending')
			END
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO


--------------------------------------------------------------------
-- 2) View the interview questions related to the job I am applying for

-- CREATE: view_Interview_Questions Procedure
CREATE OR ALTER PROC view_Interview_Questions
@job_id INT
AS
	BEGIN TRY
		IF @job_id = ''
			PRINT 'Empty Input(s)'
		ELSE IF @job_id = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			PRINT 'Job Does Not Exist'
		ELSE
			SELECT IQ.wording
				FROM Jobs J INNER JOIN Interview_Questions IQ ON J.job_id = IQ.job_id
				WHERE @job_id = J.job_id
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

--------------------------------------------------------
-- 3) Save the score I got while applying for a certain job

-- CREATE: save_Score_for_certain_Job Procedure
CREATE OR ALTER PROC save_Score_for_certain_Job
@username VARCHAR(100), @job_id INT, @score INT
AS
	BEGIN TRY
		IF @username = '' OR @job_id = '' OR @score = '' 
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL OR @job_id = NULL OR @score = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'User Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			PRINT 'Job Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id)
			PRINT 'No Application WIth Such Interies Exist'
		ELSE IF @score > 100 OR @score < 0
			PRINT 'Score Out Of Range'
		ELSE
			UPDATE Applications
				SET score = @score
				WHERE @username = seeker_username
					AND @job_id = job_id
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4) View the status of all jobs I applied for before (whether it is finally accepted, rejected or still in the review process), along with the score of the interview questions

-- CREATE: view_Status_of_all_Applications Procedure
CREATE OR ALTER PROC view_Status_of_all_Applications
@username VARCHAR(100)
AS
	BEGIN TRY
		IF @username = ''
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'User Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username)
			PRINT 'No Application Yet'
		ELSE
			SELECT J.title, A.status, A.score
				FROM Applications A inner join Jobs J on A.job_id = J.job_id 
				WHERE @username = A.seeker_username
	END TRY
	BEGIN CATCH
		PRINT 'Invalid Input(s)'
	END CATCH
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5) Choose a job from the jobs I was accepted in, which would make me a staff member in the company and the department that offered this job. Accordingly, my salary and company email are set, and I GET 30 annual leaves. In addition, I should also choose one day-off other than Friday. The number of vacancies for the assigned job has to be updated too

-- CREATE: choose_Job_choose_day_off_30_annual_leaves Procedure
CREATE OR ALTER PROC choose_Job_choose_day_off_30_annual_leaves
@username VARCHAR(100), @job_id INT, @day_off VARCHAR(12)
AS
	BEGIN
	Declare @jobtitle varchar(120)
		IF @username = '' OR @job_id = '' OR @day_off = '' 
			PRINT 'Empty Input(s)'
		ELSE IF @username = NULL OR @job_id = NULL OR @day_off = NULL
			PRINT 'NULL Input(s)'
		ELSE IF NOT EXISTS (SELECT * FROM Users U WHERE @username = U.username)
			PRINT 'User Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Jobs J WHERE @job_id = J.job_id)
			PRINT 'Job Does Not Exist'
		ELSE IF NOT EXISTS (SELECT * FROM Applications A WHERE @username = A.seeker_username AND @job_id = A.job_id AND A.status = 'accepted')
			PRINT 'User Was Not Accepted To This Job Or Did Not Apply To It'
		ELSE IF @day_off LIKE '%Friday%'
			PRINT 'Friday is Already A Day-Off'
		ELSE
			BEGIN
				DECLARE @salary INT
				SELECT @salary = J.salary
					FROM Jobs J
					WHERE @job_id = J.job_id

				INSERT INTO Staff_Members(username, salary,day_off,number_of_leaves,job_id)
					VALUES (@username, @salary, @day_off, 30, @job_id)
				
				Select @jobtitle = title
				From Jobs
				Where job_id = @job_id

				-- FOR THE MANAGERS IT WAS NOT SPECIFIED HOW TO GET THE TYPE
				if @jobtitle like 'HR Employee - %' 
					Insert into Hr_Employees values (@username)
				else if @jobtitle like 'Manager - %'
					Insert into Managers(username) values (@username)
				else 
					Insert into Regular_Employees values (@username)

				DELETE FROM Applications
					WHERE @username = seeker_username
				DELETE FROM Job_Seekers
					WHERE @username = username

				Update Jobs
					Set number_of_vacancies = number_of_vacancies - 1
					Where job_id = @job_id
			END
	END
GO

/**
Job Seeker Procedure 6
The Job Seeker can delete any job application that he applied for as long as it is still in the review process.
It takes the username and the job_id as input. This is the primary key of Applications.
If the entered username or job_id is invalid, an error message is printed.
Otherwise, the status of the application is retrieved
**/
create or alter proc deleteJobApplication
@username varchar(100), @job_id int
as
if(@username is null or @job_id is null)
print 'The username or job_id is invalid.';
else
begin
declare @application_status varchar(60);
select @application_status=A.status from Applications A where A.seeker_username=@username and A.job_id=@job_id;
if(@application_status='pending')
delete from Applications where Applications.seeker_username=@username and Applications.job_id=@job_id;
else
print 'The application is not in the review process';
end
--end of deleteJobApplication
GO

----------------------------------------------------------------------------------------------------------------------------------
-- STAFF MEMBER PROCEDURES

--helper to check username is registered as a staff member
create or alter proc check_staff_members 
@username VARCHAR (100), @i int = 0 output
as
begin

if not exists(select * from Staff_Members where username = @username)
begin
print 'username is not registered as a staff member'
set @i = 0
end
else
 set @i = 1

end


GO

--helper to check username is registered as a manager
create or alter proc check_managers @username VARCHAR (100), @m int = 0 output
as
begin
declare @i int
exec check_staff_members @username, @i output
if (@i =1)
begin
if not exists(
select *
from Managers
where username = @username
)
set @m = 0
else set @m = 1
end
end

GO

--helper to check username is registered as a regular employee
create or alter proc check_regular_employees @username VARCHAR (100), @m int= 0 output
as
begin
declare @i int
exec check_staff_members @username, @i output
if (@i =1)
begin
if not exists(
select *
from Regular_Employees
where username = @username
)
set @m = 0
else set @m = 1
end
end

GO

--helper to check username is registered as an hr employee
create or alter proc check_hr_employees @username VARCHAR (100), @m int = 0 output
as
begin
declare @i int
exec check_staff_members @username, @i output
if (@i =1)
begin
if not exists(
select *
from Hr_Employees
where username = @username
)
set @m = 0
else set @m = 1
end
end


GO

-- 1 Check-in once I arrive each day.

create or alter proc check_in
@username varchar(100)
as
	begin
		declare @i INT
		exec check_staff_members @username, @i output
		if @i = 1
			begin
				if EXISTS(SELECT * FROM dbo.Attendance_Records A WHERE A.employee_username = @username AND A.date = (SELECT CONVERT(date,GETDATE())))
					PRINT 'user has already checked in'
				ELSE IF EXISTS(SELECT * FROM dbo.Staff_Members s WHERE s.username = @username AND (s.day_off = DATENAME(WEEKDAY,GETDATE()) OR DATENAME(WEEKDAY,GETDATE()) = 'Friday'))
					PRINT 'it is his day off'
				ELSE
					INSERT into Attendance_Records(date,employee_username,start_time) VALUES (CONVERT(date,GETDATE()),@username,Convert(Time, GetDate()))
			end
	end

GO

-- 2 Check-out before I leave each day.
create or alter proc check_out
@username varchar(100)
as
begin
declare @i int
exec check_staff_members @username, @i output
if @i = 1
begin
if exists(
select A.employee_username 
from Attendance_Records A
where A.employee_username = @username and A.date = convert(date, GETDATE()) and A.end_time is null
)
begin
update Attendance_Records
set end_time = CONVERT(Time, GETDATE())
where employee_username = @username and date = (SELECT CONVERT(date,GETDATE()))
end
else
print 'this employee did not check in today or has already checked out'
end
end

GO

-- 3 View all my attendance records (check-in time, check-out time, duration, missing hours) within a
-- certain period of time.
create or alter proc view_attendance_records 
@username varchar(100), @start date=null, @end date=null
as
begin
declare @i int
if(@start is null or @end is null)
print('Please do not leave any empty fields')
else 
begin
exec check_staff_members @username, @i output
if @i = 1
begin
if exists(
select A.*
from Attendance_Records A
where A.employee_username = @username and (A.date >= @start and A.date <= @end) and A.end_time is not null)
begin
select A.start_time, A.end_time, '' + convert(varchar(50),datediff(hour,A.start_time, A.end_time)) + ' : ' + convert(varchar(50),datediff(MINUTE,A.start_time, A.end_time)) + ' : ' +  convert(varchar(50),datediff(SECOND,A.start_time, A.end_time)) + '' as duration,
(j.work_hours - convert(int,datediff(hour,A.start_time, A.end_time))) as missing_hours
from Attendance_Records A inner join Staff_Members s on A.employee_username = s.username inner join jobs j on s.job_id = j.job_id
where A.employee_username = @username and A.date between @start and @end and A.end_time is not null
end
else print 'no records for this username in the specified period'
end
end
end
GO

/*
4 Apply for requests of both types: leave requests or business trip requests, by supplying all the
needed information for the request. As a staff member, I can not apply for a leave if I exceeded the
number of annual leaves allowed. If I am a manager applying for a request, the request does not
need to be approved, but it only needs to be kept track of. Also, I can not apply for a request when
it’s applied period overlaps with another request.
*/

CREATE OR ALTER PROC get_staff_type
@username VARCHAR(100), @type INT OUTPUT 
AS
	BEGIN
		IF EXISTS (SELECT * FROM dbo.Managers WHERE username = @username) SET @type = 4
		ELSE IF EXISTS (SELECT * FROM dbo.Hr_Employees WHERE username = @username) SET @type = 3
		ELSE IF EXISTS (SELECT * FROM dbo.Regular_Employees WHERE username = @username) SET @type = 2
		ELSE IF EXISTS (SELECT * FROM dbo.Staff_Members WHERE username = @username) SET @type = 1
		ELSE SET @type = 0
	END
GO

CREATE OR ALTER PROC apply_for_request
@submitter  VARCHAR(100), @start_date DATE=null, @end_date DATE=null, @replacement VARCHAR(100)=null, @request_id INT OUTPUT
AS
DECLARE @submitter_type INT, @replacement_type INT
if(@start_date is null or @end_date is null or @replacement is null)
print('Please do not leave any empty fields')
else
	BEGIN
		EXEC dbo.get_staff_type @submitter, @submitter_type OUTPUT 
		EXEC dbo.get_staff_type @replacement, @replacement_type OUTPUT
        IF @submitter_type = 0 OR @replacement_type = 0
			PRINT 'one of the usernames supplied not registered as a staff member'
		ELSE IF @submitter = @replacement
			PRINT 'You Can not Replace Yourself, Moron!'
		ELSE IF EXISTS (SELECT * FROM dbo.Staff_Members WHERE @submitter = username AND number_of_leaves <= 0)
			PRINT 'maximum number of leaves has been reached'
		ELSE IF @submitter_type <> @replacement_type
			PRINT 'submitter and replacement must be of the same type'
		ELSE IF @submitter_type = 4 --manager
			BEGIN
				IF EXISTS (
						SELECT *
						FROM dbo.Managers_submit_Requests MSR INNER JOIN dbo.Requests R ON R.request_id = MSR.request_id
						WHERE (@start_date BETWEEN R.start_date AND R.end_date OR @end_date BETWEEN R.start_date AND R.end_date)
						AND (@submitter = MSR.submitter_username OR @submitter = MSR.replacement_username OR @replacement = MSR.submitter_username OR @replacement = MSR.replacement_username)
						)
					PRINT 'OVERLAP!'
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date, status, hr_approval, manager_approval) VALUES (@start_date, @end_date, 'accepted', 1, 1)
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Managers_submit_Requests VALUES (@request_id, @submitter, @replacement)
					END 
            END
		ELSE IF @submitter_type = 3 --hr
			BEGIN
				IF EXISTS (
						SELECT *
						FROM dbo.Hr_Employees_submit_Requests MSR INNER JOIN dbo.Requests R ON R.request_id = MSR.request_id
						WHERE (@start_date BETWEEN R.start_date AND R.end_date OR @end_date BETWEEN R.start_date AND R.end_date)
						AND (@submitter = MSR.submitter_username OR @submitter = MSR.replacement_username OR @replacement = MSR.submitter_username OR @replacement = MSR.replacement_username)
						)
					PRINT 'OVERLAP!'
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date) VALUES (@start_date, @end_date)
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Hr_Employees_submit_Requests VALUES (@request_id, @submitter, @replacement)
					END 
            END 
		ELSE IF @submitter_type = 2 --regular
			BEGIN
				IF EXISTS (
						SELECT *
						FROM dbo.Regular_Employees_submit_Requests MSR INNER JOIN dbo.Requests R ON R.request_id = MSR.request_id
						WHERE (@start_date BETWEEN R.start_date AND R.end_date OR @end_date BETWEEN R.start_date AND R.end_date)
						AND (@submitter = MSR.submitter_username OR @submitter = MSR.replacement_username OR @replacement = MSR.submitter_username OR @replacement = MSR.replacement_username)
						)
					PRINT 'OVERLAP!'
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date) VALUES (@start_date, @end_date)
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Regular_Employees_submit_Requests VALUES (@request_id, @submitter, @replacement)
					END 
            END  
	END
GO

CREATE OR ALTER PROC apply_for_request_leave
@submitter  VARCHAR(100), @start_date DATE, @end_date DATE, @replacement VARCHAR(100), @type VARCHAR(120)
AS
	BEGIN
		DECLARE @request_id INT
		EXEC dbo.apply_for_request @submitter, @start_date, @end_date, @replacement, @request_id OUTPUT
		IF @request_id is not null and @request_id > 0
			INSERT INTO dbo.Leave_Requests VALUES (@request_id, @type)
	END
GO		

CREATE OR ALTER PROC apply_for_request_business_trip
@submitter  VARCHAR(100), @start_date DATE, @end_date DATE, @replacement VARCHAR(100), @destination VARCHAR(60), @purpose VARCHAR(200)
AS
	BEGIN
		DECLARE @request_id INT
		EXEC dbo.apply_for_request @submitter, @start_date, @end_date, @replacement, @request_id OUTPUT
		IF @request_id is not null and @request_id > 0
			INSERT INTO dbo.Business_Trip_Requests VALUES (@request_id, @destination, @purpose)
	END
GO



-- 5 View the status of all requests I applied for before (HR employee and manager responses).
create or alter proc view_status_of_requests 
@username  varchar(100)
as
begin
declare @a int
exec check_staff_members @username, @a output
if (@a = 1)
begin
if not exists(
select *
from Regular_Employees_submit_Requests reg
where reg.submitter_username = @username
UNION
select *
from Managers_submit_Requests man
where man.submitter_username = @username
UNION
select *
from  Hr_Employees_submit_Requests hrem
where hrem.submitter_username = @username
)
print 'user did not submit a request'
else
begin
declare @m int
declare @g int
declare @h int
exec check_managers @username, @m output
exec check_regular_employees @username, @g output
exec check_hr_employees @username, @h output
--if he's a regular employee
if (@g =1 and @h = 0 and @m = 0)
begin
select r1.*
from Requests r1 INNER JOIN Regular_Employees_submit_Requests g1
ON r1.request_id = g1.request_id
where g1.submitter_username = @username
end
--if he's a manager
if (@m =1 and @g =0 and @h = 0)
begin
select r2.*
from Requests r2 INNER JOIN Managers_submit_Requests g2
ON r2.request_id = g2.request_id
where g2.submitter_username = @username
end
--if he's an hr employee
if (@h = 1 and @g = 0 and @m = 0)
begin
select r3.*
from Requests r3 INNER JOIN Hr_Employees_submit_Requests g3
ON r3.request_id = g3.request_id
where g3.submitter_username = @username
end
end
end
else print 'username is incorrect'
end

GO

-- 6 Delete any request I applied for as long as it is still in the review process.
CREATE OR ALTER PROC delete_request_in_review
@request_id INT
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM dbo.Requests WHERE @request_id = request_id)
			PRINT 'Request is not found'
		ELSE IF EXISTS (SELECT * FROM dbo.Requests WHERE @request_id = request_id AND status <> 'pending')
			PRINT 'Request no longer in the review process'
		ELSE
			BEGIN
				DECLARE @username VARCHAR(100)
				IF EXISTS (SELECT * FROM dbo.Managers_submit_Requests WHERE @request_id = request_id)
					BEGIN
						SELECT @username = submitter_username FROM dbo.Managers_submit_Requests WHERE @request_id = request_id
						DELETE FROM dbo.Managers_submit_Requests WHERE @request_id = request_id
					END
				ELSE IF EXISTS (SELECT * FROM dbo.Hr_Employees_submit_Requests WHERE @request_id = request_id)
					BEGIN
						SELECT @username = submitter_username FROM dbo.Hr_Employees_submit_Requests WHERE @request_id = request_id
						DELETE FROM dbo.Hr_Employees_submit_Requests WHERE @request_id = request_id
					END
				ELSE IF EXISTS (SELECT * FROM dbo.Regular_Employees_submit_Requests WHERE @request_id = request_id)
					BEGIN
						SELECT @username = submitter_username FROM dbo.Regular_Employees_submit_Requests WHERE @request_id = request_id
						DELETE FROM dbo.Regular_Employees_submit_Requests WHERE @request_id = request_id
					END
				DELETE FROM dbo.Leave_Requests WHERE @request_id = request_id
				DELETE FROM dbo.Business_Trip_Requests WHERE @request_id = request_id
				DELETE FROM dbo.Requests WHERE @request_id = request_id
--				UPDATE dbo.Staff_Members SET number_of_leaves = number_of_leaves + 1 WHERE @username = username
			END
	END
GO
-- 7 Send emails to staff members in my company.
create or alter proc send_email
@sender VARCHAR (100), @subject varchar(1000)=null, @body VARCHAR (max)=null, @recepient varchar (100)=null
as
DECLARE @i INT
DECLARE @i2 int
Declare @time datetime
if(@subject is null or @body is null or @recepient is null)
print('Please do not leave any empty fields')
else
BEGIN
exec check_staff_members @sender, @i output
exec check_staff_members @recepient, @i2 OUTPUT
IF @i = 0 or @i2 = 0
PRINT 'Not staff members'
ELSE

if ((
select d.company_domain_name
from Staff_Members s inner join Jobs j on s.job_id = j.job_id
inner join Departments d on j.dep_code = d.code
where s.username = @sender
) = (
select d1.company_domain_name
from Staff_Members s1 inner join Jobs j1 on s1.job_id = j1.job_id
inner join Departments d1 on j1.dep_code = d1.code
where s1.username = @recepient
))
begin
set @time = CURRENT_TIMESTAMP
insert into Emails values (@time, @sender, @subject, @body)
insert into Staff_Members_receive_Emails values (@time, @sender, @recepient)
end
else
print 'sender and recepient are not from the same company'
end

GO

-- 8 View emails sent to me by other staff members of my company.
create or alter proc view_emails
@username varchar(100)
as
begin
select *
from Emails e inner join Staff_Members_receive_Emails s on (e.time_stamp = s.time_stamp and e.sender_username = s.sender_username)
where s.recepient_username = @username
end

GO

-- 9 Reply to an email sent to me, while the reply would be saved in the database as a new email record.
create or alter proc reply_to_email
@timestamp datetime, @sender varchar(100), @recepient varchar(100), @replySubject varchar(1000), @replyBody varchar(max) 
as
begin
if exists (
select *
from Emails e inner join Staff_Members_receive_Emails s on (e.time_stamp = s.time_stamp and e.sender_username = s.sender_username)
where e.time_stamp = @timestamp and e.sender_username = @sender and s.recepient_username = @recepient
)
begin
exec send_email @recepient, @replySubject, @replyBody, @sender --in the reply the recepient becomes the sender and vice versa
end
else print 'there is no such email'
end

GO

-- 10 View announcements related to my company within the past 20 days.
create or alter proc view_announcements @username varchar(100)
as
begin
select a.*
from Staff_Members s inner join Jobs j on s.job_id = j.job_id inner join Departments d
on j.dep_code = d.code inner join Announcements a on d.company_domain_name = a.company_domain_name
where s.username = @username and datediff(day,a.date, convert(date,GETDATE()) ) <= 20
end

GO

/** HR Story 1: **/
--Part 1:
/**Add a new job that belongs to my department, including all the information needed about the
job. The title of the added job should contain at the beginning the role that will be assigned to the job seeker if he/she was accepted in
this job; for example: “Manager - Junior Sales Manager”. **/
GO
create or alter proc addJob 
@creator_username varchar(100), @title varchar(120), @detailed_description varchar(max), @short_description varchar(1500),
@minimum_years_of_experience int, @salary decimal(20,2), @application_deadline datetime, @work_hours int, @number_of_vacancies int
as
if(@creator_username is null or @title is null or @detailed_description is null or @short_description is null or
@minimum_years_of_experience is null or @salary is null or @application_deadline is null or @work_hours is null or @number_of_vacancies is null
or @title='' or @detailed_description='' or @short_description='') print 'Invalid Data Entry';
    else
   	 begin
   		 if(@title not like 'Manager - %' and @title not like 'HR Employee - %' and @title not like 'Regular Employee - %')
   			 print 'The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - .'
   		else if (@work_hours >8)
			 print('THIS IS SLAVERY')
		else if (@application_deadline <CURRENT_TIMESTAMP)
			 print('deadline can not be before now')
		else
   			 begin
   				 declare @department_code varchar(500);
   				 select @department_code=J.dep_code from Jobs J inner join Staff_Members S on S.job_id=J.job_id where S.username=@creator_username;
   				 insert into Jobs Values (@title,@detailed_description,@short_description,@minimum_years_of_experience,
   				 @salary,@application_deadline,@work_hours,@number_of_vacancies, @department_code);
   			 end
   	 end

GO

-- HR Story 1 Part 2:
/**Add a job's interview questions along with their model answers.**/
create or alter proc addJobQuestions 
@model_answer bit,@wording varchar(max),@job_id int
as
if(@model_answer is null or @wording is null or @wording = '' or @job_id is null)
    print 'The model answer, wording, and job id must not be null. Also the wording shouldn''t be empty.';
else
    insert into Interview_Questions (model_answer,wording,job_id) values(@model_answer,@wording,@job_id);

GO

/** HR Story 2:
    An HR Employee can view information about a job in his department.
    The procedure viewJobs retrieves a table with all the jobs in the HR Employee's department
**/

create or alter procedure viewJobs 
@hr_user_name varchar(100)
as
    if(@hr_user_name is null)
   	 print 'Invalid username';
    else
   	 begin
   		 declare @department_code varchar(500);
   		 select @department_code=D.code from Departments D inner join Jobs J on D.code=J.dep_code
   		 inner join Staff_Members S on J.job_id=S.job_id
		 where S.username=@hr_user_name;

   		 select * from Jobs J where J.dep_code=@department_code;
   	 end
--end of viewJobs procedure

GO

/**    HR Story 2: Part 2
    The HR Employee can view the interview questions associated with the jobs
**/
create or alter procedure viewJobQuestions 
@hr_user_name varchar(100)
as
    if(@hr_user_name is null)
   	 print 'Invalid username'
    else
   	 begin
   	 declare @department_code varchar(500);
   	 select @department_code=D.code from Departments D inner join Jobs J on D.code=J.dep_code
   		 inner join Staff_Members S on S.username=@hr_user_name and J.job_id=S.job_id;
   	 --select the questions related to the jobs in this department
   	 select I.*
   	 from Interview_Questions I
   	 where I.job_id in(select J.job_id from Jobs J where J.dep_code=@department_code);
   	 end

GO

/**    HR Story 3:
    Part 1
    An HR Employee can edit the information of a job in his department.
    We assumed that the HR employee will have access in the website only to the jobs in his department. Therefore, we did not make
    a check whether the job is in his department or not.
    The job id and the department that the job belongs to cannot be edited.
**/
create or alter proc editJob 
@job_id int, @title varchar(120)=null, @detailed_description varchar(max)=null, @short_description varchar(1500)=null,
@minimum_years_of_experience int=null, @salary decimal(20,2)=null, @application_deadline datetime=null, @work_hours int=null, @number_of_vacancies int=null
as
if(@job_id is null)
    print 'Invalid job id';
else
    begin
   	 if( not (@title is null or @title='') )
   		 begin
   		 if(@title not like 'Manager - %' and @title not like 'HR Employee - %' and @title not like 'Regular Employee - %')
   			 print 'The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - .';
   		 else
   			 update Jobs set title=@title where @job_id=job_id;
   		 end
   	 if( not (@detailed_description is null or @detailed_description='') )
   		 update Jobs set detailed_description=@detailed_description where @job_id=job_id;
   	 if( not (@short_description is null or @short_description='') )
   		 update Jobs set short_description=@short_description where @job_id=job_id;
   	 if( not (@minimum_years_of_experience is null) )
   		 update Jobs set minimum_years_of_experience=@minimum_years_of_experience where @job_id=job_id;
   	 if( not (@salary is null or @salary<0) )
   		 update Jobs set salary=@salary where @job_id=job_id;
   	 if( not (@application_deadline is null or @application_deadline < CURRENT_TIMESTAMP) )
   		 update Jobs set application_deadline=@application_deadline where @job_id=job_id;
   	 if( not (@work_hours is null or @work_hours > 8) )
   		 update Jobs set work_hours=@work_hours where @job_id=job_id;
   	 if( not (@number_of_vacancies is null) )
   		 update Jobs set number_of_vacancies=@number_of_vacancies where @job_id=job_id;
    end
--end of the editJob Procedure

GO

/** HR Story 3: Part 2
    An HR can edit the interview questions of the jobs in his department.
    The job that the question belongs to cannot be edited.
    The question_id is a unique identifier of a question.
**/
create or alter proc editJobQuestions 
@question_id int, @model_answer bit=null,@wording varchar(max)=null
as
if(@question_id is null)
    print 'The question id or job id is null';
else
    begin
   	 if(not(@model_answer is null))
   		 update Interview_Questions set model_answer=@model_answer where @question_id=question_id;
   	 if(not(@wording is null))
   		 update Interview_Questions set wording=@wording where @question_id=question_id;
    end

--end of the editJobQuestions procedure
GO


/** HR Story 4:
    An HR Employee can view new applications for a specific job in his department.
    I assumed that new means that the application was not reviewed by the HR before. This was implemented in:
    viewApplicationsHR
    
    For each application, he should be able to check information about the job seeker, job, the score he/she got while applying.
    The information about the job seeker and the job are retrieved through three other procedures:
    viewJobSeekerInfoHR
    viewPreviousJobTitlesForJobSeekerHR
    viewJobInfoHR

    The score is displayed along with the application in viewApplicationsHR. Therefore, I did not create an additional procedure for it.
**/
create or alter proc viewApplicationsHR 
@hr_username varchar(100)
as
if(@hr_username is null)
    print 'The username of the HR is invalid.';
else
    begin
   	 declare @department_code varchar(500);
   	 select @department_code=D.code from Departments D inner join Jobs J on D.code=J.dep_code
   		 inner join Staff_Members S on S.username=@hr_username and J.job_id=S.job_id;
   	 
   	 select A.* from Applications A inner join Jobs J on J.job_id=A.job_id where J.dep_code=@department_code and A.hr_approval is null;

    end

GO

--I assumed that the seeker's username will be available after a call to viewApplications.
--I assumed that the password should not be displayed
create or alter proc viewJobSeekerInfoHR 
@seeker_username varchar(100)
as
if(@seeker_username is null)
    print 'The username provided for the seeker was null.';
else
    begin
   	 select U.username,U.first_name,U.middle_name,U.last_name,U.age,U.birth_date,U.email,U.years_of_experience
   	 from Job_Seekers J inner join Users U on J.username=U.username where J.username=@seeker_username;
    end

GO

--here the remaining info of previous job titles is retrieved to be displayed along with the other information of the job seeker
create or alter proc viewPreviousJobTitlesForJobSeekerHR 
@seeker_username varchar(100)
as
if(@seeker_username is null)
    print 'The username provided for the seeker was null.';
else
    begin
   	 select PJ.job_title from Users_have_Previous_Job_Titles PJ where PJ.username=@seeker_username;
    end

GO

--I assumed the job_id will be available after a call to viewApplications
create or alter proc viewJobInfoHR @job_id int
as
if(@job_id is null)
    print 'The job_id was null';
else
    begin
   	 select J.* from Jobs J where J.job_id=@job_id;
    end

GO
--end of HR Story 4

/** HR Story 5:
    An HR Employee can accept or reject applications for jobs in his department.
    I assumed that only the jobs in his department will be displayed to him; therefore, he would not be able to take any action(accept/reject) other
    jobs.
    I assumed that the application primary key is available for the procedure.
**/
create or alter proc evaluateApplicationHR 
@job_id int, @seeker_username varchar(100), @hr_approval bit=null, @hruser varchar(100)
as
if(@job_id is null or @seeker_username is null or @hr_approval is null)
    print 'The job id or seeker username is null OR You didn''t provide a response';
else
    begin
if(@hr_approval = 0)
   	 update Applications 
	 set hr_approval=@hr_approval , hr_employee_username = @hruser, status = 'rejected'
	 where job_id=@job_id and seeker_username=@seeker_username;
else
	update Applications 
	 set hr_approval=@hr_approval , hr_employee_username = @hruser
	 where job_id=@job_id and seeker_username=@seeker_username;
    end
--end of HR story 5
GO

/** HR Story 6:
    An HR Employee can Post announcements related to his/her company to inform staff members about new updates.
**/
create or alter proc postAnnouncements 
@hr_username varchar(100), @description varchar(max)=null, @type varchar(120)=null, @title varchar(1000)=null
as
if(@hr_username is null or @description is null or @description='' or @type is null or @type='' or @title is null or @title='')
    print 'Invalid input.';
else
    begin
   	 declare @company_domain_name varchar(120);
   	 select @company_domain_name=D.company_domain_name from Staff_Members S inner join Jobs J on S.job_id=J.job_id
   				 inner join Departments D on D.code=J.dep_code where S.username=@hr_username;
   	 insert into Announcements (description, type, title, company_domain_name) Values(@description,@type,@title,@company_domain_name)
    end
--end of HR Story 6

GO

--7 View requests (business or leave) of staff members working with me in the same department that
--were approved by a manager only.
CREATE PROC view_Leave_req_Hr
@hrUsername varchar(100)
AS
Declare @hrdep varchar(500)

Select @hrdep = J.dep_code
From Staff_Members S inner join Jobs J on S.job_id = J.job_id
Where S.username = @hrUsername

Select a.* , r.submitter_username , r.replacement_username, LR.type
	From Requests a inner join Hr_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.type
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.type
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
GO

CREATE PROC view_Business_req_Hr
@hrUsername varchar(100)
AS
Declare @hrdep varchar(500)

Select @hrdep = J.dep_code
From Staff_Members S inner join Jobs J on S.job_id = J.job_id
Where S.username = @hrUsername

Select a.* , r.submitter_username , r.replacement_username, LR.destination, LR.purpose
	From Requests a inner join Hr_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.destination, LR.purpose
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.destination, LR.purpose
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @hrdep and manager_username is not null and a.status = 'pending'
GO

/*
8 Accept or reject requests of staff members working with me in the same department that were
approved by a manager. My response decides the final status of the request, therefore the annual
leaves of the applying staff member should be updated in case the request was accepted. Take into
consideration that if the duration of the request includes the staff member’s weekly day-off and/or
Friday, they should not be counted as annual leaves.
*/
-- it is assumed that the HR employee is choosing from the requests shown above
CREATE PROC Response_Req_Hr_Employee
@reqid int, @hrusername varchar(200), @response bit = null, @staffuser varchar(200)
AS
if(@response is null)
print('Please either reject or accept the request')
ELSE
BEGIN
if(@response = 0)
UPDATE Requests
set hr_approval = @response, status = 'rejected' , hr_employee_username = @hrusername
WHERE request_id = @reqid
else
Begin

UPDATE Requests
set hr_approval = @response, status = 'accepted' , hr_employee_username = @hrusername
WHERE request_id = @reqid

Declare @start datetime, @end datetime, @numleaves int,@dayoff varchar(20), @day varchar(12)
Select @start = start_date, @end = end_date
FROM Requests
Where request_id = @reqid

Select @numleaves = number_of_leaves, @dayoff = day_off
FROM Staff_Members
Where username = @staffuser

while(@start <= @end)
BEGIN
SELECT @day = DATENAME(dw,@start)
if(@day <> @dayoff and @day <> 'Friday')
set @numleaves = @numleaves - 1
set @start = @start + 1
END

UPDATE Staff_Members
set number_of_leaves = @numleaves
WHere username = @staffuser
End
END
GO

-- 9 View the attendance records of any staff member in my department (check-in time, check-out time,
-- duration, missing hours) within a certain period of time.
-- Assuming the HR will only choose from the members among his department
CREATE PROC Show_staff_in_dep
@hrusername varchar(100)
AS
Declare @hrdep varchar(500)
Select @hrdep = J.dep_code
from Staff_Members s inner join Jobs J on s.job_id = J.job_id
Where s.username = @hrusername

Select S.*
from Staff_Members s inner join Jobs J on s.job_id = J.job_id
Where J.dep_code = @hrdep 
GO


CREATE PROC View_Attendance_in_Period
@start datetime, @end datetime, @username varchar(200)
AS

if(@start is null or @end is null)
print('Please enter the start date and the end date of the Attendace records.')
else BEGIN

Declare @officialhours int
SELECT @officialhours = work_hours
from Attendance_Records att inner join Staff_Members sta
on att.employee_username = sta.username
inner join Jobs j
on sta.job_id = j.job_id
WHERE att.employee_username = @username

SELECT start_time, end_time, DATEDIFF(HOUR,start_time, end_time) AS 'Duration', (@officialhours -  DATEDIFF(HOUR,start_time, end_time)) as 'Missing Hours' 
FROM Attendance_Records
WHERE date between @start and @end and employee_username = @username

END
GO

-- 10 View the total number of hours for any staff member in my department in each month of a certain
-- year.
-- Assuming the HR will only choose from the members among his department
CREATE PROC view_total_hours_in_year
@username varchar(200), @year int = null
AS
if(@year is null)
	print('Please pick a year')
else BEGIN
	SELECT DATEPART(MONTH, date) AS 'MONTH', sum(DATEDIFF(HOUR, start_time, end_time)) AS 'Total Hours'
	FROM Attendance_Records
	WHERE employee_username = @username and DATEPART(YEAR, date) = @year
	Group BY  DATEPART(MONTH, date)
END
GO

/*
11 View names of the top 3 high achievers in my department. A high achiever is a regular employee
who stayed the longest hours in the company for a certain month and all tasks assigned to him/her
with deadline within this month are fixed.
*/
CREATE OR ALTER PROC View_top_3_employees
@month int=null, @year int=null, @hrusername varchar(200)
AS
if(@month = null or @year = null)
print('Please pick a year and a month')
else
BEGIN

Declare @hrdep varchar(500)

Select @hrdep = j.dep_code
FROM Staff_Members sta inner join Jobs j
on sta.job_id = j.job_id
where sta.username = @hrusername

Select first_name , last_name
From Users
Where username in
(
SELECT top 3 R.username
From Regular_Employees R inner join Attendance_Records att
on R.username = att.employee_username
Where DATEPART(MONTH,att.date) = @month and DATEPART(YEAR,att.date) = @year and R.username in (
	Select r.username
	From Regular_Employees r inner join Managers_create_assign_Regular_Employees_Tasks Ass
	on r.username = Ass.employee_username
	inner join Tasks t
	on Ass.company_domain = t.company_domain and Ass.project_name = t.project_name and Ass.task_name = t.name
	Where t.status = 'Fixed' and DATEPART(MONTH,t.deadline) = @month and DATEPART(YEAR,t.deadline) = @year
	and r.username in (Select sta.username
					   FROM Staff_Members sta inner join Jobs J
					   on sta.job_id = J.job_id
					   where J.dep_code = @hrdep)
)
Group By R.username
Order By sum(DATEDIFF(HOUR, start_time, end_time)) DESC
)

END
GO


-- REGULAR EMPLOYEE PROCEDURES

-- 1 View a list of projects assigned to me along with all of their information.
CREATE PROC View_projects_of_User
@user varchar(100)
AS
Select p.*
From Projects p inner join Managers_assign_Projects_Regular_Employees a
on p.company_domain = a.company_domain and p.name = a.project_name
where a.employee_username = @user
GO

-- 2 View a list of tasks in a certain project assigned to me along with all of their information and status.
CREATE PROC View_task_of_user_in_project
@user varchar(100), @projname varchar(200)
AS
SELECT t.*
FROM Tasks t inner join Managers_create_assign_Regular_Employees_Tasks a
on t.company_domain = a.company_domain and t.project_name = a.project_name and t.name = a.task_name
Where a.employee_username = @user and t.project_name = @projname
GO

-- This procedure allows the employee to show comments of one of the tasks he chose from the above query
CREATE PROC View_Comments_of_Task
@compdom varchar(120),@projname varchar(200), @task varchar(200)
AS
SELECT comment_content
FROM Tasks_have_Comments
where company_domain = @compdom and project_name = @projname and @task = task_name
GO

-- 3 After finalizing a task, I can change the status of this task to ‘Fixed’ as long as it did not pass the
-- deadline.
-- I am assuming that a user is always changing status of his task only
-- since other tasks will not appear to him in the first place
CREATE PROC Change_status_to_fixed
@domain varchar(120), @projname varchar(200), @taskname varchar(200)
AS
Declare @deadline datetime
Select @deadline = deadline
From Tasks 
Where company_domain = @domain and project_name = @projname and name = @taskname
if(@deadline > CURRENT_TIMESTAMP)
	UPDATE Tasks Set status = 'Fixed' 
	Where company_domain = @domain and project_name = @projname and name = @taskname
else 
	print('The task''s deadline has already passed.')
GO

-- 4 Work on the task again (a task that was assigned to me before). I can change the status of this
-- task from ‘Fixed’ to ‘Assigned’ as long as the deadline did not pass and it was not reviewed by the
-- manager yet. Same assumptions from the previous procedure 
-- are assumed here as well.
CREATE PROC Change_status_to_Assigned
@domain varchar(120), @projname varchar(200), @taskname varchar(200)
AS
Declare @deadline datetime, @status varchar(20)
Select @deadline = deadline , @status = status
From Tasks 
Where company_domain = @domain and project_name = @projname and name = @taskname
if(@deadline > CURRENT_TIMESTAMP and @status = 'Fixed')
	UPDATE Tasks Set status = 'Assigned' 
	Where company_domain = @domain and project_name = @projname and name = @taskname
else 
	print('The task''s deadline has already passed or/and it has been reviewd by the manager.')
GO

-- MANAGER PROCEDURES

/** Managers Story 1:
	This procedure view new requests from staff members working in manager's department
	There are two types of requests. Therefore, I made two procedures, one for each.
	When the Manager decides to see the new requests, both procedures will be called.
**/

--retrieve the leave requests
CREATE OR ALTER PROC view_leave_req_in_manager_dep
@manager varchar(100)
AS
Declare @mandep varchar(500)
Declare @manType varchar(120)

Select @manType = type
From Managers
Where username = @manager

Select @mandep = dep_code
FROM Staff_Members s inner join Jobs j
on s.job_id = j.job_id
WHERE s.username = @manager

--HR Manager can view HR requests
if(@manType = 'HR')
begin
	Select a.* , r.submitter_username , r.replacement_username, LR.type
	From Requests a inner join Hr_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.type
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.* , r.submitter_username , r.replacement_username,LR.type
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
end
else
begin
	Select a.*, r.submitter_username , r.replacement_username, LR.type
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.*, r.submitter_username , r.replacement_username, LR.type
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Leave_Requests LR
	on LR.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
end

GO
--retrieve business trip requests
CREATE OR ALTER PROC view_business_trip_req_in_manager_dep
@manager varchar(100)
AS
Declare @mandep varchar(500)
Declare @manType varchar(120)

Select @manType = type
From Managers
Where username = @manager

Select @mandep = dep_code
FROM Staff_Members s inner join Jobs j
on s.job_id = j.job_id
WHERE s.username = @manager

--HR Manager can view HR requests
if(@manType = 'HR')
begin
	Select a.* , r.submitter_username , r.replacement_username, BR.destination, BR.purpose
	From Requests a inner join Hr_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests BR
	on Br.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.* , r.submitter_username , r.replacement_username, BR.destination, BR.purpose
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests BR
	on Br.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.* , r.submitter_username , r.replacement_username, BR.destination, BR.purpose
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests BR
	on Br.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
end
else
begin
	Select a.*, r.submitter_username , r.replacement_username, BR.destination, BR.purpose
	From Requests a inner join Regular_Employees_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests BR
	on Br.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
	UNION 
	Select a.*, r.submitter_username , r.replacement_username, BR.destination, BR.purpose
	From Requests a inner join Managers_submit_Requests r  
	on a.request_id = r.request_id
	inner join Staff_Members s
	on r.submitter_username = s.username
	inner join Jobs j
	on s.job_id = j.job_id
	inner join Business_Trip_Requests BR
	on Br.request_id=a.request_id
	Where j.dep_code = @mandep and manager_username is null
end
GO

/**	Managers Story 2:
	These procedures are for accepting or rejecting requests by staff members.
	Assume that manager chose one of the requests from the calls to the previous procedures.
**/
CREATE OR ALTER PROC Respond_request_manager
@reqid int, @username varchar(100), @response bit, @reason varchar(MAX)=null
AS 

DECLARE @type varchar(120)
if(@response = 0 and @reason is null)
	print('Please write a reason for your disapproval of this request')
else
	BEGIN
		Select @type = type
		from Managers
		where username = @username

		--if the manager is HR and the request was filed by an HR Employee, the status is updated and the decision is final.
		if(@type = 'HR' and exists(select * from Hr_Employees_submit_Requests HSR where HSR.request_id=@reqid ))
			BEGIN
				if(@response = 0)
					UPDATE Requests
					set status = 'rejected'
					where request_id = @reqid
				else
					UPDATE Requests
					set status = 'accepted'
					where request_id = @reqid
			END

		UPDATE Requests
		set manager_approval = @response , manager_username = @username
		where request_id = @reqid

		if(@response = 0)
			UPDATE Requests
			set manager_reason = @reason
			where request_id = @reqid
	END

GO
/** Managers Story 3:
-- These procedures are for viewing applications of a certain job in the manager's department
-- and the job seeker and job details if he wishes so assuming that he 
-- chooses from the Jobs that were shown to him
**/

-- AUXILARY PREOCEDURE FOR SHOWING JOBS IN A DEPARTMENT
--I assumed that the manager will be not need to view the interview questions of a job, since he will be interested only in the final score of the applicant.
CREATE OR ALTER PROC View_jobs_in_manager_dep
@manager varchar(100)
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
From Staff_Members s inner join Jobs j 
on s.job_id = j.job_id
where s.username = @manager

Select *
From Jobs
Where dep_code = @mandep
GO

CREATE OR ALTER PROC  View_app_in_manager_dep
@manager varchar(200), @jobid int
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
FROM Staff_Members s inner join Jobs j
on s.job_id = j.job_id
WHERE s.username = @manager

SELECT a.seeker_username, a.score
From Applications a inner join Jobs j
on a.job_id = j.job_id
Where a.job_id = @jobid and hr_employee_username is not null and hr_approval = 1 and j.dep_code=@mandep;
GO

-- Viewing job seeker
-- The differnce here from the one in registered users is that it doesn't show private data like password
-- To view previous job titles, the procedure in registered users can be used
CREATE or alter PROC View_seeker_data_in_app
@user varchar(100)
AS
SELECT s.first_name,s.middle_name, s.last_name, s.years_of_experience, s.email, s.age
from Users s
Where username = @user
GO

/** Manager Story 4:
-- This procedure is for the manager's response on applications
-- Assuming he chose one of the applications in the above query, which guarantees that an HR has examined it.
**/
CREATE or alter PROC Respond_application_manager
@seeker_username varchar(100)=null, @job_id int=null, @username varchar(100)=null, @response bit=null
AS
if(@seeker_username is null or @job_id is null or @username is null or @response is null)
	print 'Invalid input.';
else
	begin
		if(@response=1)
			UPDATE Applications
			set manager_approval = @response , manager_username = @username, status='accepted'
			where seeker_username=@seeker_username and job_id=@job_id;
		else
			UPDATE Applications
			set manager_approval = @response , manager_username = @username, status='rejected'
			where seeker_username=@seeker_username and job_id=@job_id;
	end
GO

/** Manager Story 5:
-- This procedure creates new projects
**/
CREATE or alter PROC create_project
@projname varchar(200)=null, @start datetime=null, @end datetime=null,@manuser varchar(100)
AS
Declare @domain varchar(120)
if(@projname is null or @start is null or @end is null or @manuser is null)
	print('Please do not leave any empty fields')
else 
	if(@start > @end)
		print('Start date must be before end date')
	else 
		BEGIN
			SELECT @domain = d.company_domain_name
			FROM Staff_Members s inner join Jobs j
			on s.job_id = j.job_id
			inner join Departments d
			on j.dep_code = d.code
			where s.username = @manuser

			if(not exists(Select * From Projects where company_domain = @domain and name = @projname))
				Insert into Projects
				values(@domain, @projname, @start,@end,@manuser);
			else
				print('A project with the same name already exists');
		END
GO

/**Manager Story 6:
-- This procedure assigns a regular employee to a project
-- We assume that the manager chose the project from those in his department only according to 
-- the Get_projects_in_department procedure below
**/
CREATE OR ALTER PROC assign_to_proj
@employee varchar(100),@compdomain varchar(120), @projname varchar(200),@manuser varchar(100)
AS
Declare @depofproject varchar(500),@dep_employee varchar(500)

if(	exists(	Select * 
			from Managers_assign_Projects_Regular_Employees 
			Where company_domain=@compdomain and employee_username = @employee and project_name = @projname))
	print('The employee is already working on this project.')
else
	Begin
		if(
			exists(select P1.project_name,P2.project_name 
			from Managers_assign_Projects_Regular_Employees P1 inner join Managers_assign_Projects_Regular_Employees P2
			on P1.employee_username=P2.employee_username
			where P1.company_domain=P2.company_domain and P1.project_name<>P2.project_name)
		)
			print 'The employee is working on two different projects; he cannot be assigned to more.'
		else
			BEGIN
				Select @depofproject = j.dep_code
				FROM Projects p inner join Staff_Members s
				on p.defining_manager_username = s.username 
				inner join Jobs j
				on s.job_id = j.job_id
				Where p.name = @projname

				Select @dep_employee = j.dep_code
				From Staff_Members s inner join Jobs j
				on s.job_id = j.job_id
				WHERE s.username = @employee

				if(@dep_employee = @depofproject)
					insert into Managers_assign_Projects_Regular_Employees
					values(@compdomain,@projname,@employee,@manuser)
				else 
					print('The employee is working in another department')
			END
	END
GO

CREATE or alter PROC Get_projects_in_department
@manuser varchar(100)
AS

Declare @mandept varchar(500)

Select @mandept = j.dep_code
From Staff_Members s inner join Jobs j
on s.job_id = j.job_id 
Where s.username = @manuser

Select p.name,p.start_date, p.end_date
FROM Projects p inner join Staff_Members s
on p.defining_manager_username = s.username 
inner join Jobs j
on s.job_id = j.job_id 
Where j.dep_code = @mandept
Go

/** Manager Story 7:
-- This procedure removes an employee from a project
-- It is assumed that the employee is chosen from list of employees in a certain project
**/
CREATE or alter PROC remove_from_project
@compdomain varchar(120),@projname varchar(200),@employee varchar(200)
AS
if(exists(	Select * 
			From Managers_create_assign_Regular_Employees_Tasks 
			Where employee_username = @employee and project_name = @projname and company_domain = @compdomain))
	print('This employee is working on a task in the project')
else
	Delete from Managers_assign_Projects_Regular_Employees
	where employee_username = @employee and project_name = @projname and company_domain = @compdomain
GO

/**Manager Story 8:
-- This procedure creates new tasks in a project in a department
-- It is assumed that the manager chose from one of the projects in his department
**/
CREATE or alter PROC create_task_in_project
@domain varchar(120) , @projname varchar(200),@taskname varchar(200)=null,@desc varchar(MAX)=null, @end datetime=null,@manuser varchar(100)
AS
if(@taskname is null or @end is null or @desc is null)
	print('Please do not leave any empty fields')
else 
	BEGIN
		if(not exists(Select * From Tasks where company_domain = @domain and project_name = @projname and name = @taskname))
			BEGIN
				Insert into Tasks
				values(@domain, @projname,@taskname,@desc,@end,'Open')
				Insert into Managers_create_assign_Regular_Employees_Tasks
				values(@domain,@projname, @taskname,@manuser,null)
			END
		else
			print('A task with the same name already exists.')
	END
GO

/**Manager Story 9:
-- This procedure assigns an employee in a project to a task
-- It is assumed that the employee is chosen from those working in the project already, who are returned by currently_assigned_to_project 
**/
Create or alter proc currently_assigned_to_project @company_domain varchar(120), @project_name varchar(200)
As
if(@company_domain is null or @project_name is null)
	print 'invalid input';
else
	select MAPR.employee_username 
	from Managers_assign_Projects_Regular_Employees MAPR
	where MAPR.company_domain=@company_domain and MAPR.project_name=@project_name;
GO

CREATE or alter PROC assign_employee_to_task
@domain varchar(120) , @projname varchar(200),@taskname varchar(200), @manuser varchar(100), @employee varchar(100)
AS
Declare @working_emp varchar(100)
Select @working_emp = employee_username
From Managers_create_assign_Regular_Employees_Tasks
Where company_domain = @domain and project_name = @projname and task_name = @taskname and manager_username = @manuser

if(@working_emp is null)
	BEGIN
		UPDATE Managers_create_assign_Regular_Employees_Tasks
		set employee_username = @employee
		Where company_domain = @domain and project_name = @projname and task_name = @taskname and manager_username = @manuser
		UPDATE Tasks
		set status = 'Assigned'
		where company_domain = @domain and project_name = @projname and name = @taskname
	END
else 
	print('Someone is already working on this task')
GO

/** Manager Story 10:
-- This procedure alters the employee working on a task
**/
CREATE or alter PROC alter_employee_of_task
@domain varchar(120) , @projname varchar(200),@taskname varchar(200), @manuser varchar(100), @employee varchar(100)
AS
Declare @status varchar(20)
Select @status = status
From Tasks
where company_domain = @domain and project_name = @projname and name = @taskname

if(@status = 'Assigned')
	UPDATE Managers_create_assign_Regular_Employees_Tasks
	set employee_username = @employee
	Where company_domain = @domain and project_name = @projname and task_name = @taskname and manager_username = @manuser
else 
	print('The employee working on this task has finished doing it already. Please review his work.')

GO

/** Manager Story 11:
-- This procedure views a list of tasks in a certain project that have a certain status.
**/
CREATE or alter PROC View_tasks_in_proj_with_status
@compdomain varchar(120), @projname varchar(200), @status varchar(20)
AS
if(@compdomain is null or @projname is null or @status is null)
	print 'Invalid input';
else
	Select name,description,deadline
	From Tasks
	Where company_domain = @compdomain and  project_name = @projname and status = @status
GO

/** Manager Story 12:
-- This procedure allows a manager to review a task, providing a new deadline for rejected ones
-- it is assumed that the manager chose from the tasks with status 'Fixed' Only
**/
CREATE or alter PROC Review_task
@manager_username varchar(100),@domain varchar(120) , @projname varchar(200),@taskname varchar(200),@deadline datetime= null,@response bit
AS
if(@manager_username is null or @domain is null or @projname is null or @taskname is null or @deadline is null or @response is null)
	print 'Invalid input';
else
	Begin
		if(@response = 1 and exists(select * from Managers_create_assign_Regular_Employees_Tasks MT where MT.company_domain=@domain and MT.project_name=@projname and MT.task_name=@taskname and MT.manager_username=@manager_username))
			Update Tasks
			set status = 'Closed'
			Where company_domain = @domain and project_name = @projname and name = @taskname;
		else
			Begin
				if(@response = 0 and exists(select * from Managers_create_assign_Regular_Employees_Tasks MT where MT.company_domain=@domain and MT.project_name=@projname and MT.task_name=@taskname and MT.manager_username=@manager_username))
					begin
						Update Tasks
						set status = 'Assigned', deadline=@deadline
						Where company_domain = @domain and project_name = @projname and name = @taskname
					end
				else
					print 'You don''t have the authority to review this task. It was created by another manager.';
			end
	end
GO