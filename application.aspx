<%@ page language="C#" autoeventwireup="true" codefile="application.aspx.cs" inherits="application" %>

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

            <!-- Output Table -->
            <asp:Table runat="server" ID="tbl_output_table" HorizontalAlign="Center" CellSpacing="3" CellPadding="3" GridLines="Both">
            </asp:Table>

            <!-- New Line -->
            <br />
            <br />

            <!-- SUBMIT ANSWER Part -->
            <asp:Button runat="server" ID="btn_submit_answers" OnClick="Submit_Answers" Text="SUBMIT" Width="384px" Height="23" />

            <!-- New Line -->
            <br />

            <!-- SUBMIT ANSWER Part -->
            <asp:Button runat="server" ID="btn" OnClick="Back_To_Job_Seeker" Text="JOB SEEKER PAGE" Width="384px" Height="23" />

        </div>
    </form>
</body>
</html>
