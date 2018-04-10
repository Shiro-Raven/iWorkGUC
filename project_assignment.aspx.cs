using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class project_assignment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //establish connection
        string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
        SqlConnection conn = new SqlConnection(connStr);

        //reference procedure
        SqlCommand cmd = new SqlCommand("Get_projects_in_department", conn);
        cmd.CommandType = CommandType.StoredProcedure;

        conn.Open();

        //retrieve the username of the manager

        string username = Session["username"].ToString();
        cmd.Parameters.Add(new SqlParameter("@manuser", username));


        SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        project_assignment_form.Controls.Add(new Literal { Text = "<h2>Project Assignment</h2>"+
            Session["username"].ToString()+
            ", you have the following projects in your department.</ h3 > " +
            "<table><tr><th>Project Name</th><th>Start Date</th><th>End Date</th><th>Assign Regular Employees</th><th>Remove Regular Employees</th></tr>" });

        int counter = 0;

        while (rdr.Read())
        {
            project_assignment_form.Controls.Add(new Literal { Text = "<tr><th>"+rdr.GetValue(rdr.GetOrdinal("name")).ToString()+"</th>"
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("start_date")).ToString() + "</th>"
                + "<th>" + rdr.GetValue(rdr.GetOrdinal("end_date")).ToString() + "</th>"
            });

            Button assignButton = new Button();
            assignButton.Text = "Assign";
            assignButton.ToolTip = rdr.GetValue(rdr.GetOrdinal("company_domain")).ToString()+"/"+rdr.GetValue(rdr.GetOrdinal("name")).ToString();
            assignButton.Click += new EventHandler(to_assign_employees_to_projects);
            project_assignment_form.Controls.Add(new Literal { Text = "<th>" });
            project_assignment_form.Controls.Add(assignButton);
            project_assignment_form.Controls.Add(new Literal { Text = "</th>" });

            Button removeButton = new Button();
            removeButton.Text = "Remove";
            removeButton.ToolTip = rdr.GetValue(rdr.GetOrdinal("company_domain")).ToString() + "/" + rdr.GetValue(rdr.GetOrdinal("name")).ToString();
            removeButton.Click += new EventHandler(to_remove_employees_from_projects);
            project_assignment_form.Controls.Add(new Literal { Text = "<th>" });
            project_assignment_form.Controls.Add(removeButton);
            project_assignment_form.Controls.Add(new Literal { Text = "</th><tr>" });
            counter++;
        }
        project_assignment_form.Controls.Add(new Literal { Text = "</table>" });
        project_assignment_form.Controls.Add(new Literal { Text = "<H3> There are "+ counter +" projects in your department.</H3>" });
        conn.Close();
    }

    protected void to_assign_employees_to_projects(object sender, EventArgs e)
    {
        Button b1 = sender as Button;
        Session["project_to_assign_to"] = b1.ToolTip;
        Response.Redirect("assign_employees_to_projects");
    }

    protected void to_remove_employees_from_projects(object sender, EventArgs e)
    {
        Button b1 = sender as Button;
        Session["project_to_remove_from"] = b1.ToolTip;
        Response.Redirect("remove_employees_from_projects");
    }

    protected void to_project_central(object sender, EventArgs e)
    {
        Response.Redirect("project_central");
    }



}