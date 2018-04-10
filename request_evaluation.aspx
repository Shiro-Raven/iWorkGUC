<%@ Page Language="C#" AutoEventWireup="true" CodeFile="request_evaluation.aspx.cs" Inherits="request_evaluation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Request Evaluation</title>
</head>
<body>
    <form id="accept_request_form" runat="server">
        <div>
            <asp:Button ID="return_to_manager_requests_button" runat="server" Text="Go Back" onclick="return_to_manager_requests"/>
            <h2><%:Session["username"]%>, please enter your response to request number <%:Session["request_id"]%>.</h2>
            <br />
            <asp:Label ID="request_id_label" runat="server">Request Number: <%:Session["request_id"]%></asp:Label>
            <br />
            <asp:Label ID="evaluation_label" runat="server" Text="Decision: "></asp:Label>
            <asp:DropDownList ID="response_dropdownlist" runat="server">
                            <asp:ListItem Text="accepted" Value="0"></asp:ListItem>
                            <asp:ListItem Text="rejected" Value="1"></asp:ListItem>
                        </asp:DropDownList>
            <br />
            <asp:Label ID="reason_label" runat="server" Text="Reason: (Needed only in case of rejection) "></asp:Label>
            <br />
            <asp:TextBox ID="reason_textbox" runat="server"></asp:TextBox>
            <br />
            <asp:Button ID="submit_evaluation_button" runat="server" Text="Submit" OnClick="submit_evaluation" />
        </div>
    </form>
</body>
</html>
