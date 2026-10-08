package com.smartdairy.controller;

import com.smartdairy.entity.Product;
import com.smartdairy.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductService service = new ProductService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("products", service.findAll());
            request.getRequestDispatcher("product.jsp").forward(request, response);
        } catch (Exception e) { throw new ServletException("Unable to load products", e); }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            Product p = new Product();
            p.setProductName(request.getParameter("product_name"));
            p.setCategory(request.getParameter("category"));
            p.setUnit(request.getParameter("unit"));
            p.setPurchasePrice(parseDouble(request.getParameter("purchase_price"), 0));
            p.setSellingPrice(parseDouble(request.getParameter("selling_price"), 0));
            p.setStock(parseDouble(request.getParameter("stock"), 0));
            p.setMinimumStock(parseDouble(request.getParameter("minimum_stock"), 0));
            p.setStatus(request.getParameter("status"));
            service.create(p);
            response.sendRedirect("ProductServlet?success=true");
        } catch (Exception e) { response.sendRedirect("ProductServlet?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8")); }
    }

    private double parseDouble(String value, double fallback) {
        return value == null || value.trim().isEmpty() ? fallback : Double.parseDouble(value);
    }
}
