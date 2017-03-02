package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.myAcademy.service.LmsMyRecommendService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMyRecommendServiceImpl  implements LmsMyRecommendService{
	@Autowired
	private LmsMyRecommendMapper lmsMyRecommendMapper;
	
	@Override
	public int selectLmsRecommendCount(RequestBox requestBox) throws Exception {
		return lmsMyRecommendMapper.selectLmsRecommendCount(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectLmsRecommendList(RequestBox requestBox) throws Exception {
		return lmsMyRecommendMapper.selectLmsRecommendList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectLmsRecommendCategoryList(RequestBox requestBox) throws Exception {
		return lmsMyRecommendMapper.selectLmsRecommendCategoryList(requestBox);
	}
	
	@Override
	public String selectLmsTargetCodeName(RequestBox requestBox) throws Exception {
		return lmsMyRecommendMapper.selectLmsTargetCodeName(requestBox);
	}
	
	@Override
	public int insertLmsSubscribe(RequestBox requestBox) throws Exception {
		
		//1. 전체 구독신청 카테고리 삭제하기
		String[] categoryids = requestBox.getString("categoryids").split("[,]");
		requestBox.put("categoryids", categoryids);
		int deleteCnt = lmsMyRecommendMapper.deleteLmsSubscribe(requestBox);
		
		int insertCnt = 0;
		for( int i=0; i<categoryids.length; i++ ) {
			requestBox.put("categoryid", categoryids[i]);
			lmsMyRecommendMapper.insertLmsSubscribe(requestBox);
			
			insertCnt++;
		}
		
		return deleteCnt + insertCnt;
	}
	
	@Override
	public int deleteLmsSubscribe(RequestBox requestBox) throws Exception {
		
		//1. 전체 구독신청 카테고리 삭제하기
		int deleteCnt = lmsMyRecommendMapper.deleteLmsSubscribeAll(requestBox);
		
		return deleteCnt;
	}
}
