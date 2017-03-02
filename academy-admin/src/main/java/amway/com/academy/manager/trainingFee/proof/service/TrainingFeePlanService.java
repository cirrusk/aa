package amway.com.academy.manager.trainingFee.proof.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeePlanService {
	/**
	 * 사전계획서 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTrainingFeeSpendingListCount(RequestBox requestBox);
	
	/**
	 * 사전계획서 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectTrainingFeeSpendingList(RequestBox requestBox) throws Exception;

	/**
	 * 사전계획서 상세 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTrainingFeePlanDetailListCount(RequestBox requestBox);

	/**
	 * 사전계획서 상세 리스트
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectTrainingFeePlanDetailList(RequestBox requestBox);
	
	
}