<%@ Page Language="C#" AutoEventWireup="true" CodeFile="view_tasks_by_status.aspx.cs" Inherits="view_tasks_by_status" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Tasks by Status</title>
</head>
<body>
             <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    <form id="view_tasks_form" runat="server">
        <div>
              <asp:Button ID="to_manage_tasks_button" runat="server" Text="Go Back" OnClick="to_manage_tasks" />

        </div>
    </form>
</body>
</html>
