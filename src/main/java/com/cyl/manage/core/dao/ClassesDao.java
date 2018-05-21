package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Classes;

import java.util.List;

@MyBatisDao
public interface ClassesDao extends CrudDao<Classes> {
    List<Classes> findListExceptId(String id) ;
}
