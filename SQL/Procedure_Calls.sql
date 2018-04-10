use iWork_team54_v1;

GO

-- TEST: search_for_Company_by_Name Procedure
EXEC search_for_Company_by_Name 'Microsoft'
EXEC search_for_Company_by_Name 'Ezz Steel'
EXEC search_for_Company_by_Name ''
EXEC search_for_Company_by_Name 'Blah Blah'
GO
-- TEST: search_for_Company_by_Address Procedure
EXEC search_for_Company_by_Address 'EGYPT'
EXEC search_for_Company_by_Address 'USA'
EXEC search_for_Company_by_Address 'Germany'
GO
-- TEST: search_for_Company_by_Type Procedure
EXEC search_for_Company_by_Type 'international'
EXEC search_for_Company_by_Type 'national'
EXEC search_for_Company_by_Type 'local'
GO
-- TEST: show_all_Companies Procedure
EXEC show_all_Companies
GO
-- TEST: view_certain_Company_Department Procedure
EXEC view_certain_Company_Department 'Microsoft'
GO
-- TEST: view_certain_Company_Department_Job_with_Vacancies Procedure
EXEC view_certain_Company_Department_Job_with_Vacancies 'Microsoft', 'Sales'
EXEC view_certain_Company_Department_Job_with_Vacancies 'Microsoft', 'Food'
GO
-- TEST: register_User Procedure
EXEC register_User @username = 'EvalUser',                     -- varchar(100)
                   @password = '123',                     -- varchar(200)
                   @first_name = 'first_mac',                   -- varchar(60)
                   @middle_name = 'middle_mac',                  -- varchar(60)
                   @last_name = 'second_mac',                    -- varchar(60)
                   @birthdate = '1997-1-15 09:01:57', -- datetime
                   @email = 'evaluser@mac.com',                        -- varchar(120)
                   @years_of_experience = 1            -- int
GO
EXEC register_User @username = 'Mac',                     -- varchar(100)
                   @password = '123',                     -- varchar(200)
                   @first_name = 'first_mac',                   -- varchar(60)
                   @middle_name = 'middle_mac',                  -- varchar(60)
                   @last_name = 'second_mac',                    -- varchar(60)
                   @birthdate = '1997-1-15 09:01:57', -- datetime
                   @email = 'mac@mac.com',                        -- varchar(120)
                   @years_of_experience = 1            -- int
GO
-- TEST: add_Job_Title Procedure
EXEC add_Job_Title 'Mac', 'Assoc. Sales Manager'
GO
-- TESTING FOR EMPTY INPUTS
EXEC register_User @username = 'Mac',                     -- varchar(100)
                   @password = '',                     -- varchar(200)
                   @first_name = '',                   -- varchar(60)
                   @middle_name = 'middle_mac',                  -- varchar(60)
                   @last_name = 'second_mac',                    -- varchar(60)
                   @birthdate = '1997-1-15 09:01:57', -- datetime
                   @email = 'mac@mac.com',                        -- varchar(120)
                   @years_of_experience = 1            -- int
GO
-- TEST: search_for_Job_with_Vacancies_by_Keyword Procedure
EXEC search_for_Job_with_Vacancies_by_Keyword 'account manager'
EXEC search_for_Job_with_Vacancies_by_Keyword 'Production'
GO
-- TEST: view_Company_by_highest_Average_Salary Procedure
EXEC view_Company_by_highest_Average_Salary
GO


-- Unregistered User/Wrong input
exec Log_in @user='blah blah',@password='adsaf'
--Job seeker
exec Log_in @user='seeker',@password='asd123'
--Manager
exec Log_in @user='AnnaWW',@password='whyaretheresomanyusers'
--Hr 
exec Log_in @user='Martin',@password='hate_speech'
--regular
exec Log_in @user='ibm_emp_prod_1',@password='password'

--Assuming a logged in user
exec View_Personal_Info_of_User @user = 'Salem'
exec View_prev_job_titles @user = 'Salem'

exec View_Personal_Info_of_User @user = 'AnnaWW'
exec View_prev_job_titles @user = 'AnnaWW'

exec View_Personal_Info_of_User @user = 'SINCLAIR'
exec View_prev_job_titles @user = 'SINCLAIR'

--Editing Personal information
exec Edit_Personal_Info @user = 'Martin', @pass = 'ProcedureCall'
exec Edit_Prev_Titles @user = 'Salem', @oldtitle = 'Coffee Farmer', @newtitle = 'Accountant'

-- Editing email to an exisiting one
exec Edit_Personal_Info @user = 'AnnaWW', @email = 'ahmed_mohamed@yahoo.ca'
-- not providing the name of the new job titles
exec Edit_Prev_Titles @user = 'AnnaWW',@oldtitle = 'Janitor'

-- Deleting one of the old titles
exec Delete_Prev_title @user = 'AnnaWW', @oldtitle = 'Janitor'

-- TEST: apply_for_Job Procedure
EXEC apply_for_Job 'omar1983', 33
GO
-- TEST: view_Interview_Questions Procedure
EXEC view_Interview_Questions 31
GO
-- TEST: save_Score_for_certain_Job Procedure
EXEC save_Score_for_certain_Job 'omar1983', 33, 80
GO
-- TEST: view_Status_of_all_Applications Procedure
EXEC view_Status_of_all_Applications 'omar1983'
GO
----------------------------------------------------------------------------------------------------------------------------
-- INSERTION: choose_Job_choose_day_off_30_annual_leaves Procedure
UPDATE Applications SET hr_employee_username = 'Qayuub' WHERE seeker_username = 'omar1983' AND job_id = 33
UPDATE Applications SET manager_username = 'AnnaWW' WHERE seeker_username = 'omar1983' AND job_id = 33
UPDATE Applications SET hr_approval = 1 WHERE seeker_username = 'omar1983' AND job_id = 33
UPDATE Applications SET manager_approval = 1 WHERE seeker_username = 'omar1983' AND job_id = 33
UPDATE dbo.Applications SET status = 'accepted' WHERE seeker_username = 'omar1983' AND job_id = 33
GO

-- TEST: choose_Job_choose_day_off_30_annual_leaves Procedure
EXEC choose_Job_choose_day_off_30_annual_leaves @username = 'omar1983', @job_id = 33, @day_off = 'Monday'
GO
----------------------------------------------------------------------------------------------------------------------------
/** User Stories: Job Seeker Story 6
first call: application Nader25 to job 8 is deleted
second call: application Nader25 to job 2 is not deleted
third call: application Nader25 to job 6 is not deleted
**/
EXEC deleteJobApplication @username ='Nader25', @job_id =  1002 
EXEC deleteJobApplication @username ='Nader25', @job_id =  2 
EXEC deleteJobApplication @username ='Nader25', @job_id =  6
GO
-----------------------------------------------------------------------------------------------------------------------------
-- Test checking out before check in 
EXEC dbo.check_out @username = 'adam_wahby' -- varchar(100)
-- checking in normally
EXEC dbo.check_in @username = 'adam_wahby' -- varchar(100)
-- checking in again
EXEC dbo.check_in @username = 'adam_wahby' -- varchar(100)
-- checking out normally
EXEC dbo.check_out @username = 'adam_wahby' -- varchar(100)
-- Checking out again
EXEC dbo.check_out @username = 'adam_wahby' -- varchar(100)
GO

-- Looking for attendance in an empty period
EXEC dbo.view_attendance_records @username = 'adam_wahby',        -- varchar(100)
                                 @start = '2016-11-21', -- date
                                 @end = '2016-11-21'    -- date

GO
-- Looking attendance normally
EXEC dbo.view_attendance_records @username = 'adam_wahby',        -- varchar(100)
                                 @start = '2017-11-21', -- date
                                 @end = '2017-12-21'    -- date

GO

EXEC dbo.apply_for_request_leave @submitter = 'Ahmed_Ramy',            -- varchar(100)
                                 @start_date = '11-25-2018', -- date
                                 @end_date = '11-30-2018',   -- date
                                 @replacement = 'amy',          -- varchar(100)
                                 @type = 'sick leave'                  -- varchar(120)

  

 --overlap
 EXEC dbo.apply_for_request_leave @submitter = 'Ahmed_Ramy',            -- varchar(100)
                                 @start_date = '11-25-2017', -- date
                                 @end_date = '11-30-2017',   -- date
                                 @replacement = 'amy',          -- varchar(100)
                                 @type = 'sick leave'                  -- varchar(120)

 

 EXEC dbo.apply_for_request_business_trip @submitter = 'adam_wahby',            -- varchar(100)
                                          @start_date = '2017-11-21', -- date
                                          @end_date = '2017-11-21',   -- date
                                          @replacement = 'ahmed_mohamed',          -- varchar(100)
                                          @destination = 'Hawaii',          -- varchar(60)
                                          @purpose = 'Meet the president'               -- varchar(200)

 

 EXEC dbo.apply_for_request_leave @submitter = 'jeff_amber',            -- varchar(100)
                                 @start_date = '11-25-2017', -- date
                                 @end_date = '11-30-2017',   -- date
                                 @replacement = 'jeff_buckley',          -- varchar(100)
                                 @type = 'accidental leave'                  -- varchar(120)



-- Viewing status of request
EXEC dbo.view_status_of_requests @username = 'Ahmed_Ramy' 

-- Deleting request 
EXEC dbo.delete_request_in_review @request_id = 0 -- int
EXEC dbo.delete_request_in_review @request_id = 1 -- int

-- Testing for Emails
EXEC dbo.send_email @sender = 'ahmed_mohamed',   -- varchar(100)
                     @subject = 'hi',  -- varchar(1000)
                     @body = 'How are you',     -- varchar(max)
                     @recepient = 'Ahmed_Ramy' -- varchar(100)
 
EXEC dbo.view_emails @username = 'Ahmed_Ramy' -- varchar(100)
 

--FOR THIS TEST PLEASE GET THE EXACT TIMESTAMP FROM THE EMAILS TABLE
EXEC dbo.reply_to_email @timestamp = '2017-11-21 13:47:23', -- datetime
                         @sender = 'ahmed_mohamed',                       -- varchar(100)
                         @recepient = 'Ahmed_Ramy',                    -- varchar(100)
                         @replySubject = 'hi',                 -- varchar(1000)
                         @replyBody = 'i am fine'                     -- varchar(max)

--Making sure the reply was received
EXEC dbo.view_emails @username = 'ahmed_mohamed' -- varchar(100)

EXEC dbo.view_announcements @username = 'adam_wahby' -- varchar(100)

/** HR Employee Story 1:
    Test calls for the procedure addJob
    Call 1: Fails because username is null
    Call 2: Fails because title is null
    Call 3: Fails because title is not formated correctly
    Call 4: New manager job is added to department M1
**/
exec addJob null,'Manager - Finance Manager', 'Manages the financial status of the department by taking the suitable decisions regarding all the transactions of the department with other financial entities within or outside of the company.',
'Manages the financial status of the department.', 2, 30000, '12/3/2018',8,5;
exec addJob 'sebastian',null, 'Manages the financial status of the department by taking the suitable decisions regarding all the transactions of the department with other financial entities within or outside of the company.',
'Manages the financial status of the department.', 2, 30000, '12/3/2018',8,5;
exec addJob 'sebastian','Finance Manager', 'Manages the financial status of the department by taking the suitable decisions regarding all the transactions of the department with other financial entities within or outside of the company.',
'Manages the financial status of the department.', 2, 30000, '12/3/2018',8,5;
exec addJob 'sebastian','Manager - Finance Manager', 'Manages the financial status of the department by taking the suitable decisions regarding all the transactions of the department with other financial entities within or outside of the company.',
'Manages the financial status of the department.', 2, 30000, '12/3/2018',8,5;
--end of test calls for addJob

/** HR Employee Story 1:
    Test calls for the procedure addJobQuestions
    Call 1: Fails because model_answer is null
    Call 2: Fails because wording is null
    Call 3: Fails because job_id is null
    Call 4: Fails because wording is an empty string.
    Call 5: New question is added to job 1
**/
exec addJobQuestions null,'True or False: The managers must arrive to work at time.',1;
exec addJobQuestions 1,null,1;
exec addJobQuestions 1,'True or False: The managers must arrive to work at time.',null;
exec addJobQuestions 1,'',1;
exec addJobQuestions 1,'True or False: The managers must arrive to work at time.',1;
--end of test calls for addJobQuestions

/** HR Story 2: Test Calls to viewJobs procedure
    Call 1: returns jobs from M1.
    Call 2: returns jobs from E1.
    Call 3: invalid username
**/
exec viewJobs 'sebastian';
exec viewJobs 'Gianna';
exec viewJobs null;
--end of test calls for viewJobs

/** HR Story 2: Test Calls to viewJobQuestions
    Call 1: returns the job questions from jobs in M1.
    Call 2: returns the job questions from jobs in E1.
**/
exec viewJobQuestions 'sebastian';
exec viewJobQuestions 'Gianna';
exec viewJobQuestions null;
--end of test calls for viewJobQuestions

/** HR Story 3 Test Calls:
    Call 1:    Change the work hours for job 12 to 7
    Call 2: Change the title of job 1 to "Manager - Part-time Senior Sales Manager"
    Call 3: Change the model answer of question 1, which belongs to job 1
**/
exec editJob @job_id=12,@work_hours=7;
exec editJob @job_id=1,@title='Manager - Part-time Senior Sales Manager';
exec editJobQuestions @question_id=1,@model_answer=0;

--end of the test calls to the procedures of story 3

-- Test HR story 4
exec viewApplicationsHR @hr_username = 'Faust'
exec viewApplicationsHR @hr_username = 'Sarutobi'
exec viewJobSeekerInfoHR @seeker_username = 'SINCLAIR'
exec viewPreviousJobTitlesForJobSeekerHR @seeker_username = 'SINCLAIR'
exec viewJobInfoHR @job_id = 1001
GO


exec evaluateApplicationHR @job_id = 1001 , @seeker_username = 'SINCLAIR' , @hr_approval = 1, @hruser = 'Faust'

exec evaluateApplicationHR @job_id = 1002 , @seeker_username = 'SINCLAIR' , @hr_approval = 0, @hruser = 'Sarutobi'

exec postAnnouncements @hr_username = 'Qayuub', @description = 'You shall not pass!', @type ='Warning' , @title ='Note to self'

--should be empty
exec view_Leave_req_Hr @hrUsername = 'Faust' 

exec view_Leave_req_Hr @hrUsername = 'Armin_55'

exec view_Business_req_Hr @hrUsername = 'Diego'

-- the request ID should be 5 PLEASE CHECK
exec Response_Req_Hr_Employee @reqid = 5, @hrusername = 'Sina' , @response = 1, @staffuser =  'jeff_amber'
 
exec View_Attendance_in_Period @start ='20170101', @end = '20171230', @username = 'adam_wahby'

-- this should fail
exec view_total_hours_in_year @username = 'adam_wahby'
-- this should work
exec view_total_hours_in_year @username = 'adam_wahby', @year = 2017

exec View_top_3_employees @month = 11, @year =2017, @hrusername = 'Martin'


------------------------------------------------------
-------- REGULAR EMPLOYEE CALLS-----------------------
--- I THINK WE SHOULD CALL MANAGERS PROCs FIRST-------
exec View_projects_of_User @user = 'ibm_emp_sales_1'

exec View_task_of_user_in_project @user = 'ibm_emp_purch_1', @projname = 'evaluation1'

exec View_Comments_of_Task @compdom = 'ibm.com',@projname = 'evaluation1', @task = 'evalta_1'
exec Change_status_to_fixed @domain = 'ibm.com', @projname = 'evaluation1', @taskname = 'evalta_1'
exec Change_status_to_Assigned @domain = 'ibm.com', @projname = 'evaluation1', @taskname = 'evalta_1'
-- PLEASE RUN THIS AGAIN FOR THE LAST PROCEDURE IN MANAGER STORIES
exec Change_status_to_fixed @domain = 'ibm.com', @projname = 'evaluation1', @taskname = 'evalta_1'


exec view_leave_req_in_manager_dep @manager = 'Salem'
exec view_business_trip_req_in_manager_dep @manager = 'Shin'

-- this should fail because there's no reason of disapproval
exec Respond_request_manager @reqid = 5, @username = 'ahmed_mohamed', @response = 0, @reason =null
-- this should work
exec Respond_request_manager @reqid = 5, @username = 'ahmed_mohamed', @response = 1, @reason =null

-- this should return one record
exec View_app_in_manager_dep @manager = 'Tatsumi23', @jobid = 1001

-- this will fail
exec Respond_application_manager @seeker_username = 'SINCLAIR', @job_id =1001, @username = 'Tatsumi23', @response = null
-- this should work
exec Respond_application_manager @seeker_username = 'SINCLAIR', @job_id =1001, @username = 'Tatsumi23', @response = 0

-- this will fail
exec create_project @projname ='evaluation', @start = null, @end ='20171220', @manuser = 'Shin'
-- this will fail
exec create_project @projname ='evaluation', @start = '20171201', @end ='20161220', @manuser = 'Shin'
-- this should work
exec create_project @projname ='evaluation1', @start = '20171201', @end ='20171220', @manuser = 'Shin'
exec create_project @projname ='evaluation2', @start = '20171201', @end ='20171220', @manuser = 'Shin'

-- Assigning employee to a project
exec assign_to_proj @employee = 'ibm_emp_sales_1',@compdomain = 'ibm.com',@projname = 'Nier',@manuser = 'AnnaWW'
-- Assigning employee to a project he is already in
exec assign_to_proj @employee = 'ibm_emp_sales_1',@compdomain = 'ibm.com',@projname = 'Nier',@manuser = 'AnnaWW'
-- Assigning an employee to another project
exec assign_to_proj @employee = 'ibm_emp_sales_1',@compdomain = 'ibm.com',@projname = 'YorHa',@manuser = 'Salem'
-- Assiging to a project by another manager in same department
exec assign_to_proj @employee = 'ibm_emp_sales_2',@compdomain = 'ibm.com',@projname = 'Nier',@manuser = 'Salem'
--This should work
exec assign_to_proj @employee='ibm_emp_purch_1' ,@compdomain='ibm.com' , @projname='evaluation1' ,@manuser = 'Shin'
exec assign_to_proj @employee='ibm_emp_purch_2' ,@compdomain='ibm.com' , @projname='evaluation1' ,@manuser = 'Shin'
--this will fail since that employee is working in evaluation1
exec assign_to_proj @employee='ibm_emp_purch_1' ,@compdomain='ibm.com' , @projname='evaluation2' ,@manuser = 'Shin' 

-- this should work
exec remove_from_project @compdomain ='ibm.com',@projname = 'evaluation1',@employee = 'ibm_emp_purch_1'


exec create_task_in_project @domain = 'ibm.com' , @projname = 'evaluation1',@taskname = 'evalta_1',@desc = 'evaluation task', @end = '20171215' ,@manuser = 'Shin'

exec assign_employee_to_task @domain = 'ibm.com' , @projname = 'evaluation1',@taskname = 'evalta_1', @manuser = 'Shin', @employee = 'ibm_emp_purch_2'
-- this should fail now since the employee has a task to do 
exec remove_from_project @compdomain ='ibm.com',@projname = 'evaluation1',@employee = 'ibm_emp_purch_2'

-- Assigning emp_1 again to check the alter_employee procedure
exec assign_to_proj @employee='ibm_emp_purch_1' ,@compdomain='ibm.com' , @projname='evaluation1' ,@manuser = 'Shin'
exec alter_employee_of_task @domain = 'ibm.com' , @projname = 'evaluation1',@taskname = 'evalta_1', @manuser = 'Shin',@employee = 'ibm_emp_purch_1'

exec View_tasks_in_proj_with_status @compdomain= 'ibm.com' , @projname = 'evaluation1', @status = 'Assigned'

----- PLEASE RUN THE change_to_fixed procedure BEFORE TRYING THIS PROCEDURE
exec Review_task @manager_username = 'Shin' ,@domain = 'ibm.com', @projname = 'evaluation1', @taskname = 'evalta_1',@deadline = '20180101' ,@response = 0