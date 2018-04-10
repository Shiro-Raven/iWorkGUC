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
public partial class evaluate_specific_jobseeker_applications : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void submit_evaluation(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("Respond_application_manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        int response = 0;

        //get the reason
        string response_string = response_dropdownlist.SelectedItem.Text;

        if (response_string.Equals("accepted"))
            response = 1;
        else
            response = 0;

        //pass parameters
        //@seeker_username varchar(100)=null, @job_id int=null, @username varchar(100)=null, @response bit=null
        cmd.Parameters.Add(new SqlParameter("@username", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@job_id", Session["manage_applications_specific_job_id"]));
        cmd.Parameters.Add(new SqlParameter("@seeker_username", Session["evaluate_applications_specific_jobseeker"]));
        cmd.Parameters.Add(new SqlParameter("@response", response));

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        Session["manager_application_error"] = "Your response to " + Session["evaluate_applications_specific_jobseeker"] + "'s job application was saved.";
        Response.Redirect("manage_specific_job_applications", true);
    }

    protected void to_manage_specific_job_applications(object sender, EventArgs e)
    {
        Response.Redirect("manage_specific_job_applications", true);
    }


}