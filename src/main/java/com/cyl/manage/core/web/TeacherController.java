package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Classes;
import com.cyl.manage.core.entity.Course;
import com.cyl.manage.core.entity.Teacher;
import com.cyl.manage.core.service.ClassesService;
import com.cyl.manage.core.service.CourseService;
import com.cyl.manage.core.service.TeacherService;
import com.cyl.manage.system.service.SystemService;
import com.cyl.manage.system.utils.DictUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping( value = "${adminPath}/teacher")
public class TeacherController extends BaseController {
    
    @Autowired
    private TeacherService teacherService ;

    @Autowired
    private SystemService systemService;

    @Autowired
    private CourseService courseService ;

    @Autowired
    private ClassesService classesService ;
    
    @ModelAttribute
    public Teacher get(String id){
        if(StringUtils.isNotEmpty(id)){
            return teacherService.get(id);
        }else return new Teacher() ;
    }

    @RequiresPermissions("teacher:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("identityList", DictUtils.getDictList("identity"));
        model.addAttribute("educationList", DictUtils.getDictList("education"));
        return "core/teacher/teacherList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String,Object> getTableData(Teacher teacher ,int pageNo ,int pageSize){
        Map<String,Object> map = Maps.newHashMap() ;
        Page<Teacher> page = teacherService.findPage(new Page<Teacher>(pageNo , pageSize) , teacher);
        map.put("total",page.getCount());
        map.put("rows",page.getList());
        return  map ;
    }

    @RequiresPermissions("teacher:view")
    @RequestMapping(value = "form")
    public String form(Teacher teacher, Model model) {
        model.addAttribute("teacher", teacher);
        model.addAttribute("allRoles", systemService.findAllRole());
        model.addAttribute("allCourse",courseService.findList(new Course()));
        model.addAttribute("allClasses",classesService.findAllList());
        return "core/teacher/teacherForm";
    }

    @RequiresPermissions("teacher:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String,Object> save(Teacher teacher, HttpServletRequest request) {
        Map<String,Object> map = Maps.newHashMap() ;
        System.out.println(request.getParameter("courseIdsList"));
        List<String> ids = teacher.getCourseIdsList() ;
        List<String> classesIds = teacher.getClassesIdsList();
        for(String id : ids){
            System.out.println(id);
        }
        setRtnCodeAndMsgBySuccess(map,"保存成功");
        teacherService.save(teacher);
        return map;
    }

    @RequiresPermissions("teacher:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String,Object> delete(Teacher teacher) {
        Map<String,Object> map = Maps.newHashMap() ;
        setRtnCodeAndMsgBySuccess(map,"删除成功");
        teacherService.delete(teacher);
        return map ;
    }
    
}
