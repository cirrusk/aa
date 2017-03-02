package amway.com.academy.manager.common.targetRule.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface TargetRuleService {

	/**
	 * 대상자조건 설정 카운트
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetRuleCount(RequestBox requestBox)throws Exception;

	/**
	 * 대상자조건 설정 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> targetRuleList(RequestBox requestBox)throws Exception;

	/**
	 * 대상자조건 설정 팝업
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox targetRulePop(RequestBox requestBox) throws Exception;

	/**
	 * 대상자조건 설정 팝업
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> targetRuleCode(RequestBox requestBox) throws Exception;

	/**
	 * 대상자조건 설정 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetRuleInsert(RequestBox requestBox) throws Exception;

}
