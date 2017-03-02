package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMyTestMapper {

	public Map<String, Object> selectLmsTest(RequestBox requestBox) throws Exception;
	public int insertLmsTestAnswer(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsTestSubmitTestPoolList(RequestBox requestBox) throws Exception;
	
	public List<Map<String, Object>> selectLmsTestAnswerList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsTestAnswerSampleList(RequestBox requestBox) throws Exception;
	
	public int updateLmsMyTestInit(RequestBox requestBox) throws Exception;
	public int selectLmsTestLimitTime(RequestBox requestBox) throws Exception;
	public int updateLmsTestAnswer(RequestBox requestBox) throws Exception;
	
	public int updateLmsTestAnswerPoint(RequestBox requestBox) throws Exception;
	public int updateLmsStudentPoint(RequestBox requestBox) throws Exception;
	public int updateLmsStudentFinish(RequestBox requestBox) throws Exception;
	public int updateLmsStudentFinish2(RequestBox requestBox) throws Exception;
	
	public String selectLmsTestStudent(RequestBox requestBox) throws Exception;
	
}
