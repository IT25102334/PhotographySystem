<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // If already logged in, skip login page
    HttpSession existingSession = request.getSession(false);
    if (existingSession != null && existingSession.getAttribute("loggedInUser") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String error          = (String) request.getAttribute("error");
    String success        = (String) request.getAttribute("success");
    String enteredUsername = (String) request.getAttribute("enteredUsername");
    Boolean showRegister  = (Boolean) request.getAttribute("showRegister");
    if (showRegister == null) showRegister = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - PhotoStudio</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0a0a0a;--card:#141414;--accent:#c9a96e;--accent2:#e8c99a;--text:#f0ece4;--muted:#7a7570;--border:#2a2520;--danger:#e05c5c;--green:#4caf7d;}
*{margin:0;padding:0;box-sizing:border-box;}
body{background:var(--bg);min-height:100vh;display:flex;font-family:'DM Sans',sans-serif;color:var(--text);}
.left-panel{flex:1;background:linear-gradient(135deg,#1a1208 0%,#0a0a0a 50%,#12100a 100%);display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;}
.left-panel::before{content:'';position:absolute;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,rgba(201,169,110,0.15) 0%,transparent 70%);top:50%;left:50%;transform:translate(-50%,-50%);}
.brand{text-align:center;z-index:1;}
.brand-icon{font-size:4rem;margin-bottom:1rem;display:block;}
.brand h1{font-family:'Playfair Display',serif;font-size:3rem;color:var(--accent);}
.brand p{color:var(--muted);font-size:0.9rem;letter-spacing:0.2em;text-transform:uppercase;margin-top:0.5rem;}
.brand-features{margin-top:2.5rem;text-align:left;display:inline-block;}
.brand-features p{color:var(--muted);font-size:0.82rem;margin-bottom:0.6rem;padding-left:1.2rem;position:relative;}
.brand-features p::before{content:'✓';position:absolute;left:0;color:var(--accent);}
.right-panel{width:500px;background:var(--card);display:flex;align-items:center;justify-content:center;padding:3rem;border-left:1px solid var(--border);}
.login-box{width:100%;}

/* Tabs */
.tabs{display:flex;gap:0;margin-bottom:2rem;border:1px solid var(--border);border-radius:8px;overflow:hidden;}
.tab-btn{flex:1;padding:0.75rem;background:transparent;border:none;color:var(--muted);cursor:pointer;font-family:'DM Sans',sans-serif;font-size:0.9rem;transition:all .2s;}
.tab-btn.active{background:var(--accent);color:#000;font-weight:500;}

/* Form */
.tab-content{display:none;}
.tab-content.active{display:block;}
.form-title{font-family:'Playfair Display',serif;font-size:1.8rem;margin-bottom:0.4rem;}
.form-subtitle{color:var(--muted);font-size:0.85rem;margin-bottom:1.8rem;}
.form-group{margin-bottom:1.2rem;}
label{display:block;font-size:0.72rem;text-transform:uppercase;letter-spacing:.12em;color:var(--muted);margin-bottom:0.4rem;}
input{width:100%;background:var(--bg);border:1px solid var(--border);border-radius:6px;padding:0.85rem 1rem;color:var(--text);font-family:'DM Sans',sans-serif;font-size:0.95rem;outline:none;transition:all .2s;}
input:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(201,169,110,0.1);}
.btn-submit{width:100%;background:var(--accent);color:#0a0a0a;border:none;border-radius:6px;padding:1rem;font-family:'DM Sans',sans-serif;font-size:0.95rem;font-weight:500;cursor:pointer;transition:all .2s;margin-top:0.5rem;}
.btn-submit:hover{background:var(--accent2);transform:translateY(-1px);box-shadow:0 8px 25px rgba(201,169,110,0.25);}

/* Alerts */
.alert-error{background:rgba(224,92,92,0.1);border:1px solid var(--danger);color:var(--danger);padding:0.85rem 1rem;border-radius:6px;margin-bottom:1.2rem;font-size:0.85rem;}
.alert-success{background:rgba(76,175,125,0.1);border:1px solid var(--green);color:var(--green);padding:0.85rem 1rem;border-radius:6px;margin-bottom:1.2rem;font-size:0.85rem;}

.hint{background:rgba(201,169,110,0.07);border:1px solid rgba(201,169,110,0.2);border-radius:6px;padding:0.75rem 1rem;margin-bottom:1.2rem;font-size:0.78rem;color:var(--muted);}
.hint strong{color:var(--accent);}
.back-link{text-align:center;margin-top:1.5rem;}
.back-link a{color:var(--muted);text-decoration:none;font-size:0.82rem;}
.back-link a:hover{color:var(--accent);}
</style>
</head>
<body>

<div class="left-panel">
    <div class="brand">
        <span class="brand-icon">📷</span>
        <h1>PhotoStudio</h1>
        <p>Professional Photography Management</p>
        <div class="brand-features">
            <p>Manage bookings & customers</p>
            <p>Track payments & packages</p>
            <p>Monitor staff & feedback</p>
            <p>Secure role-based access</p>
        </div>
    </div>
</div>

<div class="right-panel">
    <div class="login-box">

        <!-- TABS -->
        <div class="tabs">
            <button class="tab-btn <%= !showRegister ? "active" : "" %>"
                    onclick="showTab('login')">Sign In</button>
            <button class="tab-btn <%= showRegister ? "active" : "" %>"
                    onclick="showTab('register')">Register</button>
        </div>

        <%-- SUCCESS message (after register) --%>
        <% if (success != null) { %>
        <div class="alert-success">✓ <%= success %></div>
        <% } %>

        <%-- ERROR message --%>
        <% if (error != null && !showRegister) { %>
        <div class="alert-error">⚠ <%= error %></div>
        <% } %>

        <!-- LOGIN TAB -->
        <div class="tab-content <%= !showRegister ? "active" : "" %>" id="tab-login">
            <h2 class="form-title">Welcome back</h2>
            <p class="form-subtitle">Sign in to your dashboard</p>

            <div class="hint">
                Default admin: <strong>admin</strong> / <strong>123</strong>
            </div>

            <form action="LoginServlet" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Enter username"
                           value="<%= enteredUsername != null ? enteredUsername : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>
                <button class="btn-submit" type="submit">Sign In →</button>
            </form>
        </div>

        <!-- REGISTER TAB -->
        <div class="tab-content <%= showRegister ? "active" : "" %>" id="tab-register">
            <h2 class="form-title">Create Account</h2>
            <p class="form-subtitle">Register a new staff account</p>

            <% if (error != null && showRegister) { %>
            <div class="alert-error">⚠ <%= error %></div>
            <% } %>

            <form action="LoginServlet" method="post">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Choose a username" required>
                </div>
                <div class="form-group">
                    <label>Password (min 3 characters)</label>
                    <input type="password" name="password" placeholder="Choose a password" required>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword"
                           placeholder="Repeat password" required>
                    <p id="matchMsg" style="font-size:0.75rem;margin-top:0.3rem;display:none;"></p>
                </div>
                <button class="btn-submit" type="submit" id="registerBtn">Create Account →</button>
            </form>
        </div>

        <div class="back-link"><a href="index.jsp">← Back to Home</a></div>
    </div>
</div>

<script>
function showTab(tab) {
    document.getElementById('tab-login').classList.remove('active');
    document.getElementById('tab-register').classList.remove('active');
    document.getElementById('tab-' + tab).classList.add('active');
    document.querySelectorAll('.tab-btn').forEach(function(btn, i) {
        btn.classList.toggle('active', (tab === 'login' && i === 0) || (tab === 'register' && i === 1));
    });
}

// Password match check
var confirmInput = document.getElementById('confirmPassword');
var matchMsg     = document.getElementById('matchMsg');
var registerBtn  = document.getElementById('registerBtn');

confirmInput.addEventListener('input', function() {
    var pass = document.querySelector('#tab-register input[name="password"]').value;
    if (this.value === '') { matchMsg.style.display = 'none'; return; }
    matchMsg.style.display = 'block';
    if (this.value === pass) {
        matchMsg.textContent = '✓ Passwords match';
        matchMsg.style.color = '#4caf7d';
        registerBtn.disabled = false;
    } else {
        matchMsg.textContent = '✗ Passwords do not match';
        matchMsg.style.color = '#e05c5c';
        registerBtn.disabled = true;
    }
});
</script>
</body>
</html>
