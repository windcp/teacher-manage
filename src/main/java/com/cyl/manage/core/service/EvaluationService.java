package com.cyl.manage.core.service;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.core.dao.EvaluationDao;
import com.cyl.manage.core.entity.Evaluation;
import com.cyl.manage.core.entity.Grade;
import com.google.common.collect.Lists;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class EvaluationService extends CrudService<EvaluationDao, Evaluation> {

    @Transactional(readOnly = false)
    public void  updateRanking(){
        List<Evaluation> list = calculateRanking() ;
        list.stream().forEach(e -> {
            dao.updateRanking(e.getRanking(),e.getId());
        });
    }


    public List<Evaluation> calculateRanking(){
        List<Evaluation> list = dao.findAllList()  ;
        List<Integer> scoreList = list.stream().map(Evaluation::getScore).collect(Collectors.toList());
        List<Evaluation> rtnList = Lists.newArrayList() ;
        list.stream().forEach(e -> {
           long ranking =   scoreList.stream().filter(score -> e.getScore() < score).count();
            e.setRanking(ranking == 0 ?1:((int)ranking +1) );
           rtnList.add(e);
        });
        return rtnList;
    }


}
