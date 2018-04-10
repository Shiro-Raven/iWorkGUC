<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit_manager_info.aspx.cs" Inherits="edit_manager_info" %>

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
            width: 200px;
            float: left;
        }
    </style>
    <form id="edit_form" runat="server">
        <div>
            <asp:Button ID="go_back_button" runat="server" Text="Go Back" OnClick="to_manager" />
        </div>
    </form>
</body>
</html>
