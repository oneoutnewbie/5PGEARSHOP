package controller.feedback;

import dal.CustomerDAO;
import dal.FeedbackDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Feedback;
import model.Product;
import dal.ProductDAO;
import jakarta.servlet.http.HttpSession;

import java.util.Map;
import model.Customer;

public class FeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer account = (Customer) session.getAttribute("account");


        if (account == null) {
            response.sendRedirect("login");  
            return;
        }
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        ProductDAO productDAO = new ProductDAO();


        String productIdParam = request.getParameter("productid");
        int productId = Integer.parseInt(productIdParam);


        boolean hasPurchased = feedbackDAO.hasPurchasedProduct(account.getCustomerId(), productId);


        Product product = productDAO.getProductById(productId);
        String sortRating = request.getParameter("sortRating");

        List<Feedback> feedbacks = feedbackDAO.getFeedbackByProductId(productId, sortRating);


        int ratingCount = feedbackDAO.getRatingCount(productId);
        float averageRating = feedbackDAO.getAverageRating(productId);
        feedbackDAO.updateProductRate(productId, averageRating);

        Map<Integer, Integer> ratingCounts = feedbackDAO.getRatingCounts(productId);


        int fiveStarRaw = (int) Math.round(ratingCounts.getOrDefault(5, 0) * 100.0 / ratingCount);
        int fourStarRaw = (int) Math.round(ratingCounts.getOrDefault(4, 0) * 100.0 / ratingCount);
        int threeStarRaw = (int) Math.round(ratingCounts.getOrDefault(3, 0) * 100.0 / ratingCount);
        int twoStarRaw = (int) Math.round(ratingCounts.getOrDefault(2, 0) * 100.0 / ratingCount);
        int oneStarRaw = (int) Math.round(ratingCounts.getOrDefault(1, 0) * 100.0 / ratingCount);


        int totalPercentage = fiveStarRaw + fourStarRaw + threeStarRaw + twoStarRaw + oneStarRaw;

        int difference = 100 - totalPercentage;

        if (difference != 0) {

            if (difference > 0) {
                fiveStarRaw += difference; 
            } else {
                fiveStarRaw += difference; 
            }
        }


        int fiveStarPercentage = fiveStarRaw;
        int fourStarPercentage = fourStarRaw;
        int threeStarPercentage = threeStarRaw;
        int twoStarPercentage = twoStarRaw;
        int oneStarPercentage = oneStarRaw;


        request.setAttribute("sortRating", sortRating);
        request.setAttribute("product", product);
        request.setAttribute("sortRating", sortRating);
        request.setAttribute("feedbackList", feedbacks);
        request.setAttribute("account", account);
        request.setAttribute("ratingCount", ratingCount);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("ratingCounts", ratingCounts);
        request.setAttribute("fiveStarPercentage", fiveStarPercentage);
        request.setAttribute("fourStarPercentage", fourStarPercentage);
        request.setAttribute("threeStarPercentage", threeStarPercentage);
        request.setAttribute("twoStarPercentage", twoStarPercentage);
        request.setAttribute("oneStarPercentage", oneStarPercentage);
        request.setAttribute("hasPurchased", hasPurchased);

        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO feedbackDAO = new FeedbackDAO();


        int feedbackId = Integer.parseInt(request.getParameter("feedbackId")); 
        String updatedComment = request.getParameter("feedbackComment"); 
        int updatedRating = Integer.parseInt(request.getParameter("rating")); 
        int productId = Integer.parseInt(request.getParameter("productid"));
        try {

            feedbackDAO.updateFeedback(feedbackId, updatedComment, updatedRating);
            response.sendRedirect("feedback?productid=" + productId); 
        } catch (Exception e) {

            request.setAttribute("errorMessage", "Cập nhật phản hồi thất bại."); 
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "FeedbackController handles displaying customer feedback.";
    }
}
