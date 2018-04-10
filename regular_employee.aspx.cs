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

public partial class regular_employee : System.Web.UI.Page
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

		lbl_welcome_username.Text = (string)Session["username"];

		Check_Regular_Employee(sender, e);
		Refresh_Projects(sender, e);
	}
	protected void Check_Regular_Employee(object sender, EventArgs e)
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

		if (type.Value.ToString().Equals("2") == false)
			Response.Redirect("logged_in", true);
	}
	protected void Refresh_Projects(object sender, EventArgs e)
	{
		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("view_Projects", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

		while (rdr.Read())
		{
			drpdwnlst_projects.Items.Add(rdr.GetString(rdr.GetOrdinal("name")));
			drpdwnlst_tasks_project.Items.Add(rdr.GetString(rdr.GetOrdinal("name")));
		}

		rdr.Close();

		Refresh_Tasks(sender, e);
	}
	protected void Refresh_Tasks(object sender, EventArgs e)
	{
		if (drpdwnlst_tasks_project.SelectedIndex == -1)
			return;

		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("view_Tasks", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
		cmd.Parameters.AddWithValue("@project_name", drpdwnlst_tasks_project.SelectedValue);

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

		drpdwnlst_tasks_task.Items.Clear();

		while (rdr.Read())
		{
			drpdwnlst_tasks_task.Items.Add(rdr.GetString(rdr.GetOrdinal("name")));
		}

		rdr.Close();
	}
	protected void Modify_User_Info(object sender, EventArgs e)
	{
		Response.Redirect("modify_user_info", true);
	}
	protected void View_Projects(object sender, EventArgs e)
	{
		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("view_Projects", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

		tbl_output_table.Rows.Clear();

		TableHeaderRow tblhdrrw = new TableHeaderRow();

		TableHeaderCell tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Project's Name"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Project's Start Date"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Project's End Date"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Project's Defining Manager"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Projects's Assigning Manager"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tbl_output_table.Controls.Add(tblhdrrw);

		while (rdr.Read())
		{
			TableRow tblrw = new TableRow();

			TableCell tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("name"))));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("start_date")).ToString()));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("end_date")).ToString()));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("defining_manager_username"))));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("manager_username"))));
			tblrw.Cells.Add(tblcl);

			tbl_output_table.Controls.Add(tblrw);
		}

		rdr.Close();

		if (!output_message.Value.ToString().Equals(("5")))
			tbl_output_table.Rows.Clear();
		if (output_message.Value.ToString().Equals(("0")))
			Response.Write("Invalid Input(s)");
		else if (output_message.Value.ToString().Equals(("1")))
			Response.Write("Empty Input(s)");
		else if (output_message.Value.ToString().Equals(("2")))
			Response.Write("NULL Input(s)");
		else if (output_message.Value.ToString().Equals(("3")))
			Response.Write("User Does Not Exist!");
		else if (output_message.Value.ToString().Equals(("4")))
			Response.Write("No Projects Yet!");
	}
	protected void View_Tasks(object sener, EventArgs e)
	{
		if (drpdwnlst_projects.SelectedIndex == -1)
			return;

		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("view_Tasks", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
		cmd.Parameters.AddWithValue("@project_name", drpdwnlst_projects.SelectedValue);

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

		tbl_output_table.Rows.Clear();

		TableHeaderRow tblhdrrw = new TableHeaderRow();

		TableHeaderCell tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Project's Name"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Task's name"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Task's Description"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Task's Deadline"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tblhdrcl = new TableHeaderCell();
		tblhdrcl.Controls.Add(new LiteralControl("Task's Status"));
		tblhdrrw.Cells.Add(tblhdrcl);

		tbl_output_table.Controls.Add(tblhdrrw);

		while (rdr.Read())
		{
			TableRow tblrw = new TableRow();

			TableCell tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("project_name"))));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("name"))));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("description")).ToString()));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetValue(rdr.GetOrdinal("deadline")).ToString()));
			tblrw.Cells.Add(tblcl);

			tblcl = new TableCell();
			tblcl.Controls.Add(new LiteralControl(rdr.GetString(rdr.GetOrdinal("status"))));
			tblrw.Cells.Add(tblcl);

			tbl_output_table.Controls.Add(tblrw);
		}

		rdr.Close();

		if (!output_message.Value.ToString().Equals(("5")))
			tbl_output_table.Rows.Clear();
		if (output_message.Value.ToString().Equals(("0")))
			Response.Write("Invalid Input(s)");
		else if (output_message.Value.ToString().Equals(("1")))
			Response.Write("Empty Input(s)");
		else if (output_message.Value.ToString().Equals(("2")))
			Response.Write("NULL Input(s)");
		else if (output_message.Value.ToString().Equals(("3")))
			Response.Write("User Does Not Exist!");
		else if (output_message.Value.ToString().Equals(("4")))
			Response.Write("No Tasks Yet!");

	}
	protected void Fix_Task(object sener, EventArgs e)
	{
		if (drpdwnlst_tasks_project.SelectedIndex == -1 || drpdwnlst_tasks_task.SelectedIndex == -1)
			return;

		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("set_Task_status", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
		cmd.Parameters.AddWithValue("@project_name", drpdwnlst_tasks_project.SelectedValue);
		cmd.Parameters.AddWithValue("@task_name", drpdwnlst_tasks_task.SelectedValue);
		cmd.Parameters.AddWithValue("@status", "Fixed");

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		cmd.ExecuteNonQuery();
		conn.Close();

		if (output_message.Value.ToString().Equals("0"))
			Response.Write("Invalid Input(s)");
		else if (output_message.Value.ToString().Equals("1"))
			Response.Write("Empty Input(s)");
		else if (output_message.Value.ToString().Equals("2"))
			Response.Write("NULL Input(s)");
		else if (output_message.Value.ToString().Equals("3"))
			Response.Write("User Does Not Exist!");
		else if (output_message.Value.ToString().Equals("4"))
			Response.Write("Task Does Not Exist!");
		else if (output_message.Value.ToString().Equals("5"))
			Response.Write("Cannot Update After Deadline!");
		else if (output_message.Value.ToString().Equals("6"))
			Response.Write("Task Is Closed!");
		else if (output_message.Value.ToString().Equals("7"))
			Response.Write("UPDATED!");
	}
	protected void Open_Task(object sener, EventArgs e)
	{
		if (drpdwnlst_tasks_project.SelectedIndex == -1 || drpdwnlst_tasks_task.SelectedIndex == -1)
			return;

		string connStr = ConfigurationManager.ConnectionStrings["iWorkDBConn"].ToString();
		SqlConnection conn = new SqlConnection(connStr);

		SqlCommand cmd = new SqlCommand("set_Task_status", conn);
		cmd.CommandType = CommandType.StoredProcedure;

		cmd.Parameters.AddWithValue("@username", (string)Session["username"]);
		cmd.Parameters.AddWithValue("@project_name", drpdwnlst_tasks_project.SelectedValue);
		cmd.Parameters.AddWithValue("@task_name", drpdwnlst_tasks_task.SelectedValue);
		cmd.Parameters.AddWithValue("@status", "Open");

		SqlParameter output_message = cmd.Parameters.Add("@output_message", SqlDbType.Int);
		output_message.Direction = ParameterDirection.Output;

		conn.Open();
		cmd.ExecuteNonQuery();
		conn.Close();

		if (output_message.Value.ToString().Equals("0"))
			Response.Write("Invalid Input(s)");
		else if (output_message.Value.ToString().Equals("1"))
			Response.Write("Empty Input(s)");
		else if (output_message.Value.ToString().Equals("2"))
			Response.Write("NULL Input(s)");
		else if (output_message.Value.ToString().Equals("3"))
			Response.Write("User Does Not Exist!");
		else if (output_message.Value.ToString().Equals("4"))
			Response.Write("Task Does Not Exist!");
		else if (output_message.Value.ToString().Equals("5"))
			Response.Write("Cannot Update After Deadline!");
		else if (output_message.Value.ToString().Equals("6"))
			Response.Write("Task Is Closed!");
		else if (output_message.Value.ToString().Equals("7"))
			Response.Write("UPDATED!");
	}
	protected void Back_To_Staff_Member(object sender, EventArgs e)
	{
		Response.Redirect("staff_member", true);
	}
	protected void Back_To_Logged_In(object sender, EventArgs e)
	{
		Response.Redirect("logged_in", true);
	}
}