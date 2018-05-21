package com.cyl.manage.common.enums;

/**
 * 
 * @ClassName EnumsRtnMapCode
 * @Description 枚举返回码 
 * @author xuchang
 * @Date 2017年10月10日
 */
public enum EnumsRtnMapCode {
	
    RTN_CODE("rtnCode"),
    RTN_MSG("rtnMsg"),
    RTN_DATA("rtnData");
	
	private String key;
	
	private EnumsRtnMapCode(String key){
		this.key = key;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}
	
	
}
