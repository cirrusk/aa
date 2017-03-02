package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeCheckListService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeCheckListServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeCheckListService {
	@Autowired
	private TrainingFeeCheckListMapper trainingFeeCheckDAO;

	@Override
	public int selectTrainingFeeCheckListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeCheckDAO.selectTrainingFeeCheckListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectTrainingFeeCheckList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeCheckDAO.selectTrainingFeeCheckList(requestBox);
	}

	@Override
	public int updateAs400UploadFalg(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> saveMap = new HashMap<String, Object>();
		String spendId[] = requestBox.get("spendid").split(",");
		String depabono[] = requestBox.get("depabono").split(",");
		int result = 0;
		
		saveMap.put("giveyear", requestBox.get("giveyear"));
		saveMap.put("givemonth", requestBox.get("givemonth"));
		saveMap.put("as400uploadfalg", requestBox.get("as400uploadfalg"));
		saveMap.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		
		for(int row=0;row<spendId.length;row++){
			saveMap.put("spendid", spendId[row]);
			saveMap.put("depabono", depabono[row]);
			
			result = result + trainingFeeCheckDAO.updateAs400UploadFalg(saveMap);
			result = result + trainingFeeCheckDAO.updateGroupAs400UploadFalg(saveMap);
		}
		
		return result;
	}

}