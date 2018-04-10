USE iWork_team54_v1
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
@username varchar(100), @out INT OUTPUT
as
	BEGIN 
		declare @i INT
		exec check_staff_members @username, @i output
		if @i = 1
			BEGIN 
				if EXISTS(SELECT * FROM dbo.Attendance_Records A WHERE A.employee_username = @username AND A.date = (SELECT CONVERT(date,GETDATE())))
					BEGIN 
						PRINT 'user has already checked in'
						SET @out = 1
					END 
				ELSE IF EXISTS(SELECT * FROM dbo.Staff_Members s WHERE s.username = @username AND (s.day_off = DATENAME(WEEKDAY,GETDATE()) OR DATENAME(WEEKDAY,GETDATE()) = 'Friday'))
					BEGIN
						PRINT 'it is his day off'
						SET @out = 2
					END
				ELSE
					BEGIN
						INSERT into Attendance_Records(date,employee_username,start_time) VALUES (CONVERT(date,GETDATE()),@username,Convert(Time, GetDate()))
						SET @out = 3
					END
                    
			END 
	END 

GO

-- 2 Check-out before I leave each day.
create or alter proc check_out
@username varchar(100), @out INT OUTPUT
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
SET @out = 1
end
ELSE
BEGIN 
print 'this employee did not check in today or has already checked out'
SET @out = 2
END 
end
end

GO

-- 3 View all my attendance records (check-in time, check-out time, duration, missing hours) within a
-- certain period of time.
create or alter proc view_attendance_records 
@username varchar(100), @start date=null, @end date=null, @out INT OUTPUT
as
begin
declare @i int
if(@start is null or @end is null)
BEGIN
SET @out = 1
print('Please do not leave any empty fields')
END 
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
SET @out = 2
END
else 
BEGIN 
PRINT 'no records for this username in the specified period'
SET @out = 3
end
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
@submitter  VARCHAR(100), @start_date DATE=null, @end_date DATE=null, @replacement VARCHAR(100)=null, @request_id INT OUTPUT, @out INT OUTPUT
AS
DECLARE @submitter_type INT, @replacement_type INT
if(@start_date is null or @end_date is null or @replacement is null)
BEGIN 
print('Please do not leave any empty fields')
SET @out = 1
END 
else
	BEGIN
		EXEC dbo.get_staff_type @submitter, @submitter_type OUTPUT 
		EXEC dbo.get_staff_type @replacement, @replacement_type OUTPUT
        IF @submitter_type = 0 OR @replacement_type = 0
			BEGIN 
			SET @out = 2
			PRINT 'one of the usernames supplied not registered as a staff member'
			END 
		ELSE IF @submitter = @replacement
			BEGIN
            SET @out = 3
			PRINT 'You Can not Replace Yourself, Moron!'
			END 
		ELSE IF EXISTS (SELECT * FROM dbo.Staff_Members WHERE @submitter = username AND number_of_leaves <= 0)
			BEGIN
            SET @out = 4
			PRINT 'maximum number of leaves has been reached'
			END 
		ELSE IF @submitter_type <> @replacement_type
			BEGIN 
			PRINT 'submitter and replacement must be of the same type'
			SET @out = 5
			END 
		ELSE IF @submitter_type = 4 --manager
			BEGIN
				IF EXISTS (
						SELECT *
						FROM dbo.Managers_submit_Requests MSR INNER JOIN dbo.Requests R ON R.request_id = MSR.request_id
						WHERE (@start_date BETWEEN R.start_date AND R.end_date OR @end_date BETWEEN R.start_date AND R.end_date)
						AND (@submitter = MSR.submitter_username OR @submitter = MSR.replacement_username OR @replacement = MSR.submitter_username OR @replacement = MSR.replacement_username)
						)
					BEGIN 
					PRINT 'OVERLAP!'
					SET @out = 6
					END 
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date, status, hr_approval, manager_approval,filing_date) VALUES (@start_date, @end_date, 'accepted', 1, 1,GETDATE())
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Managers_submit_Requests VALUES (@request_id, @submitter, @replacement)
						SET @out = 7
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
					BEGIN
                    SET @out = 6
					PRINT 'OVERLAP!'
					END 
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date,filing_date) VALUES (@start_date, @end_date,GETDATE())
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Hr_Employees_submit_Requests VALUES (@request_id, @submitter, @replacement)
						SET @out = 7
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
					BEGIN
                    SET @out = 6
					PRINT 'OVERLAP!'
					END 
				ELSE
					BEGIN 
						INSERT INTO dbo.Requests (start_date, end_date,filing_date) VALUES (@start_date, @end_date,GETDATE())
						SELECT @request_id = MAX(R.request_id) FROM dbo.Requests R
						INSERT INTO dbo.Regular_Employees_submit_Requests VALUES (@request_id, @submitter, @replacement)
						SET @out = 7
					END 
            END  
	END
GO

CREATE OR ALTER PROC apply_for_request_leave
@submitter  VARCHAR(100), @start_date DATE, @end_date DATE, @replacement VARCHAR(100), @type VARCHAR(120), @out INT OUTPUT
AS
	BEGIN
		DECLARE @request_id INT
		EXEC dbo.apply_for_request @submitter, @start_date, @end_date, @replacement, @request_id OUTPUT, @out OUTPUT
		IF @request_id is not null and @request_id > 0
			INSERT INTO dbo.Leave_Requests VALUES (@request_id, @type)
	END
GO		

CREATE OR ALTER PROC apply_for_request_business_trip
@submitter  VARCHAR(100), @start_date DATE, @end_date DATE, @replacement VARCHAR(100), @destination VARCHAR(60), @purpose VARCHAR(200), @out INT OUTPUT
AS
	BEGIN
		DECLARE @request_id INT
		EXEC dbo.apply_for_request @submitter, @start_date, @end_date, @replacement, @request_id OUTPUT, @out OUTPUT 
		IF @request_id is not null and @request_id > 0
			INSERT INTO dbo.Business_Trip_Requests VALUES (@request_id, @destination, @purpose)
	END
GO



-- 5 View the status of all requests I applied for before (HR employee and manager responses).
create or alter proc view_status_of_requests 
@username  varchar(100), @out INT OUTPUT
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
BEGIN
SET @out = 1
print 'user did not submit a request'
END 
else
BEGIN
SET @out = 2
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
else 
BEGIN
PRINT 'username is incorrect'
SET @out = 3
END 
end

GO

-- 6 Delete any request I applied for as long as it is still in the review process.
CREATE OR ALTER PROC delete_request_in_review
@request_id INT, @out INT OUTPUT 
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM dbo.Requests WHERE @request_id = request_id)
			PRINT 'Request is not found'
		ELSE IF EXISTS (SELECT * FROM dbo.Requests WHERE @request_id = request_id AND status <> 'pending')
			BEGIN 
			PRINT 'Request no longer in the review process'
			SET @out = 1
			END 
		ELSE
			BEGIN
				SET @out = 2
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
@sender VARCHAR (100), @subject varchar(1000)=null, @body VARCHAR (max)=null, @recepient varchar (100)=NULL, @out INT OUTPUT
as
DECLARE @i INT
DECLARE @i2 int
Declare @time datetime
if(@subject is null or @body is null or @recepient is null)
BEGIN
SET @out = 1
print('Please do not leave any empty fields')
END 
else
BEGIN
exec check_staff_members @sender, @i output
exec check_staff_members @recepient, @i2 OUTPUT
IF @i = 0 or @i2 = 0
BEGIN 
PRINT 'Not staff members'
SET @out = 2
END 
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
SET @out = 3
end
ELSE
BEGIN 
print 'sender and recepient are not from the same company'
SET @out = 4
END 
END 

GO

-- 8 View emails sent to me by other staff members of my company.
create or alter proc view_emails
@username varchar(100)
as
begin
select e.time_stamp, e.sender_username, e.subject, e.body
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

-- extra procedure for front end design
CREATE OR ALTER PROC reply_to_email_m3
@timestamp DATETIME, @username VARCHAR(100), @se VARCHAR(100) OUTPUT
AS 
BEGIN 
IF EXISTS (
	SELECT *
	FROM dbo.Emails e
	WHERE e.time_stamp = @timestamp)
		BEGIN 
			SELECT @se = e.sender_username
			FROM Emails e inner join Staff_Members_receive_Emails s on (e.time_stamp = s.time_stamp AND
			e.sender_username = s.sender_username)
			WHERE e.time_stamp = @timestamp and s.recepient_username = @username
		END 
	ELSE 
		PRINT 'problem'
END 


