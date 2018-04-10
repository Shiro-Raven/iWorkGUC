using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class project_central : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if(Session["project_central_error"] != null)
        {
            Response.Write(Session["project_central_error"]);
            Session["project_central_error"] = null;
        }

    }

    protected void to_project_creation(object sender, EventArgs e)
    {
        Response.Redirect("project_creation");
    }

    protected void to_manager(object sender, EventArgs e)
    {
        Response.Redirect("manager");
    }
    protected void to_project_assignment(object sender, EventArgs e)
    {
        Response.Redirect("project_assignment");
    }
    protected void to_manage_tasks(object sender, EventArgs e)
    {
        Response.Redirect("manage_tasks");
    }
}