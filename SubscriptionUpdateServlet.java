package com.smartdairy.controller;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartdairy.service.SubscriptionService;

public class SubscriptionUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SubscriptionService service = new SubscriptionService();
    @Override protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        try {
            String end=request.getParameter("end_date");
            service.update(Integer.parseInt(request.getParameter("id")),Integer.parseInt(request.getParameter("customer_id")),Integer.parseInt(request.getParameter("product_id")),Double.parseDouble(request.getParameter("quantity")),request.getParameter("shift"),LocalDate.parse(request.getParameter("start_date")),end==null||end.isBlank()?null:LocalDate.parse(end),request.getParameter("status"),request.getParameter("remarks"));
            response.sendRedirect("subscription.jsp?updated=true");
        } catch(IllegalArgumentException e) { response.sendRedirect("subscription.jsp?error=validation"); }
          catch(Exception e) { e.printStackTrace(); response.sendRedirect("subscription.jsp?error=true"); }
    }
}
