package amway.com.academy.lms.myAcademy.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.myAcademy.service.LmsMySurveyService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMySurveyServiceImpl  implements LmsMySurveyService{
	@Autowired
	private LmsMySurveyMapper lmsMySurveyMapper;

	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	public Map<String, Object> selectLmsSurvey(RequestBox requestBox) throws Exception {
		
		return lmsMySurveyMapper.selectLmsSurvey(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectLmsSurveySampleList(RequestBox requestBox) throws Exception {
		
		//1. 설문지 읽기
		List<Map<String, Object>> answerList = lmsMySurveyMapper.selectLmsSurveyList(requestBox);
		
		//2. 보기 읽기
		List<Map<String, String>> answerSampleList = lmsMySurveyMapper.selectLmsSurveySampleList(requestBox);
		
		for( int i=0; i<answerList.size(); i++ ) {
			Map<String,Object> tempAnswerMap = answerList.get(i);
			
			List<Map<String,String>> sampleList = new ArrayList<Map<String,String>>();
			for( int k=0;k<answerSampleList.size(); k++) {
				Map<String,String> tempSampleMap = answerSampleList.get(k);
				if( tempAnswerMap.get("surveyseq").equals( tempSampleMap.get("surveyseq")) ) {
					sampleList.add(tempSampleMap);
				}
			}
			
			tempAnswerMap.put("sampleList", sampleList);
			answerList.set(i, tempAnswerMap);
		}
		
		return answerList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public int submitLmsSurvey(RequestBox requestBox, List<Map<String,Object>> reponseList) throws Exception {
		
		int resultCount = 0;
		
		for(int i=0;i<reponseList.size(); i++) {
			Map<String,Object> retMap = reponseList.get(i);
			
			//1. 답안지 등록하기
			requestBox.put("surveyseq", retMap.get("surveyseq"));
			requestBox.put("subjectresponse", retMap.get("subjectresponse"));
			requestBox.put("objectresponse", retMap.get("objectresponse"));
			
			resultCount = lmsMySurveyMapper.insertLmsSurveyResponse(requestBox);
			
			List<Map<String,String>> opinionList = (List<Map<String,String>>)retMap.get("opinionList");
			int check0 = 0;
			if( opinionList != null && opinionList.size() > check0 ) {
				
				for( int k=0; k<opinionList.size(); k++) {
					Map<String,String> opinionMap = opinionList.get(k);

					//2. 답안지 의견 등록하기
					requestBox.put("opinionseq", opinionMap.get("opinionseq"));
					requestBox.put("opinioncontent", opinionMap.get("opinioncontent"));
					
					resultCount = lmsMySurveyMapper.insertLmsSurveyOpinion(requestBox);
				}
			}
		}
		
		//3. 설문 수료 확인
		resultCount = lmsMySurveyMapper.updateLmsStudentFinish(requestBox);
		
		//4. 과정 step 수료 여부 확인하기 : courseid, stepseq, uid 필요함
		resultCount = lmsCommonMapper.updatetLmsStepFinish(requestBox);
		
		//5. 전체 수료 여부 확인하기 : courseid, uid 필요함
		resultCount = lmsCommonMapper.updatetLmsTotalFinish(requestBox);
		
		//6. 정규과정 스탬프 발행 확인
		lmsCommonMapper.insertLmsRegularStamp(requestBox);
		
		return resultCount;
	}
	
}
