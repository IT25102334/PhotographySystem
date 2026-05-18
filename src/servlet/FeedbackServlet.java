package servlet;

import model.Feedback;
import service.FeedbackService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FeedbackServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/feedback.txt");
        FeedbackService service = new FeedbackService(filePath);

        List<String> feedbacks = FileUtil.readFromFile(filePath);
        request.setAttribute("feedbacks", feedbacks);


        request.setAttribute("avgRating",       service.calculateAverageRating());
        request.setAttribute("positiveCount",   service.countPositiveFeedback());
        request.setAttribute("negativeCount",   service.countNegativeFeedback());
        request.setAttribute("totalFeedbacks",  feedbacks.size());

        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/feedback.txt");
        FeedbackService service = new FeedbackService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deleteFeedback(request.getParameter("customerName"));
        } else {
            String customerName = request.getParameter("customerName");
            String message      = request.getParameter("message");
            int rating          = Integer.parseInt(request.getParameter("rating"));
            Feedback f = new Feedback(customerName, message, rating);
            service.addFeedback(f);
        }

        response.sendRedirect("FeedbackServlet");
    }
}package servlet;

import model.Feedback;
import service.FeedbackService;
import util.FileUtil;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FeedbackServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/feedback.txt");
        FeedbackService service = new FeedbackService(filePath);

        List<String> feedbacks = FileUtil.readFromFile(filePath);
        request.setAttribute("feedbacks", feedbacks);


        request.setAttribute("avgRating",       service.calculateAverageRating());
        request.setAttribute("positiveCount",   service.countPositiveFeedback());
        request.setAttribute("negativeCount",   service.countNegativeFeedback());
        request.setAttribute("totalFeedbacks",  feedbacks.size());

        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filePath = getServletContext().getRealPath("/data/feedback.txt");
        FeedbackService service = new FeedbackService(filePath);
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            service.deleteFeedback(request.getParameter("customerName"));
        } else {
            String customerName = request.getParameter("customerName");
            String message      = request.getParameter("message");
            int rating          = Integer.parseInt(request.getParameter("rating"));
            Feedback f = new Feedback(customerName, message, rating);
            service.addFeedback(f);
        }

        response.sendRedirect("FeedbackServlet");
    }
}
