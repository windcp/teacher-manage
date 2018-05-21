/**

 */
package com.cyl.manage.system.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.DateUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.system.entity.Log;
import com.cyl.manage.system.service.LogService;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.Map;

/**
 * 日志Controller
 * @author luochaoqun
 * @version 2013-6-2
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/log")
public class LogController extends BaseController {

	@Autowired
	private LogService logService;
	
	@RequiresPermissions("sys:log:view")
	@RequestMapping(value = {"list", ""})
	public String list(Model model) {
	    Date today = new Date();
	    String date = DateUtils.formatDate(today);
	    model.addAttribute("beginDate", DateUtils.getDayStart(date));
        model.addAttribute("endDate", DateUtils.formatDateTime(today));
		return "system/logList";
	}

	@RequestMapping(value = "getTableData")
	@ResponseBody
	public Map<String, Object> getTableData(Log log, int pageNo, int pageSize) {
		Map<String, Object> map = Maps.newHashMap();
		Page<Log> page = logService.findPage(new Page<Log>(pageNo, pageSize), log);
		map.put("total", page.getCount());
		map.put("rows", page.getList());
		return map;
	}

}
