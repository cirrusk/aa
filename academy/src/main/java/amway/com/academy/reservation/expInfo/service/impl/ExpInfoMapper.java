package amway.com.academy.reservation.expInfo.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpInfoMapper {

	public List<Map<String, String>> expInfoList(Map<String, Object> map) throws Exception;
	
	public int expInfoListCount(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> expInfoDetailList(RequestBox requestBox) throws Exception;
	
	public int changePartnertAjax(RequestBox requestBox) throws Exception;
	
	public int updateCancelCodeAjax(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchMaxStandByNumber(RequestBox requestBox) throws Exception;
	
	public int updateStandByNumber(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> searchPenaltyList(RequestBox requestBox) throws Exception;
	
	public int insertPenaltyHistory(Map<String, String> map) throws Exception;
	
	public Map<String, String> searchThreeMonthMobile(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchExpPenaltyYn(RequestBox requestBox	) throws Exception;
	
	public String expInfoByRsvSeq(RequestBox requestBox) throws Exception;
}
