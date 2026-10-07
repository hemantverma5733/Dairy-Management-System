package com.smartdairy.entity;
public class Distributor {
 private int id; private String name,mobile,shopName,address,area,status;
 public Distributor() {}
 public Distributor(int id,String name,String mobile,String shopName,String address,String area,String status){this.id=id;this.name=name;this.mobile=mobile;this.shopName=shopName;this.address=address;this.area=area;this.status=status;}
 public int getId(){return id;} public void setId(int v){id=v;} public String getName(){return name;} public void setName(String v){name=v;} public String getMobile(){return mobile;} public void setMobile(String v){mobile=v;} public String getShopName(){return shopName;} public void setShopName(String v){shopName=v;} public String getAddress(){return address;} public void setAddress(String v){address=v;} public String getArea(){return area;} public void setArea(String v){area=v;} public String getStatus(){return status;} public void setStatus(String v){status=v;}
}
