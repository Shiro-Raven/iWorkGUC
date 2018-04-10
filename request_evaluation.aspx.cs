using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class request_evaluation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


    }

    protected void submit_evaluation(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("Respond_request_manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string reason = reason_textbox.Text;
        int response = 0;

        //get the reason
        string response_string = response_dropdownlist.SelectedItem.Text;

        if (response_string.Equals("accepted"))
            response = 1;
        else
            response = 0;

        //pass the parameters

        cmd.Parameters.Add(new SqlParameter("@username", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@reqid", Session["request_id"]));
        cmd.Parameters.Add(new SqlParameter("@response", response));
        cmd.Parameters.Add(new SqlParameter("@reason", reason));

        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (message.Value.ToString().Equals("0"))
            Response.Write("Your response was not saved correctly. Please choose a accepted/rejected from the dropdown list.");
        if (message.Value.ToString().Equals("1"))
            Response.Write("Your response was not saved correctly. In case of rejection, you must provide a reason.");
        if (message.Value.ToString().Equals("2"))
        {
            Session["request_error"] = "Your response on request number " + Session["request_id"] + " has been saved.";
            Response.Redirect("manager_requests", true);
        }
    }
    protected void return_to_manager_requests(object sender, EventArgs e)
    {
        Response.Redirect("manager_requests", true);
    }
}