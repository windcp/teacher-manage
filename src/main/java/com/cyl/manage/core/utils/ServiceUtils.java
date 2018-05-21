package com.cyl.manage.core.utils;

import com.cyl.manage.common.utils.SpringContextHolder;
import com.cyl.manage.core.dao.TeacherDao;
import com.cyl.manage.core.entity.Teacher;

import java.util.List;

/**
 * 业务方法
 */
public class ServiceUtils {

    private static TeacherDao teacherDao = SpringContextHolder.getBean(TeacherDao.class) ;

    public static List<Teacher> findAllTeachers(){
        return teacherDao.findAllList() ;
    }

    public static List<Teacher> findListByNoEvaluation(){return teacherDao.findListByNoEvaluation() ;}

}
