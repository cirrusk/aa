package amway.com.academy.manager.trainingFee.agree.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.agree.service.TrainingFeeWrittenService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeWrittenServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeWrittenService {
	@Autowired
	private TrainingFeeWrittenMapper trainingFeeWrittenDAO;

	@Override
	public int selectWrittenListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeWrittenDAO.selectWrittenListCount(requestBox);
	}

	@Override
	public List<DataBox> selectWrittenList(RequestBox requestBox)
			throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeWrittenDAO.selectWrittenList(requestBox);
	}
	
	@Override
	public DataBox selectWrittenData(RequestBox requestBox)
			throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeWrittenDAO.selectWrittenData(requestBox);
	}

	@Override
	public int saveWrittenEdit(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeWrittenDAO.saveWrittenEdit(requestBox);
	}

	
	
}