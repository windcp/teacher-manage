package com.cyl.manage.core.service;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.core.dao.CourseDao;
import com.cyl.manage.core.entity.Course;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class CourseService extends CrudService<CourseDao,Course>{
}
