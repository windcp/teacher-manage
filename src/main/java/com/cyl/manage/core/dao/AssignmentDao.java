package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Assignment;

@MyBatisDao
public interface AssignmentDao extends CrudDao<Assignment> {
}
