package amway.com.academy.lms.myAcademy.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMySurveyService {
	
	public Map<String, Object> selectLmsSurvey(RequestBox requestBox) throws Exception;
	
	public List<Map<String, Object>> selectLmsSurveySampleList(RequestBox requestBox) throws Exception;
	
	public int submitLmsSurvey(RequestBox requestBox, List<Map<String,Object>> reponseList) throws Exception;
	
}
