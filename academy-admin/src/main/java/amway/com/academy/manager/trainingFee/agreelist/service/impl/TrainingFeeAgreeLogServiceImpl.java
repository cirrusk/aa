package amway.com.academy.manager.trainingFee.agreelist.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.agreelist.service.TrainingFeeAgreeLogService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

@Service
public class TrainingFeeAgreeLogServiceImpl implements TrainingFeeAgreeLogService{
	
	@Autowired
	private TrainingFeeAgreeLogMapper trainingFeeAgreeLogDAO;

	@Override
	public int selectAgreeLogListCount(RequestBox requestBox) throws Exception {
		return trainingFeeAgreeLogDAO.selectAgreeLogListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectAgreeLogList(RequestBox requestBox) throws Exception {
		return trainingFeeAgreeLogDAO.selectAgreeLogList(requestBox);
	}
	
	@Override
	public int selectAgreeDelegLogListCount(RequestBox requestBox) throws Exception {
		return trainingFeeAgreeLogDAO.selectAgreeDelegLogListCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectAgreeDelegLogList(RequestBox requestBox) throws Exception {
		return trainingFeeAgreeLogDAO.selectAgreeDelegLogList(requestBox);
	}

	@Override
	public int selectThirdpersonLogListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeAgreeLogDAO.selectThirdpersonLogListCount(requestBox);
	}

	@Override
	public List<DataBox> selectThirdpersonLogList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeAgreeLogDAO.selectThirdpersonLogList(requestBox);
	}

	@Override
	public int selectSpecialLogListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeAgreeLogDAO.selectSpecialLogListCount(requestBox);
	}

	@Override
	public List<DataBox> selectSpecialLogList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeAgreeLogDAO.selectSpecialLogList(requestBox);
	}

	@Override
	public int saveSpecialLog(RequestBox requestBox) {
		// TODO Auto-generated method stub
		int result=0;
		requestBox.put("adminId", requestBox.getSession(SessionUtil.sessionAdno));
		result = trainingFeeAgreeLogDAO.insertSpecialLog(requestBox);
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectAgreePrint(RequestBox requestBox) {
		// TODO Auto-generated method stub
		Map<String,Object> rtnMap = new HashMap<String,Object>();
		
		if("100".equals(requestBox.get("agreetypecode"))){
			List<Map<String, Object>> textMap = trainingFeeAgreeLogDAO.selectAgreePledgePrint(requestBox);
			
			for(int i=0;i<textMap.size();i++){
				rtnMap = textMap.get(i);
				
				String agreetext = StringUtil.replaceTag(rtnMap.get("agreetext").toString());
				rtnMap.put("agreeTxt", agreetext);
				textMap.set(i, rtnMap);
			}
			
			return textMap;
		} else if("200".equals(requestBox.get("agreetypecode"))){
			List<Map<String, Object>> textMap = trainingFeeAgreeLogDAO.selectAgreeDelegPrint(requestBox);
			
			for(int i=0;i<textMap.size();i++){
				rtnMap = textMap.get(i);
				
				String agreetext = StringUtil.replaceTag(rtnMap.get("agreetext").toString());
				rtnMap.put("agreeTxt", agreetext);
				textMap.set(i, rtnMap);
			}
			
			return textMap;
		} else if("300".equals(requestBox.get("agreetypecode"))){
			List<Map<String, Object>> textMap = trainingFeeAgreeLogDAO.selectThirdpersonPrint(requestBox);
			
			for(int i=0;i<textMap.size();i++){
				rtnMap = textMap.get(i);
				
				String agreetext = StringUtil.replaceTag(rtnMap.get("agreetext").toString());
				rtnMap.put("agreeTxt", agreetext);
				textMap.set(i, rtnMap);
			}
			
			return textMap;
		}
		
		return null;		
	}

	@Override
	public int deleteSpecialLog(RequestBox requestBox) throws SQLException {
		Map<String, Object> deleteMap = new HashMap<String, Object>();
		String fiscalyear[] = requestBox.get("fiscalyear").split(",");
		String specialid[] = requestBox.get("specialid").split(",");
		
		for(int i=0; i<fiscalyear.length; i++) {
			deleteMap.put("fiscalyear", fiscalyear[i]);
			deleteMap.put("specialid", specialid[i]);
			
			trainingFeeAgreeLogDAO.deleteSpecialLog(deleteMap);
		}
		
		return 0;
	}


}
