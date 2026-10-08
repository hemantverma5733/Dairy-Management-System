package com.smartdairy.entity;

import java.time.LocalDate;

public class MilkCollection {
    private int id; private LocalDate collectionDate; private String supplierName, shift, animalType;
    private double quantity, fat, snf, rate, amount;
    public int getId(){return id;} public void setId(int v){id=v;}
    public LocalDate getCollectionDate(){return collectionDate;} public void setCollectionDate(LocalDate v){collectionDate=v;}
    public String getSupplierName(){return supplierName;} public void setSupplierName(String v){supplierName=v;}
    public String getShift(){return shift;} public void setShift(String v){shift=v;}
    public String getAnimalType(){return animalType;} public void setAnimalType(String v){animalType=v;}
    public double getQuantity(){return quantity;} public void setQuantity(double v){quantity=v;}
    public double getFat(){return fat;} public void setFat(double v){fat=v;}
    public double getSnf(){return snf;} public void setSnf(double v){snf=v;}
    public double getRate(){return rate;} public void setRate(double v){rate=v;}
    public double getAmount(){return amount;} public void setAmount(double v){amount=v;}
}
