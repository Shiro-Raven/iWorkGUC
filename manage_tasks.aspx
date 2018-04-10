<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manage_tasks.aspx.cs" Inherits="manage_tasks" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Tasks</title>
</head>
<body>
    <form id="manage_tasks_form" runat="server">
        <div>
            <asp:Button ID="to_project_central_button" runat="server" Text="Go Back" OnClick="to_project_central" />
            <h1>Task Management</h1>
        </div>
    </form>
</body>
</html>
