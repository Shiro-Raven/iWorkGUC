--------------------------------------------
----------- MANDATORY INSERTIONS -----------
--------------------------------------------
--use the database
use iWork_team54_v1;

--insert three companies
Go

insert into Company_Profiles Values('microsoft.com','Microsoft',
'10260 SW Greenburg Rd #600, Tigard, OR 97223, USA',
'info@microsoft.com','To empower every person and every organization on the planet to achieve more.',
'international','Computer Hardware and Software');

insert into Company_Profiles Values('ezzsteel.com','Ezz Steel','8 El Sad El Aaly St., Cairo, Egypt', 'info@ezzsteel.com',
'To sustain our position as the leading steel producer in the Middle East region and to remain a global player in the international steel trade, with a brand name that is synonymous with quality and reliability.'
,'national','Steel');

insert into Company_Profiles Values ('ibm.com','IBM','3605 US-52, Rochester, MN 55901, USA','info@ibm.com',
'To be the world’s most successful and important information technology company. Successful in helping out customers apply technology to solve their problems. Successful in introducing this extraordinary technology to new customers. Important, because we will continue to be the basic resource of much of what is invested in this industry',
'international','Computer Hardware');
--end of the insertions of companies

--insert three departments in each company
Go

insert into Departments Values('M1','Sales','microsoft.com');
insert into Departments Values('M2','Production','microsoft.com');
insert into Departments Values('M3','Marketing','microsoft.com');

insert into Departments Values('E1','Sales','ezzsteel.com');
insert into Departments Values('E2','Purchasing','ezzsteel.com');
insert into Departments Values('E3','Accounting and Finance','ezzsteel.com');

insert into Departments Values('I1','Sales','ibm.com');
insert into Departments Values('I2','Production','ibm.com');
insert into Departments Values('I3','Purchasing','ibm.com');
--end of the insertions of departments


--insert jobs for the managers

Go

--sales
--job 1
insert into Jobs Values('Manager - Senior Sales Manager',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects. The senior sales executive will be the most experienced member of the sales team. They will have superior analytical skills and a firm grasp on their customers throughout the sales process.',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects.',
10, 30000, '10/23/2017',9,0,'M1');
--job 2
insert into Jobs Values('Manager - Junior Account Manager',
'An account manager is a person who works for a company and is responsible for the management of sales and relationships with particular customers. An account manager maintains the company''s existing relationships with a client or group of clients, so that they will continue using the company for business.',
'An account manager is responisble for the management of sales and relationships with particular customers.',
3,12000,'1/20/2018',8,2,'M1');
--job 3
insert into Jobs Values('Manager - Senior Sales Manager',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects. The senior sales executive will be the most experienced member of the sales team. They will have superior analytical skills and a firm grasp on their customers throughout the sales process.',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects.',
6, 15000, '10/23/2019',7,3,'E1');
--job 4
insert into Jobs Values('Manager - Junior Account Manager',
'An account manager is a person who works for a company and is responsible for the management of sales and relationships with particular customers. An account manager maintains the company''s existing relationships with a client or group of clients, so that they will continue using the company for business.',
'An account manager is responisble for the management of sales and relationships with particular customers.',
1,5000,'1/20/2018',7,0,'E1');
--job 5
insert into Jobs Values('Manager - Senior Sales Manager',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects. The senior sales executive will be the most experienced member of the sales team. They will have superior analytical skills and a firm grasp on their customers throughout the sales process.',
'A Senior Sales Manager is responsible for building business success by identifying, qualifying and selling prospects.',
15, 70000, '10/23/2016',9,0,'I1');
--job 6
insert into Jobs Values('Manager - Junior Account Manager',
'An account manager is a person who works for a company and is responsible for the management of sales and relationships with particular customers. An account manager maintains the company''s existing relationships with a client or group of clients, so that they will continue using the company for business.',
'An account manager is responisble for the management of sales and relationships with particular customers.',
5,30000,'1/20/2018',9,10,'I1');
--Production
--job 7
insert into Jobs Values('Manager - Senior Production Manager',
'Production managers ensure that manufacturing processes run reliably and efficiently. Responsibilities of the job include: planning and organising production schedules, assessing project and resource requirements, estimating, negotiating and agreeing budgets and timescales with clients and managers, ensuring that health and safety regulations are met, determining quality control standards, overseeing production processes, re-negotiating timescales or schedules as necessary, selecting, ordering and purchasing materials, organising the repair and routine maintenance of production equipment, and liaising with buyers and marketing and sales staff, supervising the work of junior, staff organising relevant training sessions. In larger companies, there may be close links between production management and general or strategic management and marketing or finance roles.',
'Production managers ensure that manufacturing processes run reliably and efficiently.',
20,90000,'3/15/2017',8,0,'M2');
--job 8
insert into Jobs Values('Manager - Machine Shop Production Manager',
'Assigns daily production duties to production operators. Works on design of new production tooling. Troubleshoot mechanical failures and perform basic repairs and maintenance on machines. Verify production set-up and production programming.',
'Supervises the machine shop production',
8,30000,'12/10/2018',7,1,'M2');
--job 9
insert into Jobs Values('Manager - Senior Production Manager',
'Production managers ensure that manufacturing processes run reliably and efficiently. Responsibilities of the job include: planning and organising production schedules, assessing project and resource requirements, estimating, negotiating and agreeing budgets and timescales with clients and managers, ensuring that health and safety regulations are met, determining quality control standards, overseeing production processes, re-negotiating timescales or schedules as necessary, selecting, ordering and purchasing materials, organising the repair and routine maintenance of production equipment, and liaising with buyers and marketing and sales staff, supervising the work of junior, staff organising relevant training sessions. In larger companies, there may be close links between production management and general or strategic management and marketing or finance roles.',
'Production managers ensure that manufacturing processes run reliably and efficiently.',
10,30000,'3/15/2018',5,1,'I2');
--job 10
insert into Jobs Values('Manager - Machine Production Manager',
'Assigns daily production duties to production operators. Works on design of new production tooling. Troubleshoot mechanical failures and perform basic repairs and maintenance on machines. Verify production set-up and production programming.',
'Supervises the machine shop production',
5,10000,'12/10/2018',8,3,'I2');
--Marketing
--job 11
insert into Jobs Values('Manager - Advertising Account Manager',
'Advertising account manager. The advertising account manager is the link between the client and the entire agency team. Along with their team the account manager acts as both the salesperson for the agency and as the client''s representative within the agency.',
'The advertising account manager is the link between the client and the entire agency.',
3,12000,'12/12/2012',7,0,'M3');
--job 12
insert into Jobs Values('Manager - Campaign Manager',
'Plan advertising and promotional campaigns. Plan advertising, including which media to advertise in, such as radio, television, print, online media, and billboards. Negotiate advertising contracts.',
'Plans and Manages Campaigns',
0,3000,'2/17/2018',5,2,'M3');
--purchasing
--job 13
insert into Jobs Values('Manager - Purchasing Manager',
'Purchasing Managers 1) Maintain records of goods ordered and received. 2) Locate vendors of materials, equipment or supplies, and interview them in order to determine product availability and terms of sales. ... 6) Review purchase order claims and contracts for conformance to company policy.',
'Manages the purchases of the company',
10,50000,'2/18/2015',5,0,'E2');
--job 14
insert into Jobs Values('Manager - Purchasing Manager',
'Purchasing Managers 1) Maintain records of goods ordered and received. 2) Locate vendors of materials, equipment or supplies, and interview them in order to determine product availability and terms of sales. ... 6) Review purchase order claims and contracts for conformance to company policy.',
'Manages the purchases of the company',
2,65500,'2/18/2014',9,0,'I3');
--accounting and finance
--job 15
insert into Jobs Values('Manager - Accounting Manager',
'Accounting Manager Job Responsibilities: Establishes financial status by developing and implementing systems for collecting, analyzing, verifying, and reporting financial information; managing staff.',
'Establishes financial status',
5,20100,'2/3/2019',8,4,'E3');
--end of the job insertions for managers

--insert jobs for Hr Employees
GO
--job 16
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
1,5000,'4/4/2013',8,0,'M1');
--job 17
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
3,5500,'5/5/2018',8,1,'M2');
--job 18
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
1,5000,'4/4/2013',8,0,'M3');
--job 19
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
2,6000,'3/2/2014',8,0,'E1');
--job 20
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
1,7000,'4/4/2015',8,0,'E2');
--job 21
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
5,5000,'4/4/2018',8,4,'E3');
--job 22
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
20,120000,'5/5/2019',8,2,'I1');
--job 23
insert into Jobs Values('HR Employee - Junior HR Generalist',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
10,90000,'5/5/2019',8,3,'I2');
--job 24
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
20,120000,'5/5/2019',8,2,'I3');
--job 25
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
10,100000,'5/5/2018',8,2,'M1');
--job 26
insert into Jobs Values('HR Employee - Junior HR Generalist',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
5,80000,'5/5/2013',8,0,'M2');
--job 27
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
15,10000,'5/5/2011',8,0,'M3');
--job 28
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
12,103000,'5/6/2018',8,1,'E1');
--job 29
insert into Jobs Values('HR Employee - Junior HR Generalist',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Junior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
0,8000,'5/7/2013',8,0,'E2');
--job 30
insert into Jobs Values('HR Employee - Senior HR Generalist',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers. The most advanced generalists handle tasks that affect the strategic direction of the company and the HR department. For example, a senior HR generalist might handle an informal employee complaint from the investigative stage through to resolution by mediation with government agencies, such as the U.S. Equal Employment Opportunity Commission.',
'Senior HR generalists'' duties range from screening employment applications to negotiating group rates with health insurance providers.',
1,10000,'5/8/2011',8,0,'E3');
--job 31
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
0,5000,'4/10/2013',7,0,'I1');
--job 32
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
0,5500,'5/25/2018',6,1,'I2');
--job 33
insert into Jobs Values('HR Employee - HR Officer',
'Human resources (HR) officers are responsible for hiring, developing and looking after employees. This involves functions such as training and monitoring performance.',
'Hiring, developing and looking after employees',
0,5000,'1/14/2018',9,4,'I3');
--end of the insertion of jobs for HR Employees

--insert jobs for Regular Employees
GO
--job 34
insert into Jobs Values('Regular Employee - Machine Operator',
'Machine operators, also knows as machinists or tool and die makers, work with heavy machinery from setup to operation. Machine operators might work with computer-controlled equipment or more mechanically based machines to make sure they are set up properly, working well, and producing quality product.',
'Machinists or tool and die makers', 5, 3000,'3/20/2019',9,3,'M2');
--job 35
insert into Jobs Values('Regular Employee - Machine Operator',
'Machine operators, also knows as machinists or tool and die makers, work with heavy machinery from setup to operation. Machine operators might work with computer-controlled equipment or more mechanically based machines to make sure they are set up properly, working well, and producing quality product.',
'Machinists or tool and die makers', 6, 9000,'5/1/2011',10,0,'I2');
--end of job insertions for Regular Employees

--insert Users into departments
GO
--to-be-managers
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('michael_ronald','1234hellow','Michael','Adam','Ronald','1/1/1970','michael_the_first_user@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('gonzalez_roberto','abcdeILovetheAlphabet','Gonzalez','Roberto','Arnold','1/1/1975','gonzalez_the_second_user@gmail.com',30);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('ahmed_mohamed','very_creative_name','Ahmed','Mohamed','Mohamed','1/12/1980','ahmed_mohamed@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Yoshio_Tanaka','konosekainochuushin','Yoshio',null,'Tanaka','6/12/1950','yoshio_tanaka@hotmail.com',30);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Robert_Speta','weather_forcaster','Robert','Daniel','Speta','7/12/1988','speta@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Ken_Siemens','1329492024','Ken','Yoshiko','Siemens','1/1/1990','ken_siemens@yahoo.ca',20);

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('adam_wahby','1234','Adam','Adam','Wahby','1/1/1950','adam_wahby@gmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Mustafa_Said','189273','Mustafa','Ahmed','Said','4/23/1975','mustafa_said992@gmail.com',25);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('latif','seventyfourplusfive','Samy','Mohamed','Latif','1/12/1989','Samy_Latif@yahoo.ca',25);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Mona_Ahmed','mona2342','Mona','Ahmed','Samir','6/12/1955','mona_samir@hotmail.com',30);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('yui','japanese23453','Yui',null,'Sakakibara','7/12/1990','yui_sakakiabara@yahoo.jp',23);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Lobna_Ahmed','1329492022222222434','Lobna','Ahmed','Ahmed','10/22/1970','lobna_ahmed@yahoo.ca',21);

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Salem','1234helsssslow','Salem','Ahmed','Salem','12/22/1969','salem_salem@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('AnnaWW','whyaretheresomanyusers','Anna','Roberto','Ron','7/3/1965','annaRR@gmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Fredrick','good name','Fredrick','Angel','Angelo','1/12/1980','fredrick_angelo@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Tatsumi23','sekainoowari','Tatsumi',null,'Eda','6/12/1970','eda@hotmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Shin','weather_shin','Shin','Armin','Sanders','7/12/1948','shin_24@yahoo.ca',25);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Roberts','1329491111','Elvis','Ken','Roberts','2/21/1960','elvis_roberts@yahoo.ca',30);

--end of the users to be managers

--to-be-HR-Employees

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('sebastian','Sebasyou','Sebastian','Angel','Simon','2/2/1980','sebastian@yahoo.ca',21);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('ciel','kuroshitsuji','Ciel','Kuro','Shiro','1/1/1985','kuro@gmail.com',31);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Sina','vee_sina_see','Sina','Eric','Sam','12/12/1995','sina@yahoo.ca',21);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Ahmed_Ramy','thismeansdespair','Ahmed','Ramy','Abdelrahman','6/12/1950','ahmed_ramy@hotmail.com',24);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Samuel_jones','weather_r','Samuel','Amber','Jones','7/12/1990','jones_amber@yahoo.ca',21);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Kenshirou','omae_wa_mou_shindeiru','Kenshirou','Hokuto','Shinken','1/1/1980','ken_shirou@yahoo.ca',35);

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Gianna','2095750927','Gianna','Daniel','Sams','1/1/1970','gianna_sams@gmail.com',22);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Kasim','18927ssss3','Kasim','Ahmed','Tawfeeq','8/22/1975','kasim_tawfeeq@gmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('fareed','seventyfour','Samer','Mohamed','Fareed','1/12/1989','Samerfareed@yahoo.ca',25);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Daniella','daniella42','Daniella','Moses','Jesus','6/12/1965','daniella_jesus@hotmail.com',31);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('amy','jap23453','Amy','Andrew','Toda','7/12/1990','amy_andrew@yahoo.jp',22);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Erika','13294ssss34aa','Erika','Hilton','Watson','1/9/1950','erika_hilton@yahoo.ca',20);

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Qayuub','thewordsofapassword','Samir','Ahmed','Qayuub','12/22/1979','samir_qayuub@yahoo.ca',21);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Martin','hate_speech','Martin','Donald','Trump','7/3/1975','martin_trump@gmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Faust','fromthefamousgermanstory','Frank','Dan','Faust','12/12/1959','faust@yahoo.ca',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Sarutobi','1223311332211','Tatsurou',null,'Sarutobi','6/12/1970','sarutobi@hotmail.com',20);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Armin_55','the_colossal_titan','Armin','Eren','Mikasa','7/12/1960','armin_55@yahoo.ca',25);
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Diego','111rrrrrqddcjsl','Diego','Gunther','Graham','2/21/1960','diego_graham@yahoo.ca',30);

--end of the users to be HR Employees

--end of the user insertions

--insert the Staff_Members
GO
--M1 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('michael_ronald',30000,'Saturday',30,1);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('gonzalez_roberto',12000,'Sunday',30,2);
--M2 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('ahmed_mohamed',90000,'Sunday',30,7);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Yoshio_Tanaka',30000,'Sunday',30,8);
--M3 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Robert_Speta',12000,'Sunday',30,11);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Ken_Siemens',3000,'Sunday',30,12);
--E1 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('adam_wahby',15000,'Sunday',30,3);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Mustafa_Said',5000,'Sunday',30,4);
--E2 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('latif',50000,'Sunday',30,13);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Mona_Ahmed',50000,'Sunday',30,13);
--E3 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('yui',20100,'Sunday',30,15);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Lobna_Ahmed',20100,'Saturday',30,15);
--I1 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Salem',70000,'Sunday',30,5);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('AnnaWW',30000,'Sunday',30,6);
--I2 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Fredrick',30000,'Sunday',30,9);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Tatsumi23',10000,'Sunday',30,10);
--I3 managers
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Shin',65500,'Sunday',30,14);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Roberts',65500,'Saturday',30,14);
--M1 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('sebastian',5000,'Sunday',30,16);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('ciel',100000,'Saturday',30,25);
--M2 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Sina',5500,'Sunday',30,17);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Ahmed_Ramy',80000,'Saturday',30,26);
--M3 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Samuel_jones',5000,'Sunday',30,18);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Kenshirou',10000,'Saturday',30,27);
--E1 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Gianna',6000,'Sunday',30,19);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Kasim',103000,'Saturday',30,28);
--E2 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('fareed',7000,'Sunday',30,20);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Daniella',8000,'Saturday',30,29);
--E3 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('amy',5000,'Sunday',30,21);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Erika',10000,'Saturday',30,30);
--I1 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Qayuub',120000,'Sunday',30,22);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Martin',5000,'Saturday',30,31);
--I2 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Faust',90000,'Sunday',30,23);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Sarutobi',5500,'Saturday',30,32);
--I3 HR
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Armin_55',5000,'Sunday',30,33);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id)
Values ('Diego',120000,'Saturday',30,24);
--end of staff members insertions

--insert managers into managers table
insert into Managers Values('michael_ronald','Technical');
insert into Managers Values('gonzalez_roberto','HR');
insert into Managers Values('ahmed_mohamed','Technical');
insert into Managers Values('Yoshio_Tanaka','Technical');
insert into Managers Values('Robert_Speta','HR');
insert into Managers Values('Ken_Siemens','Technical');
insert into Managers Values('adam_wahby','Technical');
insert into Managers Values('Mustafa_Said','Technical');
insert into Managers Values('latif','HR');
insert into Managers Values('Mona_Ahmed','Technical');
insert into Managers Values('yui','Technical');
insert into Managers Values('Lobna_Ahmed','Technical');
insert into Managers Values('Salem','Technical');
insert into Managers Values('AnnaWW','HR');
insert into Managers Values('Fredrick','Technical');
insert into Managers Values('Tatsumi23','Technical');
insert into Managers Values('Shin','HR');
insert into Managers Values('Roberts','Technical');
--end of insertions into Managers table

--insert HR Employees into Hr_Employees table
insert into Hr_Employees Values('sebastian');
insert into Hr_Employees Values('ciel');
insert into Hr_Employees Values('Sina');
insert into Hr_Employees Values('Ahmed_Ramy');
insert into Hr_Employees Values('Samuel_jones');
insert into Hr_Employees Values('Kenshirou');
insert into Hr_Employees Values('Gianna');
insert into Hr_Employees Values('Kasim');
insert into Hr_Employees Values('fareed');
insert into Hr_Employees Values('Daniella');
insert into Hr_Employees Values('amy');
insert into Hr_Employees Values('Erika');
insert into Hr_Employees Values('Qayuub');
insert into Hr_Employees Values('Martin');
insert into Hr_Employees Values('Faust');
insert into Hr_Employees Values('Sarutobi');
insert into Hr_Employees Values('Armin_55');
insert into Hr_Employees Values('Diego');


--------------------------------------------
------ EXTRA INSERTIONS FOR TESTING --------
--------------------------------------------

Insert into Users(username,password,first_name,last_name,email)
values('SINCLAIR','1000212','Roberta','Sinclair','ibmreg1@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_sales_1','password','Yorha Model 9','Type S','ibmreg7@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_sales_2','password','Yorha Model 2','Type B','ibmreg2@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_prod_1','password','Yorha Model 2','Type A','ibmreg3@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_prod_2','password','Devola','Gestalt','ibmreg4@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_purch_1','password','Emil','Karma','ibmreg5@me.me')
Insert into Users(username,password,first_name,last_name,email)
values('ibm_emp_purch_2','password','Grimoire','Weiss','ibmreg6@me.me')

Insert into Users_have_Previous_Job_Titles
values('SINCLAIR','President')
Insert into Users_have_Previous_Job_Titles
values('AnnaWW','Vice President')
Insert into Users_have_Previous_Job_Titles
values('AnnaWW','Janitor')
Insert into Users_have_Previous_Job_Titles
values('Martin','Grocer')
Insert into Users_have_Previous_Job_Titles
values('Tatsumi23','Mangaka')
Insert into Users_have_Previous_Job_Titles
values('Shin','Grim Reaper')
Insert into Users_have_Previous_Job_Titles
values('Roberts','Taco man')
Insert into Users_have_Previous_Job_Titles
values('Salem','Coffee Farmer')

insert into Job_Seekers Values('SINCLAIR');

set Identity_insert Jobs ON 
Insert into Jobs(job_id, title, application_deadline,number_of_vacancies, dep_code)
values(1000,'Regular Employee - Salesman',5/6/2020,5,'I1')
Insert into Jobs(job_id, title, application_deadline,number_of_vacancies, dep_code)
values(1001,'Regular Employee - Proliterean',5/6/2020,5,'I2')
Insert into Jobs(job_id, title, application_deadline,number_of_vacancies, dep_code)
values(1002,'Regular Employee - Bourgeoisie',5/6/2020,5,'I3')
set Identity_insert Jobs OFF

Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_sales_1',1000,'Saturday',30)
Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_sales_2',1000,'Saturday',30)
Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_prod_1',1001,'Saturday',30)
Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_prod_2',1001,'Saturday',30)
Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_purch_1',1002,'Saturday',30)
Insert into Staff_Members(username,job_id,day_off,number_of_leaves)
values('ibm_emp_purch_2',1002,'Saturday',30)

insert into Regular_Employees
values('ibm_emp_sales_1')
insert into Regular_Employees
values('ibm_emp_sales_2')
insert into Regular_Employees
values('ibm_emp_prod_1')
insert into Regular_Employees
values('ibm_emp_prod_2')
insert into Regular_Employees
values('ibm_emp_purch_1')
insert into Regular_Employees
values('ibm_emp_purch_2')


insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','YorHa','20110125','20111212','Salem')
insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','Nier','20100125','20171212','AnnaWW')
insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','CoD','20110125','20171212', 'Fredrick')
insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','PSY','20110125','20171212','Tatsumi23')
insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','Tokyo Ghoul','20110125','20171212','Roberts')
insert into Projects(company_domain,name,start_date,end_date,defining_manager_username)
values('ibm.com','Skillet','20110125','20171212','Shin')

insert into Tasks(company_domain,project_name,name, deadline)
values('ibm.com','YorHa','YorHa_1','11/30/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','YorHa','YorHa_2','2/3/2018')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Nier','Nier_1','10/23/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Nier','Nier_2','2/4/2018')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','CoD','CoD_1','5/6/2018')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','CoD','CoD_2','6/7/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','PSY','PSY_1','7/8/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','PSY','PSY_2','8/7/2018')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Tokyo Ghoul','TK_1','9/9/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Tokyo Ghoul','TK_2','10/12/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Skillet','sk_1','2/14/2019')
insert into Tasks(company_domain,project_name,name,deadline)
values('ibm.com','Skillet','sk_2','3/23/2018')

insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','YorHa','YorHa_1','Salem')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','YorHa','YorHa_2','Salem')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Nier','Nier_1','AnnaWW')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Nier','Nier_2','AnnaWW')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','CoD','CoD_1','Fredrick')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','CoD','CoD_2','Fredrick')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','PSY','PSY_1','Tatsumi23')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','PSY','PSY_2','Tatsumi23')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Tokyo Ghoul','TK_1','Roberts')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Tokyo Ghoul','TK_2','Roberts')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Skillet','sk_1','Shin')
insert into Managers_create_assign_Regular_Employees_Tasks(company_domain,project_name,task_name,manager_username)
values('ibm.com','Skillet','sk_2','Shin')

insert into Requests(start_date,end_date)
values('20171010','20171111')
insert into Requests(start_date,end_date)
values('20171010','20171111')
insert into Leave_Requests Values(1,'sick leave');

insert into Business_Trip_Requests Values(2,'USA','Purchasing Machinery');
insert into Hr_Employees_submit_Requests
values(2,'Qayuub','Martin')
insert into Regular_Employees_submit_Requests
values(2,'ibm_emp_purch_2','ibm_emp_purch_1')

--insertions to test Job Seeker Story 6
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('Nader25','theseeker','Nader','Mohannad','Yasser','1/1/1980','nader_yasser@yahoo.ca',20);
insert into Job_Seekers Values('Nader25');
insert Applications(seeker_username,job_id,score)
values('SINCLAIR',1001,65)
insert Applications(seeker_username,job_id,score)
values('SINCLAIR',1002,98)
insert Applications(seeker_username,job_id,score)
values('Nader25',1001,56)
insert Applications(seeker_username,job_id,score,hr_approval,hr_employee_username)
values('Nader25',1002,56,1,'Diego')

-- INSERTION to test Job seeker story 1
INSERT INTO Users VALUES ('omar1983', 'password123', 'Omar', 'Darwish', 'Ali', '11-27-1983', 34, 10)
INSERT INTO Job_Seekers VALUES ('omar1983')
GO

-- INSERTION to test Job seeker story 2
INSERT INTO dbo.Interview_Questions (model_answer, wording, job_id) VALUES (1, 'Are You Willing To Die For This Job?', 31)
INSERT INTO dbo.Interview_Questions (model_answer, wording, job_id) VALUES (0, 'Will You Harm Any Of Your Co-Mates?', 31)
INSERT INTO dbo.Interview_Questions (model_answer, wording, job_id) VALUES (0, 'Have You Ever Done A Crime Before?', 31)
GO


--an application that can be deleted
insert into Applications(seeker_username, job_id, score, status, hr_approval, manager_approval, hr_employee_username, manager_username)
Values ('Nader25',8,80,'pending',null,null,'Sina','ahmed_mohamed');
--an appilcation that cannot be deleted because it is not being reviewed
insert into Applications(seeker_username, job_id, score, status, hr_approval, manager_approval, hr_employee_username, manager_username)
Values ('Nader25',2,80,'accepted',null,null,'sebastian','michael_ronald');
--a third application that will not be deleted
insert into Applications(seeker_username, job_id, score, status, hr_approval, manager_approval, hr_employee_username, manager_username)
Values ('Nader25',6,80,'rejected',null,null,'Martin','Salem');



--insertions to test Job Seeker Story 2
INSERT INTO Users
VALUES ('seeker', 'asd123', 'see', '', 'ker', GETDATE(), 'seeker@awesome.com', 50)

INSERT INTO Job_Seekers
VALUES ('seeker')


INSERT INTO Interview_Questions (model_answer, wording, job_id)
VALUES (1, 'Are You Going To Do Your Best For This Job?', 10)

INSERT INTO Interview_Questions (model_answer, wording, job_id)
VALUES (1, 'Are You Going To Do Your Best For This Company?', 10)


-- Insertions for staff members
insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('jeff_amber','1234','Jeff','Amber','Wahby','1/1/1950','jeff_wahby@gmail.com',20);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id) Values ('jeff_amber',15000,'Sunday',30,34);
insert into Regular_Employees Values('jeff_amber');

insert into Users(username, password, first_name, middle_name, last_name, birth_date, email, years_of_experience)
Values('jeff_buckley','1234','Jeff','Buckley','Wahby','1/1/1950','buckley_wahby@gmail.com',20);
insert into Staff_Members (username, salary, day_off, number_of_leaves, job_id) Values ('jeff_buckley',15000,'Sunday',30,34);
insert into Regular_Employees Values('jeff_buckley');

-- Insertions for staff members story 10
insert into Announcements (description,type,title,company_domain_name,date) values ('you have an assignment','news','urgent','ezzsteel.com','2017-12-15')
insert into Announcements (description,type,title,company_domain_name,date) values ('assignment has been cancelled','news','urgent','ibm.com','2017-12-15')
insert into Announcements (description,type,title,company_domain_name,date) values ('sorry assignment has not been cancelled ','news','urgent','microsoft.com','2017-12-15')