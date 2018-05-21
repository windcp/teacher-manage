package com.cyl.manage.core.service;

import com.cyl.manage.common.service.BaseService;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.core.entity.Classes;
import com.cyl.manage.core.entity.Course;
import com.cyl.manage.core.entity.Student;
import com.cyl.manage.core.entity.Teacher;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.utils.UserUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class CoreService extends BaseService implements InitializingBean {

    @Autowired
    private ClassesService classesService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private StudentService studentService;

    /**
     * 获取课程列表
     */
    public List<Course> getCourseList(){
        //获取当前用户
        User user = UserUtils.getUser();
        //当前用户是否是老师
        Teacher teacher = teacherService.get(user.getTeacherId());
        List<Course> courseList = null;
        if (teacher != null) {
            //获取当前老师所授课班级id集合
            courseList = teacher.getCourseList();
        }else{
            courseList = courseService.findAllList();
        }
        return courseList;
    }

    /**
     * 获取班级列表
     * @return
     */
    public List<Classes> getClassesList(){
        //获取当前用户
        User user = UserUtils.getUser();
        //当前用户是否是老师
        Teacher teacher = teacherService.get(user.getTeacherId());
        List<Classes> classesList = null;
        if (teacher != null) {
            //获取当前老师所授课班级id集合
            classesList = teacher.getClassesList();
        }else{
            classesList = classesService.findAllList();
        }
        return classesList;
    }

    /**
     * 获取学生列表
     * @return
     */
    public List<Student> getStudentList(String classesId){
        List<Student> studentList = null;
        if(StringUtils.isNotBlank(classesId)){
            List<String> classesIds = new ArrayList<String>();
            classesIds.add(classesId);
            studentList = studentService.findListByClassesIds(classesIds);
        }else {
            studentList = studentService.findAllList();
        }
        return studentList;
    }


    @Override
    public void afterPropertiesSet() throws Exception {

    }
}
