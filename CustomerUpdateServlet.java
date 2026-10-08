package com.smartdairy.controller;
import com.smartdairy.entity.Customer; import com.smartdairy.service.CustomerService; import jakarta.servlet.ServletException; import jakarta.servlet.http.*; import java.io.IOException;
public class CustomerUpdateServlet extends HttpServlet { private final CustomerService service=new CustomerService();
 protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{req.setCharacterEncoding("UTF-8"); try{Customer c=new Customer(Integer.parseInt(req.getParameter("id")),req.getParameter("name"),req.getParameter("mobile"),req.getParameter("address"),req.getParameter("customer_type"),req.getParameter("status")); service.update(c); resp.sendRedirect("customer.jsp?updated=true");}catch(Exception e){getServletContext().log("Customer update failed",e);resp.sendRedirect("customer.jsp?error="+java.net.URLEncoder.encode(e.getMessage()==null?"Unable to update customer":e.getMessage(),"UTF-8"));}}
}
