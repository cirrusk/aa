package amway.com.academy.manager.trainingFee.proof.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeRentService {
	
	/**
	 * 임차료관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectRentListCount(RequestBox requestBox);
	
	/**
	 * 임차료관리 리스트 
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectRentList(RequestBox requestBox) throws Exception;


	/**
	 * 미처리 건수
	 * @param requestBox
	 * @return
	 */
	public DataBox selectTotalCount(RequestBox requestBox);
	
	/**
	 * 임차료 상세보기 신청정보
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectRentDetailInfo(RequestBox requestBox) throws SQLException;

	/**
	 * 임차료 상세보기(개인) - 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectRentDetailCount(RequestBox requestBox);
	
	/**
	 * 임차료 상세보기(개인) - 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectRentDetailList(RequestBox requestBox) throws Exception;

	/**
	 * 임차료 상세보기(개인) - 승인
	 * @param requestBox
	 * @return
	 */
	public int saveRentConfrim(RequestBox requestBox);
	
	/**
	 * 임차료 상세보기(그룹) - 승인
	 * @param requestBox
	 * @return
	 */
	public int saveRentGrpConfrim(RequestBox requestBox);
	
	/**
	 * 임차료 상세보기(개인) - 반려
	 * @param requestBox
	 * @return
	 */
	public int updateRentReject(RequestBox requestBox) throws SQLException;
	
	/**
	 * 임차료 상세보기(개인) - 이미지
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectRentDetailImg(RequestBox requestBox);
	
	
	
	
	
	public int selectRentGrpDetailListCount(RequestBox requestBox);
	
	public List<DataBox> selectRentGrpDetailList(RequestBox requestBox) throws Exception;
	
	
	public int saveRentGrpApprove(RequestBox requestBox);

	public int saveRentImgCheck(RequestBox requestBox) throws SQLException;



	
	
}