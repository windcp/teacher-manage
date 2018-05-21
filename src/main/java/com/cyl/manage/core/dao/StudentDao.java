package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Course;
import com.cyl.manage.core.entity.Student;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@MyBatisDao
public interface StudentDao extends CrudDao<Student> {

    int deleteStudentClasses(String studentId);

    int insertStudentClasses(@Param(value = "studentId") String studentId , @Param(value = "classesId")String classesId);

    List<Student> findList(Student student, @Param(value = "classesIds") List<String> classesIds);

    List<Student> findListByClassesIds(@Param(value = "classesIds") List<String> classesIds);

    Student getByStudentNo(String studentNo);
}
