<%@ Page Language="C#" AutoEventWireup="true" CodeFile="change_regular_employee_working_on_task.aspx.cs" Inherits="change_regular_employee_working_on_task" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Change the Regular Employee Assigned to a Task</title>
</head>
<body>
         <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    <form id="change_regular_task_form" runat="server">
        <div>
            <asp:Button ID="to_manage_tasks_button" runat="server" Text="Go Back" OnClick="to_manage_tasks" />
        </div>
    </form>
</body>
</html>
