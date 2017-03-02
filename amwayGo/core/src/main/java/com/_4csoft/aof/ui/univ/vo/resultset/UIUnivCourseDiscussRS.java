/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyElementVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseDiscussRS.java
 * @Title : 토론
 * @date : 2014. 2. 27.
 * @author : 김영학
 * @descrption : 대학 교과목구성정보 토론
 */
public class UIUnivCourseDiscussRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 토론 템플릿 vo */
	private UIUnivCourseDiscussTemplateVO discussTemplate;

	/** 토론 템플릿 vo */
	private UIUnivCourseDiscussVO discuss;

	/** 멤버 vo */
	private UIMemberVO member;

	/** 카테고리 vo */
	private UICategoryVO cate;

	/** 학습자수강요소 vo */
	private UnivCourseApplyElementVO applyElement;

	public UIUnivCourseDiscussTemplateVO getDiscussTemplate() {
		return discussTemplate;
	}

	public void setDiscussTemplate(UIUnivCourseDiscussTemplateVO discussTemplate) {
		this.discussTemplate = discussTemplate;
	}

	public UIUnivCourseDiscussVO getDiscuss() {
		return discuss;
	}

	public void setDiscuss(UIUnivCourseDiscussVO discuss) {
		this.discuss = discuss;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICategoryVO getCate() {
		return cate;
	}

	public void setCate(UICategoryVO cate) {
		this.cate = cate;
	}

	public UnivCourseApplyElementVO getApplyElement() {
		return applyElement;
	}

	public void setApplyElement(UnivCourseApplyElementVO applyElement) {
		this.applyElement = applyElement;
	}

}
