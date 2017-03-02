/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.service;

import java.util.List;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIAgreementCodeVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;


/**
 * @Project : aof5-infra-3
 * @Package : com._4csoft.aof.infra.service
 * @File : UIEmailSendService.java
 * @Title : SMS 발송
 * @date : 2014. 3. 11.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIAgreementService {
	
	Paginate<ResultSet> getListAgreement(UIAgreementCondition conditionVO) throws Exception;
	
	UIAgreementCondition getDetailAgreement(UIAgreementCondition conditionVO);

	void insertAgreement(UIAgreementCondition condition);
	
	List<UIAgreementCodeVO> getListCode();
	
	List<UIAgreementCondition> getCallAgree(UIUnivCourseApplyCondition condition);

	List<ResultSet> getAgreeList(UIAgreementCondition condition);
	
	void insertAgreeApply(UIAgreementCondition condition);
	
	void updateActiveApply(UIAgreementCondition condition);

	List<ResultSet> getClause(UIAgreementCondition agreeCondition);
	
	UIAgreementCondition getActiveAgreeSeq(UIAgreementCondition condition);

}
