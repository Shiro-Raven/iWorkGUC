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

public partial class review_tasks : System.Web.UI.Page
{
    protected DropDownList tasks_ddl = new DropDownList();
    protected DropDownList response_ddl = new DropDownList();
    protected TextBox new_deadline_textbox = new TextBox();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["review_success"] != null)
        {
            Response.Write(Session["review_success"].ToString());
            Session["review_success"] = null;
        }

        string[] project_pk = Session["project_for_review_tasks"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("View_tasks_in_proj_with_status", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@compdomain varchar(120), @projname varchar(200), @status varchar(20)
        cmd.Parameters.Add(new SqlParameter("@compdomain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@manager_username", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@status", "Fixed"));

        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        StringBuilder tasks_table = new StringBuilder();
        tasks_table.Append("<table><tr><th>Name</th><th>Description</th><th>Deadline</th><th>Currently Assigned To</th></tr>");

        int counter = 0;
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

            counter++;
        }
        conn.Close();
        tasks_table.Append("</table>");
        if (counter > 0)
        {
            review_tasks_form.Controls.Add(new Literal
            {
                Text = "<h2>Review Tasks in project " + project_name + "</h2>" +
    "<h3>Please choose a task to review and enter your response.</h3>"
            });

            Label task_label = new Label();
            task_label.Text = "Choose Task: ";
            review_tasks_form.Controls.Add(task_label);


            review_tasks_form.Controls.Add(tasks_ddl);

            review_tasks_form.Controls.Add(new Literal { Text = "<br/>" });

            Label response_label = new Label();
            response_label.Text = "Response: ";
            review_tasks_form.Controls.Add(response_label);

            ListItem accept_item = new ListItem();
            accept_item.Text = "Accept";
            ListItem reject_item = new ListItem();
            reject_item.Text = "Reject";
            response_ddl.Items.Add(accept_item);
            response_ddl.Items.Add(reject_item);

            review_tasks_form.Controls.Add(response_ddl);

            review_tasks_form.Controls.Add(new Literal { Text = "<br/>" });

            Label new_deadline_label = new Label();
            new_deadline_label.Text = "New Deadline: ";
            review_tasks_form.Controls.Add(new_deadline_label);

            review_tasks_form.Controls.Add(new_deadline_textbox);

            review_tasks_form.Controls.Add(new Literal { Text = "<br/>" });

            Button submit_button = new Button();
            submit_button.Text = "Submit Review";
            submit_button.Click += new EventHandler(submit_review);
            review_tasks_form.Controls.Add(submit_button);

            review_tasks_form.Controls.Add(new Literal { Text = "<H3>Details of Tasks with Status Fixed: </H3>" });
            review_tasks_form.Controls.Add(new Literal { Text = tasks_table.ToString() });
            review_tasks_form.Controls.Add(new Literal { Text = "<h3> There are currently " + counter + " tasks that can be reviewed." });
        }
        else
        {
            review_tasks_form.Controls.Add(new Literal
            {
                Text = "<h2>Review Tasks in project " + project_name + "</h2>" +
            "<h3>There are currently no tasks with status Fixed. Please check again later.</h3>"
            });
        }

    }


    protected void submit_review(object sender, EventArgs e)
    {
        string[] project_pk = Session["project_for_review_tasks"].ToString().Split('/');

        string company_domain = project_pk[0];
        string project_name = project_pk[1];
        string task_name = tasks_ddl.SelectedItem.Text;
        string response_string = response_ddl.SelectedItem.Text;
        string new_deadline_string = new_deadline_textbox.Text;

        DateTime new_deadline;
        int response = 0;
        Boolean null_datetime = false;
        if (response_string.Equals("Accept"))
        {
            response = 1;
        }

        if (response == 1 & !DateTime.TryParse(new_deadline_string, out new_deadline))
        {
            null_datetime = true;
        }
        else
        if (response == 0 & !DateTime.TryParse(new_deadline_string, out new_deadline))
        {
            Response.Write("In case of rejection, you must provide a new deadline. The deadline you entered is not formatted correctly. Please write it in the form MM/DD/YYYY.");
            return;
        }

        string connString = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connString);

        SqlCommand cmd = new SqlCommand("Review_task", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        //@manager_username varchar(100), @domain varchar(120) , @projname varchar(200),@taskname varchar(200),
        //@deadline datetime= null,@response bit, @message int output
        cmd.Parameters.Add(new SqlParameter("@manager_username", Session["username"]));
        cmd.Parameters.Add(new SqlParameter("@domain", company_domain));
        cmd.Parameters.Add(new SqlParameter("@projname", project_name));
        cmd.Parameters.Add(new SqlParameter("@taskname", task_name));

        if (null_datetime)
            cmd.Parameters.Add(new SqlParameter("@deadline", null));
        else
            cmd.Parameters.Add(new SqlParameter("@deadline", new_deadline));
        cmd.Parameters.Add(new SqlParameter("@response", response));

        SqlParameter message = cmd.Parameters.Add("@message", SqlDbType.Int);
        message.Direction = ParameterDirection.Output;

        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();

        switch (message.Value.ToString())
        {
            case "0":
                Response.Write("Task name cannot be left empty. Please choose a task.");
                break;
            case "1":
                Response.Write("Response cannot be left empty. Please enter a response.");
                break;
            case "2":
                Response.Write("In case of rejection, you must provide a new deadline. Please enter a suitable new deadline.");
                break;
            case "3":
                Session["review_success"] = "Your response to the completion of task " + task_name + " has been successfully saved.";
                Response.Redirect("review_tasks", true);
                break;
        }
    }


    protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks", true);
    }
}