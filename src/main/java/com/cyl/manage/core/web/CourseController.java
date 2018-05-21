package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Course;
import com.cyl.manage.core.service.CourseService;
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

import java.util.Map;

@Controller
@RequestMapping(value = "${adminPath}/course")
public class CourseController extends BaseController {

    @Autowired
    private CourseService courseService;


    @ModelAttribute
    public Course get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return courseService.get(id);
        } else return new Course();
    }

    @RequiresPermissions("course:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("termList", DictUtils.getDictList("term"));

        return "core/course/courseList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Course course, int pageNo, int pageSize) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Course> page = courseService.findPage(new Page<Course>(pageNo, pageSize), course);
        map.put("total", page.getCount());
        map.put("rows", page.getList());
        return map;
    }

    @RequiresPermissions("course:view")
    @RequestMapping(value = "form")
    public String form(Course course, Model model) {
        model.addAttribute("course", course);

        return "core/course/courseForm";
    }

    @RequiresPermissions("course:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Course course, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        courseService.save(course);
        return map;
    }

    @RequiresPermissions("course:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Course course) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        courseService.delete(course);
        return map;
    }

}
