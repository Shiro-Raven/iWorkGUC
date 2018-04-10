<%@ Page Language="C#" AutoEventWireup="true" CodeFile="evaluate_specific_jobseeker_applications.aspx.cs" Inherits="evaluate_specific_jobseeker_applications" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="return_to_manage_specific_job_applications_button" runat="server" Text="Go Back" onclick="to_manage_specific_job_applications"/>
            <h2><%:Session["username"]%>, please enter your response to <%:Session["evaluate_applications_specific_jobseeker"]%>'s application to job number <%:Session["manage_applications_specific_job_id"]%>.</h2>
            <br />
            <asp:Label ID="evaluation_label" runat="server" Text="Decision: "></asp:Label>
            <asp:DropDownList ID="response_dropdownlist" runat="server">
                            <asp:ListItem Text="accepted" Value="0"></asp:ListItem>
                            <asp:ListItem Text="rejected" Value="1"></asp:ListItem>
                        </asp:DropDownList>
            <br />
            <asp:Button ID="submit_evaluation_button" runat="server" Text="Submit" OnClick="submit_evaluation" />
        </div>
    </form>
</body>
</html>
