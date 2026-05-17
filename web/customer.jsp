<%@ include file="sessionCheck.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%
    List<String> lines = (List<String>) request.getAttribute("customers");
    List<String[]> customers = new ArrayList<>();
    if (lines != null)
        for (String line : lines)
            if (!line.trim().isEmpty()) customers.add(line.split(","));

    String error        = (String) request.getAttribute("error");
    String[] searchResult = (String[]) request.getAttribute("searchResult");
    String searchMsg    = (String) request.getAttribute("searchMsg");
    String searchId     = (String) request.getAttribute("searchId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Customers - PhotoStudio</title>
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
.title{font-family:'Playfair Display',serif;font-size:2.5rem;color:var(--accent);margin-bottom:2rem;}
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
.error-box{background:rgba(224,92,92,0.15);border:1px solid var(--danger);color:var(--danger);padding:1rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result{background:rgba(201,169,110,0.1);border:1px solid var(--accent);padding:1.5rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result h4{color:var(--accent);margin-bottom:0.5rem;}
.row{display:flex;gap:1rem;align-items:flex-end;margin-top:1rem;}
.row input{flex:1;}
.empty{text-align:center;padding:2rem;color:var(--muted);}
.count{color:var(--muted);font-size:0.85rem;margin-bottom:1rem;}
</style>
</head>
<body>
<header>
    <a href="index.jsp" class="logo">📷 PhotoStudio</a>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="CustomerServlet" class="active">Customers</a>
        <a href="BookingServlet">Bookings</a>
        <a href="PaymentServlet">Payments</a>
        <a href="FeedbackServlet">Feedback</a>
        <a href="StaffServlet">Staff</a>
        <a href="PackageServlet">Packages</a>
        <a href="LoginServlet?action=logout">Logout (<%= loggedInUser %>)</a>
    </nav>
</header>
<div class="container">
<h1 class="title">Customers</h1>

<%-- ERROR --%>
<% if (error != null && !error.isEmpty()) { %>
<div class="error-box">⚠ <%= error %></div>
<% } %>

<%-- SEARCH RESULT --%>
<% if (searchResult != null && "success".equals(searchMsg)) { %>
<div class="search-result">
    <h4>🔍 Customer Found</h4>
    <p><strong>ID:</strong> <%= searchResult.length > 0 ? searchResult[0] : "-" %></p>
    <p><strong>Name:</strong> <%= searchResult.length > 1 ? searchResult[1] : "-" %></p>
    <p><strong>Email:</strong> <%= searchResult.length > 2 ? searchResult[2] : "-" %></p>
</div>
<% } else if (searchMsg != null && !"success".equals(searchMsg)) { %>
<div class="error-box">🔍 <%= searchMsg %></div>
<% } %>

<%-- SEARCH FORM --%>
<div class="card">
    <strong style="color:var(--accent)">Search Customer by ID</strong>
    <form action="CustomerServlet" method="post">
        <input type="hidden" name="action" value="search">
        <div class="row">
            <input type="text" name="searchId" placeholder="e.g. C001"
                   value="<%= searchId != null ? searchId : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </div>
    </form>
</div>

<%-- ADD FORM --%>
<div class="card">
    <strong style="color:var(--accent)">Add New Customer</strong>
    <form action="CustomerServlet" method="post">
        <input type="hidden" name="action" value="add">
        <label>Customer ID</label>
        <input type="text" name="id" required>
        <label>Full Name</label>
        <input type="text" name="name" required>
        <label>Email Address</label>
        <input type="email" name="email" required>
        <button class="btn">Add Customer</button>
    </form>
</div>

<%-- TABLE --%>
<div class="card">
    <p class="count"><%= customers.size() %> customer(s)</p>
    <% if (customers.isEmpty()) { %>
    <div class="empty">No customers yet.</div>
    <% } else { %>
    <table>
        <tr><th>ID</th><th>Name</th><th>Email</th><th>Action</th></tr>
        <% for (String[] c : customers) { %>
        <tr>
            <td><%= c.length > 0 ? c[0] : "-" %></td>
            <td><%= c.length > 1 ? c[1] : "-" %></td>
            <td><%= c.length > 2 ? c[2] : "-" %></td>
            <td>
                <form action="CustomerServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= c[0] %>">
                    <button class="deleteBtn" onclick="return confirm('Delete this customer?')">Delete</button>
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
