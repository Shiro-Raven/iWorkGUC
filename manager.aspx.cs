using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class manager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
            Response.Redirect("login", true);

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("View_Personal_Info_of_Manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@user
        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));
        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        Label username_label = new Label();
        Label password_label = new Label();
        Label first_name_label = new Label();
        Label middle_name_label = new Label();
        Label last_name_label = new Label();
        Label birthdate_label = new Label();
        Label age_label = new Label();
        Label email_label = new Label();
        Label years_label = new Label();

        username_label.Text = "Username: ";
        password_label.Text = "Password: ";
        first_name_label.Text = "First Name: ";
        middle_name_label.Text = "Middle Name: ";
        last_name_label.Text = "Last Name: ";
        birthdate_label.Text = "Birthdate: ";
        age_label.Text = "Age: ";
        email_label.Text = "Email: ";
        years_label.Text = "Years of Experience: ";

        username_label.CssClass = "labels";
        password_label.CssClass = "labels";
        first_name_label.CssClass = "labels";
        middle_name_label.CssClass = "labels";
        last_name_label.CssClass = "labels";
        birthdate_label.CssClass = "labels";
        age_label.CssClass = "labels";
        email_label.CssClass = "labels";
        years_label.CssClass = "labels";
        while (rdr.Read()) {
            //Users (username, password, first_name, middle_name, last_name, birth_date, age, email, years_of_experience)
            manager_form.Controls.Add(new Literal { Text = "<h2>Personal Infromation</h2><br/>" });
            manager_form.Controls.Add(username_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("username")).ToString()+"<br/>" });
            manager_form.Controls.Add(password_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("password")).ToString() + "<br/>" });
            manager_form.Controls.Add(first_name_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("first_name")).ToString() + "<br/>" });
            manager_form.Controls.Add(middle_name_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("middle_name")).ToString() + "<br/>" });
            manager_form.Controls.Add(last_name_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("last_name")).ToString() + "<br/>" });
            manager_form.Controls.Add(birthdate_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("birth_date")).ToString() + "<br/>" });
            manager_form.Controls.Add(age_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("age")).ToString() + "<br/>" });
            manager_form.Controls.Add(email_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("email")).ToString() + "<br/>" });
            manager_form.Controls.Add(years_label);
            manager_form.Controls.Add(new Literal { Text = rdr.GetValue(rdr.GetOrdinal("years_of_experience")).ToString() + "<br/>" });
        }

        Label prev_jobs_label = new Label();
        prev_jobs_label.CssClass = "labels";
        prev_jobs_label.Text = "Previous Job Titles: ";
        manager_form.Controls.Add(new Literal { Text = "<br/>" });
        manager_form.Controls.Add(prev_jobs_label);

        conn.Close();

        conn = new SqlConnection(connString);
        cmd = new SqlCommand("View_prev_job_titles_of_Manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));

        conn.Open();

        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

       

        while (rdr.Read())
        {
            manager_form.Controls.Add(new Literal { Text = "<br/>"+rdr.GetValue(rdr.GetOrdinal("job_title")).ToString() });
        }

        conn.Close();

    }

    protected void to_manager_applications(object sender, EventArgs e)
    {
        Response.Redirect("manager_applications", true);
    }

    protected void to_manager_requests(object sender, EventArgs e)
    {
        Response.Redirect("manager_requests", true);
    }

    protected void to_project_central(object sender, EventArgs e)
    {
        Response.Redirect("project_central", true);
    }

    protected void to_staff_member(object sender, EventArgs e)
    {
        Response.Redirect("staff_member", true);
    }

    protected void to_edit_manager_info(object sender, EventArgs e)
    {
        Response.Redirect("edit_manager_info", true);
    }

    protected void to_login(object sender, EventArgs e)
    {
        Response.Redirect("login", true);
    }

}