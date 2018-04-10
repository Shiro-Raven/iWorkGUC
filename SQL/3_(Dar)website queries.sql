use iWork_team54_v1;

ALTER TABLE Announcements
drop column date;
ALTER TABLE Announcements
add date date;
GO

alter   proc postAnnouncements 
@hr_username varchar(100), @description varchar(max)=null, @type varchar(120)=null, @title varchar(1000)=null
as
if(@hr_username is null or @description is null or @description='' or @type is null or @type='' or @title is null or @title='')
    print 'Invalid input.';
else
    begin
   	 declare @company_domain_name varchar(120),@currDate date;
   	 select @company_domain_name=D.company_domain_name from Staff_Members S inner join Jobs J on S.job_id=J.job_id
   				 inner join Departments D on D.code=J.dep_code where S.username=@hr_username;
	 set @currDate = GETDATE()
   	 insert into Announcements (description, type, title, company_domain_name,date) Values(@description,@type,@title,@company_domain_name,@currDate)
    end
Go

-- This Query is needed for sending emails to the top 3
CREATE OR ALTER PROC View_top_3_employees_username
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

END
GO

ALTER PROC View_Attendance_in_Period
@start datetime=null, @end datetime=null, @username varchar(200), @out int output
AS

if(@start is null or @end is null)begin
set @out = -1;
print('Please enter the start date and the end date of the Attendace records.')
end
else BEGIN
set @out = 1
Declare @officialhours int
SELECT @officialhours = work_hours
from Attendance_Records att inner join Staff_Members sta
on att.employee_username = sta.username
inner join Jobs j
on sta.job_id = j.job_id
WHERE att.employee_username = @username

SELECT date, start_time, end_time, DATEDIFF(HOUR,start_time, end_time) AS 'Duration', (@officialhours -  DATEDIFF(HOUR,start_time, end_time)) as 'Missing Hours' 
FROM Attendance_Records
WHERE date between @start and @end and employee_username = @username

END
GO

ALTER PROC Response_Req_Hr_Employee
@reqid int, @hrusername varchar(200), @response bit = null
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

Declare @start datetime, @end datetime, @numleaves int,@dayoff varchar(20), @day varchar(12), @staffuser varchar(120)

Select @staffuser = submitter_username
From Hr_Employees_submit_Requests
where request_id = @reqid

if(@staffuser is null)
Select @staffuser = submitter_username
From Managers_submit_Requests
where request_id = @reqid

if(@staffuser is null)
Select @staffuser = submitter_username
From Regular_Employees_submit_Requests
where request_id = @reqid

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

ALTER PROC view_total_hours_in_year
@username varchar(200), @year int = null
AS
if(@year is null)
	print('Please pick a year')
else BEGIN
	SELECT DATEPART(MONTH, date) AS 'Month', sum(DATEDIFF(HOUR, start_time, end_time)) AS 'Total Hours'
	FROM Attendance_Records
	WHERE employee_username = @username and DATEPART(YEAR, date) = @year
	Group BY DATEPART(MONTH, date)
END
GO

ALTER proc viewApplicationsHR 
@job_id int
as
select A.* 
from Applications A 
where job_id = @job_id and A.hr_approval is null;

GO

ALTER   proc postAnnouncements 
@hr_username varchar(100), @description varchar(max)=null, @type varchar(120)=null, @title varchar(1000)=null
as
declare @date datetime
if(@hr_username is null or @description is null or @description='' or @type is null or @type='' or @title is null or @title='')
    print 'Invalid input.';
else
    begin
   	 declare @company_domain_name varchar(120);
set @date = GETDATE()
   	 select @company_domain_name=D.company_domain_name from Staff_Members S inner join Jobs J on S.job_id=J.job_id
   				 inner join Departments D on D.code=J.dep_code where S.username=@hr_username;
   	 insert into Announcements (description, type, title, company_domain_name,date) Values(@description,@type,@title,@company_domain_name,@date)
    end
GO

ALTER  proc addJob 
@creator_username varchar(100), @title varchar(120), @detailed_description varchar(max), @short_description varchar(1500),
@minimum_years_of_experience int, @salary decimal(20,2), @application_deadline datetime, @work_hours int, @number_of_vacancies int, @out int output
as
if(@creator_username is null or @title is null or @detailed_description is null or @short_description is null or
@minimum_years_of_experience is null or @salary is null or @application_deadline is null or @work_hours is null or @number_of_vacancies is null
or @title='' or @detailed_description='' or @short_description='')begin
set @out = 0; 
print 'Invalid Data Entry';
end
    else
   	 begin
   		 if(@title not like 'Manager - %' and @title not like 'HR Employee - %' and @title not like 'Regular Employee - %')begin
			set @out = 1;
   			 print 'The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - .'
end
   		else if (@work_hours >8)
begin
set @out = 2;
			 print('THIS IS SLAVERY')
end
		else
   			 begin
   				 declare @department_code varchar(500);
   				 select @department_code=J.dep_code from Jobs J inner join Staff_Members S on S.job_id=J.job_id where S.username=@creator_username;
   				 insert into Jobs Values (@title,@detailed_description,@short_description,@minimum_years_of_experience,
   				 @salary,@application_deadline,@work_hours,@number_of_vacancies, @department_code);
				set @out = 3;
   			 end
   	 end
Go

create or alter   procedure viewJobQuestionsbyID 
@jobid int
as
   	 begin
   	 select I.*
   	 from Interview_Questions I
   	 where job_id=@jobid;
   	 end
GO

create  or alter proc deleteJobQuestion
@question_id int
as
    begin
   	 delete from Interview_Questions
	where question_id = @question_id
    end
GO

Alter   proc editJob 
@job_id int, @title varchar(120)=null, @detailed_description varchar(max)=null, @short_description varchar(1500)=null,
@minimum_years_of_experience int=null, @salary decimal(20,2)=null, @application_deadline datetime=null, @work_hours int=null, @number_of_vacancies int=null,@out int output
as
    begin
   		 begin
   		 if(@title not like 'Manager - %' and @title not like 'HR Employee - %' and @title not like 'Regular Employee - %')begin
			 set @out = 1
   			 print 'The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - .';
end
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
   	 if( not (@application_deadline is null) )
   		 update Jobs set application_deadline=@application_deadline where @job_id=job_id;
   	 if( not (@work_hours is null)) begin
		if(@work_hours <= 8)
   		 update Jobs set work_hours=@work_hours where @job_id=job_id;
		else
		set @out = 2
	 end
   	 if( not (@number_of_vacancies is null) )
   		 update Jobs set number_of_vacancies=@number_of_vacancies where @job_id=job_id;
    end
GO