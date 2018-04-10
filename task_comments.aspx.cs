using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class task_comments : System.Web.UI.Page
{
    DropDownList tasks_ddl = new DropDownList();
    TextBox comment_content_textbox = new TextBox();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["comment_added"] != null)
        {
            Response.Write(Session["comment_added"]);
            Session["comment_added"] = null;
        }

        string[] project_pk = Session["project_for_task_comments"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);


        //reference procedure
        SqlCommand cmd = new SqlCommand("retrieve_task_comments", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manager_username", username));
        cmd.Parameters.Add(new SqlParameter("@project_name", project_name));
        cmd.Parameters.Add(new SqlParameter("@company_domain", company_domain));

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        StringBuilder comments_table = new StringBuilder();

        comments_table.Append("<table><tr><th>Task</th><th>Comment Number</th><th>Comment</th></tr>");

        int counter = 0;
        while (rdr.Read())
        {
            //add rows to table
            comments_table.Append("<tr><th>" + rdr.GetValue(rdr.GetOrdinal("task_name")).ToString()
                + "</th><th>" + rdr.GetValue(rdr.GetOrdinal("comment_number")).ToString()
                + "</th><th>" + rdr.GetValue(rdr.GetOrdinal("comment_content")).ToString()
                + "</th></tr>");
            counter++;
        }
        comments_table.Append("</table>");
        conn.Close();

        comments_form.Controls.Add(new Literal { Text = "<h4>The following table shows all the comments on the tasks you created.</h4>" });
        comments_form.Controls.Add(new Literal { Text = comments_table.ToString() });
        comments_form.Controls.Add(new Literal { Text = "There are " + counter + " comments on all tasks in this project." });
        conn = new SqlConnection(connString);

        //reference procedure
        cmd = new SqlCommand("retrieve_tasks_created_by_manager", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        cmd.Parameters.Add(new SqlParameter("@manager_username", username));
        cmd.Parameters.Add(new SqlParameter("@project_name", project_name));
        cmd.Parameters.Add(new SqlParameter("@company_domain", company_domain));

        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        counter = 0;
        while (rdr.Read())
        {
            //add item to dropdown list
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("task_name")).ToString();
            tasks_ddl.Items.Add(listItem);
            counter++;
        }

        conn.Close();

        if (counter == 0)
        {
            comments_form.Controls.Add(new Literal { Text = "<h3>There are no tasks in this project yet. Add tasks before adding comments.</h3>" });
        }
        else
        {
            comments_form.Controls.Add(new Literal { Text = "<h3>Select a task and add comments.</h3>" });
            comments_form.Controls.Add(tasks_ddl);
            comments_form.Controls.Add(new Literal { Text = "<h4>Comment: </h4>" });
            comments_form.Controls.Add(comment_content_textbox);
            Button add_comment_button = new Button();
            add_comment_button.Click += new EventHandler(add_comment);
            add_comment_button.Text = "Add New Comment";
            comments_form.Controls.Add(add_comment_button);
        }
    }

    protected void add_comment(object sender, EventArgs e)
    {
        string[] project_pk = Session["project_for_task_comments"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);


        //reference procedure
        SqlCommand cmd = new SqlCommand("add_new_task_comment", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@project_name", project_name));
        cmd.Parameters.Add(new SqlParameter("@company_domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@task_name", tasks_ddl.SelectedItem.Text));
        cmd.Parameters.Add(new SqlParameter("@comment_content", comment_content_textbox.Text));
        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (message.Value.ToString().Equals("0"))
        {
            Response.Write("Please write the contents of the comment before adding it.");
        }
        else
        {
            Session["comment_added"] = "Your comment has been added successfully.";
            Response.Redirect("task_comments", true);
        }
    }

    protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks", true);
    }



}