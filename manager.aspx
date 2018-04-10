<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manager.aspx.cs" Inherits="manager" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manager Profile</title>
</head>
<body>
    <style>
        .labels {
            color: #153c4b;
            font-weight: bold;
            display: block;
            width: 150px;
            float: left;
        }
    </style>
    <form id="manager_form" runat="server">
        <div>
            <h1>Welcome to your profile page!</h1>
            <h2>What would you like to do?</h2>
            <asp:Button ID="to_manager_applications_button" runat="server" Text="Manage Applications" OnClick="to_manager_applications" />
            <asp:Button ID="to_manager_requests_button" runat="server" Text="Manage Requests" OnClick="to_manager_requests" />
            <asp:Button ID="to_project_central_button" runat="server" Text="Manage Projects" OnClick="to_project_central" />
            <asp:Button ID="to_staff_members_button" runat="server" Text="Go to My Page as a Staff Member" OnClick="to_staff_member" />
            <asp:Button ID="to_edit_manager_info_button" runat="server" Text="Edit My Personal Information" OnClick="to_edit_manager_info" />
            <asp:Button ID="to_log_in_button" runat="server" Text="Log Out" OnClick="to_login" />
        </div>
    </form>
</body>
</html>
