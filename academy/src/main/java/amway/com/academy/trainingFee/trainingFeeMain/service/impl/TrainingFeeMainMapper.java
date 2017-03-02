package amway.com.academy.trainingFee.trainingFeeMain.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeMainMapper {

	List<Map<String, Object>> selectSchedule(RequestBox requestBox) throws Exception;
	
	Map<String, Object> selectTargetInformation(RequestBox requestBox);
	
	List<Map<String, Object>> selectMainList(RequestBox requestBox) throws Exception;

	Map<String, String> selectTrFeeAgreeText(RequestBox requestBox);

	int inserTrfeeAgreePledge(RequestBox requestBox);

	List<Map<String, Object>> selectTrfeeAgreeThirdperson(RequestBox requestBox);

	List<Map<String, Object>> selectTrfeeAgreeDeleg(RequestBox requestBox);

	int inserTrfeeAgreeDeleg(Map<String, Object> rtnMap);

	List<Map<String, Object>> selectTrfeeAgreeDelegEm(RequestBox requestBox);

	int inserTrfeeThirdperson(Map<String, Object> rtnMap);

	List<Map<String, Object>> selectGroupTargetList(RequestBox requestBox);

	Map<String, String> selectTrFeeAgreePledge(RequestBox requestBox);

	Map<String, Object> selectTrFeeThirdPerson(RequestBox requestBox);

	Map<String, String> selectTrFeeAgreeDeleg(RequestBox requestBox);

	List<Map<String, Object>> selectPF(RequestBox requestBox);

	List<Map<String, Object>> selectTrFeeAgreeTextPop(RequestBox requestBox);

	Map<String, String> selectTrFeeAgreeDelegFull(RequestBox requestBox);

	List<Map<String, Object>> selectTrFeeThirdPersonList(RequestBox requestBox);

	List<Map<String, Object>> selectTrFeeAgreeDelegFullList(
			RequestBox requestBox);

	List<Map<String, Object>> selectPtList(RequestBox requestBox);

	int updateTrfeeAgreeDeleg(Map<String, Object> rtnMap);

	int updateThirdpersonAgree(RequestBox requestBox);

}
