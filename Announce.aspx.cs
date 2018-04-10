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
    protected void close_Click(object sender, EventArgs e)
    {
        Response.Redirect("hr_employee", true);
    }
    protected void btn_post_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("postAnnouncements", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];

        cmd.Parameters.AddWithValue("@hr_username", username);

        if(txtbox_title.Text.Equals("") || txtbox_type.Text.Equals("") || txt_desc.Text.Equals(""))
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, cyka!" + "');</script>");
        else
        {
            cmd.Parameters.AddWithValue("@description", txt_desc.Text);
            cmd.Parameters.AddWithValue("@type", txtbox_type.Text);
            cmd.Parameters.AddWithValue("@title", txtbox_title.Text);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            Response.Write(@"<script language='javascript'>alert('" + "Announcement Posted!" + "');</script>");

            txtbox_title.Text = "";
            txtbox_type.Text = "";
            txt_desc.Text = "";
        }

    }
}