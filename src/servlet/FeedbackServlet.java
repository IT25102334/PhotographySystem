import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class FeedbackServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String message = request.getParameter("message");

        Feedback f = new Feedback(id, message);
        new FeedbackService().addFeedback(f);

        response.sendRedirect("feedback.jsp");
    }
}
