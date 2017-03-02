package amway.com.academy.reservation.basicPackage.web;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;

import amway.com.academy.common.util.CheckSSO;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.common.util.XmlTemplete;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.service.ReservationCheckerService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.StringUtil;

/**
 * <pre>
 * 	예약 모듈 공통으로 사용되는 Class
 * </pre>
 * Program Name  : BasicReservationController.java
 * Author : KR620207
 * Creation Date : 2016. 8. 11.
 */
public class BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicReservationController.class);

	/* default setting information */
	@Autowired
	protected BasicReservationService basicReservationService;
	
	@Autowired
	protected ReservationCheckerService reservationCheckerService;
	
	// adobe analytics
	@Autowired
	protected CommomCodeUtil commonCodeUtil;

	protected static final String COLUMN_NAME_ACCOUNT = "account";
	protected static final String COLUMN_NAME_RESERVATIONDATE = "reservationdate";
	protected static final String COLUMN_NAME_RSVTYPECODE = "rsvtypecode";
	protected static final String COLUMN_NAME_TYPESEQ = "typeseq";
	protected static final String COLUMN_NAME_EXPSEQ = "expseq";
	protected static final String COLUMN_NAME_ROOMSEQ = "roomseq";
	protected static final String COLUMN_NAME_PPSEQ = "ppseq";
	protected static final String COLUMN_NAME_SESSIONSEQ = "sessionseq";
	
	private int etcNumber = 180;
	
	/**
	 * <pre>
	 * 회원번호를 13자리로 맞추기 위한 기능
	 * 	7480002 -> 00007480002
	 * </pre>
	 * @param origin
	 * @return
	 * @throws Exception
	 */
	private String setToThirteenLengthString(String origin) throws Exception {
		
		while(11 > origin.length()){
			origin = "0".concat(origin);
		}
		return origin;
	}
	
	/**
	 * 공통 코드 목록을 조회 하는 기능
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> commonCodeList(CommonCodeVO codeVO) throws Exception {
		
        List<CommonCodeVO> list = basicReservationService.commonCodeList(codeVO);
        
		return list;
	}
	
	/**
	 * <pre>
	 * 공통코드명 취득
	 * 
	 * usage : getCommonCodeName("RV1", "R02");		// 대분류코드, 공통코드
	 * return : 일반예약
	 * </pre>
	 * @param commonCodeSeq
	 * @param commonCode
	 * @return 공통코드명
	 * @throws Exception
	 */
	public String getCommonCodeName(String commonCodeSeq, String commonCode) throws Exception {
		
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCommonCodeSeq(commonCode);
		
		return basicReservationService.getCommonCodeName(codeVO);
	}
	
	/**
	 * 동의여부
	 * 		- [동의, 비동의]
	 * @param type
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> agreementCodeListType1() throws Exception {
		
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN9");
		codeVO.setCaseOne("TYPE1");
		
		return commonCodeList( codeVO);
	}
	
	/**
	 * 동의여부
	 * 		- [동의, 비동의, 미동의] 
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> agreementCodeList() throws Exception {
		
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN9");
		
		return commonCodeList( codeVO);
	}
	
	/**
	 * PP(교육장)
	 * 		- 운영자 일 경우 본인의 PP만 조회
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ppCodeList() throws Exception{
		
		return basicReservationService.ppCodeList();
	}
	
	/**
	 * 상태여부
	 * 		-[사용, 미사용]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> stateCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 지역 우대 여부
	 * 		-[우대, 없음]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> cityTreatCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN5");
		
		return commonCodeList(codeVO);
		
	}
	
	/**
	 * 나이 우대 여부
	 * 		-[U35, U40]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ageTreatCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("RU1");
		
		return commonCodeList(codeVO);
		
	}
	
	/**
	 * 설정 요일 리스트
	 * 		-[월, 화 , 수, 목, 금, 토, 일]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> setWeekCodeListType1() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("WEK");
		codeVO.setCaseOne("TYPE1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 설정 요일 리스트
	 * 		-[월, 화, 수, 목, 금, 토, 일, 마지막주 일요일]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> setWeekCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("WEK");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 단위 기간 리스트
	 * 		-[일, 월]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> periodTypeCodeListType2()throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("PD1");
		codeVO.setCaseTwo("TYPE2");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 시설 타입 리스트
	 * 		-[교육장, 비즈룸, 퀸룸]
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roomTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("RM1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 예약자 검색 조건 리스트
	 * 		-[ABO 이름, ABO번호]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> searchAccountTypeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("TM3");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 패널티 유형 코드 리스트
	 * 		-[취소 패널티, NoShow패널티]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> penaltyTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("PN1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 패널티 상세 유형 코드 리스트
	 * 		-[x회 이내 취소, x회 불참]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> penaltyTypeDetailCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("PN2");
		
		return commonCodeList(codeVO);
		
	}
	
	/**
	 * 패널티 적용 형태
	 * 		-[수수료, 예약제한, 횟수차감]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> penaltyApplyTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("PN3");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 체험 프로그램 종류
	 * 		-[체성분측정, 피부측정, 브랜드체험, 문화체험]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> programTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("EP1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 동반자 구분(회원 구분과 같은건지 확인 필요)
	 * 		-[ABO, 일반인]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> partnerTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("RV4");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 파티션룸 존재 여부
	 * 		-[있음, 없음]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> partitionRoomTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN2");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 세션 시간 리스트
	 * 		-[0시~23시]
	 * @return
	 * @throws Exception
	 */
	public List<String> ppSessionHourCodeList() throws Exception{
		
		ArrayList<String> ppSessionHourCodeList = new ArrayList<String>();
		
		for(int i=0; i <= 23; i++){
			
			ppSessionHourCodeList.add(String.format("%02d", i));
		}
		
		return ppSessionHourCodeList;
	}
	
	/**
	 * 세션 분 리스트
	 * 		-[00분~55분]
	 * @return
	 * @throws Exception
	 */
	public List<String> ppSessionMinuteCodeList() throws Exception{
		ArrayList<String> ppSessionMinuteCodeList = new ArrayList<String>();
		
		
		for(int i=0; i <= 55; i+=5){
			
			ppSessionMinuteCodeList.add(String.format("%02d", i));
		}
		
		return ppSessionMinuteCodeList;
	}
	
	/**
	 * 관리자 우선 예약
	 * 		-[AKL 직원미팅, 본사 직원 미팅]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> adminPriorReservationCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("RV5");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 예약 현황_프로그램 타입
	 * 		-[RSVEXPINFO table - 카테고리1 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramTypeCodeList() throws Exception{
		List<CommonCodeVO> list = basicReservationService.rervationProgramTypeCodeList();
		
		return list;
	}
	
	/**
	 * 예약 현황_프로그램 명
	 * 		-[RSVEXPINFO table - 프로그램명 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception{
		List<CommonCodeVO> list = basicReservationService.rervationProgramCodeList();
		
		return list;
	}
	
	/**
	 * 회원 구분 코드 리스트
	 * 		-[운영자, 소비자, ABO, member]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> divisionMemverCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("MT1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 약관 타입 코드 리스트
	 * 		-[규약동의, 주의사항, 주문동의, 개인정보 수집 동의]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> clauseTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("CL2");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 세션 코드 리스트
	 * 		-[세션1 : 10:00 ~ 10:30 - 세션13 : 05:30 ~ 06:00]
	 * @return
	 * @throws Exception
	 */
//	public Map<String, String> reservationManagerSessionCodeList() throws Exception{
//		HashMap<String, String> sessionCodeList = new HashMap<String, String>();
//		
//		int sw = 1;
//		int cnt = 0;
//		
//		//10사~12시까지
//		for(int i = 10; i <= 11; i++){
//			for(int j = 0; j <= 1; j++ ){
//				if(sw == 1){
//					sw = sw * -1;
//					cnt ++;
//					sessionCodeList.put(String.valueOf(cnt), "세션" + String.valueOf(cnt) + ":" + i + ":00 ~ " + i + ":30");
//				}else if(sw == -1){
//					sw = sw * -1;
//					cnt ++;
//					sessionCodeList.put(String.valueOf(cnt), "세션" + String.valueOf(cnt) + ":" + i + ":30 ~ " + (i+1) + ":00");
//				}
//			}
//		}
//		
//		sw = 1;
//		//1시부터 6시까지
//		for(int i = 1; i <= 5; i++){
//			for(int j = 0; j <= 1 ; j++){
//				if(sw == 1){
//					sw = sw * -1;
//					cnt ++;
//					sessionCodeList.put(String.valueOf(cnt), "세션" + String.valueOf(cnt) + ":" + String.format("%02d", i) + ":00 ~ " + String.format("%02d", i) + ":30");
//				}else if(sw == -1){
//					sw = sw * -1;
//					cnt ++;
//					sessionCodeList.put(String.valueOf(cnt), "세션" + String.valueOf(cnt) + ":" + String.format("%02d", i) + ":30 ~ " + String.format("%02d", (i+1)) + ":00");
//				}
//			}
//		}
//		
//		return sessionCodeList;
//	}
//	
	/**
	 * 행정 구역 코드 리스트
	 * 		-[RSVREGIONINFO table - 행정구역 조회(서울시, 경기도, 경상남도 등)]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> regionCodeList() throws Exception{
		List<CommonCodeVO> regionCodeList = basicReservationService.regionCodeList();
		
		return regionCodeList;
	}
	
	/**
	 * 타입 분류 코드 리스트
	 * 		-[시설, 체험/측정]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> typeClassifyCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("RT1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 사용 상태
	 * 		-[사용중, 사용안함]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> useStateCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("YN3");
		
		return commonCodeList(codeVO);
	}
	
	
	/**
	 * 제한기준 타입 코드 리스트
	 * 		-[자격  조건 선택, 특정 대상자 선택, 특정 PP선택]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> constraintTypeCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("CR1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 필수 여부 & 약관 종류 코드 리스트
	 * 		-[필수, 선택]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> mandatoryCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("CL1");
		
		return commonCodeList(codeVO);
		
	}
	
	public List<CommonCodeVO> reservationProgressFormCodeList() throws Exception{
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCodeMasterSeq("PM1");
		
		return commonCodeList(codeVO);
	}
	
	/**
	 * 기준 년 리스트
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<String> reservationYearCodeList() throws Exception{
		ArrayList<String> reservationYearCodeList = new ArrayList<String>();
		
		
		for(int i = 2014; i <= 2020; i++){
			
			reservationYearCodeList.add(String.format("%d", i));
		}
		
		return reservationYearCodeList;
	}
	
	/**
	 * 기준 월 리스트
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<String> reservationMonthCodeList() throws Exception{
		ArrayList<String> reservationMonthCodeList = new ArrayList<String>();
		
		
		for(int i=0; i < 12; i++){
			
			reservationMonthCodeList.add(String.format("%d", i + 1));
		}
		
		return reservationMonthCodeList;
	}
	
	/**
	 * 기준 월 리스트[01, 02, 03 ~ 12] - 두 자릿수 맞춤
	 * @return
	 * @throws Exception
	 */
	public List<String> reservationFormatingMonthCodeList() throws Exception{
		
		ArrayList<String> reservationFormatingMonthCodeList = new ArrayList<String>();
		
		
		for(int i=0; i < 12; i++){
			
			reservationFormatingMonthCodeList.add(String.format("%02d", i + 1));
		}
		
		return reservationFormatingMonthCodeList;
	}
	
	/**
	 * 예약 형태 정보 코드 리스트(예약 형태 정보 테이블 조회)
	 * 		-[체성분측정, 피부 측정, 브랜드 체험, 문화체험]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> expRsvTypeInfoCodeList()throws Exception{
		return basicReservationService.expRsvTypeInfoCodeList();
	}
	
	/**
	 * 예약 형태 정보 코드 리스트(예약 형태 정보 테이블 조회)
	 * 		-[교육장, 퀸룸/파티룸, 비즈룸]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roomRsvTypeInfoCodeList()throws Exception{
		return basicReservationService.roomRsvTypeInfoCodeList();
	}
	
	/**
	 * <pre>
	 * 규약동의 내용(만)을 취득
	 * 
	 * C01	규약동의
	 * C02	주의사항
	 * C03	주문동의
	 * C04	개인정보수집동의
	 * C05	시설교육규정동의
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsRoleAgreement() throws Exception {
		
		RequestBox requestBox = new RequestBox("clause");
		requestBox.put("typecode", "C01");
		
		return basicReservationService.getClauseContentsByKeyCode(requestBox);
	}
	
	/**
	 * <pre>
	 * 주의사항 내용(만)을 취득
	 * 
	 * C01	규약동의
	 * C02	주의사항
	 * C03	주문동의
	 * C04	개인정보수집동의
	 * C05	시설교육규정동의 
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsAttentionAgreement() throws Exception {
		
		RequestBox requestBox = new RequestBox("clause");
		requestBox.put("typecode", "C02");
		
		return basicReservationService.getClauseContentsByKeyCode(requestBox);
	}
	
	/**
	 * <pre>
	 * 주문동의 내용(만)을 취득
	 * 
	 * C01	규약동의
	 * C02	주의사항
	 * C03	주문동의
	 * C04	개인정보수집동의
	 * C05	시설교육규정동의 
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsPurchaseAgreement() throws Exception {
		
		RequestBox requestBox = new RequestBox("clause");
		requestBox.put("typecode", "C03");
		
		return basicReservationService.getClauseContentsByKeyCode(requestBox);
	}
	
	/**
	 * <pre>
	 * 개인정보수집동의 내용(만)을 취득
	 * 
	 * C01	규약동의
	 * C02	주의사항
	 * C03	주문동의
	 * C04	개인정보수집동의
	 * C05	시설교육규정동의 
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsPrivateAgreement() throws Exception {
		
		RequestBox requestBox = new RequestBox("clause");
		requestBox.put("typecode", "C04");
		
		return basicReservationService.getClauseContentsByKeyCode(requestBox);
	}
	
	/**
	 * <pre>
	 * 시설교육규정동의 내용(만)을 취득
	 * 
	 * C01	규약동의
	 * C02	주의사항
	 * C03	주문동의
	 * C04	개인정보수집동의
	 * C05	시설교육규정동의 
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsRoomEducateAgreement() throws Exception {
		
		RequestBox requestBox = new RequestBox("clause");
		requestBox.put("typecode", "C05");
		
		return basicReservationService.getClauseContentsByKeyCode(requestBox);
	}
	
	/**
	 * 예약필수 안내 내용 취득 - 예약 형태 일련번호로 조회
	 * @param rsvTypeSeq
	 * @return
	 * @throws Exception
	 */
	public String getReservationInfoByType(String rsvTypeName) throws Exception {
		
		RequestBox requestBox = new RequestBox("reservationType");
		requestBox.put("rsvTypeName", rsvTypeName);
		
		return basicReservationService.getReservationInfoByType(requestBox);
	}
	
	public boolean checkSso(HttpServletRequest request, HttpServletResponse response) throws Exception {

		//삼성 하이브리스 연결
		String ssoValue = "";
		
		String requestUrl = request.getRequestURL().toString();
		
		LOGGER.error("============ sso check " + requestUrl);
		
		if( requestUrl.indexOf("http://localhost") >= 0 ) {
			//로컬 테스트
			Cookie[] cookies = request.getCookies();
			
	        if(null != cookies) {
				/* 유효한 연결이면 requestMap 객체 생성 */
	        	for(Cookie cookie : cookies){
					String cookieName = cookie.getName();
					String cookieValue = cookie.getValue();

					if("username".equals(cookieName)){
						ssoValue = cookieValue;
						
						break;
					}
				}
	        }
		} else {
			LOGGER.error("============ 정상 sso check");
			//프로퍼티의 Hybris.ssoUrl정보를 읽어서 https://localhost 이면 체크하지 않는다.
			String urlString = "";
			
			String resourceName = "/config/props/framework.properties";
			ClassLoader loader = Thread.currentThread().getContextClassLoader();
			Properties props = new Properties();
			try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
				props.load(resourceStream);
				//삼성 하이브리스 체크 url
				urlString = props.getProperty("Hybris.ssoUrl");
				
				if( urlString.indexOf("https://localhost") >= 0 ) {
					Cookie[] cookies = request.getCookies();
					
			        if(null != cookies) {
						/* 유효한 연결이면 requestMap 객체 생성 */
			        	for(Cookie cookie : cookies){
							String cookieName = cookie.getName();
							String cookieValue = cookie.getValue();

							if("username".equals(cookieName)){
								ssoValue = cookieValue;
								
								break;
							}
						}
			        }
				} else {
					ssoValue = CheckSSO.ssoCheck(request, urlString);
				}
				
				LOGGER.error("============ 정상 sso check ssoValue : " + ssoValue);
			} catch( IOException e) {
				LOGGER.error("/config/props/framework.properties File not found.");
				
				ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				throw new ModelAndViewDefiningException(modelAndView);
			}
		}

		if( ssoValue.equals("ERROR") || ssoValue.equals("") ) {
			// 세션 아웃
			request.getSession().invalidate();
			String requestUri = request.getRequestURI().toString();
			LOGGER.debug("================== sso인증 오류로 로그아웃" + requestUri);

			if( 0 <= requestUri.indexOf("/reservation/expCultureForm") || 0 <= requestUri.indexOf("/mobile/reservation/expCultureForm") ){
				LOGGER.debug("================== sso인증 비회원");
				return false;
			} else {
				ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				throw new ModelAndViewDefiningException(modelAndView);
			}

		} else {
			
			if( !("").equals(ssoValue) ) {
				request.getSession().setAttribute("abono", ssoValue);
				LOGGER.debug("================== checkSso sso인증 로그인 완료");
				return true;
			} else {
				// 세션 아웃
				request.getSession().invalidate();
				LOGGER.debug("================== checkSso imar값이 없어서 로그아웃 시킴");
				return false;
/*				String requestUri = request.getRequestURI().toString();
				
				if(-1 == requestUri.indexOf("/lms")){
					ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
					throw new ModelAndViewDefiningException(modelAndView);
				}*/
			}
		}
		
	}
	
	/**
	 * <pre>
	 * 	AI 프로젝트의 PP 코드로 Hybris 의 AP 코드를 얻어오는 기능
	 * </pre>
	 * @param ppCode
	 * @return
	 * @throws Exception
	 */
	public String getApCodeByPpCode(String ppCode) throws Exception {
		
		RequestBox requestBox = new RequestBox("getApCodeByPpCode");
		requestBox.put("ppcode", ppCode);
		
		return basicReservationService.getApCodeByPpCode(requestBox);
		
	}

	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String roomReservationCheckAjax(ModelMap model, RequestBox requestBox) throws Exception {
		/** 선택 예약 정보 총 갯수 */
		return basicReservationService.getCurrentCardTraceNumber();
	}
	
	/**
	 * <pre>
	 * interface : 주문 체크부터 주문까지 진행
	 *  - 주문 전에 체크 request로 
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> interfacePayment(HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke interfacePayment");
		LOGGER.debug("request : {}", request);
		LOGGER.debug("requestBox : {}", requestBox);
		
		// 기준단가 (vat 포함액)
		int quantityPriceUnit = 1100;
		
		Map<String, String> returnMessage = new HashMap<String, String>();
		
		try {
			
			/* 1. 주문 체크 */
			String interfaceChannel = (String) requestBox.get("interfaceChannel");
			String paymentmode = (String) requestBox.get("paymentmode");
			String xmlSourceForCheckOrder = XmlTemplete.xmlSource();
			
			String requestTime = DateUtil.getDateType("yyyy-MM-dd") + "T" + DateUtil.getTime();
			//String interfaceChannel = requestBox.getString("interfaceChannel");
			String distNo = requestBox.getSession("abono");
			String apCode = getApCodeByPpCode((String)requestBox.getString("ppseq"));
			String roomSeq = (String)requestBox.getString("roomseq");
			
			StringBuffer etcForAS400 = new StringBuffer();
			etcForAS400.append(apCode).append("-").append(roomSeq);
			
			int selectedSessionCount = requestBox.getVector("reservationdate").size();
			
			String reservationdate = "";
			String rsvsessionSeq = "";
			for(int cnt = 0; cnt < selectedSessionCount; cnt++){
				reservationdate = (String) requestBox.getVector("reservationdate").get(cnt);
				rsvsessionSeq = (String) requestBox.getVector("rsvsessionseq").get(cnt);
				etcForAS400.append("-").append(reservationdate).append("+").append(rsvsessionSeq);
			}
			
			if (etcNumber < etcForAS400.length()){
				etcForAS400.delete(0, etcForAS400.length());
				etcForAS400.append(etcForAS400.substring(0, 180));
			}
			
			String quantity = "0";
			int priceInteger = 0;
			
			if(null != requestBox.getString("orderAmount") && !"".equals(requestBox.getString("orderAmount"))){
				priceInteger = Integer.parseInt(requestBox.getString("orderAmount"));
				
				if( priceInteger > quantityPriceUnit){
					priceInteger = priceInteger / quantityPriceUnit;
				}
				
				quantity = String.valueOf(priceInteger);
			}
			
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__request__", 		 	requestTime);	// 2016-08-09T12:32:22.857
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__interfaceChannel__", 	interfaceChannel);
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__distNo__", 			distNo);
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__quantity__", 		 	quantity);
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__apCode__", 			apCode);
			xmlSourceForCheckOrder = xmlSourceForCheckOrder.replaceAll("__etc__", 				etcForAS400.toString());
			
			LOGGER.debug("xmlSourceForCheckOrder : {}" , xmlSourceForCheckOrder);

			Map receiptInfoMapCheckOrder = UtilAPI.checkOrder(xmlSourceForCheckOrder);
			
			String checkResult = null;
			String checkResultCode = null;
			String orderAmountAddedVATReturn = null;
			if(null != receiptInfoMapCheckOrder){
				
				checkResult = null == (String) receiptInfoMapCheckOrder.get("result") ? "" : (String) receiptInfoMapCheckOrder.get("result");
				checkResultCode = null == (String) receiptInfoMapCheckOrder.get("errorCode") ? "" : (String) receiptInfoMapCheckOrder.get("errorCode");
				
				// error-code 18 을 제외한 모든 에러는 결제 중단 - 현업 운영의 의사결정
				if (("ERROR").equals(checkResult) && !("18").equals(checkResultCode)){
					
					returnMessage.put("status", "ERROR");
					String errorMsg = (String) receiptInfoMapCheckOrder.get("errorMsg");
					String errorCode = (String) receiptInfoMapCheckOrder.get("errorCode");
					
					if(null != errorMsg && !"".equals(errorMsg)){
						returnMessage.put("errorCode", errorCode);
						returnMessage.put("errorMsg", errorMsg);
					}else{
						returnMessage.put("errorCode", "");
						returnMessage.put("errorMsg", "결재진행중 오류가 발생했습니다.");
					}
					return returnMessage;

				} else if ( "18".equals(checkResultCode) ) {
					
					orderAmountAddedVATReturn = requestBox.getString("orderAmount");
					
				} else {
					
					//결제 진행
					orderAmountAddedVATReturn = (String) receiptInfoMapCheckOrder.get("orderAmount");
					
				}
				
			} else {
				returnMessage.put("status", "ERROR");
				returnMessage.put("errorMsg", "결재진행중 오류가 발생했습니다.");
				return returnMessage;
			}
			
			/* 2. 주문 */
			String xmlSourceForOrderCreate = XmlTemplete.xmlOrderSource();
			
			//String orderAmount = requestBox.getString("orderAmount");
			String cardNumber = requestBox.getString("cardnumber1") + requestBox.getString("cardnumber2") + requestBox.getString("cardnumber3") + requestBox.getString("cardnumber4");
			String cardEffectiveDate = requestBox.getString("cardmonth") + requestBox.getString("cardyear");
			String vpsInstallmentMonth = requestBox.getString("ninstallment");
			String url = requestBox.getString("reqeustServletName");
			String cardTraceNumber= requestBox.getString("cardtracenumber");
			
			String cardowner = requestBox.getString("cardowner");
			String bizNo = null;
			if ("personal".equals(cardowner)){
				bizNo = requestBox.getString("birthday");
			}else{
				bizNo = requestBox.getString("biznumber");
			}

			/* easy-pay setting */
			//String paymentmode = requestBox.getString("paymentmode");
			if(null != paymentmode && ("easypay").equals(paymentmode)) {
				
				String installPeriod = ""; 
				
				String epTrCd = StringUtil.nvl(request.getParameter("EP_tr_cd"), "");
				String epTraceNo = StringUtil.nvl(request.getParameter("EP_trace_no"), "");
				String epSessionKey = StringUtil.nvl(request.getParameter("EP_sessionkey"), "");
				String epEncryptData = StringUtil.nvl(request.getParameter("EP_encrypt_data"), "");
				
				/* sAbn 어플의 응답은 parameter-key 값이 다르므로  없는 값의 파라미터를 매칭한다. */
				if("".equals(epTrCd)) {
					epTrCd = StringUtil.nvl(request.getParameter("tr_cd"), "");
				}
				if("".equals(epTraceNo)){
					epTraceNo = StringUtil.nvl(request.getParameter("m_cert_no"), "");
				}
				if("".equals(epSessionKey)){
					epSessionKey = StringUtil.nvl(request.getParameter("sessionkey"), "");
				}
				if("".equals(epEncryptData)){
					epEncryptData = StringUtil.nvl(request.getParameter("encrypt_data"), "");
				}
				
				String ip = request.getHeader("X-Forwarded-For");

				if (ip == null || ip.length() == 0 || ("unknown").equalsIgnoreCase(ip)) {  
					ip = request.getHeader("Proxy-Client-IP");
					LOGGER.debug("IP : {}", ip);
				}  
				
				if (ip == null || ip.length() == 0 || ("unknown").equalsIgnoreCase(ip)) {  
					ip = request.getHeader("WL-Proxy-Client-IP");  
					LOGGER.debug("IP : {}", ip);
				}  
				
				if (ip == null || ip.length() == 0 || ("unknown").equalsIgnoreCase(ip)) {  
					ip = request.getHeader("HTTP_CLIENT_IP");  
					LOGGER.debug("IP : {}", ip);
				}  
				
				if (ip == null || ip.length() == 0 || ("unknown").equalsIgnoreCase(ip)) {  
					ip = request.getHeader("HTTP_X_FORWARDED_FOR");  
					LOGGER.debug("IP : {}", ip);
				}  
				
				if (ip == null || ip.length() == 0 || ("unknown").equalsIgnoreCase(ip)) {  
					ip = request.getRemoteAddr();  
					LOGGER.debug("IP : {}", ip);
				}
				
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__request__",				requestTime);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__interfaceChannel__",	interfaceChannel);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__distNo__", 				distNo);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__quantity__", 			quantity); 
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__apCode__", 				apCode);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__etc__", 				"");	//etcForAS400.toString()
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__orderAmount__", 		orderAmountAddedVATReturn);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__trackingNumber__",		cardTraceNumber);
				
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__cardNumber__",			"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__cardEffectiveDate__",	"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__vpsInstallmentMonth__",	installPeriod);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__ispCard__",				"true");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__mpiCard__",				"false");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__bizNo__",				"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epTrCd__",				epTrCd);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epTraceNo__",			epTraceNo);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epSessionKey__",		epSessionKey);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epEncryptData__",		epEncryptData);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epUserIp__",			"127.0.0.1");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epOrderNo__",			cardTraceNumber); //epOrderNo
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__kknCode__",				"1");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__url__",					url);

			} else {
				
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__request__",				requestTime);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__interfaceChannel__",	interfaceChannel);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__distNo__", 				distNo);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__quantity__", 			quantity); 
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__apCode__", 				apCode);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__etc__", 				etcForAS400.toString());
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__orderAmount__", 		orderAmountAddedVATReturn);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__trackingNumber__",		cardTraceNumber);
				
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__cardNumber__", 			cardNumber);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__cardEffectiveDate__",	cardEffectiveDate);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__vpsInstallmentMonth__", vpsInstallmentMonth);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__ispCard__",				"false");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__bizNo__", 				bizNo);
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epTrCd__",				"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epTraceNo__",			"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epSessionKey__",		"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epEncryptData__",		"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epUserIp__",			"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__epOrderNo__",			"");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__kknCode__",				"2");
				xmlSourceForOrderCreate = xmlSourceForOrderCreate.replaceAll("__url__", 				url);
				
			}
		
			LOGGER.debug("receiptInfoMapCreateOrder : {}" , xmlSourceForOrderCreate);
			
			/** 주문 method 호출 : xml 생성 및 api 호출까지 진행 */
			Map receiptInfoMapCreateOrder = UtilAPI.orderCreate(xmlSourceForOrderCreate);
			
			if (null != receiptInfoMapCreateOrder) {
				
				String result = (String) receiptInfoMapCreateOrder.get("result");
				String errorMsg = (String) receiptInfoMapCreateOrder.get("errorMsg");
				String errorCode = (String) receiptInfoMapCreateOrder.get("errorCode");
				String invoiceQueue = (String) receiptInfoMapCreateOrder.get("invoiceQueue");
				String productCode = (String) receiptInfoMapCreateOrder.get("productCode");
				String responseTimestamp = (String) receiptInfoMapCreateOrder.get("responseTimestamp");
				
				if("ERROR".equals(result)) {
					returnMessage.put("status", "ERROR");
					returnMessage.put("errorMsg", errorMsg);
					returnMessage.put("errorCode", errorCode);
					return returnMessage;
				}
				
				returnMessage.put("status", "SUCCESS");
				returnMessage.put("invoiceQueue", invoiceQueue);
				returnMessage.put("productCode", productCode);
				returnMessage.put("responseTimestamp", responseTimestamp);
				returnMessage.put("errorMsg", "");
				returnMessage.put("errorCode", "");
				return returnMessage;
				
			} else {
				returnMessage.put("status", "ERROR");
				returnMessage.put("errorMsg", "결재시스템 연동중 오류가 발생했습니다.(주문생성 실패)");
				return returnMessage;
			}
			
		} catch (SqlSessionException e) {
			returnMessage.put("status", "ERROR");
			returnMessage.put("errorMsg", "결재시스템 연동중 알수없는 오류가 발생했습니다.");
			LOGGER.error(e.getMessage(), e);
			
			return returnMessage;
		}
		
	}
	
	/**
	 * interface : 환불처리 
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> interfaceRefund(RequestBox requestBox) throws Exception{
		
		// 기준단가 (vat 포함액)
		int quantityPriceUnit = 1100;
		
		// SKU code
		String itemCode = "271565K16";

		Map<String, String> returnMessage = new HashMap<String, String>();
		
		try {
			
			String xmlSourceForRefund = XmlTemplete.xmlCancelSource();
			
			/* 환불 처리 */
			//String request = DateUtil.getDateTime();
			String request = DateUtil.getDateType("yyyy-MM-dd") + "T" + DateUtil.getTime();
			String interfaceChannel = requestBox.getString("interfaceChannel");
			String id = requestBox.getString("ssn").concat("1111111");
			String imcNumber = requestBox.getSession("abono");
			String courseFinishDate = requestBox.getString("reservationdate");
			String applicationDate = requestBox.getString("purchasedate");
			String vpsRef = requestBox.getString("virtualpurchasenumber");
			
			/* temporary open logic */
			if("true".equals( (String) requestBox.get("isOldReservation") )){
				quantityPriceUnit = 11000;
				itemCode = "WHU9010K";
			}
			
			
			String itemQuantity = "0";
			int priceInteger = 0;
			
			if(null != requestBox.getString("paymentamount") && !"".equals(requestBox.getString("paymentamount"))){
				priceInteger = Integer.parseInt(requestBox.getString("paymentamount"));
				
				if( priceInteger > quantityPriceUnit){
					priceInteger = priceInteger / quantityPriceUnit;
				}
				
				itemQuantity = String.valueOf(priceInteger);
			}
			
			xmlSourceForRefund = xmlSourceForRefund.replace("__request__",			request);
			xmlSourceForRefund = xmlSourceForRefund.replace("__interfaceChannel__", interfaceChannel);
			xmlSourceForRefund = xmlSourceForRefund.replace("__id__", 				id);
			xmlSourceForRefund = xmlSourceForRefund.replace("__imcNumber__",		imcNumber);
			xmlSourceForRefund = xmlSourceForRefund.replace("__courseFinishDate__", courseFinishDate);
			xmlSourceForRefund = xmlSourceForRefund.replace("__applicationDate__",	applicationDate);
			xmlSourceForRefund = xmlSourceForRefund.replace("__vpsRef__",			vpsRef);
			xmlSourceForRefund = xmlSourceForRefund.replace("__onlineStatus__",		"false");
			xmlSourceForRefund = xmlSourceForRefund.replace("__item__",				itemCode);
			xmlSourceForRefund = xmlSourceForRefund.replace("__itemQuantity__",		itemQuantity);
			
			LOGGER.debug("xmlSourceForRefund : {}" , xmlSourceForRefund);
			
			Map<String, String> refundResultMap = (Map<String,String>) UtilAPI.cancelOrder(xmlSourceForRefund);
			
			if (null != refundResultMap) {
				String result = (String) refundResultMap.get("result");
				String errorCode = (String) refundResultMap.get("errorCode");
				String errorMsg = (String) refundResultMap.get("errorMsg");
				
				if ("ERROR".equals(result)) {
					returnMessage.put("status", "ERROR");
					returnMessage.put("errorCode", errorCode);
					returnMessage.put("errorMsg", errorMsg);
					return returnMessage;
				}
				
			}
			
			returnMessage.put("status", "SUCCESS");
			returnMessage.put("errorCode", "");
			returnMessage.put("errorMsg", "");
			
			return returnMessage;
			
		} catch (SqlSessionException e){
			returnMessage.put("status", "ERROR");
			returnMessage.put("errorCode", "");
			returnMessage.put("errorMsg", "반품 진행중 오류가 발생했습니다.");
			LOGGER.error(e.getMessage(), e);
			
			return returnMessage;
		}
		
	}
	
}
