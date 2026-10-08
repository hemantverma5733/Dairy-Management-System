package com.smartdairy.controller;

import com.smartdairy.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ProductDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductService service = new ProductService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try { service.delete(Integer.parseInt(request.getParameter("id"))); response.sendRedirect("ProductServlet?deleted=true"); }
        catch (Exception e) { response.sendRedirect("ProductServlet?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8")); }
    }
}
