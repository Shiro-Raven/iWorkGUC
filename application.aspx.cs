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

public partial class application : System.Web.UI.Page
{
    static ArrayList arraylist_Interview_Questions_Answers = new ArrayList();
    static ArrayList arraylist_drpdwnlst_Interview_Questions_Answers = new ArrayList();
    static int score = 100;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("login", true);
            return;
        }
        else if (Session["job_id"] == null)
        {
            Response.Redirect("job_seeker", true);
            return;
        }

        lbl_welcome_username.Text = (string)Session["username"];

        Check_Job_Seeker(sender, e);
        Refresh_Interview_Questions(sender, e);
    }
    protected void Check_Job_Seeker(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("login", true);
            return;
        }

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
    protected void Refresh_Interview_Questions(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ConnectionString;
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("view_Interview_Questions", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@job_id", (int)Session["job_id"]);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        arraylist_Interview_Questions_Answers.Clear();
        arraylist_drpdwnlst_Interview_Questions_Answers.Clear();

        TableHeaderRow tblhdrrw = new TableHeaderRow();

        TableHeaderCell tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Question"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tblhdrcl = new TableHeaderCell();
        tblhdrcl.Controls.Add(new LiteralControl("Answer"));
        tblhdrrw.Cells.Add(tblhdrcl);

        tbl_output_table.Controls.Add(tblhdrrw);

        while (rdr.Read())
        {
            TableRow tblrw = new TableRow();

            TableCell tblcl = new TableCell();
            tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("wording"))));
            tblrw.Cells.Add(tblcl);

            tblcl = new TableCell();

            DropDownList drpdwnlst_answer = new DropDownList();
            drpdwnlst_answer.Items.Add("False");
            drpdwnlst_answer.Items.Add("True");
            tblcl.Controls.Add(drpdwnlst_answer);
            tblrw.Cells.Add(tblcl);

            tbl_output_table.Controls.Add(tblrw);

            arraylist_Interview_Questions_Answers.Add(rdr.GetValue(rdr.GetOrdinal("model_answer")).ToString());
            arraylist_drpdwnlst_Interview_Questions_Answers.Add(drpdwnlst_answer);
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
        {
            score = 100;
            Submit_Answers(sender, e);
        }
    }
    protected void Submit_Answers(object sender, EventArgs e)
    {
        Calculate_Score(sender, e);

        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("save_Score_for_certain_Job", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
        cmd.Parameters.AddWithValue("@job_id", (int)Session["job_id"]);
        cmd.Parameters.AddWithValue("@score", score);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals(("0")))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals(("1")))
            Response.Write("Empty Input(s)");
        else if (output_message.Value.ToString().Equals(("2")))
            Response.Write("NULL Input(s)");
        else if (output_message.Value.ToString().Equals(("3")))
            Response.Write("User Does Not Exist!");
        else if (output_message.Value.ToString().Equals(("4")))
            Response.Write("Job Does Not Exist!");
        else if (output_message.Value.ToString().Equals(("5")))
            Response.Write("Application Does Not Exist!");
        else if (output_message.Value.ToString().Equals(("6")))
            Response.Write("Score Out Of Range!");
        else if (output_message.Value.ToString().Equals(("7")))
        {
            Session["job_id"] = null;
            Response.Redirect("job_seeker", true);
        }
    }
    protected void Calculate_Score(object sender, EventArgs e)
    {
        if (arraylist_Interview_Questions_Answers.Count == 0)
            return;

        int correctAnswer = 0;

        for (int i = 0; i < arraylist_Interview_Questions_Answers.Count; i++)
            if (((DropDownList)arraylist_drpdwnlst_Interview_Questions_Answers[i]).SelectedValue.ToString().Equals(arraylist_Interview_Questions_Answers[i]))
                correctAnswer++;

        double tempScore = (((double)correctAnswer) / ((double)arraylist_Interview_Questions_Answers.Count)) * 100;
        score = (int)tempScore;
    }
    protected void Back_To_Job_Seeker(object sender, EventArgs e)
    {
        Session["job_id"] = null;
        Response.Redirect("job_seeker", true);
    }
}