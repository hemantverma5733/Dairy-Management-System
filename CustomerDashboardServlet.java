package com.smartdairy.controller;
import com.smartdairy.service.CustomerService; import jakarta.servlet.ServletException; import jakarta.servlet.http.*; import java.io.IOException;
public class CustomerDashboardServlet extends HttpServlet { private final CustomerService service=new CustomerService();
 protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{try{req.setAttribute("activeCustomers",service.countActive());req.setAttribute("totalCustomers",service.countAll());req.getRequestDispatcher("customer_dashboard.jsp").forward(req,resp);}catch(Exception e){throw new ServletException("Unable to load customer dashboard",e);}}
}
