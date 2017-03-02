package amway.com.academy.manager.trainingFee.util.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.trainingFee.util.service.TrainingFeeUtilService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeUtilServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeUtilService {
	@Autowired
	private TrainingFeeUtilMapper trainingFeeUtilDAO;

	@Override
	public int selectSystemLogListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeUtilDAO.selectSystemLogListCount(requestBox);
	}

	@Override
	public List<DataBox> selectSystemLogList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeUtilDAO.selectSystemLogList(requestBox);
	}

	@Override
	public int selectSMSLogListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeUtilDAO.selectSMSLogListCount(requestBox);
	}

	@Override
	public List<DataBox> selectSMSLogList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeUtilDAO.selectSMSLogList(requestBox);
	}

	

}