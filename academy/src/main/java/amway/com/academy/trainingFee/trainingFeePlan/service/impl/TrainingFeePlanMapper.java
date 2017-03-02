package amway.com.academy.trainingFee.trainingFeePlan.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeePlanMapper {

	public int insertTrfeePlan(RequestBox requestBox) ;
	
	public int insertTrfeePlanItem(Map<String, Object> dataMap) ;
	
	public int insertTrfeePlanItemGroup(Map<String, Object> dataMap) ;

	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox);

	public int insertTrfeeRent(RequestBox requestBox);

	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox);

	public List<Map<String, String>> selectTrFeeRentYear(RequestBox requestBox);

	public List<Map<String, String>> selectTrFeeRentMonth(Map<String, Object> searchMap);

	public Map<String, String> selectTrFeeRentList(RequestBox requestBox);

	public Map<String, String> selectTrFeePlan(RequestBox requestBox);

	public List<Map<String, String>> selectTrFeePlanItem(RequestBox requestBox);

	public List<Map<String, String>> selectPlanUseMon(Map<String, Object> tempMap);

	public int updateTrfeeRent(RequestBox requestBox);

	public int updateTrfeePlan(RequestBox requestBox);

	public int deleteTrfeePlan(RequestBox requestBox);
	
	public int deleteTrfeePlanItem(RequestBox requestBox);

	public int deleteTrfeePlanItemGroup(RequestBox requestBox);

	public int updateTrainingFeePlanConfirm(RequestBox requestBox);

	public List<Map<String, String>> selectTrFeeRentFileList(
			RequestBox requestBox);

	public int insertTrfeeRentattachfile(RequestBox requestBox);

	public int deleteTrfeeRentattachfile(RequestBox requestBox);

	public int deleteTrfeeRent(RequestBox requestBox);

	public Map<String, String> selectRentDeleteVaildate(RequestBox requestBox);

	
	

}
