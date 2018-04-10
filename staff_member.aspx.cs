using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Staff_Members : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void Check_in(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("check_in", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        String username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@username", username));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("user has already checked in");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("it is his day off");
        else
            Response.Write("checked in!");
        
    }
    protected void Check_out(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("check_out", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        String username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@username", username));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Checked out!");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("this employee did not check in today or has already checked out");

    }
    protected void View_Attendance_Records(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_attendance_records", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        String username = Session["username"].ToString();
        DateTime start = DateTime.Parse(TextBox2.Text);
        DateTime end = DateTime.Parse(TextBox3.Text);

        cmd.Parameters.Add(new SqlParameter("@username", username));
        cmd.Parameters.Add(new SqlParameter("@start", start));
        cmd.Parameters.Add(new SqlParameter("@end", end));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Please do not leave any empty fields");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Write("no records for this username in the specified period");
        else if (printStat.Value.ToString().Equals("2"))
        {
            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            TableHeaderRow hdr = new TableHeaderRow();
            TableHeaderCell hdrcl = new TableHeaderCell();
            TableHeaderCell hdrcl1 = new TableHeaderCell();
            TableHeaderCell hdrcl2 = new TableHeaderCell();
            TableHeaderCell hdrcl3 = new TableHeaderCell();
            hdrcl.Controls.Add(new LiteralControl("start_time"));
            hdrcl1.Controls.Add(new LiteralControl("end_time"));
            hdrcl2.Controls.Add(new LiteralControl("duration"));
            hdrcl3.Controls.Add(new LiteralControl("missing_hours"));

            hdr.Cells.Add(hdrcl);
            hdr.Cells.Add(hdrcl1);
            hdr.Cells.Add(hdrcl2);
            hdr.Cells.Add(hdrcl3);

            tbl_attendance_records.Rows.Add(hdr);

            while (rdr.Read())
            {
                string start_time = rdr.GetValue(rdr.GetOrdinal("start_time")).ToString();
                string end_time = rdr.GetValue(rdr.GetOrdinal("end_time")).ToString();
                string duration = rdr.GetString(rdr.GetOrdinal("duration"));
                string missing_hours = (rdr.GetValue(rdr.GetOrdinal("missing_hours"))).ToString();

                TableRow row = new TableRow();
                TableCell cell1 = new TableCell();
                TableCell cell2 = new TableCell();
                TableCell cell3 = new TableCell();
                TableCell cell4 = new TableCell();

                cell1.Controls.Add(new LiteralControl(start_time));
                cell2.Controls.Add(new LiteralControl(end_time));
                cell3.Controls.Add(new LiteralControl(duration));
                cell4.Controls.Add(new LiteralControl(missing_hours));

                row.Cells.Add(cell1);
                row.Cells.Add(cell2);
                row.Cells.Add(cell3);
                row.Cells.Add(cell4);

                tbl_attendance_records.Rows.Add(row);

            }
        }

    }
    protected void view_status_requests(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_status_of_requests", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = Session["username"].ToString();

        cmd.Parameters.Add(new SqlParameter("@username",username));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("user did not submit a request");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Write("username is incorrect");
        else if (printStat.Value.ToString().Equals("2"))
        {
            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            TableHeaderRow hdr = new TableHeaderRow();
            TableHeaderCell hdrcl = new TableHeaderCell();
            TableHeaderCell hdrcl1 = new TableHeaderCell();
            TableHeaderCell hdrcl2 = new TableHeaderCell();
            TableHeaderCell hdrcl3 = new TableHeaderCell();
            TableHeaderCell hdrcl4 = new TableHeaderCell();
            TableHeaderCell hdrcl5 = new TableHeaderCell();
            TableHeaderCell hdrcl6 = new TableHeaderCell();
            TableHeaderCell hdrcl7 = new TableHeaderCell();
            TableHeaderCell hdrcl8 = new TableHeaderCell();
            TableHeaderCell hdrcl9 = new TableHeaderCell();
            TableHeaderCell hdrcl10 = new TableHeaderCell();


            hdrcl.Controls.Add(new LiteralControl("request_id"));
            hdrcl1.Controls.Add(new LiteralControl("filing_date"));
            hdrcl2.Controls.Add(new LiteralControl("start_date"));
            hdrcl3.Controls.Add(new LiteralControl("end_date"));
            hdrcl4.Controls.Add(new LiteralControl("number_of_days"));
            hdrcl5.Controls.Add(new LiteralControl("status"));
            hdrcl6.Controls.Add(new LiteralControl("hr_approval"));
            hdrcl7.Controls.Add(new LiteralControl("manager_approval"));
            hdrcl8.Controls.Add(new LiteralControl("manager_reason"));
            hdrcl9.Controls.Add(new LiteralControl("hr_employee_username"));
            hdrcl10.Controls.Add(new LiteralControl("manager_username"));


            hdr.Cells.Add(hdrcl);
            hdr.Cells.Add(hdrcl1);
            hdr.Cells.Add(hdrcl2);
            hdr.Cells.Add(hdrcl3);
            hdr.Cells.Add(hdrcl4);
            hdr.Cells.Add(hdrcl5);
            hdr.Cells.Add(hdrcl6);
            hdr.Cells.Add(hdrcl7);
            hdr.Cells.Add(hdrcl8);
            hdr.Cells.Add(hdrcl9);
            hdr.Cells.Add(hdrcl10);


            tbl_view_status_of_requests.Rows.Add(hdr);

            DropDownListRequestID.Items.Clear();

            while (rdr.Read())
            {
                string request_id = rdr.GetValue(rdr.GetOrdinal("request_id")).ToString();
                string filing_date = rdr.GetValue(rdr.GetOrdinal("filing_date")).ToString();
                string start_date = rdr.GetValue(rdr.GetOrdinal("start_date")).ToString();
                string end_date = (rdr.GetValue(rdr.GetOrdinal("end_date"))).ToString();
                string number_of_days = rdr.GetValue(rdr.GetOrdinal("number_of_days")).ToString();
                string status = rdr.GetValue(rdr.GetOrdinal("status")).ToString();
                string hr_approval = rdr.GetValue(rdr.GetOrdinal("hr_approval")).ToString();
                string manager_approval = rdr.GetValue(rdr.GetOrdinal("manager_approval")).ToString();
                string manager_reason = rdr.GetValue(rdr.GetOrdinal("manager_reason")).ToString();
                string hr_employee_username = rdr.GetValue(rdr.GetOrdinal("hr_employee_username")).ToString();
                string manager_username = rdr.GetValue(rdr.GetOrdinal("manager_username")).ToString();
           
                DropDownListRequestID.Items.Add(new ListItem(request_id));

                TableRow row = new TableRow();
                TableCell cell1 = new TableCell();
                TableCell cell2 = new TableCell();
                TableCell cell3 = new TableCell();
                TableCell cell4 = new TableCell();
                TableCell cell5 = new TableCell();
                TableCell cell6 = new TableCell();
                TableCell cell7 = new TableCell();
                TableCell cell8 = new TableCell();
                TableCell cell9 = new TableCell();
                TableCell cell10 = new TableCell();
                TableCell cell11 = new TableCell();



                cell1.Controls.Add(new LiteralControl(request_id));
                cell2.Controls.Add(new LiteralControl(filing_date));
                cell3.Controls.Add(new LiteralControl(start_date));
                cell4.Controls.Add(new LiteralControl(end_date));
                cell5.Controls.Add(new LiteralControl(number_of_days));
                cell6.Controls.Add(new LiteralControl(status));
                cell7.Controls.Add(new LiteralControl(hr_approval));
                cell8.Controls.Add(new LiteralControl(manager_approval));
                cell9.Controls.Add(new LiteralControl(manager_reason));
                cell10.Controls.Add(new LiteralControl(hr_employee_username));
                cell11.Controls.Add(new LiteralControl(manager_username));


                row.Cells.Add(cell1);
                row.Cells.Add(cell2);
                row.Cells.Add(cell3);
                row.Cells.Add(cell4);
                row.Cells.Add(cell5);
                row.Cells.Add(cell6);
                row.Cells.Add(cell7);
                row.Cells.Add(cell8);
                row.Cells.Add(cell9);
                row.Cells.Add(cell10);
                row.Cells.Add(cell11);


                tbl_view_status_of_requests.Rows.Add(row);

            }


        }

    }
    protected void apply_for_leave_request(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("apply_for_request_leave", conn);
        cmd.CommandType = CommandType.StoredProcedure;
        
        String submitter = Session["username"].ToString();
        DateTime start = DateTime.Parse(TextBox4.Text);
        DateTime end = DateTime.Parse(TextBox5.Text);
        String replacement = TextBox6.Text;
        String type = DropDownList1.Text;

        cmd.Parameters.Add(new SqlParameter("@submitter", submitter));
        cmd.Parameters.Add(new SqlParameter("@start_date", start));
        cmd.Parameters.Add(new SqlParameter("@end_date", end));
        cmd.Parameters.Add(new SqlParameter("@replacement", replacement));
        cmd.Parameters.Add(new SqlParameter("@type", type));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Please do not leave any empty fields");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("one of the usernames supplied not registered as a staff member");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Write("You Can not Replace Yourself, Moron!");
        else if (printStat.Value.ToString().Equals("4"))
            Response.Write("maximum number of leaves has been reached");
        else if (printStat.Value.ToString().Equals("5"))
            Response.Write("submitter and replacement must be of the same type");
        else if (printStat.Value.ToString().Equals("6"))
            Response.Write("OVERLAP!");
        else if (printStat.Value.ToString().Equals("7"))
            Response.Write("Applied!");


    }
    protected void apply_for_business_trip_request(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("apply_for_request_business_trip", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        String submitter = Session["username"].ToString();
        DateTime start = DateTime.Parse(TextBox7.Text);
        DateTime end = DateTime.Parse(TextBox8.Text);
        String replacement = TextBox9.Text;
        String destination = TextBox10.Text;
        String purpose = TextBox11.Text;

        cmd.Parameters.Add(new SqlParameter("@submitter", submitter));
        cmd.Parameters.Add(new SqlParameter("@start_date", start));
        cmd.Parameters.Add(new SqlParameter("@end_date", end));
        cmd.Parameters.Add(new SqlParameter("@replacement", replacement));
        cmd.Parameters.Add(new SqlParameter("@destination", destination));
        cmd.Parameters.Add(new SqlParameter("@purpose", purpose));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Please do not leave any empty fields");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("one of the usernames supplied not registered as a staff member");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Write("You Can not Replace Yourself, Moron!");
        else if (printStat.Value.ToString().Equals("4"))
            Response.Write("maximum number of leaves has been reached");
        else if (printStat.Value.ToString().Equals("5"))
            Response.Write("submitter and replacement must be of the same type");
        else if (printStat.Value.ToString().Equals("6"))
            Response.Write("OVERLAP!");
        else if (printStat.Value.ToString().Equals("7"))
            Response.Write("Applied!");


    }
    protected void Button8_Click(object sender, EventArgs e)
    {
        Response.Redirect("Email.aspx");
    }
    protected void delete_request(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("delete_request_in_review", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@request_id", DropDownListRequestID.SelectedValue.ToString()));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Request no longer in the review process");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("Deleted!");

        DropDownListRequestID.Items.Clear();
    }
    protected void view_announcements(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_announcements", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@username", username));

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        TableHeaderRow hdr = new TableHeaderRow();
        TableHeaderCell hdrcl = new TableHeaderCell();
        TableHeaderCell hdrcl1 = new TableHeaderCell();
        TableHeaderCell hdrcl2 = new TableHeaderCell();
        TableHeaderCell hdrcl3 = new TableHeaderCell();
        TableHeaderCell hdrcl4 = new TableHeaderCell();
        TableHeaderCell hdrcl5 = new TableHeaderCell();


        hdrcl.Controls.Add(new LiteralControl("a_id"));
        hdrcl1.Controls.Add(new LiteralControl("date"));
        hdrcl2.Controls.Add(new LiteralControl("description"));
        hdrcl3.Controls.Add(new LiteralControl("type"));
        hdrcl4.Controls.Add(new LiteralControl("title"));
        hdrcl5.Controls.Add(new LiteralControl("company_domain_name"));


        hdr.Cells.Add(hdrcl);
        hdr.Cells.Add(hdrcl1);
        hdr.Cells.Add(hdrcl2);
        hdr.Cells.Add(hdrcl3);
        hdr.Cells.Add(hdrcl4);
        hdr.Cells.Add(hdrcl5);

        tbl_announcements.Rows.Add(hdr);

        while (rdr.Read())
        {
            string a_id = rdr.GetValue(rdr.GetOrdinal("a_id")).ToString();
            string date = rdr.GetValue(rdr.GetOrdinal("date")).ToString();
            string description = rdr.GetValue(rdr.GetOrdinal("description")).ToString();
            string type = (rdr.GetValue(rdr.GetOrdinal("type"))).ToString();
            string title = rdr.GetValue(rdr.GetOrdinal("title")).ToString();
            string company_domain_name = rdr.GetValue(rdr.GetOrdinal("company_domain_name")).ToString();
            

            TableRow row = new TableRow();
            TableCell cell1 = new TableCell();
            TableCell cell2 = new TableCell();
            TableCell cell3 = new TableCell();
            TableCell cell4 = new TableCell();
            TableCell cell5 = new TableCell();
            TableCell cell6 = new TableCell();

            cell1.Controls.Add(new LiteralControl(a_id));
            cell2.Controls.Add(new LiteralControl(date));
            cell3.Controls.Add(new LiteralControl(description));
            cell4.Controls.Add(new LiteralControl(type));
            cell5.Controls.Add(new LiteralControl(title));
            cell6.Controls.Add(new LiteralControl(company_domain_name));


            row.Cells.Add(cell1);
            row.Cells.Add(cell2);
            row.Cells.Add(cell3);
            row.Cells.Add(cell4);
            row.Cells.Add(cell5);
            row.Cells.Add(cell6);


            tbl_announcements.Rows.Add(row);

        }




    }
    protected void back_to_homepage(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("get_staff_type", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string) Session["username"];
        cmd.Parameters.Add(new SqlParameter("@username", username));

        SqlParameter printStat = cmd.Parameters.Add("@type", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("4"))
            Response.Redirect("manager");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Redirect("hr_employee");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Redirect("regular_employee");


    }
}