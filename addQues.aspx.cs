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

public partial class Default2 : System.Web.UI.Page
{
    int jobid;
    ArrayList Quest;

    protected void Page_Load(object sender, EventArgs e)
    {
        jobid = int.Parse((string)Session["Job"]);
        lbl_jobid.Text = "Job Id: " + jobid;
        view_Questions(sender, e);
    }
    protected void view_Questions(object sender, EventArgs e)
    {
        tbl_output_table.Rows.Clear();

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewJobQuestionsbyID", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        Quest = new ArrayList();

        cmd.Parameters.AddWithValue("@jobid", jobid);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Question ID"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Wording"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Model Answer"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableHeaderRow();

            TableCell tblcl = new TableCell();
            string tmp = rdr.GetValue(rdr.GetOrdinal("question_id")).ToString();
            Quest.Add(int.Parse(tmp));
            tblcl.Controls.Add(new LiteralControl(tmp));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("wording")).ToString()));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("model_answer")).ToString()));
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);
        }

        rdr.Close();
    }
    protected void close_Click(object sender, EventArgs e)
    {
        Session["Job"] = null;
        Response.Redirect("hr_employee",true);
    }
    protected void btn_submitquest_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("addJobQuestions", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        if (txt_quest.Text.Equals(""))
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, cyka!" + "');</script>");
        else {
            bool answer = drpdwnlst_answer.Text.Equals("Yes") ? true : false;

            cmd.Parameters.AddWithValue("@model_answer", answer);
            cmd.Parameters.AddWithValue("@wording", txt_quest.Text);
            cmd.Parameters.AddWithValue("@job_id", jobid);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            view_Questions(sender, e);
            
         }
    }
    protected void btn_delete_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("deleteJobQuestion", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        if (txt_questID.Text.Equals(""))
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave empty fields, cyka!" + "');</script>");
        else
        {
            if (Quest.Contains(int.Parse(txt_questID.Text)))
            {
                cmd.Parameters.AddWithValue("@question_id", int.Parse(txt_questID.Text));

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                view_Questions(sender, e);
            }
            else
            {
                Response.Write(@"<script language='javascript'>alert('" + "Choose from the IDs in the table." + "');</script>");
            }
        }
    }
}