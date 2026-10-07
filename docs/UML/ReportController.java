package com.smartdairy.controller;
import com.smartdairy.service.ReportService; import jakarta.servlet.*; import jakarta.servlet.http.*; import java.io.IOException;
public class ReportController extends HttpServlet{private final ReportService service=new ReportService(); protected void doGet(HttpServletRequest r,HttpServletResponse s)throws ServletException,IOException{try{r.setAttribute("reportSummary",service.getSummary());r.getRequestDispatcher("reports.jsp").forward(r,s);}catch(Exception e){throw new ServletException("Unable to load reports",e);}}}
