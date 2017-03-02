package amway.com.academy.manager.trainingFee.trainingFeeTarget.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeTargetMapper {
	
	/**
	 * 마스터정보관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	int selectTargetListCount(RequestBox requestBox);
	
	/**
	 * 마스터정보관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectTargetList(RequestBox requestBox) throws Exception;

	/**
	 * 운영그룹 일괄 변경
	 * @param paramMap
	 * @return
	 */
	public int saveGiveTargetGroupCode(Map<String, Object> paramMap);
	
	/**
	 * 마스터정보관리 - 참고사항 및 메모 입력
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int trainingFeeMasterMemoUpdateAjax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 지급대상자관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	int selectGiveTargetListCount(RequestBox requestBox);
	
	/**
	 * 지급대상자관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectGiveTargetList(RequestBox requestBox) throws Exception;
	
	/**
	 * 지급대상자관리 tab2 운영그룹 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int trainingFeeGiveTargetGrpListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 지급대상자관리 tab2 운영그룹 리스트
	 * @param requestBox
	 * @return
	 */
	List<DataBox> trainingFeeGiveTargetGrpList(RequestBox requestBox) throws Exception;	
	
	List<DataBox> trainingFeeGiveTargetGrpDetailList(RequestBox requestBox) throws Exception;
	
	public int trainingFeeGiveTargetGrpDetailListCount(RequestBox requestBox) throws SQLException;
	
	public int selectGiveTargetGrpListCount(RequestBox requestBox);
	
	public List<DataBox> selectGiveTargetGrpList(RequestBox requestBox) throws Exception;
	
	public int saveTargetGroupCode(Map<String, Object> paramMap) throws Exception;
	
	public int trainingFeeMasterGiveTargetUpdateAjax(RequestBox requestBox) throws SQLException;
	
	public int trainingFeeMasterTargetUpdateAjax(RequestBox requestBox) throws SQLException;
	
	//insert memo
	public int trainingFeeMasterMemoInsertAjax(RequestBox requestBox) throws Exception;
	
	//memo detail
	public DataBox trainingFeeMasterMemoDetail(RequestBox requestBox) throws Exception;
	
	public DataBox trainingFeeMasterCheckedAboNoAjax(RequestBox requestBox) throws SQLException;
	
	public int trainingFeeMasterInsertAboTrainingfeetarget(RequestBox requestBox) throws SQLException;
	
	public int trainingFeeMasterInsertAboTrainingfeegivetarget(RequestBox requestBox) throws SQLException;
	
	public int trainingFeeMasterGiveTargetDeleteAjax(Map<String, Object> paramMap) throws SQLException;
	
	public DataBox trainingFeeGiveTargetMemoDetail(RequestBox requestBox) throws Exception;
	
	public int trainingFeeGiveTargetMemoUpdateAjax(RequestBox requestBox) throws Exception;
}