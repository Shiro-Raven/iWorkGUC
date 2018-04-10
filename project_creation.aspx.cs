using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class project_creation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


    }

    protected void create_project(object sender, EventArgs e)
    {
        string project_name = project_name_textbox.Text;
        string start_date= start_date_textbox.Text , end_date = end_date_textbox.Text;

        DateTime start_datetime, end_datetime;
        Boolean conversion_worked;

        conversion_worked = DateTime.TryParse(start_date, out start_datetime) & DateTime.TryParse(end_date, out end_datetime);

        //reject wrong dates
        if (!conversion_worked)
        {
            Response.Write("The start date or the end date were not formatted correctly. Please write them in the form month/day/year.");
            return;
        }

        //connect
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("create_project", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //pass the parameters
        //@projname varchar(200)=null, @start datetime=null, @end datetime=null,@manuser varchar(100),@message int output
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@start", start_datetime));
        cmd.Parameters.Add(new SqlParameter("@end", end_datetime));
        cmd.Parameters.Add(new SqlParameter("@manuser", Session["username"]));

        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        switch (message.Value.ToString())
        {
            case "0":
                Response.Write("Please enter a valid project name.");
                break;
            case "1":
                Response.Write("Please enter a valid start date.");
                break;
            case "2":
                Response.Write("Please enter a valid end date.");
                break;
            case "3":
                Response.Write("The start date cannot come after the end date. Please adjust the dates to indicate a proper interval.");
                break;
            case "4":
                Response.Write("A project with the same name already exists. Please choose a different name.");
                break;
            case "5":
                Session["project_central_error"] = "The project " + project_name + " has been successfully created.";
                Response.Redirect("project_central", true);
                break;
        }
    }

    protected void return_to_project_central(object sender, EventArgs e)
    {
        Response.Redirect("project_central", true);
    }

}