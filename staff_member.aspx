<%@ Page Language="C#" AutoEventWireup="true" CodeFile="staff_member.aspx.cs" Inherits="Staff_Members" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Staff Member Services</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align:center">
        <div  style = "border: solid teal; border-width:thin; height: 37px;" >
            &nbsp;
            <asp:Image ID="Image1" runat="server" Height="28px" ImageUrl="~/email.jpg" style="margin-left: 0px" Width="29px" />
            <asp:Button ID="Button8" runat="server" style="margin-left: 8px" Text="Email" OnClick="Button8_Click" Font-Underline="True" ForeColor="#0033CC" Width="48px" />
            <asp:Image ID="Image2" runat="server" Height="31px" ImageUrl="~/home.jpg" style="margin-left: 35px" Width="32px" />
            <asp:Button ID="Button11" runat="server" style="margin-left: 10px" Text="Back to Profile" Width="130px" OnClick="back_to_homepage" Font-Underline="True" ForeColor="#0033CC" />
            <br />
        </div>
        <div style ="border-style: solid; border-color: teal; border-width: thin; margin-top: 20px;">
            &nbsp;<br />
&nbsp;
            <asp:Label ID="Label20" runat="server" Text="Attendance and Announcements:" Font-Size="Larger" ForeColor="Teal" Font-Overline="False" Font-Underline="True"></asp:Label>
            <br />
            <br />
            <asp:Button ID="Button1" runat="server" OnClick="Check_in" Text="Check in" Width="89px" style="margin-left: 9px" />
            <asp:Button ID="Button2" runat="server" OnClick="Check_out" Text="Check out" style="margin-left: 17px" />
            &nbsp;<br />
            <br />
            &nbsp;
            <asp:Label ID="Label19" runat="server" Text="View Attendance Records:"></asp:Label>
            <br />
            <br />
            &nbsp;
            <asp:Label ID="Label1" runat="server" Text="Start date"></asp:Label>
            <asp:TextBox ID="TextBox2" runat="server" Type="date" style="margin-left: 29px" placeholder="YYYY-MM-DD"></asp:TextBox>
&nbsp;<asp:Label ID="Label2" runat="server" Text="End date"></asp:Label>
            <asp:TextBox ID="TextBox3" runat="server" Type="date" style="margin-left: 36px" placeholder="YYYY-MM-DD"></asp:TextBox>
&nbsp;
            <br />
            <br />
            <asp:Button ID="Button3" runat="server" OnClick="View_Attendance_Records" Text="View Attendance Records" style="margin-left: 126px" Width="195px" />
            <br />
            <br />
            <asp:Table runat="server" ID="tbl_attendance_records" HorizontalAlign="Center" CellSpacing="3" CellPadding="3" GridLines="Both">
            </asp:Table>
            <br />
            <asp:Button ID="Button10" runat="server" style="margin-left: 9px" Text="View Announcements" OnClick="view_announcements" Width="181px" />
            
            <br />
            
            <br />
            <asp:Table ID="tbl_announcements" runat="server" style="margin-left: 12px">
            </asp:Table>
            <br />
            
        </div>
        <div style="margin-top: 36px; border : solid; border-color : teal; border-width: thin">
          &nbsp;<br />
&nbsp;
          <asp:Label ID="Label16" runat="server" Text="Requests:" Font-Bold="False" Font-Size="Larger" ForeColor="Teal" Font-Underline="True"></asp:Label>

            <div style="height: 343px" >

                <br />
                <br />
                <asp:Button ID="Button9" runat="server" style="margin-left: 11px"  Text="View Status of Requests" Width="282px" OnClick="view_status_requests" />
                <br />
                <br />
                <asp:Table ID="tbl_view_status_of_requests" runat="server" CellPadding="3" CellSpacing="3" GridLines="Both" HorizontalAlign="Center">
                </asp:Table>
                <br />
                &nbsp;
                <asp:Label ID="Label18" runat="server" ForeColor="#999999" Text="* To delete a request please click on &quot;View Status of Requests&quot; , select the request ID to be deleted from the drop down list below and click on &quot;DELETE&quot;."></asp:Label>
                <br />
                &nbsp;
                <asp:Label ID="Label17" runat="server" Text="Request ID:"></asp:Label>
                <br />
                &nbsp;
                <asp:DropDownList ID="DropDownListRequestID" runat="server" style="margin-top: 5px">
                </asp:DropDownList>
            <asp:Button ID="Button7" runat="server" Text="DELETE" Height="25px" style="margin-left: 100px" OnClick="delete_request" />
                <br />
                <br />
                <br />

            </div>
            <div style="height: 231px; margin-bottom: 43px">
                <br />
            &nbsp;
            <asp:Label ID="Label3" runat="server" Text="Apply for a leave request:" Font-Underline="True"></asp:Label>
            <br />
            <br />
            &nbsp;
            <asp:Label ID="Label4" runat="server" Text="From:"></asp:Label>
&nbsp;
            <asp:TextBox ID="TextBox4" runat="server" Width="119px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label6" runat="server" Text="To:"></asp:Label>
&nbsp;
            <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
            <br />
            &nbsp;
            <asp:Label ID="Label5" runat="server" Text="Replacement Username:"></asp:Label>
&nbsp;
            <asp:TextBox ID="TextBox6" runat="server" style="margin-top: 2px"></asp:TextBox>
            <br />&nbsp; Type:&nbsp;&nbsp; <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" style="margin-top: 6px">
                <asp:ListItem>sick leave</asp:ListItem>
                <asp:ListItem>accidental leave</asp:ListItem>
                <asp:ListItem>annual leave</asp:ListItem>
            </asp:DropDownList>
            <br />
            <br />
            <asp:Button ID="Button4" runat="server" style="margin-left: 125px" Text="Apply for leave Request" OnClick="apply_for_leave_request"  />
        </div>
        <div style="height: 219px; margin-top: 0px;">

            &nbsp;&nbsp;

            <asp:Label ID="Label7" runat="server" Text="Apply for a business trip request:" Font-Underline="True"></asp:Label>
            <br />
            <br />
            &nbsp;
            <asp:Label ID="Label8" runat="server" Text="From:"></asp:Label>
            &nbsp;<asp:TextBox ID="TextBox7" runat="server" Width="119px"></asp:TextBox>
            &nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label9" runat="server" Text="To:"></asp:Label>
            &nbsp;
            <asp:TextBox ID="TextBox8" runat="server"></asp:TextBox>
            <br />
            &nbsp;
            <asp:Label ID="Label10" runat="server" Text="Replacement Username:"></asp:Label>
            &nbsp;
            <asp:TextBox ID="TextBox9" runat="server" style="margin-top: 1px"></asp:TextBox>
            <br />
            &nbsp;
            <asp:Label ID="Label11" runat="server" Text="Destination:"></asp:Label>
&nbsp;&nbsp;<asp:TextBox ID="TextBox10" runat="server" style="margin-top: 7px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;
            <asp:Label ID="Label12" runat="server" Text="Purpose:"></asp:Label>
            &nbsp;
            <asp:TextBox ID="TextBox11" runat="server" style="margin-left: 5px"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="Button5" runat="server" style="margin-left: 77px" Text="Apply for business trip Request" OnClick="apply_for_business_trip_request" />
            <br />

        </div>
        </div>
            </div>
    </form>
</body>
</html>
