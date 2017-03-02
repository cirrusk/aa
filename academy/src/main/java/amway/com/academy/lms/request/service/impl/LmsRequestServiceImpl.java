package amway.com.academy.lms.request.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.LmsCommonService;
import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.request.service.LmsRequestService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsRequestServiceImpl  implements LmsRequestService{
	@Autowired
	private LmsRequestMapper lmsRequestMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	@Autowired
	private LmsCommonService lmsCommonService;
	
	/**
	 * 통합교육 신청 과정 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int selectLmsRequestListCount(RequestBox requestBox) throws Exception {

		return lmsRequestMapper.selectLmsRequestListCount(requestBox);
	}
	
	/**
	 * 통합교육 신청 과정 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestList(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsRequestMapper.selectLmsRequestList(requestBox);
		
		return list;
	}
	
	/**
	 * 통합교육 신청 정규 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestRegularDetail(RequestBox requestBox) throws Exception {
		Map<String, Object> data = new HashMap<String, Object>();
		// 과정상세
		DataBox item = lmsRequestMapper.selectLmsRequestDetail(requestBox);
		if(item !=  null){
		
			item.put("coursecontent", LmsUtil.getHtmlStrCnvrBr(item.getString("coursecontent")));
			data.put("item", item);
			
			requestBox.put("courseid", item.get("courseid"));
			// 정규과정상세
			DataBox item2 = lmsRequestMapper.selectLmsRequestRegularDetail(requestBox);
			item2.put("targetdetail", LmsUtil.getHtmlStrCnvr(item2.getString("targetdetail")));
			item2.put("note", LmsUtil.getHtmlStrCnvr(item2.getString("note")));
			item2.put("passnote", LmsUtil.getHtmlStrCnvr(item2.getString("passnote")));
			item2.put("penaltynote", LmsUtil.getHtmlStrCnvr(item2.getString("penaltynote")));
			data.put("item2", item2);
			
			// 교육장 목록
			data.put("apList", lmsRequestMapper.selectLmsRequestCourseApList(requestBox));
			
			// 신청기간 목록
			data.put("reqList", lmsRequestMapper.selectLmsRequestDateList(requestBox));
			
			// 구성 과정 목록
			data.put("unitList", lmsRequestMapper.selectLmsRequestStepUnitList(requestBox));
		}
		return data;
	}
	
	/**
	 * 통합교육 신청 오프라인 과정 강의장 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestApList(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsRequestMapper.selectLmsRequestApList(requestBox);
		
		return list;
	}
	
	/**
	 * 통합교육 신청 오프라인 과정 달력
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestMonthDate(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsRequestMapper.selectLmsRequestMonthDate(requestBox);
		
		return list;
	}

	/**
	 * 통합교육 신청 오프라인 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestOfflineDetail(RequestBox requestBox) throws Exception {
		Map<String, Object> data = new HashMap<String, Object>();
		// 과정상세
		DataBox item = lmsRequestMapper.selectLmsRequestDetail(requestBox);
		if(item !=  null){
			item.put("coursecontent", LmsUtil.getHtmlStrCnvrBr(item.getString("coursecontent")));
			data.put("item", item);
			
			requestBox.put("courseid", item.get("courseid"));
			// 오프라인 과정상세
			DataBox item2 = lmsRequestMapper.selectLmsRequestOfflineDetail(requestBox);
			item2.put("targetdetail", LmsUtil.getHtmlStrCnvr(item2.getString("targetdetail")));
			item2.put("detailcontent", LmsUtil.getHtmlStrCnvr(item2.getString("detailcontent")));
			item2.put("note", LmsUtil.getHtmlStrCnvr(item2.getString("note")));
			item2.put("penaltynote", LmsUtil.getHtmlStrCnvr(item2.getString("penaltynote")));
			data.put("item2", item2);
			
			// 신청기간 목록
			data.put("reqList", lmsRequestMapper.selectLmsRequestDateList(requestBox));
		}
		return data;
	}
	
	/**
	 * 통합교육 신청 라이브 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestLiveDetail(RequestBox requestBox) throws Exception {
		Map<String, Object> data = new HashMap<String, Object>();
		// 과정상세
		DataBox item = lmsRequestMapper.selectLmsRequestDetail(requestBox);
		if(item !=  null){
			item.put("coursecontent", LmsUtil.getHtmlStrCnvrBr(item.getString("coursecontent")));
			data.put("item", item);
			
			requestBox.put("courseid", item.get("courseid"));
			// 라이브 과정상세
			DataBox item2 = lmsRequestMapper.selectLmsRequestLiveDetail(requestBox);
			item2.put("targetdetail", LmsUtil.getHtmlStrCnvr(item2.getString("targetdetail")));
			item2.put("note", LmsUtil.getHtmlStrCnvr(item2.getString("note")));
			item2.put("penaltynote", LmsUtil.getHtmlStrCnvr(item2.getString("penaltynote")));
			data.put("item2", item2);
			
			// 신청기간 목록
			data.put("reqList", lmsRequestMapper.selectLmsRequestDateList(requestBox));
		}
		return data;
	}
	
	/**
	 * 통합교육 신청 수강신청 처리
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> insertCourseRequest(RequestBox requestBox) throws Exception {
	
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String result = "NO";
		int cnt = 0;
		DataBox item = lmsRequestMapper.selectLmsRequestCheck(requestBox); 
		String requestpossibleflag = (String) item.get("requestpossibleflag");
		String coursetype = (String) item.get("coursetype");
		String groupflag = (String) item.get("groupflag");
		requestBox.put("coursetype", coursetype);
		if("Y".equals(requestpossibleflag)){
			// 정규과정인 경우 소속 과정을 가져와서 신청 테이블에 넣는다.
			// 정규과정이 아닌 경우 그냥 신청 테이블에 넣는다.
			List<DataBox> list = lmsRequestMapper.selectLmsRequestCourseList(requestBox);
			String togetherrequestflag = requestBox.get("togetherrequestflag");
			for(int i = 0; i < list.size(); i++){
				DataBox data = list.get(i);
				requestBox.put("targetcourseid", data.get("courseid")) ;
				String fStr = "F";
				String lStr = "L";
				String rStr = "R";
				if( fStr.equals(data.get("coursetype"))  && !"Y".equals(data.get("togetherflag"))){ // 오프라인이면서 부사업자 허용을 안한 경우 부사업자 플래그를 널로 넣는다.
					requestBox.remove("togetherrequestflag"); // 플래그 널로 셋팅
				}else{
					requestBox.put("togetherrequestflag", togetherrequestflag) ;
				}
				cnt += lmsRequestMapper.insertCourseRequest(requestBox);
				
				/*쪽지 발송*/
				
				if(i==0 && (fStr.equals(data.get("coursetype")) || lStr.equals(data.get("coursetype")) || rStr.equals(data.get("coursetype")))){
					requestBox.put("coursename", data.get("coursename")) ;
					requestBox.put("apname", data.get("apname")) ;
					requestBox.put("startdate", data.get("startdate")) ;
					requestBox.put("noteitem", "101") ; // 오프라인 신청완료, 라이브 신청완료, 정규과정 신청완료
					lmsCommonService.insertLmsNoteSend(requestBox);
				}
			}
			requestBox.put("togetherrequestflag", togetherrequestflag) ;
			if("R".equals(coursetype)){ // 정규과정인 경우 LMSSTEPFINISH 테이블에도 넣어야 한다.
				cnt += lmsRequestMapper.insertCourseRequestStep(requestBox);
			}
		}
		if(cnt > 0 ){
			//AmwayGo 그룹방 연동
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
			
			result = "OK";
		}
		returnMap.put("result", result);
		returnMap.put("coursetype", coursetype);
		returnMap.put("groupflag", groupflag);
		returnMap.put("item", item);
		
		return returnMap;
	}
	
	/**
	 * 무권한 페이지 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsShareCourseDetail(RequestBox requestBox) throws Exception {
		Map<String, Object> data = new HashMap<String, Object>();
		// 과정상세
		DataBox item = lmsRequestMapper.selectLmsCourseShareDetail(requestBox);
		if(item !=  null){
			// 조회수 증가
			lmsCommonMapper.updateCourseViewCount(requestBox);
			
			item.put("coursecontent", LmsUtil.getHtmlStrCnvrBr(item.getString("coursecontent") ) ) ;
			data.put("item", item);
			requestBox.put("courseid", item.get("courseid"));
			String coursetype = item.getString("coursetype");
			
			// 과정상세
			if("F".equals(coursetype)){
				DataBox item2 = lmsRequestMapper.selectLmsRequestOfflineDetail(requestBox);
				data.put("item2", item2);
			} 
			if("R".equals(coursetype)){
				DataBox item2 = lmsRequestMapper.selectLmsRequestRegularDetail(requestBox);
				data.put("item2", item2);
				data.put("apList", lmsRequestMapper.selectLmsRequestCourseApList(requestBox));
			}
			if("L".equals(coursetype)){
				DataBox item2 = lmsRequestMapper.selectLmsRequestLiveDetail(requestBox);
				data.put("item2", item2);
			}
			if("D".equals(coursetype)){
				DataBox item2 = lmsRequestMapper.selectLmsCourseShareDetailData(requestBox);
				data.put("item2", item2);
			}
			// 신청기간 목록
			data.put("reqList", lmsRequestMapper.selectLmsRequestDateList(requestBox));
		}
		return data;
	}
	
	
	
	
}
