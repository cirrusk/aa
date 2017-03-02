package amway.com.academy.manager.lms.data.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.common.LmsUtil;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.course.LmsKeyword;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import amway.com.academy.manager.lms.course.service.impl.LmsKeywordMapper;
import amway.com.academy.manager.lms.data.service.LmsDataService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsDataServiceImpl implements LmsDataService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsDataServiceImpl.class);
	
	@Autowired
	private LmsDataMapper lmsDataMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired 
	private LmsKeywordMapper lmsKeywordMapper;
	
	@Autowired
	private LmsCommonService lmsCommonService;
	
	private LmsKeyword lmsKeyword = new LmsKeyword();
	
	// 교육자료 목록 카운트
	@Override
	public int selectLmsDataCount(RequestBox requestBox) throws Exception {
		return lmsDataMapper.selectLmsDataCount(requestBox);
	}
	
	// 교육자료 목록 
	@Override
	public List<DataBox> selectLmsDataList(RequestBox requestBox) throws Exception {
		return lmsDataMapper.selectLmsDataList(requestBox);
	}	
	
	// 교육자료 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsDataListExcelDown(RequestBox requestBox) throws Exception {
		return lmsDataMapper.selectLmsDataListExcelDown(requestBox);
	}
	
	// 교육자료 삭제
	@Override
	public int deleteLmsData(RequestBox requestBox) throws Exception {
		int count = lmsCourseMapper.deleteLmsCourse(requestBox);
		
		//SEARCHLMS 삭제
		lmsKeywordMapper.deleteLmsKeyword(requestBox);
		
		return count;
	}
	
	// 교육자료 상세
	@Override
	public DataBox selectLmsData(RequestBox requestBox) throws Exception {
		return lmsDataMapper.selectLmsData(requestBox);
	}

	// 교육자료 등록
	@Override
	public int insertLmsData(RequestBox requestBox) throws Exception {
		// 과정 기본 정보 등록
		int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
		// 교육자료 개별 상세 정보 등록
		int onlineCnt = lmsDataMapper.insertLmsData(requestBox);
		
				//교육자료 SEARCHLMS테이블 등록
				if(requestBox.get("openflag").equals("Y"))
				{
					Map<String,String> url = lmsKeyword.lmsKeywordUrl(requestBox.get("coursetype"), requestBox.getInt("categoryid"));
					
					requestBox.put("academyurl", url.get("academyUrl")+"&courseid="+requestBox.get("maxcourseid"));
					requestBox.put("hybrisurl", url.get("hybrisUrl")+"&courseid="+requestBox.get("maxcourseid"));
					
					String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",교육자료";
					requestBox.put("keyword", keyword);
					
					lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
				}
		
		//대상자 정보 ArrayList로 만들기
		requestBox.put("courseid", requestBox.get("maxcourseid"));
		
		int conditionCnt = 0;
		ArrayList<Map<String,String>> conditionList = LmsUtil.getLmsCourseConditionList(requestBox);
		for( int i=0; i<conditionList.size(); i++ ) {
			Map<String,String> retMap = conditionList.get(i);
			requestBox.putAll(retMap);
			conditionCnt = lmsCourseMapper.insertLmsCourseCondition(requestBox);
		}
		
		//온라인 과정 수강신청일을 이용권한의 min, max 값으로 세팅할 것
		int onlineUpdateCnt = lmsCourseMapper.updateLmsCourseRequestDate(requestBox);
				
		//구독신청자에게 쪽지보내기
		if("Y".equals(requestBox.get("openflag")) ){
			requestBox.put("noteitem", "114");
			lmsCommonService.insertLmsNoteSend(requestBox);
			
			// 구독 푸시 등록
			lmsCommonService.insertLmsPushSendSubsribe(requestBox);
		}
		
		return courseCnt + onlineCnt + conditionCnt + onlineUpdateCnt;
	}
	
	// 교육자료 수정
	@Override
	public int updateLmsData(RequestBox requestBox) throws Exception {
		// 과정 기본 정보 수정
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		// 교육자료 개별 상세 정보 수정
		int onlineCnt = lmsDataMapper.updateLmsData(requestBox);

					// SEARCHLMS테이블 수정
					//공개냐
					if(requestBox.get("openflag").equals("Y"))
					{		
							Map<String,String> url = lmsKeyword.lmsKeywordUrl(requestBox.get("coursetype"), requestBox.getInt("categoryid"));
							
							requestBox.put("academyurl", url.get("academyUrl")+"&courseid="+requestBox.get("courseid"));
							requestBox.put("hybrisurl", url.get("hybrisUrl")+"&courseid="+requestBox.get("courseid"));
						
							String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",교육자료";
							requestBox.put("keyword", keyword);
							requestBox.put("maxcourseid", requestBox.get("courseid"));
							lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
					}
					//비공개냐 or 정규냐
					else
					{
						lmsKeywordMapper.deleteLmsKeyword(requestBox);
					}
				//END SEARCHLMS테이블 수정
		
		
		//대상자 정보 삭제 후 대상자 정보 ArrayList로 만들어서 등록하기
		int courseConditionDeleteCnt = lmsCourseMapper.deleteLmsCourseCondition(requestBox);
		
		int conditionCnt = 0;
		ArrayList<Map<String,String>> conditionList = LmsUtil.getLmsCourseConditionList(requestBox);
		for( int i=0; i<conditionList.size(); i++ ) {
			Map<String,String> retMap = conditionList.get(i);

			requestBox.putAll(retMap);
			conditionCnt = lmsCourseMapper.insertLmsCourseCondition(requestBox);
		}
		
		//온라인 과정 수강신청일을 이용권한의 min, max 값으로 세팅할 것
		int onlineUpdateCnt = lmsCourseMapper.updateLmsCourseRequestDate(requestBox);
			
		//구독신청자에게 쪽지보내기
		String yStr = "Y";
		if(yStr.equals(requestBox.get("openflag")) && !yStr.equals(requestBox.get("old_openflag"))){
			requestBox.put("noteitem", "114");
			lmsCommonService.insertLmsNoteSend(requestBox);
			
			// 구독 푸시 등록
			lmsCommonService.insertLmsPushSendSubsribe(requestBox);
		}
		
		return courseCnt + onlineCnt + courseConditionDeleteCnt + conditionCnt + onlineUpdateCnt;
	}
	
	/**
	 * 자료 복사
	 */
	public int copyLmsDataAjax(RequestBox requestBox) throws Exception {
		
		int totalCount = 0;
		
		//복사할 대상 일기
		String[] courseids = requestBox.getString("courseids").split("[,]");
		for(int i=0; i<courseids.length; i++) {
			//1. 자료 복사
			requestBox.put("courseid", courseids[i]);
			
			lmsCourseMapper.copyLmsCourseAjax(requestBox);
			requestBox.put("maxcourseid", requestBox.get("maxcourseid"));
			
			//2. 자료 콘디션 복사
			lmsCourseMapper.copyLmsConditionAjax(requestBox);
			
			//3. 자료 상세
			lmsDataMapper.copyLmsDataAjax(requestBox);
			
			//4. 검색어 등록 :--> 날짜를 수정해야 하므로 복사에서는 삭제함
			//5. 푸시 등도 맞지 않는 데이터이므로 삭제함
			
			totalCount ++;
		}
		
		return totalCount;
	}
	
}
