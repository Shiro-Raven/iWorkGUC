using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class edit_manager_info : System.Web.UI.Page
{
    protected TextBox password_textbox = new TextBox();
    protected TextBox first_name_textbox = new TextBox();
    protected TextBox middle_name_textbox = new TextBox();
    protected TextBox last_name_textbox = new TextBox();
    protected TextBox birthdate_textbox = new TextBox();
    protected TextBox email_textbox = new TextBox();
    protected TextBox years_of_experience_textbox = new TextBox();
    protected TextBox add_new_jobtitle_textbox = new TextBox();

    protected DropDownList previous_jobtitles_ddl = new DropDownList();

    protected void Page_Load(object sender, EventArgs e)
    {
        if(Session["edit_message"] != null)
        {
            Response.Write(Session["edit_message"]);
            Session["edit_message"] = null;
        }

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("View_prev_job_titles_of_Manager", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));

        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        int counter = 0;
        while (rdr.Read())
        {
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("job_title")).ToString();
            previous_jobtitles_ddl.Items.Add(listItem);
            counter++;
        }

        conn.Close();

        Label passwordLabel = new Label(); passwordLabel.Text = "New Password: ";
        Label firstnameLabel = new Label(); firstnameLabel.Text = "New First Name: ";
        Label middlenameLabel = new Label(); middlenameLabel.Text = "New Middle Name: ";
        Label lastnameLabel = new Label(); lastnameLabel.Text = "New Last Name: ";
        Label birthdateLabel = new Label(); birthdateLabel.Text = "New Birthdate: ";
        Label emailLabel = new Label(); emailLabel.Text = "New Email: ";
        Label yearsLabel = new Label(); yearsLabel.Text = "New Years of Experience: ";

        passwordLabel.CssClass = "labels";
        firstnameLabel.CssClass = "labels";
        middlenameLabel.CssClass = "labels";
        lastnameLabel.CssClass = "labels";
        birthdateLabel.CssClass = "labels";
        emailLabel.CssClass = "labels";
        yearsLabel.CssClass = "labels";

        Button submit_update_button = new Button();
        submit_update_button.Text = "Update Personal Info";
        submit_update_button.Click += new EventHandler(update_personal_info);

        Button add_jobtitle_button = new Button();
        add_jobtitle_button.Text = "Add a New Title";
        add_jobtitle_button.Click += new EventHandler(add_new_title);

        Button delete_jobtitle_button = new Button();
        delete_jobtitle_button.Text = "Delete Selected Title";
        delete_jobtitle_button.Click += new EventHandler(delete_title);


        edit_form.Controls.Add(new Literal { Text = "<H2>Update your personal information, " + Session["username"].ToString() + ".</H2>" });

        edit_form.Controls.Add(passwordLabel); edit_form.Controls.Add(password_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(firstnameLabel); edit_form.Controls.Add(first_name_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(middlenameLabel); edit_form.Controls.Add(middle_name_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(lastnameLabel); edit_form.Controls.Add(last_name_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(birthdateLabel); edit_form.Controls.Add(birthdate_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(emailLabel); edit_form.Controls.Add(email_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(yearsLabel); edit_form.Controls.Add(years_of_experience_textbox);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });
        edit_form.Controls.Add(submit_update_button);

        edit_form.Controls.Add(new Literal { Text = "<H3>Edit Previous Job Titles: </H3>" });
        edit_form.Controls.Add(add_new_jobtitle_textbox); edit_form.Controls.Add(add_jobtitle_button);
        edit_form.Controls.Add(new Literal { Text = "<br/>" });

        if (counter > 0)
        {
            edit_form.Controls.Add(previous_jobtitles_ddl); edit_form.Controls.Add(delete_jobtitle_button);
            edit_form.Controls.Add(new Literal { Text = "<br/>" });
        }
        else
        {
            edit_form.Controls.Add(new Literal { Text = "You have entered zero previous job titles so far.<br/>" });
        }

    }

    protected void update_personal_info(object sender, EventArgs e)
    {
        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("Edit_Personal_Info_of_Manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@user varchar(100), @pass varchar(200)= null, @first varchar(60)= null,@middle varchar(60)= null, 
        //@last varchar(60)= null,@birth datetime = null,@email varchar(120) = null,@years int= null,@message int
        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@pass", password_textbox.Text));
        cmd.Parameters.Add(new SqlParameter("@first", first_name_textbox.Text));
        cmd.Parameters.Add(new SqlParameter("@middle", middle_name_textbox.Text));
        cmd.Parameters.Add(new SqlParameter("@last", last_name_textbox.Text)); 
        cmd.Parameters.Add(new SqlParameter("@email", email_textbox.Text));

        int years_integer;

        if (!Int32.TryParse(years_of_experience_textbox.Text, out years_integer) && !years_of_experience_textbox.Text.Equals(""))
        {
            Response.Write("Invalid years of experience. Please enter a number in the years of experience textbox.");
            return;
        }
        if (years_integer < 0)
        {
            Response.Write("Invalid years of experience. Please enter a non-negative number in the years of experience textbox.");
            return;
        }
        cmd.Parameters.Add(new SqlParameter("@years",years_integer));

        DateTime birth_datetime;

        if (!DateTime.TryParse(birthdate_textbox.Text, out birth_datetime) && !birthdate_textbox.Text.Equals(""))
        {
            Response.Write("Invalid new birth date. Please format the date correctly as MM/DD/YYYY.");
            return;
        }
        else
        {
            if(!DateTime.TryParse(birthdate_textbox.Text, out birth_datetime) && birthdate_textbox.Text.Equals(""))
            {
                cmd.Parameters.Add(new SqlParameter("@birth", DBNull.Value));
            }
            else
            {
                cmd.Parameters.Add(new SqlParameter("@birth", birth_datetime));
            }

        }
        
        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        switch (message.Value.ToString())
        {
            case "0":
                Response.Write("The email you entered is already in use. Please enter a different email.");
                break;
            default:
                Session["edit_message"] = "Your information has been successfully updated. You may choose to make more edits or go back.";
                Response.Redirect("edit_manager_info", true);
                break;
        }



    }

    protected void add_new_title(object sender, EventArgs e)
    {
        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("Add_Prev_Titles_of_Manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@newtitle", add_new_jobtitle_textbox.Text));
        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        switch (message.Value.ToString())
        {
            case "0":
                Response.Write("Invalid input. Please type a new job title into the textbox before attempting to add it.");
                break;
            case "1":
                Response.Write("The job title already exists. There is no need to add it again.");
                break;
            default:
                Session["edit_message"] = "The job title has been successfully added.";
                Response.Redirect("edit_manager_info", true);
                break;
        }
        
    }

    protected void delete_title(object sender, EventArgs e)
    {
        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("Delete_Prev_title_of_Manager", conn);
        cmd.CommandType = System.Data.CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@user", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@oldtitle", previous_jobtitles_ddl.SelectedItem.Text));

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        Session["edit_message"] = "The job title has been successfully deleted.";
        Response.Redirect("edit_manager_info", true);
    }



    protected void to_manager(object sender, EventArgs e)
    {
        Response.Redirect("manager", true);
    }





}