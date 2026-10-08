package com.smartdairy.controller;
import com.smartdairy.service.CustomerService; import jakarta.servlet.ServletException; import jakarta.servlet.http.*; import java.io.IOException;
public class CustomerDeleteServlet extends HttpServlet { private final CustomerService service=new CustomerService();
 protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{try{service.delete(Integer.parseInt(req.getParameter("id")));resp.sendRedirect("customer.jsp?deleted=true");}catch(Exception e){getServletContext().log("Customer delete failed",e);resp.sendRedirect("customer.jsp?error="+java.net.URLEncoder.encode(e.getMessage()==null?"Unable to delete customer":e.getMessage(),"UTF-8"));}}
}
