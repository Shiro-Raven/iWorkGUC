<%@ Page Language="C#" AutoEventWireup="true" CodeFile="project_creation.aspx.cs" Inherits="project_creation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
    <form id="project_creation_form" runat="server">
        <div>
             <asp:Button ID="return_to_project_central_button" runat="server" Text="Go Back" onclick="return_to_project_central"/>
            <h2>Project Creation</h2>
            <h2><%:Session["username"]%>, please enter the details of your project.</h2>
            <br />
            <asp:Label ID="project_name_label" class="labels" runat="server">Project Name:</asp:Label>
            <asp:TextBox ID="project_name_textbox" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="start_date_label" class="labels" runat="server" Text="Start Date: "></asp:Label>
            <asp:TextBox ID="start_date_textbox" runat="server" Text="e.g. 7/24/2017"></asp:TextBox>
            <br />
            <asp:Label ID="end_date_label" class="labels" runat="server" Text="End Date: "></asp:Label>
            <asp:TextBox ID="end_date_textbox" runat="server" Text="e.g. 7/30/2017"></asp:TextBox>
            <br />
            <asp:Button ID="create_project_button" runat="server" Text="Create" OnClick="create_project" />

        </div>
    </form>
</body>
</html>
