<%@ page language="C#" autoeventwireup="true" codefile="login.aspx.cs" inherits="login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>iWork
    </title>
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
            <asp:Label runat="server" ID="lbl_username" Text="USERNAME" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_username" Width="200px" Height="18px" />

            <!-- LOGIN Button -->
            <asp:Button runat="server" ID="btn_login" Text="Login" Width="70px" Height="23px" OnClick="Login" />

            <!-- New Line -->
            <br />

            <!-- PASSWORD Part -->
            <asp:Label runat="server" ID="lbl_password" Text="PASSWORD" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_password" TextMode="Password" Width="200px" Height="18px" />

            <!-- REGISTER Button -->
            <asp:Button runat="server" ID="btn_register" Text="Register" OnClick="Register" Width="70px" Height="23px" />

            <!-- New Line -->
            <br />
            <br />

            <!-- SEARCHING FOR A COMPANY Part -->
            <asp:TextBox runat="server" ID="txtbox_search_company_by" Width="212px" Height="18px" />
            <asp:DropDownList runat="server" ID="drpdwnlst_search_company_by" Width="80px" Height="22px">
                <asp:ListItem Text="Name" />
                <asp:ListItem Text="Address" />
                <asp:ListItem Text="Type" />
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_search_company_by" OnClick="Search_Company_By" Text="Search" Width="80px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW ALL COMPANIES AND ITS TYPE Part -->
            <asp:Button runat="server" ID="btn_view_all_companies_type" OnClick="View_Company_Type" Text="View All Companies / Type" Width="384px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW INFORMATION OF CERTAIN COMPANY PART -->
            <asp:DropDownList runat="server" ID="drpdwnlst_view_certain_Company" Width="200px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_view_certain_Company" OnClick="View_Certain_Company" Text="View Certain Company" Width="180px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW INFORMATION OF CERTAIN DEPARTMENT COMPANY PART -->
            <asp:DropDownList runat="server" ID="drpdwnlst_view_certain_department_company_company" AutoPostBack="true" OnSelectedIndexChanged="Refresh_Department" Width="98px" Height="22px">
            </asp:DropDownList>
            <asp:DropDownList runat="server" ID="drpdwnlst_view_certain_department_company_department" Width="98px" Height="22px">
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_view_certain_department_company" OnClick="View_Certain_Company_Department" Text="View Certain Department" Width="180px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- SEARCH FOR JOB WITH VACANCIES BY KEYWORD PART -->
            <asp:TextBox runat="server" ID="txtbox_search_for_job_vacancies_keyword" Width="196px" Height="18px" />
            <asp:Button runat="server" ID="btn_search_for_job_vacancies_keyword" OnClick="Search_For_Job_With_Vacancies_Keyword" Text="Search Job W Vacancies" Width="180px" Height="23px" />

            <!-- New Line -->
            <br />

            <!-- VIEW ALL COMPANIES IN ORDER OF HIGHEST AVERAGE SALARY Part -->
            <asp:Button runat="server" ID="btn_view_companies_with_average_salary" OnClick="View_Companies_With_Average_Salary_DESC" Text="View Companies In Order Of Having Heighest Average Salary" Width="384px" Height="23px" />

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
