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

public partial class modify_info : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        if (Session["username"] == null)
        {
            Response.Redirect("login", true);
            return;
        }

        txtbox_username.Text = (string)Session["Username"];
        txtbox_password.Text = (string)Session["password"];
        txtbox_first_name.Text = (string)Session["first_name"];
        txtbox_middle_name.Text = (string)Session["middle_name"];
        txtbox_last_name.Text = (string)Session["last_name"];
        txtbox_birth_date.Text = (string)Session["birth_date"];
        txtbox_email.Text = (string)Session["email"];
        txtbox_years_of_experience.Text = (string)Session["years_of_experience"];
    }
    protected void Update(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("update_User_info", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        if (txtbox_birth_date.Text.Equals("") || txtbox_password.Text.Equals("") || txtbox_first_name.Text.Equals("") || txtbox_middle_name.Text.Equals("") ||
            txtbox_last_name.Text.Equals("") || txtbox_birth_date.Text.Equals("") || txtbox_email.Text.Equals("") || txtbox_years_of_experience.Text.Equals(""))
        {
            Response.Write("Empty Input(s)");
            return;
        }

        string username = (string)Session["username"];
        string password = txtbox_password.Text;
        string first_name = txtbox_first_name.Text;
        string middle_name = txtbox_middle_name.Text;
        string last_name = txtbox_last_name.Text;
        string birth_date = txtbox_birth_date.Text;
        string email = txtbox_email.Text;
        int yeears_of_experience = int.Parse(txtbox_years_of_experience.Text);

        cmd.Parameters.AddWithValue("@username", username);
        cmd.Parameters.AddWithValue("@password", password);
        cmd.Parameters.AddWithValue("@first_name", first_name);
        cmd.Parameters.AddWithValue("@middle_name", middle_name);
        cmd.Parameters.AddWithValue("@last_name", last_name);
        cmd.Parameters.AddWithValue("@birthdate", birth_date);
        cmd.Parameters.AddWithValue("@email", email);
        cmd.Parameters.AddWithValue("@years_of_experience", yeears_of_experience);

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (output_message.Value.ToString().Equals("0"))
            Response.Write("Invalid Input(s)");
        else if (output_message.Value.ToString().Equals("1"))
            Response.Write(("Empty Input(s)"));
        else if (output_message.Value.ToString().Equals("2"))
            Response.Write("Null Input(s)");
        else if (output_message.Value.ToString().Equals("3"))
            Response.Write("User Name Does Not Exist!");
        else if (output_message.Value.ToString().Equals("4"))
            Response.Write("Email Already Exists!");
        else if (output_message.Value.ToString().Equals("5"))
            Response.Write("Password Must Be At Least 8 Characters");
        else if (output_message.Value.ToString().Equals("6"))
            Response.Write("User Must Be At Least 18 years Old");
        else if (output_message.Value.ToString().Equals("7"))
            Response.Write("Years Of Experience Must Be At Least 0 (ZERO)!");
        else if (output_message.Value.ToString().Equals("8"))
            Response.Write("UPDATED!");

        update_Session(sender, e);
    }
    protected void update_Session(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("get_User_info", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        string username = (string)Session["username"];
        cmd.Parameters.AddWithValue("@username", username);

        SqlParameter password = cmd.Parameters.Add("@password", SqlDbType.VarChar, 200);
        password.Direction = ParameterDirection.Output;

        SqlParameter first_name = cmd.Parameters.Add("@first_name", SqlDbType.VarChar, 60);
        first_name.Direction = ParameterDirection.Output;

        SqlParameter middle_name = cmd.Parameters.Add("@middle_name", SqlDbType.VarChar, 60);
        middle_name.Direction = ParameterDirection.Output;

        SqlParameter last_name = cmd.Parameters.Add("@last_name", SqlDbType.VarChar, 60);
        last_name.Direction = ParameterDirection.Output;

        SqlParameter birth_date = cmd.Parameters.Add("@birth_date", SqlDbType.DateTime);
        birth_date.Direction = ParameterDirection.Output;

        SqlParameter age = cmd.Parameters.Add("@age", SqlDbType.Int);
        age.Direction = ParameterDirection.Output;

        SqlParameter email = cmd.Parameters.Add("@email", SqlDbType.VarChar, 120);
        email.Direction = ParameterDirection.Output;

        SqlParameter years_of_experience = cmd.Parameters.Add("@years_of_experience", SqlDbType.Int);
        years_of_experience.Direction = ParameterDirection.Output;

        SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
        output_message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        Session["password"] = password.Value.ToString();
        Session["first_name"] = first_name.Value.ToString();
        Session["middle_name"] = middle_name.Value.ToString();
        Session["last_name"] = last_name.Value.ToString();
        Session["birth_date"] = birth_date.Value.ToString();
        Session["age"] = age.Value.ToString();
        Session["email"] = email.Value.ToString();
        Session["years_of_experience"] = years_of_experience.Value.ToString();
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
}