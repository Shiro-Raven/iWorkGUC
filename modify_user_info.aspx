<%@ page language="C#" autoeventwireup="true" codefile="modify_user_info.aspx.cs" inherits="modify_info" %>

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

            <!-- USERNAME Part -->
            <asp:Label runat="server" ID="lbl_username" Text="User Name" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_username" Enabled="false" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- PASSWORD Part -->
            <asp:Label runat="server" ID="lbl_password" Text="Password" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_password" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- FIRST NAME Part -->
            <asp:Label runat="server" ID="lbl_first_name" Text="First Name" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_first_name" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- MIDDLE NAME Part -->
            <asp:Label runat="server" ID="lbl_middle_name" Text="Middle Name" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_middle_name" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- LAST NAME Part -->
            <asp:Label runat="server" ID="lbl_last_name" Text="Last Name" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_last_name" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- BIRTH DATE Part -->
            <asp:Label runat="server" ID="lbl_birth_date" Text="Birth Date" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_birth_date" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- EMAIIL Part -->
            <asp:Label runat="server" ID="lbl_email" Text="EMAIL" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_email" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- YEARS OF EXPERIENCE Part -->
            <asp:Label runat="server" ID="lbl_years_of_experience" Text="Years Of Experience" Width="135px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_years_of_experience" Width="200px" Height="18px" />

            <!-- New Line -->
            <br />

            <!-- UPDATE INFORMATION Part -->
            <asp:Button runat="server" ID="btn_update" Text="UPDATE" OnClick="Update" Width="343px" Height="23" />

            <!-- New Line -->
            <br />

            <!-- PROFILE PAGE Part -->
            <asp:Button runat="server" ID="btn_back_to_profile_page" Text="Back to Profile" OnClick="Back_To_Profile" Width="343px" Height="23" />

        </div>
    </form>
</body>
</html>
