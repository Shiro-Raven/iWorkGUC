using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void send_email(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("send_email", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        String sender_username = Session["username"].ToString();
        String subject = TextBox7.Text;
        String body = TextBox9.Text;
        String recepient_username = TextBox8.Text;

        cmd.Parameters.Add(new SqlParameter("@sender", sender_username));
        cmd.Parameters.Add(new SqlParameter("@subject", subject));
        cmd.Parameters.Add(new SqlParameter("@body", body));
        cmd.Parameters.Add(new SqlParameter("@recepient", recepient_username));

        SqlParameter printStat = cmd.Parameters.Add("@out", SqlDbType.Int);
        printStat.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (printStat.Value.ToString().Equals("1"))
            Response.Write("Please do not leave any empty fields");
        else if (printStat.Value.ToString().Equals("2"))
            Response.Write("Not staff members");
        else if (printStat.Value.ToString().Equals("3"))
            Response.Write("Message sent!");
        else if (printStat.Value.ToString().Equals("4"))
            Response.Write("sender and recepient are not from the same company");
    }
    protected void view_emails(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_emails", conn);
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

        hdrcl.Controls.Add(new LiteralControl("time_stamp"));
        hdrcl1.Controls.Add(new LiteralControl("sender_username"));
        hdrcl2.Controls.Add(new LiteralControl("subject"));
        hdrcl3.Controls.Add(new LiteralControl("body"));

        hdr.Cells.Add(hdrcl);
        hdr.Cells.Add(hdrcl1);
        hdr.Cells.Add(hdrcl2);
        hdr.Cells.Add(hdrcl3);

        tbl_view_emails.Rows.Add(hdr);

        DropDownListTimeStamps.Items.Clear();


        while (rdr.Read())
        {
            string time_stamp = rdr.GetDateTime(rdr.GetOrdinal("time_stamp")).ToString("yyyy-MM-dd hh:mm:ss.fff tt");
            string sender_username = rdr.GetValue(rdr.GetOrdinal("sender_username")).ToString();
            string subject = rdr.GetValue(rdr.GetOrdinal("subject")).ToString();
            string body = (rdr.GetValue(rdr.GetOrdinal("body"))).ToString();

            DropDownListTimeStamps.Items.Add(new ListItem(time_stamp));

            TableRow row = new TableRow();
            TableCell cell1 = new TableCell();
            TableCell cell2 = new TableCell();
            TableCell cell3 = new TableCell();
            TableCell cell4 = new TableCell();


            cell1.Controls.Add(new LiteralControl(time_stamp));
            cell2.Controls.Add(new LiteralControl(sender_username));
            cell3.Controls.Add(new LiteralControl(subject));
            cell4.Controls.Add(new LiteralControl(body));


            row.Cells.Add(cell1);
            row.Cells.Add(cell2);
            row.Cells.Add(cell3);
            row.Cells.Add(cell4);

            tbl_view_emails.Rows.Add(row);

        }



    }
    protected void reply_to_email(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("reply_to_email_m3", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = Session["username"].ToString();
        string time_stamp = (DropDownListTimeStamps.SelectedValue.ToString());
        cmd.Parameters.Add(new SqlParameter("@timestamp", time_stamp));
        cmd.Parameters.Add(new SqlParameter("@username", username));

        SqlParameter dude = cmd.Parameters.Add("@se", SqlDbType.VarChar,100);
        dude.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        string x = dude.Value.ToString();


        TextBox8.Text = (x);
        DropDownListTimeStamps.Items.Clear();


    }

    protected void Button4_Click(object sender, EventArgs e)
    {
        Response.Redirect("staff_member");
    }
}