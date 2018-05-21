package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Assignment;
import com.cyl.manage.core.service.AssignmentService;
import com.cyl.manage.core.service.AssignmentService;
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
@RequestMapping(value = "{adminPath}/assignment")
public class AssignmentController extends BaseController {

    @Autowired
    private AssignmentService assignmentService;


    @ModelAttribute
    public Assignment get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return assignmentService.get(id);
        } else return new Assignment();
    }

    @RequiresPermissions("assignment:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("typeList", DictUtils.getDictList("topic_type"));
        model.addAttribute("difficultyList",DictUtils.getDictList("topic_difficulty"));
        return "core/assignment/assignmentList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Assignment assignment, int pageNo, int pageSize) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Assignment> page = assignmentService.findPage(new Page<Assignment>(pageNo, pageSize), assignment);
        map.put("total", page.getCount());
        map.put("rows", page.getList());
        return map;
    }

    @RequiresPermissions("assignment:view")
    @RequestMapping(value = "form")
    public String form(Assignment assignment, Model model) {
        model.addAttribute("assignment", assignment);

        return "core/assignment/assignmentForm";
    }

    @RequiresPermissions("assignment:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Assignment assignment, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        assignmentService.save(assignment);
        return map;
    }

    @RequiresPermissions("assignment:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Assignment assignment) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        assignmentService.delete(assignment);
        return map;
    }

}
