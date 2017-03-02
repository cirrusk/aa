package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeScheduleService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeScheduleServiceImpl implements TrainingFeeScheduleService {
	@Autowired
	private TrainingFeeScheduleMapper trainingFeePlanMapper;
	
	@Override
	public List<DataBox> selectPlanList(RequestBox requestBox) throws Exception {
		return trainingFeePlanMapper.selectPlanList(requestBox);
	}
	
	@Override
	public int insertPlanAjax(RequestBox requestBox) throws SQLException {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int result = 0;
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		result = trainingFeePlanMapper.insertPlanAjax(requestBox);
		
		rtnMap.put("orddt", requestBox.get("giveyear")+""+requestBox.get("givemonth"));
		rtnMap.put("giveyear", requestBox.get("giveyear"));
		rtnMap.put("givemonth", requestBox.get("givemonth"));
		rtnMap.put("rtn","");
		
		// PT그룹 가져오기		
//		trainingFeePlanMapper.sptrfeePTList(rtnMap);
//		trainingFeePlanMapper.sptrfeePTList1(rtnMap);
		
		if("Y".equals(requestBox.get("smssendflag"))) {
			result = result + trainingFeePlanMapper.insertNoteSend(requestBox);
			result = result + trainingFeePlanMapper.insertSMSSendHIST(requestBox);
		}
		
		return result;
	}
	
	@Override
	public int trainingFeePlanUpdateAjax(RequestBox requestBox) throws SQLException {
		int result = 0;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("giveyear", requestBox.get("giveyear"));
		rtnMap.put("givemonth", requestBox.get("givemonth"));
		rtnMap.put("rtn","");
		
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		result = trainingFeePlanMapper.trainingFeePlanUpdateAjax(requestBox);
		
		if("Y".equals(requestBox.get("smssendflag"))) {
			result = result + trainingFeePlanMapper.insertNoteSend(requestBox); 
			result = result + trainingFeePlanMapper.insertSMSSendHIST(requestBox);
		}
		
		return result;
		
	}
	
	@Override
	public DataBox trainingFeePlanDetail(RequestBox requestBox)
			throws Exception {
		return trainingFeePlanMapper.trainingFeePlanDetail(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectTrFeeScheduleVal(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanMapper.selectTrFeeScheduleVal(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectTrFeeTargetVal(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanMapper.selectTrFeeTargetVal(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectSMSData(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanMapper.selectSMSData(requestBox);
	}

	@Override
	public Map<String, Object> callSmsAllSend(Map<String, Object> smsMap) {
		// TODO Auto-generated method stub		
		trainingFeePlanMapper.callSmsAllSend(smsMap);
		return smsMap;
		
	}

}
