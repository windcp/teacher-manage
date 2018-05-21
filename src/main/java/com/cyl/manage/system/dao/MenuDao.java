/**

 */
package com.cyl.manage.system.dao;

import java.util.List;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.system.entity.Menu;

/**
 * 菜单DAO接口
 * @author luochaoqun
 * @version 2014-05-16
 */
@MyBatisDao
public interface MenuDao extends CrudDao<Menu> {

	public List<Menu> findByParentIdsLike(Menu menu);

	public List<Menu> findByUserId(Menu menu);
	
	public int updateParentIds(Menu menu);
	
	public int updateSort(Menu menu);

	int deleteRoleMenuByMenuId(String menuId);
	
}
