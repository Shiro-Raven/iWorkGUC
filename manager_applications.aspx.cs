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

public partial class manager_applications : System.Web.UI.Page
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
        SqlCommand cmd = new SqlCommand("View_jobs_with_applications_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        //retrieve the username of the manager
        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manager", username));

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        //job_id, title
        applications_form.Controls.Add(new Literal { Text = "<H2>" + username + ", applications have arrived for the following jobs in your department.</H2><BR/>" });

        //create an intial table
        applications_form.Controls.Add(new Literal { Text = "<table><tr><th>Job ID</th><th>Job Title</th><th>Details</th></tr>" });
        int counter = 0;
        while (rdr.Read())
        {
            string job_id = rdr.GetValue(rdr.GetOrdinal("job_id")).ToString();
            applications_form.Controls.Add(new Literal
            {
                Text = "<tr><th>" +
                job_id + "</th><th>" + rdr.GetValue(rdr.GetOrdinal("title")).ToString() + "</th><th>"
            });

            Button b1 = new Button();
            b1.ToolTip = job_id;
            b1.Click += new EventHandler(to_manage_specific_job_applications);
            b1.Text = "Go To Job Applications";
            applications_form.Controls.Add(b1);
            applications_form.Controls.Add(new Literal { Text = "</th></tr>" });
            counter++;
        }
        conn.Close();
        applications_form.Controls.Add(new Literal { Text = "</table>" });
        applications_form.Controls.Add(new Literal { Text = "<H3>There are " + counter + " jobs with new applications.</H3><BR/>" });
    }

    protected void to_manage_specific_job_applications(object sender, EventArgs e)
    {
        Button b1 = sender as Button;
        Session["manage_applications_specific_job_id"] = b1.ToolTip;
        Response.Redirect("manage_specific_job_applications");
    }

    protected void return_to_profile(object sender, EventArgs e)
    {
        Response.Redirect("manager", true);
    }
}