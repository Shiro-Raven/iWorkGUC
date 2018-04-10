<%@ Page Language="C#" AutoEventWireup="true" CodeFile="project_central.aspx.cs" Inherits="project_central" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Project Central</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Welcome <%:Session["username"]%>, what would you like to do today?</h2>
            <asp:Button ID="to_project_creation_button" runat="server" Text="Create a New Project" onclick="to_project_creation"/>
            <asp:Button ID="to_project_assignment_button" runat="server" Text="Assign Regular Employees to Projects or Remove them" onclick="to_project_assignment"/>
            <asp:Button ID="to_manage_tasks_button" runat="server" Text="Manage Tasks" onclick="to_manage_tasks"/>
            <asp:Button ID="back_to_profile_button" runat="server" Text="Go Back to Profile Page" onclick="to_manager"/>
        </div>
    </form>
</body>
</html>
