package com.cyl.manage.core.service;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.core.dao.ClassesDao;
import com.cyl.manage.core.entity.Classes;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.util.List;
@Service
@Transactional(readOnly = true)
public class ClassesService extends CrudService<ClassesDao,Classes> {

    public List<Classes> findListExceptId(String id){ return  dao.findListExceptId(id);}

}
