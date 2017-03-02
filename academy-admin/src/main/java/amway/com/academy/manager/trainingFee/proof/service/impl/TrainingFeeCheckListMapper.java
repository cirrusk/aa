package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeCheckListMapper {
	
	int selectTrainingFeeCheckListCount(RequestBox requestBox);
	
	List<DataBox> selectTrainingFeeCheckList(RequestBox requestBox) throws Exception;
	
	int updateAs400UploadFalg(Map<String, Object> saveMap) throws SQLException;

	int updateGroupAs400UploadFalg(Map<String, Object> saveMap) throws SQLException;

}