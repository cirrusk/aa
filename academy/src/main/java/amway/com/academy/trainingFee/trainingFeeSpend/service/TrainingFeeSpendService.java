package amway.com.academy.trainingFee.trainingFeeSpend.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeSpendService {

	/**
	 * 화면 로딩 기초 데이터
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox);
	
	/**
	 * 지출 증빙 리스트
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> selectTrFeeSpendList(RequestBox requestBox);
	
	/**
	 * 지출 증빙 사전계획서 selectbox
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox);
	
	/**
	 * 지출 증빙 교육일자 월 selectbox
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> selectPlanUseMon(Map<String, Object> tempMap);
	
	/**
	 * 지출증빙 insert
	 * @param requestBox
	 * @return
	 */
	public int inserTrainingFeeSpend(RequestBox requestBox);
	
	/**
	 * 지출증빙 update
	 * @param requestBox
	 * @return
	 */
	public int updateTrainingFeeSpend(RequestBox requestBox);
	
	/**
	 * 지출증빙 delete
	 * @param requestBox
	 * @return
	 */
	public int deleteTrainingFeeSpend(RequestBox requestBox);
	
	/**
	 * 리스트 클릭시 상세 내역 가져 오기
	 * @param requestBox
	 * @return
	 */
	public Map<String, String> selectTrFeeSpend(RequestBox requestBox);
	
	/**
	 * 리스트 클리시 상세 내역 영수증 항목 가져 오기
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> selectTrFeeSpendItem(RequestBox requestBox);
	
	/**
	 * 지출증빙 제출
	 * @param requestBox
	 * @return
	 */
	public int updateTrainingFeeSpendConfirm(RequestBox requestBox);
	
}
