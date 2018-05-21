package com.cyl.manage.core.web;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.core.entity.Evaluation;
import com.cyl.manage.core.service.EvaluationService;
import com.cyl.manage.core.service.TeacherService;
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
@RequestMapping(value = "{adminPath}/evaluation")
public class EvaluationController extends BaseController {

    @Autowired
    private EvaluationService evaluationService;

    @Autowired
    private TeacherService teacherService ;

    @ModelAttribute
    public Evaluation get(String id) {
        if (StringUtils.isNotEmpty(id)) {
            return evaluationService.get(id);
        } else return new Evaluation();
    }

    @RequiresPermissions("evaluation:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        model.addAttribute("teacherList",teacherService.findAllList());
        return "core/evaluation/evaluationList";
    }

    @RequestMapping(value = "getTableData")
    @ResponseBody
    public Map<String, Object> getTableData(Evaluation evaluation, int pageNo, int pageSize , String orderBy) {
        Map<String, Object> map = Maps.newHashMap();
        Page<Evaluation> page = new Page<Evaluation>(pageNo, pageSize) ;
        page.setOrderBy(orderBy);
        Page<Evaluation> rtnPage = evaluationService.findPage(page, evaluation);
        map.put("total", rtnPage.getCount());
        map.put("rows", rtnPage.getList());
        return map;
    }

    @RequiresPermissions("evaluation:view")
    @RequestMapping(value = "form")
    public String form(Evaluation evaluation, Model model) {
        model.addAttribute("evaluation", evaluation);
        return "core/evaluation/evaluationForm";
    }

    @RequiresPermissions("evaluation:edit")
    @RequestMapping(value = "save")
    @ResponseBody
    public Map<String, Object> save(Evaluation evaluation, Model model) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "保存成功");
        evaluationService.save(evaluation);
        return map;
    }

    @RequiresPermissions("evaluation:edit")
    @RequestMapping(value = "delete")
    @ResponseBody
    public Map<String, Object> delete(Evaluation evaluation) {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "删除成功");
        evaluationService.delete(evaluation);
        return map;
    }

    @RequiresPermissions("evaluation:edit")
    @RequestMapping(value = "updateRanking")
    @ResponseBody
    public Map<String, Object> updateRnking() {
        Map<String, Object> map = Maps.newHashMap();
        setRtnCodeAndMsgBySuccess(map, "更新成功");
        evaluationService.updateRanking();
        return map;
    }

}
