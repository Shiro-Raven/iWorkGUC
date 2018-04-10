using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Text;

public partial class manage_tasks : System.Web.UI.Page
{
    protected DropDownList projects_ddl = new DropDownList();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["task_error"] != null)
        {
            Response.Write(Session["task_error"].ToString());
            Session["task_error"] = null;
        }
        //establish connection
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        //reference procedure
        SqlCommand cmd = new SqlCommand("Get_projects_in_department", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manuser", username));

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        int counter = 0;
        while (rdr.Read())
        {
            //add item to dropdown list
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("company_domain")).ToString() + "/" + rdr.GetValue(rdr.GetOrdinal("name")).ToString();
            projects_ddl.Items.Add(listItem);
            counter++;
        }
        manage_tasks_form.Controls.Add(new Literal { Text = "<h3>Please select a project from the following list. Then choose the action you want to perform.</h3>" });
        if (counter == 0)
            manage_tasks_form.Controls.Add(new Literal { Text = "Oops, there are no projects in your department yet. Please create a project first." });
        else
        {
            manage_tasks_form.Controls.Add(projects_ddl);

            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
            //create_task button
            Button create_task_button = new Button();
            create_task_button.Text = "Create a New Task in this project.";
            create_task_button.Click += new EventHandler(to_create_task);
            manage_tasks_form.Controls.Add(create_task_button);
            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
            //create the change_regular_employee_working_on_task_button
            Button change_regular_employee_working_on_task = new Button();
            change_regular_employee_working_on_task.Text = "Change the Regular Employee working on a task in this project.";
            change_regular_employee_working_on_task.Click += new EventHandler(to_change_regular_employee_working_on_task);
            manage_tasks_form.Controls.Add(change_regular_employee_working_on_task);
            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
            //create the view_tasks_by_status
            Button view_tasks_by_status = new Button();
            view_tasks_by_status.Text = "View the tasks in this project by status.";
            view_tasks_by_status.Click += new EventHandler(to_view_tasks_by_status);
            manage_tasks_form.Controls.Add(view_tasks_by_status);
            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
            //Review the tasks
            Button review_tasks = new Button();
            review_tasks.Text = "Review Tasks in this Project.";
            review_tasks.Click += new EventHandler(to_review_tasks);
            manage_tasks_form.Controls.Add(review_tasks);
            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
            //View and add comments to the tasks
            Button task_comments_button = new Button();
            task_comments_button.Text = "View/Add comments to tasks in this project.";
            task_comments_button.Click += new EventHandler(to_task_comments);
            manage_tasks_form.Controls.Add(task_comments_button);
            manage_tasks_form.Controls.Add(new Literal { Text = "<br/><br/>" });
        }
        conn.Close();
    }


    protected void to_project_central(object sender, EventArgs e)
    {
        Response.Redirect("project_central");
    }

    protected void to_create_task(object sender, EventArgs e)
    {
        Session["project_for_task_creation"] = projects_ddl.SelectedItem.Text;
        Response.Redirect("create_task");
    }

    protected void to_change_regular_employee_working_on_task(object sender, EventArgs e)
    {
        Session["project_for_change_regular_employee_working_on_task"] = projects_ddl.SelectedItem.Text;
        Response.Redirect("change_regular_employee_working_on_task");
    }

    protected void to_view_tasks_by_status(object sender, EventArgs e)
    {
        Session["project_for_view_tasks_by_status"] = projects_ddl.SelectedItem.Text;
        Response.Redirect("view_tasks_by_status");
    }

    protected void to_review_tasks(object sender, EventArgs e)
    {
        Session["project_for_review_tasks"] = projects_ddl.SelectedItem.Text;
        Response.Redirect("review_tasks");
    }

    protected void to_task_comments(object sender, EventArgs e)
    {
        Session["project_for_task_comments"] = projects_ddl.SelectedItem.Text;
        Response.Redirect("task_comments");
    }

}