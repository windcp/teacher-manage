package com.cyl.manage.system.web;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import com.cyl.manage.common.beanvalidator.BeanValidators;
import com.cyl.manage.common.config.Global;
import com.cyl.manage.common.persistence.Page;
import com.cyl.manage.common.utils.DateUtils;
import com.cyl.manage.common.utils.StringUtils;
import com.cyl.manage.common.web.BaseController;
import com.cyl.manage.system.entity.Role;
import com.cyl.manage.system.service.SystemService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.cyl.manage.system.entity.User;
import com.cyl.manage.system.utils.UserUtils;

/**
 * 用户Controller
 * @author luochaoqun
 * @version 2013-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@ModelAttribute
	public User get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return systemService.getUser(id);
		}else{
			return new User();
		}
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = {"index"})
	public String index(User user, Model model) {
		return "system/userIndex";
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = {"list", ""})
	public String list() {
		return "system/userList";
	}

	@RequestMapping(value = "getTableData")
	@ResponseBody
	public Map<String,Object> getTableData(User user , int pageNo , int pageSize){
		Map<String,Object> map = Maps.newHashMap() ;
		Page<User> page = systemService.findUser(new Page<User>(pageNo, pageSize), user);
		map.put("total",page.getCount());
		map.put("rows",page.getList());
		return map ;
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "form")
	public String form(User user, Model model) {
		model.addAttribute("user", user);
		model.addAttribute("allRoles", systemService.findAllRole());
		return "system/userForm";
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "save")
    @ResponseBody
	public Map<String,Object> save(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
	    Map<String,Object> map = Maps.newHashMap() ;
	    setRtnCodeAndMsgBySuccess(map,"保存成功");
		// 角色数据有效性验证，过滤不在授权内的角色
		List<Role> roleList = Lists.newArrayList();
		List<String> roleIdList = user.getRoleIdList();
		for (Role r : systemService.findAllRole()){
			if (roleIdList.contains(r.getId())){
				roleList.add(r);
			}
		}
		user.setRoleList(roleList);
		// 保存用户信息
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())){
			UserUtils.clearCache();
			//UserUtils.getCacheMap().clear();
		}
		return map;
	}
	
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Map<String,Object> delete(User user, RedirectAttributes redirectAttributes) {
		Map<String,Object> map = Maps.newHashMap() ;
		setRtnCodeAndMsgBySuccess(map,"删除成功");
		if (UserUtils.getUser().getId().equals(user.getId())){
			setRtnCodeAndMsgByFailure(map,"删除用户失败, 不允许删除当前用户");
		}else if (User.isAdmin(user.getId())){
			setRtnCodeAndMsgByFailure(map,"删除用户失败, 不允许删除超级管理员用户");
		}else{
			systemService.deleteUser(user);
		}
		return map;
	}

	/**
	 * 验证登录名是否有效
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName !=null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName !=null && systemService.getUserByLoginName(loginName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * 用户信息显示及保存
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "info")
	public String info(User user, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())){
			currentUser.setEmail(user.getEmail());
			currentUser.setRemarks(user.getRemarks());
			systemService.updateUserInfo(currentUser);
			model.addAttribute("message", "保存用户信息成功");
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "system/userInfo";
	}

	/**
	 * 返回用户信息
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "infoData")
	public User infoData() {
		return UserUtils.getUser();
	}

	/**
	 * 修改个人用户密码
	 * @return
	 */
	@RequestMapping(value = "modifyPwd" , method = RequestMethod.GET)
	public String modifyPwd(){
		return "system/modifyPassword";
	}

	/**
	 * 修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> modifyPwd(String oldPassword, String newPassword) {
		Map<String,Object> map = Maps.newHashMap() ;
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)){
			if (SystemService.validatePassword(oldPassword, user.getPassword())){
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				setRtnCodeAndMsgBySuccess(map,"修改密码成功,请重新登录");
			}else{
				setRtnCodeAndMsgByFailure(map,"修改密码失败,旧密码错误");
			}
		}else{
			setRtnCodeAndMsgByFailure(map,"修改密码失败,密码不能为空");
		}
		return map;
	}

}
