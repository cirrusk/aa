package amway.com.academy.manager.lms.dwTarget.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsDwTargetMapper {

	List<DataBox> selectLmsDwTargetList(RequestBox requestBox);
	int selectLmsDwTargetCount(RequestBox requestBox);
	int mergeDwTargetExcelAjax(RequestBox requestBox);
	
}
