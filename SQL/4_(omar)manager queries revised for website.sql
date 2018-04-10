use iWork_team54_v1;

-- MANAGER PROCEDURES

/** Managers Story 1:
	This procedure view new requests from staff members working in manager's department
	There are two types of requests. Therefore, I made two procedures, one for each.
	When the Manager decides to see the new requests, both procedures will be called.
**/
GO
--retrieve the leave requests
CREATE OR ALTER PROC view_leave_req_in_manager_dep
@manager varchar(100), @message int=1 output
AS
if(@manager is null)
	set @message=0;
else
begin
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
end
GO
--retrieve business trip requests
CREATE OR ALTER PROC view_business_trip_req_in_manager_dep
@manager varchar(100), @message int=1 output
AS
if(@manager is null)
	set @message=0;
else
begin
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
end
GO

/**
	Managers Story 2:
	These procedures are for accepting or rejecting requests by staff members.
	Assume that manager chose one of the requests from the calls to the previous procedures.
**/
CREATE OR ALTER PROC Respond_request_manager
@reqid int, @username varchar(100), @response bit=null, @reason varchar(MAX)=null, @message int output
AS 
DECLARE @type varchar(120)
if(@response is null)
	set @message=0;
else 
	begin
		if(@response = 0 and (@reason is null or @reason = ''))
			set @message=1;
		else
			BEGIN
				set @message=2;
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
		end
GO
GO
/** Managers Story 3:
-- These procedures are for viewing applications of a certain job in the manager's department
-- and the job seeker and job details if he wishes so assuming that he 
-- chooses from the Jobs that were shown to him
**/

-- AUXILARY PREOCEDURE FOR SHOWING A JOB IN A DEPARTMENT
--I assumed that the manager will be not need to view the interview questions of a job, since he will be interested only in the final score of the applicant.
CREATE OR ALTER PROC View_job_in_manager_dep
@manager varchar(100), @job_id int
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
From Staff_Members s inner join Jobs j 
on s.job_id = j.job_id
where s.username = @manager

Select *
From Jobs
Where dep_code = @mandep and job_id=@job_id

GO
--Helper to retrieve all the jobs with applications
CREATE OR ALTER PROC View_jobs_with_applications_in_manager_dep
@manager varchar(100)
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
From Staff_Members s inner join Jobs j 
on s.job_id = j.job_id
where s.username = @manager

Select *
From Jobs J
Where dep_code = @mandep
and Exists(select A.* from Applications A where A.job_id=J.job_id and A.hr_approval=1 and A.status='pending');
GO

CREATE OR ALTER PROC  View_app_in_manager_dep
@manager varchar(200), @jobid int
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
FROM Staff_Members s inner join Jobs j
on s.job_id = j.job_id
WHERE s.username = @manager

SELECT a.*
From Applications a inner join Jobs j
on a.job_id = j.job_id
Where a.job_id = @jobid and a.hr_approval = 1 and j.dep_code=@mandep and a.status='pending';
--helper to view only a specific application
GO
CREATE OR ALTER PROC  View_specific_app_in_manager_dep
@manager varchar(200), @jobid int, @seeker_username varchar(100)
AS
Declare @mandep varchar(500)

Select @mandep = dep_code
FROM Staff_Members s inner join Jobs j
on s.job_id = j.job_id
WHERE s.username = @manager

SELECT a.*
From Applications a inner join Jobs j
on a.job_id = j.job_id
Where a.job_id = @jobid and @seeker_username = a.seeker_username and a.hr_approval = 1 and j.dep_code=@mandep and a.status='pending';
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
@projname varchar(200)=null, @start datetime=null, @end datetime=null,@manuser varchar(100),@message int output
AS
Declare @domain varchar(120)
if(@projname is null or @projname='')
	set @message=0;
else if(@start is null)
	set @message=1;
else if(@end is null)
	set @message=2;
else 
	if(@start > @end)
		set @message=3;
	else 
		BEGIN
			SELECT @domain = d.company_domain_name
			FROM Staff_Members s inner join Jobs j
			on s.job_id = j.job_id
			inner join Departments d
			on j.dep_code = d.code
			where s.username = @manuser

			if(not exists(Select * From Projects where company_domain = @domain and name = @projname))
				begin
				Insert into Projects
				values(@domain, @projname, @start,@end,@manuser);
				set @message=5;
				end
			else
				set @message=4;
		END
GO


/**Manager Story 6:
-- This procedure assigns a regular employee to a project
-- We assume that the manager chose the project from those in his department only according to 
-- the Get_projects_in_department procedure below
**/
CREATE OR ALTER PROC assign_to_proj
@employee varchar(100),@compdomain varchar(120), @projname varchar(200),@manuser varchar(100), @message int output
AS
Declare @depofproject varchar(500),@dep_employee varchar(500)

if(	exists(	Select * 
			from Managers_assign_Projects_Regular_Employees 
			Where company_domain=@compdomain and employee_username = @employee and project_name = @projname))
	 set @message=0; --print('The employee is already working on this project.')
else
	Begin
		if(
			exists(select P1.project_name,P2.project_name 
			from Managers_assign_Projects_Regular_Employees P1 inner join Managers_assign_Projects_Regular_Employees P2
			on P1.employee_username=P2.employee_username
			where P1.company_domain=P2.company_domain and P1.project_name<>P2.project_name and P1.employee_username=P2.employee_username
			and P1.employee_username=@employee)
		)
			set @message=1; --print 'The employee is working on two different projects; he cannot be assigned to more.'
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
					begin
					insert into Managers_assign_Projects_Regular_Employees
					values(@compdomain,@projname,@employee,@manuser)
					set @message=3;
					end
				else 
					set @message=2 --print('The employee is working in another department')
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

Select p.company_domain,p.name,p.start_date, p.end_date
FROM Projects p inner join Staff_Members s
on p.defining_manager_username = s.username 
inner join Jobs j
on s.job_id = j.job_id 
Where j.dep_code = @mandept
Go
--helper to retrieve all the regular employees in a department
create or alter proc get_all_regulars_in_manager_department
@manager_username varchar(100)
as
declare @manager_department varchar(500);

select @manager_department = J.dep_code
from Jobs J inner join Staff_Members S on S.job_id=J.job_id
where S.username=@manager_username;

select S.*,U.first_name,U.middle_name,U.last_name,J.title
from Staff_Members S inner join Regular_Employees R on S.username=R.username
inner join Jobs J on J.job_id=S.job_id inner join Users U on U.username=S.username
where J.dep_code=@manager_department;

GO

/** Manager Story 7:
-- This procedure removes an employee from a project
-- It is assumed that the employee is chosen from list of employees in a certain project
-- It is assumed that once the employee finishes his tasks and they have the status Closed, he could be removed normally from the project.
**/
CREATE or alter PROC remove_from_project
@compdomain varchar(120),@projname varchar(200),@employee varchar(200), @message int output
AS
if(exists(	Select * 
			From Managers_create_assign_Regular_Employees_Tasks M
			inner join Tasks T
			on T.company_domain=M.company_domain and T.project_name=M.project_name and T.name=M.task_name
			Where M.employee_username = @employee and M.project_name = @projname and M.company_domain = @compdomain and T.status<>'Closed'))
	set @message = 0;
else
	begin
	if(not exists(select * from Managers_assign_Projects_Regular_Employees 
	where employee_username = @employee and project_name = @projname and company_domain = @compdomain))
		set @message = 1;
	else
		begin
		Delete from Managers_assign_Projects_Regular_Employees
		where employee_username = @employee and project_name = @projname and company_domain = @compdomain
		set @message = 2;
		end
	end

GO


/**Manager Story 8:
-- This procedure creates new tasks in a project in a department
-- It is assumed that the manager chose from one of the projects in his department
**/
CREATE or alter PROC create_task_in_project
@domain varchar(120) , @projname varchar(200),@taskname varchar(200),@desc varchar(MAX), @end datetime,@manuser varchar(100), @message int output
AS
if(@taskname is null or @taskname='')
	set @message = 0;
else if(@end is null or @end='')
	set @message = 1;
else if(@desc is null or @desc='')
	set @message = 2;
else 
	BEGIN
		if(not exists(Select * From Tasks where company_domain = @domain and project_name = @projname and name = @taskname))
			BEGIN
				Insert into Tasks
				values(@domain, @projname,@taskname,@desc,@end,'Open')
				Insert into Managers_create_assign_Regular_Employees_Tasks
				values(@domain,@projname, @taskname,@manuser,null)
				set @message = 4;
			END
		else
			set @message = 3  --print('A task with the same name already exists.')
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
@domain varchar(120) , @projname varchar(200),@taskname varchar(200), @manuser varchar(100), @employee varchar(100), @message int output
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
		where company_domain = @domain and project_name = @projname and name = @taskname;
		set @message=1;
	END
else 
	 set @message = 0; --print('Someone is already working on this task')

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
@compdomain varchar(120), @projname varchar(200), @status varchar(20),@manager_username varchar(100)
AS
if(@compdomain is null or @projname is null or @status is null)
	print 'Invalid input';
else
	Select T.name,T.description,T.deadline, M.employee_username
	From Tasks T inner join Managers_create_assign_Regular_Employees_Tasks M 
	on M.company_domain=T.company_domain and M.project_name=T.project_name and T.name=M.task_name
	Where T.company_domain = @compdomain and  T.project_name = @projname and T.status = @status and M.manager_username=@manager_username;
GO

/** Manager Story 12:
-- This procedure allows a manager to review a task, providing a new deadline for rejected ones
-- it is assumed that the manager chose from the tasks with status 'Fixed' Only
**/
CREATE or alter PROC Review_task
@manager_username varchar(100), @domain varchar(120) , @projname varchar(200),@taskname varchar(200),@deadline datetime= null,@response bit, @message int output
AS
if(@taskname is null)
	set @message = 0;
else if( @response is null)
	set @message = 1;
else
	Begin
		if(@response = 1 and exists(select * from Managers_create_assign_Regular_Employees_Tasks MT where MT.company_domain=@domain and MT.project_name=@projname and MT.task_name=@taskname and MT.manager_username=@manager_username))
			begin
			Update Tasks
			set status = 'Closed'
			Where company_domain = @domain and project_name = @projname and name = @taskname;
			set @message = 3;
			end
		else
			Begin
				if(@response = 0 and exists(select * from Managers_create_assign_Regular_Employees_Tasks MT where MT.company_domain=@domain and MT.project_name=@projname and MT.task_name=@taskname and MT.manager_username=@manager_username))
					begin
						if(@deadline is null)
							set @message = 2;
						else
							begin
							Update Tasks
							set status = 'Assigned', deadline=@deadline
							Where company_domain = @domain and project_name = @projname and name = @taskname
							set @message = 3;
							end
					end
				else
					print 'You don''t have the authority to review this task. It was created by another manager.';
			end
	end
GO

--additional part for manager profile page
-- 2 View all of my possible information.

-- This procedure shows the general information of a user, we assume that the user logged in successfully
-- The second procedure can be used to view previous job titles user had
CREATE or ALTER PROC View_Personal_Info_of_Manager
@user varchar(100)
AS
SELECT *
FROM Users
WHERE username = @user
GO

Create or Alter PROC View_prev_job_titles_of_Manager
@user varchar(100)
AS
Select job_title
FROM Users_have_Previous_Job_Titles
WHERE username = @user
GO

--------------------------------------------------------------------------------------------------------------------------------

-- 3 Edit all of my personal information.

-- This procedure allows the user to edit whatever attribute he wants, except the username
CREATE OR ALTER PROC Edit_Personal_Info_of_Manager
@user varchar(100), 
@pass varchar(200)=null, 
@first varchar(60)=null,
@middle varchar(60)=null, 
@last varchar(60)=null,
@birth datetime=null,
@email varchar(120)=null,
@years int=null,
@message int output
AS
if(@pass is not null and @pass!='')
	UPDATE Users
	set password = @pass
	WHERE username = @user
if(@first is not null and @first!='')
	UPDATE Users
	set first_name = @first
	WHERE username = @user
if(@middle is not null and @middle!='')
	UPDATE Users
	set middle_name = @middle
	WHERE username = @user
if(@last is not null and @last!='')
	UPDATE Users
	set last_name = @last
	WHERE username = @user
if(@birth is not null and @birth!='')
	UPDATE Users
	set birth_date = @birth
	WHERE username = @user
if(@email is not null and @email!='')
Begin
if(not exists(Select * FROM Users WHERE email = @email))
	UPDATE Users
	set email = @email
	WHERE username = @user
else
	set @message = 0;
end
if(@years is not null and @years!='')
	UPDATE Users
	set years_of_experience = @years
	WHERE username = @user
GO

-- Here it is assumed that the user chooses one of his previous titles so the first two
-- paramters are never null
CREATE OR ALTER PROC Add_Prev_Titles_of_Manager
@user varchar(100), @newtitle varchar(120)=null, @message int = 2 output
AS
if(@newtitle is null or @newtitle='')
	set @message = 0;
else
begin
	if(exists (select * from Users_have_Previous_Job_Titles where job_title=@newtitle and @user = username))
		set @message = 1;
	else
		insert into Users_have_Previous_Job_Titles
		values (@user,@newtitle);
end
GO

-- This procedure allows user to delete one of his previous job titles
CREATE or alter PROC Delete_Prev_title_of_Manager
@user varchar(100), @oldtitle varchar(120)
AS 
DELETE FROM Users_have_Previous_Job_Titles
Where job_title = @oldtitle and username = @user
GO


--extra procedures for task comments
GO

create or alter proc retrieve_task_comments @manager_username varchar(100), @company_domain varchar(100), @project_name varchar(200) 
as

select C.task_name, C.comment_number, C.comment_content from  Tasks_have_Comments C 
where exists(select * from Managers_create_assign_Regular_Employees_Tasks M where M.manager_username=@manager_username 
					and C.company_domain = M.company_domain and C.project_name = M.project_name and C.task_name = M.task_name)
		and C.project_name=@project_name and C.company_domain=@company_domain
order by C.task_name,C.comment_number;

GO

create or alter proc add_new_task_comment  @comment_content varchar(max),
@company_domain varchar(120), @project_name varchar(200), @task_name varchar(200), @message int output
as
if(@comment_content is null or @comment_content='')
	set @message = 0;
else
	begin
		set @message = 1;
		declare @comment_number int;
		if(not exists(select * from Tasks_have_Comments where @company_domain=company_domain and @task_name=task_name and @project_name=project_name))
			set @comment_number=1;
		else
			begin
				declare @max_number int;
				select @max_number=max(comment_number) 
				from Tasks_have_Comments
				where @company_domain=company_domain and @task_name=task_name and @project_name=project_name;
				set @comment_number=@max_number+1;
			end
		insert into Tasks_have_Comments values(@company_domain,@project_name,@task_name,@comment_number,@comment_content);
	end

GO

create or alter proc retrieve_tasks_created_by_manager @manager_username varchar(100), @company_domain varchar(120), @project_name varchar(200)
as
select task_name from Managers_create_assign_Regular_Employees_Tasks 
where manager_username=@manager_username and @project_name=project_name and @company_domain=company_domain;

GO
