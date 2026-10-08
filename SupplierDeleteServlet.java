package com.smartdairy.controller;
import com.smartdairy.service.SupplierService; import jakarta.servlet.*; import jakarta.servlet.http.*; import java.io.IOException;
public class SupplierDeleteServlet extends HttpServlet {private final SupplierService service=new SupplierService(); protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{try{service.delete(Integer.parseInt(req.getParameter("id")));resp.sendRedirect("supplier.jsp?deleted=true");}catch(Exception e){resp.sendRedirect("supplier.jsp?error=true");}}}
