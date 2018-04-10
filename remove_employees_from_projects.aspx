<%@ Page Language="C#" AutoEventWireup="true" CodeFile="remove_employees_from_projects.aspx.cs" Inherits="remove_employees_from_projects" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Remove Employees</title>
</head>
<body>
        <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    <form id="remove_form" runat="server">
        <div>
            <asp:Button ID="return_to_project_assignment_button" runat="server" Text="Go Back" onclick="to_project_assignment"/>
           
        </div>
    </form>
</body>
</html>
