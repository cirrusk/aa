package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeScheduleMapper {

	List<DataBox> selectPlanList(RequestBox requestBox) throws Exception;
	
	int insertPlanAjax(RequestBox requestBox);
	
	int trainingFeePlanUpdateAjax(RequestBox requestBox) throws SQLException;
	
	DataBox trainingFeePlanDetail(RequestBox requestBox) throws Exception;

	List<Map<String, Object>> selectTrFeeScheduleVal(RequestBox requestBox);

	List<Map<String, Object>> selectTrFeeTargetVal(RequestBox requestBox);

	int insertNoteSend(RequestBox requestBox);

	int insertSMSSendHIST(RequestBox requestBox);

	List<Map<String, Object>> selectSMSData(RequestBox requestBox);

	void sptrfeePTList(Map<String, Object> rtnMap);
	
	void sptrfeePTList1(Map<String, Object> rtnMap);

	Map<String, Object> callSmsAllSend(Map<String, Object> rtnMap);

	List<Map<String, Object>> selectSMSData(Map<String, Object> smsMap);
} 
