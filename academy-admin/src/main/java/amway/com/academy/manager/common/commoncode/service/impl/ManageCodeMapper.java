package amway.com.academy.manager.common.commoncode.service.impl;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ManageCodeMapper {

	List<Map<String, String>> getPageCntList(Map<String, String> params);
	
	List<Map<String, String>> getTimeList(Map<String, String> params);
	
	List<Map<String, String>> getCodeList(Map<String, String> params);	
	
	int insertSmsMailQueue(RequestBox requestBox);

	void memberDropUpdate(Map<String, Object> map) throws Exception;

	int selectCurrentAdd(Map<String, Object> map);
}
