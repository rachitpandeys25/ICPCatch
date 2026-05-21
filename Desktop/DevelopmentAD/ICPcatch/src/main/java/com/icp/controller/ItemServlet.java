package com.icp.controller;

import com.icp.dao.CategoryDAO;
import com.icp.dao.ItemDAO;
import com.icp.model.Item;
import com.icp.model.User;
import com.icp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/item"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "report":
                showReportForm(request, response);
                break;
            case "detail":
                showItemDetail(request, response);
                break;
            case "myitems":
                showMyItems(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            case "resolve":
                resolveItem(request, response);
                break;
            default:
                showAllItems(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "report":
                handleReport(request, response);
                break;
            case "edit":
                handleEdit(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/item");
        }
    }

    private void showAllItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ItemDAO itemDAO = new ItemDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("items", itemDAO.getAllItems());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/views/shared/itemlist.jsp")
               .forward(request, response);
    }

    private void showReportForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("type", request.getParameter("type"));
        request.getRequestDispatcher("/views/student/reportitem.jsp")
               .forward(request, response);
    }

    private void showItemDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        ItemDAO itemDAO = new ItemDAO();
        Item item = itemDAO.getItemById(itemId);
        request.setAttribute("item", item);
        request.getRequestDispatcher("/views/shared/itemdetail.jsp")
               .forward(request, response);
    }

    private void showMyItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        ItemDAO itemDAO = new ItemDAO();
        request.setAttribute("items", itemDAO.getItemsByUser(user.getUserId()));
        request.getRequestDispatcher("/views/student/myitems.jsp")
               .forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        ItemDAO itemDAO = new ItemDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("item", itemDAO.getItemById(itemId));
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/views/student/edititem.jsp")
               .forward(request, response);
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        new ItemDAO().deleteItem(itemId);
        response.sendRedirect(request.getContextPath() + "/item?action=myitems");
    }

    private void resolveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("id"));
        new ItemDAO().updateItemStatus(itemId, "RESOLVED");
        response.sendRedirect(request.getContextPath() + "/item?action=myitems");
    }

    private void handleReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryId = request.getParameter("categoryId");
        String itemType = request.getParameter("itemType");
        String dateOccurred = request.getParameter("dateOccurred");
        String location = request.getParameter("location");
    

        if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isNotEmpty(location)
                || !ValidationUtil.isNotEmpty(dateOccurred)) {
            request.setAttribute("error", "Please fill all required fields.");
            showReportForm(request, response);
            return;
        }

        // Handle image upload
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

        Item item = new Item();
        item.setTitle(title);
        item.setDescription(description);
        item.setCategoryId(Integer.parseInt(categoryId));
        item.setItemType(itemType);
        item.setDateOccurred(Date.valueOf(dateOccurred));
        item.setLocation(location);
        item.setImagePath(imagePath);
        item.setReporterId(user.getUserId());

        if (new ItemDAO().postItem(item)) {
            response.sendRedirect(request.getContextPath() 
                                 + "/item?action=myitems&success=Item reported successfully!");
        } else {
            request.setAttribute("error", "Failed to report item. Try again.");
            showReportForm(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        Item item = new ItemDAO().getItemById(itemId);
        item.setTitle(request.getParameter("title"));
        item.setDescription(request.getParameter("description"));
        item.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        item.setLocation(request.getParameter("location"));
        item.setDateOccurred(Date.valueOf(request.getParameter("dateOccurred")));
        new ItemDAO().updateItem(item);
        response.sendRedirect(request.getContextPath() + "/item?action=myitems");
    }
}