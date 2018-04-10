using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class hr_employee : System.Web.UI.Page
{
    static ArrayList reqIDs = new ArrayList();
    static ArrayList jobIDs = new ArrayList();
    static ArrayList staff = new ArrayList();
    static ArrayList Achievers = new ArrayList();
    static ArrayList SeekerID = new ArrayList();
    static int jobforApp;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("login", true);
        }
        else
        {
            lbl_name.Text = "Welcome, " + (string)Session["username"] + ".";
        }
    }
    protected void addJob(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_viewApp.Enabled = false;

        Response.Redirect("addJob", false);
    }
    protected void staffMembers(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_viewApp.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        Response.Redirect("staff_member", false);
    }
    protected void viewJobs(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = true;
        btn_viewApp.Enabled = true;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_addQues.Enabled = true;

        // No Query Changes needed here
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewJobs", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];
        
        cmd.Parameters.AddWithValue("@hr_user_name", username);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job Title"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Short Description"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Detailed Description"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Minimum years of experience"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Salary"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Application Deadline"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Work Hours"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Number of Vacancies"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        jobIDs = new ArrayList();

        while (rdr.Read())
        {
            TableRow tblrw = new TableHeaderRow();
            
            TableCell tblcl = new TableCell();
            string tmp = rdr.GetValue(rdr.GetOrdinal("job_id")).ToString();
            jobIDs.Add(int.Parse(tmp));
            tblcl.Controls.Add(new LiteralControl(tmp));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("title"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("short_description")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("short_description"))));
            }
            else
            {
                
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("detailed_description")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("detailed_description"))));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
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
    protected void viewStaff(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = true;
        btn_viewAttbyYear.Enabled = true;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewApp.Enabled = false;

        // No Query Changes needed here
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("Show_staff_in_dep", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        staff = new ArrayList();

        string username = (string)Session["username"];
        
        cmd.Parameters.AddWithValue("@hrusername", username);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Username"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Salary"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Day off"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Number of Leaves"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Company Email"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Job ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableHeaderRow();

            TableCell tblcl = new TableCell();
            string tmp = rdr.GetString(rdr.GetOrdinal("username"));
            staff.Add(tmp);
            tblcl.Controls.Add(new LiteralControl(tmp));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("salary")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("day_off")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("day_off"))));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("number_of_leaves")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("company_email")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("job_id")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();

    }
    protected void view_requests(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewApp.Enabled = false;
        string chosen = drpdwnlst_RequestType.Text;
        if (chosen.Equals("Leave"))
            view_Leave_requests(sender, e);
        else if (chosen.Equals("Business"))
            view_Business_requests(sender, e);
    }
    protected void view_Leave_requests(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = true;

        //No Query Changed needed here
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Leave_req_Hr", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];

        cmd.Parameters.AddWithValue("@hrUsername", username);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        reqIDs = new ArrayList();

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Request ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Filing Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Start Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("End Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Number of Days"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Status"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("HR Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Reason"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("HR Employee Username"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Username"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Type"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableHeaderRow();

            TableCell tblcl = new TableCell();
            string tmp = rdr.GetValue(rdr.GetOrdinal("request_id")).ToString();
            reqIDs.Add(tmp);
            tblcl.Controls.Add(new LiteralControl(tmp));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("filing_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("start_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("end_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("number_of_days")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("status")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("hr_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_reason")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("hr_employee_username")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("hr_employee_username")).ToString()));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("manager_username")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_username")).ToString()));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("type")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();
    }
    protected void view_Business_requests(object sender, EventArgs e)
    {
        btn_evalReq.Enabled = true;
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;

        //No Query Changes needed here
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Business_req_Hr", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];

        cmd.Parameters.AddWithValue("@hrUsername", username);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        reqIDs = new ArrayList();

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Request ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Filing Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Start Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("End Date"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Number of Days"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Status"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("HR Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Approval"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Reason"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("HR Employee Username"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Manager Username"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Destination"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Purpose"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableHeaderRow();

            TableCell tblcl = new TableCell();
            string tmp = rdr.GetValue(rdr.GetOrdinal("request_id")).ToString();
            reqIDs.Add(tmp);
            tblcl.Controls.Add(new LiteralControl(tmp));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("filing_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("start_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("end_date")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("number_of_days")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("status")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("hr_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_approval")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_reason")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("hr_employee_username")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("hr_employee_username")).ToString()));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            if (!rdr.IsDBNull(rdr.GetOrdinal("manager_username")))
            {
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("manager_username")).ToString()));
            }
            else
            {
                tblcl.Controls.Add(new LiteralControl(""));
            }
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("destination")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("purpose")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();
    }
    protected void btn_evalReq_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_viewApp.Enabled = false;


        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("Response_Req_Hr_Employee", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        int id = int.Parse(txt_reqID.Text);
        if (!reqIDs.Contains(id+""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "You are not allowed to evaluate this request. Please choose from the IDs shown in the table." + "');</script>");
            return;
        }
        else
        {
            string username = (string)Session["username"];
            
            bool resp;
            if (drpdwnlist_approval.Text == "Accept")
                resp = true;
            else
                resp = false;


            cmd.Parameters.AddWithValue("@reqid", id);
            cmd.Parameters.AddWithValue("@hrusername", username);
            cmd.Parameters.AddWithValue("@response", resp);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            Response.Write(@"<script language='javascript'>alert('" + "Request evaluated successfully!" + "');</script>");
        }
    }
    protected void btn_viewAtt_Click(object sender, EventArgs e)
    {
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewApp.Enabled = false;
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("View_Attendance_in_Period", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        SqlParameter output = cmd.Parameters.Add("@out", SqlDbType.Int);
        output.Direction = ParameterDirection.Output;

        string username = txt_staffID.Text;
        if (!staff.Contains(username))
        {
            Response.Write(@"<script language='javascript'>alert('" + "This staff member is not in your department. Please choose from the usernames in the View Staff table." + "');</script>");
            return;
        }
        else
        {
            if(txt_startDate.Text.Equals("") || txt_startDate.Text.Equals(""))
                Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields." + "');</script>");
            else { 
            DateTime start = DateTime.Parse(txt_startDate.Text);
            DateTime end = DateTime.Parse(txt_endDate.Text);
                if (start > end)
                {
                    Response.Write(@"<script language='javascript'>alert('" + "Start date can not be after the end date, Idiot!" + "');</script>");
                    return;
                }
                else
                {
                    cmd.Parameters.AddWithValue("@start", start);
                    cmd.Parameters.AddWithValue("@end", end);
                    cmd.Parameters.AddWithValue("@username", username);

                    conn.Open();
                    SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                    TableHeaderRow tblhdrrw = new TableHeaderRow();

                    TableHeaderCell tblhdrcl = new TableHeaderCell();
                    tblhdrcl.Controls.Add(new LiteralControl("Date"));
                    tblhdrrw.Cells.Add(tblhdrcl);

                    tblhdrcl = new TableHeaderCell();
                    tblhdrcl.Controls.Add(new LiteralControl("Start Time"));
                    tblhdrrw.Cells.Add(tblhdrcl);

                    tblhdrcl = new TableHeaderCell();
                    tblhdrcl.Controls.Add(new LiteralControl("End Time"));
                    tblhdrrw.Cells.Add(tblhdrcl);

                    tblhdrcl = new TableHeaderCell();
                    tblhdrcl.Controls.Add(new LiteralControl("Duration"));
                    tblhdrrw.Cells.Add(tblhdrcl);

                    tblhdrcl = new TableHeaderCell();
                    tblhdrcl.Controls.Add(new LiteralControl("Missing Hours"));
                    tblhdrrw.Cells.Add(tblhdrcl);

                    tbl_output_table.Controls.Add(tblhdrrw);

                    while (rdr.Read())
                    {
                        TableRow tblrw = new TableHeaderRow();

                        TableCell tblcl = new TableCell();
                        tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("date")).ToString()));
                        tblrw.Cells.Add(tblcl);

                        tblcl = new TableCell();
                        tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("start_time")).ToString()));
                        tblrw.Cells.Add(tblcl);

                        tblcl = new TableCell();
                        tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("end_time")).ToString()));
                        tblrw.Cells.Add(tblcl);

                        tblcl = new TableCell();
                        tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("Duration")).ToString()));
                        tblrw.Cells.Add(tblcl);

                        tblcl = new TableCell();
                        tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("Missing Hours")).ToString()));
                        tblrw.Cells.Add(tblcl);

                        tbl_output_table.Controls.Add(tblrw);
                    }

                    rdr.Close();

                    if (output.Value.ToString().Equals("-1"))
                    {
                        Response.Write("Please enter the start date and the end date of the Attendace records.");
                        tbl_output_table.Rows.Clear();
                    }
                }
            }
        }
    }
    protected void btn_viewAttbyYear_Click(object sender, EventArgs e)
    {
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewApp.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_total_hours_in_year", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = txt_staffID.Text;
        if (!staff.Contains(username))
        {
            Response.Write(@"<script language='javascript'>alert('" + "This staff member is not in your department. Please choose from the usernames in the View Staff table." + "');</script>");
            return;
        }
        else
        {
            if (txt_year.Text.Equals(""))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Write something,cyka!" + "');</script>");
            }
            else
            {
                int year = int.Parse(txt_year.Text);

                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@year", year);

                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                TableHeaderRow tblhdrrw = new TableHeaderRow();

                TableHeaderCell tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Month"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Total Hours"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tbl_output_table.Controls.Add(tblhdrrw);

                while (rdr.Read())
                {
                    TableRow tblrw = new TableHeaderRow();

                    TableCell tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("Month")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("Total Hours")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tbl_output_table.Controls.Add(tblrw);
                }

                rdr.Close();
            }
        }
    }
    protected void btn_viewAchievers_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_sendToAchievers.Enabled = true;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewApp.Enabled = false;
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("View_top_3_employees", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];

        if (txt_yearTop.Text.Equals("") || txt_monthTop.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        }
        else
        {
            int year = int.Parse(txt_yearTop.Text);
            int month = int.Parse(txt_monthTop.Text);

            cmd.Parameters.AddWithValue("@month", month);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@hrusername", username);

            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            TableHeaderRow tblhdrrw = new TableHeaderRow();

            TableHeaderCell tblhdrcl = new TableHeaderCell();
            tblhdrcl.Controls.Add(new LiteralControl("First Name"));
            tblhdrrw.Cells.Add(tblhdrcl);

            tblhdrcl = new TableHeaderCell();
            tblhdrcl.Controls.Add(new LiteralControl("Last Name"));
            tblhdrrw.Cells.Add(tblhdrcl);

            tbl_output_table.Controls.Add(tblhdrrw);

            while (rdr.Read())
            {
                TableRow tblrw = new TableHeaderRow();

                TableCell tblcl = new TableCell();
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("first_name")).ToString()));
                tblrw.Cells.Add(tblcl);

                tblcl = new TableCell();
                tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("last_name")).ToString()));
                tblrw.Cells.Add(tblcl);

                tbl_output_table.Controls.Add(tblrw);
            }

            rdr.Close();
        }
    }
    protected void btn_viewApp_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_sendToAchievers.Enabled = true;
        btn_evalApp.Enabled = true;
        btn_viewSeekerInfo.Enabled = true;
        btn_viewSeekerPrev.Enabled = true;



        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewApplicationsHR", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        if (txtbox_jobID.Text.Equals(""))
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        else
        {
            int jobforApp = int.Parse(txtbox_jobID.Text);

            if (!jobIDs.Contains(jobforApp))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Please choose from the jobs in the table." + "');</script>");
            }
            else
            {
                cmd.Parameters.AddWithValue("@job_id", jobforApp);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                TableHeaderRow tblhdrrw = new TableHeaderRow();

                TableHeaderCell tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Seeker Username"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Score"));
                tblhdrrw.Cells.Add(tblhdrcl);
                
                tbl_output_table.Controls.Add(tblhdrrw);

                SeekerID = new ArrayList();

                while (rdr.Read())
                {
                    TableRow tblrw = new TableHeaderRow();

                    TableCell tblcl = new TableCell();
                    string tmp = rdr.GetValue(rdr.GetOrdinal("seeker_username")).ToString();
                    SeekerID.Add(tmp);
                    tblcl.Controls.Add(new LiteralControl(tmp));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("score")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tbl_output_table.Controls.Add(tblrw);
                }

                rdr.Close();
            }

        }


    }
    protected void btn_sendToAchievers_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_sendToAchievers.Enabled = true;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_viewSeekerInfo.Enabled = false;
        btn_viewSeekerPrev.Enabled = false;
        btn_viewApp.Enabled = false;
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("View_top_3_employees_username", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];

        if (txt_yearTop.Text.Equals("") || txt_monthTop.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        }
        else
        {
            int year = int.Parse(txt_yearTop.Text);
            int month = int.Parse(txt_monthTop.Text);

            cmd.Parameters.AddWithValue("@month", month);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@hrusername", username);

            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            while (rdr.Read())
            {
                Achievers.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("username")).ToString()));
            }

            rdr.Close();

            int num = Achievers.Count;

            SqlCommand email = new SqlCommand("send_email", conn);
            email.CommandType = CommandType.StoredProcedure;

            string body = "This email is to inform you of being one of the top 3 achievers for the month: " + month + " of the year " + year;

            foreach (string c in Achievers)
            {
                string recep = c;
                email.Parameters.AddWithValue("@sender", username);
                email.Parameters.AddWithValue("@subject", "Congratulations on your achievement");
                email.Parameters.AddWithValue("@body", body);
                email.Parameters.AddWithValue("@recepient", recep);

                conn.Open();
                email.ExecuteNonQuery();
                conn.Close();
            }

            Response.Write(@"<script language='javascript'>alert('" + "Sent " + num + " emails." + "');</script>");

        }


    }
    protected void btn_viewSeekerInfo_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewJobSeekerInfoHR", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = txtbox_appID.Text;

        if (username.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        }
        else
        {
            if (!SeekerID.Contains(username))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Please choose from the usernames in the table below." + "');</script>");
            }
            else
            {
                cmd.Parameters.AddWithValue("@seeker_username", username);

                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                TableHeaderRow tblhdrrw = new TableHeaderRow();

                TableHeaderCell tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Username"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("First Name"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Middle Name"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Last Name"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Age"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Birth Date"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Email"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Years of Experience"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tbl_output_table.Controls.Add(tblhdrrw);

                while (rdr.Read())
                {
                    TableRow tblrw = new TableHeaderRow();

                    TableCell tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("username")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("first_name")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("middle_name")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("last_name")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("age")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("birth_date")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("email")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("years_of_experience")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tbl_output_table.Controls.Add(tblrw);
                }

                rdr.Close();
            }
        }
    }
    protected void btn_viewSeekerPrevClick(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewPreviousJobTitlesForJobSeekerHR", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = txtbox_appID.Text;

        if (username.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        }
        else
        {
            if (!SeekerID.Contains(username))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Please choose from the usernames in the table below." + "');</script>");
            }
            else
            {
                cmd.Parameters.AddWithValue("@seeker_username", username);

                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                TableHeaderRow tblhdrrw = new TableHeaderRow();

                TableHeaderCell tblhdrcl = new TableHeaderCell();
                tblhdrcl.Controls.Add(new LiteralControl("Job Title"));
                tblhdrrw.Cells.Add(tblhdrcl);

                tbl_output_table.Controls.Add(tblhdrrw);

                while (rdr.Read())
                {
                    TableRow tblrw = new TableHeaderRow();

                    TableCell tblcl = new TableCell();
                    tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("job_title")).ToString()));
                    tblrw.Cells.Add(tblcl);

                    tbl_output_table.Controls.Add(tblrw);
                }

                rdr.Close();
            }
        }
    }
    protected void btn_evalApp_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("evaluateApplicationHR", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        if (txtbox_jobID.Text.Equals("") || txtbox_appID.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, Cyka!" + "');</script>");
        }
        else
        {
            int job_id = int.Parse(txtbox_jobID.Text);
            string username = txtbox_appID.Text;
            bool Resp = drpdwn_app.Text.Equals("Accept") ? true : false;
            string hr = (string)Session["username"]; 

            if(!jobIDs.Contains(job_id) || !SeekerID.Contains(username))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Please choose from the records that were shown in the previous tables." + "');</script>");
            }
            else
            {
                cmd.Parameters.AddWithValue("@job_id", job_id);
                cmd.Parameters.AddWithValue("@seeker_username", username);
                cmd.Parameters.AddWithValue("@hr_approval", Resp);
                cmd.Parameters.AddWithValue("@hruser", hr);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                Response.Write(@"<script language='javascript'>alert('" + "Application Evaluated!" + "');</script>");

                btn_viewAtt.Enabled = false;
                btn_viewAttbyYear.Enabled = false;
                btn_evalReq.Enabled = false;
                btn_editJob.Enabled = false;
                btn_evalApp.Enabled = false;
                btn_viewApp.Enabled = false;

                btn_viewApp_Click(sender, e);
            }
        }
    }
    protected void btn_postAnn_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_viewApp.Enabled = false;

        Response.Redirect("Announce", false);
    }
    protected void btn_addQues_Click(object sender, EventArgs e)
    {
        btn_viewAtt.Enabled = false;
        btn_viewAttbyYear.Enabled = false;
        btn_evalReq.Enabled = false;
        btn_editJob.Enabled = false;
        btn_evalApp.Enabled = false;
        btn_viewApp.Enabled = false;

        if (jobIDs.Contains(int.Parse(txt_addQues.Text)))
        {
            Session["Job"] = txt_addQues.Text;
            Response.Redirect("addQues", false);
        }
        else
        {
            Response.Write(@"<script language='javascript'>alert('" + "Please choose from the IDs shown in the table." + "');</script>");
        }
    }
    protected void btn_editJob_Click(object sender, EventArgs e)
    {
        Session["Job"] = txtbox_jobID.Text;
        Response.Redirect("EditJob", false);
    }
    protected void btn_logout_Click(object sender, EventArgs e)
    {
        Response.Redirect("logged_in", true);
    }
    protected void btn_modify_Click(object sender, EventArgs e)
    {
        Response.Redirect("modify_user_info", false);
    }
}