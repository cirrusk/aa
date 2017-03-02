package amway.com.academy.manager.common.searchabo.service.impl;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface SearchAboMapper {

	Map<String, Object> selectAboData(RequestBox requestBox);

	int selectAboDataCount(RequestBox requestBox);

	List<DataBox> selectAboList(RequestBox requestBox);	
	
}
