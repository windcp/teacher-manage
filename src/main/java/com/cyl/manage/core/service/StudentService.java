package com.cyl.manage.core.service;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.core.dao.CourseDao;
import com.cyl.manage.core.dao.StudentDao;
import com.cyl.manage.core.entity.Course;
import com.cyl.manage.core.entity.Student;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class StudentService extends CrudService<StudentDao,Student>{

    @Override
    @Transactional(readOnly = false)
    public void save(Student student) {
        if(StringUtils.isNotBlank(student.getId())){
            student.preUpdate();
            dao.update(student);
            dao.deleteStudentClasses(student.getId());
            dao.insertStudentClasses(student.getId(),student.getClasses().getId());
        }else{
            student.preInsert();
            dao.insert(student);
            dao.insertStudentClasses(student.getId(),student.getClasses().getId());
        }
    }


    public Page<Student> findPage(Page<Student> page, Student student, List<String> classesIds) {
        student.setPage(page);
        page.setList(dao.findListByClassesIds(classesIds));
        return page;
    }

      public List<Student> findListByClassesIds(List<String> classesIds){
        return dao.findListByClassesIds(classesIds);
      }

    /**
     * 根据学号获取学生信息
     * @param student
     * @return
     */
      public Student getByStudentNo(String studentNo){
        return dao.getByStudentNo(studentNo);
      }
}
