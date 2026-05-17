<%@ include file="sessionCheck.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PhotoStudio - Capturing Moments Gracefully</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700;900&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0a; --card: #141414; --accent: #c9a96e;
            --accent2: #e8c99a; --text: #f0ece4; --muted: #7a7570; --border: #2a2520;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: var(--bg); font-family: 'DM Sans', sans-serif; color: var(--text); overflow-x: hidden; }

        /* HEADER */
        header {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            background: rgba(10,10,10,0.95); backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 1.1rem 3rem; display: flex; align-items: center; justify-content: space-between;
        }
        .logo { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: var(--accent); text-decoration: none; }
        nav a { color: var(--muted); text-decoration: none; font-size: 0.88rem; margin-left: 2rem; transition: color 0.2s; }
        nav a:hover { color: var(--accent); }
        .btn-login { background: var(--accent); color: #0a0a0a; padding: 0.6rem 1.4rem; border-radius: 6px; text-decoration: none; font-size: 0.88rem; font-weight: 500; }
        .btn-login:hover { background: var(--accent2); }

        /* SLIDER */
        .hero-wrapper { margin-top: 64px; position: relative; width: 100%; height: 90vh; overflow: hidden; }

        .slider-track {
            display: flex;
            width: 300%;
            height: 100%;
            transition: transform 0.7s ease-in-out;
            will-change: transform;
        }

        .slide {
            width: 33.3333%;
            height: 100%;
            position: relative;
            background: #0a0a0a;
            flex-shrink: 0;
            overflow: hidden;
        }

        .slide::before {
            content: '';
            position: absolute; inset: 0; z-index: 1;
            background: linear-gradient(to right, rgba(10,10,10,0.88) 35%, rgba(10,10,10,0.1) 100%);
        }

        .slide-img {
            position: absolute; right: 0; top: 0;
            width: 58%; height: 100%;
            object-fit: cover; object-position: center top;
            border-radius: 0 0 0 70px;
        }

        .slide-content {
            position: absolute; left: 8%; top: 50%; transform: translateY(-50%);
            max-width: 500px; z-index: 2;
        }
        .slide-tag { font-size: 0.72rem; letter-spacing: 0.25em; text-transform: uppercase; color: var(--accent); margin-bottom: 1.2rem; }
        .slide-title { font-family: 'Playfair Display', serif; font-size: clamp(2.2rem, 4vw, 3.6rem); font-weight: 900; line-height: 1.08; margin-bottom: 1.2rem; }
        .slide-desc { color: var(--muted); font-size: 1rem; line-height: 1.7; margin-bottom: 2rem; max-width: 400px; }
        .btn-hero { display: inline-flex; align-items: center; gap: 0.5rem; background: var(--accent); color: #0a0a0a; padding: 0.9rem 2rem; border-radius: 8px; text-decoration: none; font-weight: 500; font-size: 0.95rem; transition: all 0.3s; }
        .btn-hero:hover { background: var(--accent2); transform: translateY(-2px); }

        .arrow {
            position: absolute; top: 50%; transform: translateY(-50%); z-index: 10;
            width: 48px; height: 48px; border-radius: 50%;
            background: rgba(201,169,110,0.12); border: 1px solid rgba(201,169,110,0.35);
            color: var(--accent); font-size: 1.6rem; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.25s; user-select: none;
        }
        .arrow:hover { background: var(--accent); color: #0a0a0a; }
        .arrow-prev { left: 1.8rem; }
        .arrow-next { right: 1.8rem; }

        .dots { position: absolute; bottom: 1.8rem; left: 50%; transform: translateX(-50%); display: flex; gap: 8px; z-index: 10; }
        .dot { width: 8px; height: 8px; border-radius: 50%; background: rgba(201,169,110,0.3); cursor: pointer; transition: all 0.3s; }
        .dot.active { background: var(--accent); width: 26px; border-radius: 4px; }

        /* STATS */
        .stats-bar { background: var(--card); border-bottom: 1px solid var(--border); padding: 2rem 8%; display: grid; grid-template-columns: repeat(4,1fr); }
        .stat-item { text-align: center; }
        .stat-item:not(:last-child) { border-right: 1px solid var(--border); }
        .stat-num { font-family: 'Playfair Display', serif; font-size: 2.2rem; color: var(--accent); }
        .stat-lbl { color: var(--muted); font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 0.3rem; }

        /* SERVICES */
        .section { padding: 5rem 8%; }
        .section-tag { font-size: 0.72rem; letter-spacing: 0.25em; text-transform: uppercase; color: var(--accent); margin-bottom: 1rem; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 2.5rem; margin-bottom: 1rem; }
        .section-sub { color: var(--muted); max-width: 480px; line-height: 1.7; margin-bottom: 3rem; }
        .services-grid { display: grid; grid-template-columns: repeat(2,1fr); gap: 1.5rem; }
        .service-card { background: var(--card); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; transition: all 0.3s; }
        .service-card:hover { border-color: var(--accent); transform: translateY(-6px); box-shadow: 0 20px 50px rgba(0,0,0,0.4); }
        .svc-img { width:100%; height:320px; object-fit:cover; object-position:center top; display:block; }
        .svc-body { padding: 1.5rem; background: var(--card); }
        .svc-num { font-size:0.72rem; color:var(--muted); letter-spacing:0.15em; }
        .svc-name { font-family:'Playfair Display',serif; font-size:1.25rem; margin:0.5rem 0; color:var(--accent); }
        .svc-desc { color:var(--muted); font-size:0.85rem; line-height:1.6; }
        .svc-link { display:inline-flex; align-items:center; gap:0.3rem; color:var(--accent); text-decoration:none; font-size:0.85rem; margin-top:1rem; }
        .svc-link:hover { gap:0.6rem; }

        /* NOTE */
        .note-box { background:var(--card); border:1px solid var(--border); border-radius:16px; padding:2.5rem; text-align:center; max-width:600px; margin:0 auto; }
        .note-icon { font-size:2rem; margin-bottom:1rem; }
        .note-title { font-family:'Playfair Display',serif; font-size:1.3rem; margin-bottom:0.8rem; }
        .note-text { color:var(--muted); line-height:1.7; font-size:0.9rem; }

        /* FOOTER */
        footer { background:var(--card); border-top:1px solid var(--border); padding:2rem 8%; display:flex; justify-content:space-between; align-items:center; }
        footer p { color:var(--muted); font-size:0.85rem; }
        footer a { color:var(--accent); text-decoration:none; }
    </style>
</head>
<body>

<!-- HEADER -->
<header>
    <a href="index.jsp" class="logo">📷 SnapSpark Studio</a>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="CustomerServlet">Customers</a>
        <a href="BookingServlet">Bookings</a>
        <a href="PaymentServlet">Payments</a>
        <a href="FeedbackServlet">Feedback</a>
        <a href="StaffServlet">Staff</a>
        <a href="PackageServlet">Packages</a>
        <a href="LoginServlet?action=logout">Logout (<%= loggedInUser %>)</a>
    </nav>
    <a href="login.jsp" class="btn-login">Login →</a>
</header>

<!-- HERO SLIDER -->
<div class="hero-wrapper">

    <div class="slider-track" id="sliderTrack">

        <!-- SLIDE 1 -->
        <div class="slide">
            <img class="slide-img" src="images/tharindi2.jpg" alt="Portrait">
            <div class="slide-content">
                <p class="slide-tag">Capturing Moments Gracefully</p>
                <h1 class="slide-title">Elegant Portraits,<br>Timeless Memories</h1>
                <p class="slide-desc">The premier photographic studio, known for creating captivating portraits that truly stand out.</p>
                <a href="BookingServlet" class="btn-hero">Book Now →</a>
            </div>
        </div>

        <!-- SLIDE 2 -->
        <div class="slide">
            <img class="slide-img" src="images/yohani2.jpg" alt="Wedding">
            <div class="slide-content">
                <p class="slide-tag">Fashion & Lifestyle</p>
                <h1 class="slide-title">Step Into<br>The Spotlight</h1>
                <p class="slide-desc">Expertly crafted fashion shoots that capture your style and personality with every click.</p>
                <a href="PackageServlet" class="btn-hero">View Packages →</a>
            </div>
        </div>

        <!-- SLIDE 3 -->
        <div class="slide">
            <img class="slide-img" src="images/wedding1.jpg" alt="Fashion">
            <div class="slide-content">
                <p class="slide-tag">Wedding Photography</p>
                <h1 class="slide-title">Your Perfect<br>Day, Forever</h1>
                <p class="slide-desc">Every smile, every tear, every precious moment beautifully preserved for a lifetime.</p>
                <a href="BookingServlet" class="btn-hero">Get Quote →</a>
            </div>
        </div>

    </div>

    <div class="arrow arrow-prev" id="prevBtn">&#8249;</div>
    <div class="arrow arrow-next" id="nextBtn">&#8250;</div>

    <div class="dots" id="dotsContainer">
        <div class="dot active" id="dot0"></div>
        <div class="dot" id="dot1"></div>
        <div class="dot" id="dot2"></div>
    </div>

</div>

<!-- STATS -->
<div class="stats-bar">
    <div class="stat-item"><div class="stat-num">100k+</div><div class="stat-lbl">Photos Captured</div></div>
    <div class="stat-item"><div class="stat-num">75+</div><div class="stat-lbl">Corporate Clients</div></div>
    <div class="stat-item"><div class="stat-num">4.9</div><div class="stat-lbl">Average Rating</div></div>
    <div class="stat-item"><div class="stat-num">13</div><div class="stat-lbl">Years in Business</div></div>
</div>

<!-- SERVICES -->
<section class="section">
    <p class="section-tag">What We Offer</p>
    <h2 class="section-title">Our Services</h2>
    <p class="section-sub">From intimate portraits to grand weddings, we capture every moment with artistry and care.</p>
    <div class="services-grid">

        <div class="service-card">
            <img class="svc-img" src="images/serve.jpg" alt="Portraits">
            <div class="svc-body">
                <p class="svc-num">01</p>
                <h3 class="svc-name">Portrait Sessions</h3>
                <p class="svc-desc">Professional portraits that capture your true essence.</p>
                <a href="BookingServlet" class="svc-link">Book Session →</a>
            </div>
        </div>

        <div class="service-card">
            <img class="svc-img" src="images/service2.jpg" alt="Wedding">
            <div class="svc-body">
                <p class="svc-num">02</p>
                <h3 class="svc-name">Wedding Photography</h3>
                <p class="svc-desc">Timeless wedding memories beautifully preserved.</p>
                <a href="PackageServlet" class="svc-link">View Packages →</a>
            </div>
        </div>

        <div class="service-card">
            <img class="svc-img" src="images/service3.jpg" alt="Family">
            <div class="svc-body">
                <p class="svc-num">03</p>
                <h3 class="svc-name">Family Portraits</h3>
                <p class="svc-desc">Capture the love and joy of your family.</p>
                <a href="BookingServlet" class="svc-link">Book Now →</a>
            </div>
        </div>

        <div class="service-card">
            <img class="svc-img" src="images/service4.jpg" alt="Graduation">
            <div class="svc-body">
                <p class="svc-num">04</p>
                <h3 class="svc-name">Graduation Shoots</h3>
                <p class="svc-desc">Celebrate your milestone with stunning photos.</p>
                <a href="BookingServlet" class="svc-link">Get Quote →</a>
            </div>
        </div>

        <div class="service-card">
            <img class="svc-img" src="images/service5.jpg" alt="Photoshoots">
            <div class="svc-body">
                <p class="svc-num">05</p>
                <h3 class="svc-name">Photoshoots</h3>
                <p class="svc-desc">Creative photoshoots tailored to your vision.</p>
                <a href="BookingServlet" class="svc-link">Book Now →</a>
            </div>
        </div>

        <div class="service-card">
            <img class="svc-img" src="images/service6.jpg" alt="Fashion shoots">
            <div class="svc-body">
                <p class="svc-num">06</p>
                <h3 class="svc-name">Fashion Shoots</h3>
                <p class="svc-desc">Step into the spotlight with expertly crafted shoots.</p>
                <a href="BookingServlet" class="svc-link">Get Quote →</a>
            </div>
        </div>

    </div>
</section>

<!-- NOTE -->
<section class="section" style="padding-top:0;">
    <div class="note-box">
        <div class="note-icon">ℹ️</div>
        <h3 class="note-title">Please Note</h3>
        <p class="note-text">Our standard editing process takes 3–4 working days. However, if you require same-day service, it can be arranged after making full payment and selecting your portraits.</p>
    </div>
</section>

<!-- FOOTER -->
<footer>
    <p>© 2025 PhotoStudio. All rights reserved.</p>
    <p><a href="login.jsp">Admin Login</a></p>
</footer>

<script>
    // ✅ Simple bulletproof slider
    var cur = 0;
    var total = 3;

    function goTo(n) {
        cur = ((n % total) + total) % total;
        document.getElementById('sliderTrack').style.transform = 'translateX(-' + (cur * 33.3333) + '%)';
        document.getElementById('dot0').className = 'dot' + (cur === 0 ? ' active' : '');
        document.getElementById('dot1').className = 'dot' + (cur === 1 ? ' active' : '');
        document.getElementById('dot2').className = 'dot' + (cur === 2 ? ' active' : '');
    }

    document.getElementById('nextBtn').onclick = function() { goTo(cur + 1); };
    document.getElementById('prevBtn').onclick = function() { goTo(cur - 1); };
    document.getElementById('dot0').onclick = function() { goTo(0); };
    document.getElementById('dot1').onclick = function() { goTo(1); };
    document.getElementById('dot2').onclick = function() { goTo(2); };

    // Auto slide every 5 seconds
    setInterval(function() { goTo(cur + 1); }, 5000);
</script>

</body>
</html>
