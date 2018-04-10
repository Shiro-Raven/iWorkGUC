<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Email.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 763px">

            <asp:Label ID="Label8" runat="server" Text="To:"></asp:Label>
            <asp:TextBox ID="TextBox8" runat="server" style="margin-left: 37px" Width="142px"></asp:TextBox>
            <asp:Button ID="Button4" runat="server" OnClick="Button4_Click" style="margin-left: 309px" Text="Go back to staff services" />
            <br />
            <asp:Label ID="Label7" runat="server" Text="Subject:"></asp:Label>
&nbsp;<asp:TextBox ID="TextBox7" runat="server" Width="301px"></asp:TextBox>
            <br />
            <asp:TextBox ID="TextBox9" runat="server" Height="164px" Width="700px"></asp:TextBox>
            <br />
            <asp:Button ID="Button1" runat="server" Text="Send" OnClick="send_email" />
            

            <br />
            

        </div>

        <div style="height: 239px; margin-top: 40px;">

            <asp:Button ID="Button2" runat="server" style="margin-left: 1px" Text="Check Emails" OnClick="view_emails" />

            <br />

            <br />
           
            <asp:Table ID="tbl_view_emails" runat="server" CellPadding="3" CellSpacing="3" GridLines="Both" style="margin-left: 3px" >
            </asp:Table>

            <br />
            <asp:Label ID="Label9" runat="server" Text="Reply To Email:"></asp:Label>
            <br />
            <asp:DropDownList ID="DropDownListTimeStamps" runat="server">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button3" runat="server" OnClick="reply_to_email" Text="Reply" />
            <br />

        </div>
    </form>
</body>
</html>
