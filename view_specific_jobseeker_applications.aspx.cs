using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Text;

public partial class view_specific_jobseeker_applications : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string seeker_username = Session["view_applications_specific_jobseeker"].ToString();
        string job_id = Session["manage_applications_specific_job_id"].ToString();
        string manager_username = Session["username"].ToString();
        //establish connection
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        //reference procedure
        SqlCommand cmd = new SqlCommand("View_specific_app_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        cmd.Parameters.Add(new SqlParameter("@manager", manager_username));
        cmd.Parameters.Add(new SqlParameter("@jobid", job_id));
        cmd.Parameters.Add(new SqlParameter("@seeker_username", seeker_username));

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        while (rdr.Read())
        {
            specific_app_form.Controls.Add(new Literal
            {
                Text = "<H1>All Details</H1><br/><H2>Application Details</H2><p>"
            + "Job Seeker Username: " + rdr.GetValue(rdr.GetOrdinal("seeker_username")).ToString()
            + "<br/>Job Id: " + rdr.GetValue(rdr.GetOrdinal("job_id")).ToString()
            + "<br/>Score: " + rdr.GetValue(rdr.GetOrdinal("score")).ToString() + " out of 100"
            + "<br/>HR Approval: " + "approved by " + rdr.GetValue(rdr.GetOrdinal("hr_employee_username")).ToString()
            + "<br/>Status: " + rdr.GetValue(rdr.GetOrdinal("status")).ToString() + "</p>"
            });
        }
        conn.Close();
        //add job details
        conn = new SqlConnection(connStr);
        cmd = new SqlCommand("View_job_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        cmd.Parameters.Add(new SqlParameter("@manager", manager_username));
        cmd.Parameters.Add(new SqlParameter("@job_id", job_id));

        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        while (rdr.Read())
        {
            specific_app_form.Controls.Add(new Literal
            {
                //job_id, title, detailed_description, short_description, minimum_years_of_experience, 
                //salary, application_deadline, work_hours, number_of_vacancies, dep_code
                Text = "<br/><H2>Job Details</H2><p>"
           + "Job ID: " + rdr.GetValue(rdr.GetOrdinal("job_id")).ToString()
           + "<br/>Title: " + rdr.GetValue(rdr.GetOrdinal("title")).ToString()
           + "<br/>Detailed Description: " + rdr.GetValue(rdr.GetOrdinal("detailed_description")).ToString()
           + "<br/>Short Description: " + rdr.GetValue(rdr.GetOrdinal("short_description")).ToString()
           + "<br/>Minimum Years of Experience: " + rdr.GetValue(rdr.GetOrdinal("minimum_years_of_experience")).ToString()
           + "<br/>Salary: " + rdr.GetValue(rdr.GetOrdinal("salary")).ToString()
           + "<br/>Application Deadline: " + rdr.GetValue(rdr.GetOrdinal("application_deadline")).ToString()
           + "<br/>Work Hours: " + rdr.GetValue(rdr.GetOrdinal("work_hours")).ToString()
           + "<br/>Number of Vacancies: " + rdr.GetValue(rdr.GetOrdinal("number_of_vacancies")).ToString()
           + "<br/>Department Code: " + rdr.GetValue(rdr.GetOrdinal("dep_code")).ToString() + "</p>"
            });
        }

        //add job_seeker details
        conn.Close();
        conn = new SqlConnection(connStr);
        cmd = new SqlCommand("View_seeker_data_in_app", conn);
        cmd.CommandType = CommandType.StoredProcedure;
        conn.Open();

        cmd.Parameters.Add(new SqlParameter("@user", seeker_username));


        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        while (rdr.Read())
        {
            specific_app_form.Controls.Add(new Literal
            {
                //s.first_name,s.middle_name, s.last_name, s.years_of_experience, s.email, s.age
                Text = "<br/><H2>Applicant Details</H2><p>"
           + "Username: " + seeker_username
           + "<br/>First Name: " + rdr.GetValue(rdr.GetOrdinal("first_name")).ToString()
           + "<br/>Middle Name: " + rdr.GetValue(rdr.GetOrdinal("middle_name")).ToString()
           + "<br/>Last Name: " + rdr.GetValue(rdr.GetOrdinal("last_name")).ToString()
           + "<br/>Years of Experience: " + rdr.GetValue(rdr.GetOrdinal("years_of_experience")).ToString()
           + "<br/>Personal Email: " + rdr.GetValue(rdr.GetOrdinal("email")).ToString()
           + "<br/>Age: " + rdr.GetValue(rdr.GetOrdinal("age")).ToString() + "</p>"
            });
        }
        conn.Close();
    }

    protected void return_to_manage_specific_job_applications(object sender, EventArgs e)
    {
        Response.Redirect("manage_specific_job_applications", true);
    }
}