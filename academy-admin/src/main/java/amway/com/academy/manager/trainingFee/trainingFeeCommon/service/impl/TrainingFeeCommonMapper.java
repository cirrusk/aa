package amway.com.academy.manager.trainingFee.trainingFeeCommon.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeCommonMapper {
	
	Map<String, Object> selectTargetInfoList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectBRList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectGrpCdList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectCodeList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLOAList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectDeptList(RequestBox requestBox) throws Exception;

	List<DataBox> selectCPinList(RequestBox requestBox);
}