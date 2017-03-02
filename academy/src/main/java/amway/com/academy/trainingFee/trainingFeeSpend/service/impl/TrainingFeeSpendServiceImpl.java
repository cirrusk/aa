package amway.com.academy.trainingFee.trainingFeeSpend.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.trainingFee.trainingFeeSpend.service.TrainingFeeSpendService;
import framework.com.cmm.lib.RequestBox;

/**
 * 지출증빙
 * @author KR620208
 *
 */
@Service
public class TrainingFeeSpendServiceImpl implements TrainingFeeSpendService{
	
	@Autowired
	TrainingFeeSpendMapper trainingFeeSpendDAO;

	/**
	 * 화면 로딩 기초 데이터
	 * @param requestBox
	 * @return
	 */
	@Override
	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrFeeFiscalYear(requestBox);
	}
	
	/**
	 * 지출 증빙 리스트
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, String>> selectTrFeeSpendList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrFeeSpendList(requestBox);
	}
	
	/**
	 * 지출 증빙 사전계획서 selectbox
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrFeePlanList(requestBox);
	}
	
	/**
	 * 지출 증빙 교육일자 월 selectbox
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, String>> selectPlanUseMon(Map<String, Object> tempMap) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectPlanUseMon(tempMap);
	}
	
	/**
	 * 지출증빙 insert
	 * @param requestBox
	 * @return
	 */
	public int inserTrainingFeeSpend(RequestBox requestBox) {
		// TODO Auto-generated method stub
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		int result = 0;
		
		// 개인/그룹 공통
		result = trainingFeeSpendDAO.insertTrfeeSpend(requestBox);
		
		String spendItem[]   = requestBox.get("spendItem").split(",");
		String spendAmount[] = requestBox.get("spendAmount").split(",");
		String attachFile[]  = requestBox.get("attachfile").split(",");
		
		for(int i=0; i<spendItem.length;i++){
			dataMap.put("giveyear"   , requestBox.get("giveyear")  );
			dataMap.put("givemonth"  , requestBox.get("givemonth") );
			dataMap.put("maxSpendId" , requestBox.get("maxSpendId"));
			dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
			dataMap.put("groupCode"  , requestBox.get("groupCode") );
			dataMap.put("spendItem"  , spendItem[i]  );
			dataMap.put("spendAmount", spendAmount[i]);
			dataMap.put("attachFile" , attachFile[i] );
			
			// 아이템별 저장
			result = trainingFeeSpendDAO.insertTrfeeSpendItem(dataMap);
		}
		
		// 개인이냐 그룹이냐 구분하여 저장
		if( "group".equals(requestBox.get("procType")) ) {
			// 그룹 n빵 하기 위한 기본 데이터 생성
			result = trainingFeeSpendDAO.insertTrfeeSpendItemGroup(dataMap);
			
		}
		
		return result;
	}
	
	/**
	 * 지출증빙 update
	 * @param requestBox
	 * @return
	 */
	@Override
	public int updateTrainingFeeSpend(RequestBox requestBox) {
		// TODO Auto-generated method stub
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		int result = 0;
		
		// 개인/그룹 공통
		result = trainingFeeSpendDAO.updateTrfeeSpend(requestBox);
		result = trainingFeeSpendDAO.deleteTrfeeSpendItem(requestBox);
		
		String spendItem[]   = requestBox.get("spendItem").split(",");
		String spendAmount[] = requestBox.get("spendAmount").split(",");
		String attachFile[]  = requestBox.get("attachfile").split(",");
		
		for(int i=0; i<spendItem.length;i++){
			dataMap.put("giveyear"   , requestBox.get("giveyear")  );
			dataMap.put("givemonth"  , requestBox.get("givemonth") );
			dataMap.put("maxSpendId" , requestBox.get("spendid"));
			dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
			dataMap.put("groupCode"  , requestBox.get("groupCode") );
			dataMap.put("spendItem"  , spendItem[i]  );
			dataMap.put("spendAmount", spendAmount[i]);
			dataMap.put("attachFile" , attachFile[i] );
			
			// 아이템별 저장
			result = trainingFeeSpendDAO.insertTrfeeSpendItem(dataMap);
		}
		
		// 개인이냐 그룹이냐 구분하여 저장
		if( "group".equals(requestBox.get("procType")) ) {
			result = trainingFeeSpendDAO.deleteTrfeeSpendItemGroup(requestBox);
			// 그룹 n빵 하기 위한 기본 데이터 생성
			result = trainingFeeSpendDAO.insertTrfeeSpendItemGroup(dataMap);
			
		}
		
		return result;
	}
	
	/**
	 * 지출증빙 delete
	 * @param requestBox
	 * @return
	 */
	@Override
	public int deleteTrainingFeeSpend(RequestBox requestBox) {
		// TODO Auto-generated method stub
		int result = 0;
		
		// 일반 지출 삭제
		result = trainingFeeSpendDAO.deleteTrfeeSpend(requestBox);
		// 일반 지출 항목 삭제
		result = result + trainingFeeSpendDAO.deleteTrfeeSpendItem(requestBox);
		
		if( "group".equals(requestBox.get("procType")) ) {
			// 그룹 n빵 하기 위한 기본 데이터 삭제
			result = result + trainingFeeSpendDAO.deleteTrfeeSpendItemGroup(requestBox);
		}
		
		return result;
	}
	
	/**
	 * 리스트 클릭시 상세 내역 가져 오기
	 * @param requestBox
	 * @return
	 */
	@Override
	public Map<String, String> selectTrFeeSpend(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrFeeSpend(requestBox);
	}
	
	/**
	 * 리스트 클리시 상세 내역 영수증 항목 가져 오기
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, String>> selectTrFeeSpendItem(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.selectTrFeeSpendItem(requestBox);
	}
	
	/**
	 * 지출증빙 제출
	 * @param requestBox
	 * @return
	 */
	public int updateTrainingFeeSpendConfirm(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeeSpendDAO.updateTrainingFeeSpendConfirm(requestBox);
	}

}
