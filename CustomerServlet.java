package com.smartdairy.controller;

import com.smartdairy.entity.Customer;
import com.smartdairy.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CustomerServlet extends HttpServlet {
    private final CustomerService service=new CustomerService();
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        req.setCharacterEncoding("UTF-8");
        try { Customer c=new Customer(0,req.getParameter("name"),req.getParameter("mobile"),req.getParameter("address"),req.getParameter("customer_type"),req.getParameter("status")); service.create(c); resp.sendRedirect("customer.jsp?success=true"); }
        catch(Exception e){ getServletContext().log("Customer create failed",e); resp.sendRedirect("customer.jsp?error="+java.net.URLEncoder.encode(e.getMessage()==null?"Unable to save customer":e.getMessage(),"UTF-8")); }
    }
}
