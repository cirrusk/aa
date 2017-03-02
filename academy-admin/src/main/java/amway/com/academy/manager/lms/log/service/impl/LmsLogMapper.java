package amway.com.academy.manager.lms.log.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsLogMapper {
	
	public int lmsInsertLogAjax(RequestBox requestBox) throws Exception;
	
	public DataBox lmsSelectLog(RequestBox requestBox) throws Exception;
	
}
