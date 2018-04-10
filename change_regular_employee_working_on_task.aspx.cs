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

public partial class change_regular_employee_working_on_task : System.Web.UI.Page
{
    protected DropDownList tasks_ddl = new DropDownList();
    protected DropDownList project_employees = new DropDownList();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["change_regular_success"] != null)
        {
            Response.Write(Session["change_regular_success"]);
            Session["change_regular_success"] = null;
        }
        string[] project_pk = Session["project_for_change_regular_employee_working_on_task"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];
      

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("View_tasks_in_proj_with_status", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@compdomain varchar(120), @projname varchar(200), @status varchar(20)
        cmd.Parameters.Add(new SqlParameter("@compdomain",company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@manager_username", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@status", "Assigned"));

        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        StringBuilder tasks_table = new StringBuilder();
        tasks_table.Append("<table><tr><th>Name</th><th>Description</th><th>Deadline</th><th>Currently Assigned To</th></tr>");

        int counter1 = 0;

        while (rdr.Read())
        {
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("name")).ToString();
            tasks_ddl.Items.Add(listItem);

            tasks_table.Append("<tr><th>" + rdr.GetValue(rdr.GetOrdinal("name")) + "</th>"
                + "<th> " + rdr.GetValue(rdr.GetOrdinal("description")) + "</th>"
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("deadline")) + "</th> "
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("employee_username")) + "</th></tr>"
                );
            counter1++;
        }

        tasks_table.Append("</table>");
        conn.Close();
        //add drop down list containing the usernames of the employees currently assigned to project
        conn = new SqlConnection(connString);

        cmd = new SqlCommand("currently_assigned_to_project", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@company_domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@project_name", project_name));
        conn.Open();
        rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

        int counter2 = 0;
        while (rdr.Read())
        {
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("employee_username")).ToString();
            project_employees.Items.Add(listItem);
            counter2++;
        }

        if(counter1==0)
            change_regular_task_form.Controls.Add(new Literal
            {
                Text = "<H2>There are no tasks in " + project_name + " with status assigned that you created.</H2>"
            });
        else if(counter2==0)
            change_regular_task_form.Controls.Add(new Literal
            {
                Text = "<H2>There are no regular employees currently assigned to " + project_name + ".</H2>"
            });
        else
        { 

            change_regular_task_form.Controls.Add(new Literal
            {
                Text = "<H2>Task Reassignment: Project " + project_name + "</H2>" +
         "<H3>Please select a task and a new employee to be assigned to it. <br/>" +
         "Note that only tasks with status \"assigned\" appear, since only those can be reassigned to new employees.</H3>"
            });
            Label task_label = new Label();
            task_label.Text = "Choose Task: ";
            change_regular_task_form.Controls.Add(task_label);

            change_regular_task_form.Controls.Add(tasks_ddl);

            change_regular_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Label new_employee_label = new Label();
            new_employee_label.Text = "Choose New Regular Employee: ";
            change_regular_task_form.Controls.Add(new_employee_label);

            change_regular_task_form.Controls.Add(project_employees);
            change_regular_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Button change_regular_employee_button = new Button();
            change_regular_employee_button.Text = "Replace the Regular Employee";
            change_regular_employee_button.Click += new EventHandler(perform_change);
            change_regular_task_form.Controls.Add(change_regular_employee_button);

            change_regular_task_form.Controls.Add(new Literal { Text = "<br/>" });
            change_regular_task_form.Controls.Add(new Literal { Text = "<H3>Extra Information about the Tasks with Status Assigned</H3>" });
            change_regular_task_form.Controls.Add(new Literal { Text = tasks_table.ToString() });
        }
        conn.Close();
    }
    protected void perform_change(object sender, EventArgs e)
    {
        string[] project_pk = Session["project_for_change_regular_employee_working_on_task"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];
        string taskname = tasks_ddl.SelectedItem.Text;
        string manager_username = Session["username"].ToString();
        string employee_username = project_employees.SelectedItem.ToString();

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("alter_employee_of_task", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@domain varchar(120) , @projname varchar(200),@taskname varchar(200), @manuser varchar(100), @employee varchar(100)
        cmd.Parameters.Add(new SqlParameter("@domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@taskname", taskname));
        cmd.Parameters.Add(new SqlParameter("@manuser", manager_username));
        cmd.Parameters.Add(new SqlParameter("@employee", employee_username));

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        Session["change_regular_success"] = employee_username + " has been successfully assigned to " + taskname + " instead of the previous employee.";

        Response.Redirect("change_regular_employee_working_on_task");

    }
    protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks", true);
    }
}