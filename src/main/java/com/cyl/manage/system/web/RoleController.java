package com.cyl.manage.system.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.cyl.manage.common.config.Global;
import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.Collections3;
import com.cyl.manage.system.entity.Role;
import com.cyl.manage.system.service.SystemService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.utils.UserUtils;

/**
 * 角色Controller
 * @author luochaoqun
 * @version 2013-12-05
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/role")
public class RoleController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@ModelAttribute("role")
	public Role get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return systemService.getRole(id);
		}else{
			return new Role();
		}
	}
	
	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = {"list", ""})
	public String list(Role role, Model model) {
		List<Role> list = systemService.findAllRole();
		model.addAttribute("list", list);
		return "system/roleList";
	}

	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = "form")
	public String form(Role role, Model model) {
		model.addAttribute("role", role);
		model.addAttribute("menuList", systemService.findAllMenu());
		return "system/roleForm";
	}
	
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public Map<String,Object> save(Role role, Model model, RedirectAttributes redirectAttributes) {
		Map<String,Object> map = Maps.newHashMap() ;
		setRtnCodeAndMsgBySuccess(map,"保存成功");
		if(!UserUtils.getUser().isAdmin()&&role.getSysData().equals(Global.YES)){
			setRtnCodeAndMsgByFailure(map,"越权操作，只有超级管理员才能修改此数据！");
		}
		/*if (!checkName(role.getOldName(), role.getName())){
			setRtnCodeAndMsgByFailure(map,"保存角色'" + role.getName() + "'失败, 角色名已存在");
		}
		if (!checkEnname(role.getOldEnname(), role.getEnname())){
			setRtnCodeAndMsgByFailure(map,"保存角色'" + role.getName() + "'失败, 英文名已存在");
		}*/
		systemService.saveRole(role);
		return map;
	}
	
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Map<String,Object> delete(Role role, RedirectAttributes redirectAttributes) {
		Map<String,Object> map = Maps.newHashMap() ;
		if(!UserUtils.getUser().isAdmin() && role.getSysData().equals(Global.YES)){
			setRtnCodeAndMsgByFailure(map,"越权操作，只有超级管理员才能修改此数据！");
		}
		systemService.deleteRole(role);
		setRtnCodeAndMsgBySuccess(map,"删除成功");
		return map;
	}
	
	/**
	 * 角色分配页面
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assign")
	public String assign(Role role, Model model) {
		List<User> userList = systemService.findUser(new User(new Role(role.getId())));
		model.addAttribute("userList", userList);
		return "system/roleAssign";
	}
	
	/**
	 * 角色分配 -- 打开角色分配对话框
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:role:view")
	@RequestMapping(value = "usertorole")
	public String selectUserToRole(Role role, Model model) {
		List<User> userList = systemService.findUser(new User(new Role(role.getId())));
		model.addAttribute("role", role);
		model.addAttribute("userList", userList);
		model.addAttribute("selectIds", Collections3.extractToString(userList, "name", ","));
		return "system/selectUserToRole";
	}
	
	/**
	 * 角色分配 -- 根据部门编号获取用户列表
	 * @param officeId
	 * @param response
	 * @return
	 */
	@RequiresPermissions("sys:role:view")
	@ResponseBody
	@RequestMapping(value = "users")
	public List<Map<String, Object>> users(String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		Page<User> page = systemService.findUser(new Page<User>(1, -1), user);
		for (User e : page.getList()) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", 0);
			map.put("name", e.getName());
			mapList.add(map);			
		}
		return mapList;
	}
	
	/**
	 * 角色分配 -- 从角色中移除用户
	 * @param userId
	 * @param roleId
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "outrole")
	public String outrole(String userId, String roleId, RedirectAttributes redirectAttributes) {
		Role role = systemService.getRole(roleId);
		User user = systemService.getUser(userId);
		if (UserUtils.getUser().getId().equals(userId)) {
			addMessage(redirectAttributes, "无法从角色【" + role.getName() + "】中移除用户【" + user.getName() + "】自己！");
		}else {
			if (user.getRoleList().size() <= 1){
				addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除失败！这已经是该用户的唯一角色，不能移除。");
			}else{
				Boolean flag = systemService.outUserInRole(role, user);
				if (!flag) {
					addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除失败！");
				}else {
					addMessage(redirectAttributes, "用户【" + user.getName() + "】从角色【" + role.getName() + "】中移除成功！");
				}
			}		
		}
		return "redirect:" + adminPath + "/sys/role/assign?id="+role.getId();
	}
	
	/**
	 * 角色分配
	 * @param role
	 * @param idsArr
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:role:edit")
	@RequestMapping(value = "assignrole")
	public String assignRole(Role role, String[] idsArr, RedirectAttributes redirectAttributes) {
		StringBuilder msg = new StringBuilder();
		int newNum = 0;
		for (int i = 0; i < idsArr.length; i++) {
			User user = systemService.assignUserToRole(role, systemService.getUser(idsArr[i]));
			if (null != user) {
				msg.append("<br/>新增用户【" + user.getName() + "】到角色【" + role.getName() + "】！");
				newNum++;
			}
		}
		addMessage(redirectAttributes, "已成功分配 "+newNum+" 个用户"+msg);
		return "redirect:" + adminPath + "/sys/role/assign?id="+role.getId();
	}

	/**
	 * 验证角色名是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkName")
	public boolean checkName(String oldName, String name) {
		if (name!=null && name.equals(oldName)) {
			return true ;
		} else if (name!=null && systemService.getRoleByName(name) == null) {
			return true ;
		}
		return false;
	}

	/**
	 * 验证角色英文名是否有效
	 * @param oldEnname
	 * @param enname
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkEnname")
	public boolean checkEnname(String oldEnname, String enname) {
		if (enname!=null && enname.equals(oldEnname)) {
			return true ;
		} else if (enname!=null && systemService.getRoleByEnname(enname) == null) {
			return true ;
		}
		return false;
	}

}
