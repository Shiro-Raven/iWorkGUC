<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manage_specific_job_applications.aspx.cs" Inherits="manage_specific_job_applications" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    <form id="applications_form" runat="server">
        <div>
             <asp:Button ID="return_to_manager_applications_button" runat="server" Text="Go Back" onclick="return_to_manager_applications"/>
        </div>
    </form>
</body>
</html>
