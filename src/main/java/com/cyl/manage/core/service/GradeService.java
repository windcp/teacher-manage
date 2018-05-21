package com.cyl.manage.core.service;

import com.cyl.manage.common.service.CrudService;
import com.cyl.manage.common.utils.DateUtils;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.utils.excel.ExportExcel;
import com.cyl.manage.core.dao.GradeDao;
import com.cyl.manage.core.entity.Grade;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.poi.ss.usermodel.Row;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class GradeService extends CrudService<GradeDao, Grade> {

    public List<Grade> findListExceptId(String id){ return  dao.findListExceptId(id);}

    @Transactional(readOnly = false)
    public void updateRanking(){
        List<Grade> list = calculateRanking() ;
        list.stream().forEach(g -> {
            dao.updateRanking(g.getRanking(),g.getId());
        });

    }

    /**
     *
     * @param grade
     */
    @Override
    @Transactional(readOnly = false)
    public void save(Grade grade) {
        if(StringUtils.isNotBlank(grade.getId())){
            grade.preUpdate();
            dao.update(grade);
            dao.deleteGradeCourse(grade.getId());
            dao.insertGradeCourse(grade.getId(),grade.getCourse().getId());
            dao.deleteStudentGrade(grade.getId());
            dao.insertStudentGrade(grade.getStudent().getId(),grade.getId());
        }else{
            grade.preInsert();
            dao.insert(grade);
            dao.insertGradeCourse(grade.getId(),grade.getCourse().getId());
            dao.insertStudentGrade(grade.getStudent().getId(),grade.getId());
        }
    }

    public List<Grade> calculateRanking(){
        List<Grade> list = dao.findAllList()  ;
        List<Integer> scoreList = list.stream().map(Grade::getAmount).collect(Collectors.toList());
        List<Grade> rtnList = Lists.newArrayList() ;
        list.stream().forEach(g -> {
            long ranking =   scoreList.stream().filter(score -> g.getAmount() < score).count();
            g.setRanking(ranking == 0 ?1:((int)ranking +1) );
            rtnList.add(g);
        });
        return rtnList;
    }


    public Map<String,String> exportForExcel(Grade grade,String url){
        Map<String,String> rtnMap = Maps.newHashMap() ;
        Boolean flag = false ;
        List<Grade> list = dao.findList(grade) ;
        //标题
        List<String> headerList = Lists.newArrayList() ;
        headerList.add("学号");
        headerList.add("姓名");
        headerList.add("班级");
        headerList.add("课程");
        headerList.add("卷面分");
        headerList.add("平时成绩");
        headerList.add("总成绩");
        headerList.add("排名");
        headerList.add("绩点");
        List<List<String>> dataList = Lists.newArrayList() ;
        ExportExcel ee = new ExportExcel("学生成绩表",headerList);
        list.stream().forEach(g -> {
            List<String> data = Lists.newArrayList() ;
            data.add(g.getStudent().getStudentNo());
            data.add(g.getStudent().getName());
            data.add(g.getClasses().getName());
            data.add(g.getCourse().getName());
            data.add(String.valueOf(g.getPaperScore()));
            data.add(String.valueOf(g.getExtraScore()));
            data.add(String.valueOf(g.getAmount()));
            data.add(String.valueOf(g.getRanking()));
            data.add(String.valueOf(g.getPoint()));
            dataList.add(data);
        });
        for (int i = 0; i < dataList.size(); i++) {
            Row row = ee.addRow();
            for (int j = 0; j < dataList.get(i).size(); j++) {
                ee.addCell(row, j, 2,dataList.get(i).get(j));
            }
        }
        String fileName = String.valueOf(DateUtils.getTime(new Date()));
        url +=  fileName +".xls";
        try {
            ee.writeFile(url);
            ee.dispose();
            flag = true ;
        } catch (IOException e) {
            e.printStackTrace();
        }
        rtnMap.put("url",fileName);
        rtnMap.put("isSuccess",flag.toString());
        return rtnMap ;
    }
}
