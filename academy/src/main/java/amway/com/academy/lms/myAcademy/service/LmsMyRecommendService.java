package amway.com.academy.lms.myAcademy.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMyRecommendService {
	
	public int selectLmsRecommendCount(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsRecommendList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsRecommendCategoryList(RequestBox requestBox) throws Exception;
	
	public String selectLmsTargetCodeName(RequestBox requestBox) throws Exception;
	
	public int insertLmsSubscribe(RequestBox requestBox) throws Exception;
	public int deleteLmsSubscribe(RequestBox requestBox) throws Exception;
	
}
