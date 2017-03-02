package amway.com.academy.manager.common.targetRule.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

@Mapper
public interface TargetRuleMapper {

	/**
	 * 대상자코드 LIst
	 * @param requestBox
	 * @throws Exception
	 */
	int targetRuleCount(RequestBox requestBox) throws Exception;

	List<DataBox> targetRuleList(RequestBox requestBox) throws Exception;

	DataBox targetRulePop(RequestBox requestBox) throws Exception;

	List<DataBox> targetRuleCode(RequestBox requestBox) throws Exception;

	DataBox targetRuleCheck(RequestBox requestBox) throws Exception;

	int targetRuleInsert(RequestBox requestBox) throws Exception;

}