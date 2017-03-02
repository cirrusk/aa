package amway.com.academy.manager.reservation.baseRule.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.baseRule.service.BaseRuleService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class BaseRuleServiceImpl implements BaseRuleService{
	@Autowired
	public BaseRuleMapper baseRuleDAO;

	@Override
	public List<DataBox> baseRuleListAjax(RequestBox requestBox) throws Exception {
		
		List<DataBox> list = baseRuleDAO.baseRuleListAjax(requestBox);
		
		List<DataBox> baseRuleList = new ArrayList<DataBox>();
		
		try{
		
			for (DataBox tempDataBox : list){
				
				if(tempDataBox.get("constrainttype").equals("C01")){
					
					String[] result = tempDataBox.get("role").toString().split("\\|");
					StringBuffer temp = new StringBuffer("");
					tempDataBox.remove("role");
					for(int i = 0; i < result.length; i++){
						if(!("N").equals(result[i])){
							
							if(i == 0){
								temp.append(result[i]+",");
							}else{
								temp.append(result[i]+",");
								
							}
						}
					}
					
					String role = "";
					if(0 < temp.length()){
						role = temp.substring(0, temp.length()-1);
					}
					tempDataBox.put("role", role);
					
				}
				
				baseRuleList.add(tempDataBox);
			}
		
		}catch(SqlSessionException e){
			e.printStackTrace();
		}

		return baseRuleList;
	}

	@Override
	public int baseRuleListCount(RequestBox requestBox) throws Exception {
		return baseRuleDAO.baseRuleListCount(requestBox);
	}

	@Override
	public int baseRuleInsertAjax(RequestBox requestBox) throws Exception {
		return baseRuleDAO.baseRuleInsertAjax(requestBox);
	}

	@Override
	public DataBox baseRuleDetailAjax(RequestBox requestBox) throws Exception {
		
		return baseRuleDAO.baseRuleDetailAjax(requestBox);
	}

	@Override
	public int baseRuleUpdateAjax(RequestBox requestBox) throws Exception {
		
		Map<String, String> rsvSpecialPpMapInsert;
		
		if("C03".equals(requestBox.get("afterConstrainttype"))){
			// 특정 교육장 맵핑 tbl delete
			baseRuleDAO.ppToRoomTypeDeleteAjax(requestBox);
			
			for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
				rsvSpecialPpMapInsert = new HashMap<String, String>();
				
				rsvSpecialPpMapInsert.put("settingseq", String.valueOf(requestBox.getVector("settingseq").get(0)));
				rsvSpecialPpMapInsert.put("sessionAccount", String.valueOf(requestBox.getVector("sessionAccount").get(0)));
				rsvSpecialPpMapInsert.put("typeseq", String.valueOf(requestBox.getVector("typeseq").get(i)));
				rsvSpecialPpMapInsert.put("statuscode", String.valueOf(requestBox.getVector("statuscode").get(0)));
				
				// 특정 교육장 맵핑 tbl에 insert
				baseRuleDAO.rsvSpecialPpMapInsert(rsvSpecialPpMapInsert);
			}
		}
		
		//누적예액 횟수 수정
		return baseRuleDAO.baseRuleUpdateAjax(requestBox);
	}

	@Override
	public List<Map<String, String>> searchPpToRoomTypeList(RequestBox requestBox) throws Exception {
		return baseRuleDAO.searchPpToRoomTypeList(requestBox);
	}

	@Override
	public int ppToRoomTypeInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		Map<String, String> rsvSpecialPpMapInsert;
		
		// 누적예약 횟수 등록
		result = baseRuleDAO.ppToRoomTypeInsertAjax(requestBox);
		
		for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
			rsvSpecialPpMapInsert = new HashMap<String, String>();
			
			rsvSpecialPpMapInsert.put("settingseq", String.valueOf(requestBox.getVector("settingseq").get(0)));
			rsvSpecialPpMapInsert.put("sessionAccount", String.valueOf(requestBox.getVector("sessionAccount").get(0)));
			rsvSpecialPpMapInsert.put("typeseq", String.valueOf(requestBox.getVector("typeseq").get(i)));
			rsvSpecialPpMapInsert.put("typeseq", String.valueOf(requestBox.getVector("typeseq").get(i)));
			rsvSpecialPpMapInsert.put("statuscode", String.valueOf(requestBox.getVector("statuscode").get(0)));
			
			// 특정 교육장 맵핑 tbl에 insert
			result = baseRuleDAO.rsvSpecialPpMapInsert(rsvSpecialPpMapInsert);
		}
		
		return result;
	}

	@Override
	public int ppToRoomTypeUpdateAjax(RequestBox requestBox) throws Exception {
		//특정 교육장 삭제
		int result = baseRuleDAO.ppToRoomTypeDeleteAjax(requestBox);
		
		if(result > 0 ){
			//누적예약 횟수 수정
			result = baseRuleDAO.baseRuleUpdateAjax(requestBox);
		}
		return result;
	}
	
	@Override
	public int baseRuleUpdateAndInsertAjax(RequestBox requestBox) throws Exception {
		
		Map<String, String> rsvSpecialPpMapInsert;
		
		//누적얘약 횟수 수정
		int result = baseRuleDAO.baseRuleUpdateAjax(requestBox);
		
		if(result > 0){
			for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
				rsvSpecialPpMapInsert = new HashMap<String, String>();
				
				rsvSpecialPpMapInsert.put("settingseq", String.valueOf(requestBox.getVector("settingseq").get(0)));
				rsvSpecialPpMapInsert.put("sessionAccount", String.valueOf(requestBox.getVector("sessionAccount").get(0)));
				rsvSpecialPpMapInsert.put("typeseq", String.valueOf(requestBox.getVector("typeseq").get(i)));
				rsvSpecialPpMapInsert.put("statuscode", String.valueOf(requestBox.getVector("statuscode").get(0)));
				
				// 특정 교육장 맵핑 tbl에 insert
				result = baseRuleDAO.rsvSpecialPpMapInsert(rsvSpecialPpMapInsert);
			}
		}
		
		return result;
	}
}
