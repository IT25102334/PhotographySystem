package servlet;

import model.Customer;
import service.CustomerService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CustomerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/customers.txt");
        CustomerService service = new CustomerService(filePath);

        // Handle search
        String searchId = request.getParameter("searchId");
        if (searchId != null && !searchId.trim().isEmpty()) {
            String found = service.findCustomer(searchId.trim());
            if (found != null) {
                request.setAttribute("searchResult", found.split(","));
                request.setAttribute("searchMsg", "success");
            } else {
                request.setAttribute("searchMsg", "Customer ID '" + searchId + "' not found.");
            }
            request.setAttribute("searchId", searchId);
        }

        // Pass error from redirect if any
        String error = request.getParameter("error");
        if (error != null) request.setAttribute("error", error);

        List<String> customers = FileUtil.readFromFile(filePath);
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("customer.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/customers.txt");
        CustomerService service = new CustomerService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deleteCustomer(request.getParameter("id"));
            response.sendRedirect("CustomerServlet");

        } else if ("search".equals(action)) {
            String searchId = request.getParameter("searchId");
            response.sendRedirect("CustomerServlet?searchId=" + searchId);

        } else {
            // ADD - show validation error in UI
            String id    = request.getParameter("id");
            String name  = request.getParameter("name");
            String email = request.getParameter("email");
            Customer c   = new Customer(id, name, email);
            String error = service.addCustomer(c);

            if (error != null) {
                response.sendRedirect("CustomerServlet?error=" +
                        java.net.URLEncoder.encode(error, "UTF-8"));
            } else {
                response.sendRedirect("CustomerServlet");
            }
        }
    }
}
