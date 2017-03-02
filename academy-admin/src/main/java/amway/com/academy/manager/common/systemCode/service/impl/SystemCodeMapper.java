package amway.com.academy.manager.common.systemCode.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface SystemCodeMapper {

	List<DataBox> codeListScope(RequestBox requestBox) throws Exception;

	int systemCodeListCount(RequestBox requestBox) throws Exception;

	List<DataBox> systemCodeList(RequestBox requestBox) throws Exception;

	DataBox systemCodeListPop(RequestBox requestBox) throws Exception;

	int systemCodeInsert(RequestBox requestBox) throws Exception;

	int systemCodeUpdate(RequestBox requestBox)throws Exception;

	int existyn(RequestBox requestBox) throws Exception;

	int systemCodeDelete(RequestBox requestBox) throws Exception;


	DataBox codeListDetail(RequestBox requestBox) throws Exception;

	List<DataBox> systemCodeDetail(RequestBox requestBox) throws Exception;

	DataBox systemCodeDetailPop(RequestBox requestBox) throws Exception;

	int systemCodeDetailInsert(RequestBox requestBox)throws Exception;

	int systemCodeDetailUpdate(RequestBox requestBox) throws Exception;

	int systemCodeDetailDelete(RequestBox requestBox) throws Exception;

	int systemCodeDetailOrder(RequestBox requestBox) throws Exception;

}