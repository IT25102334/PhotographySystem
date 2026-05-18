package servlet;

import model.Booking;
import service.BookingService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BookingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/bookings.txt");
        BookingService service = new BookingService(filePath);

        String searchId = request.getParameter("searchId");
        if (searchId != null && !searchId.trim().isEmpty()) {
            String found = service.findBooking(searchId.trim());
            if (found != null) {
                request.setAttribute("searchResult", found.split(",", 4));
                request.setAttribute("searchMsg", "success");
            } else {
                request.setAttribute("searchMsg", "Booking ID '" + searchId + "' not found.");
            }
            request.setAttribute("searchId", searchId);
        }

        String error = request.getParameter("error");
        if (error != null) request.setAttribute("error", error);

        String packagesPath = getServletContext().getRealPath("/data/packages.txt");
        List<String> packages = FileUtil.readFromFile(packagesPath);
        request.setAttribute("packages", packages);

        List<String> bookings = FileUtil.readFromFile(filePath);
        request.setAttribute("bookings",      bookings);
        request.setAttribute("totalBookings", service.countBookings());
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/bookings.txt");
        BookingService service = new BookingService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deleteBooking(request.getParameter("id"));
            response.sendRedirect("BookingServlet");

        } else if ("search".equals(action)) {
            response.sendRedirect("BookingServlet?searchId=" +
                    java.net.URLEncoder.encode(request.getParameter("searchId"), "UTF-8"));

        } else {

            Booking b = new Booking(
                    request.getParameter("id"),
                    request.getParameter("customerId"),
                    request.getParameter("date"),
                    request.getParameter("packageId")  
            );
            String error = service.addBooking(b);
            if (error != null) {
                response.sendRedirect("BookingServlet?error=" +
                        java.net.URLEncoder.encode(error, "UTF-8"));
            } else {
                response.sendRedirect("BookingServlet");
            }
        }
    }
}
