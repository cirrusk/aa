package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMySurveyMapper {

	public Map<String, Object> selectLmsSurvey(RequestBox requestBox) throws Exception;
	
	public List<Map<String, Object>> selectLmsSurveyList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsSurveySampleList(RequestBox requestBox) throws Exception;
	
	public int insertLmsSurveyResponse(RequestBox requestBox) throws Exception;
	public int insertLmsSurveyOpinion(RequestBox requestBox) throws Exception;
	public int updateLmsStudentFinish(RequestBox requestBox) throws Exception;
	
}
