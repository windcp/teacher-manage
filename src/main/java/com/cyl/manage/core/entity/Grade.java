package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;

import java.io.Serializable;

public class Grade extends DataEntity<Grade> implements Serializable {

    private static final long serialVersionUID = 1L;

  /*  //学生学号
    private String studentNo ;

    //学生姓名
    private String studentName ;*/
    //学生
    private Student student = new Student();

    //课程
    private Course course ;

    //班级
    private Classes classes = new Classes();

    //卷面分
    private Integer paperScore ;

    //平时成绩
    private Integer extraScore ;

    //总成绩
    private Integer amount ;

    //获得绩点
    private Double point;

    //获得学分
    private Integer credit;

    //排名
    private Integer ranking ;

    /*public String getStudentNo() {
        return studentNo;
    }

    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }*/

    public Integer getCredit() {
        return credit;
    }

    public void setCredit(Integer credit) {
        this.credit = credit;
    }

    public Integer getPaperScore() {
        return paperScore;
    }

    public void setPaperScore(Integer paperScore) {
        this.paperScore = paperScore;
    }

    public Integer getExtraScore() {
        return extraScore;
    }

    public void setExtraScore(Integer extraScore) {
        this.extraScore = extraScore;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public Integer getRanking() {
        return ranking;
    }

    public void setRanking(Integer ranking) {
        this.ranking = ranking;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Double getPoint() {
        return point;
    }

    public void setPoint(Double point) {
        this.point = point;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Classes getClasses() {
        return classes;
    }

    public void setClasses(Classes classes) {
        this.classes = classes;
    }

    @Override
    public String toString() {
        return "Grade{" +
/*                "studentNo='" + studentNo + '\'' +
                ", studentName='" + studentName + '\'' +*/
                ", course=" + course +
                ", paperScore=" + paperScore +
                ", extraScore=" + extraScore +
                ", amount=" + amount +
                ", point=" + point +
                ", ranking=" + ranking +
                '}';
    }
}
