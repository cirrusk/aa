package amway.com.academy.manager.lms.live.service.impl;

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
import amway.com.academy.manager.lms.live.service.LmsLiveService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsLiveServiceImpl implements LmsLiveService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsLiveServiceImpl.class);
	
	@Autowired
	private LmsLiveMapper lmsLiveMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsKeywordMapper lmsKeywordMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	private LmsKeyword lmskeyword = new LmsKeyword();
	
	// 라이브 목록 카운트
	@Override
	public int selectLmsLiveCount(RequestBox requestBox) throws Exception {
		return lmsLiveMapper.selectLmsLiveCount(requestBox);
	}
	
	// 라이브 목록 
	@Override
	public List<DataBox> selectLmsLiveList(RequestBox requestBox) throws Exception {
		return lmsLiveMapper.selectLmsLiveList(requestBox);
	}	
	
	// 라이브 목록 엑셀다운
		@Override
		public List<Map<String, String>> selectLmsLiveListExcelDown(RequestBox requestBox) throws Exception {
			return lmsLiveMapper.selectLmsLiveListExcelDown(requestBox);
		}
		
		// 라이브 삭제
		@Override
		public int deleteLmsLive(RequestBox requestBox) throws Exception {
			int cnt = lmsCourseMapper.deleteLmsCourse(requestBox);
			//라이브교육 SEARCHLMS삭제
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
		
		// 라이브 상세
		@Override
		public DataBox selectLmsLive(RequestBox requestBox) throws Exception {
			return lmsLiveMapper.selectLmsLive(requestBox);
		}

		// 라이브 등록
		@Override
		public int insertLmsLive(RequestBox requestBox) throws Exception {
			String themeseq = requestBox.get("themeseq");
			if("".equals(themeseq)){
				// 과정 기본 정보 테마 멕스값 가져오기
				int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
				requestBox.put("themeseq", themeseqInt);
			}
			// 과정 기본 정보 등록
			int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
			// 라이브 개별 상세 정보 등록
			int liveCnt = lmsLiveMapper.insertLmsLive(requestBox);
			
			//라이브 과정 SEARCHLMS 등록
			if(requestBox.get("openflag").equals("Y"))
			{
				Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
				requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("maxcourseid"));
				requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("maxcourseid"));
				
				String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",라이브"+","+requestBox.get("note")+","+requestBox.get("themename");
				requestBox.put("keyword", keyword);
				
				lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
			}
			//End SEARCHLMS등록
			
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
			
			//AmwayGo 그룹방 연동
			requestBox.put("courseid", requestBox.get("courseid"));
			requestBox.put("uid", "");
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
			
			return courseCnt + liveCnt + conditionCnt + onlineUpdateCnt;
		}
		
		// 라이브 수정
		@Override
		public int updateLmsLive(RequestBox requestBox) throws Exception {
			String themeseq = requestBox.get("themeseq");
			if("".equals(themeseq)){
				// 과정 기본 정보 테마 멕스값 가져오기
				int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
				requestBox.put("themeseq", themeseqInt);
			}
			// 과정 기본 정보 수정
			int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
			// 라이브 개별 상세 정보 수정
			int liveCnt = lmsLiveMapper.updateLmsLive(requestBox);
			
			//SEARCHLMS테이블 수정
				//공개냐
				if(requestBox.get("openflag").equals("Y"))
				{		
						Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
						requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("courseid"));
						requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("courseid"));
					
						String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",라이브"+","+requestBox.get("note")+","+requestBox.get("themename");
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
			
			//AmwayGo 그룹방 연동
			requestBox.put("uid", "");
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
			
			return courseCnt + liveCnt + courseConditionDeleteCnt + conditionCnt + onlineUpdateCnt;
		}

}
