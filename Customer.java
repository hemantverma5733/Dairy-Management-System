package com.smartdairy.entity;

public class Customer {
    private int id;
    private String name;
    private String mobile;
    private String address;
    private String customerType;
    private String status;

    public Customer() {}
    public Customer(int id, String name, String mobile, String address, String customerType, String status) {
        this.id=id; this.name=name; this.mobile=mobile; this.address=address; this.customerType=customerType; this.status=status;
    }
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getName(){return name;} public void setName(String v){this.name=v;}
    public String getMobile(){return mobile;} public void setMobile(String v){this.mobile=v;}
    public String getAddress(){return address;} public void setAddress(String v){this.address=v;}
    public String getCustomerType(){return customerType;} public void setCustomerType(String v){this.customerType=v;}
    public String getStatus(){return status;} public void setStatus(String v){this.status=v;}
}
