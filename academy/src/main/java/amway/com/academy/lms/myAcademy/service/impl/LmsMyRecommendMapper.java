package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMyRecommendMapper {

	public int selectLmsRecommendCount(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsRecommendList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectLmsRecommendCategoryList(RequestBox requestBox) throws Exception;
	
	public String selectLmsTargetCodeName(RequestBox requestBox) throws Exception;
	
	public int deleteLmsSubscribe(RequestBox requestBox) throws Exception;
	public int insertLmsSubscribe(RequestBox requestBox) throws Exception;
	public int deleteLmsSubscribeAll(RequestBox requestBox) throws Exception;
}
