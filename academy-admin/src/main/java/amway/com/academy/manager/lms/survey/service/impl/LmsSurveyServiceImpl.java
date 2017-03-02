package amway.com.academy.manager.lms.survey.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.lms.survey.service.LmsSurveyService;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;

@Service
public class LmsSurveyServiceImpl implements LmsSurveyService {

	@Autowired
	private LmsSurveyMapper lmsSurveyMapper;

	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Override
	public List<DataBox> selectLmsSurveyList(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyList(requestBox);
	}
	
	@Override
	public List<DataBox> selectLmsSurveyDetailList(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyDetailList(requestBox);
	}
	
	@Override
	public List<DataBox> selectLmsSurveySampleList(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveySampleList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectLmsSurveyExcelList(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyExcelList(requestBox);
	}
	
	@Override
	public DataBox selectLmsSurveyDetail(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyDetail(requestBox);
	}
	
	@Override
	public int selectLmsSurveyCount(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyCount(requestBox);
	}
	
	@Override
	public int deleteLmsSurveyAjax(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.deleteLmsSurveyAjax(requestBox);
	}
	
	@Override
	public int selectLmsSurveyResponseCount(RequestBox requestBox) throws Exception {
		return lmsSurveyMapper.selectLmsSurveyResponseCount(requestBox);
	}
	
	@Override
	public int copyLmsSurveyAjax(RequestBox requestBox) throws Exception {
		
		int totalCount = 0;
		
		//복사할 대상 일기
		String[] courseids = requestBox.getString("courseids").split("[,]");
		for(int i=0; i<courseids.length; i++) {
			//1. 설문지 복사
			requestBox.put("courseid", courseids[i]);
			
			lmsSurveyMapper.copyLmsSurveyCourseAjax(requestBox);
			requestBox.put("maxcourseid", requestBox.get("maxcourseid"));
			
			//2. 설문문항 복사
			lmsSurveyMapper.copyLmsSurveyAjax(requestBox);
			
			//3. 설문보기 복사
			lmsSurveyMapper.copyLmsSurveySampleAjax(requestBox);
			
			totalCount ++;
		}
		
		return totalCount;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public int insertLmsSurveyAjax(RequestBox requestBox, List<Map<String,Object>> surveyList) throws Exception {
		
		//1. insert lmsCourse
		requestBox.put("coursetype", "V");
		requestBox.put("requeststartdate", requestBox.get("startdate"));
		requestBox.put("requestenddate", requestBox.get("enddate"));
		
		int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
		requestBox.put("courseid", requestBox.get("maxcourseid"));

		//2. insert lmsSurvey : loop
		//3. insert lmsSurveySample : loop
		int surveyCount = 0;
		int resultCount = 0;
		for(int i=0; i<surveyList.size(); i++ ) {
			Map<String,Object> retMap = surveyList.get(i);
			
			requestBox.put("surveyseq", retMap.get("surveyseq").toString());
			requestBox.put("surveyname", retMap.get("surveyname").toString());
			requestBox.put("surveytype", retMap.get("surveytype").toString());

			surveyCount = lmsSurveyMapper.insertLmsSurvey(requestBox);
			resultCount ++;
			String str1 = "1";
			String str2 = "2";
			if( str1.equals(retMap.get("surveytype").toString()) || str2.equals(retMap.get("surveytype").toString()) ) {
				ArrayList<Map<String,String>> sampleList = (ArrayList<Map<String,String>>)retMap.get("sampleList");
				for(int k=0; k<sampleList.size(); k++) {
					Map<String,String> ret2Map = (Map<String,String>)sampleList.get(k); 
					
					requestBox.put("sampleseq", (k+1)+"");
					requestBox.put("samplename", ret2Map.get("samplename").toString());
					requestBox.put("samplevalue", ret2Map.get("samplevalue").toString());
					requestBox.put("directyn", ret2Map.get("directyn").toString());
					
					surveyCount = lmsSurveyMapper.insertLmsSurveySample(requestBox);
					
					resultCount ++;
				}
			}
		}
		
		return courseCnt + resultCount + surveyCount;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public int updateLmsSurveyAjax(RequestBox requestBox, List<Map<String,Object>> surveyList) throws Exception {
		
		//1. insert lmsCourse
		requestBox.put("coursetype", "V");
		requestBox.put("requeststartdate", requestBox.get("startdate"));
		requestBox.put("requestenddate", requestBox.get("enddate"));
		
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		
		int resultCount = 0;
		int surveyCount = 0;
		
		//2. delete lmsSurveySample
		surveyCount = lmsSurveyMapper.deleteLmsSurveySample(requestBox);
		
		//3. delete lmsSurvey
		surveyCount = lmsSurveyMapper.deleteLmsSurvey(requestBox);
		
		//4. insert lmsSurvey : loop
		//5. insert lmsSurveySample : loop
		for(int i=0; i<surveyList.size(); i++ ) {
			Map<String,Object> retMap = surveyList.get(i);
			
			requestBox.put("surveyseq", retMap.get("surveyseq").toString());
			requestBox.put("surveyname", retMap.get("surveyname").toString());
			requestBox.put("surveytype", retMap.get("surveytype").toString());
			
			surveyCount = lmsSurveyMapper.insertLmsSurvey(requestBox);
			resultCount ++;
			String str1 = "1";
			String str2 = "2";
			if( str1.equals(retMap.get("surveytype").toString()) || str2.equals(retMap.get("surveytype").toString()) ) {
				ArrayList<Map<String,String>> sampleList = (ArrayList<Map<String,String>>)retMap.get("sampleList");
				for(int k=0; k<sampleList.size(); k++) {
					Map<String,String> ret2Map = (Map<String,String>)sampleList.get(k); 
					
					requestBox.put("sampleseq", (k+1)+"");
					requestBox.put("samplename", ret2Map.get("samplename").toString());
					requestBox.put("samplevalue", ret2Map.get("samplevalue").toString());
					requestBox.put("directyn", ret2Map.get("directyn").toString());
					
					surveyCount = lmsSurveyMapper.insertLmsSurveySample(requestBox);
					
					resultCount ++;
				}
			}
		}
		
		return courseCnt + resultCount + surveyCount;
	}
	
}
