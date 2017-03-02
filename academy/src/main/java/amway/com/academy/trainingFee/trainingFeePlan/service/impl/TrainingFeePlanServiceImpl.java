package amway.com.academy.trainingFee.trainingFeePlan.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.trainingFee.trainingFeePlan.service.TrainingFeePlanService;
import framework.com.cmm.lib.RequestBox;

@Service
public class TrainingFeePlanServiceImpl implements TrainingFeePlanService{
	@Autowired
	private TrainingFeePlanMapper trainingFeePlanDAO;

	/**
	 * 사전계획등록 page - 사전계획 등록한 데이터 추출 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> selectTrFeePlanList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeePlanList(requestBox);
	}
	
	/**
	 * 계획서 신규 저장
	 * @param requestBox
	 * @return
	 */
	@Override
	public int inserTrainingFeePlan(RequestBox requestBox) {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		int result = 0;
		
		// 개인이냐 그룹이냐 구분하여 저장
		if( "group".equals(requestBox.get("procType")) ) {

			if( "nomal".equals(requestBox.get("tabType")) ) {
				// 개인/그룹 공통
				result = trainingFeePlanDAO.insertTrfeePlan(requestBox);
				
				String spendItem[] = requestBox.get("spendItem").split(",");
				String spendAmount[] = requestBox.get("spendAmount").split(",");
				for(int i=0; i<spendItem.length;i++){
					dataMap.put("giveyear"   , requestBox.get("giveyear")  );
					dataMap.put("givemonth"  , requestBox.get("givemonth"));
					dataMap.put("maxPlanId"  , requestBox.get("maxPlanId")  );
					dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
					dataMap.put("groupCode"   , requestBox.get("groupCode")  );
					dataMap.put("spendItem"  , spendItem[i]  );
					dataMap.put("spendAmount", spendAmount[i]);
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeePlanItem(dataMap);
				}
				
				// 그룹 n빵 하기 위한 기본 데이터 생성
//				result = result + trainingFeePlanDAO.insertTrfeePlanItemGroup(dataMap);
			} else {
				String attachfile[] = requestBox.get("attachfile").split(",");
				// 임대차 신청
				result = trainingFeePlanDAO.insertTrfeeRent(requestBox);
				
				for(int i=0; i<attachfile.length;i++){
					requestBox.put("filekey"  , attachfile[i]  );
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeeRentattachfile(requestBox);
				}
			}
			
		} else {
			// 개인
			if( "nomal".equals(requestBox.get("tabType")) ) {
				// 개인/그룹 공통
				result = trainingFeePlanDAO.insertTrfeePlan(requestBox);
				
				String spendItem[] = requestBox.get("spendItem").split(",");
				String spendAmount[] = requestBox.get("spendAmount").split(",");
				for(int i=0; i<spendItem.length;i++){
					dataMap.put("giveyear"   , requestBox.get("giveyear")  );
					dataMap.put("givemonth"  , requestBox.get("givemonth"));
					dataMap.put("maxPlanId"  , requestBox.get("maxPlanId")  );
					dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
					dataMap.put("groupCode"   , requestBox.get("groupCode")  );
					dataMap.put("spendItem"  , spendItem[i]  );
					dataMap.put("spendAmount", spendAmount[i]);
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeePlanItem(dataMap);
				}
			}else {
				String attachfile[] = requestBox.get("attachfile").split(",");
				// 임대차 신청
				result = trainingFeePlanDAO.insertTrfeeRent(requestBox);
				
				for(int i=0; i<attachfile.length;i++){
					requestBox.put("filekey"  , attachfile[i]  );
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeeRentattachfile(requestBox);
				}
			}
		}
		
		return result;
	}

	/**
	 * 계획서 수정 저장
	 * @param requestBox
	 * @return
	 */
	@Override
	public int updateTrainingFeePlan(RequestBox requestBox) {
		// TODO Auto-generated method stub
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		int result = 0;
		
		if( "group".equals(requestBox.get("procType")) ) {

			if( "nomal".equals(requestBox.get("tabType")) ) {
				// 일반 지출 ( 지출항목은 모두 삭제 후 신규 저장 한다. )
				result = trainingFeePlanDAO.updateTrfeePlan(requestBox);
				
				
				result = trainingFeePlanDAO.deleteTrfeePlanItem(requestBox);
				result = trainingFeePlanDAO.deleteTrfeePlanItemGroup(requestBox);
				
				String spendItem[] = requestBox.get("spendItem").split(",");
				String spendAmount[] = requestBox.get("spendAmount").split(",");
				for(int i=0; i<spendItem.length;i++){
					dataMap.put("giveyear"   , requestBox.get("giveyear")  );
					dataMap.put("givemonth"  , requestBox.get("givemonth"));
					dataMap.put("maxPlanId"  , requestBox.get("planid")  );
					dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
					dataMap.put("groupCode"   , requestBox.get("groupCode")  );
					dataMap.put("spendItem"  , spendItem[i]  );
					dataMap.put("spendAmount", spendAmount[i]);
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeePlanItem(dataMap);
				}
				
				// 그룹 n빵 하기 위한 기본 데이터 생성
//				result = result + trainingFeePlanDAO.insertTrfeePlanItemGroup(dataMap);
			} else {
				// 임대차 신청
				result = trainingFeePlanDAO.updateTrfeeRent(requestBox);
				result = trainingFeePlanDAO.deleteTrfeeRentattachfile(requestBox);
				
				String attachfile[] = requestBox.get("attachfile").split(",");
				requestBox.put("maxRentId"  , requestBox.get("planid")  );
				
				for(int i=0; i<attachfile.length;i++){
					requestBox.put("filekey"  , attachfile[i]  );
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeeRentattachfile(requestBox);
				}
			}
			
		} else {
			if( "nomal".equals(requestBox.get("tabType")) ) {
				// 일반 지출 ( 지출항목은 모두 삭제 후 신규 저장 한다. )
				result = trainingFeePlanDAO.updateTrfeePlan(requestBox);
				
				result = trainingFeePlanDAO.deleteTrfeePlanItem(requestBox);
				String spendItem[] = requestBox.get("spendItem").split(",");
				String spendAmount[] = requestBox.get("spendAmount").split(",");
				for(int i=0; i<spendItem.length;i++){
					dataMap.put("giveyear"   , requestBox.get("giveyear")  );
					dataMap.put("givemonth"  , requestBox.get("givemonth"));
					dataMap.put("maxPlanId"  , requestBox.get("planid")  );
					dataMap.put("depaboNo"   , requestBox.get("depaboNo")  );
					dataMap.put("groupCode"   , requestBox.get("groupCode")  );
					dataMap.put("spendItem"  , spendItem[i]  );
					dataMap.put("spendAmount", spendAmount[i]);
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeePlanItem(dataMap);
				}
				
			} else {
				// 임대차 신청
				result = trainingFeePlanDAO.updateTrfeeRent(requestBox);
				result = trainingFeePlanDAO.deleteTrfeeRentattachfile(requestBox);
				
				String attachfile[] = requestBox.get("attachfile").split(",");
				requestBox.put("maxRentId"  , requestBox.get("planid")  );
				
				for(int i=0; i<attachfile.length;i++){
					requestBox.put("filekey"  , attachfile[i]  );
					
					// 아이템별 저장
					result = trainingFeePlanDAO.insertTrfeeRentattachfile(requestBox);
				}
			}
			
		}
		
		return result;
	}
	
	/**
	 * 계획서 삭제
	 * @param requestBox
	 * @return
	 */
	@Override
	public int deleteTrainingFeePlan(RequestBox requestBox) {
		// TODO Auto-generated method stub
		int result = 0;
		
		if( "group".equals(requestBox.get("procType")) ) {
			if( "nomal".equals(requestBox.get("tabType")) ) {
				// 일반 지출 삭제
				result = trainingFeePlanDAO.deleteTrfeePlan(requestBox);
				// 일반 지출 항목 삭제
				result = trainingFeePlanDAO.deleteTrfeePlanItem(requestBox);
				// 그룹 n빵 하기 위한 기본 데이터 삭제
//				result = trainingFeePlanDAO.deleteTrfeePlanItemGroup(requestBox);
			} else {
				result = trainingFeePlanDAO.deleteTrfeeRent(requestBox);
			}
		} else {
			// 일반 지출 삭제
			result = trainingFeePlanDAO.deleteTrfeePlan(requestBox);
			// 일반 지출 항목 삭제
			result = trainingFeePlanDAO.deleteTrfeePlanItem(requestBox);
		}
		return result;
	}
	
	/**
	 * 교육비 회계년도를 가져온다.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectTrFeeFiscalYear(RequestBox requestBox)  {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeeFiscalYear(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectTrFeeRentYear(RequestBox requestBox)  {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeeRentYear(requestBox);
	}

	@Override
	public List<Map<String, String>> selectTrFeeRentMonth(Map<String, Object> searchMap) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeeRentMonth(searchMap);
	}

	/**
	 * 수정 또는 조회 모드 일 경우 - rent내역 가져오기
	 * @param searchMap
	 * @return
	 */
	@Override
	public Map<String, String> selectTrFeeRentList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeeRentList(requestBox);
	}
	
	@Override
	public Map<String, String> selectTrFeePlan(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeePlan(requestBox);
	}

	@Override
	public List<Map<String, String>> selectTrFeePlanItem(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeePlanItem(requestBox);
	}

	@Override
	public List<Map<String, String>> selectPlanUseMon(
			Map<String, Object> tempMap) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectPlanUseMon(tempMap);
	}

	/**
	 * 계획서 완료
	 * @param requestBox
	 * @return
	 */
	@Override
	public int updateTrainingFeePlanConfirm(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.updateTrainingFeePlanConfirm(requestBox);
	}

	@Override
	public List<Map<String, String>> selectTrFeeRentFileList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectTrFeeRentFileList(requestBox);
	}

	@Override
	public Map<String, String> selectRentDeleteVaildate(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return trainingFeePlanDAO.selectRentDeleteVaildate(requestBox);
	}





}
