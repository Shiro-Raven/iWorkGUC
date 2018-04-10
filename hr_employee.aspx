<%@ Page Language="C#" AutoEventWireup="true" CodeFile="hr_employee.aspx.cs" Inherits="hr_employee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HR Employee Data</title>
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
            
            <asp:Label runat="server" ID="lbl_HR" Text="HR Employee" Font-Size="56" />

            <!-- New Line -->
            <br />

            <asp:Label runat="server" ID="lbl_name" Font-Size="28" />

            <!-- New Line -->
            <br />

            
            <asp:Button runat="server" ID="btn_logout" Text="Back to Homepage" CssClass="button1" OnClick="btn_logout_Click" />
            <br />
            <br />

            <asp:Label runat="server" ID="lbl_your" Text="Your Stuff" Font-Size="16" />
            <br />
            <asp:Button runat="server" ID="btn_staff" Text="Go To Staff Services" CssClass="button1" onClick="staffMembers" />

            <!-- New Line -->
            <br />

            <asp:Button runat="server" ID="btn_modify" CssClass="button1" OnClick="btn_modify_Click" Text="Modify Your Personal Information" />

            <br />

            <br />


            <div id="Manage Jobs" class="tab">
            <asp:Label runat="server" ID="Label9" Text="Manage Jobs" Font-Size="16" />
                <br />
             <!-- View ALL Jobs Part --> <!-- TODO Add onClick -->
            <asp:Button runat="server" ID="btn_viewJob" CssClass="button1" Text="VIEW JOBS OF YOUR DEPARTMENT" onClick="viewJobs" />

            <!-- New Line -->
            <br />

            <!-- ADD JOB Button --> <!-- TODO Add onClick -->
            <asp:Button runat="server" CssClass="button1" ID="btn_addJob" Text="ADD NEW JOB TO YOUR DEPARTMENT" onClick="addJob"  />
            <!-- New Line -->
            <br />

            <!-- ADD INTERVIEW QUESTIONS -->
            <asp:Label runat="server" ID="Label8" Text="Job ID" Width="" Height="23px" />
            <asp:TextBox runat="server" ID="txt_addQues" Width="120px" Height="18px" />
            <asp:Button runat="server" CssClass="button1" ID="btn_addQues" Text="ADD INTERVIEW QUESTIONS FOR THIS JOB" onClick="btn_addQues_Click" Enabled="false"  />

            <!-- New Line -->
            <br />

            <!-- VIEW APPLICATIONS FOR A JOB/EDIT JOB Part --> <!-- TODO on click -->
            <asp:Label runat="server" ID="lbl_viewApp" Text="Job ID" Width="" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_jobID" Width="120px" Height="18px" />
            <asp:Button runat="server" ID="btn_editJob" CssClass="button1" Enabled="false" Text="View/Edit Job Details" OnClick="btn_editJob_Click" />
            <asp:Button runat="server" ID="btn_viewApp" CssClass="button1" OnClick="btn_viewApp_Click"  Enabled="false"  Text="View Applications for this Job"  />

            <!-- New Line -->
            <br />

            <!-- Evaluate application part -->
            <asp:Label runat="server" Text="Seeker Username" Width="" Height="23px" />
            <asp:TextBox runat="server" ID="txtbox_appID" Width="120px" Height="18px" />
            <asp:DropDownList runat="server" ID="drpdwn_app" Width="80px" Height="22px">
                <asp:ListItem Text="Accept" />
                <asp:ListItem Text="Reject" />
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_viewSeekerInfo" OnClick="btn_viewSeekerInfo_Click" CssClass="button1" enabled="false" Text="View Seeker Information" />
            <asp:Button runat="server" ID="btn_viewSeekerPrev" OnClick="btn_viewSeekerPrevClick" CssClass="button1" enabled="false" Text="View Seeker Previous Titles" />
            <asp:Button runat="server" ID="btn_evalApp" CssClass="button1" OnClick="btn_evalApp_Click" enabled="false" Text="Evaluate Application" />

            </div>
            <br />

            <asp:Label runat="server" ID="Label10" Text="Announcements" Font-Size="16" />
            <br />
            <div id="Post an Announcement" class="tabcontent">
            <!-- Post Announcement Part --> <!-- TODO on click -->
            <asp:Button runat="server" ID="btn_postAnn" OnClick="btn_postAnn_Click" CssClass="button1"  Text="POST AN ANNOUNCEMENT" />
            </div>
            <br />

            <div id="Manage Requests" class="tabcontent">
            <!-- VIEW REQUESTS PART -->
                <asp:Label runat="server" ID="Label12" Text="Manage Requests" Font-Size="16" />
                <br />
             <asp:DropDownList runat="server" ID="drpdwnlst_RequestType" Width="80px" Height="22px">
                <asp:ListItem Text="Leave" />
                <asp:ListItem Text="Business" />
            </asp:DropDownList>
            <asp:Button runat="server" ID="btn_view_requests" CssClass="button1" OnClick="view_requests"  Text="View Requests by Type"  />

            <!-- New Line -->
            <br />

            <!-- Evaluate Requests PART -->
			 <asp:Label runat="server" ID="Label1" Text="Request ID" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_reqID" Width="90px" Height="18px" />
            <asp:DropDownList runat="server" ID="drpdwnlist_approval" Width="80px" Height="22px">
                <asp:ListItem Text="Accept" />
                <asp:ListItem Text="Reject" />
            </asp:DropDownList>
            <asp:Button runat="server" Enabled="false" ID="btn_evalReq"  CssClass="button1"  Text="Evaluate Request" OnClick="btn_evalReq_Click" />

            </div>
            <br />

            <div id="Manage Staff" class="tabcontent">
            <!-- View ALL STAFF MEMBERS IN DEPARTMENT PART -->
             <asp:Label runat="server" ID="Label11" Text="Manage Staff" Font-Size="16" />
                <br />
             <asp:Button runat="server" ID="btn_viewAllStaff" CssClass="button1" OnClick="viewStaff"  Text="View All Staff in My Department"  />
            
			<!-- New Line -->
            <br />
            <br />

            <!-- VIEW ATTENDANCE RECORD OF A STAFF MEMBER Part -->
			<asp:Label runat="server" ID="Label2" Text="Staff ID" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_staffID" Width="200px" Height="18px" />
			<br />
            <asp:Label runat="server" ID="Label5" Text="Attendance Year" Width="120px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_year" Width="200px" Height="18px" />
            <br />
            <asp:Button runat="server" ID="btn_viewAttbyYear" enabled="false" OnClick="btn_viewAttbyYear_Click"  CssClass="button1" Text="View Hours Worked in Year" />
            <br />
            <asp:Label runat="server" ID="Label3" Text="Starting from" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_startDate" Width="200px" Height="18px" />
			<br />
            <asp:Label runat="server" ID="Label4" Text="Till" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_endDate" Width="200px" Height="18px" />
			<br />
            <asp:Button runat="server" CssClass="button1"  Enabled="false" ID="btn_viewAtt" onclick="btn_viewAtt_Click"  Text="View Attendance Record" />
			

			<br />
            <br />

			<!-- VIEW Achievers in month Part -->
			 <asp:Label runat="server" ID="Label6" Text="Year" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_yearTop" Width="200px" Height="18px" />
            <br />
            <asp:Label runat="server" ID="Label7" Text="Month" Width="90px" Height="23px" />
            <asp:TextBox runat="server" ID="txt_monthTop" Width="200px" Height="18px" />
            <br />
			<asp:Button runat="server" ID="btn_viewAchievers" CssClass="button1" onclick="btn_viewAchievers_Click" Text="View Achievers in this Month" />
			<!-- Send Email to achievers Part -->
			<asp:Button runat="server" ID="btn_sendToAchievers" Text="Send Achievers an Email" CssClass="button1" enabled="false" OnClick="btn_sendToAchievers_Click"/>
			</div>
            <br />
            <br />

        </div>

        <div style="" >
             <!-- Output Table -->
            <asp:Table runat="server" ID="tbl_output_table" HorizontalAlign="Center" CellSpacing="3" CellPadding="3" GridLines="Both" style="margin-right: 4px" >
            </asp:Table>
        </div>

    </form>
</body>
</html>
