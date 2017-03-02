package amway.com.academy.manager.lms.survey.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.lib.DataBox;

public interface LmsSurveyService {

	public List<DataBox> selectLmsSurveyList(RequestBox requestBox) throws Exception;
	
	public List<DataBox> selectLmsSurveyDetailList(RequestBox requestBox) throws Exception;
	public List<DataBox> selectLmsSurveySampleList(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> selectLmsSurveyExcelList(RequestBox requestBox) throws Exception;
	public DataBox selectLmsSurveyDetail(RequestBox requestBox) throws Exception;
	
	public int selectLmsSurveyCount(RequestBox requestBox) throws Exception;
	public int deleteLmsSurveyAjax(RequestBox requestBox) throws Exception;
	public int copyLmsSurveyAjax(RequestBox requestBox) throws Exception;
	
	public int insertLmsSurveyAjax(RequestBox requestBox, List<Map<String,Object>> list) throws Exception;
	public int updateLmsSurveyAjax(RequestBox requestBox, List<Map<String,Object>> list) throws Exception;
	
	public int selectLmsSurveyResponseCount(RequestBox requestBox) throws Exception;
}
