<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.MD5"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Login Test</title>
</head>
<body>
    <h2>Testing Login Credentials</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                out.println("<p style='color: green;'>✓ Database connection successful!</p>");
                
                // Test seeker login
                String seekerQuery = "SELECT * FROM seeker WHERE seekerUName = ?";
                PreparedStatement seekerStmt = connection.prepareStatement(seekerQuery);
                seekerStmt.setString(1, "johndoe");
                ResultSet seekerRs = seekerStmt.executeQuery();
                
                if (seekerRs.next()) {
                    String dbPassword = seekerRs.getString("seekerPassword");
                    String testPassword = MD5.getMd5("hello");
                    out.println("<p><strong>Seeker Test:</strong></p>");
                    out.println("<p>Username: johndoe - Found ✓</p>");
                    out.println("<p>DB Password: " + dbPassword + "</p>");
                    out.println("<p>Test Password (MD5 of 'hello'): " + testPassword + "</p>");
                    out.println("<p>Match: " + (dbPassword.equals(testPassword) ? "✓ YES" : "✗ NO") + "</p>");
                } else {
                    out.println("<p style='color: red;'>✗ Seeker 'johndoe' not found</p>");
                }
                seekerRs.close();
                seekerStmt.close();
                
                out.println("<hr>");
                
                // Test company login
                String companyQuery = "SELECT * FROM company WHERE companyUsername = ?";
                PreparedStatement companyStmt = connection.prepareStatement(companyQuery);
                companyStmt.setString(1, "techcorp");
                ResultSet companyRs = companyStmt.executeQuery();
                
                if (companyRs.next()) {
                    String dbPassword = companyRs.getString("companyPassword");
                    String testPassword = MD5.getMd5("hello");
                    out.println("<p><strong>Company Test:</strong></p>");
                    out.println("<p>Username: techcorp - Found ✓</p>");
                    out.println("<p>DB Password: " + dbPassword + "</p>");
                    out.println("<p>Test Password (MD5 of 'hello'): " + testPassword + "</p>");
                    out.println("<p>Match: " + (dbPassword.equals(testPassword) ? "✓ YES" : "✗ NO") + "</p>");
                } else {
                    out.println("<p style='color: red;'>✗ Company 'techcorp' not found</p>");
                }
                companyRs.close();
                companyStmt.close();
                
                out.println("<hr>");
                
                // Test admin login
                String adminQuery = "SELECT * FROM admin WHERE adUsername = ?";
                PreparedStatement adminStmt = connection.prepareStatement(adminQuery);
                adminStmt.setString(1, "admin");
                ResultSet adminRs = adminStmt.executeQuery();
                
                if (adminRs.next()) {
                    String dbPassword = adminRs.getString("adPassword");
                    String testPassword = MD5.getMd5("admin");
                    out.println("<p><strong>Admin Test:</strong></p>");
                    out.println("<p>Username: admin - Found ✓</p>");
                    out.println("<p>DB Password: " + dbPassword + "</p>");
                    out.println("<p>Test Password (MD5 of 'admin'): " + testPassword + "</p>");
                    out.println("<p>Match: " + (dbPassword.equals(testPassword) ? "✓ YES" : "✗ NO") + "</p>");
                } else {
                    out.println("<p style='color: red;'>✗ Admin 'admin' not found</p>");
                }
                adminRs.close();
                adminStmt.close();
                
            } else {
                out.println("<p style='color: red;'>✗ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>✗ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    out.println("<p style='color: red;'>Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
    
    <p><a href="seekerLogin.jsp">Test Seeker Login</a> | <a href="companyLogin.jsp">Test Company Login</a> | <a href="adminLogin.jsp">Test Admin Login</a></p>
</body>
</html>