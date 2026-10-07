package com.smartdairy.service; import com.smartdairy.entity.ReportSummary; import com.smartdairy.repository.ReportRepository; import java.sql.SQLException;
public class ReportService{private final ReportRepository repo=new ReportRepository(); public ReportSummary getSummary()throws Exception{return repo.summary();}}
