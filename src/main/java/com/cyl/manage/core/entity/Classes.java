package com.cyl.manage.core.entity;

import com.cyl.manage.common.persistence.DataEntity;

import java.io.Serializable;
import java.util.List;

/**
 * 班级实体类
 */
public class Classes extends DataEntity<Classes> implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;//班级名称

    private List<Grade> courseList;

    public Classes() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Grade> getCourseList() {
        return courseList;
    }

    public void setCourseList(List<Grade> courseList) {
        this.courseList = courseList;
    }

    @Override
    public String toString() {
        return "Classes{" +
                "name='" + name + '\'' +
                '}';
    }
}
