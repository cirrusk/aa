package amway.com.academy.reservation.expBrand.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 체험예약_브랜드 체험
 * @author KR620225
 *
 */
public interface ExpBrandService {

	/**
	 * 다음달에 휴무일을 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchExpHealthHoliDayList(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 날짜의 얘약 가능한 프로그램 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, List<Map<String, String>>> searchBrandProgramList(RequestBox requestBox) throws Exception;
	
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
	 * 날짜 먼저 선택_예액정보 확인 팝업 호출
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expBrandRsvRequestPop(RequestBox requestBox) throws Exception;
	
	/**
	 * 날짜 먼저 선택페이지_선택한 프로그램 등록(예약정보 확인 팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expBrandCalendarInsertAjax(RequestBox requestBox) throws Exception;
	
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
	 * 프로그램 먼저 선택 페이지_예약 가능 세션 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchRsvProgramAbleSessionList(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 먼저선텍_선택한 프로그램 & 날짜에 해당 되는 세션 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchProgramSessionList(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 먼저 선택페이지_데이터 가공 [예약정보 확인 팝업]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expBrandProgramRsvRequestPop(RequestBox requestBox) throws Exception;
	
	/**
	 * 프로그램 먼저 선택페이지_예약 정보 등록(예약정보 확인 팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expBrandProgramInsertAjax(RequestBox requestBox) throws Exception;
	
	public Map<String, String > searchBrandPpInfo(RequestBox requestBox) throws Exception; 
	
	/**
	 * 사진 키값 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> brandProgramKeyList(RequestBox requestBox) throws Exception;
	
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
	
	public List<Map<String, String>> expBrandCalendarIndividualDuplicateCheck(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> expBrandCalendarGroupDuplicateCheck(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> expBrandCalendarDisablePop(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expBrandStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
}
