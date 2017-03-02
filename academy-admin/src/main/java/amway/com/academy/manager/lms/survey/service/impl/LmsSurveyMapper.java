package amway.com.academy.manager.lms.survey.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsSurveyMapper {

	List<DataBox> selectLmsSurveyList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsSurveyDetailList(RequestBox requestBox) throws Exception;
	List<DataBox> selectLmsSurveySampleList(RequestBox requestBox) throws Exception;
	
	List<Map<String, String>> selectLmsSurveyExcelList(RequestBox requestBox) throws Exception;
	public DataBox selectLmsSurveyDetail(RequestBox requestBox) throws Exception;
	
	public int selectLmsSurveyCount(RequestBox requestBox) throws Exception;
	public int selectLmsSurveyResponseCount(RequestBox requestBox) throws Exception;
	
	public int deleteLmsSurveyAjax(RequestBox requestBox) throws Exception;
	public int insertLmsSurvey(RequestBox requestBox) throws Exception;
	public int insertLmsSurveySample(RequestBox requestBox) throws Exception;
	public int deleteLmsSurveySample(RequestBox requestBox) throws Exception;
	public int deleteLmsSurvey(RequestBox requestBox) throws Exception;
	
	public int copyLmsSurveyCourseAjax(RequestBox requestBox) throws Exception;
	public int copyLmsSurveyAjax(RequestBox requestBox) throws Exception;
	public int copyLmsSurveySampleAjax(RequestBox requestBox) throws Exception;
}