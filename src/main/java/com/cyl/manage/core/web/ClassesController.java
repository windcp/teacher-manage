package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Classes;
import com.cyl.manage.core.service.ClassesService;
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
@RequestMapping(value = "${adminPath}/classes")
public class ClassesController extends BaseController {

    @Autowired
    private ClassesService classesService;

    @ModelAttribute
    public Classes get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return classesService.get(id);
        } else return new Classes();
    }

    @RequiresPermissions("classes:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {


        return "core/classes/classesList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Classes classes, int pageNo, int pageSize, String orderBy) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Classes> page = new Page<Classes>(pageNo, pageSize) ;
        Page<Classes> rtnPage = classesService.findPage(page, classes);
        map.put("total", rtnPage.getCount());
        map.put("rows", rtnPage.getList());
        return map;
    }

    @RequiresPermissions("classes:view")
    @RequestMapping(value = "form")
    public String form(Classes classes, Model model) {
        model.addAttribute("classes", classes);

        return "core/classes/classesForm";
    }

    @RequiresPermissions("classes:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Classes classes, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        classesService.save(classes);
        return map;
    }

    @RequiresPermissions("classes:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Classes classes) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        classesService.delete(classes);
        return map;
    }

}
