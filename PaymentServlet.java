package com.smartdairy.controller;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.smartdairy.service.PaymentService;

public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PaymentService service = new PaymentService();
    @Override protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            int customerId=Integer.parseInt(request.getParameter("customer_id"));
            String order=request.getParameter("order_id");
            Integer orderId=(order==null||order.isBlank())?null:Integer.valueOf(order);
            double amount=Double.parseDouble(request.getParameter("amount"));
            LocalDate date=LocalDate.parse(request.getParameter("payment_date"));
            service.receive(customerId,orderId,date,amount,request.getParameter("payment_method"),request.getParameter("transaction_reference"),request.getParameter("remarks"));
            response.sendRedirect("payment.jsp?success=true");
        } catch(IllegalArgumentException e) { response.sendRedirect("payment.jsp?error=validation"); }
          catch(Exception e) { e.printStackTrace(); response.sendRedirect("payment.jsp?error=true"); }
    }
}
