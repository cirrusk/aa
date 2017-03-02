package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeePlanMapper {
	
	/**
	 * 사전계획서 리스트 count
	 * @param requestBox
	 * @return
	 */
	int selectTrainingFeeSpendingListCount(RequestBox requestBox);
	
	/**
	 * 사전계획서 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectTrainingFeeSpendingList(RequestBox requestBox) throws Exception;

	int selectTrainingFeePlanDetailListCount(RequestBox requestBox);

	List<DataBox> selectTrainingFeePlanDetailList(RequestBox requestBox);

}