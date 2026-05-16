package servlet;

import model.Admin;
import service.AdminService;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 * LoginServlet — handles login, logout, and registration
 * Uses Admin model and AdminService — completely separate from Customer
 * Actions: login, logout, register
 */
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // LOGOUT — destroy session and go to login page
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        // If already logged in, skip login page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect("index.jsp");
            return;
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Uses admins.txt — separate from customers.txt
        String filePath = getServletContext().getRealPath("/data/admins.txt");
        AdminService service = new AdminService(filePath);
        String action = request.getParameter("action");

        // ── REGISTER ──────────────────────────────────────────────────────────
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role     = "user"; // new registrations are always "user"

            String result = service.register(username, password, role);

            if (result.startsWith("error:")) {
                request.setAttribute("error",        result.substring(6));
                request.setAttribute("showRegister", true);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("success", "Account created! You can now log in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return;
        }

        // ── LOGIN ─────────────────────────────────────────────────────────────
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both username and password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Admin admin = service.login(username.trim(), password.trim());

        if (admin != null) {
            // ✅ LOGIN SUCCESS — create session
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedInUser", admin.getUsername());
            session.setAttribute("userRole",     admin.getRole());
            session.setAttribute("isAdmin",      admin.isAdmin());
            session.setMaxInactiveInterval(30 * 60); // 30 min timeout
            response.sendRedirect("index.jsp");
        } else {
            // ❌ LOGIN FAILED
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}