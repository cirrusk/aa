package com._4csoft.aof.ui.infra.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.mapper.UIAgreementMapper;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.vo.UIAgreementCodeVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File : UIEmailSendServiceImpl.java
 * @Title : 이메일 발송서비스
 * @date : 2014. 4. 3.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIAgreementService")
public class UIAgreementServiceImpl extends AbstractServiceImpl implements UIAgreementService {

	@Resource (name = "UIAgreementMapper")
	private UIAgreementMapper agreementMapper;
	
	public Paginate<ResultSet> getListAgreement(UIAgreementCondition conditionVO) throws Exception {
		int totalCount = agreementMapper.countList(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(agreementMapper.getList(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}
	
	public void insertAgreement(UIAgreementCondition condition){
		
		Long version = agreementMapper.getVersion(condition);
		
		if(version != null && (!version.equals(""))){
			version = version + 1;
		}else{
			version = (long) 1;
		}
		
		condition.setAgreementVersion(version);
		
		agreementMapper.insertAgreement(condition);
	}
	
	public void insertAgreeApply(UIAgreementCondition condition){
		if(condition.getSrchAgreeSeq1() != null && (!condition.getSrchAgreeSeq1().equals(""))){
			condition.setAgreementSeq(Long.valueOf(condition.getSrchAgreeSeq1()));
			condition.setApplyCheck(Long.valueOf(condition.getSrchApplyCheck1()));
			agreementMapper.insertAgreeApply(condition);
		}
		if(condition.getSrchAgreeSeq2() != null && (!condition.getSrchAgreeSeq2().equals(""))){
			condition.setAgreementSeq(Long.valueOf(condition.getSrchAgreeSeq2()));
			condition.setApplyCheck(Long.valueOf(condition.getSrchApplyCheck2()));
			agreementMapper.insertAgreeApply(condition);
		}
		if(condition.getSrchAgreeSeq3() != null && (!condition.getSrchAgreeSeq3().equals(""))){
			condition.setAgreementSeq(Long.valueOf(condition.getSrchAgreeSeq3()));
			condition.setApplyCheck(Long.valueOf(condition.getSrchApplyCheck3()));
			agreementMapper.insertAgreeApply(condition);
		}
		
	}
	
	public void updateActiveApply(UIAgreementCondition condition){
		
		agreementMapper.updateActiveApply(condition);
	}
	
	public List<UIAgreementCodeVO> getListCode(){
		
		return agreementMapper.getListCode();
	}
	
	
	public List<UIAgreementCondition> getCallAgree(UIUnivCourseApplyCondition condition){
		
		return agreementMapper.getCallAgree(condition);
	}
	
	public List<ResultSet> getAgreeList(UIAgreementCondition condition){
		return agreementMapper.getAgreeList(condition);
	}

	public List<ResultSet> getClause(UIAgreementCondition agreeCondition) {
		return agreementMapper.getClause(agreeCondition);
	}

	public UIAgreementCondition getActiveAgreeSeq(UIAgreementCondition condition) {
		return agreementMapper.getActiveAgreeSeq(condition);
	}

	public UIAgreementCondition getDetailAgreement(UIAgreementCondition condition) {
		return agreementMapper.getDetailAgreement(condition);
	}
}
