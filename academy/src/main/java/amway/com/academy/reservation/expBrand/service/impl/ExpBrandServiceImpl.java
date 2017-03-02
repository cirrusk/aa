package amway.com.academy.reservation.expBrand.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import amway.com.academy.reservation.basicPackage.service.impl.BasicReservationMapper;
import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.basicPackage.service.impl.ReservationCheckerServiceImpl;
import amway.com.academy.reservation.expBrand.service.ExpBrandService;

@Service
public class ExpBrandServiceImpl extends CommonReservationService implements ExpBrandService{
	@Autowired
	private BasicReservationMapper basicReservationDAO; 
	
	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;
	
	@Autowired
	private ExpBrandMapper expBrandDAO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationCheckerServiceImpl.class);
	
	@Override
	public List<Map<String, String>> searchExpHealthHoliDayList(RequestBox requestBox) throws Exception {
		
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return basicReservationDAO.searchExpHoliDay(requestBox);
		
	}

	/**
	 * searchCategoryTypeList -> 체험 정보 마스터 테이블에서 등록된 브랜드 체험의  카테고리값 조회
	 * Map<String, List<Map<String, String>>> list ->얻어온 브랜드 체험의 카테고리 값으로 카테고리 별로 리스트를 조회하여 map에 담는다  
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, List<Map<String, String>>> searchBrandProgramList(RequestBox requestBox) throws Exception {
		
		int cnt = 0;
//		int realCnt = 0;
		
		/** 체험정보 마스터 테이블에 등록된 브랜드 체험 키값 조회 */
		List<Map<String, String>> searchCategoryTypeList = expBrandDAO.searchCategoryTypeList(requestBox);
		
		/** 브랜드 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		List<Map<String, String>> map;
		Map<String, List<Map<String, String>>> list = new HashMap<String, List<Map<String,String>>>();
		
		for(int i = 0; i < searchCategoryTypeList.size(); i++){
			
			map = new ArrayList<Map<String,String>>();
			
			requestBox.put("categorytype2", searchCategoryTypeList.get(i).get("categorytype2"));
			requestBox.put("categorytype3", searchCategoryTypeList.get(i).get("categorytype3"));
			
			map = expBrandDAO.searchBrandProgramList(requestBox);
//			if(map.size() != 0){
			if(!map.isEmpty()){
				list.put(String.valueOf(cnt), map);
				cnt++;
			}
			
		}
		
		return list;
	}

	/**
	 * 카테고리 2 리스트 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchBrandCategoryType2(RequestBox requestBox) throws Exception {
		return expBrandDAO.searchBrandCategoryType2(requestBox);
	}

	/**
	 * 해당 카테고리 1, 2에 해당되는 카테고리 3조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchBrandCategoryType3(RequestBox requestBox) throws Exception {
		return expBrandDAO.searchBrandCategoryType3(requestBox);
	}

	/**
	 * 프로그램 상세 정보(브랜드 체험 소개 팝업 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> searchBrandProductDetail(RequestBox requestBox) throws Exception {
		
		Map<String, String> map;
		
		if("E0304".equals(requestBox.get("categorytype2"))){
			
			map = expBrandDAO.searchBrandJointProductDetail(requestBox);
			
		}else{
			map = expBrandDAO.searchBrandProductDetail(requestBox);
		}
		
		
		return map;
	}

	/**
	 * 날짜 먼저 선택_예액정보 확인 팝업 호출
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> expBrandRsvRequestPop(RequestBox requestBox) throws Exception {
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		/** 브랜드 typeseq 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 브랜드 키값 셋팅  */
		
		for(int i = 0; i < requestBox.getVector("expsessionseq").size(); i++){
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("typeseq", String.valueOf(searchRsvTypeSeq.get("typeseq")));
			map.put("expseq", (String) requestBox.getVector("expseq").get(i));
			map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
			map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
			map.put("getYear", (String) requestBox.getVector("getYear").get(i));
			map.put("getMonth", (String) requestBox.getVector("getMonth").get(i));
			map.put("getDay", (String) requestBox.getVector("getDay").get(i));
			map.put("accountType", (String) requestBox.getVector("accountType").get(i));
			map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
			map.put("weekDay", (String) requestBox.getVector("weekDay").get(i));
			map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
			map.put("productName", (String) requestBox.getVector("productName").get(i));
			map.put("preparation", (String) requestBox.getVector("preparation").get(i));
			map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
					
			list.add(map);
		}
		
		return list;
	}

	/**
	 * 날짜 먼저 선택페이지_선택한 프로그램 등록(예약정보 확인 팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> expBrandCalendarInsertAjax(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke expBrandCalendarInsertAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		String transactionTime = String.valueOf(ts.getTime());
		requestBox.put("transactionTime", transactionTime);
		
		LOGGER.debug("transactionTime", transactionTime);
		
		for(int i = 0; i < requestBox.getVector("ppSeq").size(); i++){
			HashMap<String, String> map = new HashMap<String, String>();
			
			requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			
			/** 예약 전 예약 대기자 조회 */
			Map<String, String> expReservation = basicReservationDAO.searchExpReservation(requestBox);
			
			if(Integer.parseInt(String.valueOf(expReservation.get("standbynumber"))) < 1){
				map.put("transactionTime", transactionTime);
				map.put("account", (String) requestBox.getVector("account").get(0));
				
				map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
				map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
				map.put("expseq", (String) requestBox.getVector("expseq").get(i));
				map.put("typeSeq", (String) requestBox.getVector("typeseq").get(i));
				map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
				map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
				map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
				
				/** 타입 코드가 개인일경우에만 파트너 타입 코드 셋팅 */
				if("A01".equals(requestBox.getVector("accountType").get(i))){
					map.put("partnerTypeCode", (String) requestBox.getVector("partnerTypeCode").get(i));
				}
				map.put("accountType", (String) requestBox.getVector("accountType").get(i));
				map.put("productName", (String) requestBox.getVector("productName").get(i));
				map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
				map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
				
				String standByNumber = "";
				
				if("A01".equals(requestBox.getVector("accountType").get(i))){
					/* 브랜드 체험 개인 예약 시 프로그램 남은 정원 조회 하여 
					 * 1. 대기자가 없고 예약하려는 인원수가 남은 정원수보다 작거나 같을때 0
					 * 2. 대기자가 없고 예약하려는 인원수가 남은 정원수보다 클때 1
					 * param - reservationdate, expsessionseq,
					 * 조건으로 standbynumber을 세팅한다.
					 * */
					standByNumber = expBrandDAO.expBrandRsvPersonCheck(map);
					
					if(null == standByNumber){
						standByNumber = "0";
					}
					
					map.put("standbynumber", standByNumber);
					map.put("standByNumber", standByNumber);
				}else{
					if("200".equals((String) requestBox.getVector("rsvflag").get(i))){
						map.put("standbynumber", "1");
						map.put("standByNumber", "1");
						standByNumber = "1";
					}else{
						map.put("standbynumber", "0");
						map.put("standByNumber", "0");
						standByNumber = "0";
					}
				}
				map.put("msg", "true");
				
				/** 브랜드 체험 등록 */
				basicReservationDAO.expInsertAjax(map);
				
				/** 결제 이력정보 등록 */
//				basicReservationDAO.expPayMentInsert(map);
				
				list.add(map);
				
				/* 메세지 처리 */
				try {
					// 대기자가 아닐경우만 발송 함.
					String sessionDateTime = (String) requestBox.getVector("reservationDate").get(i) 
							+ (String) requestBox.getVector("startdatetime").get(i);
					
					sessionDateTime = DateUtil.getKoreanDateTime(sessionDateTime, "MDhm");
					
					map.put("ppName", basicReservationDAO.getPpNameByPpSeq(map.get("ppSeq")));
					map.put("sessionInfo", sessionDateTime );
					map.put("programName", (String) requestBox.getVector("productName").get(i) );
					
					/** send message - push */
					super.sendPushMessage(map, "expr", "reserv");
					
					/** send message - note */
					super.sendNoteMessage(map, "expr", "reserv");
					
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			}else{
				map.put("msg", "false");
				map.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));
				list.add(map);
			}
		}
		
		return list;
	}

	/**
	 * 일자 별로 예약 가능 여부 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchRsvAbleSessionList(RequestBox requestBox) throws Exception {
		return expBrandDAO.searchRsvAbleSessionList(requestBox);
	}

	/**
	 * 해당 카테고리 1,2 에 해당 하는 프로그램 타이틀 조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchBrandProductList(RequestBox requestBox) throws Exception {
		return expBrandDAO.searchBrandProductList(requestBox);
	}

	/**
	 * 일자 별로 예약 가능 여부 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchRsvProgramAbleSessionList(RequestBox requestBox) throws Exception {
		
		/** 브랜드 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 브랜드 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return expBrandDAO.searchRsvProgramAbleSessionList(requestBox);
	}

	/**
	 * 프로그램 먼저선텍_선택한 프로그램 & 날짜에 해당 되는 세션 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> searchProgramSessionList(RequestBox requestBox) throws Exception {
		
		Map<String, String> searchFirstSession = basicReservationDAO.searchFirstSession(requestBox);
		
		if(searchFirstSession != null){
			requestBox.put("settypecode", searchFirstSession.get("settypecode"));
			requestBox.put("worktypecode", searchFirstSession.get("worktypecode"));
		}else{
			requestBox.put("settypecode", "S01".toString());
			requestBox.put("worktypecode", "");
		}
		
		
		/** 브랜드 체험 pp정보 조회 */
		Map<String, String> searchBrandPpInfo = expBrandDAO.searchBrandPpInfo(requestBox);
		
		/** 브랜드 키값 셋팅  */
		requestBox.put("typeseq", searchBrandPpInfo.get("typeseq"));
		requestBox.remove("ppseq");
		requestBox.put("ppseq", searchBrandPpInfo.get("ppseq"));
		return expBrandDAO.searchProgramSessionList(requestBox);
	}

	/**
	 * 프로그램 먼저 선텍_예약정보 등록 팝업 호출
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> expBrandProgramRsvRequestPop(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		/** 브랜드 typeseq 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 브랜드 키값 셋팅  */
		
		for(int i = 0; i < requestBox.getVector("expseq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("account", (String) requestBox.getVector("account").get(0));
			
			map.put("typeseq", String.valueOf(searchRsvTypeSeq.get("typeseq")));
			map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
			map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			map.put("expseq", (String) requestBox.getVector("expseq").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
			map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
			map.put("setDateFormat", (String) requestBox.getVector("setDateFormat").get(i));
			map.put("korWeek", (String) requestBox.getVector("korWeek").get(i));
			map.put("accountType", (String) requestBox.getVector("accountType").get(i));
			map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
			map.put("productName", (String) requestBox.getVector("productName").get(i));
			map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
			map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
			
			list.add(map);
		}
		
		return list;
	}

	/**
	 * 프로그램 먼저 선택_예약정보 등록(예약정보 확인 팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> expBrandProgramInsertAjax(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke expBrandProgramInsertAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		String transactionTime = String.valueOf(ts.getTime());
		requestBox.put("transactionTime", transactionTime);

        LOGGER.debug("transactionTime {}", transactionTime);

		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("expsessionseq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			
			/** 예약 전 예약 대기자 조회 */
			Map<String, String> expReservation = basicReservationDAO.searchExpReservation(requestBox);
			
			if(Integer.parseInt(String.valueOf(expReservation.get("standbynumber"))) <= 1){
				map.put("transactionTime", transactionTime);
				map.put("account", (String) requestBox.getVector("account").get(0));
				map.put("typeSeq", (String) requestBox.getVector("typeseq").get(i));
				
				map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
				map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
				map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
				map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
				map.put("expseq", (String) requestBox.getVector("expseq").get(i));
				map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
				map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
				map.put("accountType", (String) requestBox.getVector("accountType").get(i));
				
				/** 타입 코드가 개인일경우에만 파트너 타입 코드 셋팅 */
				if("A01".equals(requestBox.getVector("accountType").get(i))){
					
					map.put("partnerTypeCode", (String) requestBox.getVector("partnerTypeCode").get(i));
				}
							
				
				map.put("setDateFormat", (String) requestBox.getVector("setDateFormat").get(i));
				map.put("korWeek", (String) requestBox.getVector("korWeek").get(i));
				map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
				
				if("A01".equals(requestBox.getVector("accountType").get(i))){
					/* 브랜드 체험 개인 예약 시 프로그램 남은 정원 조회 하여 
					 * 1. 대기자가 없고 예약하려는 인원수가 남은 정원수보다 작거나 같을때 0
					 * 2. 대기자가 없고 예약하려는 인원수가 남은 정원수보다 클때 1
					 * param - reservationdate, expsessionseq,
					 * 조건으로 standbynumber을 세팅한다.
					 * */
					String standByNumber = expBrandDAO.expBrandRsvPersonCheck(map);
					if(null == standByNumber){
						standByNumber = "0";
					}
					map.put("standbynumber", standByNumber);
				}else{
					if("200".equals((String) requestBox.getVector("rsvflag").get(i))){
						map.put("standbynumber", "1");
					}else{
						map.put("standbynumber", "0");
					}
				}
				map.put("msg", "true");
				
				
				/** 브랜드 체험 등록 */
				basicReservationDAO.expInsertAjax(map);
				
				/** 결제 이력정보 등록 */
//				basicReservationDAO.expPayMentInsert(map);
				
				list.add(map);
				
				
				try {
					
					Map<String, String> messageMap = new HashMap<String, String>();
					messageMap = basicReservationDAO.getSendMessageExpForBrandProgram(map);
					
					String sessionDateTime = (String) requestBox.getVector("reservationDate").get(i) 
							+ (String) requestBox.getVector("startdatetime").get(i);
					
					sessionDateTime = DateUtil.getKoreanDateTime(sessionDateTime, "MDhm");
					
					messageMap.put("account", map.get("account"));
					messageMap.put("ppName", basicReservationDAO.getPpNameByPpSeq( (String) map.get("ppSeq")));
					messageMap.put("sessionInfo", sessionDateTime );
					messageMap.put("reservationDate", (String) map.get("reservationDate") );
					/** send message - push */
					super.sendPushMessage(messageMap, "expr", "reserv");
					
					/** send message - note */
					super.sendNoteMessage(messageMap, "expr", "reserv");
					
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			}else{
				map.put("msg", "false");
				map.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));
				list.add(map);
			}
			
		}
		
		return list;
	}

	@Override
	public Map<String, String> searchBrandPpInfo(RequestBox requestBox) throws Exception {
		return expBrandDAO.searchBrandPpInfo(requestBox);
	}

	@Override
	public List<Map<String, String>> brandProgramKeyList(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("categorytype3Array").size(); i++){
			
			requestBox.put("categorytype3", (String) requestBox.getVector("categorytype3Array").get(i));
			
			Map<String,String> map = expBrandDAO.searchExpBrandProgramKey(requestBox);
			
			list.add(map);
		}
		
		
		return list;
	}

	@Override
	public List<Map<String, String>> brandNextYearMonth(RequestBox requestBox) throws Exception {
		
		return expBrandDAO.brandNextYearMonth(requestBox);
	}

	@Override
	public List<Map<String, String>> searchBrandCalenderHoliDay(RequestBox requestBox) throws Exception {
		
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "브랜드");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return expBrandDAO.searchBrandCalenderHoliDay(requestBox);
	}

	@Override
	public List<Map<String, String>> brandCalenderNextYearMonth(RequestBox requestBox) throws Exception {
		
//		/** 체성분 키 값 가져오기 */
//		requestBox.put("rsvTypeName", "브랜드");
//		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
//		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		requestBox.put("ppseq", expBrandDAO.searchBrandPpInfo(requestBox).get("ppseq"));
		requestBox.put("typeseq", expBrandDAO.searchBrandPpInfo(requestBox).get("typeseq"));
		
		return expBrandDAO.brandCalenderNextYearMonth(requestBox);
	}
	
	@Override
	public List<Map<String, String>> expBrandCalendarIndividualDuplicateCheck(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpSessionSeq", requestBox.getVector("expsessionseq").get(i));
			
			if(("100").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "0");
			}else if(("200").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "1");
			}
			
			Map<String, String> map = basicReservationDAO.expDuplicateExceptCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expBrandCalendarGroupDuplicateCheck(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpSessionSeq", requestBox.getVector("expsessionseq").get(i));
			
			if(("100").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "0");
			}else if(("200").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "1");
			}
			
			Map<String, String> map = basicReservationDAO.expDuplicateCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expBrandCalendarDisablePop(RequestBox requestBox) throws Exception {
		
		/** 시설 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("expsessionseq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("ppName", (String) requestBox.getVector("ppname").get(i));
			map.put("programName", (String) requestBox.getVector("programname").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationdate").get(i));
			map.put("reservationWeek", (String) requestBox.getVector("reservationweek").get(i));
			map.put("expSessionSeq", (String) requestBox.getVector("expsessionseq").get(i));
			map.put("startDateTime", (String) requestBox.getVector("starttime").get(i));
			map.put("endDateTime", (String) requestBox.getVector("endtime").get(i));
			map.put("sessionName", (String) requestBox.getVector("sessionname").get(i));
			map.put("standByNumber", (String) requestBox.getVector("standbynumber").get(i));
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public Map<String, String> expBrandStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception {
		Map<String, String> expStandByNumber = new HashMap<String, String>();
		
		for(int i = 0; i < requestBox.getVector("expsessionseq").size(); i++){
			requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			requestBox.put("tempRsvflag", (String) requestBox.getVector("rsvflag").get(i));
		
			//해당일, 해당 세션시간, 대기자 여부에 따른 대기자 조회
			expStandByNumber =  basicReservationDAO.expStandByNumberAdvanceChecked(requestBox);
			
			//먼저 선점 한 사람이 있다면  return false
			if("false".equals(expStandByNumber.get("standbynumber"))){
				expStandByNumber.put("msg", "false");
				expStandByNumber.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));//예약 불가 메세지
				
				return expStandByNumber;
			}else{
				expStandByNumber.put("msg", "true");
			}
		}
		
		return expStandByNumber;
		
	}
}
