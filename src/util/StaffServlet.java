package util;

import model.Staff;
import service.StaffService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class StaffServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String role = request.getParameter("role");

        Staff s = new Staff(id, name, role);
        new StaffService().addStaff(s);

        response.sendRedirect("staff.jsp");
    }
}
