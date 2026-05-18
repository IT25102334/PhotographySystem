public class PaymentServlet {
    import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

    public class PaymentServlet extends HttpServlet {

        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String id = request.getParameter("id");
            String bookingId = request.getParameter("bookingId");
            double amount = Double.parseDouble(request.getParameter("amount"));

            Payment p = new Payment(id, bookingId, amount);
            new PaymentService().addPayment(p);

            response.sendRedirect("payment.jsp");
        }
    }
}
