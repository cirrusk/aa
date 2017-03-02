package amway.com.academy.manager.trainingFee.trainingFeeCommon.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeCommonServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeCommonService {
	@Autowired
	private TrainingFeeCommonMapper trainingFeeCommonDAO;

	@Override
	public Map<String, Object> selectTargetInfoList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectTargetInfoList(requestBox);
	}

	@Override
	public List<DataBox> selectBRList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectBRList(requestBox);
	}

	@Override
	public List<DataBox> selectGrpCdList(RequestBox requestBox)
			throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectGrpCdList(requestBox);
	}

	@Override
	public List<DataBox> selectCodeList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectCodeList(requestBox);
	}

	@Override
	public List<DataBox> selectLOAList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectLOAList(requestBox);
	}

	@Override
	public List<DataBox> selectDeptList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectDeptList(requestBox);
	}

	@Override
	public List<DataBox> selectCPinList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeCommonDAO.selectCPinList(requestBox);
	}
	

}