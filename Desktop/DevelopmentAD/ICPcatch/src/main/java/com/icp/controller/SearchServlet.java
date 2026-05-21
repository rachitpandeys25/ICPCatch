package com.icp.controller;

import com.icp.dao.CategoryDAO;
import com.icp.dao.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        ItemDAO itemDAO = new ItemDAO();
        request.setAttribute("items", 
            itemDAO.searchItems(keyword, category, type, dateFrom, dateTo));
        request.setAttribute("categories", 
            new CategoryDAO().getAllCategories());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedType", type);

        request.getRequestDispatcher("/views/shared/search.jsp")
               .forward(request, response);
    }
}