package amway.com.academy.trainingFee.trainingFeePlan.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface TrainingFeePlanService {
	
	/**
	 * 사전계획등록 page - 사전계획 등록한 데이터 추출 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 회계년도를 가져온다.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox);
	
	/**
	 * 교육비 회계년도를 리스트 가져온다.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectTrFeeRentYear(RequestBox requestBox);
	
	public List<Map<String, String>> selectTrFeeRentMonth(Map<String, Object> searchMap);
	
	/**
	 * 수정 또는 조회 모드 일 경우 - rent내역 가져오기
	 * @param searchMap
	 * @return
	 */
	public Map<String, String> selectTrFeeRentList(RequestBox requestBox);
	
	public Map<String, String> selectTrFeePlan(RequestBox requestBox);
	
	public List<Map<String, String>> selectTrFeePlanItem(RequestBox requestBox);
	
	/**
	 * 계획서 신규 저장
	 * @param requestBox
	 * @return
	 */
	public int inserTrainingFeePlan(RequestBox requestBox);
	
	/**
	 * 계획서 수정 저장
	 * @param requestBox
	 * @return
	 */
	public int updateTrainingFeePlan(RequestBox requestBox);
	
	/**
	 * 계획서 삭제
	 * @param requestBox
	 * @return
	 */
	public int deleteTrainingFeePlan(RequestBox requestBox);

	public List<Map<String, String>> selectPlanUseMon(Map<String, Object> tempMap);
	
	/**
	 * 계획서 완료
	 * @param requestBox
	 * @return
	 */
	public int updateTrainingFeePlanConfirm(RequestBox requestBox);

	/**
	 * 임차료 첨부파일
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> selectTrFeeRentFileList(RequestBox requestBox);

	public Map<String, String> selectRentDeleteVaildate(RequestBox requestBox);
	
}
