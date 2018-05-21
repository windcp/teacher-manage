package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;

import java.io.Serializable;

public class Course extends DataEntity<Course> implements Serializable{

    private static final long serialVersionUID = 1L;

    //课程名
    private String name ;

    //学分
    private String  credit;

    //开课学期
    private String term ;

    //教室
    private String classRoom ;

    //人数
    private Integer amount ;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCredit() {
        return credit;
    }

    public void setCredit(String credit) {
        this.credit = credit;
    }

    public String getTerm() {
        return term;
    }

    public void setTerm(String term) {
        this.term = term;
    }

    public String getClassRoom() {
        return classRoom;
    }

    public void setClassRoom(String classRoom) {
        this.classRoom = classRoom;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }


    @Override
    public String toString() {
        return "Course{" +
                "name='" + name + '\'' +
                ", credit='" + credit + '\'' +
                ", term='" + term + '\'' +
                ", classRoom='" + classRoom + '\'' +
                ", amount=" + amount +
                '}';
    }
}
