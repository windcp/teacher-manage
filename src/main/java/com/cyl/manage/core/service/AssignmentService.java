package com.cyl.manage.core.service;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.core.dao.AssignmentDao;
import com.cyl.manage.core.entity.Assignment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class AssignmentService extends CrudService<AssignmentDao, Assignment> {
}
