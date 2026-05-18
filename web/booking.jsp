<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="sessionCheck.jsp" %>
<%
    List<String> lines = (List<String>) request.getAttribute("bookings");
    List<String[]> bookings = new ArrayList<>();
    if (lines != null)
        for (String line : lines)
            if (!line.trim().isEmpty()) bookings.add(line.split(",", 4));


    List<String> pkgLines = (List<String>) request.getAttribute("packages");
    List<String[]> packages = new ArrayList<>();
    if (pkgLines != null)
        for (String line : pkgLines)
            if (!line.trim().isEmpty()) packages.add(line.split(",", 5));

    String   error        = (String)   request.getAttribute("error");
    String[] searchResult = (String[]) request.getAttribute("searchResult");
    String   searchMsg    = (String)   request.getAttribute("searchMsg");
    String   searchId     = (String)   request.getAttribute("searchId");
    Integer  totalBookings = (Integer) request.getAttribute("totalBookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Bookings - PhotoStudio</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0a0a0a;--card:#141414;--accent:#c9a96e;--accent2:#e8c99a;--text:#f0ece4;--muted:#7a7570;--border:#2a2520;--danger:#e05c5c;--green:#4caf7d;--blue:#5b9bd5;}
*{margin:0;padding:0;box-sizing:border-box;}
body{background:var(--bg);font-family:'DM Sans',sans-serif;color:var(--text);}
header{background:var(--card);padding:1.2rem 2rem;display:flex;justify-content:space-between;border-bottom:1px solid var(--border);}
.logo{font-family:'Playfair Display',serif;color:var(--accent);font-size:1.5rem;text-decoration:none;}
nav a{color:var(--muted);margin-left:1.5rem;text-decoration:none;font-size:0.85rem;}
nav a:hover,nav a.active{color:var(--accent);}
.container{max-width:950px;margin:3rem auto;padding:0 2rem;}
.title{font-family:'Playfair Display',serif;font-size:2.5rem;color:var(--accent);margin-bottom:2rem;}
.card{background:var(--card);border:1px solid var(--border);padding:2rem;border-radius:12px;margin-bottom:2rem;}
.card-title{font-family:'Playfair Display',serif;font-size:1.1rem;color:var(--accent);margin-bottom:1.2rem;}
label{display:block;font-size:0.75rem;color:var(--muted);margin-bottom:0.4rem;text-transform:uppercase;letter-spacing:.05em;}
input,select{width:100%;padding:0.8rem;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:6px;font-family:'DM Sans',sans-serif;outline:none;margin-bottom:1rem;}
input:focus,select:focus{border-color:var(--accent);}
select option{background:var(--card);}
.btn{background:var(--accent);border:none;padding:0.8rem 1.5rem;cursor:pointer;font-weight:500;border-radius:6px;font-family:'DM Sans',sans-serif;color:#000;}
.btn:hover{background:var(--accent2);}
.btn-search{background:rgba(201,169,110,0.2);color:var(--accent);border:1px solid var(--accent);padding:0.75rem 1.2rem;border-radius:6px;cursor:pointer;font-family:'DM Sans',sans-serif;}
.deleteBtn{background:var(--danger);border:none;padding:0.4rem 0.8rem;color:white;border-radius:5px;cursor:pointer;font-family:'DM Sans',sans-serif;font-size:0.8rem;}
table{width:100%;border-collapse:collapse;}
th,td{padding:0.9rem 1rem;border-bottom:1px solid var(--border);text-align:left;font-size:0.9rem;}
th{color:var(--muted);font-size:0.72rem;text-transform:uppercase;letter-spacing:.06em;}
tr:hover td{background:rgba(201,169,110,0.04);}
.error-box{background:rgba(224,92,92,0.15);border:1px solid var(--danger);color:var(--danger);padding:1rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result{background:rgba(201,169,110,0.08);border:1px solid var(--accent);padding:1.5rem;border-radius:8px;margin-bottom:1.5rem;}
.search-result h4{color:var(--accent);margin-bottom:0.8rem;font-family:'Playfair Display',serif;}
.search-result p{font-size:0.88rem;margin-bottom:0.3rem;color:var(--muted);}
.search-result p span{color:var(--text);}
.row{display:flex;gap:1rem;align-items:flex-end;}
.row input{flex:1;margin-bottom:0;}
.stat{display:inline-block;background:rgba(201,169,110,0.1);padding:0.3rem 1rem;border-radius:20px;color:var(--accent);font-size:0.85rem;margin-bottom:1.5rem;}
.empty{text-align:center;padding:2rem;color:var(--muted);}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}
.pkg-badge{background:rgba(91,155,213,0.15);color:var(--blue);font-size:0.75rem;padding:2px 8px;border-radius:10px;}
.pkg-preview{background:rgba(201,169,110,0.06);border:1px solid var(--border);border-radius:8px;padding:0.8rem 1rem;margin-bottom:1rem;font-size:0.82rem;display:none;}
.pkg-preview .pkg-name{color:var(--accent);font-weight:500;}
.pkg-preview .pkg-price{color:var(--green);}
.pkg-preview .pkg-desc{color:var(--muted);margin-top:0.2rem;}
</style>
</head>
<body>
<header>
    <a href="index.jsp" class="logo">📷 PhotoStudio</a>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="CustomerServlet">Customers</a>
        <a href="BookingServlet" class="active">Bookings</a>
        <a href="PaymentServlet">Payments</a>
        <a href="FeedbackServlet">Feedback</a>
        <a href="StaffServlet">Staff</a>
        <a href="PackageServlet">Packages</a>
        <a href="LoginServlet?action=logout" style="color:var(--danger);">Logout (<%= loggedInUser %>)</a>
    </nav>
</header>

<div class="container">
<h1 class="title">Bookings</h1>
<span class="stat">Total: <%= totalBookings != null ? totalBookings : 0 %> bookings</span>

<%-- ERROR --%>
<% if (error != null && !error.isEmpty()) { %>
<div class="error-box">⚠ <%= error %></div>
<% } %>

<%-- SEARCH RESULT --%>
<% if (searchResult != null && "success".equals(searchMsg)) { %>
<div class="search-result">
    <h4>🔍 Booking Found</h4>
    <p>Booking ID: <span><%= searchResult.length > 0 ? searchResult[0] : "-" %></span></p>
    <p>Customer ID: <span><%= searchResult.length > 1 ? searchResult[1] : "-" %></span></p>
    <p>Date: <span><%= searchResult.length > 2 ? searchResult[2] : "-" %></span></p>
    <p>Package: <span><%= searchResult.length > 3 ? searchResult[3] : "None" %></span></p>
</div>
<% } else if (searchMsg != null && !"success".equals(searchMsg)) { %>
<div class="error-box">🔍 <%= searchMsg %></div>
<% } %>

<%-- SEARCH FORM --%>
<div class="card">
    <p class="card-title">Search Booking</p>
    <form action="BookingServlet" method="post">
        <input type="hidden" name="action" value="search">
        <div class="row">
            <input type="text" name="searchId" placeholder="Enter Booking ID e.g. B001"
                   value="<%= searchId != null ? searchId : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </div>
    </form>
</div>

<%-- ADD FORM --%>
<div class="card">
    <p class="card-title">New Booking</p>
    <form action="BookingServlet" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-row">
            <div>
                <label>Booking ID</label>
                <input type="text" name="id" placeholder="e.g. B001" required>
            </div>
            <div>
                <label>Customer ID</label>
                <input type="text" name="customerId" placeholder="e.g. C001" required>
            </div>
        </div>
        <div class="form-row">
            <div>
                <label>Date — duplicate dates are rejected</label>
                <input type="date" name="date" required>
            </div>
            <div>
                <label>Select Package (optional)</label>
                <select name="packageId" id="packageSelect" onchange="showPackagePreview()">
                    <option value="None">-- No Package --</option>
                    <% for (String[] pkg : packages) {
                        String pkgId    = pkg.length > 0 ? pkg[0] : "";
                        String pkgName  = pkg.length > 1 ? pkg[1] : "";
                        String pkgPrice = pkg.length > 2 ? pkg[2] : "";
                        String pkgDesc  = pkg.length > 3 ? pkg[3].replace(";", ",") : "";
                    %>
                    <option value="<%= pkgId %>"
                            data-name="<%= pkgName %>"
                            data-price="<%= pkgPrice %>"
                            data-desc="<%= pkgDesc %>">
                        <%= pkgId %> — <%= pkgName %> ($<%= pkgPrice %>)
                    </option>
                    <% } %>
                </select>
                <%-- Live preview of selected package --%>
                <div class="pkg-preview" id="pkgPreview">
                    <p class="pkg-name" id="prevName"></p>
                    <p class="pkg-price" id="prevPrice"></p>
                    <p class="pkg-desc" id="prevDesc"></p>
                </div>
            </div>
        </div>
        <button class="btn" type="submit">Add Booking</button>
    </form>
</div>

<%-- TABLE --%>
<div class="card">
    <p class="card-title"><%= totalBookings != null ? totalBookings : 0 %> Booking(s)</p>
    <% if (bookings.isEmpty()) { %>
    <div class="empty">No bookings yet.</div>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Booking ID</th>
            <th>Customer ID</th>
            <th>Date</th>
            <th>Package</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% for (String[] b : bookings) { %>
        <tr>
            <td><%= b.length > 0 ? b[0] : "-" %></td>
            <td><%= b.length > 1 ? b[1] : "-" %></td>
            <td><%= b.length > 2 ? b[2] : "-" %></td>
            <td>
                <% String pkgId = b.length > 3 ? b[3] : "None"; %>
                <% if (!"None".equals(pkgId) && !pkgId.isEmpty()) { %>
                <span class="pkg-badge"><%= pkgId %></span>
                <% } else { %>
                <span style="color:var(--muted);font-size:0.8rem;">None</span>
                <% } %>
            </td>
            <td>
                <form action="BookingServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= b[0] %>">
                    <button class="deleteBtn"
                            onclick="return confirm('Delete booking <%= b[0] %>?')">Delete</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</div>

<script>
function showPackagePreview() {
    var select  = document.getElementById('packageSelect');
    var preview = document.getElementById('pkgPreview');
    var opt     = select.options[select.selectedIndex];

    if (select.value === 'None') {
        preview.style.display = 'none';
        return;
    }
    document.getElementById('prevName').textContent  = '📦 ' + opt.getAttribute('data-name');
    document.getElementById('prevPrice').textContent = '$' + opt.getAttribute('data-price');
    document.getElementById('prevDesc').textContent  = opt.getAttribute('data-desc') || 'No description';
    preview.style.display = 'block';
}
</script>
</body>
</html>
