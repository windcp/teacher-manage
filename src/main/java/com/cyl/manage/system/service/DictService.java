/**

 */
package com.cyl.manage.system.service;

import java.util.List;

import com.cyl.manage.system.dao.DictDao;
import com.cyl.manage.system.entity.Dict;
import com.cyl.manage.system.utils.DictUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.common.utils.CacheUtils;

/**
 * 字典Service
 * @author luochaoqun
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {
	
	/**
	 * 查询字段类型列表
	 * @return
	 */
	public List<String> findTypeList(){
		return dao.findTypeList(new Dict());
	}

	@Override
	@Transactional(readOnly = false)
	public void save(Dict dict) {
		super.save(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

	@Override
	@Transactional(readOnly = false)
	public void delete(Dict dict) {
		super.delete(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

}
