package amway.com.academy.trainingFee.trainingFeeSpend.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeSpendMapper {

	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox);
	
	public List<Map<String, String>> selectTrFeeSpendList(RequestBox requestBox);
	
	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox);
	
	public List<Map<String, String>> selectPlanUseMon(Map<String, Object> tempMap);
	
	public int insertTrfeeSpend(RequestBox requestBox);
	
	public int insertTrfeeSpendItem(Map<String, Object> dataMap);
	
	public int insertTrfeeSpendItemGroup(Map<String, Object> dataMap);
	
	public Map<String, String> selectTrFeeSpend(RequestBox requestBox);
	
	public List<Map<String, String>> selectTrFeeSpendItem(RequestBox requestBox);
	
	public int updateTrfeeSpend(RequestBox requestBox);
	
	public int deleteTrfeeSpendItem(RequestBox requestBox);
	
	public int deleteTrfeeSpendItemGroup(RequestBox requestBox);
	
	public int deleteTrfeeSpend(RequestBox requestBox);

	public int updateTrainingFeeSpendConfirm(RequestBox requestBox);
}
