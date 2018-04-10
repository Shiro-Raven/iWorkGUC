using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class create_task : System.Web.UI.Page
{
    protected TextBox task_name_textbox = new TextBox();
    protected TextBox task_description_textbox = new TextBox();
    protected TextBox task_deadline_textbox = new TextBox();
    protected DropDownList employees_in_project = new DropDownList();

    protected void Page_Load(object sender, EventArgs e)
    {
        string[] project_pk = Session["project_for_task_creation"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];
        string manager_username = Session["username"].ToString();

        //add drop down list containing the usernames of the employees currently assigned to project
        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("currently_assigned_to_project", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add(new SqlParameter("@company_domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@project_name", project_name));
        conn.Open();
        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        int counter = 0;
        while (rdr.Read())
        {
            ListItem listItem = new ListItem();
            listItem.Text = rdr.GetValue(rdr.GetOrdinal("employee_username")).ToString();
            employees_in_project.Items.Add(listItem);
            counter++;
        }

        if (counter == 0)
        {
            create_task_form.Controls.Add(new Literal
            { Text = "<H4> A manager has to assign employees to a newly-created task.<br/>" + 
            manager_username + ", there are currently no employees assigned to this project. " +
            "Assign at least one employee first before creating a task.<br/>" +
            "Otherwise, you will not be able to assign any employees to this task.</H4>" });
        }
        else
        {

            create_task_form.Controls.Add(new Literal { Text = "<H2>" + manager_username + ", please enter the details of the task.</H2>" });

            Label company_label = new Label();
            company_label.Text = "Company: " + company_domain;
            create_task_form.Controls.Add(company_label);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Label project_label = new Label();
            project_label.Text = "Project: " + project_name;
            create_task_form.Controls.Add(project_label);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Label task_name_label = new Label();
            task_name_label.Text = "Task Name: ";
            create_task_form.Controls.Add(task_name_label);
            create_task_form.Controls.Add(task_name_textbox);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Label task_description_label = new Label();
            task_description_label.Text = "Description: ";
            create_task_form.Controls.Add(task_description_label);
            create_task_form.Controls.Add(task_description_textbox);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Label task_deadline_label = new Label();
            task_deadline_label.Text = "Deadline: ";
            create_task_form.Controls.Add(task_deadline_label);
            create_task_form.Controls.Add(task_deadline_textbox);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            create_task_form.Controls.Add(new Literal { Text = "Choose an employee to assign to the task: " });
            create_task_form.Controls.Add(employees_in_project);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });

            Button create_task_button = new Button();
            create_task_button.Text = "Create Task";
            create_task_button.Click += new EventHandler(create_new_task);
            create_task_form.Controls.Add(create_task_button);
            create_task_form.Controls.Add(new Literal { Text = "<br/>" });
        }
        conn.Close();
    }



    protected void create_new_task(object sender, EventArgs e)
    {   
        string[] project_pk = Session["project_for_task_creation"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];
        string manager_username = Session["username"].ToString();
        string description = task_description_textbox.Text;
        string task_name = task_name_textbox.Text;

        string deadline_string = task_deadline_textbox.Text;
        DateTime deadline;

        if (!DateTime.TryParse(deadline_string, out deadline))
        {
            Response.Write("The date you entered was not formatted correctly. Please enter it in the format MM/DD/YYYY.");
            return;
        }

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("create_task_in_project", conn);
        cmd.CommandType = CommandType.StoredProcedure;

      

        //@domain varchar(120) , @projname varchar(200),@taskname varchar(200)= null,@desc varchar(MAX)= null, 
        //@end datetime = null, @manuser varchar(100), @message int output
        cmd.Parameters.Add(new SqlParameter("@domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@taskname",task_name));
        cmd.Parameters.Add(new SqlParameter("@desc", description));
        cmd.Parameters.Add(new SqlParameter("@end",deadline));
        cmd.Parameters.Add(new SqlParameter("@manuser", manager_username));

        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        switch (message.Value.ToString())
        {
            case "0":
                Response.Write("The task name was left empty. Please enter a valid task name.");
                return;
            case "1":
                Response.Write("The deadline was left empty. Please enter a valid deadline");
                return;
            case "2":
                Response.Write("The description was left empty. Please enter a valid description.");
                return;
            case "3":
                Response.Write("A task with the same name already exists in this project.");
                return;
            default:
                break;
        }

        //if no errors occurred proceed to assign an employee to this newly created task
        conn = new SqlConnection(connString);

        cmd = new SqlCommand("assign_employee_to_task", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@domain varchar(120) , @projname varchar(200),
        //@taskname varchar(200), @manuser varchar(100), @employee varchar(100), @message int output

        cmd.Parameters.Add(new SqlParameter("@domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@taskname", task_name));
        cmd.Parameters.Add(new SqlParameter("@manuser", manager_username));
        cmd.Parameters.Add(new SqlParameter("@employee", employees_in_project.SelectedItem.Text));

        SqlParameter message2 = cmd.Parameters.Add("@message", SqlDbType.Int);
        message2.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        if (message2.Value.ToString().Equals("0"))
            Response.Write("Another employee is already assigned to this task.");
        else
        {
            if (message2.Value.ToString().Equals("1"))
            {
                Session["task_error"] = "The task " + task_name + " was created in project " + project_name + " And " + employees_in_project.SelectedItem.Text + " was assigned to it.";
                Response.Redirect("manage_tasks");
            }
        }

    }


        protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks", true);
    }
}