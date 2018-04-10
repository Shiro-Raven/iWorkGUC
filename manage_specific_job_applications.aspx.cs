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

public partial class manage_specific_job_applications : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["manager_application_error"] != null)
        {
            Response.Write(Session["manager_application_error"]);
            Session["manager_application_error"] = null;
        }

        //establish connection
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        //reference procedure
        SqlCommand cmd = new SqlCommand("View_app_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        //retrieve the username of the manager

        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manager", username));
        cmd.Parameters.Add(new SqlParameter("@jobid", Session["manage_applications_specific_job_id"]));

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        //job_id, title
        applications_form.Controls.Add(new Literal { Text = "<H2>" + username + ", the following applicants have applied for job number" + Session["manage_applications_specific_job_id"] + ".</H2><BR/>" });

        //create an intial table
        applications_form.Controls.Add(new Literal { Text = "<table><tr><th>Applicant Username</th><th>View All Details</th><th>Accept/Reject</th></tr>" });
        int counter = 0;
        while (rdr.Read())
        {
            string jobseeker_username = rdr.GetValue(rdr.GetOrdinal("seeker_username")).ToString();
            applications_form.Controls.Add(new Literal
            {
                Text = "<tr><th>" + jobseeker_username + "</th><th>"
            });

            Button viewButton = new Button();
            viewButton.ToolTip = jobseeker_username;
            viewButton.Click += new EventHandler(to_view_specific_jobseeker_applications);
            viewButton.Text = "View All Details";
            applications_form.Controls.Add(viewButton);
            applications_form.Controls.Add(new Literal { Text = "</th><th>" });

            Button evaluateButton = new Button();
            evaluateButton.ToolTip = jobseeker_username;
            evaluateButton.Click += new EventHandler(to_evaluate_specific_jobseeker_applications);
            evaluateButton.Text = "Accept/Reject";
            applications_form.Controls.Add(evaluateButton);
            applications_form.Controls.Add(new Literal { Text = "</th></tr>" });
            counter++;
        }
        applications_form.Controls.Add(new Literal { Text = "</table>" });
        applications_form.Controls.Add(new Literal { Text = "<H3>There are " + counter + " applicants.</H3><BR/>" });
        conn.Close();

    }

    protected void to_view_specific_jobseeker_applications(object sender, EventArgs e)
    {
        Button b1 = sender as Button;
        Session["view_applications_specific_jobseeker"] = b1.ToolTip;
        Response.Redirect("view_specific_jobseeker_applications");
    }

    protected void to_evaluate_specific_jobseeker_applications(object sender, EventArgs e)
    {
        Button b1 = sender as Button;
        Session["evaluate_applications_specific_jobseeker"] = b1.ToolTip;
        Response.Redirect("evaluate_specific_jobseeker_applications");
    }

    protected void return_to_manager_applications(object sender, EventArgs e)
    {
        Response.Redirect("manager_applications", true);
    }
}