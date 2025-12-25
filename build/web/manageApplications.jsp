<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.company"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    company company = (company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("companyLogin.jsp");
        return;
    }
    
    String filterStatus = request.getParameter("status");
    if (filterStatus == null) filterStatus = "all";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Applications - TrendHire</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" type="text/css" href="css/stylesheet-coral.css?v=<%= System.currentTimeMillis() %>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <style>
        .application-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 15px;
            transition: box-shadow 0.3s ease;
        }
        .application-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
        }
        .status-applied { background-color: #ff4153; }
        .status-under-review { background-color: #ff4153; color: #000; }
        .status-shortlisted { background-color: #ff4153; }
        .status-interview-scheduled { background-color: #ff4153; }
        .status-selected { background-color: #ff4153; }
        .status-rejected { background-color: #dc3545; }
        .action-buttons .btn {
            margin: 2px;
            padding: 4px 8px;
            font-size: 0.8rem;
        }
        .filter-tabs {
            margin-bottom: 20px;
        }
        .seeker-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" title="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav navbar-center m-auto">
                        <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="companyProfile.jsp">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="postvacancy.jsp">Post Job</a></li>
                        <li class="nav-item"><a class="nav-link active" href="manageApplications.jsp">Applications</a></li>
                    </ul>
                    <ul class="navbar-nav navbar-right">
                        <li><a class="btn btn-danger" href="backend/logout.jsp">Log Out</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-users"></i> Manage Job Applications</h2>
                <p class="text-muted">Review and manage applications for your job postings</p>
                
                <!-- Filter Tabs -->
                <div class="filter-tabs">
                    <ul class="nav nav-pills">
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("all") ? "active" : "" %>" href="?status=all">
                                <i class="fas fa-list"></i> All Applications
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("Applied") ? "active" : "" %>" href="?status=Applied">
                                <i class="fas fa-clock"></i> New Applications
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
                        <li class="nav-item">
                            <a class="nav-link <%= filterStatus.equals("Under Review") ? "active" : "" %>" href="?status=Under Review">
                                <i class="fas fa-search"></i> Under Review
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
                            String query = "SELECT a.*, v.title as job_title, v.location, v.type as job_type, " +
                                         "s.seekerFName, s.seekerLName, s.seekerEmail, s.seekerPhone, s.seekerAbout, s.seekerCV, " +
                                         "DATEDIFF(CURDATE(), a.applied_date) as days_ago " +
                                         "FROM application a " +
                                         "JOIN vacancy v ON a.vacancyID = v.vacancyID " +
                                         "JOIN seeker s ON a.seekerID = s.seekerID " +
                                         "WHERE a.companyID = ?";
                            
                            if (!filterStatus.equals("all")) {
                                if (filterStatus.equals("Applied") || filterStatus.equals("Waiting")) {
                                    query += " AND a.status = 'Waiting'";
                                } else if (filterStatus.equals("Accepted") || filterStatus.equals("Selected")) {
                                    query += " AND a.status = 'Accepted'";
                                } else if (filterStatus.equals("Rejected")) {
                                    query += " AND a.status = 'Rejected'";
                                } else if (filterStatus.equals("Under Review")) {
                                    query += " AND a.status = 'Under Review'";
                                }
                            }
                            
                            query += " ORDER BY a.applied_date DESC";
                            
                            PreparedStatement stmt = connection.prepareStatement(query);
                            stmt.setString(1, String.valueOf(company.getCompanyID()));
                            
                            ResultSet rs = stmt.executeQuery();
                            
                            boolean hasApplications = false;
                            while (rs.next()) {
                                hasApplications = true;
                                String status = rs.getString("status");
                                if (status == null) status = "Waiting";
                                // Convert database status to display status
                                String displayStatus = status;
                                if (status.equals("Waiting")) displayStatus = "Applied";
                                if (status.equals("Accepted")) displayStatus = "Selected";
                    %>
                    
                    <div class="application-card">
                        <div class="card-body">
                            <div class="row">
                                <!-- Seeker Information -->
                                <div class="col-md-4">
                                    <div class="seeker-info">
                                        <h5><i class="fas fa-user"></i> <%= rs.getString("seekerFName") %> <%= rs.getString("seekerLName") %></h5>
                                        <p class="mb-1"><i class="fas fa-envelope"></i> <%= rs.getString("seekerEmail") %></p>
                                        <p class="mb-1"><i class="fas fa-phone"></i> <%= rs.getString("seekerPhone") %></p>
                                        <% if (rs.getString("seekerAbout") != null && !rs.getString("seekerAbout").trim().isEmpty()) { %>
                                        <p class="mb-1"><small><%= rs.getString("seekerAbout") %></small></p>
                                        <% } %>
                                        <% if (rs.getString("seekerCV") != null && !rs.getString("seekerCV").contains("default")) { %>
                                        <a href="<%= rs.getString("seekerCV") %>" target="_blank" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-file-pdf"></i> View CV
                                        </a>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <!-- Job Information -->
                                <div class="col-md-4">
                                    <h6><i class="fas fa-briefcase"></i> <%= rs.getString("job_title") %></h6>
                                    <p class="mb-1"><i class="fas fa-map-marker-alt"></i> <%= rs.getString("location") %></p>
                                    <p class="mb-1"><i class="fas fa-clock"></i> <%= rs.getString("job_type") %></p>
                                    <p class="mb-1"><small class="text-muted">Applied <%= rs.getInt("days_ago") %> days ago</small></p>
                                    
                                    <span class="badge status-badge status-<%= displayStatus.toLowerCase().replace(" ", "-") %>">
                                        <%= displayStatus %>
                                    </span>
                                </div>
                                
                                <!-- Actions -->
                                <div class="col-md-4">
                                    <div class="action-buttons">
                                        <h6>Actions:</h6>
                                        
                                        <% if (status.equals("Applied")) { %>
                                        <button class="btn btn-warning btn-sm" onclick="updateStatus(<%= rs.getInt("applicationID") %>, 'Under Review')">
                                            <i class="fas fa-search"></i> Review
                                        </button>
                                        <% } %>
                                        
                                        <% if (status.equals("Applied") || status.equals("Under Review")) { %>
                                        <button class="btn btn-success btn-sm" onclick="updateStatus(<%= rs.getInt("applicationID") %>, 'Shortlisted')">
                                            <i class="fas fa-star"></i> Shortlist
                                        </button>
                                        <% } %>
                                        
                                        <% if (status.equals("Shortlisted") || status.equals("Under Review")) { %>
                                        <button class="btn btn-primary btn-sm" onclick="scheduleInterview(<%= rs.getInt("applicationID") %>)">
                                            <i class="fas fa-calendar"></i> Schedule Interview
                                        </button>
                                        <% } %>
                                        
                                        <% if (status.equals("Interview Scheduled")) { %>
                                        <button class="btn btn-success btn-sm" onclick="updateStatus(<%= rs.getInt("applicationID") %>, 'Selected')">
                                            <i class="fas fa-check"></i> Select
                                        </button>
                                        <% } %>
                                        
                                        <% if (!status.equals("Rejected") && !status.equals("Selected")) { %>
                                        <button class="btn btn-danger btn-sm" onclick="rejectApplication(<%= rs.getInt("applicationID") %>)">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                        <% } %>
                                        
                                        <button class="btn btn-info btn-sm" onclick="addNotes(<%= rs.getInt("applicationID") %>)">
                                            <i class="fas fa-sticky-note"></i> Notes
                                        </button>
                                    </div>
                                    
                                    <% if (rs.getString("recruiter_notes") != null && !rs.getString("recruiter_notes").trim().isEmpty()) { %>
                                    <div class="mt-2">
                                        <small><strong>Notes:</strong> <%= rs.getString("recruiter_notes") %></small>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
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
                            No applications have been received yet.
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
                    }
                    %>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <!-- Reject Application Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reject Application</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="rejectForm">
                        <input type="hidden" id="rejectApplicationId">
                        <div class="mb-3">
                            <label class="form-label">Reason for Rejection:</label>
                            <textarea class="form-control" id="rejectionReason" rows="3" placeholder="Please provide a reason for rejection..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmReject()">Reject Application</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Schedule Interview Modal -->
    <div class="modal fade" id="interviewModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Schedule Interview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="interviewForm">
                        <input type="hidden" id="interviewApplicationId">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Interview Date:</label>
                                    <input type="date" class="form-control" id="interviewDate" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Interview Time:</label>
                                    <input type="time" class="form-control" id="interviewTime" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Interview Mode:</label>
                            <select class="form-control" id="interviewMode">
                                <option value="Online">Online</option>
                                <option value="Onsite">Onsite</option>
                                <option value="Phone">Phone</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Meeting Link/Location:</label>
                            <input type="text" class="form-control" id="interviewLocation" placeholder="Zoom link or office address">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Interviewer Name:</label>
                            <input type="text" class="form-control" id="interviewerName" value="<%= company.getCompanyName() %>" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="confirmInterview()">Schedule Interview</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Notes Modal -->
    <div class="modal fade" id="notesModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Notes</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="notesForm">
                        <input type="hidden" id="notesApplicationId">
                        <div class="mb-3">
                            <label class="form-label">Recruiter Notes:</label>
                            <textarea class="form-control" id="recruiterNotes" rows="4" placeholder="Add your notes about this candidate..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveNotes()">Save Notes</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(applicationId, newStatus) {
            if (confirm('Are you sure you want to change the status to "' + newStatus + '"?')) {
                fetch('backend/updateApplicationStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'applicationId=' + applicationId + '&status=' + encodeURIComponent(newStatus)
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        location.reload();
                    } else {
                        alert('Error updating status');
                    }
                });
            }
        }

        function rejectApplication(applicationId) {
            document.getElementById('rejectApplicationId').value = applicationId;
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function confirmReject() {
            const applicationId = document.getElementById('rejectApplicationId').value;
            const reason = document.getElementById('rejectionReason').value;
            
            fetch('backend/updateApplicationStatus.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'applicationId=' + applicationId + '&status=Rejected&notes=' + encodeURIComponent(reason)
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    location.reload();
                } else {
                    alert('Error rejecting application');
                }
            });
        }

        function scheduleInterview(applicationId) {
            document.getElementById('interviewApplicationId').value = applicationId;
            // Set minimum date to today
            document.getElementById('interviewDate').min = new Date().toISOString().split('T')[0];
            new bootstrap.Modal(document.getElementById('interviewModal')).show();
        }

        function confirmInterview() {
            const applicationId = document.getElementById('interviewApplicationId').value;
            const date = document.getElementById('interviewDate').value;
            const time = document.getElementById('interviewTime').value;
            const mode = document.getElementById('interviewMode').value;
            const location = document.getElementById('interviewLocation').value;
            const interviewer = document.getElementById('interviewerName').value;
            
            if (!date || !time || !interviewer) {
                alert('Please fill in all required fields');
                return;
            }
            
            fetch('backend/scheduleInterview.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'applicationId=' + applicationId + 
                      '&date=' + date + 
                      '&time=' + time + 
                      '&mode=' + mode + 
                      '&location=' + encodeURIComponent(location) + 
                      '&interviewer=' + encodeURIComponent(interviewer)
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    location.reload();
                } else {
                    alert('Error scheduling interview');
                }
            });
        }

        function addNotes(applicationId) {
            document.getElementById('notesApplicationId').value = applicationId;
            new bootstrap.Modal(document.getElementById('notesModal')).show();
        }

        function saveNotes() {
            const applicationId = document.getElementById('notesApplicationId').value;
            const notes = document.getElementById('recruiterNotes').value;
            
            fetch('backend/updateApplicationStatus.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'applicationId=' + applicationId + '&notes=' + encodeURIComponent(notes) + '&updateNotesOnly=true'
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    location.reload();
                } else {
                    alert('Error saving notes');
                }
            });
        }
    </script>
</body>
</html>
