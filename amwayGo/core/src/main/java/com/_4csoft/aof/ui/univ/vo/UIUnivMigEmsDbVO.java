/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivMigEmsDbVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivMigEmsDbVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 18.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivMigEmsDbVO extends UnivMigEmsDbVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** procedure return 값이 있을때 사용 */
	private Long returnValue;

	/** procedure 호출시 연동정보 - 회원정보 */
	private String memberInfoYn;

	/** procedure 호출시 연동정보 - 교과목분류 */
	private String categoryInfoYn;

	/** procedure 호출시 연동정보 - 교과목정보 */
	private String masterInfoYn;

	/** procedure 호출시 연동정보 - 개설과목정보 */
	private String courseInfoYn;

	/** procedure 호출시 연동정보 - 수강정보 */
	private String applyInfoYn;
	
	/** cs_batch_schedule_cd : 배치 스케줄 코드 */
	private String batchScheduleCd;
	
	/** cs_batch_hour : 배치 스케줄 적용 시간 */
	private Long batchHour;
	
	/** cs_batch_min : 배치 스케줄 적용 분 */
	private Long batchMin;

	public String getBatchScheduleCd() {
		return batchScheduleCd;
	}

	public void setBatchScheduleCd(String batchScheduleCd) {
		this.batchScheduleCd = batchScheduleCd;
	}

	public Long getBatchHour() {
		return batchHour;
	}

	public void setBatchHour(Long batchHour) {
		this.batchHour = batchHour;
	}

	public Long getBatchMin() {
		return batchMin;
	}

	public void setBatchMin(Long batchMin) {
		this.batchMin = batchMin;
	}


	public Long getReturnValue() {
		return returnValue;
	}

	public void setReturnValue(Long returnValue) {
		this.returnValue = returnValue;
	}

	public String getMemberInfoYn() {
		return memberInfoYn;
	}

	public void setMemberInfoYn(String memberInfoYn) {
		this.memberInfoYn = memberInfoYn;
	}

	public String getCategoryInfoYn() {
		return categoryInfoYn;
	}

	public void setCategoryInfoYn(String categoryInfoYn) {
		this.categoryInfoYn = categoryInfoYn;
	}

	public String getMasterInfoYn() {
		return masterInfoYn;
	}

	public void setMasterInfoYn(String masterInfoYn) {
		this.masterInfoYn = masterInfoYn;
	}

	public String getCourseInfoYn() {
		return courseInfoYn;
	}

	public void setCourseInfoYn(String courseInfoYn) {
		this.courseInfoYn = courseInfoYn;
	}

	public String getApplyInfoYn() {
		return applyInfoYn;
	}

	public void setApplyInfoYn(String applyInfoYn) {
		this.applyInfoYn = applyInfoYn;
	}

}
