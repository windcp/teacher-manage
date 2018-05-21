package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.FileUtils;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Grade;
import com.cyl.manage.core.entity.Student;
import com.cyl.manage.core.service.CoreService;
import com.cyl.manage.core.service.CourseService;
import com.cyl.manage.core.service.GradeService;
import com.cyl.manage.core.service.StudentService;
import com.cyl.manage.core.utils.PointUtil;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "{adminPath}/grade")
public class GradeController extends BaseController {

    @Autowired
    private GradeService gradeService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private CoreService coreService;

    @ModelAttribute
    public Grade get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return gradeService.get(id);
        } else return new Grade();
    }

    @RequiresPermissions("grade:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("classesList", coreService.getClassesList());
        return "core/grade/gradeList";
    }

    @RequestMapping(value = "getStudent")
    @ResponseBody
    public Student getStudent(String studentNo){
       if(StringUtils.isNotBlank(studentNo)){
           return studentService.getByStudentNo(studentNo);
       }else{
           return null;
       }
    }

    @RequestMapping(value = "getStudentList")
    @ResponseBody
    public List<Student> getStudentList(String classesId){
        return coreService.getStudentList(classesId);
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Grade grade, int pageNo, int pageSize, String orderBy) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Grade> page = new Page<Grade>(pageNo, pageSize) ;
        page.setOrderBy(orderBy);
        Page<Grade> rtnPage = gradeService.findPage(page, grade);
        map.put("total", rtnPage.getCount());
        map.put("rows", rtnPage.getList());
        return map;
    }

    @RequiresPermissions("grade:view")
    @RequestMapping(value = "form")
    public String form(Grade grade, Model model) {
       /* if(StringUtils.isNotBlank(grade.getId())){
             grade = gradeService.get(grade.getId());
        }*/
        model.addAttribute("grade", grade);
        model.addAttribute("courseList", coreService.getCourseList());
        model.addAttribute("classesList", coreService.getClassesList());
        return "core/grade/gradeForm";
    }

    @RequiresPermissions("grade:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Grade grade, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        //计算学分
        int credit = 0;
        //计算总分，平时分占比30%，卷面分占比70%
        int amount = (int) Math.round(grade.getPaperScore()*0.7 + grade.getExtraScore()*0.3);
        grade.setAmount(amount);
        //计算绩点
        double point = PointUtil.getPoint(amount);
        grade.setPoint(point);
        if(point == 0.0){
            credit = 0;
        }else{
            credit=Integer.parseInt(courseService.get(grade.getCourse().getId()).getCredit());
        }
        grade.setCredit(credit);
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        gradeService.save(grade);
        return map;
    }

    @RequiresPermissions("grade:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Grade grade) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        gradeService.delete(grade);
        return map;
    }

    @RequiresPermissions("evaluation:edit")
    @RequestMapping(value = "updateRanking")
    @ResponseBody
    public Map<String, Object> updateRnking() {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "更新成功");
        gradeService.updateRanking();
        return map;
    }

    @RequiresPermissions("evaluation:view")
    @RequestMapping(value = "exportForExcel")
    @ResponseBody
    public Map<String, Object> exportForExcel(Grade grade ,HttpServletRequest request) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "文件生成成功");
        String url = super.getAppRoot(request) +"/excel/" ;
        FileUtils.createDirectory(url);
        System.out.println("file : "+url);
        Map<String,String> data = gradeService.exportForExcel(grade,url);
        if("false".equals(data.get("isSuccess"))){
            setRtnCodeAndMsgByFailure(map,"文件生成失败");
        }else{
            setRtnData(map,data);
        }
        return map;
    }

    @RequestMapping(value="/downloadExcel")
    @ResponseBody
    public void downloadExcel(String url , HttpServletRequest request,HttpServletResponse response) throws IOException {
        response.addHeader("Content-Disposition",
                "attachment;filename=" + java.net.URLEncoder.encode("学生成绩表.xls", "UTF-8"));
        url = super.getAppRoot(request)+"/excel/"+url+".xls";
        File file = new File(url);
        FileInputStream in = new FileInputStream(file);
        OutputStream out = response.getOutputStream() ;
        byte[] buffer = new byte[1024] ;
        int len = 0;
        while((len=in.read(buffer))>0){
            out.write(buffer, 0, len);
        }
        in.close();
        out.close();
    }

  /*  @RequestMapping(value="/validateCourse")
    @ResponseBody
    public boolean validateCourse(Grade grade){
        boolean result = false;
        String courseId = grade.getCourse().getId();
        String studentId = grade.getStudent().getId();
        if(StringUtils.isNotBlank(grade.getId())){
            grade = gradeService.get(grade.getId());
            if(courseId == grade.getCourse().getId() && studentId == grade.getStudent().getId()){
                result = false;
            }else{
                result = true;
            }
        }else{

        }

        return result;
    }*/

    @RequestMapping(value = "test")
    public String test(Integer test){
        int i = 0 ;
        //int j = i /0 ;

        return "test" ;
    }

}
