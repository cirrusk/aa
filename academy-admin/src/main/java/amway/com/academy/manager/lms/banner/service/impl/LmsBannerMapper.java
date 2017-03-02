package amway.com.academy.manager.lms.banner.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsBannerMapper {

	/**
	 * 배너 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsBannerCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsBannerList(RequestBox requestBox) throws Exception;

	/**
	 * 배너 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsBannerListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsBanner(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 순서 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsBannerOrder(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsBanner(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsBanner(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsBanner(RequestBox requestBox) throws Exception;
	
	/**
	 * 배너 공개일자 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsBannerDate(RequestBox requestBox) throws Exception;
	
	
	int insertLmsBannerCondition(RequestBox requestBox) throws Exception;
	
	int deleteLmsBannerCondition(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsBannerConditionList(RequestBox requestBox) throws Exception;


}