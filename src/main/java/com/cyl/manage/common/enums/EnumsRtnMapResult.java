package com.cyl.manage.common.enums;

/**
 * 
 * @ClassName EnumsRtnMapResult
 * @Description 枚举返回结果
 * @author xuchang
 * @Date 2017年10月10日
 */
public enum EnumsRtnMapResult {
	
	SUCCESS("00000000","操作成功"),
	FAILURE("00000001","操作失败"),
	EXCEPTION("00000009","操作异常");
	
	private String code ;
	
	private String msg ;
	
	private EnumsRtnMapResult(String code ,String msg){
		this.code = code ;
		this.msg = msg ;
	}

	public static String getLable(String code) {
		if (code == null || "".equals(code))
			return null;
		for (EnumsRtnMapResult c : EnumsRtnMapResult.values()) {
			if (code.equals(c.getCode())) {
				return c.msg;
			}
		}
		return null;
	}
	
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

}
