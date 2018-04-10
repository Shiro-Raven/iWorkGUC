<%@ Page Language="C#" AutoEventWireup="true" CodeFile="addJob.aspx.cs" Inherits="addJob" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Adding a Job</title>
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
    <form id="addJobForm" runat="server">
        <div style="text-align: center; ">
            <asp:Label runat="server" Text="Adding a Job" Font-Size="54px" Font-Bold="true" />
            <br />
            <br />
             <asp:Label runat="server" ID="lbl_title" Text="Job Title" Width="150px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_title" Width="200px" Height="18px" />
            <br />
            <br />
             <asp:Label runat="server" ID="lbl_shortdesc" Text="Short Description" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_shortdesc" Width="200px" Height="50px" />
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_longdesc" Text="Long Description" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_longdesc" Width="200px" Height="100px" TextMode="MultiLine"/>
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_years" Text="Minimum years of experience" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_years" Width="200px" Height="18px" />
            <br />
            <br />
            <asp:Label runat="server" ID="lbl_salary" Text="Salary" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_salary" Width="200px" Height="18px" />
             <br />
            <br />
            <asp:Label runat="server" ID="lbl_deadline" Text="Application Deadline" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_deadline" Width="200px" Height="18px" type="Date" />
             <br />
            <br />
            <asp:Label runat="server" ID="lbl_hours" Text="Work Hours" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_hours" Width="200px" Height="18px" />
             <br />
            <br />
            <asp:Label runat="server" ID="lbl_vacant" Text="Number of Vacancies" Width="150" Height="23px" />
            <asp:TextBox runat="server" ID="txt_vacant" Width="200px" Height="18px" />
             <br />
            <br />
            <asp:Button runat="server" ID="btn_submit" Text="Submit the new Job" CssClass="button1" OnClick="btn_submit_Click" />
            <asp:Button runat="server" ID="close" Text="Back to HR" CssClass="button1" OnClick="close_Click" />
    
        </div>
    </form>
</body>
</html>
