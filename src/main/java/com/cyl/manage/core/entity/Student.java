package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;
import com.cyl.manage.common.utils.StringUtils;

import java.io.Serializable;

/**
 * 学生实体类
 */
public class Student extends DataEntity<Student> implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;//姓名

    private String studentNo;//学号

    private Integer age ; //年龄

    private Integer sex ; //性别 (1 : 男 ; 2:女; 3 : 未知)

    private Double point; //总绩点

    private Integer grades; //获得总学分

    private Classes classes; //所在班级

    private String classesId;//班级id

    public String getClassesId() {
            return classesId;
    }

    public void setClassesId(String classesId) {
        this.classesId = classesId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStudentNo() {
        return studentNo;
    }

    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public Double getPoint() {
        return point;
    }

    public void setPoint(Double point) {
        this.point = point;
    }

    public Integer getGrades() {
        return grades;
    }

    public void setGrades(Integer grades) {
        this.grades = grades;
    }

    public Classes getClasses() {
        return classes;
    }

    public void setClasses(Classes classes) {
        this.classes = classes;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", studentNo='" + studentNo + '\'' +
                ", age=" + age +
                ", sex=" + sex +
                ", point=" + point +
                ", grade=" + grades +
                '}';
    }
}
