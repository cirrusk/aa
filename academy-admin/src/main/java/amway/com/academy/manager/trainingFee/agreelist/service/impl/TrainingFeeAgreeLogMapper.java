package amway.com.academy.manager.trainingFee.agreelist.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeAgreeLogMapper {

	int selectAgreeLogListCount(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectAgreeLogList(RequestBox requestBox) throws Exception;

	int selectAgreeDelegLogListCount(RequestBox requestBox);

	List<DataBox> selectAgreeDelegLogList(RequestBox requestBox);

	int selectThirdpersonLogListCount(RequestBox requestBox);

	List<DataBox> selectThirdpersonLogList(RequestBox requestBox);

	int selectSpecialLogListCount(RequestBox requestBox);

	List<DataBox> selectSpecialLogList(RequestBox requestBox);

	int selectSaveSpecialLogCount(RequestBox requestBox);

	int updateSpecialLog(RequestBox requestBox);

	int insertSpecialLog(RequestBox requestBox);

	List<Map<String, Object>> selectAgreePledgePrint(RequestBox requestBox);

	List<Map<String, Object>> selectAgreeDelegPrint(RequestBox requestBox);

	List<Map<String, Object>> selectThirdpersonPrint(RequestBox requestBox);

	int deleteSpecialLog(Map<String, Object> deleteMap) throws SQLException;  
}
