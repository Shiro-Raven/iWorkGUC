<%@ page language="C#" autoeventwireup="true" codefile="regular_employee.aspx.cs" inherits="regular_employee" %>

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

             <!-- MOPDIFY INFO Part -->
            <asp:Button runat="server" ID="btn_modify" OnClick="Modify_User_Info" Text="Modify User Information" Width="384px" Height="23px" />

            <!-- New Line -->
            <br />
            <br />

			<!-- VIEW PROJECTS Part -->
            <asp:Button runat="server" ID="btn_view_projects" OnClick="View_Projects" Text="View Projects" Width="384px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW TASKS OF CERTAIN PROJECT Part -->
            <asp:DropDownList runat="server" ID="drpdwnlst_projects" Width="320px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_view_tasks" OnClick="View_Tasks" Text="View" Width="60px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- SET TASK STATUS Part -->
            <asp:DropDownList runat="server" ID="drpdwnlst_tasks_project" AutoPostBack="true" OnSelectedIndexChanged="Refresh_Tasks" Width="131px" Height="22px">
            </asp:DropDownList>
			<asp:DropDownList runat="server" ID="drpdwnlst_tasks_task" Width="131px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_fix" OnClick="Fix_Task" Text="Fix" Width="50px" Height="23px" />
            <asp:Button runat="server" ID="btn_rework" OnClick="Open_Task" Text="Open" Width="60px" Height="23px" />

			<!-- New Line -->
			<br />
			<br />

			<!-- BACK TO STAFF MEMBER PAGE Part -->
			<asp:Button runat="server" ID="btn_back_to_staff_member" Text="STAFF MEMBER PAGE" OnClick="Back_To_Staff_Member" Width="384px" Height="23" />

			<!-- New Line -->
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
