<%@page import="com.classes.company"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    company company = (company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("companyLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Recruiter Dashboard - TrendHire</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .dashboard-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .dashboard-card:hover {
            transform: translateY(-2px);
        }
        .stat-card {
            text-align: center;
            padding: 30px 20px;
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #007bff;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .status-applied { background: #e3f2fd; color: #1976d2; }
        .status-shortlisted { background: #fff3e0; color: #f57c00; }
        .status-interview { background: #f3e5f5; color: #7b1fa2; }
        .status-selected { background: #e8f5e8; color: #388e3c; }
        .status-rejected { background: #ffebee; color: #d32f2f; }
        .quick-action-btn {
            margin: 5px;
            border-radius: 20px;
        }
        .application-row {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .application-row:last-child {
            border-bottom: none;
        }
        .candidate-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/trendhireLogo.jpg" class="main-logo" alt="Logo" title="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav navbar-center m-auto">
                        <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="vacancies.jsp">All Jobs</a></li>
                        <li class="nav-item active"><a class="nav-link" href="recruiter_dashboard.jsp">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="companyProfile.jsp">Profile</a></li>
                    </ul>
                    <ul class="navbar-nav navbar-right">
                        <li><a class="btn btn-danger" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid" style="margin-top: 30px;">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-tachometer-alt"></i> Recruiter Dashboard</h2>
                <p class="text-muted">Welcome back, <%= company.getCompanyName() %>! Here's your recruitment overview.</p>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row">
            <%
                Connection connection = DBConnector.getCon();
                int totalJobs = 0, activeJobs = 0, totalApplications = 0, newApplications = 0;
                
                if (connection != null) {
                    // Get job statistics
                    PreparedStatement stmt = connection.prepareStatement(
                        "SELECT COUNT(*) as total FROM vacancy WHERE companyID = ?");
                    stmt.setString(1, company.getCompanyID());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) totalJobs = rs.getInt("total");
                    rs.close(); stmt.close();
                    
                    // Get active jobs
                    stmt = connection.prepareStatement(
                        "SELECT COUNT(*) as active FROM vacancy WHERE companyID = ? AND job_status = 'Published'");
                    stmt.setString(1, company.getCompanyID());
                    rs = stmt.executeQuery();
                    if (rs.next()) activeJobs = rs.getInt("active");
                    rs.close(); stmt.close();
                    
                    // Get total applications
                    stmt = connection.prepareStatement(
                        "SELECT COUNT(*) as total FROM application WHERE companyID = ?");
                    stmt.setString(1, company.getCompanyID());
                    rs = stmt.executeQuery();
                    if (rs.next()) totalApplications = rs.getInt("total");
                    rs.close(); stmt.close();
                    
                    // Get new applications (last 7 days)
                    stmt = connection.prepareStatement(
                        "SELECT COUNT(*) as new_apps FROM application WHERE companyID = ? AND applied_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
                    stmt.setString(1, company.getCompanyID());
                    rs = stmt.executeQuery();
                    if (rs.next()) newApplications = rs.getInt("new_apps");
                    rs.close(); stmt.close();
                }
            %>
            
            <div class="col-md-3">
                <div class="dashboard-card stat-card">
                    <div class="stat-number"><%= totalJobs %></div>
                    <div class="stat-label">Total Job Posts</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card stat-card">
                    <div class="stat-number"><%= activeJobs %></div>
                    <div class="stat-label">Active Jobs</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card stat-card">
                    <div class="stat-number"><%= totalApplications %></div>
                    <div class="stat-label">Total Applications</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="dashboard-card stat-card">
                    <div class="stat-number text-success"><%= newApplications %></div>
                    <div class="stat-label">New This Week</div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row">
            <div class="col-12">
                <div class="dashboard-card">
                    <h4><i class="fas fa-bolt"></i> Quick Actions</h4>
                    <div class="mt-3">
                        <a href="enhanced_post_job.jsp" class="btn btn-primary quick-action-btn">
                            <i class="fas fa-plus"></i> Post New Job
                        </a>
                        <a href="companyVacancies.jsp" class="btn btn-info quick-action-btn">
                            <i class="fas fa-briefcase"></i> Manage Jobs
                        </a>
                        <a href="companyApplication.jsp" class="btn btn-success quick-action-btn">
                            <i class="fas fa-users"></i> View Applications
                        </a>
                        <a href="#" class="btn btn-warning quick-action-btn" onclick="showInterviewScheduler()">
                            <i class="fas fa-calendar"></i> Schedule Interview
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Recent Applications -->
            <div class="col-md-8">
                <div class="dashboard-card">
                    <h4><i class="fas fa-file-alt"></i> Recent Applications</h4>
                    <div class="mt-3">
                        <%
                            if (connection != null) {
                                PreparedStatement stmt = connection.prepareStatement(
                                    "SELECT a.*, v.title, s.seekerFName, s.seekerLName, s.seekerEmail, " +
                                    "DATEDIFF(NOW(), a.applied_date) as days_ago " +
                                    "FROM application a " +
                                    "JOIN vacancy v ON a.vacancyID = v.vacancyID " +
                                    "JOIN seeker s ON a.seekerID = s.seekerID " +
                                    "WHERE a.companyID = ? " +
                                    "ORDER BY a.applied_date DESC LIMIT 5");
                                stmt.setString(1, company.getCompanyID());
                                ResultSet rs = stmt.executeQuery();
                                
                                while (rs.next()) {
                                    String statusClass = "status-" + rs.getString("application_status").toLowerCase().replace(" ", "-");
                        %>
                        <div class="application-row">
                            <div class="row align-items-center">
                                <div class="col-md-1">
                                    <div class="candidate-avatar">
                                        <%= rs.getString("seekerFName").charAt(0) %><%= rs.getString("seekerLName").charAt(0) %>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <strong><%= rs.getString("seekerFName") %> <%= rs.getString("seekerLName") %></strong><br>
                                    <small class="text-muted"><%= rs.getString("seekerEmail") %></small>
                                </div>
                                <div class="col-md-3">
                                    <strong><%= rs.getString("title") %></strong><br>
                                    <small class="text-muted"><%= rs.getInt("days_ago") %> days ago</small>
                                </div>
                                <div class="col-md-2">
                                    <span class="status-badge <%= statusClass %>">
                                        <%= rs.getString("application_status") != null ? rs.getString("application_status") : rs.getString("status") %>
                                    </span>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-sm btn-outline-primary" onclick="viewApplication(<%= rs.getInt("applicationID") %>)">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                                rs.close();
                                stmt.close();
                            }
                        %>
                    </div>
                    <div class="text-center mt-3">
                        <a href="companyApplication.jsp" class="btn btn-outline-primary">View All Applications</a>
                    </div>
                </div>
            </div>

            <!-- Application Status Chart -->
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h4><i class="fas fa-chart-pie"></i> Application Status</h4>
                    <canvas id="statusChart" width="300" height="300"></canvas>
                </div>
            </div>
        </div>

        <!-- Active Jobs -->
        <div class="row">
            <div class="col-12">
                <div class="dashboard-card">
                    <h4><i class="fas fa-briefcase"></i> Active Job Postings</h4>
                    <div class="table-responsive mt-3">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Job Title</th>
                                    <th>Location</th>
                                    <th>Type</th>
                                    <th>Applications</th>
                                    <th>Posted Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (connection != null) {
                                        PreparedStatement stmt = connection.prepareStatement(
                                            "SELECT v.*, COUNT(a.applicationID) as app_count " +
                                            "FROM vacancy v " +
                                            "LEFT JOIN application a ON v.vacancyID = a.vacancyID " +
                                            "WHERE v.companyID = ? AND v.job_status = 'Published' " +
                                            "GROUP BY v.vacancyID " +
                                            "ORDER BY v.posted_date DESC LIMIT 10");
                                        stmt.setString(1, company.getCompanyID());
                                        ResultSet rs = stmt.executeQuery();
                                        
                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><strong><%= rs.getString("title") %></strong></td>
                                    <td><%= rs.getString("location") %></td>
                                    <td><%= rs.getString("type") %></td>
                                    <td>
                                        <span class="badge badge-info"><%= rs.getInt("app_count") %> applications</span>
                                    </td>
                                    <td><%= rs.getDate("posted_date") %></td>
                                    <td>
                                        <span class="badge badge-success">Active</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" onclick="viewJobApplications(<%= rs.getInt("vacancyID") %>)">
                                            <i class="fas fa-users"></i> View Apps
                                        </button>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="editJob(<%= rs.getInt("vacancyID") %>)">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        stmt.close();
                                        connection.close();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Application Status Chart
        <%
            // Get status data for chart
            connection = DBConnector.getCon();
            int applied = 0, shortlisted = 0, interview = 0, selected = 0, rejected = 0;
            
            if (connection != null) {
                PreparedStatement stmt = connection.prepareStatement(
                    "SELECT " +
                    "SUM(CASE WHEN application_status = 'Applied' OR status = 'Waiting' THEN 1 ELSE 0 END) as applied, " +
                    "SUM(CASE WHEN application_status = 'Shortlisted' THEN 1 ELSE 0 END) as shortlisted, " +
                    "SUM(CASE WHEN application_status LIKE '%Interview%' THEN 1 ELSE 0 END) as interview, " +
                    "SUM(CASE WHEN application_status = 'Selected' OR status = 'Accepted' THEN 1 ELSE 0 END) as selected, " +
                    "SUM(CASE WHEN application_status = 'Rejected' OR status = 'Rejected' THEN 1 ELSE 0 END) as rejected " +
                    "FROM application WHERE companyID = ?");
                stmt.setString(1, company.getCompanyID());
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    applied = rs.getInt("applied");
                    shortlisted = rs.getInt("shortlisted");
                    interview = rs.getInt("interview");
                    selected = rs.getInt("selected");
                    rejected = rs.getInt("rejected");
                }
                rs.close();
                stmt.close();
                connection.close();
            }
        %>
        
        const ctx = document.getElementById('statusChart').getContext('2d');
        const statusChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Applied', 'Shortlisted', 'Interview', 'Selected', 'Rejected'],
                datasets: [{
                    data: [<%= applied %>, <%= shortlisted %>, <%= interview %>, <%= selected %>, <%= rejected %>],
                    backgroundColor: [
                        '#2196F3',
                        '#FF9800',
                        '#9C27B0',
                        '#4CAF50',
                        '#F44336'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                legend: {
                    position: 'bottom'
                }
            }
        });

        // JavaScript functions
        function viewApplication(applicationId) {
            window.location.href = 'application_details.jsp?id=' + applicationId;
        }

        function viewJobApplications(vacancyId) {
            window.location.href = 'job_applications.jsp?vacancyId=' + vacancyId;
        }

        function editJob(vacancyId) {
            window.location.href = 'edit_job.jsp?id=' + vacancyId;
        }

        function showInterviewScheduler() {
            alert('Interview scheduler feature coming soon!');
        }
    </script>
</body>
</html>