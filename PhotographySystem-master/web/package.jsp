<%@ include file="sessionCheck.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ page import="service.PackageService" %>
<%
    List<String> lines = (List<String>) request.getAttribute("packages");
    List<String[]> packages = new ArrayList<>();
    if (lines != null) {
        for (String line : lines)
            if (!line.trim().isEmpty()) packages.add(line.split(",", 5));
    }

    PackageService service  = (PackageService) request.getAttribute("service");
    String   error          = (String)   request.getAttribute("error");
    String[] searchResult   = (String[]) request.getAttribute("searchResult");
    String   searchMsg      = (String)   request.getAttribute("searchMsg");
    String   searchId       = (String)   request.getAttribute("searchId");
    String[] editTarget     = (String[]) request.getAttribute("editTarget");
    String   suggestedId    = (String)   request.getAttribute("suggestedId");

    Integer totalPackages   = (Integer) request.getAttribute("totalPackages");
    Double  totalValue      = (Double)  request.getAttribute("totalValue");
    Integer discountedCount = (Integer) request.getAttribute("discountedCount");
    String  mostExpensive   = (String)  request.getAttribute("mostExpensive");

    if (totalPackages   == null) totalPackages   = 0;
    if (totalValue      == null) totalValue      = 0.0;
    if (discountedCount == null) discountedCount = 0;
    if (mostExpensive   == null) mostExpensive   = "-";
    if (suggestedId     == null) suggestedId     = "PKG-001";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Packages - PhotoStudio</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0a0a0a;--card:#141414;--accent:#c9a96e;--accent2:#e8c99a;--text:#f0ece4;--muted:#7a7570;--border:#2a2520;--danger:#e05c5c;--green:#4caf7d;--blue:#5b9bd5;}
*{margin:0;padding:0;box-sizing:border-box;}
body{background:var(--bg);font-family:'DM Sans',sans-serif;color:var(--text);}
header{background:var(--card);padding:1.2rem 2rem;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border);}
.logo{font-family:'Playfair Display',serif;color:var(--accent);font-size:1.5rem;text-decoration:none;}
nav a{color:var(--muted);margin-left:1.5rem;text-decoration:none;font-size:0.85rem;}
nav a:hover,nav a.active{color:var(--accent);}
.container{max-width:1050px;margin:3rem auto;padding:0 2rem;}
.title{font-family:'Playfair Display',serif;font-size:2.5rem;color:var(--accent);margin-bottom:2rem;}
.card{background:var(--card);border:1px solid var(--border);padding:2rem;border-radius:12px;margin-bottom:2rem;}
.card-title{font-family:'Playfair Display',serif;font-size:1.1rem;color:var(--accent);margin-bottom:1.2rem;}

/* Stats */
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:2rem;}
.stat-card{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1.4rem;text-align:center;}
.stat-value{font-family:'Playfair Display',serif;font-size:1.6rem;color:var(--green);}
.stat-value.gold{color:var(--accent);}
.stat-value.blue{color:var(--blue);}
.stat-value.sm{font-size:1.1rem;}
.stat-label{color:var(--muted);font-size:0.7rem;text-transform:uppercase;letter-spacing:.05em;margin-top:0.3rem;}

/* Form */
label{display:block;font-size:0.72rem;color:var(--muted);margin-bottom:0.4rem;text-transform:uppercase;letter-spacing:.05em;}
input,textarea,select{width:100%;padding:0.8rem;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:6px;font-family:'DM Sans',sans-serif;outline:none;margin-bottom:1rem;}
input:focus,textarea:focus{border-color:var(--accent);}
textarea{resize:vertical;min-height:80px;}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:1rem;}
.form-row-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem;}
.btn{background:var(--accent);border:none;padding:0.8rem 1.8rem;cursor:pointer;font-weight:500;border-radius:6px;font-family:'DM Sans',sans-serif;color:#000;font-size:0.9rem;}
.btn:hover{background:var(--accent2);}
.btn-edit{background:var(--blue);border:none;color:white;padding:0.4rem 0.9rem;cursor:pointer;border-radius:4px;font-family:'DM Sans',sans-serif;font-size:0.8rem;}
.btn-delete{background:var(--danger);border:none;color:white;padding:0.4rem 0.8rem;cursor:pointer;border-radius:4px;font-family:'DM Sans',sans-serif;font-size:0.8rem;}
.btn-search{background:rgba(201,169,110,0.15);color:var(--accent);border:1px solid var(--accent);padding:0.75rem 1.2rem;border-radius:6px;cursor:pointer;font-family:'DM Sans',sans-serif;}

/* Alerts */
.error-box{background:rgba(224,92,92,0.12);border:1px solid var(--danger);color:var(--danger);padding:1rem 1.2rem;border-radius:8px;margin-bottom:1.5rem;}
.editing-banner{background:rgba(91,155,213,0.1);border:1px solid var(--blue);color:var(--blue);padding:0.8rem 1.2rem;border-radius:8px;margin-bottom:1.2rem;display:flex;justify-content:space-between;align-items:center;font-size:0.85rem;}
.cancel-link{color:var(--muted);text-decoration:none;font-size:0.8rem;}
.cancel-link:hover{color:var(--danger);}

/* Search result */
.search-result{background:rgba(201,169,110,0.08);border:1px solid var(--accent);border-radius:10px;padding:1.5rem;margin-bottom:1.5rem;display:flex;gap:1.5rem;align-items:flex-start;}
.search-result img{width:100px;height:80px;object-fit:cover;border-radius:8px;border:1px solid var(--border);}
.search-result h4{color:var(--accent);margin-bottom:0.5rem;font-family:'Playfair Display',serif;}

/* Package cards grid */
.pkg-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
    gap:1.5rem;
}
.pkg-card{
    background:#1a1a1a;
    border:1px solid var(--border);
    border-radius:12px;
    overflow:hidden;
    transition:border-color .2s;
}
.pkg-card:hover{border-color:var(--accent);}
.pkg-card img{
    width:100%;
    height:400px;
    object-fit:cover;
    display:block;
}
.pkg-card-body{padding:1.2rem;}
.pkg-card-id{font-size:0.7rem;color:var(--muted);text-transform:uppercase;letter-spacing:.05em;}
.pkg-card-name{font-family:'Playfair Display',serif;font-size:1.1rem;color:var(--accent);margin:.3rem 0 .5rem;}
.pkg-card-desc{
    font-size:0.82rem;
    color:var(--muted);
    line-height:1.5;
    margin-bottom:.8rem;
}
.pkg-card-price{font-size:1rem;color:var(--green);font-weight:500;}
.pkg-card-discounted{font-size:0.8rem;color:var(--accent);margin-left:6px;}
.badge-discount{background:rgba(76,175,125,0.15);color:var(--green);font-size:0.68rem;padding:2px 8px;border-radius:10px;margin-left:6px;}
.pkg-card-actions{display:flex;gap:6px;margin-top:.9rem;}

/* Image preview */
.img-preview{width:100%;max-height:140px;object-fit:cover;border-radius:6px;margin-bottom:0.8rem;border:1px solid var(--border);display:none;}
.image-options{display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:0.8rem;}
.img-opt-btn{background:rgba(201,169,110,0.1);border:1px solid var(--border);color:var(--muted);padding:0.4rem 0.7rem;border-radius:6px;cursor:pointer;font-size:0.75rem;font-family:'DM Sans',sans-serif;}
.img-opt-btn:hover{border-color:var(--accent);color:var(--accent);}

.empty{text-align:center;padding:3rem;color:var(--muted);}
.search-row{display:flex;gap:1rem;align-items:flex-end;}
.search-row input{flex:1;margin-bottom:0;}
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
        <a href="StaffServlet">Staff</a>
        <a href="PackageServlet" class="active">Packages</a>
        <a href="LogoutServlet" style="color:var(--danger);">Logout (<%= loggedInUser %>)</a>
    </nav>
</header>

<div class="container">
<h1 class="title">Packages</h1>

<%-- ERROR --%>
<% if (error != null && !error.isEmpty()) { %>
<div class="error-box">⚠ <%= error %></div>
<% } %>

<%-- STATS --%>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-value blue"><%= totalPackages %></div>
        <div class="stat-label">Total Packages</div>
    </div>
    <div class="stat-card">
        <div class="stat-value gold">Rs. <%= String.format("%.2f", totalValue) %></div>
        <div class="stat-label">Portfolio Value</div>
    </div>
    <div class="stat-card">
        <div class="stat-value"><%= discountedCount %></div>
        <div class="stat-label">With 15% Discount</div>
    </div>
    <div class="stat-card">
        <div class="stat-value sm gold"><%= mostExpensive %></div>
        <div class="stat-label">Most Expensive</div>
    </div>
</div>

<%-- SEARCH --%>
<div class="card">
    <p class="card-title">🔍 Search Package</p>
    <form action="PackageServlet" method="post">
        <input type="hidden" name="action" value="search">
        <div class="search-row">
            <input type="text" name="searchId" placeholder="Enter Package ID e.g. PKG-001"
                   value="<%= searchId != null ? searchId : "" %>">
            <button type="submit" class="btn-search">Search</button>
        </div>
    </form>

    <%-- Search Result --%>
    <% if (searchResult != null && "success".equals(searchMsg)) {
        double sp = 0;
        try { sp = Double.parseDouble(searchResult.length > 2 ? searchResult[2].trim() : "0"); } catch(Exception e){}
        String sImg  = searchResult.length > 4 ? searchResult[4] : "images/packages/default.jpg";
        String sDesc = searchResult.length > 3 ? searchResult[3].replace(";", ",") : "-";
    %>
    <div class="search-result" style="margin-top:1.2rem;">
        <img src="<%= sImg %>" alt="package image"
             onerror="this.src='https://via.placeholder.com/100x80?text=No+Image'">
        <div>
            <h4><%= searchResult.length > 1 ? searchResult[1] : "-" %></h4>
            <p style="font-size:0.8rem;color:var(--muted);margin-bottom:0.4rem;">ID: <%= searchResult[0] %></p>
            <p style="font-size:0.85rem;color:var(--text);margin-bottom:0.5rem;"><%= sDesc %></p>
            <p>
                <span style="color:var(--green);font-weight:500;">Rs. <%= String.format("%.2f", sp) %></span>
                <% if (service != null && service.hasDiscount(sp)) { %>
                → <span style="color:var(--accent);">Rs. <%= String.format("%.2f", service.getDiscountedPrice(sp)) %></span>
                <span class="badge-discount">15% OFF</span>
                <% } %>
            </p>
        </div>
    </div>
    <% } else if (searchMsg != null && !"success".equals(searchMsg)) { %>
    <p style="color:var(--danger);margin-top:1rem;font-size:0.85rem;">⚠ <%= searchMsg %></p>
    <% } %>
</div>

<%-- ADD / EDIT FORM --%>
<div class="card">
    <% if (editTarget != null) { %>
    <div class="editing-banner">
        ✏️ Editing package <strong><%= editTarget[0] %></strong>
        <a href="PackageServlet" class="cancel-link">✕ Cancel</a>
    </div>
    <p class="card-title">Edit Package</p>
    <form action="PackageServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="originalId" value="<%= editTarget[0] %>">
        <div class="form-row-3">
            <div>
                <label>Package ID</label>
                <input type="text" name="id" value="<%= editTarget[0] %>" required>
            </div>
            <div>
                <label>Package Name</label>
                <input type="text" name="name" value="<%= editTarget.length > 1 ? editTarget[1] : "" %>" required>
            </div>
            <div>
                <label>Price (Rs.) — Over Rs. 5000 gets 15% OFF</label>
                <input type="number" name="price" min="1" step="0.01"
                       value="<%= editTarget.length > 2 ? editTarget[2].trim() : "" %>" required>
            </div>
        </div>
        <label>Description (what's included)</label>
        <textarea name="description"><%= editTarget.length > 3 ? editTarget[3].replace(";", ",") : "" %></textarea>
        <label>Image Path (from web root, e.g. images/packages/wedding.jpg)</label>
        <img id="editPreview" class="img-preview"
             src="<%= editTarget.length > 4 ? editTarget[4] : "" %>"
             onerror="this.style.display='none'">
        <input type="text" name="imagePath" id="editImagePath"
               value="<%= editTarget.length > 4 ? editTarget[4] : "" %>"
               placeholder="images/packages/wedding.jpg"
               oninput="previewImage(this.value,'editPreview')">
        <div class="image-options">
            <span style="font-size:0.72rem;color:var(--muted);align-self:center;">Quick pick:</span>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/wedding.jpg')">Wedding</button>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/portrait.jpg')">Portrait</button>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/event.jpg')">Event</button>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/family.jpg')">Family</button>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/corporate.jpg')">Corporate</button>
            <button type="button" class="img-opt-btn" onclick="setImage('editImagePath','editPreview','images/packages/newborn.jpg')">Newborn</button>
        </div>
        <button class="btn" type="submit">Update Package</button>
    </form>

    <% } else { %>
    <p class="card-title">Add New Package</p>
    <p style="font-size:0.8rem;color:var(--muted);margin-bottom:1.2rem;">
        Suggested next ID: <strong style="color:var(--accent);"><%= suggestedId %></strong>
    </p>
    <form action="PackageServlet" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-row-3">
            <div>
                <label>Package ID</label>
                <input type="text" name="id" placeholder="<%= suggestedId %>" required>
            </div>
            <div>
                <label>Package Name</label>
                <input type="text" name="name" placeholder="e.g. Wedding Premium" required>
            </div>
            <div>
                <label>Price (Rs.) — Over Rs. 5000 gets 15% OFF</label>
                <input type="number" name="price" min="1" step="0.01" placeholder="0.00" required>
            </div>
        </div>
        <label>Description (what's included)</label>
        <textarea name="description" placeholder="e.g. 4 hours coverage, 2 photographers, 100 edited photos, online gallery, printed album"></textarea>
        <label>Image Path (from web root)</label>
        <img id="addPreview" class="img-preview" src="" onerror="this.style.display='none'">
        <input type="text" name="imagePath" id="addImagePath"
               placeholder="images/packages/wedding.jpg"
               oninput="previewImage(this.value,'addPreview')">
        <div class="image-options">
            <span style="font-size:0.72rem;color:var(--muted);align-self:center;">Quick pick:</span>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/wedding.jpg')">Wedding</button>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/portrait.jpg')">Portrait</button>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/event.jpg')">Event</button>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/family.jpg')">Family</button>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/corporate.jpg')">Corporate</button>
            <button type="button" class="img-opt-btn" onclick="setImage('addImagePath','addPreview','images/packages/newborn.jpg')">Newborn</button>
        </div>
        <button class="btn" type="submit">Add Package</button>
    </form>
    <% } %>
</div>

<%-- PACKAGES CARD GRID --%>
<div class="card">
    <p class="card-title"><%= totalPackages %> Package(s) Available</p>
    <% if (packages.isEmpty()) { %>
    <div class="empty">No packages yet. Add your first package above.</div>
    <% } else { %>
    <div class="pkg-grid">
        <% for (String[] p : packages) {
            double price = 0;
            try { price = Double.parseDouble(p.length > 2 ? p[2].trim() : "0"); } catch(Exception e){}
            double discounted = service != null ? service.getDiscountedPrice(price) : price;
            boolean hasDisc   = service != null && service.hasDiscount(price);
            String  imgPath   = p.length > 4 ? p[4].trim() : "images/packages/default.jpg";
            String  desc      = p.length > 3 ? p[3].replace(";", ",") : "No description";
        %>
        <div class="pkg-card">
            <img src="<%= imgPath %>" alt="<%= p.length > 1 ? p[1] : "package" %>"
                 onerror="this.src='https://via.placeholder.com/280x160?text=No+Image'">
            <div class="pkg-card-body">
                <p class="pkg-card-id"><%= p.length > 0 ? p[0] : "-" %></p>
                <p class="pkg-card-name"><%= p.length > 1 ? p[1] : "-" %></p>
                <p class="pkg-card-desc"><%= desc %></p>
                <p class="pkg-card-price">
                    Rs. <%= String.format("%.2f", price) %>
                    <% if (hasDisc) { %>
                    <span class="pkg-card-discounted">→ Rs. <%= String.format("%.2f", discounted) %></span>
                    <span class="badge-discount">15% OFF</span>
                    <% } %>
                </p>
                <div class="pkg-card-actions">
                    <form action="PackageServlet" method="get" style="display:inline;">
                        <input type="hidden" name="editId" value="<%= p[0] %>">
                        <button class="btn-edit" type="submit">Edit</button>
                    </form>
                    <form action="PackageServlet" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= p[0] %>">
                        <button class="btn-delete" type="submit"
                                onclick="return confirm('Delete package <%= p.length > 1 ? p[1] : p[0] %>?')">Delete</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</div>

<script>
function previewImage(path, previewId) {
    var img = document.getElementById(previewId);
    if (path.trim() === '') { img.style.display = 'none'; return; }
    img.src = path;
    img.style.display = 'block';
    img.onerror = function() { this.style.display = 'none'; };
}

function setImage(inputId, previewId, path) {
    document.getElementById(inputId).value = path;
    previewImage(path, previewId);
}

window.onload = function() {
    var editImg = document.getElementById('editPreview');
    if (editImg && editImg.src && editImg.src !== window.location.href) {
        editImg.style.display = 'block';
    }
};
</script>
</body>
</html>
