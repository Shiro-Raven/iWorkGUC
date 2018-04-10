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

public partial class view_tasks_by_status : System.Web.UI.Page
{
    protected DropDownList status_ddl = new DropDownList();

    protected void Page_Load(object sender, EventArgs e)
    {
        ListItem assignedListItem = new ListItem();
        assignedListItem.Text = "Assigned";
        ListItem fixedListItem = new ListItem();
        fixedListItem.Text = "Fixed";
        ListItem openListItem = new ListItem();
        openListItem.Text = "Open";
        ListItem closedListItem = new ListItem();
        closedListItem.Text = "Closed";

        status_ddl.Items.Add(openListItem);
        status_ddl.Items.Add(assignedListItem);
        status_ddl.Items.Add(fixedListItem);
        status_ddl.Items.Add(closedListItem);

        Button view_tasks_button = new Button();
        view_tasks_button.Text = "View Tasks with this Status.";
        view_tasks_button.Click += new EventHandler(view_tasks);

        string[] project_pk = Session["project_for_view_tasks_by_status"].ToString().Split('/');
        string company_domain = project_pk[0];
        string project_name = project_pk[1];

        view_tasks_form.Controls.Add(new Literal { Text = "<H2>View Tasks by Status in project "+project_name+".</H2>" +
            "<h3>Here you can view tasks with any status. <br/>To review tasks, please go back and press the appropriate button.</h3>" +
            "<h4>Select a status: </h4>"});
        view_tasks_form.Controls.Add(status_ddl);
        view_tasks_form.Controls.Add(new Literal { Text = "<br/>" });
        view_tasks_form.Controls.Add(view_tasks_button);

    }


    protected void view_tasks(object sender, EventArgs e)
    {
        string[] project_pk = Session["project_for_view_tasks_by_status"].ToString().Split('/');
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
        cmd.Parameters.Add(new SqlParameter("@status", status_ddl.SelectedItem.Text));

        conn.Open();

        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        StringBuilder tasks_table = new StringBuilder();
        tasks_table.Append("<table><tr><th>Name</th><th>Description</th><th>Deadline</th><th>Was Assigned To</th></tr>");

        int counter = 0;
        while (rdr.Read())
        {
            tasks_table.Append("<tr><th>" + rdr.GetValue(rdr.GetOrdinal("name")) + "</th>"
                + "<th> " + rdr.GetValue(rdr.GetOrdinal("description")) + "</th>"
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("deadline")) + "</th> "
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("employee_username")) + "</th></tr>"
                );
            counter++;

        }
        tasks_table.Append("</table>");
        view_tasks_form.Controls.Add(new Literal { Text = tasks_table.ToString() });
        view_tasks_form.Controls.Add(new Literal { Text = "<h3>There are "+counter+" tasks with status "+
            status_ddl.SelectedItem.Text+" in project "+project_name+".</h3>" });
        conn.Close();
    }

    protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks", true);
    }

}