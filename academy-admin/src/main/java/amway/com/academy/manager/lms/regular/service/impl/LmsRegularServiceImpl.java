package amway.com.academy.manager.lms.regular.service.impl;

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
import amway.com.academy.manager.lms.regular.service.LmsRegularService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsRegularServiceImpl implements LmsRegularService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsRegularServiceImpl.class);
	
	@Autowired
	private LmsRegularMapper lmsRegularMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsKeywordMapper lmsKeywordMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	private LmsKeyword lmskeyword = new LmsKeyword();

	// 정규과정 목록 카운트
	@Override
	public int selectLmsRegularCount(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularCount(requestBox);
	}
	
	// 정규과정 목록 
	@Override
	public List<DataBox> selectLmsRegularList(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularList(requestBox);
	}	
	
	// 정규과정 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsRegularListExcelDown(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularListExcelDown(requestBox);
	}
	
	// 정규과정 삭제
	@Override
	public int deleteLmsRegular(RequestBox requestBox) throws Exception {
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
	
	// 정규과정 상세
	@Override
	public DataBox selectLmsRegular(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegular(requestBox);
	}

	// 정규과정 등록
	@Override
	public int insertLmsRegular(RequestBox requestBox) throws Exception {
		String themeseq = requestBox.get("themeseq");
		if("".equals(themeseq)){
			// 과정 기본 정보 테마 멕스값 가져오기
			int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
			requestBox.put("themeseq", themeseqInt);
		}
		// 과정 기본 정보 등록
		
		// 교육시작일, 종료일 우선 설정
		requestBox.put("startdate", "2000-01-01 00:00:00");
		requestBox.put("enddate", "2000-01-01 00:00:00");
		int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
		requestBox.put("courseid", requestBox.get("maxcourseid"));
		// 정규과정 개별 상세 정보 등록
		int regularCnt = lmsRegularMapper.insertLmsRegular(requestBox);
		
		// 스텝및 유닛 삭제/입력
		@SuppressWarnings("unused")
		int stepCnt = deleteInsertLmsStepUnit(requestBox);
		
		//정규과정 SEARCHLMS 등록
		if(requestBox.get("openflag").equals("Y"))
		{
			Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
			requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("maxcourseid"));
			requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("maxcourseid"));
			
			String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",정규과정"+","+requestBox.get("note")+","+requestBox.get("themename")+","+requestBox.get("stepnames")+","+requestBox.get("stepunitnames");
			requestBox.put("keyword", keyword);
			
			lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
		}
		
		//AmwayGo 그룹방 연동
		requestBox.put("uid", "");
		lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
		
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
		
		return courseCnt + regularCnt + conditionCnt + onlineUpdateCnt;
	}
	
	// 정규과정 수정
	@Override
	public int updateLmsRegular(RequestBox requestBox) throws Exception {
		String themeseq = requestBox.get("themeseq");
		if("".equals(themeseq)){
			// 과정 기본 정보 테마 멕스값 가져오기
			int themeseqInt = lmsCourseMapper.selectLmsCourseMaxThemeSeq(requestBox);
			requestBox.put("themeseq", themeseqInt);
		}
		// 과정 기본 정보 수정
		// 교육시작일, 종료일 우선 설정
		requestBox.put("startdate", "2000-01-01 00:00:00");
		requestBox.put("enddate", "2000-01-01 00:00:00");
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		// 정규과정 개별 상세 정보 수정
		int regularCnt = lmsRegularMapper.updateLmsRegular(requestBox);
		
		if("0".equals(requestBox.get("studentcount"))){ // 수강생이 없는 경우만 스탬 유닛 수정하기
			// 스텝및 유닛 삭제/입력
			deleteInsertLmsStepUnit(requestBox);
		}else{
			lmsRegularMapper.updateLmsCourseEduDate(requestBox);
		}
		//정규과정 SEARCHLMS 수정
		//공개냐
		if(requestBox.get("openflag").equals("Y"))
		{	
			Map<String,String> url = lmskeyword.lmsKeywordUrl(requestBox.get("coursetype"), 0);
			requestBox.put("academyurl", url.get("academyUrl")+"?courseid="+requestBox.get("courseid"));
			requestBox.put("hybrisurl", url.get("hybrisUrl")+"?courseid="+requestBox.get("courseid"));
			
			String keyword = requestBox.get("courseimagenote")+","+requestBox.get("searchword")+",정규과정"+","+requestBox.get("note")+","+requestBox.get("themename")+","+requestBox.get("stepnames")+","+requestBox.get("stepunitnames");
			requestBox.put("keyword", keyword);
			requestBox.put("maxcourseid", requestBox.get("courseid"));
			lmsKeywordMapper.mergeKeywordSearchLms(requestBox);
		}
		//비공개냐 or 정규냐
		else
		{
			lmsKeywordMapper.deleteLmsKeyword(requestBox);
		}
		
		//AmwayGo 그룹방 연동
		requestBox.put("uid", "");
		lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
		
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
				
		return courseCnt + regularCnt + courseConditionDeleteCnt + conditionCnt + onlineUpdateCnt;
	}
	
	// 정규과정 스탬프 목록 
	@Override
	public List<DataBox> selectLmsRegularStampList(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularStampList(requestBox);
	}

	// 정규과정 과정 목록 카운트
	@Override
	public int selectLmsRegularCourseCount(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularCourseCount(requestBox);
	}
	
	// 정규과정 과정 목록 
	@Override
	public List<DataBox> selectLmsRegularCourseList(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularCourseList(requestBox);
	}
	
	// 정규과정 과정 테마 목록 카운트
	@Override
	public int selectLmsRegularCourseThemeCount(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularCourseThemeCount(requestBox);
	}
	
	// 정규과정 과정 테마 목록 
	@Override
	public List<DataBox> selectLmsRegularCourseThemeList(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularCourseThemeList(requestBox);
	}
	
	// 정규과정 오프라인과정 테마번호로 검색한 목록 
	@Override
	public List<DataBox> selectLmsRegularOffCourseList(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularOffCourseList(requestBox);
	}
	
	// 정규과정 스텝/유닛 삭제 및 등록
	@Override
	@SuppressWarnings("rawtypes")
	public int deleteInsertLmsStepUnit(RequestBox requestBox) throws Exception {
		int result = 0;
		// 수강생 삭제
		int delStudentCnt = lmsRegularMapper.deleteLmsStudent(requestBox);
		// 스텝종료 정보 삭제
		int delStepFinishCnt = lmsRegularMapper.deleteLmsStepFinish(requestBox);
		// 스텝유닛정보 삭제
		int delUnitCnt = lmsRegularMapper.deleteLmsStepUnit(requestBox);
		// 스텝정보삭제
		int delStepCnt = lmsRegularMapper.deleteLmsStep(requestBox);
		int insertStepCnt = 0;
		int insertUnitCnt = 0;
		String stepNames = "";
		String stepUnitNames = "";
		// 스텝 벡터
		
		String zeroStr = "";
		
		Vector stepseqV = requestBox.getVector("stepseq");
		Vector steporderV = requestBox.getVector("steporder");
		Vector stepnameV = requestBox.getVector("stepname");
		Vector stepcountV = requestBox.getVector("stepcount");
		for(int i = 0 ; i < stepseqV.size() ; i++){
			String stepseq = stepseqV.get(i).toString();
			String steporder = steporderV.get(i).toString();
			String stepname = stepnameV.get(i).toString();
			String stepcount = stepcountV.get(i).toString();
			String mustflag = "N";
			if(!zeroStr.equals(stepcount)){
				mustflag = "Y";
			}
			requestBox.put("stepseqstep", steporder); // 스텝순서로 같이 입력한다.
			requestBox.put("steporderstep", steporder);
			requestBox.put("stepnamestep", stepname);
			requestBox.put("stepcountstep", stepcount);
			requestBox.put("mustflagstep", mustflag);
			
			if(stepNames.equals(""))
			{
				stepNames = stepname;
			}
			else
			{
				StringBuffer stepNamesBuffer = new StringBuffer(stepNames);
				stepNamesBuffer.append(","+stepname);
				stepNames = stepNamesBuffer.toString(); 
			}
			
			// 스텝 등록
			insertStepCnt += lmsRegularMapper.insertLmsStep(requestBox);
			
			//유닛 벡터
			Vector stepcourseidV = requestBox.getVector("stepcourseid"+stepseq);
			Vector coursemustflagV = requestBox.getVector("coursemustflag"+stepseq);
			Vector unitorderV = requestBox.getVector("unitorder"+stepseq);
			for(int j = 0; j < stepcourseidV.size(); j++){
				String stepcourseid = stepcourseidV.get(j).toString(); 
				String coursemustflag = coursemustflagV.get(j).toString();
				String unitorder = unitorderV.get(j).toString();
				requestBox.put("stepcourseidunit", stepcourseid);
				requestBox.put("mustflagunit", coursemustflag);
				requestBox.put("unitorderunit", unitorder);
				
				//SEARCHLMS INSERT용 데이터
				if(stepUnitNames.equals(""))
				{
					stepUnitNames = lmsKeywordMapper.selectLmsKeywordCourseName(requestBox);
				}
				else
				{
					StringBuffer stepUnitNamesBuffer  = new StringBuffer(stepUnitNames);
					stepUnitNamesBuffer.append(","+lmsKeywordMapper.selectLmsKeywordCourseName(requestBox));
					stepUnitNames = stepUnitNamesBuffer.toString(); 
					//stepUnitNames += ","+lmsKeywordMapper.selectLmsKeywordCourseName(requestBox); 버퍼로 변경
				}
				
				insertUnitCnt += lmsRegularMapper.insertLmsStepUnit(requestBox);
			}
		}
		
		//SEARCHLMS INSERT용 데이터
		requestBox.put("stepnames", stepNames);
		requestBox.put("stepunitnames", stepUnitNames);
		lmsRegularMapper.updateLmsCourseEduDate(requestBox);
		result = delStudentCnt + delStepFinishCnt + delUnitCnt + delStepCnt + insertStepCnt + insertUnitCnt;
		return result; 
	}
	
	// 정규과정 스텝 유닛 합친 목록
	@Override
	public List<DataBox> selectLmsRegularStepUnitSumList(RequestBox requestBox) throws Exception {
		List<DataBox> stepList = lmsRegularMapper.selectLmsRegularStepList(requestBox);
		List<DataBox> newStepList = new ArrayList<DataBox>();
		List<DataBox> unitList = lmsRegularMapper.selectLmsRegularStepUnitList(requestBox);
		for(int i=0; i<stepList.size() ; i++){
			DataBox step = stepList.get(i);
			String stepseq = step.getString("stepseq");
			List<DataBox> newUnitList = new ArrayList<DataBox>();
			for(int j = 0; j < unitList.size(); j++){
				DataBox unit = unitList.get(j);
				String unitstepseq = unit.getString("stepseq");
				if(stepseq.equals(unitstepseq)){
					newUnitList.add(unit);
				}
			}
			step.put("unitlist", newUnitList);
			newStepList.add(step);
		}
		
		return newStepList;
				
	}	
	
	
	// 정규과정 스텝유닛별 수정용 상세
	@Override
	public DataBox selectLmsRegularStepUnitEditDetail(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularStepUnitEditDetail(requestBox);
	}
	
	// 정규과정 스텝유닛별 수정
	@Override
	public int updateLmsRegularStepUnitEdit(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.updateLmsRegularStepUnitEdit(requestBox);
	}
	
	// 정규과정 스텝유닛별 수정용 상세 시험
	@Override
	public DataBox selectLmsRegularStepUnitEditTestDetail(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularStepUnitEditTestDetail(requestBox);
	}
	
	// 정규과정 스텝유닛별 시험 수정
	@Override
	public int updateLmsRegularStepUnitEditTest(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.updateLmsRegularStepUnitEditTest(requestBox);
	}
	
	// 정규과정 스텝유닛별 수정용 상세 오프라인
	@Override
	public DataBox selectLmsRegularStepUnitEditOffDetail(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.selectLmsRegularStepUnitEditOffDetail(requestBox);
	}
	
	// 정규과정 스텝유닛별 오프라인 수정
	@Override
	public int updateLmsRegularStepUnitEditOff(RequestBox requestBox) throws Exception {
		return lmsRegularMapper.updateLmsRegularStepUnitEditOff(requestBox);
	}
	
}
