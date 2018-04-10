<%@ page language="C#" autoeventwireup="true" codefile="job_seeker.aspx.cs" inherits="job_seeker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center; left: 50%; right: 50%; justify-content: center">

            <!-- iWork Title -->
            <asp:Label runat="server" ID="lbl_iwork" Text="iWork" Font-Size="70" />

            <!-- New Line -->
            <br />
            <br />

            <!-- WELCOME Part -->
            <asp:Label runat="server" ID="lbl_welcome_first" Text="Welcome, " />
            <asp:Label runat="server" ID="lbl_welcome_username" ForeColor="#FF0000" />
            <asp:Label runat="server" ID="lbl_welcome_second" Text=" To iWork Where The Future Begins!" />

            <!-- New Line -->
            <br />
            <br />

            <!-- APPLY FOR JOB Part -->
            <asp:DropDownList runat="server" ID="drpdwnlst_apply_for_job" Width="269px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_view" OnClick="View_Job_Details" Text="View" Width="50px" Height="23px" />
            <asp:Button runat="server" ID="btn_apply_for_job" OnClick="Apply_For_Job" Text="Apply" Width="57px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW APPLCATIONS Part -->
            <asp:Button runat="server" ID="btn_view_applcations" Text="View Applications" OnClick="View_Applications" Width="384px" Height="23" />

            <!-- New Line -->
            <br />

            <!-- APPLY FOR JOB Part -->
            <asp:DropDownList runat="server" ID="drpdwnlst_delete_application" Width="313px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_delete_application" OnClick="Delete_Applcation" Text="Delete" Width="67px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- APPLY FOR JOB Part -->
            <asp:DropDownList runat="server" ID="drpdwnlst_choose_job" Width="218px" Height="22px">
            </asp:DropDownList>
            <asp:DropDownList runat="server" ID="drpdwnlst_days" Width="91px" Height="22px">
                <asp:ListItem Text="Saturday" />
                <asp:ListItem Text="Sunday" />
                <asp:ListItem Text="Monday" />
                <asp:ListItem Text="Tuesday" />
                <asp:ListItem Text="Wednesday" />
                <asp:ListItem Text="Thursday" />
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_choose_job" OnClick="Choose_Job" Text="Choose" Width="66px" Height="23px" />

            <!-- New Line -->
            <br />
            <br />

            <!-- BACK TO LOGGED IN PAGE Part -->
            <asp:Button runat="server" ID="btn_back_to_logged_in" Text="LOGGED IN PAGE" OnClick="Back_To_Logged_In" Width="384px" Height="23" />

            <!-- New Line -->
            <br />
            <br />

            <!-- Output Table -->
            <asp:Table runat="server" ID="tbl_output_table" HorizontalAlign="Center" CellSpacing="3" CellPadding="3" GridLines="Both">
            </asp:Table>

        </div>
    </form>
</body>
</html>
