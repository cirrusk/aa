package amway.com.academy.manager.lms.banner.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsBannerService {

	// 배너 목록 카운트
	public int selectLmsBannerCount(RequestBox requestBox) throws Exception;
	
	// 배너 목록
	public List<DataBox> selectLmsBannerList(RequestBox requestBox) throws Exception;
	
	//배너 Excel  다운로드
	public List<Map<String, String>> selectLmsBannerListExcelDown(RequestBox requestBox) throws Exception;

	// 배너 삭제
	public int deleteLmsBanner(RequestBox requestBox) throws Exception;
	
	// 배너 순서 업데이트
	public int updateLmsBannerOrder(RequestBox requestBox) throws Exception;
	
	// 배너 상세
	public DataBox selectLmsBanner(RequestBox requestBox) throws Exception;
	
	//배너 등록
	public int insertLmsBanner(RequestBox requestBox) throws Exception;
	
	// 배너 수정
	public int updateLmsBanner(RequestBox requestBox) throws Exception;

	
	public List<DataBox> selectLmsBannerConditionList(RequestBox requestBox) throws Exception;

}
