/**

 */
package com.cyl.manage.system.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.system.entity.Log;

/**
 * 日志DAO接口
 * @author luochaoqun
 * @version 2014-05-16
 */
@MyBatisDao
public interface LogDao extends CrudDao<Log> {

}
