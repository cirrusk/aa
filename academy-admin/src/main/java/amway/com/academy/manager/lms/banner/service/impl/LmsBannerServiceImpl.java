package amway.com.academy.manager.lms.banner.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.banner.service.LmsBannerService;
import amway.com.academy.manager.lms.common.LmsUtil;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsBannerServiceImpl implements LmsBannerService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsBannerServiceImpl.class);
	
	@Autowired
	private LmsBannerMapper lmsBannerMapper;

	
	// 배너 목록 카운트
	@Override
	public int selectLmsBannerCount(RequestBox requestBox) throws Exception {
		return lmsBannerMapper.selectLmsBannerCount(requestBox);
	}
	
	// 배너 목록 
	@Override
	public List<DataBox> selectLmsBannerList(RequestBox requestBox) throws Exception {
		return lmsBannerMapper.selectLmsBannerList(requestBox);
	}	
	
	// 배너 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsBannerListExcelDown(RequestBox requestBox) throws Exception {
		return lmsBannerMapper.selectLmsBannerListExcelDown(requestBox);
	}
	
	// 배너 삭제
	@Override
	public int deleteLmsBanner(RequestBox requestBox) throws Exception {
		int count = lmsBannerMapper.deleteLmsBanner(requestBox);
	
		return count;
	}
	
	// 배너 순서 업데이트
	@Override
	public int updateLmsBannerOrder(RequestBox requestBox) throws Exception {
		int count =  0 ;
		Vector bannerids = requestBox.getVector("bannerids");
		Vector bannerorders = requestBox.getVector("bannerorders");
		Vector beforebannerorders = requestBox.getVector("beforebannerorders");
		for(int i = 0; i < bannerids.size(); i++){
			String bannerid = (String) bannerids.get(i);
			String bannerorder = (String) bannerorders.get(i);
			String beforebannerorder = (String) beforebannerorders.get(i);
			if(!bannerorder.equals(beforebannerorder)){
				requestBox.put("bannerid",bannerid);
				requestBox.put("bannerorder",bannerorder);
				count = lmsBannerMapper.updateLmsBannerOrder(requestBox);	
			}
		}
		return count;
	}
	
	// 배너 상세
	@Override
	public DataBox selectLmsBanner(RequestBox requestBox) throws Exception {
		return lmsBannerMapper.selectLmsBanner(requestBox);
	}

	// 배너 등록
	@Override
	public int insertLmsBanner(RequestBox requestBox) throws Exception {
		// 과정 기본 정보 등록
		int bannerCnt = lmsBannerMapper.insertLmsBanner(requestBox);
		requestBox.put("bannerid", requestBox.get("maxbannerid"));
		//대상자 정보 ArrayList로 만들기

		int conditionCnt = 0;
		ArrayList<Map<String,String>> conditionList = LmsUtil.getLmsCourseConditionList(requestBox);
		for( int i=0; i<conditionList.size(); i++ ) {
			Map<String,String> retMap = conditionList.get(i);
			requestBox.putAll(retMap);
			conditionCnt = lmsBannerMapper.insertLmsBannerCondition(requestBox);
		}
		
		//배너 노출일을 노출권한의 min, max 값으로 세팅할 것
		int onlineUpdateCnt = lmsBannerMapper.updateLmsBannerDate(requestBox);
				
		
		return bannerCnt;
	}
	
	// 배너 수정
	@Override
	public int updateLmsBanner(RequestBox requestBox) throws Exception {
		// 배너 정보 수정
		int bannerCnt = lmsBannerMapper.updateLmsBanner(requestBox);
	
		
		//대상자 정보 삭제 후 대상자 정보 ArrayList로 만들어서 등록하기
		int courseConditionDeleteCnt = lmsBannerMapper.deleteLmsBannerCondition(requestBox);
		
		int conditionCnt = 0;
		ArrayList<Map<String,String>> conditionList = LmsUtil.getLmsCourseConditionList(requestBox);
		for( int i=0; i<conditionList.size(); i++ ) {
			Map<String,String> retMap = conditionList.get(i);

			requestBox.putAll(retMap);
			conditionCnt = lmsBannerMapper.insertLmsBannerCondition(requestBox);
		}
		
		//배너 노출일을 노출권한의 min, max 값으로 세팅할 것
		int bannerUpdateCnt = lmsBannerMapper.updateLmsBannerDate(requestBox);
			
		
		return bannerCnt;
	}
	
	@Override
	public List<DataBox> selectLmsBannerConditionList(RequestBox requestBox) throws Exception {
		return lmsBannerMapper.selectLmsBannerConditionList(requestBox);
	}

}
