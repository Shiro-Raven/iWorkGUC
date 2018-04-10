<%@ Page Language="C#" AutoEventWireup="true" CodeFile="project_assignment.aspx.cs" Inherits="project_assignment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Project Assignment</title>
</head>
<body>
    <style>
        table, th, td {
            border: 1px solid black;
        }
    </style>
    <form id="project_assignment_form" runat="server">
        <div>
            <asp:Button ID="to_project_central_button" runat="server" Text="Go Back" OnClick="to_project_central" />

        </div>
    </form>
</body>
</html>
