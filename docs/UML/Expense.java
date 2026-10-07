package com.smartdairy.entity;
import java.sql.Date;
public class Expense {
 private int id; private Date expenseDate; private String category,description,paymentMethod; private double amount;
 public int getId(){return id;} public void setId(int v){id=v;} public Date getExpenseDate(){return expenseDate;} public void setExpenseDate(Date v){expenseDate=v;} public String getCategory(){return category;} public void setCategory(String v){category=v;} public double getAmount(){return amount;} public void setAmount(double v){amount=v;} public String getDescription(){return description;} public void setDescription(String v){description=v;} public String getPaymentMethod(){return paymentMethod;} public void setPaymentMethod(String v){paymentMethod=v;}
}
