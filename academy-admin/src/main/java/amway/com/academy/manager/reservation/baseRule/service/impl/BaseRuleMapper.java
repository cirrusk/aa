package amway.com.academy.manager.reservation.baseRule.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BaseRuleMapper {

	public List<DataBox> baseRuleListAjax(RequestBox requestBox) throws Exception;
	
	public int baseRuleListCount(RequestBox requestBox) throws Exception;
	
	public int baseRuleInsertAjax(RequestBox requestBox) throws Exception;
	
	public DataBox baseRuleDetailAjax(RequestBox requestBox) throws Exception;
	
	public int baseRuleUpdateAjax(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> searchPpToRoomTypeList(RequestBox requestBox) throws Exception;
	
	public int ppToRoomTypeInsertAjax(RequestBox requestBox) throws Exception;
	
	public int rsvSpecialPpMapInsert(Map<String, String> map) throws Exception;
	
	public int ppToRoomTypeUpdateAjax(RequestBox requestBox) throws Exception;
	
	public int ppToRoomTypeDeleteAjax(RequestBox requestBox) throws Exception;
}
