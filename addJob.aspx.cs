using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class addJob : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    protected void btn_submit_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("addJob", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];
        

        if (txtbox_title.Text.Equals("") ||
            txtbox_shortdesc.Text.Equals("") ||
            txt_longdesc.Text.Equals("") ||
            txt_years.Text.Equals("") ||
            txt_salary.Text.Equals("") ||
            txt_deadline.Text.Equals("") ||
            txt_hours.Text.Equals("") ||
            txt_vacant.Text.Equals(""))
        {
            Response.Write(@"<script language='javascript'>alert('" + "Do not leave any empty fields, cyka!" + "');</script>");
        }
        else
        {
            string title = txtbox_title.Text;
            string shortdesc = txtbox_shortdesc.Text;
            string detailed = txt_longdesc.Text;
            int years = int.Parse(txt_years.Text);
            double salary = double.Parse(txt_salary.Text);
            DateTime deadline = DateTime.Parse(txt_deadline.Text);
            int hours = int.Parse(txt_hours.Text);
            int vacancies = int.Parse(txt_vacant.Text);

            SqlParameter output_message = cmd.Parameters.Add("@out", SqlDbType.Int);
            output_message.Direction = ParameterDirection.Output;

            cmd.Parameters.AddWithValue("@creator_username", username);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@detailed_description", detailed);
            cmd.Parameters.AddWithValue("@short_description", shortdesc);
            cmd.Parameters.AddWithValue("@minimum_years_of_experience", years);
            cmd.Parameters.AddWithValue("@salary", salary);
            cmd.Parameters.AddWithValue("@application_deadline", deadline);
            cmd.Parameters.AddWithValue("@work_hours", hours);
            cmd.Parameters.AddWithValue("@number_of_vacancies", vacancies);


            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            if (output_message.Value.ToString().Equals("0"))
                Response.Write(@"<script language='javascript'>alert('" + "Do not leave any empty fields, cyka!" + " .');</script>");
            else if (output_message.Value.ToString().Equals("1"))
                Response.Write(@"<script language='javascript'>alert('" + "The title of the job should start with the format: Manager - , HR Employee - , or Regular Employee - ." + "');</script>");
            else if (output_message.Value.ToString().Equals("2"))
                Response.Write(@"<script language='javascript'>alert('" + "THIS IS SLAVERY" + "');</script>");
            else if (output_message.Value.ToString().Equals("3"))
            {
                Response.Write(@"<script language='javascript'>alert('" + "Job Added!" + "');</script>");
                txtbox_title.Text = "";
                txtbox_shortdesc.Text = "";
                txt_longdesc.Text = "";
                txt_years.Text = "";
                txt_salary.Text = "";
                txt_deadline.Text = "";
                txt_hours.Text = "";
                txt_vacant.Text = "";
            }


        }



    }
    protected void close_Click(object sender, EventArgs e)
    {
        Response.Redirect("hr_employee",true);
    }
}