package amway.com.academy.reservation.expBrand.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpBrandMapper {

	/**
	 * 체험 정보 마스터 테이블에서 등록된 브랜드 체험의  카테고리값 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchCategoryTypeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 날짜의 얘약 가능한 프로그램 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchBrandProgramList(RequestBox requestBox) throws Exception;
	
	/**
	 * 카테고리 2 리스트 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchBrandCategoryType2(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 카테고리 1, 2에 해당되는 카테고리 3조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchBrandCategoryType3(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 상세 정보(브랜드 체험 소개 팝업 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchBrandProductDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 일자 별로 예약 가능 여부 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchRsvAbleSessionList(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 카테고리 1,2 에 해당 하는 프로그램 타이틀 조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchBrandProductList(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 먼저 선택 페이지_예약가능일 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchRsvProgramAbleSessionList(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 먼저 선택 페이지_해당일의 예약 가능 세션 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchProgramSessionList(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchBrandPpInfo(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchExpBrandProgramKey(RequestBox requestBox)throws Exception;
	
	public Map<String, String> searchBrandJointProductDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 다음 월에 대한 년, 월 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> brandNextYearMonth(RequestBox requestBox) throws Exception;
	
	/**
	 * 다음 월에 대한 년, 월 조회(캘린더)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> brandCalenderNextYearMonth(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> searchBrandCalenderHoliDay(RequestBox requestBox) throws Exception;

	/**
	 * 브랜드체험 개인 예약 형태 체크
	 * @param map
	 * @return
	 */
	public String expBrandRsvPersonCheck(HashMap<String, String> map) throws Exception;
}
