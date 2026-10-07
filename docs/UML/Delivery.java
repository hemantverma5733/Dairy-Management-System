package com.smartdairy.entity;
import java.sql.Date;
public class Delivery {
 private int id,orderId; private String deliveryPerson,mobile,vehicleNumber,route,status,remarks; private Date deliveryDate;
 public int getId(){return id;} public void setId(int v){id=v;} public int getOrderId(){return orderId;} public void setOrderId(int v){orderId=v;} public String getDeliveryPerson(){return deliveryPerson;} public void setDeliveryPerson(String v){deliveryPerson=v;} public String getMobile(){return mobile;} public void setMobile(String v){mobile=v;} public String getVehicleNumber(){return vehicleNumber;} public void setVehicleNumber(String v){vehicleNumber=v;} public Date getDeliveryDate(){return deliveryDate;} public void setDeliveryDate(Date v){deliveryDate=v;} public String getRoute(){return route;} public void setRoute(String v){route=v;} public String getStatus(){return status;} public void setStatus(String v){status=v;} public String getRemarks(){return remarks;} public void setRemarks(String v){remarks=v;}
}
