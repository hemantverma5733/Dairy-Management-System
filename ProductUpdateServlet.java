package com.smartdairy.controller;

import com.smartdairy.entity.Product;
import com.smartdairy.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ProductUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductService service = new ProductService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Product p = new Product();
            p.setId(Integer.parseInt(request.getParameter("id")));
            p.setProductName(request.getParameter("product_name")); p.setCategory(request.getParameter("category")); p.setUnit(request.getParameter("unit"));
            p.setPurchasePrice(Double.parseDouble(request.getParameter("purchase_price")));
            p.setSellingPrice(Double.parseDouble(request.getParameter("selling_price")));
            p.setStock(Double.parseDouble(request.getParameter("stock")));
            p.setMinimumStock(Double.parseDouble(request.getParameter("minimum_stock")));
            p.setStatus(request.getParameter("status"));
            service.update(p);
            response.sendRedirect("ProductServlet?updated=true");
        } catch (Exception e) { response.sendRedirect("ProductServlet?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8")); }
    }
}
