package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeRentService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeRentServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeRentService {
	@Autowired
	private TrainingFeeRentMapper trainingFeeRentDAO;

	@Override
	public int selectRentListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeRentDAO.selectRentListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectRentList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentList(requestBox);
	}

	@Override
	public Map<String, Object> selectRentDetailInfo(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentDetailInfo(requestBox);
	}
	
	@Override
	public int selectRentDetailCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentDetailCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectRentDetailList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentDetailList(requestBox);
	}
	
	@Override
	public int saveRentConfrim(RequestBox requestBox) {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		int result = 0;
		// 입차료 승인		
		result =  trainingFeeRentDAO.saveRentApprove(requestBox);
		result =  result + trainingFeeRentDAO.insertRentApprove(requestBox);
		
		return result;
	}
	
	@Override
	public int saveRentGrpConfrim(RequestBox requestBox) {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		int result = 0;
		// 입차료 승인		
		result =  trainingFeeRentDAO.saveRentApprove(requestBox);
		result =  result + trainingFeeRentDAO.insertRentGrpApprove(requestBox);
		
		return result;
	}
	
	@Override
	public int updateRentReject(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeRentDAO.updateRentReject(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectRentDetailImg(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentDetailImg(requestBox);
	}
	
	@Override
	public int saveRentImgCheck(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeRentDAO.saveRentImgCheck(requestBox);
	}
	
	@Override
	public int selectRentGrpDetailListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeRentDAO.selectRentGrpDetailListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectRentGrpDetailList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectRentGrpDetailList(requestBox);
	}
		
	@Override
	public int saveRentGrpApprove(RequestBox requestBox) {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		int result = 0;
		// 입차료 승인
		
		result =  trainingFeeRentDAO.saveRentApprove(requestBox);
		result =  trainingFeeRentDAO.insertRentGrpApprove(requestBox);
		
		return result;
	}

	@Override
	public DataBox selectTotalCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeRentDAO.selectTotalCount(requestBox);
	}
	
}