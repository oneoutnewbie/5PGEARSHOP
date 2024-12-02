package controller.marketting;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import model.Marketing;
import java.util.Map;
import model.Customer;

/**
 *
 * @author acer
 */

@WebServlet(urlPatterns={"/marketting/feedmarketting"})
public class FeedBackMarketting extends HttpServlet {
   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       HttpSession session = request.getSession();
        Marketing marketer = (Marketing) session.getAttribute("marketer");

        // Check if the user is logged in
        if (marketer != null) {
            try {            
                // Get filtering parameters
                String search = request.getParameter("search");           
                String status = request.getParameter("status");
                String sort = request.getParameter("sort");

                // Initialize default values
                search = (search != null) ? search : "";
                status = (status != null) ? status : "";
                sort = (sort != null) ? sort : "feedid"; // Default sorting by title
                FeedbackDAO feedbackdao = new FeedbackDAO();
                // Get the filtered list of blogs
                List<Feedback> filteredFeedbacks = feedbackdao.getFilteredFeedback(search, sort, status);
                request.setAttribute("filteredFeedBackLists", filteredFeedbacks);

                // Pagination
                String pageParam = request.getParameter("page");
                int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
                int pageSize = 6; // Number of blogs per page

                int totalFilteredBlogs = filteredFeedbacks.size();
                int totalPages = (int) Math.ceil((double) totalFilteredBlogs / pageSize);

                // Calculate start and end index for pagination
                int start = (page - 1) * pageSize;
                int end = Math.min(start + pageSize, totalFilteredBlogs);

                // Get blogs for the current page
                List<Feedback> feedbacksForCurrentPage = filteredFeedbacks.subList(start, end);
                request.setAttribute("filteredFeedbackList", feedbacksForCurrentPage);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);

                // Set parameters back for the UI
                request.setAttribute("paramSearch", search);   
                request.setAttribute("paramStatus", status);
                request.setAttribute("paramSort", sort);

                // Forward to the JSP page
                request.getRequestDispatcher("/marketting/feedBack.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Redirect to login if the user is not logged in
            response.sendRedirect(request.getContextPath() + "/loginstaff.jsp");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String statu = request.getParameter("id");
        String status = request.getParameter("status");
        String newstatus ="Active";
        if(status.equals("Active")){
            newstatus="Inactive";
        }
        FeedbackDAO feedbackdao = new FeedbackDAO();
        feedbackdao.changeStatus(Integer.parseInt(statu), newstatus);
        response.sendRedirect("/SWP391Gr5/marketting/feedmarketting");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
