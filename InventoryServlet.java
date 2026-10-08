package com.smartdairy.controller;

import com.smartdairy.entity.InventoryTransaction;
import com.smartdairy.service.InventoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

public class InventoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final InventoryService service = new InventoryService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("products", service.findProducts());
            request.setAttribute("transactions", service.findAll());
            request.getRequestDispatcher("inventory.jsp").forward(request, response);
        } catch (Exception e) { throw new ServletException("Unable to load inventory", e); }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            InventoryTransaction t = new InventoryTransaction();
            t.setProductId(Integer.parseInt(request.getParameter("product_id")));
            t.setTransactionType(request.getParameter("transaction_type"));
            t.setQuantity(Double.parseDouble(request.getParameter("quantity")));
            t.setReferenceType(request.getParameter("reference_type"));
            String ref = request.getParameter("reference_id");
            if (ref != null && !ref.trim().isEmpty()) t.setReferenceId(Integer.parseInt(ref));
            String date = request.getParameter("transaction_date");
            if (date != null && !date.trim().isEmpty()) t.setTransactionDate(Timestamp.valueOf(date.replace("T", " ") + (date.length() == 16 ? ":00" : "")));
            t.setRemarks(request.getParameter("remarks"));
            service.recordTransaction(t);
            response.sendRedirect("InventoryServlet?success=true");
        } catch (Exception e) { response.sendRedirect("InventoryServlet?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8")); }
    }
}
