package com._4csoft.aof.ui.infra.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.infra.vo.UIAgreementCodeVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper ("UIAgreementMapper")
public interface UIAgreementMapper {

	List<ResultSet> getList(SearchConditionVO conditionVO);
	
	UIAgreementCondition getDetailAgreement(UIAgreementCondition condition);
	
	int countList(SearchConditionVO conditionVO);
	
	void insertAgreement(UIAgreementCondition condition);
	
	List<UIAgreementCodeVO> getListCode();
	
	Long getVersion(UIAgreementCondition condition);
	
	List<UIAgreementCondition> getCallAgree(UIUnivCourseApplyCondition condition);

	List<ResultSet> getAgreeList(UIAgreementCondition condition);
	
	void insertAgreeApply(UIAgreementCondition condition);
	
	void updateActiveApply(UIAgreementCondition condition);

	List<ResultSet> getClause(UIAgreementCondition agreeCondition);

	UIAgreementCondition getActiveAgreeSeq(UIAgreementCondition condition);
}
