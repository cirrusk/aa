package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeSpendMapper {
	
	/**
	 * 지출증빙 리스트 count
	 * @param requestBox
	 * @return
	 */
	int selectTrainingFeeSpendListCount(RequestBox requestBox);
	
	/**
	 * 지출증빙 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectTrainingFeeSpendList(RequestBox requestBox) throws Exception;

	int selectTrainingFeeSpendDetailListCount(RequestBox requestBox);

	List<DataBox> selectTrainingFeeSpendDetailList(RequestBox requestBox);

	int updateSpend(RequestBox requestBox);

	int updateSpendGroup(RequestBox requestBox);

	int updateSpendReject(RequestBox requestBox);

	int updateTrfeeTarget(RequestBox requestBox);

	List<Map<String, Object>> selectTrainingFeeSpendReceiptList(RequestBox requestBox);

	int saveSpendChecking(RequestBox requestBox);

	int selectSpendDoNotIt(RequestBox requestBox);

	int insertNoteSend(RequestBox requestBox);

	int insertSMSSendHIST(RequestBox requestBox);

	Map<String, Object> selectStatus(RequestBox requestBox);

	Map<String, Object> callSmsRejectSend(Map<String, Object> map);

	int selectNotRentConfrim(RequestBox requestBox);

}