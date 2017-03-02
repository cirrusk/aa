package amway.com.academy.trainingFee.trainingFeeMain.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.trainingFee.trainingFeeMain.service.TrainingFeeMainService;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeMainServiceImpl implements TrainingFeeMainService{
	@Autowired
	private TrainingFeeMainMapper trainingFeeMainMapper;

	public Map<String, Object> selectSchedule(RequestBox requestBox) throws Exception {
		// 일정 관리 체크
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		// 일정 검색 오픈 여부를 체크
		List<Map<String, Object>> scheduleMap = trainingFeeMainMapper.selectSchedule(requestBox);
		String currentYm = "NOT";
		String currentYmLoop = "NOT";
		String giveyear  = "";
		String givemonth = "";
		String fiscalyear = "";
		String getyymm   = (String) scheduleMap.get(0).get("getYm");
		int basNum = 11;
		
		for(int i=0; i<scheduleMap.size(); i++) {
			Map<String, Object> forMap =  scheduleMap.get(i);
			currentYm = (String) forMap.get("currentYm");
			// 일정 등록이 되어 있다면.
			if( !currentYm.equals("NOT") ) {
				currentYmLoop = (String) forMap.get("currentYm");
				giveyear  = forMap.get("giveyear").toString();
				givemonth = (String) forMap.get("givemonth");
				fiscalyear = forMap.get("fiscalyear").toString();
			}
		}
		
		if( "NOT".equals(currentYmLoop) ) {
			int imm = Integer.parseInt(getyymm.substring(4,6));
			
			rtnMap.put("giveopen" , "N");
			rtnMap.put("giveyear" , getyymm.substring(0,4));
			rtnMap.put("givemonth", getyymm.substring(4,6));
			
			if(imm<basNum) { 
				rtnMap.put("fiscalyear", getyymm.substring(0,4));
			} else {
				rtnMap.put("fiscalyear", Integer.parseInt(getyymm.substring(0,4)) + 1 );
			}
		} else {
			rtnMap.put("giveopen"  , "Y");
			rtnMap.put("giveyear"  , giveyear);
			rtnMap.put("givemonth" , givemonth);
			rtnMap.put("fiscalyear", fiscalyear);
		}
		
		return rtnMap;
	}
	
	@Override
	public Map<String, Object> selectTargetInformation(RequestBox requestBox) throws Exception {
		return trainingFeeMainMapper.selectTargetInformation(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectMainList(RequestBox requestBox) throws Exception {
		return trainingFeeMainMapper.selectMainList(requestBox);
	}

	@Override
	public Map<String, String> selectTrFeeAgreeText(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreeText(requestBox);
	}

	@Override
	public int inserTrfeeAgreePledge(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.inserTrfeeAgreePledge(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectTrfeeAgreeThirdperson(
			RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrfeeAgreeThirdperson(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectTrfeeAgreeDeleg(
			RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrfeeAgreeDeleg(requestBox);
	}

	@Override
	public int inserTrfeeAgreeDeleg(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		int result = 0;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		rtnMap.putAll(requestBox);
		Vector<Object> delegatoraboNo = requestBox.getVector("delegatoraboNo");
		
		for(int num=0; num<requestBox.getVector("delegaboNo").size(); num++){
	        rtnMap.put("fiscalyear", requestBox.get("fiscalyear"));
	        rtnMap.put("delegtypecode", requestBox.get("delegtypecode"));
			rtnMap.put("delegaboNo", requestBox.get("delegaboNo"));
			rtnMap.put("delegatoraboNo", delegatoraboNo.get(num));
			rtnMap.put("agreeid"  , requestBox.get("agreeid"));
			rtnMap.put("agreeflag", requestBox.get("agreeflag"));
			rtnMap.put("depaboNo" , requestBox.get("depaboNo"));
			
			if("1".equals(requestBox.get("delegtypecode"))){
				result = result+trainingFeeMainMapper.updateTrfeeAgreeDeleg(rtnMap);	
			} else {
				result = result+trainingFeeMainMapper.inserTrfeeAgreeDeleg(rtnMap);
			}
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectTrfeeAgreeDelegEm(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrfeeAgreeDelegEm(requestBox);
	}

	@Override
	public int inserTrfeeThirdperson(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int result = 1;
		rtnMap.putAll(requestBox);
		Vector<Object> thirdperson = requestBox.getVector("thirdperson");
		
		for(int num=0; num<requestBox.getVector("thirdperson").size(); num++){
			rtnMap.put("fiscalyear", requestBox.get("fiscalyear"));
			rtnMap.put("agreeid", requestBox.get("agreeid"));
			rtnMap.put("thirdperson", thirdperson.get(num));
			rtnMap.put("depaboNo", requestBox.get("depaboNo"));
			rtnMap.put("agreeflag", requestBox.get("agreeflag"));
			rtnMap.put("", requestBox.get(""));
			
			result = result + trainingFeeMainMapper.inserTrfeeThirdperson(rtnMap);
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectGroupTargetList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectGroupTargetList(requestBox);
	}

	@Override
	public Map<String, String> selectTrFeeAgreePledge(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreePledge(requestBox);
	}

	@Override
	public Map<String, Object> selectTrFeeThirdPerson(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeThirdPerson(requestBox);
	}

	@Override
	public Map<String, String> selectTrFeeAgreeDeleg(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreeDeleg(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectPF(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectPF(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectTrFeeAgreeTextPop(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreeTextPop(requestBox);
	}

	@Override
	public Map<String, String> selectTrFeeAgreeDelegFull(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreeDelegFull(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectTrFeeThirdPersonList(
			RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeThirdPersonList(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectTrFeeAgreeDelegFullList(
			RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectTrFeeAgreeDelegFullList(requestBox);
	}

	@Override
	public List<Map<String, Object>> selectPtList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.selectPtList(requestBox);
	}

	@Override
	public int updateThirdpersonAgree(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeMainMapper.updateThirdpersonAgree(requestBox);
	}

}
