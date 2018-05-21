/**

 */
package com.cyl.manage.common.service;

import java.util.List;

import com.cyl.manage.common.persistence.BaseEntity;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.system.entity.Role;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import com.cyl.manage.system.entity.User;
import com.google.common.collect.Lists;

/**
 * Service基类
 * @author luochaoqun
 * @version 2014-05-16
 */
@Transactional(readOnly = true)
public abstract class BaseService {
	/**
	 * 日志对象
	 */
	protected Logger logger = LoggerFactory.getLogger(getClass());

}
