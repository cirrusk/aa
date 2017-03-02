package amway.com.academy.manager.common.login.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LoginMapper {

	public int loginMergeManager(RequestBox requestBox) throws Exception;
	
	
	List<DataBox> selectManagerAuthList(RequestBox requestBox) throws Exception;

	public int loginLogInsert(RequestBox requestBox) throws Exception;

}