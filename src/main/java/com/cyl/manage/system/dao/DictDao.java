/**

 */
package com.cyl.manage.system.dao;

import java.util.List;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.system.entity.Dict;

/**
 * 字典DAO接口
 * @author luochaoqun
 * @version 2014-05-16
 */
@MyBatisDao
public interface DictDao extends CrudDao<Dict> {

	public List<String> findTypeList(Dict dict);
	
}
