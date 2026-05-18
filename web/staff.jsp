<%@ include file="sessionCheck.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%
    List<String> lines = (List<String>) request.getAttribute("staffList");
    List<String[]> staffList = new ArrayList<>();
    if (lines != null)
        for (String line : lines)
            if (!line.trim().isEmpty()) staffList.add(line.split(","));

    String error          = (String) request.getAttribute("error");
    String[] searchResult = (String[]) request.getAttribute("searchResult");
    String searchMsg      = (String) request.getAttribute("searchMsg");
    String searchId       = (String) request.getAttribute("searchId");
    Integer photographerCount = (Integer) request.getAttribute("photographerCount");
    Integer totalStaff        = (Integer) request.getAttribute("totalStaff");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Staff - PhotoStudio</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0a0a0a;--card:#141414;--accent:#c9a96e;--accent2:#e8c99a;--text:#f0ece4;--muted:#7a7570;--border:#2a2520;--danger:#e05c5c;--green:#4caf7d;}
*{margin:0;padding:0;box-sizing:border-box;}
body{background:var(--bg);font-family:'DM Sans',sans-serif;color:var(--text);}
header{background:var(--card);padding:1.2rem 2rem;display:flex;justify-content:space-between;border-bottom:1px solid var(--border);}
.logo{font-family:'Playfair Display',serif;color:var(--accent);font-size:1.5rem;text-decoration:none;}
nav a{color:var(--muted);margin-left:1.5rem;text-decoration:none;font-size:0.85rem;}
nav a:hover,nav a.active{color:var(--accent);}
.container{max-width:950px;margin:3rem auto;padding:0 2rem;}
.title{font-family:'Playfair Display',serif;font-size:2.5rem;color:var(--accent);margin-bottom:1rem;}
.card{background:var(--card);border:1px solid var(--border);padding:2rem;border-radius:12px;margin-bottom:2rem;}
label{display:block;font-size:0.75rem;color:var(--muted);margin-bottom:0.5rem;text-transform:uppercase;margin-top:1rem;}
input{width:100%;padding:0.8rem;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:6px;font-family:'DM Sans',sans-serif;outline:none;}
input:focus{border-color:var(--accent);}
.btn{margin-top:1rem;background:var(--accent);border:none;padding:0.8rem 1.5rem;cursor:pointer;font-weight:500;border-radius:6px;font-family:'DM Sans',sans-serif;}
.btn:hover{background:var(--accent2);}
.btn-search{background:rgba(201,169,110,0.2);color:var(--accent);border:1px solid var(--accent);padding:0.7rem 1.2rem;border-radius:6px;cursor:pointer;font-family:'DM Sans',sans-serif;}
table{width:100%;border-collapse:collapse;}
th,td{padding:1rem;border-bottom:1px solid var(--border);text-align:left;}
th{color:var(--muted);font-size:0.75rem;text-transform:uppercase;}
tr:hover td{background:rgba(201,169,110,0.04);}
.deleteBtn{background:var(--danger);border:none;padding:0.4rem 0.8rem;color:white;border-radius:5px;cursor:pointer;font-family:'DM Sans',sans-serif;}
.role-badge{display:inline-block;padding:0.2rem 0.7rem;border-radius:20px;font-size:0.75rem;background:rgba(201,169,110,0.15);color:var(--accent);}
.error-box{background:rgba(224,92,92,0.15);border:1px solid var(--danger);color:var(--danger);padding:1rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result{background:rgba(201,169,110,0.1);border:1px solid var(--accent);padding:1.5rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result h4{color:var(--accent);margin-bottom:0.5rem;}
.row{display:flex;gap:1rem;align-items:flex-end;margin-top:1rem;}
.row input{flex:1;}
.stats-grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:2rem;}
.stat-card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1.2rem;text-align:center;}
.stat-value{font-family:'Playfair Display',serif;font-size:2rem;color:var(--accent);}
.stat-label{color:var(--muted);font-size:0.75rem;text-transform:uppercase;margin-top:0.3rem;}
.empty{text-align:center;padding:2rem;color:var(--muted);}
</style>
</head>
<body>
<header>
    <a href="index.jsp" class="logo">📷 PhotoStudio</a>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="CustomerServlet">Customers</a>
        <a href="BookingServlet">Bookings</a>
        <a href="PaymentServlet">Payments</a>
        <a href="FeedbackServlet">Feedback</a>
        <a href="StaffServlet" class="active">Staff</a>
        <a href="PackageServlet">Packages</a>
        <a href="LoginServlet?action=logout">Logout (<%= loggedInUser %>)</a>
    </nav>
</header>
<div class="container">
<h1 class="title">Staff</h1>

<%-- STATS --%>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-value"><%= totalStaff != null ? totalStaff : 0 %></div>
        <div class="stat-label">Total Staff</div>
    </div>
    <div class="stat-card">
        <div class="stat-value"><%= photographerCount != null ? photographerCount : 0 %></div>
        <div class="stat-label">Photographers</div>
    </div>
</div>

<%-- ERROR --%>
<% if (error != null && !error.isEmpty()) { %>
<div class="error-box">⚠ <%= error %></div>
<% } %>

<%-- SEARCH RESULT --%>
<% if (searchResult != null && "success".equals(searchMsg)) { %>
<div class="search-result">
    <h4>🔍 Staff Found</h4>
    <p><strong>ID:</strong> <%= searchResult.length > 0 ? searchResult[0] : "-" %></p>
    <p><strong>Name:</strong> <%= searchResult.length > 1 ? searchResult[1] : "-" %></p>
    <p><strong>Role:</strong> <%= searchResult.length > 2 ? searchResult[2] : "-" %></p>
</div>
<% } else if (searchMsg != null && !"success".equals(searchMsg)) { %>
<div class="error-box">🔍 <%= searchMsg %></div>
<% } %>

<%-- SEARCH FORM --%>
<div class="card">
    <strong style="color:var(--accent)">Search Staff by ID</strong>
    <form action="StaffServlet" method="post">
        <input type="hidden" name="action" value="search">
        <div class="row">
            <input type="text" name="searchId" placeholder="e.g. S001"
                   value="<%= searchId != null ? searchId : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </div>
    </form>
</div>

<%-- ADD FORM --%>
<div class="card">
    <strong style="color:var(--accent)">Add Staff Member</strong>
    <form action="StaffServlet" method="post">
        <input type="hidden" name="action" value="add">
        <label>Staff ID</label>
        <input type="text" name="id" required>
        <label>Full Name</label>
        <input type="text" name="name" required>
        <label>Role (e.g. Photographer, Editor, Manager)</label>
        <input type="text" name="role" required>
        <button class="btn">Add Staff</button>
    </form>
</div>

<%-- TABLE --%>
<div class="card">
    <% if (staffList.isEmpty()) { %>
    <div class="empty">No staff added yet.</div>
    <% } else { %>
    <table>
        <tr><th>ID</th><th>Name</th><th>Role</th><th>Action</th></tr>
        <% for (String[] s : staffList) { %>
        <tr>
            <td><%= s.length > 0 ? s[0] : "-" %></td>
            <td><%= s.length > 1 ? s[1] : "-" %></td>
            <td><span class="role-badge"><%= s.length > 2 ? s[2] : "-" %></span></td>
            <td>
                <form action="StaffServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= s[0] %>">
                    <button class="deleteBtn" onclick="return confirm('Delete this staff member?')">Delete</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>
</div>
</div>
</body>
</html>
