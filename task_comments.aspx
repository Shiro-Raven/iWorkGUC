<%@ Page Language="C#" AutoEventWireup="true" CodeFile="task_comments.aspx.cs" Inherits="task_comments" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Task Comments</title>
</head>
<body>
    <style>
        table, th, td {
            border: 1px solid black;
        }
    </style>
    <form id="comments_form" runat="server">
        <div>
            <asp:Button ID="to_manage_tasks_button" runat="server" Text="Go Back" OnClick="to_manage_tasks" />
            <h1>Task Comments</h1>


        </div>
    </form>
</body>
</html>
