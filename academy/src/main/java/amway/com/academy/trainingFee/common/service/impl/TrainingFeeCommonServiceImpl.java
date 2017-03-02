package amway.com.academy.trainingFee.common.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.trainingFee.common.service.TrainingFeeCommonService;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeCommonServiceImpl implements TrainingFeeCommonService{
	@Autowired
	private TrainingFeeCommonMapper trainingFeeCommonMapper;

	@Override
	public int inserTrfeeSystemProcessLog(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeCommonMapper.inserTrfeeSystemProcessLog(requestBox);
	}


}
