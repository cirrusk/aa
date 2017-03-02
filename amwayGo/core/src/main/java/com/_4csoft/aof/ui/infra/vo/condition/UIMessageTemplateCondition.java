package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

public class UIMessageTemplateCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 템플릿 사용여부 */
	private String srchUseYn;
	
	/** 템플릿 구분 */
	private String srchTemplateType;

	/** 이메일,SMS 모듈삽입용 템플릿 구분 (노말,QNA 등) */
	private String srchMessageTemplateType;
	
	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public String getSrchTemplateType() {
		return srchTemplateType;
	}

	public void setSrchTemplateType(String srchTemplateType) {
		this.srchTemplateType = srchTemplateType;
	}

	public String getSrchMessageTemplateType() {
		return srchMessageTemplateType;
	}

	public void setSrchMessageTemplateType(String srchMessageTemplateType) {
		this.srchMessageTemplateType = srchMessageTemplateType;
	}
	
}
