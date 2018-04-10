<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Announce.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Post an Announcement</title>
    <style>
         .button1 {
        background-color: #e720e8; 
        border:double;
        font-size: 16px;
        -webkit-transition-duration: 0.4s; /* Safari */
    transition-duration: 0.4s;
    }

.button1:hover {
    background-color: black; /* Green */
    color: blanchedalmond;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align:center">
            <asp:Label runat="server" ID="lbl_HR" Text="Post an announcement" Font-Size="42" />
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_title" Text="Announcement Title" Width="150px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_title" Width="200px" Height="18px" />
            <br />
            <br />
             <asp:Label runat="server" ID="lbl_shortdesc" Text="Announcement Type" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_type" Width="200px" Height="18px" />
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_longdesc" Text="Description" Width="150" Height="23px" />
            <br />
            <asp:Textbox runat="server" ID="txt_desc" Width="300px" Height="200px" TextMode="MultiLine" />
            <br />
            <br />
            <asp:Button runat="server" ID="btn_post" Text="Post Announcement" CssClass="button1" OnClick="btn_post_Click" />
            <asp:Button runat="server" ID="close" Text="Back to HR" CssClass="button1" OnClick="close_Click" />
        </div>
    </form>
</body>
</html>
