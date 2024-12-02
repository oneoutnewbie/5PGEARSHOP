
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Marketting Dashboard</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .message.info {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                max-width: 300px;
                width: 100%;
            }

            .message.info [show-alert] {
                background-color: #28a745;
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                display: flex;
                justify-content: space-between;
                align-items: center;
                animation: slideIn 0.5s ease-out;
            }

            .message.info [show-alert] button {
                background: none;
                border: none;
                color: white;
                font-size: 20px;
                cursor: pointer;
                padding: 0;
                margin-left: 10px;
            }

            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes fadeOut {
                from {
                    opacity: 1;
                }
                to {
                    opacity: 0;
                }
            }

            .message.info [show-alert].alert-hidden {
                animation: fadeOut 0.5s ease-out forwards;
            }
            .Page navigation{
                display: flex
            }
            .pagination{
                justify-content: center;

            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Gọi sidebar ở đây -->
                <jsp:include page="sidebar.jsp" />
                <main class="col-md-9 col-lg-10 main-content">
                    <header class="main-header d-flex justify-content-between align-items-center py-3">
                        <button id="sidebar-toggle" class="btn btn-outline-secondary">
                            <i class="fas fa-bars"></i>
                        </button>
                        <div class="user-info">
                            <span>Welcome, Marketing</span>
                            <a href="${pageContext.request.contextPath}/logoutstaff" class="btn btn-outline-danger btn-sm ml-2">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </div>
                    </header>

                    <div class="dashboard">
                        <h1 class="my-4">Feedback List</h1>
                        <!-- Filter Form -->
                        <form method="get" action="/SWP391Gr5/marketting/feedmarketting">

                            <div class="form-inline my-2">
                                <input type="text" name="search" class="form-control mr-2" placeholder="Search by title" value="${param.search}">                              
                                <select name="status" class="form-control mr-2">
                                    <option value="">All Statuses</option>
                                    <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                    <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                </select>
                                <select name="sort" class="form-control mr-2">
                                    <option value="feedId"${param.sort == 'feedId' ? 'selected' : ''}>FeedBack's Id</option> 
                                    <option value="dateCreated" ${param.sort == 'dateCreated' ? 'selected' : ''}>Sort by date</option>

                                </select>
                                <button type="submit" class="btn btn-primary filter-btn">Apply Filters</button>
                            </div>
                        </form>


                        <!-- Success Message Alert -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="message info">
                                <div show-alert>
                                    ${sessionScope.successMessage}
                                    <button type="button" onclick="closeAlert(this)" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </div>
                            <c:remove var="successMessage" scope="session"/>
                        </c:if>


                        <!-- Blog Table -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Comment</th>
                                    <th>Status</th>
                                    <th>Rating</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>

                                <c:forEach var="feedback" items="${filteredFeedbackList}">
                                    <tr>
                                        <td>${feedback.getFeedbackId()}</td>
                                        <td>${feedback.getCustomerId().getCustomerName()}</td>
                                        <td>${feedback.getProductId().getProductName()}</td>
                                        <td>${feedback.getComment()}</td>                                     
                                        <td>
                                            <button class="btn ${feedback.status.equals("Active") ? 'btn-success' : 'btn-danger'}">
                                                ${feedback.status.equals("Active") ? 'Active' : 'Inactive'}
                                            </button>
                                        </td>
                                        <td>${feedback.getRating()}</td>  
                                        <td>${feedback.getDobString()}</td> 
                                        <td>

                                            <form action="/SWP391Gr5/marketting/feedmarketting" method="POST" onsubmit="return confirm('Are you sure you want to ${feedback.status.equals("Active") ? 'Inactive' : 'Active'} this feedback?');" style="display: inline;">
                                                <input type="hidden" name="id" value="${feedback.getFeedbackId()}">
                                                <input type="hidden" name="status" value="${feedback.status}">
                       
                                                <button type="submit" class="btn btn-secondary btn-sm">
                                                    <i class="fas ${feedback.status.equals("Active") ? 'fa-eye'  : 'fa-eye-slash'}"></i> 
                                                    ${feedback.status.equals("Active") ? 'Hide' : 'Show'}
                                                </button>
                                            </form>


                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>                   

                    </div>
                </main>
            </div>
        </div>


        <!-- Pagination -->
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <!-- Previous Button -->
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage - 1}&search=${paramSearch}&category=${paramCategory}&status=${paramStatus}&sort=${paramSort}">Previous</a>
                    </li>
                </c:if>

                <!-- Page Number Links -->
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&search=${paramSearch}&category=${paramCategory}&status=${paramStatus}&sort=${paramSort}">${i}</a>
                    </li>
                </c:forEach>

                <!-- Next Button -->
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage + 1}&search=${paramSearch}&category=${paramCategory}&status=${paramStatus}&sort=${paramSort}">Next</a>
                    </li>
                </c:if>
            </ul>
        </nav>

        <!-- Bootstrap JS and dependencies -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="script.js"></script>

        <script>
                                                $(document).ready(function () {
                                                    // Check if there are validation errors
            <% if (request.getAttribute("errors") != null) { %>
                                                    // Open the modal if there are errors
                                                    $('#addBlogModal').modal('show');

                                                    // Change the URL to the current page (if necessary)
                                                    const currentUrl = window.location.href;
                                                    const errorUrl = currentUrl.replace("/editBlogMarketting", "/createBlogMarketting"); // Change to appropriate URL
                                                    history.pushState(null, null, errorUrl);

                                                    // Listen for modal close event
                                                    $('#addBlogModal').on('hidden.bs.modal', function () {
                                                        // Change the URL back to the /marketing/listBlog path
                                                        history.pushState(null, null, '/SWP391Gr5/marketing/listblogmarketting');
                                                    });
            <% } %>
                                                });
        </script>

        <script>
            $(document).ready(function () {
                // Check if the blogById object exists
            <c:if test="${not empty blogById}">
                // Show the modal automatically when blogById is present
                $('#blogModal').modal('show');

                // Change the URL to the blog view URL
                const currentUrl = window.location.href;
                const blogUrl = currentUrl.replace("/listBlogMarketting", `/marketting/viewBlog?id=${blogById.blogId}`);
                history.pushState(null, null, blogUrl);

                // Listen for modal close event
                $('#blogModal').on('hidden.bs.modal', function () {
                    // Change the URL back to the /marketing/listBlogMarketting path
                    history.pushState(null, null, '/SWP391Gr5/marketting/listblogmarketting');
                });
            </c:if>
            });

        </script>

        <script>
            function closeAlert(button) {
                const alert = button.closest('[show-alert]');
                alert.classList.add('alert-hidden');
                setTimeout(() => {
                    alert.parentElement.remove();
                }, 500);
            }

            // Auto-hide the alert after 5 seconds
            setTimeout(() => {
                const alert = document.querySelector('[show-alert]');
                if (alert) {
                    closeAlert(alert.querySelector('button'));
                }
            }, 5000);
        </script>
    </body>
</html>
