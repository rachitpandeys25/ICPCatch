package com.icp.controller;

import com.icp.dao.ClaimDAO;
import com.icp.model.Claim;
import com.icp.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/claim"})
public class ClaimServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "myclaims":
                showMyClaims(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/item");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            submitClaim(request, response);
        }
    }

    private void showMyClaims(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        ClaimDAO claimDAO = new ClaimDAO();
        request.setAttribute("claims", claimDAO.getClaimsByUser(user.getUserId()));
        request.getRequestDispatcher("/views/student/myclaims.jsp")
               .forward(request, response);
    }

    private void submitClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        String proofDetails = request.getParameter("proofDetails");

        ClaimDAO claimDAO = new ClaimDAO();
        if (claimDAO.alreadyClaimed(itemId, user.getUserId())) {
            response.sendRedirect(request.getContextPath() 
                + "/item?action=detail&id=" + itemId + "&error=Already claimed");
            return;
        }

        Claim claim = new Claim();
        claim.setItemId(itemId);
        claim.setClaimantId(user.getUserId());
        claim.setProofDetails(proofDetails);

        claimDAO.submitClaim(claim);
        response.sendRedirect(request.getContextPath() 
            + "/claim?action=myclaims&success=Claim submitted!");
    }
}