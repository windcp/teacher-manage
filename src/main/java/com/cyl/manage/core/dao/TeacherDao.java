package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Teacher;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@MyBatisDao
public interface TeacherDao extends CrudDao<Teacher>{

    int deleteTeacherCourse(String teacherId);

    int insertTeacherCourse(@Param(value = "courseIds") List<String> courseIds , @Param(value = "teacherId")String teacherId);

    int deleteTeacherClasses(String teacherId);

    int insertTeacherClasses(@Param(value = "classesIds") List<String> classesIds , @Param(value = "teacherId")String teacherId);

    List<Teacher> findListByNoEvaluation();
}
