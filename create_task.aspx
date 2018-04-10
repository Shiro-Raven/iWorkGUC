<%@ Page Language="C#" AutoEventWireup="true" CodeFile="create_task.aspx.cs" Inherits="create_task" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create a Task</title>
</head>
<body>
    <form id="create_task_form" runat="server">
        <div>
            <asp:Button ID="to_manage_tasks_button" runat="server" Text="Go Back" OnClick="to_manage_tasks" />
        </div>
    </form>
</body>
</html>
