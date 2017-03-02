package amway.com.academy.manager.common.targetUpload.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;
import java.util.Map;

@Mapper
public interface TargetUploadMapper {

	/**
	 * 대상자일괄등록 LIst
	 * @param requestBox
	 * @throws Exception
	 */
	int targetUploadListCount(RequestBox requestBox) throws Exception;

	List<DataBox> targetUploadList(RequestBox requestBox) throws Exception;

	DataBox targetUploadDetailPop(RequestBox requestBox) throws Exception;

	List<DataBox> targetUploadListCntPop(RequestBox requestBox) throws Exception;

	int targetUploadListCntPopCount(RequestBox requestBox) throws Exception;

	void targeterUploadInsert(RequestBox requestBox) throws Exception;

	int targetUploadDelete(RequestBox requestBox) throws Exception;

	int targetUploadDetailDelete(RequestBox requestBox) throws Exception;

	int targetUploadDelseq(RequestBox requestBox) throws Exception;


	int insertExcelData(Map<String, Object> params) throws Exception;
}