package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;
import com.cyl.manage.system.entity.User;
import com.google.common.collect.Lists;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

public class Teacher extends DataEntity<Teacher> implements Serializable{

    private static final long serialVersionUID = 1L;

    private String name ; //姓名

    private Integer age ; //年龄

    private Integer sex ; //性别 (1 : 男 ; 2:女; 3 : 未知)

    private String identity ;  //身份

    private String courses ; //教授课程

    private String courseIds ;

    private List<Course> courseList = Lists.newArrayList();

    private String classeses ; //教授班级

    private String classesIds;

    private List<Classes> classesList = Lists.newArrayList();

    private Evaluation evaluation ; //评价

    private String education ; //学历

    private String phone ; //联系电话

    private String thesis ; //论文发表

    private String awards ; //所获奖项

    private User user ;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getIdentity() {
        return identity;
    }

    public void setIdentity(String identity) {
        this.identity = identity;
    }

    public String getCourses() {
        return courseList.stream().map(Course::getName).collect(Collectors.joining(","));
    }

    public void setCourses(String courses) {
        this.courses = courses;
    }

    public String getClasseses() {
        return classesList.stream().map(Classes::getName).collect(Collectors.joining(","));
    }

    public void setClasseses(String classeses) {
        this.classeses = classeses;
    }

    public List<Course> getCourseList() {
        return courseList;
    }

    public void setCourseList(List<Course> courseList) {
        this.courseList = courseList;
    }

    public List<Classes> getClassesList() {
        return classesList;
    }

    public void setClassesList(List<Classes> classesList) {
        this.classesList = classesList;
    }

    public List<String> getCourseIdsList() {
        return courseList.stream().map(Course::getId).collect(Collectors.toList());
    }

    public List<String> getClassesIdsList() {
        return classesList.stream().map(Classes::getId).collect(Collectors.toList());
    }

    public void setCourseIdsList(List<String> courseIdsList) {
        courseList = Lists.newArrayList() ;
        for(String id : courseIdsList){
            Course  c = new Course() ;
            c.setId(id);
            courseList.add(c);
        }
    }

    public void setClassesIdsList(List<String> classesIdsList) {
        classesList = Lists.newArrayList() ;
        for(String id : classesIdsList){
            Classes c = new Classes() ;
            c.setId(id);
            classesList.add(c);
        }
    }

    public String getCourseIds() {
        return courseList.stream().map(Course::getId).collect(Collectors.joining(","));
    }

    public void setCourseIds(String courseIds) {
        this.courseIds = courseIds;
    }

    public String getClassesIds() {
        return classesList.stream().map(Classes::getId).collect(Collectors.joining(","));
    }
    public void setClassesIds(String classesIds) {
        this.classesIds = classesIds;
    }

    public String getEducation() {
        return education;
    }

    public void setEducation(String education) {
        this.education = education;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getThesis() {
        return thesis;
    }

    public void setThesis(String thesis) {
        this.thesis = thesis;
    }

    public String getAwards() {
        return awards;
    }

    public void setAwards(String awards) {
        this.awards = awards;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Evaluation getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(Evaluation evaluation) {
        this.evaluation = evaluation;
    }

    @Override
    public String toString() {
        return "Teacher{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", sex=" + sex +
                ", identity='" + identity + '\'' +
                ", courses='" + courses + '\'' +
                ", education='" + education + '\'' +
                ", phone='" + phone + '\'' +
                ", thesis='" + thesis + '\'' +
                ", awards='" + awards + '\'' +
                ", user=" + user +
                ", evaluation=" + evaluation +
                '}';
    }
}
