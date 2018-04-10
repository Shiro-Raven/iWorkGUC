<%@ Page Language="C#" AutoEventWireup="true" CodeFile="review_tasks.aspx.cs" Inherits="review_tasks" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Review Tasks</title>
</head>
<body>
      <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    <form id="review_tasks_form" runat="server">
        <div>
             <asp:Button ID="to_manage_tasks_button" runat="server" Text="Go Back" OnClick="to_manage_tasks" />
        </div>
    </form>
</body>
</html>
