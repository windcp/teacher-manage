package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Classes;
import com.cyl.manage.core.entity.Student;
import com.cyl.manage.core.entity.Teacher;
import com.cyl.manage.core.service.ClassesService;
import com.cyl.manage.core.service.CoreService;
import com.cyl.manage.core.service.StudentService;
import com.cyl.manage.core.service.TeacherService;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.service.SystemService;
import com.cyl.manage.system.utils.DictUtils;
import com.cyl.manage.system.utils.UserUtils;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "${adminPath}/student")
public class StudentController extends BaseController {

    /*@Autowired
    private SystemService systemService;*/

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private ClassesService classesService;

    @Autowired
    private CoreService coreService;

    @ModelAttribute
    public Student get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return studentService.get(id);
        } else return new Student();
    }

    @RequiresPermissions("student:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("termList", DictUtils.getDictList("term"));
        model.addAttribute("classesList", coreService.getClassesList());
        return "core/student/studentList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Student student, int pageNo, int pageSize) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Student> page = null;
        List<String> classesIds = new ArrayList<String>();
        //获取当前用户
        User user = UserUtils.getUser();
        //当前用户是否是老师
        Teacher teacher = teacherService.get(user.getTeacherId());
        if (teacher != null){
            //获取当前老师所授课班级id集合
            // List<String> classesIds = Arrays.asList(teacher.getClassesIds().split(","));
            String classId = student.getClassesId();
            if(StringUtils.isNotBlank(classId)){
                classesIds.add(classId);
            }else{
                classesIds = teacher.getClassesIdsList();
            }
            page = studentService.findPage(new Page<Student>(pageNo, pageSize), student, classesIds);
        }else{
            //管理员时获取所有学生信息：系统理论只有管理员和老师两种类型用户
            page = studentService.findPage(new Page<Student>(pageNo, pageSize), student);
        }
        map.put("total", page.getCount());
        map.put("rows", page.getList());
        return map;
    }

    @RequiresPermissions("student:view")
    @RequestMapping(value = "form")
    public String form(Student student, Model model) {
        if(StringUtils.isNotBlank(student.getId())){
            student = studentService.get(student.getId());
        }
        model.addAttribute("student", student);
        model.addAttribute("classesList", coreService.getClassesList());
        return "core/student/studentForm";
    }

    @RequiresPermissions("student:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Student student, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        studentService.save(student);
        return map;
    }

    @RequiresPermissions("student:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Student student) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        studentService.delete(student);
        return map;
    }

    /**
     * 学号唯一性验证
     * @return
     */
    @RequestMapping(value = "validateStudentNo")
    @ResponseBody
    public boolean validateStudentNo(String studentNo, String id){
        List<Student> studentList = studentService.findAllList();
        boolean result = true;
        //List<String> studentNoList = new ArrayList<String>();
        //避免修改用户时造成无法保存
        if(!StringUtils.isNotBlank(id)){
            for(Student student:studentList){
                if((student.getStudentNo()).equals(studentNo)){
                    result = false;
                }
            }
        }else{
            result = true;
        }
         return result;
    }

}
