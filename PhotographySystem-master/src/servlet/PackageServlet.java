package servlet;


import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

    public class PackageServlet extends HttpServlet {

        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String id = request.getParameter("id");
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));

            Package p = new Package(id, name, price);
            new PackageService().addPackage(p);

            response.sendRedirect("package.jsp");
        }
    }

