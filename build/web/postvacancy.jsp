<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.classes.company" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    company company = (company) session.getAttribute("company");
    if (company != null) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Post New Job - GrumJobs</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" type="text/css" href="css/stylesheet-coral.css?v=<%= System.currentTimeMillis() %>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <style>
        .skill-input { margin-bottom: 10px; }
        .skill-tag { 
            display: inline-block; 
            background: #ff4153; 
            color: white; 
            padding: 5px 10px; 
            margin: 2px; 
            border-radius: 15px; 
            font-size: 12px;
        }
        .skill-tag .remove { 
            margin-left: 5px; 
            cursor: pointer; 
            font-weight: bold;
        }
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
            border-left: 4px solid #ff4153;
        }
        .section-title {
            color: #ff4153;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .toggle-section {
            background: #e9ecef;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            cursor: pointer;
            border: 1px solid #dee2e6;
        }
        .toggle-section:hover {
            background: #dee2e6;
        }
        .advanced-features {
            display: block;
        }
        .basic-mode .advanced-features {
            display: none !important;
        }
    </style>
</head>
<body>
    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/trenHire.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" title="Logo" style="max-width: 150px; max-height: 100px;">
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

    <div class="container-fluid" style="margin-top: 30px; margin-bottom: 50px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <h2 class="text-center mb-4">
                    <i class="fas fa-briefcase"></i> Post New Job Vacancy
                </h2>
                
                <!-- Mode Toggle -->
                <div class="text-center mb-4">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-primary" id="basicModeBtn">
                            <i class="fas fa-bolt"></i> Quick Post
                        </button>
                        <button type="button" class="btn btn-primary" id="advancedModeBtn">
                            <i class="fas fa-cogs"></i> Advanced Post
                        </button>
                    </div>
                    <p class="text-muted mt-2">Choose Quick Post for simple job posting or Advanced Post for detailed features</p>
                </div>
                
                <form action="backend/postVacancyProcess.jsp" method="post" id="jobForm">
                    
                    <!-- Basic Job Information -->
                    <div class="form-section">
                        <h4 class="section-title"><i class="fas fa-info-circle"></i> Basic Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">Job Title *</label>
                                    <input type="text" name="title" class="form-control" placeholder="e.g. Senior Java Developer" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">Job Category *</label>
                                    <select name="category" class="form-control" required>
                                        <option value="">Select Category</option>
                                        <option value="Information Technology (IT)">Information Technology (IT)</option>
                                        <option value="Management and Leadership">Management and Leadership</option>
                                        <option value="Human Resources">Human Resources</option>
                                        <option value="Finance and Accounting">Finance and Accounting</option>
                                        <option value="Marketing and Sales">Marketing and Sales</option>
                                        <option value="Operations and Logistics">Operations and Logistics</option>
                                        <option value="Customer Service">Customer Service</option>
                                        <option value="Research and Development (R&D)">Research and Development (R&D)</option>
                                        <option value="Legal and Compliance">Legal and Compliance</option>
                                        <option value="Creative and Design">Creative and Design</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group mb-3">
                                    <label class="form-label">Location *</label>
                                    <input type="text" name="location" class="form-control" placeholder="e.g. Colombo, Sri Lanka" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group mb-3">
                                    <label class="form-label">Job Type *</label>
                                    <select name="type" class="form-control" required>
                                        <option value="">Select Job Type</option>
                                        <option value="Full-time">Full-time</option>
                                        <option value="Part-time">Part-time</option>
                                        <option value="Contract">Contract</option>
                                        <option value="Internship">Internship</option>
                                        <option value="Remote">Remote</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4 advanced-features">
                                <div class="form-group mb-3">
                                    <label class="form-label">Experience Level</label>
                                    <select name="experience_level" class="form-control">
                                        <option value="">Select Level</option>
                                        <option value="Entry Level">Entry Level (0-2 years)</option>
                                        <option value="Mid Level">Mid Level (3-5 years)</option>
                                        <option value="Senior Level">Senior Level (6+ years)</option>
                                        <option value="Executive">Executive Level</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Salary Information -->
                    <div class="form-section">
                        <h4 class="section-title"><i class="fas fa-money-bill-wave"></i> Salary Information</h4>
                        <div class="row">
                            <div class="col-md-4" id="basicSalaryField" style="display: none;">
                                <div class="form-group mb-3">
                                    <label class="form-label">Salary *</label>
                                    <input type="text" name="salary" class="form-control" placeholder="e.g. Rs. 100,000 - 150,000">
                                </div>
                            </div>
                            <div class="col-md-4 advanced-features">
                                <div class="form-group mb-3">
                                    <label class="form-label">Minimum Salary (Rs.)</label>
                                    <input type="number" name="salary_min" class="form-control" placeholder="e.g. 100000">
                                </div>
                            </div>
                            <div class="col-md-4 advanced-features">
                                <div class="form-group mb-3">
                                    <label class="form-label">Maximum Salary (Rs.)</label>
                                    <input type="number" name="salary_max" class="form-control" placeholder="e.g. 150000">
                                </div>
                            </div>
                            <div class="col-md-4 advanced-features">
                                <div class="form-group mb-3">
                                    <label class="form-label">Application Deadline</label>
                                    <input type="date" name="application_deadline" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Required Skills (Advanced Only) -->
                    <div class="form-section advanced-features">
                        <h4 class="section-title"><i class="fas fa-cogs"></i> Required Skills</h4>
                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group mb-3">
                                    <label class="form-label">Add Skills (Press Enter to add)</label>
                                    <input type="text" id="skillInput" class="form-control" placeholder="e.g. Java, Spring Boot, MySQL">
                                    <small class="text-muted">Type a skill and press Enter to add it</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group mb-3">
                                    <label class="form-label">Skill Level</label>
                                    <select id="skillLevel" class="form-control">
                                        <option value="Basic">Basic</option>
                                        <option value="Intermediate" selected>Intermediate</option>
                                        <option value="Advanced">Advanced</option>
                                        <option value="Expert">Expert</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div id="skillTags" class="mb-3"></div>
                        <input type="hidden" name="required_skills" id="requiredSkills">
                    </div>

                    <!-- Job Description -->
                    <div class="form-section">
                        <h4 class="section-title"><i class="fas fa-file-alt"></i> Job Description</h4>
                        <div class="form-group mb-3">
                            <label class="form-label">Job Description *</label>
                            <textarea name="description" class="form-control" rows="8" placeholder="Describe the job responsibilities, requirements, and benefits..." required></textarea>
                        </div>
                    </div>

                    <!-- Publishing Options (Advanced Only) -->
                    <div class="form-section advanced-features">
                        <h4 class="section-title"><i class="fas fa-globe"></i> Publishing Options</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">Job Status</label>
                                    <select name="job_status" class="form-control">
                                        <option value="Draft">Save as Draft</option>
                                        <option value="Published" selected>Publish Immediately</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Selection Criteria Section -->
                    <div class="form-section advanced-features">
                        <h4 class="section-title"><i class="fas fa-filter"></i> Selection Criteria</h4>
                        <p class="text-muted">Define the criteria for evaluating candidates for this position</p>
                        
                        <div id="criteriaContainer">
                            <div class="criteria-item mb-3">
                                <div class="row">
                                    <div class="col-md-3">
                                        <select name="criteria_type[]" class="form-control">
                                            <option value="">Select Type</option>
                                            <option value="Education">Education</option>
                                            <option value="Experience">Experience</option>
                                            <option value="Skills">Skills</option>
                                            <option value="Certification">Certification</option>
                                            <option value="Language">Language</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <input type="text" name="criteria_description[]" class="form-control" 
                                               placeholder="e.g., Bachelor's degree in Computer Science">
                                    </div>
                                    <div class="col-md-2">
                                        <select name="criteria_priority[]" class="form-control">
                                            <option value="High">High (Must Have)</option>
                                            <option value="Medium" selected>Medium (Preferred)</option>
                                            <option value="Low">Low (Nice to Have)</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <input type="number" name="criteria_weightage[]" class="form-control" 
                                               placeholder="%" min="1" max="100">
                                    </div>
                                    <div class="col-md-1">
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeCriteria(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="addCriteria()">
                                <i class="fas fa-plus"></i> Add Another Criteria
                            </button>
                        </div>
                        
                        <div class="alert alert-info">
                            <small><i class="fas fa-info-circle"></i> 
                            Selection criteria help standardize candidate evaluation. High priority items are must-haves, 
                            while medium and low priority items are preferred qualifications.</small>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-success btn-lg me-3">
                            <i class="fas fa-save"></i> Post Job Vacancy
                        </button>
                        <a href="companyProfile.jsp" class="btn btn-secondary btn-lg">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>

                    <input type="hidden" name="companyID" value="<%= company.getCompanyID() %>">
                </form>
            </div>
        </div>
    </div>

    <footer id="footer">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-3" style="margin-top: 20px;">
                    <a href="index.jsp">
                        <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" alt="Logo" title="Logo">
                    </a>
                    <div class="footer_inner">
                        <p class="w-90">"Welcome to TrendHire, your gateway to career opportunities. Explore, apply, and 
                            connect with your dream jobs effortlessly. Join us today and shape your future!" 
                        </p>
                    </div>
                </div>
                <div class="col-sm-2 mx-auto" style="margin-top: 20px;">
                    <h5>Useful Links</h5>
                    <div class="footer_inner">
                        <ul class="list-unstyled">
                            <li><a href="aboutUs.jsp">About Us</a></li>
                            <li><a href="contact.jsp">Contact Us</a></li>
                            <li><a href="vacancies.jsp">Vacancies</a></li>
                            <li><a href="termsAndConditions.jsp">Terms & Conditions</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-sm-3" style="margin-top: 20px;">
                    <h5>Contact Us</h5>
                    <div class="footer_inner">
                        <div class="d-flex media">
                            <i class="fa fa-map-marker" aria-hidden="true"></i>
                            <div class="media-body"><p> <span class="f_rubik">43,</span> Passara Road, Badulla <br> Sri Lanka <span class="f_rubik">90000</span> </p></div>
                        </div>
                        <div class="d-flex media">
                            <i class="fa-regular fa-envelope"></i>
                            <div class="media-body"><p>info@trendhire.com</p></div>
                        </div>
                        <div class="d-flex media">
                            <i class="fa fa-phone" aria-hidden="true"></i>
                            <div class="media-body"><p class="f_rubik">+9455-1234567</p></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Mode switching functionality
        let isAdvancedMode = true;
        
        document.getElementById('basicModeBtn').addEventListener('click', function() {
            isAdvancedMode = false;
            document.body.classList.add('basic-mode');
            document.getElementById('basicModeBtn').classList.remove('btn-outline-primary');
            document.getElementById('basicModeBtn').classList.add('btn-primary');
            document.getElementById('advancedModeBtn').classList.remove('btn-primary');
            document.getElementById('advancedModeBtn').classList.add('btn-outline-primary');
            
            // Show basic salary field, hide advanced
            document.getElementById('basicSalaryField').style.display = 'block';
            document.querySelector('input[name="salary"]').required = true;
            
            // Clear advanced fields
            document.querySelector('select[name="experience_level"]').value = '';
            document.querySelector('input[name="salary_min"]').value = '';
            document.querySelector('input[name="salary_max"]').value = '';
            document.querySelector('input[name="application_deadline"]').value = '';
            document.querySelector('select[name="job_status"]').value = 'Published';
            skills = [];
            updateSkillTags();
            updateHiddenInput();
        });
        
        document.getElementById('advancedModeBtn').addEventListener('click', function() {
            isAdvancedMode = true;
            document.body.classList.remove('basic-mode');
            document.getElementById('advancedModeBtn').classList.remove('btn-outline-primary');
            document.getElementById('advancedModeBtn').classList.add('btn-primary');
            document.getElementById('basicModeBtn').classList.remove('btn-primary');
            document.getElementById('basicModeBtn').classList.add('btn-outline-primary');
            
            // Hide basic salary field
            document.getElementById('basicSalaryField').style.display = 'none';
            document.querySelector('input[name="salary"]').required = false;
        });

        // Skills management (for advanced mode)
        let skills = [];
        
        document.getElementById('skillInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                addSkill();
            }
        });
        
        function addSkill() {
            const skillInput = document.getElementById('skillInput');
            const skillLevel = document.getElementById('skillLevel');
            const skillName = skillInput.value.trim();
            
            if (skillName && !skills.find(s => s.name.toLowerCase() === skillName.toLowerCase())) {
                const skill = {
                    name: skillName,
                    level: skillLevel.value,
                    required: true
                };
                
                skills.push(skill);
                updateSkillTags();
                updateHiddenInput();
                skillInput.value = '';
            }
        }
        
        function removeSkill(index) {
            skills.splice(index, 1);
            updateSkillTags();
            updateHiddenInput();
        }
        
        function updateSkillTags() {
            const container = document.getElementById('skillTags');
            container.innerHTML = skills.map((skill, index) => 
                `<span class="skill-tag">
                    ${skill.name} (${skill.level})
                    <span class="remove" onclick="removeSkill(${index})">&times;</span>
                </span>`
            ).join('');
        }
        
        function updateHiddenInput() {
            document.getElementById('requiredSkills').value = JSON.stringify(skills);
        }
        
        // Form validation
        document.getElementById('jobForm').addEventListener('submit', function(e) {
            if (isAdvancedMode) {
                const salaryMin = document.querySelector('input[name="salary_min"]').value;
                const salaryMax = document.querySelector('input[name="salary_max"]').value;
                
                if (salaryMin && salaryMax && parseInt(salaryMin) > parseInt(salaryMax)) {
                    e.preventDefault();
                    alert('Minimum salary cannot be greater than maximum salary');
                    return false;
                }
            } else {
                // In basic mode, make sure salary field is required
                const basicSalary = document.querySelector('input[name="salary"]');
                if (!basicSalary.value.trim()) {
                    e.preventDefault();
                    alert('Please enter salary information');
                    basicSalary.focus();
                    return false;
                }
            }
        });
        
        // Selection Criteria Management
        function addCriteria() {
            const container = document.getElementById('criteriaContainer');
            const criteriaItem = document.createElement('div');
            criteriaItem.className = 'criteria-item mb-3';
            criteriaItem.innerHTML = `
                <div class="row">
                    <div class="col-md-3">
                        <select name="criteria_type[]" class="form-control">
                            <option value="">Select Type</option>
                            <option value="Education">Education</option>
                            <option value="Experience">Experience</option>
                            <option value="Skills">Skills</option>
                            <option value="Certification">Certification</option>
                            <option value="Language">Language</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="criteria_description[]" class="form-control" 
                               placeholder="e.g., Bachelor's degree in Computer Science">
                    </div>
                    <div class="col-md-2">
                        <select name="criteria_priority[]" class="form-control">
                            <option value="High">High (Must Have)</option>
                            <option value="Medium" selected>Medium (Preferred)</option>
                            <option value="Low">Low (Nice to Have)</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="number" name="criteria_weightage[]" class="form-control" 
                               placeholder="%" min="1" max="100">
                    </div>
                    <div class="col-md-1">
                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeCriteria(this)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;
            container.appendChild(criteriaItem);
        }
        
        function removeCriteria(button) {
            const criteriaItem = button.closest('.criteria-item');
            criteriaItem.remove();
        }
        
        // Initialize in advanced mode and ensure proper display
        document.addEventListener('DOMContentLoaded', function() {
            // Start in advanced mode
            isAdvancedMode = true;
            document.body.classList.remove('basic-mode');
            document.getElementById('advancedModeBtn').classList.add('btn-primary');
            document.getElementById('basicModeBtn').classList.add('btn-outline-primary');
            document.getElementById('basicSalaryField').style.display = 'none';
        });
    </script>
</body>
</html>

<%
    } else {
        response.sendRedirect("companyLogin.jsp?error=2");
    }
%>
