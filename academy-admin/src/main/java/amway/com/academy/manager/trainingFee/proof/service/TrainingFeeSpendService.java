package amway.com.academy.manager.trainingFee.proof.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeSpendService {
	/**
	 * 지출증빙 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTrainingFeeSpendListCount(RequestBox requestBox);
	
	/**
	 * 지출증빙 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectTrainingFeeSpendList(RequestBox requestBox) throws Exception;

	/**
	 * 지출증빙 상세 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTrainingFeeSpendDetailListCount(RequestBox requestBox);

	/**
	 * 지출증빙 상세 리스트
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectTrainingFeeSpendDetailList(RequestBox requestBox);

	/**
	 * 교육비 지출증빙 - 지급 승인
	 * @param requestBox
	 * @return
	 */
	public int saveSpendConfrim(RequestBox requestBox);

	/**
	 * 교육비 지출증빙 - 지급 반려
	 * @param requestBox
	 * @return
	 */
	public int saveSpendReject(RequestBox requestBox);
	
	/**
	 * 교육비 지출증빙 - 영수증 확인
	 * @param requestBox
	 * @return
	 */
	public int saveSpendChecking(RequestBox requestBox) throws SQLException;

	/**
	 * 지출증빙 - 영수증 가져오기
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrainingFeeSpendReceiptList(RequestBox requestBox);

	public int selectSpendDoNotIt(RequestBox requestBox);

	/**
	 * 계획서, 지출 젳출 상태값 알아 오기
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectStatus(RequestBox requestBox) throws SQLException;

	/**
	 * 지출증빙 반련 SMS 전송
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> callSmsRejectSend(Map<String, Object> map);

	/**
	 * 지출증빙 승인 전 임대차 미승인건 체크
	 * @param requestBox
	 * @return
	 */
	public int selectNotRentConfrim(RequestBox requestBox);

}