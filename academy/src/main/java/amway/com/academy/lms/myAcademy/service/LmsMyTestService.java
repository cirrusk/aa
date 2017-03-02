package amway.com.academy.lms.myAcademy.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMyTestService {
	
	public Map<String, Object> selectLmsTest(RequestBox requestBox) throws Exception;
	
	public int insertLmsTestAnswer(RequestBox requestBox) throws Exception;
	
	public List<Map<String, Object>> selectLmsTestAnswerList(RequestBox requestBox) throws Exception;
	
	public int updateLmsMyTestInit(RequestBox requestBox) throws Exception;
	
	public int selectLmsTestLimitTime(RequestBox requestBox) throws Exception;
	
	public int updateLmsTestAnswer(RequestBox requestBox) throws Exception;
	
	public int submitLmsTestAnswer(RequestBox requestBox) throws Exception;
	
}
