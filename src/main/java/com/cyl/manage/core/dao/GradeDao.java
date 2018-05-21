package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Grade;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@MyBatisDao
public interface GradeDao extends CrudDao<Grade> {

    List<Grade> findListExceptId(String id) ;

    int updateRanking(@Param("ranking") Integer ranking , @Param("id")String id);

    int deleteGradeCourse(String gradeId);

    int insertGradeCourse(@Param(value = "gradeId") String gradeId , @Param(value = "courseId")String courseId);


    int deleteStudentGrade(String gradeId);

    int insertStudentGrade(@Param(value = "studentId")String studentId, @Param(value = "gradeId") String gradeId);

}
