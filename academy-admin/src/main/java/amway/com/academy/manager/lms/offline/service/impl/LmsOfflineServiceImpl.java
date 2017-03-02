package amway.com.academy.manager.lms.offline.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.common.LmsUtil;
import amway.com.academy.manager.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.manager.lms.course.LmsKeyword;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import amway.com.academy.manager.lms.course.service.impl.LmsKeywordMapper;
import amway.com.academy.manager.lms.offline.service.LmsOfflineService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsOfflineServiceImpl implements LmsOfflineService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOfflineServiceImpl.class);
	
	@Autowired
	private LmsOfflineMapper lmsOfflineMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	@Autowired
	private LmsKeywordMapper lmsKeywordMapper;
	
	private LmsKeyword lmskeyword = new LmsKeyword();
	
	// 오프라인 목록 카운트
	@Override
	public int selectLmsOfflineCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMapper.selectLmsOfflineCount(requestBox);
	}
	
	// 오프라인 목록 
	@Override
	public List<DataBox> selectLmsOfflineList(RequestBox requestBox) throws Exception {
		return lmsOfflineMapper.selectLmsOfflineList(requestBox);
	}	
	
	// 오프라인 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsOfflineListExcelDown(RequestBox requestBox) throws Exception {
		return lmsOfflineMapper.selectLmsOfflineListExcelDown(requestBox);
	}
	
	// 오프라인 삭제
	@Override
	public int deleteLmsOffline(RequestBox requestBox) throws Exception {
		int cnt = lmsCourseMapper.deleteLmsCourse(requestBox);
		//오프라인 SEARCHLMS삭제
		lmsKeywordMapper.deleteLmsKeyword(requestBox);
		
		//AmwayGo 그룹방 연동
		//courseids 배열이므로 하나씩 받아서 보내야 함
		Vector courseids = requestBox.getVector("courseid");
		int zero = 0;
		if(courseids != null && courseids.size() > zero){
			for(int i = 0; i < courseids.size(); i++){
				requestBox.put("courseid", (String) courseids.get(i)) ;
				requestBox.put("uid", "");
				lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);				
			}
		}
		return cnt;
	}
	
	// 오프라인 상세
	@Override
	public DataBox selectLmsOffline(RequestBox requestBox) throws Exception {
		return lmsOfflineMapper.selectLmsOffline(requestBox);
	}

	// 오프라인 등록
	@SuppressWarnings("rawtypes")
	@Override
	public int insertLmsOffline(RequestBox requestBox) throws Exception {
		String themeseq = requestBox.get("themeseq");
		if("".equals(themeseq)){
			// 과정 기본 정보 테마 멕스값 가져오기
			int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
			requestBox.put("themeseq", themeseqInt);
		}
		
		// 과정 등록시 배열 처리하여 루프문을 돈다.
		Vector apseqVec = requestBox.getVector("apseq"); // 교육장소
		Vector apnameVec = requestBox.getVector("apname");
		Vector roomseqVec = requestBox.getVector("roomseq"); 
		Vector roomnameVec = requestBox.getVector("roomname");
		Vector startdateVec = requestBox.getVector("startdate");
		Vector enddateVec = requestBox.getVector("enddate");
		Vector limitcountVec = requestBox.getVector("limitcount");
		Vector detailcontentVec = requestBox.getVector("detailcontent");
		
		int courseCnt = 0;
		int onlineCnt = 0;
		int conditionCnt = 0;
		int onlineUpdateCnt = 0;
		for(int k=0; k<apseqVec.size(); k++){
			requestBox.put("apseq", apseqVec.get(k));
			requestBox.put("apname", apnameVec.get(k));
			requestBox.put("roomseq", roomseqVec.get(k));
			requestBox.put("roomname", roomnameVec.get(k));
			requestBox.put("startdate", startdateVec.get(k));
			requestBox.put("enddate", enddateVec.get(k));
			requestBox.put("limitcount", limitcountVec.get(k));
			requestBox.put("detailcontent", detailcontentVec.get(k));
			
			// 과정 기본 정보 등록
			courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
			
			// 오프라인 개별 상세 정보 등록
			onlineCnt = lmsOfflineMapper.insertLmsOffline(requestBox);
			
			//오프라인 과정 SEARCHLMS 등록
			if(requestBox.get("openflag").equals("Y"))
			{
				Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
				requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("maxcourseid"));
				requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("maxcourseid"));
				
				String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",오프라인"+","+requestBox.get("note")+","+requestBox.get("apname")+","+requestBox.get("roomname")+","+requestBox.get("detailcontent")+","+requestBox.get("themename");
				requestBox.put("keyword", keyword);
				
				lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
			}
			//End SEARCHLMS등록

			
			//대상자 정보 ArrayList로 만들기
			requestBox.put("courseid", requestBox.get("maxcourseid"));
			ArrayList<Map<String,String>> conditionList = LmsUtil.getLmsCourseConditionList(requestBox);
			for( int i=0; i<conditionList.size(); i++ ) {
				Map<String,String> retMap = conditionList.get(i);
				requestBox.putAll(retMap);
				conditionCnt = lmsCourseMapper.insertLmsCourseCondition(requestBox);
			}
			
			//AmwayGo 그룹방 연동
			requestBox.put("uid", "");
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
			
			//과정 수강신청일을 이용권한의 min, max 값으로 세팅할 것
			onlineUpdateCnt = lmsCourseMapper.updateLmsCourseRequestDate(requestBox);
		}
		return courseCnt + onlineCnt + conditionCnt + onlineUpdateCnt;
	}
	
	// 오프라인 수정
	@Override
	public int updateLmsOffline(RequestBox requestBox) throws Exception {
		String themeseq = requestBox.get("themeseq");
		if("".equals(themeseq)){
			// 과정 기본 정보 테마 멕스값 가져오기
			int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
			requestBox.put("themeseq", themeseqInt);
		}
		// 과정 기본 정보 수정
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		// 오프라인 개별 상세 정보 수정
		int onlineCnt = lmsOfflineMapper.updateLmsOffline(requestBox);
		
		//SEARCHLMS MERGE
			//공개냐
			if(requestBox.get("openflag").equals("Y"))
			{	
				Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
				requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("courseid"));
				requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("courseid"));
				
				String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",오프라인"+","+requestBox.get("note")+","+requestBox.get("apname")+","+requestBox.get("roomname")+","+requestBox.get("detailcontent")+","+requestBox.get("themename");
				requestBox.put("keyword", keyword);
				requestBox.put("maxcourseid", requestBox.get("courseid"));
				lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
			}
			//비공개 or 정규
			else
			{
				lmsKeywordMapper.deleteLmsKeyword(requestBox);
			}
		
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
		
		//AmwayGo 그룹방 연동
		requestBox.put("uid", "");
		lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
				
		return courseCnt + onlineCnt + courseConditionDeleteCnt + conditionCnt + onlineUpdateCnt;
	}
}
