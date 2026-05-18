package servlet;

import model.Package;
import service.PackageService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class PackageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/packages.txt");
        PackageService service = new PackageService(filePath);

        
        String searchId = request.getParameter("searchId");
        if (searchId != null && !searchId.trim().isEmpty()) {
            String found = service.findPackage(searchId.trim());
            if (found != null) {
                request.setAttribute("searchResult", found.split(","));
                request.setAttribute("searchMsg", "success");
            } else {
                request.setAttribute("searchMsg", "Package ID '" + searchId + "' not found.");
            }
            request.setAttribute("searchId", searchId);
        }

        
        String editId = request.getParameter("editId");
        if (editId != null && !editId.trim().isEmpty()) {
            String found = service.findPackage(editId.trim());
            if (found != null) {
                request.setAttribute("editTarget", found.split(","));
            }
        }

        
        String error = request.getParameter("error");
        if (error != null) request.setAttribute("error", error);

        
        request.setAttribute("totalPackages",      service.getTotalPackages());
        request.setAttribute("totalValue",          service.getTotalPortfolioValue());
        request.setAttribute("discountedCount",     service.countDiscountedPackages());
        request.setAttribute("mostExpensive",       service.getMostExpensiveName());
        request.setAttribute("suggestedId",         service.suggestNextId());

        List<String> packages = FileUtil.readFromFile(filePath);
        request.setAttribute("packages", packages);
        request.setAttribute("service",  service);

        request.getRequestDispatcher("package.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String filePath = getServletContext().getRealPath("/data/packages.txt");
        PackageService service = new PackageService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deletePackage(request.getParameter("id"));
            response.sendRedirect("PackageServlet");

        } else if ("search".equals(action)) {
            response.sendRedirect("PackageServlet?searchId=" +
                    java.net.URLEncoder.encode(request.getParameter("searchId"), "UTF-8"));

        } else if ("update".equals(action)) {
            String originalId   = request.getParameter("originalId");
            String id           = request.getParameter("id");
            String name         = request.getParameter("name");
            double price        = Double.parseDouble(request.getParameter("price"));
            String description  = request.getParameter("description");
            String imagePath    = request.getParameter("imagePath");

            
            Package updated = new Package(id, name, price, description, imagePath);
            String result = service.updatePackage(originalId, updated);

            if (result.startsWith("error:")) {
                response.sendRedirect("PackageServlet?error=" +
                        java.net.URLEncoder.encode(result.substring(6), "UTF-8"));
            } else {
                response.sendRedirect("PackageServlet");
            }

        } else {
           
            String id          = request.getParameter("id");
            String name        = request.getParameter("name");
            double price       = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String imagePath   = request.getParameter("imagePath");

            Package p = new Package(id, name, price, description, imagePath);
            String result = service.addPackage(p);

            if (result.startsWith("error:")) {
                response.sendRedirect("PackageServlet?error=" +
                        java.net.URLEncoder.encode(result.substring(6), "UTF-8"));
            } else {
                response.sendRedirect("PackageServlet");
            }
        }
    }
}
