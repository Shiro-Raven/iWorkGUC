
/**
USE master ;  
GO  
DROP DATABASE iWork_team54_v1  
GO
**/

--create the database
create database iWork_team54_v1;

GO

use iWork_team54_v1;

GO

/** Create the function createCompanyEmail
    This function takes the username of a staff member.
    It then finds the domain name of the company where he is working,
    and creates his company email by appending his username to the company domain name, adding an '@' between them.
    Please note that I defined this function here because it is stored as part of the database itself.
    And it is called in the table Staff_Members.
    Therefore, it needs to be defined after the create database statement and before create Staff_Members.
**/
create function createCompanyEmail(@username varchar(100)) returns varchar(220)
begin
declare @company_domain_name varchar(120);
select @company_domain_name=D.company_domain_name
from (Departments D inner join Jobs J on D.code = J.dep_code)
inner join Staff_Members S on S.job_id=J.job_id
where S.username=@username;
return (@username+'@'+@company_domain_name);
end

GO

--create the Company_Profiles table
create table Company_Profiles(
Constraint PK_Company_Profiles Primary Key(domain_name),
domain_name varchar(120),
name varchar(120) not null,
address varchar(200),
email varchar(120) unique not null,
vision varchar(1000),
type varchar(120),
field_of_specialization varchar(120),
Constraint Type_Company_Profiles check(type='national' or type='international')
);

--create the Company_Profiles_have_Phone_Numbers table
create table Company_Profiles_have_Phone_Numbers(
Constraint PK_Company_Profiles_have_Phone_Numbers Primary Key(domain_name,phone_number),
domain_name varchar(120),
phone_number varchar(60),
Constraint FK_Company_Profiles_have_Phone_Numbers_Company_Profiles Foreign Key(domain_name)
references Company_Profiles on update cascade on delete cascade
);

--create the Announcements table
create table Announcements(
Constraint PK_Announcements Primary Key(a_id),
a_id int identity,
date as current_timestamp,
description varchar(max) not null,
type varchar(120),
title varchar(1000),
company_domain_name varchar(120),
Constraint FK_Announcements_Company_Profiles Foreign Key(company_domain_name) references Company_Profiles on update cascade on delete cascade
);

--create the Departments table
create table Departments(
Constraint PK_Departments Primary Key(code),
code varchar(500),
name varchar(120) not null,
company_domain_name varchar(120),
Constraint FK_Departments_Company_Profiles Foreign Key(company_domain_name) references Company_Profiles on update cascade on delete cascade
);

--create the Users table
create table Users(
Constraint PK_Users Primary Key(username),
username varchar(100),
password varchar(200) not null,
first_name varchar(60) not null,
middle_name varchar(60),
last_name varchar(60) not null,
birth_date datetime,
age as year(current_timestamp) - year(birth_date),
email varchar(120) unique not null,
years_of_experience int default 0
);

--create the Users_have_Previous_Job_Titles table
create table Users_have_Previous_Job_Titles(
Constraint PK_Users_have_Previous_Job_Titles Primary Key(username,job_title),
username varchar(100),
job_title varchar(120),
Constraint FK_Users_have_Previous_Job_Titles_Users Foreign Key(username) references Users on delete cascade on update cascade
);

--create the Job_Seekers table
create table Job_Seekers(
Constraint PK_Job_Seekers Primary Key(username),
username varchar(100),
Constraint FK_Job_Seekers_Users Foreign Key(username) references Users on delete cascade on update cascade
);

--create the Jobs table
create table Jobs(
Constraint PK_Jobs Primary Key(job_id),
job_id int identity,
title varchar(120) not null,
detailed_description varchar(max),
short_description varchar(1500),
minimum_years_of_experience int Constraint default_minimum_years_of_experience Default 0,
salary decimal(20,2),
application_deadline datetime not null,
work_hours int Constraint default_work_hours Default 8,
number_of_vacancies int not null,
dep_code varchar(500) not null,
Constraint Job_must_be_in_format check(title like 'HR Employee - %' or title like 'Regular Employee - %' or title like 'Manager - %'),
Constraint FK_Jobs_Departments Foreign Key(dep_code) references Departments on delete cascade on update cascade
);

--create the Staff_Members table
create table Staff_Members(
Constraint PK_Staff_Members Primary Key(username),
username varchar(100),
salary decimal(20,2),
day_off varchar(20),
number_of_leaves int Constraint default_number_of_leaves default 0,
company_email as dbo.createCompanyEmail(username),
job_id int not null,
Constraint valid_day_off Check(day_off in('Friday','Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday')),
Constraint FK_Staff_Members_Jobs Foreign Key(job_id) references Jobs on delete cascade on update cascade,
Constraint FK_Staff_Members_Users Foreign Key(username) references Users on delete cascade on update cascade
);

--create the Emails table
create table Emails(
Constraint PK_Emails Primary Key(time_stamp,sender_username),
time_stamp datetime,
sender_username varchar(100),
subject varchar(1000),
body varchar(max)
Constraint FK_Emails_Staff_Members Foreign Key(sender_username) references Staff_Members
);

--create the Staff_Members_receive_Emails table
create table Staff_Members_receive_Emails(
Constraint PK_Staff_Members_receive_Emails Primary Key(time_stamp,sender_username,recepient_username),
time_stamp datetime,
sender_username varchar(100),
recepient_username varchar(100),
Constraint FK_Staff_Members_receive_Emails_Emails Foreign Key(time_stamp,sender_username) references Emails on delete cascade on update cascade,
Constraint FK_Staff_Members_receive_Emails_Staff_Members Foreign Key(recepient_username) references Staff_Members on delete cascade on update cascade
);

--create the Attendance_Records table
create table Attendance_Records(
Constraint PK_Attendance_Records Primary Key(date,employee_username),
date date,
employee_username varchar(100),
start_time time not null,
end_time time,
Constraint valid_start_time_end_time check(end_time is null or start_time<end_time),
Constraint FK_Attendance_Records_Staff_Members Foreign Key(employee_username) references Staff_Members on delete cascade on update cascade
);

--create the Hr_Employees table
create table Hr_Employees(
Constraint PK_Hr_Employees Primary Key(username),
username varchar(100),
Constraint FK_Hr_Employees_Staff_Members Foreign Key(username) references Staff_Members on delete cascade on update cascade
);

--create the Regular_Employees table
create table Regular_Employees(
Constraint PK_Regular_Employees Primary Key(username),
username varchar(100),
Constraint FK_Regular_Employees_Staff_Members Foreign Key(username) references Staff_Members on delete cascade on update cascade
);

--create the Managers table
create table Managers(
Constraint PK_Managers Primary Key(username),
username varchar(100),
type varchar(120) not null,
Constraint FK_Managers_Staff_Members Foreign Key(username) references Staff_Members on delete cascade on update cascade
);

--create the Interview_Questions table
create table Interview_Questions(
Constraint PK_Interview_Questions Primary Key(question_id),
question_id int identity,
model_answer bit not null,
wording varchar(max) not null,
job_id int not null,
Constraint FK_Interview_Questions_Jobs Foreign Key(job_id) references Jobs on delete cascade on update cascade
);

--create the Applications table
create table Applications(
Constraint PK_Applications Primary Key(seeker_username,job_id),
seeker_username varchar(100),
job_id int,
score int,
status varchar(12) Constraint applications_default_status Default 'pending',
hr_approval bit, --we assumed that null means that he hasn't examined it yet
manager_approval bit, --we assumed that null means that he hasn't examined it yet
hr_employee_username varchar(100),
manager_username varchar(100),
Constraint score_range check(score between 0 and 100), --we assumed that the score on any test will range from 0 to 100 to make things easier for users
Constraint applications_status_values check(status='accepted' or status='pending' or status='rejected'),
Constraint FK_Applications_Managers Foreign Key(manager_username)
references Managers on delete set null on update cascade, --we assumed that the application is not deleted if the manager responsible leaves the company
Constraint FK_Applications_Hr_Employees Foreign Key(hr_employee_username)
references Hr_Employees on delete no action on update no action,
Constraint FK_Applications_Job_Seekers Foreign Key(seeker_username) references Job_Seekers on delete no action on update no action,
Constraint FK_Applications_Jobs Foreign Key(job_id) references Jobs on delete no action on update no action
);

--create the Requests table
create table Requests(
Constraint PK_Requests Primary Key(request_id),
request_id int identity,
filing_date date,
start_date date not null,
end_date date not null,
number_of_days as DATEDIFF(day, start_date, end_date),
status varchar(12) Constraint requests_default_status Default 'pending',
hr_approval bit, --starting this line, the same assumptions as in Applications were used
manager_approval bit,
manager_reason varchar(max),
hr_employee_username varchar(100),
manager_username varchar(100),
Constraint valid_requests_start_and_end_date check(start_date<=end_date),
Constraint disapproval_must_have_reason check(not (manager_approval=0 and (manager_reason is null) ) ),
Constraint requests_status_values check(status='accepted' or status='pending' or status='rejected'), --we assumed that the status of Requests has the same possible values as the status for Applications
Constraint FK_Requests_Managers Foreign Key(manager_username) references Managers on delete set null on update cascade,
Constraint FK_Requests_Hr_Employees Foreign Key(hr_employee_username) references Hr_Employees on delete no action on update no action
);

--create the Leave_Requests table
create table Leave_Requests(
Constraint PK_Leave_Requests Primary Key(request_id),
request_id int,
type varchar(120),
Constraint type_values Check(type = 'sick leave' or type='accidental leave' or type='annual leave'),
Constraint FK_Leave_Requests_Requests Foreign Key(request_id) references Requests on delete cascade on update cascade
);

--create the Business_Trip_Requests table
create table Business_Trip_Requests(
Constraint PK_Business_Trip_Requests Primary Key(request_id),
request_id int,
destination varchar(60) not null,
purpose varchar(200) not null,
Constraint FK_Business_Trip_Requests_Requests Foreign Key (request_id) references Requests on delete cascade on update cascade
);

--create the Managers_submit_Requests table
create table Managers_submit_Requests(
Constraint PK_Managers_submit_Requests Primary Key(request_id),
request_id int,
submitter_username varchar(100) not null,
replacement_username varchar(100) not null,
Constraint FK_Managers_submit_Requests_Managers_Submitter Foreign Key(submitter_username) references Managers on delete cascade on update cascade,
Constraint FK_Managers_submit_Requests_Managers_Replacement Foreign Key(replacement_username) references Managers on delete no action on update no action,
Constraint FK_Managers_submit_Requests_Requests Foreign Key(request_id) references Requests on delete no action on update no action
);

--create the Regular_Employees_submit_Requests table
create table Regular_Employees_submit_Requests(
Constraint PK_Regular_Employees_submit_Requests Primary Key(request_id),
request_id int,
submitter_username varchar(100) not null,
replacement_username varchar(100) not null,
Constraint FK_Regular_Employees_submit_Requests_Regular_Employees_Submitter Foreign Key(submitter_username)
references Regular_Employees on delete cascade on update cascade,
Constraint FK_Regular_Employees_submit_Requests_Regular_Employees_Replacement Foreign Key(replacement_username)
references Regular_Employees on delete no action on update no action,
Constraint FK_Regular_Employees_submit_Requests_Requests Foreign Key(request_id) references Requests on delete no action on update no action
);

--create the Hr_Employees_submit_Requests table
create table Hr_Employees_submit_Requests(
Constraint PK_Hr_Employees_submit_Requests Primary Key(request_id),
request_id int,
submitter_username varchar(100) not null,
replacement_username varchar(100) not null,
Constraint FK_Hr_Employees_submit_Requests_Hr_Employees_Submitter Foreign Key(submitter_username)
references Hr_Employees on delete cascade on update cascade,
Constraint FK_Hr_Employees_submit_Requests_Hr_Employees_Replacement Foreign Key(replacement_username)
references Hr_Employees on delete no action on update no action,
Constraint FK_Hr_Employees_submit_Requests_Requests Foreign Key(request_id) references Requests on delete no action on update no action
);

--create the Projects table
create table Projects(
Constraint PK_Projects Primary Key(company_domain, name),
company_domain varchar(120),
name varchar(200),
start_date datetime not null,
end_date datetime not null,
defining_manager_username varchar(100),
Constraint valid_projects_start_date_end_date check(start_date<=end_date),
Constraint FK_Projects_Managers Foreign Key(defining_manager_username) references Managers on delete set null on update cascade,
Constraint FK_Projects_Company_Profiles Foreign Key(company_domain) references Company_Profiles on delete no action on update no action
);

--create the Tasks table
create table Tasks(
Constraint PK_Tasks Primary Key(company_domain,project_name,name),
company_domain varchar(120),
project_name varchar(200),
name varchar(200),
description varchar(max),
deadline datetime not null,
status varchar(20) Constraint tasks_default_status Default 'Open',
Constraint tasks_status_values Check(status='Open' or status='Assigned' or status='Fixed' or status='Closed'),
Constraint FK_Tasks_Projects Foreign Key(company_domain, project_name) references Projects on delete cascade on update cascade,
);

--create the Tasks_have_Comments table
create table Tasks_have_Comments(
Constraint PK_Tasks_have_Comments Primary Key(company_domain,project_name,task_name,comment_number),
company_domain varchar(120),
project_name varchar(200),
task_name varchar(200),
comment_number int,
comment_content varchar(max) not null,
Constraint FK_Tasks_have_Comments_Tasks Foreign Key(company_domain,project_name,task_name) references Tasks on delete cascade on update cascade
);

--create the Managers_assign_Projects_Regular_Employees
create table Managers_assign_Projects_Regular_Employees(
Constraint PK_Managers_assign_Projects_Regular_Employees Primary Key(company_domain,project_name,employee_username),
company_domain varchar(120),
project_name varchar(200),
employee_username varchar(100),
manager_username varchar(100),
Constraint FK_Managers_assign_Projects_Regular_Employees_Managers Foreign Key(manager_username)
references Managers on delete set null on update cascade,
Constraint FK_Managers_assign_Projects_Regular_Employees_Regular_Employees Foreign Key(employee_username)
references Regular_Employees on delete no action on update no action,
Constraint FK_Managers_assign_Projects_Regular_Employees_Projects Foreign Key(company_domain,project_name)
references Projects on delete no action on update no action
);

--create the Managers_create_assign_Regular_Employees_Tasks
create table Managers_create_assign_Regular_Employees_Tasks(
Constraint PK_Managers_create_assign_Regular_Employees_Tasks Primary Key(company_domain,project_name,task_name),
company_domain varchar(120),
project_name varchar(200),
task_name varchar(200),
manager_username varchar(100),
employee_username varchar(100),
Constraint FK_Managers_create_assign_Regular_Employees_Tasks_Tasks Foreign Key(company_domain,project_name,task_name)
references Tasks on delete cascade on update cascade,
Constraint FK_Managers_create_assign_Regular_Employees_Tasks_Managers Foreign Key(manager_username)
references Managers on delete no action on update no action,
Constraint FK_Managers_create_assign_Regular_Employees_Tasks_Regular_Employees Foreign Key(employee_username)
references Regular_Employees on delete no action on update no action
);