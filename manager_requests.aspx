<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manager_requests.aspx.cs" Inherits="manager_requests" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Department Requests</title>
</head>
<body>
    <style>
table, th, td {
    border: 1px solid black;
    }
</style>
    
    <form id="requests" runat="server">
        <div>
            <asp:Button ID="return_to_profile_button" runat="server" Text="Return to Profile Page" onclick="return_to_profile"/>
        </div>

    </form>

</body>
</html>
