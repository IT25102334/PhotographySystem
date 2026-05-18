package servlet;

import model.Staff;
import service.StaffService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StaffServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/staff.txt");
        StaffService service = new StaffService(filePath);

        // Handle search
        String searchId = request.getParameter("searchId");
        if (searchId != null && !searchId.trim().isEmpty()) {
            String found = service.findStaff(searchId.trim());
            if (found != null) {
                request.setAttribute("searchResult", found.split(","));
                request.setAttribute("searchMsg", "success");
            } else {
                request.setAttribute("searchMsg", "Staff ID '" + searchId + "' not found.");
            }
            request.setAttribute("searchId", searchId);
        }

        String error = request.getParameter("error");
        if (error != null) request.setAttribute("error", error);

        List<String> staffList = FileUtil.readFromFile(filePath);
        request.setAttribute("staffList", staffList);

        // ✅ photographer count visible in UI
        request.setAttribute("photographerCount", service.countPhotographers());
        request.setAttribute("totalStaff", staffList.size());

        request.getRequestDispatcher("staff.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/staff.txt");
        StaffService service = new StaffService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deleteStaff(request.getParameter("id"));
            response.sendRedirect("StaffServlet");

        } else if ("search".equals(action)) {
            response.sendRedirect("StaffServlet?searchId=" +
                    request.getParameter("searchId"));

        } else {
            Staff s = new Staff(
                    request.getParameter("id"),
                    request.getParameter("name"),
                    request.getParameter("role")
            );
            String error = service.addStaff(s);
            if (error != null) {
                response.sendRedirect("StaffServlet?error=" +
                        java.net.URLEncoder.encode(error, "UTF-8"));
            } else {
                response.sendRedirect("StaffServlet");
            }
        }
    }
}
