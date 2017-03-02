package amway.com.academy.common.commoncode.service.impl;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface CommonCodeMapper {

	List<Map<String, String>> getEduKindList(Map<String, String> params);
	
	List<Map<String, String>> getSpendItemList(Map<String, String> params);
	
	List<Map<String, String>> getCodeList(Map<String, String> params);

	List<Map<String, String>> getSearchYearList(Map<String, String> params);

	DataBox getAnalyticsTag(RequestBox requestBox);

	DataBox getCheckVisitor(RequestBox requestBox);
}
