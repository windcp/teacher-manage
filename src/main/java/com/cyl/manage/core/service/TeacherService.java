package com.cyl.manage.core.service;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.core.dao.TeacherDao;
import com.cyl.manage.core.entity.Teacher;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.service.SystemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class TeacherService extends CrudService<TeacherDao,Teacher> {

    @Autowired
    private SystemService systemService ;

    @Override
    @Transactional(readOnly = false)
    public void save(Teacher teacher){
        User user = teacher.getUser() ;
        if(StringUtils.isNotBlank(teacher.getId())){
            teacher.preUpdate();
            dao.update(teacher);
            dao.deleteTeacherCourse(teacher.getId());
            dao.insertTeacherCourse(teacher.getCourseIdsList(),teacher.getId());
            dao.deleteTeacherClasses(teacher.getId());
            dao.insertTeacherClasses(teacher.getClassesIdsList(),teacher.getId());
        }else{
            teacher.preInsert();
            dao.insert(teacher);
            dao.insertTeacherCourse(teacher.getCourseIdsList(),teacher.getId());
            dao.insertTeacherClasses(teacher.getClassesIdsList(),teacher.getId());
            user.setTeacherId(teacher.getId());
        }
        if(user != null ){
            systemService.saveUser(user);
        }
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Teacher teacher){
        dao.deleteTeacherCourse(teacher.getId());
        dao.delete(teacher);
    }

    /**
     * 查询分页数据
     * @param page 分页对象
     * @param teacher
     * @return
     */
    @Override
    public Page<Teacher> findPage(Page<Teacher> page, Teacher teacher) {
        int amount = dao.count(teacher);
        teacher.setPage(page);
        page.setList(dao.findList(teacher));
        page.setCount(amount);
        return page;
    }

}
