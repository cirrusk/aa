package amway.com.academy.manager.trainingFee.trainingFeeTarget.service;

import java.sql.SQLException;
import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeTargetService {
	
	/**
	 * 마스터 정보관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTargetListCount(RequestBox requestBox);
	
	/**
	 * 마스터 정보관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectTargetList(RequestBox requestBox) throws Exception;
	
	/**
	 * 마스터 정보관리 운영그룹 변경
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int saveGiveTargetGroupCode(RequestBox requestBox) throws SQLException;
	
	/**
	 * TRAININGFEETARGET, TRAININGFEEGIVETARGET 테이블에 ABO가 존재 유무를 조회하는 메서드
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox trainingFeeMasterCheckedAboNoAjax(RequestBox requestBox)	throws SQLException;
	
	/**
	 * 마스터 정보관리_지급대상자 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int trainingFeeMasterUpdateLearPop01Ajax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 마스터 정보관리 - 월별 대상자 DELETE
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int trainingFeeMasterGiveTargetDeleteAjax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 마스터 정보관리 - 누적 대상자 UPDATE
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int trainingFeeMasterTargetUpdateAjax(RequestBox requestBox) throws SQLException;
	
	/**
	 * 마스터 정보관리 - 월별 대상자 UPDATE
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int trainingFeeMasterGiveTargetUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * 마스터 정보관리 - 누적 대상자 INSERT
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int trainingFeeMasterInsertAboTrainingfeetarget(RequestBox requestBox) throws SQLException;
	
	/**
	 * 마스터 정보관리 - 월별 대상자 INSERT
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int trainingFeeMasterInsertAboTrainingfeegivetarget(RequestBox requestBox) throws SQLException;
	
	/**
	 * 지급대상자관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectGiveTargetListCount(RequestBox requestBox);
	
	/**
	 * 지급대상자관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectGiveTargetList(RequestBox requestBox) throws Exception;
	
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
	public List<DataBox> trainingFeeGiveTargetGrpList(RequestBox requestBox) throws Exception;
	
	/**
	 * 지급대상자 관리_운영그룹_운영그룹 상세보기 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int trainingFeeGiveTargetGrpDetailListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 지급대상자 관리_운영그룹_운영그룹 상세보기 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> trainingFeeGiveTargetGrpDetailList(RequestBox requestBox) throws Exception;

	/**
	 * 마스터 정보관리_메모 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int trainingFeeMasterMemoUpdateAjax(RequestBox requestBox) throws SQLException;
}