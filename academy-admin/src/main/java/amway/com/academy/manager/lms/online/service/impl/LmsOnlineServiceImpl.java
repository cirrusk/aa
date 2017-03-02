package amway.com.academy.manager.lms.online.service.impl;

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
import amway.com.academy.manager.lms.online.service.LmsOnlineService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsOnlineServiceImpl implements LmsOnlineService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOnlineServiceImpl.class);
	
	@Autowired
	private LmsOnlineMapper lmsOnlineMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsCommonService lmsCommonService;
	
	@Autowired
	private LmsKeywordMapper lmsKeywordMapper;
	
	private LmsKeyword lmsKeyword = new LmsKeyword();
	
	// 온라인 목록 카운트
	@Override
	public int selectLmsOnlineCount(RequestBox requestBox) throws Exception {
		return lmsOnlineMapper.selectLmsOnlineCount(requestBox);
	}
	
	// 온라인 목록 
	@Override
	public List<DataBox> selectLmsOnlineList(RequestBox requestBox) throws Exception {
		return lmsOnlineMapper.selectLmsOnlineList(requestBox);
	}	
	
	// 온라인 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsOnlineListExcelDown(RequestBox requestBox) throws Exception {
		return lmsOnlineMapper.selectLmsOnlineListExcelDown(requestBox);
	}
	
	// 온라인 삭제
	@Override
	public int deleteLmsOnline(RequestBox requestBox) throws Exception {
		
		int count = lmsCourseMapper.deleteLmsCourse(requestBox);
		
		//SEARCHLMS 삭제
		lmsKeywordMapper.deleteLmsKeyword(requestBox);
		
		return count;
	}
	
	// 온라인 상세
	@Override
	public DataBox selectLmsOnline(RequestBox requestBox) throws Exception {
		return lmsOnlineMapper.selectLmsOnline(requestBox);
	}

	// 온라인 등록
	@Override
	public int insertLmsOnline(RequestBox requestBox) throws Exception {
		// 과정 기본 정보 등록
		int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
		//String maxcourseid = requestBox.get("maxcourseid");
		
		//온라인과정 SEARCHLMS테이블 등록
		if(requestBox.get("openflag").equals("Y"))
		{
			Map<String,String> url = lmsKeyword.lmsKeywordUrl(requestBox.get("coursetype"), requestBox.getInt("categoryid"));
			
			//하이브리스에서 검색어 던질때 코스아이디 넣도록 변경함
			//requestBox.put("academyurl", url.get("academyUrl"));
			//requestBox.put("hybrisurl", url.get("hybrisUrl"));
			requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("maxcourseid"));
			requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("maxcourseid"));
			
			String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",온라인";
			requestBox.put("keyword", keyword);
			
			lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
		}
		//End SEARCHLMS테이블 등록
		
		// 온라인 개별 상세 정보 등록
		int onlineCnt = lmsOnlineMapper.insertLmsOnline(requestBox);

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
		if("Y".equals(requestBox.get("openflag"))){
			requestBox.put("noteitem", "114");
			lmsCommonService.insertLmsNoteSend(requestBox);
			
			// 구독 푸시 등록
			lmsCommonService.insertLmsPushSendSubsribe(requestBox);
		}
	
		return courseCnt + onlineCnt + conditionCnt + onlineUpdateCnt;
		
	}
	
	// 온라인 수정
	@Override
	public int updateLmsOnline(RequestBox requestBox) throws Exception {
		// 과정 기본 정보 수정
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		
		//SEARCHLMS MERGE
			//공개냐
			if(requestBox.get("openflag").equals("Y"))
			{		
				String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",온라인";
				requestBox.put("keyword", keyword);
				requestBox.put("maxcourseid", requestBox.get("courseid"));
				lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
			}
			//비공개냐 or 정규냐
			else
			{
				lmsKeywordMapper.deleteLmsKeyword(requestBox);
			}
		
		// 온라인 개별 상세 정보 수정
		int onlineCnt = lmsOnlineMapper.updateLmsOnline(requestBox);

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
		
		return courseCnt + onlineCnt + conditionCnt + courseConditionDeleteCnt + onlineUpdateCnt;
	}
}
