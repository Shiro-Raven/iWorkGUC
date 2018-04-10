<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manager_applications.aspx.cs" Inherits="manager_applications" %>

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
        <div id="div1">
             <asp:Button ID="return_to_profile_button" runat="server" Text="Return to Profile Page" onclick="return_to_profile"/>
        </div>
    </form>
</body>
</html>
