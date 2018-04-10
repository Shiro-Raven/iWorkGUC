<%@ Page Language="C#" AutoEventWireup="true" CodeFile="addQues.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Questions</title>
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
            <asp:label runat="server" ID="asdasd" Text="Adding/Editing Interview Questions" Font-Size="40" />
            <br />
            <br />
            <asp:Label runat="server" ID="Label5" Text="Question Wording" Width="120px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_quest" Width="300px" Height="18px" />
            <asp:Label runat="server" ID="Label1" Text="Answer" Width="60px" Height="23px" />
            <asp:DropDownList runat="server" ID="drpdwnlst_answer" Width="80px" Height="22px">
                <asp:ListItem Text="Yes" />
                <asp:ListItem Text="No" />
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_submitquest" text="Submit Question" OnClick="btn_submitquest_Click" CssClass="button1"/>
            <br />
            <asp:Label runat="server" ID="Label2" Text="Question ID" Width="120px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_questID" Width="60px" Height="18px" />
            <asp:Button runat="server" ID="btn_delete" text="Delete Question" OnClick="btn_delete_Click" CssClass="button1"/>
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_jobid" font-size="20" />
            <br />
            <asp:Table runat="server" ID="tbl_output_table" HorizontalAlign="Center" CellSpacing="3" CellPadding="3" GridLines="Both" style="margin-right: 4px" >
            </asp:Table>
            <br />
            <br />
            <asp:Button runat="server" ID="close" Text="Back to HR" CssClass="button1" OnClick="close_Click" />
            
        </div>
    </form>
</body>
</html>
