package com.smartdairy.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartdairy.service.SubscriptionService;

public class SubscriptionDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SubscriptionService service = new SubscriptionService();
    @Override protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        try { service.delete(Integer.parseInt(request.getParameter("id"))); response.sendRedirect("subscription.jsp?deleted=true"); }
        catch(Exception e) { e.printStackTrace(); response.sendRedirect("subscription.jsp?error=true"); }
    }
}
