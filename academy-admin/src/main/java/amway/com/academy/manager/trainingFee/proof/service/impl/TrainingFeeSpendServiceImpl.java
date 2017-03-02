package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeSpendService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeSpendServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeSpendService {
	@Autowired
	private TrainingFeeSpendMapper trainingFeeSpendDAO;

	@Override
	public int selectTrainingFeeSpendListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeSpendDAO.selectTrainingFeeSpendListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectTrainingFeeSpendList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		List<DataBox> rtnList = trainingFeeSpendDAO.selectTrainingFeeSpendList(requestBox);

		return rtnList;
	}

	@Override
	public int selectTrainingFeeSpendDetailListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrainingFeeSpendDetailListCount(requestBox);
	}

	@Override
	public List<DataBox> selectTrainingFeeSpendDetailList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrainingFeeSpendDetailList(requestBox);
	}

	@Override
	public int saveSpendConfrim(RequestBox requestBox) {
		// TODO Auto-generated method stub
		int result=0;
		requestBox.put("spendconfirmflag", "Y");
		requestBox.put("rejecttext", "");
		requestBox.put("smstext", "");
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		result = trainingFeeSpendDAO.updateSpend(requestBox);
		result = result + trainingFeeSpendDAO.updateSpendGroup(requestBox);
		result = result + trainingFeeSpendDAO.updateTrfeeTarget(requestBox);
		return result;
	}

	@Override
	public int saveSpendReject(RequestBox requestBox) {
		// TODO Auto-generated method stub
		int result=0;
		requestBox.put("spendconfirmflag", "R");
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		result = trainingFeeSpendDAO.updateSpend(requestBox);
		result = result + trainingFeeSpendDAO.updateSpendGroup(requestBox);
		result = result + trainingFeeSpendDAO.updateTrfeeTarget(requestBox);
		// 맞춤쪽지 발송
		result = result + trainingFeeSpendDAO.insertNoteSend(requestBox);
		// SMS 방솔
		result = result + trainingFeeSpendDAO.insertSMSSendHIST(requestBox);
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectTrainingFeeSpendReceiptList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrainingFeeSpendReceiptList(requestBox);
	}

	@Override
	public int saveSpendChecking(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeSpendDAO.saveSpendChecking(requestBox);
	}

	@Override
	public int selectSpendDoNotIt(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectSpendDoNotIt(requestBox);
	}

	@Override
	public Map<String, Object> selectStatus(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectStatus(requestBox);
	}

	@Override
	public Map<String, Object> callSmsRejectSend(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.callSmsRejectSend(map);
	}

	@Override
	public int selectNotRentConfrim(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectNotRentConfrim(requestBox);
	}

}