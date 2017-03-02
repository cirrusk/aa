package amway.com.academy.manager.trainingFee.trainingFeeTarget.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.trainingFeeTarget.service.TrainingFeeTargetService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeeTargetServiceImpl extends EgovAbstractServiceImpl implements TrainingFeeTargetService {
	@Autowired
	private TrainingFeeTargetMapper trainingFeeTargetDAO;

	/**
	 * 마스터 정보관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectTargetListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return (int) trainingFeeTargetDAO.selectTargetListCount(requestBox);
	}
	
	/**
	 * 마스터 정보관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> selectTargetList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeTargetDAO.selectTargetList(requestBox);
	}
	
	/**
	 * 마스터 정보관리 운영그룹 변경
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int saveGiveTargetGroupCode(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int result = 0;
		String item[] = requestBox.get("checkedabono").split(",");
		
		for(int i=0;i<item.length;i++) {
			paramMap.put("searchGiveYear", requestBox.get("searchGiveYear"));
			paramMap.put("groupcode"     , requestBox.get("groupcode"));
			paramMap.put("abono"         , item[i]);			
			paramMap.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));			
			
			result = trainingFeeTargetDAO.saveGiveTargetGroupCode(paramMap);
		}
		
		return result;
	}
	
	/**
	 * 마스터 정보관리_해당 ABO TRAININGFEEGIVETARGET 테이블에서 삭제
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterGiveTargetDeleteAjax(RequestBox requestBox)	throws SQLException {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		int result = 0;
		String item[] = requestBox.get("checkedabono").split(",");
		
		for(int i=0;i<item.length;i++) {
			paramMap.put("giveyear",requestBox.get("giveyear"));
			paramMap.put("givemonth",requestBox.get("givemonth"));
			paramMap.put("abono",item[i]);
			paramMap.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
			
			result = trainingFeeTargetDAO.trainingFeeMasterGiveTargetDeleteAjax(paramMap);
		}
		
		return result;
		
	}
	
	/**
	 * TRAININGFEETARGET, TRAININGFEEGIVETARGET 테이블에 ABO가 존재 유무를 조회하는 메서드
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox trainingFeeMasterCheckedAboNoAjax(RequestBox requestBox)	throws SQLException {
		
		DataBox trainingFeeMasterCheckedAboNo = trainingFeeTargetDAO.trainingFeeMasterCheckedAboNoAjax(requestBox);
		
		return trainingFeeMasterCheckedAboNo;
	}
	
	/**
	 * 마스터 정보관리_지급대상자 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterUpdateLearPop01Ajax(RequestBox requestBox) throws SQLException {
		
		int result = 0;
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		
		/**dbo.TRFEETARGETFULL 테이블 정보 수정 */
		result = trainingFeeTargetDAO.trainingFeeMasterTargetUpdateAjax(requestBox);
		
		/**dbo.TRFEETARGETMONTH 테이블 정보 수정 */
		result = trainingFeeTargetDAO.trainingFeeMasterGiveTargetUpdateAjax(requestBox);
			
		return result;
	}
	
	/**
	 * 마스터 정보관리 - 누적 대상자 UPDATE
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterTargetUpdateAjax(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeMasterTargetUpdateAjax(requestBox);
	}
	
	/**
	 * 마스터 정보관리 - 월별 대상자 UPDATE
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterGiveTargetUpdateAjax(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeMasterGiveTargetUpdateAjax(requestBox);
	}
	
	/**
	 * 마스터 정보관리 - 누적 대상자 INSERT
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterInsertAboTrainingfeetarget(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeMasterInsertAboTrainingfeetarget(requestBox);
	}
	
	/**
	 * 마스터 정보관리 - 월별 대상자 INSERT
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterInsertAboTrainingfeegivetarget(RequestBox requestBox) throws SQLException {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeMasterInsertAboTrainingfeegivetarget(requestBox);
	}
	
	/**
	 * 지급대상자관리 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectGiveTargetListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return (int) trainingFeeTargetDAO.selectGiveTargetListCount(requestBox);
	}
	
	/**
	 * 지급대상자관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> selectGiveTargetList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeeTargetDAO.selectGiveTargetList(requestBox);
	}
	
	/**
	 * 지급대상자관리 tab2 운영그룹 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int trainingFeeGiveTargetGrpListCount(RequestBox requestBox) throws Exception {
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeGiveTargetGrpListCount(requestBox);
	}

	/**
	 * 지급대상자관리 tab2 운영그룹 리스트
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<DataBox> trainingFeeGiveTargetGrpList(RequestBox requestBox) throws Exception {
		return trainingFeeTargetDAO.trainingFeeGiveTargetGrpList(requestBox);
	}
	
	/**
	 * 지급대상자 관리_운영그룹_운영그룹 상세보기 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int trainingFeeGiveTargetGrpDetailListCount(RequestBox requestBox) throws Exception {
		return trainingFeeTargetDAO.trainingFeeGiveTargetGrpDetailListCount(requestBox);
	}
	
	/**
	 * 지급대상자 관리_운영그룹_운영그룹 상세보기 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> trainingFeeGiveTargetGrpDetailList(RequestBox requestBox) throws Exception {
		return trainingFeeTargetDAO.trainingFeeGiveTargetGrpDetailList(requestBox);
	}

	/**
	 * 마스터 정보관리_메모 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int trainingFeeMasterMemoUpdateAjax(RequestBox requestBox) throws SQLException {
		requestBox.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
		return trainingFeeTargetDAO.trainingFeeMasterMemoUpdateAjax(requestBox);
	}

}