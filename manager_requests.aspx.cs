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

public partial class manager_requests : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["request_error"] != null)
        {
            Response.Write(Session["request_error"]);
            Session["request_error"] = null;
        }

        //establish connection
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        //reference procedure
        SqlCommand cmd = new SqlCommand("view_leave_req_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;
       
        conn.Open();

        //retrieve the username of the manager
        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manager", username));
        //read the leave requests
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);



        //request_id, filing_date, start_date, end_date, number_of_days, status, hr_approval, manager_approval, manager_reason, hr_employee_username, manager_username
        requests.Controls.Add(new Literal { Text = "<H2>" + username + ", you have the following leave requests in your department.</H2><BR/>" });
        requests.Controls.Add(new Literal { Text = "<table style=\"width: 100% \"><tr><th>Request Id</th><th>Filing Date</th><th>Start Date</th><th>End Date</th><th>Number of Days</th><th>Status</th><th>Type</th><th>Submitter</th><th>Replacement</th><th>Your Response</th></tr>" });
        int counter = 0;
        while (rdr.Read())
        {
            StringBuilder leave_requests_table = new StringBuilder();
            string request_id, filing_date, start_date, end_date, number_of_days, status,leave_type,submitter,replacement;
            request_id = rdr.GetValue(rdr.GetOrdinal("request_id")).ToString();
            filing_date = rdr.GetValue(rdr.GetOrdinal("filing_date")).ToString();
            start_date = rdr.GetValue(rdr.GetOrdinal("start_date")).ToString();
            end_date= rdr.GetValue(rdr.GetOrdinal("end_date")).ToString();
            number_of_days = rdr.GetValue(rdr.GetOrdinal("number_of_days")).ToString();
            status= rdr.GetString(rdr.GetOrdinal("status"));
            leave_type= rdr.GetString(rdr.GetOrdinal("type"));
            submitter = rdr.GetString(rdr.GetOrdinal("submitter_username"));
            replacement = rdr.GetString(rdr.GetOrdinal("replacement_username"));

            leave_requests_table.Append("<tr><th>" + request_id + "</th><th>"+filing_date+"</th><th>"+start_date+"</th><th>"+end_date+"</th><th>"+number_of_days+"</th><th>"+status+"</th><th>"+leave_type+"</th><th>"+submitter+"</th><th>"+replacement+"</th>");

            leave_requests_table.Append("<th>");
            Button b1 = new Button();
            b1.ToolTip = request_id;
            b1.Click += new EventHandler(to_request_evaluation);
            b1.Text = "Accept/Reject";
            requests.Controls.Add(new Literal { Text = leave_requests_table.ToString() });
            requests.Controls.Add(b1);
            requests.Controls.Add(new Literal { Text = "</th></tr>" });
            counter++;
        }

        requests.Controls.Add(new Literal { Text = "</table>" });
        requests.Controls.Add(new Literal { Text = "<H3>There are " + counter + " pending leave requests.</H3></BR>" });

        conn.Close();

        //retrieve the business trip leave requests
        conn = new SqlConnection(connStr);

        cmd = new SqlCommand("view_business_trip_req_in_manager_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        cmd.Parameters.Add(new SqlParameter("@manager", username));

        //read the business trip requests
        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);


        //request_id, filing_date, start_date, end_date, number_of_days, status, hr_approval, manager_approval, manager_reason, hr_employee_username, manager_username
        requests.Controls.Add(new Literal { Text = "<H2>" + username + ", you have the following business trip leave requests in your department.</H2><BR/>" });
        requests.Controls.Add(new Literal { Text ="<table style=\"width: 100% \"><tr><th>Request Id</th><th>Filing Date</th><th>Start Date</th><th>End Date</th><th>Number of Days</th><th>Status</th><th>Destination</th><th>Purpose</th><th>Submitter</th><th>Replacement</th><th>Your Response</th></tr>" });
        counter = 0;
        while (rdr.Read())
        {
            StringBuilder business_requests_table = new StringBuilder();
            string request_id, filing_date, start_date, end_date, number_of_days, status, leave_destination, leave_purpose, submitter, replacement;
            request_id = rdr.GetValue(rdr.GetOrdinal("request_id")).ToString();
            filing_date = rdr.GetValue(rdr.GetOrdinal("filing_date")).ToString();
            start_date = rdr.GetValue(rdr.GetOrdinal("start_date")).ToString();
            end_date = rdr.GetValue(rdr.GetOrdinal("end_date")).ToString();
            number_of_days = rdr.GetValue(rdr.GetOrdinal("number_of_days")).ToString();
            status = rdr.GetString(rdr.GetOrdinal("status"));
            leave_destination = rdr.GetString(rdr.GetOrdinal("destination"));
            leave_purpose = rdr.GetString(rdr.GetOrdinal("purpose"));
            submitter = rdr.GetString(rdr.GetOrdinal("submitter_username"));
            replacement = rdr.GetString(rdr.GetOrdinal("replacement_username"));

            business_requests_table.Append("<tr><th>" + request_id + "</th><th>" + filing_date + "</th><th>" + start_date + "</th><th>" + end_date + "</th><th>" + number_of_days + "</th><th>" + status + "</th><th>" + leave_destination + "</th><th>" + leave_purpose + "</th><th>" + submitter + "</th><th>" + replacement + "</th>");

            business_requests_table.Append("<th>");
            Button b1 = new Button();
            b1.ToolTip = request_id;
            b1.Click += new EventHandler(to_request_evaluation);
            b1.Text = "Accept/Reject";
            requests.Controls.Add(new Literal { Text = business_requests_table.ToString() });
            requests.Controls.Add(b1);
            requests.Controls.Add(new Literal { Text = "</th></tr>" });
            counter++;
        }

        requests.Controls.Add(new Literal { Text = "</table>" });
        requests.Controls.Add(new Literal { Text = "<H3>There are " + counter + " pending business trip leave requests.</H3></BR>" });
        conn.Close();
    }


    protected void to_request_evaluation(object sender, EventArgs e)
    {
        Button btn = sender as Button;
        Session["request_id"] = btn.ToolTip;
        Response.Redirect("request_evaluation", true);
    }

    protected void return_to_profile(object sender, EventArgs e)
    {
        Response.Redirect("manager", true);
    }






}