package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.trainingFee.proof.service.TrainingFeePlanService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeePlanServiceImpl extends EgovAbstractServiceImpl implements TrainingFeePlanService {
	@Autowired
	private TrainingFeePlanMapper trainingFeeSpendingDAO;

	@Override
	public int selectTrainingFeeSpendingListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeSpendingDAO.selectTrainingFeeSpendingListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectTrainingFeeSpendingList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeSpendingDAO.selectTrainingFeeSpendingList(requestBox);
	}

	@Override
	public int selectTrainingFeePlanDetailListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendingDAO.selectTrainingFeePlanDetailListCount(requestBox);
	}

	@Override
	public List<DataBox> selectTrainingFeePlanDetailList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendingDAO.selectTrainingFeePlanDetailList(requestBox);
	}

}