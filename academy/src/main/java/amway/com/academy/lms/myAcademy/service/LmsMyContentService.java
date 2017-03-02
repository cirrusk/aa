package amway.com.academy.lms.myAcademy.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMyContentService {
	
	public int selectLmsSaveLogCount(RequestBox requestBox) throws Exception;
	public List<Map<String, Object>> selectLmsSaveLogList(RequestBox requestBox) throws Exception;
	
	public int deleteLmsSaveLog(RequestBox requestBox) throws Exception;
	
}
