using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Collections;

public partial class job_seeker : System.Web.UI.Page
{
    static ArrayList arrayList_job_id = new ArrayList();
    static ArrayList arrayList_job_id_application = new ArrayList();
    static ArrayList arrayList_choose_job = new ArrayList();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (Session["username"] == null)
        {
            Response.Redirect("login", true);
            return;
        }

        lbl_welcome_username.Text = (string)Session["username"];

        Check_Job_Seeker(sender, e);
        Refresh_Jobs(sender, e);
        Refresh_Applications(sender, e);
    }
    protected void Check_Job_Seeker(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("get_staff_type", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];
        cmd.Parameters.AddWithValue("@username", username);

        SqlParameter type = cmd.Parameters.Add("@type", SqlDbType.Int);
        type.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
		
        if (type.Value.ToString().Equals("5") == false)
            Response.Redirect("logged_in", true);
    }
    protected void Refresh_Jobs(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_all_Jobs_with_Vacancies", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        arrayList_job_id.Clear();
        drpdwnlst_apply_for_job.Items.Clear();

        while (rdr.Read())
        {
            arrayList_job_id.Add(rdr.GetValue(rdr.GetOrdinal("job_id")));

            string job = rdr.GetString(rdr.GetOrdinal("name")) + " | " +
                rdr.GetString(rdr.GetOrdinal("dep_name")) + " | " +
                rdr.GetString(rdr.GetOrdinal("title")) + " | " +
                rdr.GetValue(rdr.GetOrdinal("job_id")).ToString();
            drpdwnlst_apply_for_job.Items.Add(job);
        }

        rdr.Close();
    }
    protected void Refresh_Applications(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Status_of_all_Applications", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", (string)Session["username"]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        arrayList_job_id_application.Clear();
        arrayList_choose_job.Clear();
        drpdwnlst_delete_application.Items.Clear();
        drpdwnlst_choose_job.Items.Clear();

        while (rdr.Read())
        {
            arrayList_job_id_application.Add(rdr.GetValue(rdr.GetOrdinal("job_id")));

            string job;

            if(rdr.GetString(rdr.GetOrdinal("status")).Equals("pending"))
            {
                job = rdr.GetString(rdr.GetOrdinal("title")) + " | " +
                    rdr.GetString(rdr.GetOrdinal("status")) + " | " +
                    rdr.GetValue(rdr.GetOrdinal("job_id")).ToString();
                drpdwnlst_delete_application.Items.Add(job);
            }

            if (rdr.GetString(rdr.GetOrdinal("status")).Equals("accepted"))
            {
                arrayList_choose_job.Add(rdr.GetValue(rdr.GetOrdinal("job_id")));

                job = rdr.GetString(rdr.GetOrdinal("title")) + " | " +
                    rdr.GetString(rdr.GetOrdinal("status")) + " | " +
                    rdr.GetValue(rdr.GetOrdinal("job_id")).ToString();
                drpdwnlst_choose_job.Items.Add(job);
            }
        }

        rdr.Close();
    }
    protected void View_Job_Details(object sender, EventArgs e)
    {
		if (drpdwnlst_apply_for_job.SelectedIndex == -1)
			return;

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Certain_Job", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("job_id", arrayList_job_id[drpdwnlst_apply_for_job.SelectedIndex]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        tbl_output_table.Rows.Clear();

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Company's Name"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Department's Name"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Title"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Detailed Description"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Short Description"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Minimum Years Of Experience"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Salary"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Application Deadline"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Work Hours"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Number Of Vacancies"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableRow();

            TableCell tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("name"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("dep_name"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("job_id")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("title"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("detailed_description"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("short_description"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("minimum_years_of_experience")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("salary")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("application_deadline")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("work_hours")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("number_of_vacancies")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();
    }
    protected void Apply_For_Job(object sender, EventArgs e)
    {
        if (drpdwnlst_apply_for_job.SelectedIndex == -1)
            return;

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("apply_for_Job".ToString(), conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
        cmd.Parameters.AddWithValue("@job_id", arrayList_job_id[drpdwnlst_apply_for_job.SelectedIndex]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals("0"))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals("1"))
            Response.Write("Empty Input(s)");
        else if (output_message.Value.ToString().Equals("2"))
            Response.Write("NULL Input(s)");
        else if (output_message.Value.ToString().Equals("3"))
            Response.Write("User Does Not Exist!");
        else if (output_message.Value.ToString().Equals("4"))
            Response.Write("Job Does Not Exist!");
        else if (output_message.Value.ToString().Equals("5"))
            Response.Write("Application Is Still Being Reviewed!");
        else if (output_message.Value.ToString().Equals("6"))
            Response.Write("User Does Not Have Enough Experience!");
        else if (output_message.Value.ToString().Equals("7"))
        {
            Session["job_id"] = arrayList_job_id[drpdwnlst_apply_for_job.SelectedIndex];
            Response.Redirect("application", true);
        }

        View_Job_Details(sender, e);
    }
    protected void View_Applications(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Status_of_all_Applications", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", Session["username"]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        tbl_output_table.Rows.Clear();

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Company's Name"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Department's Name"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job's Title"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Score"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Status"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("HR's Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager's Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableRow();

            TableCell tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("name"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("dep_name"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("job_id")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("title"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("score")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("status"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("hr_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();

        if (!output_message.Value.ToString().Equals(("5")))
            tbl_output_table.Rows.Clear();
        if (output_message.Value.ToString().Equals(("0")))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals(("1")))
            Response.Write("Empty Input(s)");
        else if (output_message.Value.ToString().Equals(("2")))
            Response.Write("NULL Input(s)");
        else if (output_message.Value.ToString().Equals(("3")))
            Response.Write("User Does Not Exist!");
        else if (output_message.Value.ToString().Equals(("4")))
            Response.Write("No Applications Yet!");
    }
    protected void Delete_Applcation(object sender, EventArgs e)
    {
        if (drpdwnlst_delete_application.SelectedIndex == -1)
            return;

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("delete_Application", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
        cmd.Parameters.AddWithValue("@job_id", arrayList_job_id_application[drpdwnlst_delete_application.SelectedIndex]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals("0"))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals("1"))
            Response.Write("Empty Input(s)");
        else if (output_message.Value.ToString().Equals("2"))
            Response.Write("NULL Input(s)");
        else if (output_message.Value.ToString().Equals("3"))
            Response.Write("User Does Not Exist!");
        else if (output_message.Value.ToString().Equals("4"))
            Response.Write("Job Does Not Exist!");
        else if (output_message.Value.ToString().Equals("5"))
            Response.Write("Aplication Does Not Exist!");
        else if (output_message.Value.ToString().Equals("6"))
            Response.Write("Application Cannot Be Deleted After Being Reviewed!");
        else if (output_message.Value.ToString().Equals("7"))
        {
            Response.Write("Application Deleted!");
            Refresh_Applications(sender, e);
        }
    }
    protected void Choose_Job(object sender, EventArgs e)
    {
        if (drpdwnlst_choose_job.SelectedIndex == -1)
            return;

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("choose_Job", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
        cmd.Parameters.AddWithValue("@job_id", arrayList_choose_job[drpdwnlst_choose_job.SelectedIndex]);
        cmd.Parameters.AddWithValue("@day_off", drpdwnlst_days.Text);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals("0"))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals("1"))
            Response.Write("Empty Input(s)");
        else if (output_message.Value.ToString().Equals("2"))
            Response.Write("NULL Input(s)");
        else if (output_message.Value.ToString().Equals("3"))
            Response.Write("User Does Not Exist!");
        else if (output_message.Value.ToString().Equals("4"))
            Response.Write("Job Does Not Exist!");
        else if (output_message.Value.ToString().Equals("5"))
            Response.Write("Aplication Does Not Exist!");
        else if (output_message.Value.ToString().Equals("6"))
            Response.Write("User Was Not Accepted To That Job!");
        else if (output_message.Value.ToString().Equals("7"))
            Response.Write("Cannot Choose Friday As Day Off!");
        else if (output_message.Value.ToString().Equals("8"))
            Response.Write("Job Does Not Have Available Places Anymore!");
        else if (output_message.Value.ToString().Equals("9"))
            Back_To_Profile(sender, e);
    }
    protected void Back_To_Profile(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("get_staff_type", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];
        cmd.Parameters.AddWithValue("@username", username);

        SqlParameter type = cmd.Parameters.Add("@type", SqlDbType.Int);
        type.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (type.Value.ToString().Equals("5"))
            Response.Redirect("job_seeker", true);
        else if (type.Value.ToString().Equals("4"))
            Response.Redirect("manager", true);
        else if (type.Value.ToString().Equals("3"))
            Response.Redirect("hr_employee", true);
        else if (type.Value.ToString().Equals("2"))
            Response.Redirect("regular_employee", true);
        else if (type.Value.ToString().Equals("1"))
            Response.Redirect("staff_member", true);
        else if (type.Value.ToString().Equals("0"))
            Response.Redirect("login", true);
    }
    protected void Back_To_Logged_In(object sender, EventArgs e)
    {
        Response.Redirect("logged_in", true);
    }
}