package amway.com.academy.manager.common.targetCode.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

@Mapper
public interface TargetCodeMapper {

	/**
	 * 대상자코드 LIst
	 * @param requestBox
	 * @throws Exception
	 */
	List<DataBox> codeListScope(RequestBox requestBox) throws Exception;

	int targetCodeListCount(RequestBox requestBox) throws Exception;

	List<DataBox> targetCodeList(RequestBox requestBox) throws Exception;

	DataBox targetCodeListPop(RequestBox requestBox)throws Exception;

	int targetCodeInsert(RequestBox requestBox) throws Exception;

	int targetCodeUpdate(RequestBox requestBox)throws Exception;

	int existyn(RequestBox requestBox) throws Exception;

	int targetCodeDelete(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 Detail
	 * @param requestBox
	 * @throws Exception
	 */
	DataBox targetCodeDetail(RequestBox requestBox) throws Exception;

	List<DataBox> targetCodeDetailList(RequestBox requestBox)throws Exception;

	DataBox targetCodeDetailPop(RequestBox requestBox) throws Exception;

	int targetCodeDetailInsert(RequestBox requestBox) throws Exception;

	int targetCodeDetailUpdate(RequestBox requestBox) throws Exception;

	int targetCodeDetailDelete(RequestBox requestBox) throws Exception;

	int targetCodeDetailOrder(RequestBox requestBox) throws Exception;

}