package com.cyl.manage.core.dao;

import com.cyl.manage.common.persistence.CrudDao;
import com.cyl.manage.common.persistence.annotation.MyBatisDao;
import com.cyl.manage.core.entity.Evaluation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@MyBatisDao
public interface EvaluationDao extends CrudDao<Evaluation> {

    List<Evaluation> findListExceptId(String id);

    int updateRanking(@Param("ranking") Integer ranking , @Param("id")String id );
}
