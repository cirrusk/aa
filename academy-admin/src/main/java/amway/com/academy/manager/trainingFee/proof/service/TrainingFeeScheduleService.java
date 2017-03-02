package amway.com.academy.manager.trainingFee.proof.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeScheduleService {
	
	/**
	 * 일정관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectPlanList(RequestBox requestBox) throws Exception;
	
	/**
	 * 일정관리 등록
	 * @param requestBox
	 * @throws Exception
	 */	
	public int insertPlanAjax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 일정관리 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int trainingFeePlanUpdateAjax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 일정관리 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox trainingFeePlanDetail(RequestBox requestBox) throws Exception;

	/**
	 * 일정관리 저장시 일정 중복 체크
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrFeeScheduleVal(RequestBox requestBox);

	/**
	 * 대상자 존재 여부 체크
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrFeeTargetVal(RequestBox requestBox);

	/**
	 * SMS 발송 대상자
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectSMSData(RequestBox requestBox);

	/**
	 * SMS 발송 PROCEDURE CALL
	 * @param smsMap
	 * @return 
	 */
	public Map<String, Object> callSmsAllSend(Map<String, Object> smsMap);

} 
