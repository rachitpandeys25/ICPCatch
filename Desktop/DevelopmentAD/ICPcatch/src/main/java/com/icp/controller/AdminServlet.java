package com.icp.controller;

import com.icp.dao.*;
import com.icp.model.*;
import com.icp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet(urlPatterns = {"/admin"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AdminServlet extends HttpServlet {

    // ============ SECURITY CHECK ============
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "users":
                showUsers(request, response);
                break;
            case "items":
                showItems(request, response);
                break;
            case "claims":
                showClaims(request, response);
                break;
            case "postItem":
                showPostItemForm(request, response);
                break;
            case "editItem":
                showEditItemForm(request, response);
                break;
            case "deleteItem":
                deleteItem(request, response);
                break;
            case "deleteUser":
                deleteUser(request, response);
                break;
            case "approveClaim":
                approveClaim(request, response);
                break;
            case "rejectClaim":
                rejectClaim(request, response);
                break;
            case "resolveItem":
                resolveItem(request, response);
                break;
            case "toggleUserStatus":
                toggleUserStatus(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "postItem":
                handlePostItem(request, response);
                break;
            case "editItem":
                handleEditItem(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    // ============ DASHBOARD ============
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();
        request.setAttribute("totalItems", dao.getTotalItems());
        request.setAttribute("totalUsers", dao.getTotalUsers());
        request.setAttribute("pendingClaims", dao.getActiveClaims());
        request.setAttribute("successRate", dao.getSuccessRate());
        request.setAttribute("categoryStats", dao.getCategoryStats());
        request.setAttribute("itemTypeStats", dao.getItemTypeStats());
        request.setAttribute("recentClaims", new ClaimDAO().getPendingClaims());
        request.setAttribute("recentItems", new ItemDAO().getAllItems());
        forward(request, response, "/views/admin/dashboard.jsp");
    }

    // ============ USERS ============
    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("users", new UserDAO().getAllUsers());
        forward(request, response, "/views/admin/manageusers.jsp");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        new UserDAO().deleteUser(userId);
        response.sendRedirect(request.getContextPath() 
            + "/admin?action=users&success=User deleted successfully");
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        new UserDAO().updateStatus(userId, status);
        response.sendRedirect(request.getContextPath() + "/admin?action=users");
    }

    // ============ ITEMS ============
    private void showItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("items", new ItemDAO().getAllItems());
        request.setAttribute("categories", new CategoryDAO().getAllCategories());
        forward(request, response, "/views/admin/manageitems.jsp");
    }

    private void showPostItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", new CategoryDAO().getAllCategories());
        forward(request, response, "/views/admin/postitem.jsp");
    }

    private void showEditItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("item", new ItemDAO().getItemById(itemId));
        request.setAttribute("categories", new CategoryDAO().getAllCategories());
        forward(request, response, "/views/admin/edititem.jsp");
    }

    private void handlePostItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User admin = (User) request.getSession().getAttribute("user");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryId = request.getParameter("categoryId");
        String itemType = request.getParameter("itemType");
        String dateOccurred = request.getParameter("dateOccurred");
        String location = request.getParameter("location");
        String foundBy = request.getParameter("foundBy");

        if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isNotEmpty(location)) {
            request.setAttribute("error", "Please fill all required fields.");
            request.setAttribute("categories", new CategoryDAO().getAllCategories());
            forward(request, response, "/views/admin/postitem.jsp");
            return;
        }

        // Handle image
        // Handle image upload
            String imagePath = null;
            try {
                Part imagePart = request.getPart("image");
                if (imagePart != null && imagePart.getSize() > 0
                        && ValidationUtil.isValidImageExtension(imagePart)) {

                    // Generate unique filename to avoid conflicts
                    String originalName = imagePart.getSubmittedFileName();
                    String extension = originalName.substring(
                        originalName.lastIndexOf('.'));
                    String fileName = System.currentTimeMillis() + extension;

                    // Save to permanent external folder
                    String uploadDir = "C:/ICPCatch_Uploads/images/";
                    java.io.File dir = new java.io.File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();

                    imagePart.write(uploadDir + fileName);

                    // Store just filename in DB
                    imagePath = fileName;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        // Build description with foundBy info
        String fullDescription = description;
        if (ValidationUtil.isNotEmpty(foundBy)) {
            fullDescription = "Found by: " + foundBy + "\n\n" + description;
        }

        Item item = new Item();
        item.setTitle(title);
        item.setDescription(fullDescription);
        item.setCategoryId(Integer.parseInt(categoryId));
        item.setItemType(itemType);
        item.setDateOccurred(Date.valueOf(dateOccurred));
        item.setLocation(location);
        item.setImagePath(imagePath);
        item.setReporterId(admin.getUserId());

        if (new ItemDAO().postItem(item)) {
            response.sendRedirect(request.getContextPath()
                + "/admin?action=items&success=Item posted successfully!");
        } else {
            request.setAttribute("error", "Failed to post item.");
            request.setAttribute("categories", new CategoryDAO().getAllCategories());
            forward(request, response, "/views/admin/postitem.jsp");
        }
    }

    private void handleEditItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        Item item = new ItemDAO().getItemById(itemId);
        item.setTitle(request.getParameter("title"));
        item.setDescription(request.getParameter("description"));
        item.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        item.setLocation(request.getParameter("location"));
        item.setDateOccurred(Date.valueOf(request.getParameter("dateOccurred")));
        item.setItemType(request.getParameter("itemType"));
        new ItemDAO().updateItem(item);
        response.sendRedirect(request.getContextPath()
            + "/admin?action=items&success=Item updated successfully!");
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        new ItemDAO().deleteItem(itemId);
        response.sendRedirect(request.getContextPath()
            + "/admin?action=items&success=Item deleted");
    }

    private void resolveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        new ItemDAO().updateItemStatus(itemId, "RESOLVED");
        response.sendRedirect(request.getContextPath()
            + "/admin?action=items&success=Item marked as resolved");
    }

    // ============ CLAIMS ============
    private void showClaims(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("claims", new ClaimDAO().getAllClaims());
        forward(request, response, "/views/admin/manageclaims.jsp");
    }

    private void approveClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int claimId = Integer.parseInt(request.getParameter("id"));
        String remarks = request.getParameter("remarks");
        if (remarks == null || remarks.trim().isEmpty()) {
            remarks = "Claim approved by admin.";
        }
        ClaimDAO claimDAO = new ClaimDAO();
        Claim claim = claimDAO.getClaimById(claimId);
        claimDAO.updateClaimStatus(claimId, "APPROVED", remarks);
        // Also update item status
        new ItemDAO().updateItemStatus(claim.getItemId(), "CLAIMED");
        response.sendRedirect(request.getContextPath()
            + "/admin?action=claims&success=Claim approved!");
    }

    private void rejectClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int claimId = Integer.parseInt(request.getParameter("id"));
        String remarks = request.getParameter("remarks");
        if (remarks == null || remarks.trim().isEmpty()) {
            remarks = "Claim rejected by admin.";
        }
        new ClaimDAO().updateClaimStatus(claimId, "REJECTED", remarks);
        response.sendRedirect(request.getContextPath()
            + "/admin?action=claims&success=Claim rejected.");
    }

    private void forward(HttpServletRequest req, HttpServletResponse res, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, res);
    }
}