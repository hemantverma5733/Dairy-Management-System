package com.smartdairy.controller;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartdairy.service.OrderService;

public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OrderService service = new OrderService();
    @Override protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            int customerId=Integer.parseInt(request.getParameter("customer_id"));
            int productId=Integer.parseInt(request.getParameter("product_id"));
            double quantity=Double.parseDouble(request.getParameter("quantity"));
            LocalDate date=LocalDate.parse(request.getParameter("order_date"));
            service.placeOrder(customerId,productId,quantity,date,request.getParameter("status"),request.getParameter("payment_status"),request.getParameter("remarks"));
            response.sendRedirect("order.jsp?success=true");
        } catch(IllegalArgumentException e) { response.sendRedirect("order.jsp?error=validation"); }
          catch(Exception e) { e.printStackTrace(); response.sendRedirect("order.jsp?error=true"); }
    }
}
