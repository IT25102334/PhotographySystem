<%@ include file="sessionCheck.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%
    List<String> lines = (List<String>) request.getAttribute("feedbacks");
    List<String[]> feedbacks = new ArrayList<>();
    if (lines != null)
        for (String line : lines)
            if (!line.trim().isEmpty()) feedbacks.add(line.split(","));

    Double avgRating      = (Double)  request.getAttribute("avgRating");
    Integer positiveCount = (Integer) request.getAttribute("positiveCount");
    Integer negativeCount = (Integer) request.getAttribute("negativeCount");
    Integer totalFeedbacks= (Integer) request.getAttribute("totalFeedbacks");

    if (avgRating      == null) avgRating      = 0.0;
    if (positiveCount  == null) positiveCount  = 0;
    if (negativeCount  == null) negativeCount  = 0;
    if (totalFeedbacks == null) totalFeedbacks = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Feedback - PhotoStudio</title>
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
table{width:100%;border-collapse:collapse;}
th,td{padding:1rem;border-bottom:1px solid var(--border);text-align:left;}
th{color:var(--muted);font-size:0.75rem;text-transform:uppercase;}
tr:hover td{background:rgba(201,169,110,0.04);}
.deleteBtn{background:var(--danger);border:none;padding:0.4rem 0.8rem;color:white;border-radius:5px;cursor:pointer;font-family:'DM Sans',sans-serif;}
.deleteBtn:hover{opacity:0.8;}
.stars{color:var(--accent);}

.stats-grid{display:grid;grid-template-columns:1fr 1fr 1fr 1fr;gap:1rem;margin-bottom:2rem;}
.stat-card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1.2rem;text-align:center;}
.stat-value{font-family:'Playfair Display',serif;font-size:2rem;color:var(--accent);}
.stat-value.green{color:var(--green);}
.stat-value.red{color:var(--danger);}
.stat-label{color:var(--muted);font-size:0.72rem;text-transform:uppercase;margin-top:0.3rem;}

.empty{text-align:center;padding:2rem;color:var(--muted);}
.count{color:var(--muted);font-size:0.85rem;margin-bottom:1rem;}
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
        <a href="FeedbackServlet" class="active">Feedback</a>
        <a href="StaffServlet">Staff</a>
        <a href="PackageServlet">Packages</a>
        <a href="LoginServlet?action=logout">Logout (<%= loggedInUser %>)</a>
    </nav>
</header>

<div class="container">
<h1 class="title">Feedback</h1>

<%--ANALYTICS STATS - calculated by FeedbackService --%>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-value"><%= totalFeedbacks %></div>
        <div class="stat-label">Total Reviews</div>
    </div>
    <div class="stat-card">
        <div class="stat-value"><%= avgRating %> ★</div>
        <div class="stat-label">Average Rating</div>
    </div>
    <div class="stat-card">
        <div class="stat-value green"><%= positiveCount %></div>
        <div class="stat-label">Positive (4★ - 5★)</div>
    </div>
    <div class="stat-card">
        <div class="stat-value red"><%= negativeCount %></div>
        <div class="stat-label">Negative (1★ - 2★)</div>
    </div>
</div>

<%-- ADD FORM --%>
<div class="card">
    <strong style="color:var(--accent)">Add Feedback</strong>
    <form action="FeedbackServlet" method="post">
        <input type="hidden" name="action" value="add">
        <label>Customer Name</label>
        <input type="text" name="customerName" required>
        <label>Message</label>
        <input type="text" name="message" required>
        <label>Rating (1 - 5)</label>
        <input type="number" name="rating" min="1" max="5" required>
        <button class="btn">Submit Feedback</button>
    </form>
</div>

<%-- TABLE --%>
<div class="card">
    <p class="count"><%= feedbacks.size() %> review(s)</p>
    <% if (feedbacks.isEmpty()) { %>
    <div class="empty">No feedback yet.</div>
    <% } else { %>
    <table>
        <tr>
            <th>Customer</th>
            <th>Message</th>
            <th>Rating</th>
            <th>Action</th>
        </tr>
        <%
        for (String[] f : feedbacks) {
            int stars = 0;
            try { stars = Integer.parseInt(f.length > 2 ? f[2].trim() : "0"); } catch(Exception e){}
            StringBuilder starStr = new StringBuilder();
            for (int i = 0; i < stars; i++) starStr.append("★");
            for (int i = stars; i < 5; i++) starStr.append("☆");
        %>
        <tr>
            <td><%= f.length > 0 ? f[0] : "-" %></td>
            <td><%= f.length > 1 ? f[1] : "-" %></td>
            <td><span class="stars"><%= starStr %></span></td>
            <td>
                <form action="FeedbackServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="customerName" value="<%= f.length > 0 ? f[0] : "" %>">
                    <button class="deleteBtn"
                            onclick="return confirm('Delete this feedback?')">Delete</button>
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
