<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Database Configuration Test</title>
</head>
<body>
    <h2>Testing Different Database Configurations</h2>
    
    <%
        String[] passwords = {"", "root", "14162121", "password", "123456"};
        String[] ports = {"3306", "3307", "3308"};
        String driver = "com.mysql.cj.jdbc.Driver";
        
        boolean connected = false;
        String workingConfig = "";
        
        try {
            Class.forName(driver);
            out.println("<p>✓ MySQL Driver loaded successfully</p>");
            
            for (String port : ports) {
                for (String password : passwords) {
                    String url = "jdbc:mysql://localhost:" + port + "/mysql?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                    try {
                        Connection conn = DriverManager.getConnection(url, "root", password);
                        if (conn != null) {
                            out.println("<p style='color: green;'>✓ SUCCESS: Port " + port + ", Password: '" + password + "'</p>");
                            workingConfig = "Port: " + port + ", Password: '" + password + "'";
                            
                            // Test creating trendhire database
                            PreparedStatement stmt = conn.prepareStatement("CREATE DATABASE IF NOT EXISTS trendhire");
                            stmt.executeUpdate();
                            out.println("<p style='color: green;'>✓ trendhire database created/verified</p>");
                            stmt.close();
                            
                            conn.close();
                            connected = true;
                            break;
                        }
                    } catch (SQLException e) {
                        out.println("<p style='color: red;'>✗ Port " + port + ", Password: '" + password + "' - " + e.getMessage() + "</p>");
                    }
                }
                if (connected) break;
            }
            
            if (connected) {
                out.println("<h3 style='color: green;'>Working Configuration Found: " + workingConfig + "</h3>");
                out.println("<p>Update your DBConnector.java with these settings.</p>");
            } else {
                out.println("<h3 style='color: red;'>No working configuration found!</h3>");
                out.println("<p>Please check:</p>");
                out.println("<ul>");
                out.println("<li>WAMP/XAMPP is running</li>");
                out.println("<li>MySQL service is started</li>");
                out.println("<li>Firewall is not blocking MySQL</li>");
                out.println("</ul>");
            }
            
        } catch (ClassNotFoundException e) {
            out.println("<p style='color: red;'>✗ MySQL Driver not found: " + e.getMessage() + "</p>");
        }
    %>
    
    <p><a href="index.jsp">Back to Home</a></p>
</body>
</html>