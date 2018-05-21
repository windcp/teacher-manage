package com.cyl.manage.core.utils;

/**
 * 绩点计算工具类
 */
public class PointUtil {

    public static double getPoint(int amount){
        double point = 0.0;
       if(amount >= 90 && amount <= 100){
               point = 4.0;
       }else  if(amount >= 85 && amount < 90){
           point = 3.7;
       }else  if(amount >= 82 && amount < 85){
           point = 3.3;
       }else  if(amount >= 78 && amount < 82){
           point = 3.0;
       }else  if(amount >= 75 && amount < 78){
           point = 2.7;
       }else  if(amount >= 72 && amount < 75){
           point = 2.3;
       }else  if(amount >= 68 && amount <= 72){
           point = 2.0;
       }else  if(amount >= 64 && amount <= 68){
           point = 1.5;
       }else  if(amount >= 60 && amount < 64){
           point = 1.0;
       }else {
           point = 0.0;
       }
       return point;
    }
}
