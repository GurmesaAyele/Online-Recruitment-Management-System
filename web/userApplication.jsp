<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.seeker"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    seeker seeker = (seeker) session.getAttribute("seeker");
    if (seeker != null) {
        String filterStatus = request.getParameter("status");
        if (filterStatus == null) filterStatus = "all";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Applications - TrendHire</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <style>
        .application-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s ease;
        }
        .application-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 20px;
        }
        .status-applied { background-color: #17a2b8; color: white; }
        .status-under-review { background-color: #ffc107; color: #000; }
        .status-shortlisted { background-color: #28a745; color: white; }
        .status-interview-scheduled { background-color: #6f42c1; color: white; }
        .status-selected { background-color: #198754; color: white; }
        .status-rejected { background-color: #dc3545; color: white; }
        .status-withdrawn { background-color: #6c757d; color: white; }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .company-logo {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            margin-right: 15px;
            object-fit: cover;
        }
        .interview-details {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-left: 4px solid #2196f3;
            padding: 20px;
            margin: 15px 0;
            border-radius: 0 8px 8px 0;
            box-shadow: 0 2px 8px rgba(33, 150, 243, 0.1);
        }
        .interview-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .interview-info-item i {
            width: 20px;
            margin-right: 8px;
            color: #1976d2;
        }
    </style>
</head>
<body>
    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light"></nav>
            <div class="container-fluid"></div>
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" title="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav navbar-center m-auto">
                        <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="vacancies.jsp">Vacancies</a></li>
                        <li class="nav-item"><a class="nav-link" href="aboutUs.jsp">About Us</a></li>
                        <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
                    </ul>
                    <ul class="navbar-nav navbar-right">
                        <li><a class="btn btn-danger" href="./backend/logout.jsp">Log Out</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-3">
                <div class="card mb-3">
                    <div class="card-body text-center"></div>
                        <img src="<%= seeker.getProfilePath() %>" alt="Profile" class="rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
                        <h5><%= seeker.getFirstName() %> <%= seeker.getLastName() %></h5>
                        <p class="text-muted"><%= seeker.getEmail() %></p>
                    </div>
                </div>
                
                <div class="d-grid gap-2">
                    <a href="userprofile.jsp" class="btn btn-outline-primary">
                        <i class="fas fa-user"></i> My Profile
                    </a>
                    <a href="vacancies.jsp" class="btn btn-outline-success">
                        <i class="fas fa-search"></i> Browse Jobs
                    </a>
                    <a href="userApplication.jsp" class="btn btn-primary">
                        <i class="fas fa-file-alt"></i> My Applications
                    </a>
                </div>
            </div>
            
            <div class="col-md-9">
                <h2><i class="fas fa-file-alt"></i> My Job Applications</h2>
                <p class="text-muted">Track the status of all your job applications</p>
                
                <!-- Application Statistics -->
                <%
                try {
                    Connection connection = DBConnector.getCon();
                    if (connection != null) {
                        String statsQuery = "SELECT " +
                                          "COUNT(*) as total_applications, " +
                                          "COUNT(CASE WHEN COALESCE(application_status, 'Applied') = 'Applied' THEN 1 END) as new_applications, " +
                                          "COUNT(CASE WHEN application_status = 'Under Review' THEN 1 END) as under_review, " +
                                          "COUNT(CASE WHEN application_status = 'Shortlisted' THEN 1 END) as shortlisted, " +
                                          "COUNT(CASE WHEN application_status = 'Interview Scheduled' THEN 1 END) as interviews, " +
                                          "COUNT(CASE WHEN application_status = 'Selected' THEN 1 END) as selected, " +
                                          "COUNT(CASE WHEN application_status = 'Rejected' THEN 1 END) as rejected " +
                                          "FROM application WHERE seekerID = ?";
                        
                        PreparedStatement statsStmt = connection.prepareStatement(statsQuery);
                        statsStmt.setString(1, seeker.useSeekerID());
                        ResultSet statsRs = statsStmt.executeQuery();
                        
                        if (statsRs.next()) {
                %>
                <div class="stats-card">
                    <div class="row text-center">
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("total_applications") %></h4>
                            <small>Total Applications</small>
                        </div>
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("new_applications") %></h4>
                            <small>Applied</small>
                        </div>
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("under_review") %></h4>
                            <small>Under Review</small>
                        </div>
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("interviews") %></h4>
                            <small>Interviews</small>
                        </div>
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("selected") %></h4>
                            <small>Selected</small>
                        </div>
                        <div class="col-md-2">
                            <h4><%= statsRs.getInt("rejected") %></h4>
                            <small>Rejected</small>
                        </div>
                    </div>
                </div>
                <%
                        }
                        statsRs.close();
                        statsStmt.close();
                        connection.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
                
                <!-- Filter Tabs -->
                <div class="mb-4">
                    <ul class="nav nav-pills">
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("all") ? "active" : "" %>" href="?status=all">
                                <i class="fas fa-list"></i> All Applications
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("Waiting") ? "active" : "" %>" href="?status=Waiting">
                                <i class="fas fa-clock"></i> Applied
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("Accepted") ? "active" : "" %>" href="?status=Accepted">
                                <i class="fas fa-check-circle"></i> Accepted
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("Rejected") ? "active" : "" %>" href="?status=Rejected">
                                <i class="fas fa-times-circle"></i> Rejected
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Applications List -->
                <div class="applications-container">
                    <%
                    try {
                        Connection connection = DBConnector.getCon();
                        if (connection != null) {
                            String query = "SELECT a.*, v.title as job_title, v.location, v.type as job_type, v.salary, " +
                                         "c.companyName, c.companyPic, " +
                                         "DATEDIFF(CURDATE(), a.applied_date) as days_ago " +
                                         "FROM application a " +
                                         "JOIN vacancy v ON a.vacancyID = v.vacancyID " +
                                         "JOIN company c ON a.companyID = c.companyID " +
                                         "WHERE a.seekerID = ?";
                            
                            if (!filterStatus.equals("all")) {
                                if (filterStatus.equals("Applied") || filterStatus.equals("Waiting")) {
                                    query += " AND a.status = 'Waiting'";
                                } else if (filterStatus.equals("Accepted") || filterStatus.equals("Selected")) {
                                    query += " AND a.status = 'Accepted'";
                                } else if (filterStatus.equals("Rejected")) {
                                    query += " AND a.status = 'Rejected'";
                                }
                            }
                            
                            query += " ORDER BY a.applied_date DESC";
                            
                            PreparedStatement stmt = connection.prepareStatement(query);
                            stmt.setString(1, seeker.useSeekerID());
                            
                            ResultSet rs = stmt.executeQuery();
                            
                            boolean hasApplications = false;
                            while (rs.next()) {
                                hasApplications = true;
                                String status = rs.getString("status");
                                if (status == null || status.trim().isEmpty()) status = "Waiting";
                                // Convert database status to display status
                                String displayStatus = status;
                                if (status.equals("Waiting")) displayStatus = "Applied";
                                if (status.equals("Accepted")) displayStatus = "Selected";
                                int applicationId = rs.getInt("applicationID");
                    %>
                    
                    <div class="application-card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="d-flex align-items-center mb-3">
                                        <img src="<%= rs.getString("companyPic") != null ? rs.getString("companyPic") : "./images/uploads/companyPictures/default.jpg" %>" 
                                             alt="Company Logo" class="company-logo">
                                        <div>
                                            <h5 class="mb-1"><%= rs.getString("job_title") %></h5>
                                            <h6 class="text-primary mb-1"><%= rs.getString("companyName") %></h6>
                                            <p class="text-muted mb-0">
                                                <i class="fas fa-map-marker-alt"></i> <%= rs.getString("location") %> | 
                                                <i class="fas fa-clock"></i> <%= rs.getString("job_type") %> |
                                                <i class="fas fa-money-bill-wave"></i> <%= rs.getString("salary") %>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <div class="bg-light p-3 rounded">
                                        <p class="mb-2"><strong>Applied:</strong> <%= rs.getInt("days_ago") %> days ago</p>
                                        <% if (rs.getString("recruiter_notes") != null && !rs.getString("recruiter_notes").trim().isEmpty()) { %>
                                        <p class="mb-0"><strong>Recruiter Notes:</strong> <%= rs.getString("recruiter_notes") %></p>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 text-end">
                                    <span class="badge status-badge status-<%= displayStatus.toLowerCase().replace(" ", "-") %> mb-3">
                                        <%= displayStatus %>
                                    </span>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-outline-primary btn-sm" onclick="viewDetails(<%= applicationId %>)">
                                            <i class="fas fa-eye"></i> View Details
                                        </button>
                                        <button class="btn btn-outline-info btn-sm" onclick="viewHistory(<%= applicationId %>)">
                                            <i class="fas fa-history"></i> Status History
                                        </button>
                                        <% if (status.equals("Applied") || status.equals("Under Review")) { %>
                                        <button class="btn btn-outline-danger btn-sm" onclick="withdrawApplication(<%= applicationId %>)">
                                            <i class="fas fa-times"></i> Withdraw
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Enhanced Interview Information Display -->
                            <% if (status.equals("Interview Scheduled")) { %>
                            <%
                                String interviewQuery = "SELECT * FROM interview WHERE applicationID = ? ORDER BY created_at DESC LIMIT 1";
                                PreparedStatement intStmt = connection.prepareStatement(interviewQuery);
                                intStmt.setInt(1, applicationId);
                                ResultSet intRs = intStmt.executeQuery();
                                
                                if (intRs.next()) {
                            %>
                            <div class="interview-details">
                                <h6 class="mb-3"><i class="fas fa-calendar-check text-primary"></i> <strong>Interview Details</strong></h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="interview-info-item">
                                            <i class="fas fa-calendar-day"></i>
                                            <div>
                                                <strong>Date:</strong> <%= intRs.getDate("interview_date") %>
                                            </div>
                                        </div>
                                        
                                        <div class="interview-info-item">
                                            <i class="fas fa-clock"></i>
                                            <div>
                                                <strong>Time:</strong> <%= intRs.getTime("interview_time") %>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="interview-info-item">
                                            <i class="fas fa-<%= intRs.getString("interview_mode").equals("Online") ? "laptop" : intRs.getString("interview_mode").equals("Phone") ? "phone" : "building" %>"></i>
                                            <div>
                                                <strong>Mode:</strong> 
                                                <span class="badge bg-<%= intRs.getString("interview_mode").equals("Online") ? "primary" : intRs.getString("interview_mode").equals("Phone") ? "success" : "warning" %>">
                                                    <%= intRs.getString("interview_mode") %>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="interview-info-item">
                                            <i class="fas fa-user-tie"></i>
                                            <div>
                                                <strong>Interviewer:</strong> <%= intRs.getString("interviewer_name") %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Meeting Link for Online Interviews -->
                                <% if (intRs.getString("interview_mode").equals("Online") && intRs.getString("meeting_link") != null && !intRs.getString("meeting_link").trim().isEmpty()) { %>
                                <div class="mt-3 p-3 bg-white rounded border">
                                    <div class="interview-info-item">
                                        <i class="fas fa-video text-success"></i>
                                        <div class="flex-grow-1">
                                            <strong>Meeting Link:</strong>
                                            <div class="mt-1">
                                                <a href="<%= intRs.getString("meeting_link") %>" target="_blank" class="btn btn-success btn-sm">
                                                    <i class="fas fa-video"></i> Join Online Meeting
                                                </a>
                                                <small class="text-muted d-block mt-1">Click to join the interview meeting</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                                
                                <!-- Location for Onsite Interviews -->
                                <% if (!intRs.getString("interview_mode").equals("Online") && intRs.getString("interview_location") != null && !intRs.getString("interview_location").trim().isEmpty()) { %>
                                <div class="mt-3 p-3 bg-white rounded border">
                                    <div class="interview-info-item">
                                        <i class="fas fa-map-marker-alt text-danger"></i>
                                        <div>
                                            <strong>Location:</strong> <%= intRs.getString("interview_location") %>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                                
                                <!-- Interviewer Contact -->
                                <% if (intRs.getString("interviewer_email") != null && !intRs.getString("interviewer_email").trim().isEmpty()) { %>
                                <div class="mt-3 p-3 bg-white rounded border">
                                    <div class="interview-info-item">
                                        <i class="fas fa-envelope text-info"></i>
                                        <div>
                                            <strong>Contact:</strong> 
                                            <a href="mailto:<%= intRs.getString("interviewer_email") %>" class="text-decoration-none">
                                                <%= intRs.getString("interviewer_email") %>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                                
                                <div class="mt-3 text-center">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle"></i> 
                                        Please be prepared 10 minutes before the scheduled time
                                    </small>
                                </div>
                            </div>
                            <%
                                } else {
                            %>
                            <div class="alert alert-info mt-3">
                                <h6><i class="fas fa-calendar-alt"></i> Interview Scheduled</h6>
                                <p class="mb-0">Interview details are being prepared. Please check your email or contact the company for more information.</p>
                            </div>
                            <%
                                }
                                intRs.close();
                                intStmt.close();
                            %>
                            <% } %>
                        </div>
                    </div>
                    
                    <%
                            }
                            
                            if (!hasApplications) {
                    %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h4>No Applications Found</h4>
                        <p class="text-muted">
                            <% if (filterStatus.equals("all")) { %>
                            You haven't applied for any jobs yet. <a href="vacancies.jsp">Browse available jobs</a> to get started!
                            <% } else { %>
                            No applications with status "<%= filterStatus %>" found.
                            <% } %>
                        </p>
                    </div>
                    <%
                            }
                            
                            rs.close();
                            stmt.close();
                            connection.close();
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error loading applications: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                    %>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <!-- Application Details Modal -->
    <div class="modal fade" id="detailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Application Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="detailsContent">
                    Loading...
                </div>
            </div>
        </div>
    </div>

    <!-- Status History Modal -->
    <div class="modal fade" id="historyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Application Status History</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="historyContent">
                    Loading...
                </div>
            </div>
        </div>
    </div>

    <!-- Withdraw Application Modal -->
    <div class="modal fade" id="withdrawModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Withdraw Application</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to withdraw this application? This action cannot be undone.</p>
                    <input type="hidden" id="withdrawApplicationId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmWithdraw()">Withdraw Application</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewDetails(applicationId) {
            fetch('backend/getApplicationDetails.jsp?applicationId=' + applicationId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('detailsContent').innerHTML = data;
                    new bootstrap.Modal(document.getElementById('detailsModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('detailsContent').innerHTML = '<div class="alert alert-danger">Error loading details</div>';
                });
        }

        function viewHistory(applicationId) {
            fetch('backend/getApplicationHistory.jsp?applicationId=' + applicationId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('historyContent').innerHTML = data;
                    new bootstrap.Modal(document.getElementById('historyModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('historyContent').innerHTML = '<div class="alert alert-danger">Error loading history</div>';
                });
        }

        function withdrawApplication(applicationId) {
            document.getElementById('withdrawApplicationId').value = applicationId;
            new bootstrap.Modal(document.getElementById('withdrawModal')).show();
        }

        function confirmWithdraw() {
            const applicationId = document.getElementById('withdrawApplicationId').value;
            
            fetch('backend/withdrawApplication.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'applicationId=' + applicationId
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    location.reload();
                } else {
                    alert('Error withdrawing application');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error withdrawing application');
            });
        }
    </script>
</body>
</html>

<%
    } else {
        response.sendRedirect("seekerLogin.jsp?error=2");
    }
%>
