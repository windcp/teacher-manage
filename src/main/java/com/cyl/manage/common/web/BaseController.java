/**

 */
package com.cyl.manage.common.web;

import java.beans.PropertyEditorSupport;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import javax.validation.ValidationException;
import javax.validation.Validator;

import com.cyl.manage.common.beanvalidator.BeanValidators;
import com.cyl.manage.common.enums.EnumsRtnMapCode;
import com.cyl.manage.common.enums.EnumsRtnMapResult;
import com.cyl.manage.common.utils.DateUtils;
import com.cyl.manage.common.utils.StringUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cyl.manage.common.mapper.JsonMapper;

/**
 * 控制器支持类
 * @author luochaoqun
 * @version 2013-3-23
 */
public abstract class BaseController {

	/**
	 * 日志对象
	 */
	protected Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * 管理基础路径
	 */
	@Value("${adminPath}")
	protected String adminPath;
	
	/**
	 * 验证Bean实例对象
	 */
	@Autowired
	protected Validator validator;

	/**
	 * 服务端参数有效性验证
	 * @param object 验证的实体对象
	 * @param groups 验证组
	 * @return 验证成功：返回true；严重失败：将错误信息添加到 message 中
	 */
	protected boolean beanValidator(Model model, Object object, Class<?>... groups) {
		try{
			BeanValidators.validateWithException(validator, object, groups);
		}catch(ConstraintViolationException ex){
			List<String> list = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
			list.add(0, "数据验证失败：");
			addMessage(model, list.toArray(new String[]{}));
			return false;
		}
		return true;
	}
	
	/**
	 * 服务端参数有效性验证
	 * @param object 验证的实体对象
	 * @param groups 验证组
	 * @return 验证成功：返回true；严重失败：将错误信息添加到 flash message 中
	 */
	protected boolean beanValidator(RedirectAttributes redirectAttributes, Object object, Class<?>... groups) {
		try{
			BeanValidators.validateWithException(validator, object, groups);
		}catch(ConstraintViolationException ex){
			List<String> list = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
			list.add(0, "数据验证失败：");
			addMessage(redirectAttributes, list.toArray(new String[]{}));
			return false;
		}
		return true;
	}
	
	/**
	 * 服务端参数有效性验证
	 * @param object 验证的实体对象
	 * @param groups 验证组，不传入此参数时，同@Valid注解验证
	 * @return 验证成功：继续执行；验证失败：抛出异常跳转400页面。
	 */
	protected void beanValidator(Object object, Class<?>... groups) {
		BeanValidators.validateWithException(validator, object, groups);
	}
	
	/**
	 * 添加Model消息
	 * @param message
	 */
	protected void addMessage(Model model, String... messages) {
		StringBuilder sb = new StringBuilder();
		for (String message : messages){
			sb.append(message).append(messages.length>1?"<br/>":"");
		}
		model.addAttribute("message", sb.toString());
	}
	
	/**
	 * 添加Flash消息
	 * @param message
	 */
	protected void addMessage(RedirectAttributes redirectAttributes, String... messages) {
		StringBuilder sb = new StringBuilder();
		for (String message : messages){
			sb.append(message).append(messages.length>1?"<br/>":"");
		}
		redirectAttributes.addFlashAttribute("message", sb.toString());
	}
	
	/**
	 * 客户端返回JSON字符串
	 * @param response
	 * @param object
	 * @return
	 */
	protected String renderString(HttpServletResponse response, Object object) {
		return renderString(response, JsonMapper.toJsonString(object), "application/json");
	}
	
	/**
	 * 客户端返回字符串
	 * @param response
	 * @param string
	 * @return
	 */
	protected String renderString(HttpServletResponse response, String string, String type) {
		try {
			response.reset();
	        response.setContentType(type);
	        response.setCharacterEncoding("utf-8");
			response.getWriter().print(string);
			return null;
		} catch (IOException e) {
			return null;
		}
	}

	/**
	 * 参数绑定异常
	 */
	@ExceptionHandler({BindException.class, ConstraintViolationException.class, ValidationException.class})
    public String bindException() {  
        return "error/400";
    }
	
	/**
	 * 授权登录异常
	 */
	@ExceptionHandler({AuthenticationException.class})
    public String authenticationException() {  
        return "error/403";
    }
	
	/**
	 * 初始化数据绑定
	 * 1. 将所有传递进来的String进行HTML编码，防止XSS攻击
	 * 2. 将字段中Date类型转换为String类型
	 */
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		// String类型转换，将所有传递进来的String进行HTML编码，防止XSS攻击
		binder.registerCustomEditor(String.class, new PropertyEditorSupport() {
			/*@Override
			public void setAsText(String text) {
				setValue(text == null ? null : StringEscapeUtils.escapeHtml4(text.trim()));
			}*/
			@Override
			public void setAsText(String text) {
				setValue(text == null ? null : text.trim());
			}
			@Override
			public String getAsText() {
				Object value = getValue();
				return value != null ? value.toString() : "";
			}
		});
		// Date 类型转换
		binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				setValue(DateUtils.parseDate(text));
			}
//			@Override
//			public String getAsText() {
//				Object value = getValue();
//				return value != null ? DateUtils.formatDateTime((Date)value) : "";
//			}
		});
	}

	/**
	 *
	 * @author xuchang
	 * @Description 快捷设置返回状态码和提示消息(用于同步页面请求跳转)
	 * @param code
	 * @param msg
	 * @param model
	 */
	public void setRtnCodeAndMsg(String code, String msg, Model model){
		model.addAttribute(EnumsRtnMapCode.RTN_CODE.getKey(), code);
		model.addAttribute(EnumsRtnMapCode.RTN_MSG.getKey(), msg);
	}

	/**
	 *
	 * @author xuchang
	 * @Description 设置返回消息为异常（用于异步请求）
	 * @param rtnMap
	 * @param msg
	 */
	public void setRtnCodeAndMsgByException(Map<String, Object> rtnMap, String msg){
		rtnMap.put(EnumsRtnMapCode.RTN_CODE.getKey(), EnumsRtnMapResult.EXCEPTION.getCode());
		if(StringUtils.isNotEmpty(msg)){
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), msg);
		}else{
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), EnumsRtnMapResult.EXCEPTION.getMsg());
		}
	}

	/**
	 *
	 * @author xuchang
	 * @Description 设置返回消息为成功
	 * @param rtnMap
	 * @param msg
	 */
	public void setRtnCodeAndMsgBySuccess(Map<String, Object> rtnMap, String msg){
		rtnMap.put(EnumsRtnMapCode.RTN_CODE.getKey(), EnumsRtnMapResult.SUCCESS.getCode());
		if(StringUtils.isNotEmpty(msg)){
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), msg);
		}else{
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), EnumsRtnMapResult.SUCCESS.getMsg());
		}
	}

	/**
	 *
	 * @author xuchang
	 * @Description 设置返回消息为失败
	 * @param rtnMap
	 * @param msg
	 */
	public void setRtnCodeAndMsgByFailure(Map<String, Object> rtnMap, String msg){
		rtnMap.put(EnumsRtnMapCode.RTN_CODE.getKey(), EnumsRtnMapResult.FAILURE.getCode());
		if(StringUtils.isNotEmpty(msg)){
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), msg);
		}else{
			rtnMap.put(EnumsRtnMapCode.RTN_MSG.getKey(), EnumsRtnMapResult.FAILURE.getMsg());
		}
	}

	/**
	 *
	 * @author xuchang
	 * @Description 设置返回消息数据
	 * @param rtnMap
	 * @param data
	 */
	public void setRtnData(Map<String, Object> rtnMap, Object data){
		rtnMap.put(EnumsRtnMapCode.RTN_DATA.getKey(), data);
	}

	/**
	 *
	 * @author xuchang
	 * @Description 得到tomcat发布路径下的项目地址
	 * @param request
	 * @return
	 */
	public String getAppRoot(HttpServletRequest request) {
		return request.getSession().getServletContext().getRealPath(File.separator);
	}
	
}
