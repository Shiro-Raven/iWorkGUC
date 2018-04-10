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
    int jobid;

    protected void Page_Load(object sender, EventArgs e)
    {
        jobid = int.Parse((string)Session["Job"]);
        lbl_jobid.Text = "Job Id: " + jobid;
        FillLabels(sender, e);
    }
    protected void FillLabels(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("viewJobInfoHR", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@job_id", jobid);

        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        while (rdr.Read())
        {
             lbl_oldtitle.Text = "Current: " + rdr.GetString(rdr.GetOrdinal("title"));
             
             lbl_oldshort.Text = "Current: " + rdr.GetString(rdr.GetOrdinal("short_description"));
             
             lbl_oldlong.Text = "Current: " + rdr.GetString(rdr.GetOrdinal("detailed_description"));
             
             lbl_oldyears.Text = "Current: " + rdr.GetValue(rdr.GetOrdinal("minimum_years_of_experience")).ToString();
             
             lbl_oldsalary.Text = "Current: " + rdr.GetValue(rdr.GetOrdinal("salary")).ToString();
             
            DateTime tmp = DateTime.Parse(rdr.GetValue(rdr.GetOrdinal("application_deadline")).ToString());
            lbl_olddead.Text = tmp.ToString("dd/MM/yyyy");
             
             lbl_oldhours.Text = "Current: " + rdr.GetValue(rdr.GetOrdinal("work_hours")).ToString();
             
             lbl_oldvacant.Text = "Current: " + rdr.GetValue(rdr.GetOrdinal("number_of_vacancies")).ToString();
        }
        rdr.Close();
    }
    protected void btn_submit_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("EditJob", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@job_id", jobid);

        SqlParameter output_message = cmd.Parameters.Add("@out", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        if (!txtbox_title.Text.ToString().Equals(""))
        {
            string title = txtbox_title.Text;
            cmd.Parameters.AddWithValue("@title", title);
        }

        if (!txtbox_shortdesc.Text.ToString().Equals(""))
        {
            string shortdesc = txtbox_shortdesc.Text;
            cmd.Parameters.AddWithValue("@short_description", shortdesc);
        }

        if (!txt_longdesc.Text.ToString().Equals(""))
        {
            string detailed = txt_longdesc.Text;
            cmd.Parameters.AddWithValue("@detailed_description", detailed);
        }

        if (!txt_years.Text.ToString().Equals(""))
        {
            int years = int.Parse(txt_years.Text);
            cmd.Parameters.AddWithValue("@minimum_years_of_experience", years);
        }

        if (!txt_salary.Text.ToString().Equals(""))
        {
            double salary = double.Parse(txt_salary.Text);
            cmd.Parameters.AddWithValue("@salary", salary);
        }

        if (!txt_deadline.Text.ToString().Equals(""))
        {
            DateTime deadline = DateTime.Parse(txt_deadline.Text);
            cmd.Parameters.AddWithValue("@application_deadline", deadline);
        }

        if (!txt_hours.Text.ToString().Equals(""))
        {
            int hours = int.Parse(txt_hours.Text);
            cmd.Parameters.AddWithValue("@work_hours", hours);
        }

        if (!txt_vacant.Text.ToString().Equals(""))
        {
            int vacancies = int.Parse(txt_vacant.Text);
            cmd.Parameters.AddWithValue("@number_of_vacancies", vacancies);
        }

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals("0"))
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave any empty fields, cyka!" + " .');</script>");
        else if (output_message.Value.ToString().Equals("1"))
            Response.Write(@"<script language='javascript'>alert('" + "The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - ." + "');</script>");
        else if (output_message.Value.ToString().Equals("2"))
            Response.Write(@"<script language='javascript'>alert('" + "THIS IS SLAVERY" + "');</script>");
        else
        {
            Response.Write(@"<script language='javascript'>alert('" + "Edits Applied!" + "');</script>");
            FillLabels(sender, e);
        }
        
        
        

    }
    protected void close_Click(object sender, EventArgs e)
    {
        Response.Redirect("hr_employee", true);
    }

}