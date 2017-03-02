/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIDeviceVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSummaryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseApplyRS.java
 * @Title : 수강
 * @date : 2014. 3. 5.
 * @author : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseApplyRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseApplyVO apply;

	private UIUnivCourseActiveVO active;

	private UIUnivCourseActiveLecturerVO lecturer;

	private UIUnivCategoryVO category;

	private UIMemberVO member;

	private UIUnivCourseActiveSummaryVO summary;

	private UIUnivCourseActiveElementVO element;

	private UIUnivCourseApplyElementVO applyElement;

	private UIUnivCourseActiveEvaluateVO evaluate;

	private UIDeviceVO device;

	private UIUnivCourseMasterVO courseMaster;
	
	/** 팀프로젝트 게시물 */
	private UIUnivCourseTeamProjectBbsVO bbs;
	
	

	public UIUnivCourseTeamProjectBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UIUnivCourseTeamProjectBbsVO bbs) {
		this.bbs = bbs;
	}

	public UIUnivCourseApplyVO getApply() {
		return apply;
	}

	public void setApply(UIUnivCourseApplyVO apply) {
		this.apply = apply;
	}

	public UIUnivCourseActiveVO getActive() {
		return active;
	}

	public void setActive(UIUnivCourseActiveVO active) {
		this.active = active;
	}

	public UIUnivCourseActiveLecturerVO getLecturer() {
		return lecturer;
	}

	public void setLecturer(UIUnivCourseActiveLecturerVO lecturer) {
		this.lecturer = lecturer;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIUnivCourseActiveSummaryVO getSummary() {
		return summary;
	}

	public void setSummary(UIUnivCourseActiveSummaryVO summary) {
		this.summary = summary;
	}

	public UIUnivCourseActiveElementVO getElement() {
		return element;
	}

	public void setElement(UIUnivCourseActiveElementVO element) {
		this.element = element;
	}

	public UIUnivCourseApplyElementVO getApplyElement() {
		return applyElement;
	}

	public void setApplyElement(UIUnivCourseApplyElementVO applyElement) {
		this.applyElement = applyElement;
	}

	public UIUnivCourseActiveEvaluateVO getEvaluate() {
		return evaluate;
	}

	public void setEvaluate(UIUnivCourseActiveEvaluateVO evaluate) {
		this.evaluate = evaluate;
	}

	public UIDeviceVO getDevice() {
		return device;
	}

	public void setDevice(UIDeviceVO device) {
		this.device = device;
	}

	public UIUnivCourseMasterVO getCourseMaster() {
		return courseMaster;
	}

	public void setCourseMaster(UIUnivCourseMasterVO courseMaster) {
		this.courseMaster = courseMaster;
	}

}
