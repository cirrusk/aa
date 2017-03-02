package amway.com.academy.reservation.expCulture.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpCultureMapper {

	List<Map<String, String>> expCulturePpRsvCodeList(RequestBox requestBox)throws Exception;

	List<Map<String, String>> expCultureYearMonth(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCultureDayInfoList(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCultureProgramList(RequestBox requestBox) throws Exception;

	String expCultureSeatCountSelect(RequestBox requestBox) throws Exception;

	int expCultureRsvInsert(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCulturePpProgramList(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCultureSessionList(RequestBox requestBox) throws Exception;

	int expCultureInfoListCount(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCultureInfoList(RequestBox requestBox) throws Exception;

	int expCultureVisitNumberUpdate(RequestBox requestBox) throws Exception;

	int searchStandByNumberCheck(RequestBox requestBox) throws Exception;

	int deleteExpCultureReservation(RequestBox requestBox) throws Exception;

	int updateExpCultureCancelCodeAjax(RequestBox requestBox) throws Exception;

	Map<String, String> selectExpWaitingInfo(RequestBox requestBox) throws Exception;

	int updateExpWaitingInfo(RequestBox requestBox) throws Exception;

	List<Map<String, String>> searchExpCulturePenaltyList(RequestBox requestBox) throws Exception;

	int insertExpCulturePenaltyHistory(Map<String, String> penaltyInfo) throws Exception;

	int expCultureNonMemberRsvInsert(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expCultureIntroduceList(RequestBox requestBox) throws Exception;

	Map<String, String> expCultureToday() throws Exception;

	List<Map<String, String>> expCultureInfoListMobile(RequestBox requestBox) throws Exception;

	void expCultureAuthenticationNumberSend(RequestBox requestBox) throws Exception;

	void expCultureAuthenticationNumberInsert(RequestBox requestBox) throws Exception;

	Boolean expCultureTimeCheck(RequestBox requestBox) throws Exception;

	Boolean expCultureNumberCheck(RequestBox requestBox) throws Exception;

	Map<String, String> expCultureStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;

	Object expCultureRsvPersonCheck(RequestBox requestBox) throws Exception;
}
