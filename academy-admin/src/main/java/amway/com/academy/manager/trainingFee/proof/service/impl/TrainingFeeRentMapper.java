package amway.com.academy.manager.trainingFee.proof.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeRentMapper {
	
	int selectRentListCount(RequestBox requestBox);
	
	List<DataBox> selectRentList(RequestBox requestBox) throws Exception;
	
	Map<String, Object> selectRentDetailInfo(RequestBox requestBox) throws SQLException;
	
	List<DataBox> selectRentDetailList(RequestBox requestBox) throws Exception;
	
	int selectRentDetailCount(RequestBox requestBox);
	
	int saveRentApprove(RequestBox requestBox);
	
	int insertRentApprove(RequestBox requestBox);
	
	int updateRentReject(RequestBox requestBox) throws SQLException;
	
	List<Map<String, Object>> selectRentDetailImg(RequestBox requestBox);
	
	int insertRentGrpApprove(RequestBox requestBox);
	
	int saveRentImgCheck(RequestBox requestBox) throws SQLException;
	
	int selectRentGrpDetailListCount(RequestBox requestBox);
	
	List<DataBox> selectRentGrpDetailList(RequestBox requestBox) throws Exception;

	DataBox selectTotalCount(RequestBox requestBox);


	





	
}