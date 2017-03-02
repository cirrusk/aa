package amway.com.academy.manager.reservation.basicPackage.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import amway.com.academy.manager.reservation.basicPackage.service.BasicReservationService;
import framework.com.cmm.lib.DataBox;

public class BasicReservationController {

	/* default setting information */
	@Autowired
	protected BasicReservationService basicReservationService;
	
//	private int numberOne = 1;
	
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
		
		return basicReservationService.ppCodeList("");
	}
	
	/**
	 * <pre>
	 * PP(교육장)
	 * 		- 운영자 일 경우 본인의 PP만 조회
	 * </pre>
	 * @param allowApCode
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ppCodeList(String allowApCode) throws Exception {
		
		return basicReservationService.ppCodeList(allowApCode);
	}
	
	/**
	 * 특정 대상자 그룹 리스트
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roleGroupCodeList() throws Exception{
		return basicReservationService.roleGroupCodeList();
	}
	
	/**
	 * 특정 대상자 그룹 리스트 ( 전체 )
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roleGroupWithCookMasterCodeList() throws Exception {
		return basicReservationService.roleGroupWithCookMasterCodeList();
	}
	
	/**
	 * 핀구간 코드 리스트
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> pinCodeList() throws Exception{
		return basicReservationService.pinCodeList();
	}
	
	/**
	 * 나이 우대 코드 리스트
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ageCodeList() throws Exception{
		return basicReservationService.ageCodeList();
	}
	
	/**
	 * 지역 우대 코드리스트
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> cityGroupCodeList() throws Exception{
		return basicReservationService.cityGroupCodeList();
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
	 * 룸타입 코드 리스트 [예약  향테 정보 테이블 ]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roomTypeInfoCodeList() throws Exception{
		return basicReservationService.roomTypeInfoCodeList();
	}
	
	/**
	 * 체험형태 코드 리스트 [예약 형태 정보 테이블 ]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> expTypeInfoCodeList() throws Exception{
		return basicReservationService.expTypeInfoCodeList();
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
		codeVO.setCodeMasterSeq("RM1");
		
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
/*	public Map<String, String> reservationManagerSessionCodeList() throws Exception{
		HashMap<String, String> sessionCodeList = new HashMap<String, String>();
		
		int sw = 1;
		int cnt = 0;
		
		//10사~12시까지
		for(int i = 10; i <= 11; i++){
			for(int j = 0; j <= 1; j++ ){
				if(sw == numberOne){
					sw = sw * -1;
					cnt ++;
					sessionCodeList.put(Integer.toString(cnt), "세션" + Integer.toString(cnt) + ":" + i + ":00 ~ " + i + ":30");
				}else if(sw == -1){
					sw = sw * -1;
					cnt ++;
					sessionCodeList.put(Integer.toString(cnt), "세션" + Integer.toString(cnt) + ":" + i + ":30 ~ " + (i+1) + ":00");
				}
			}
		}
		
		sw = 1;
		//1시부터 6시까지
		for(int i = 1; i <= 5; i++){
			for(int j = 0; j <= 1 ; j++){
				if(sw == numberOne){
					sw = sw * -1;
					cnt ++;
					sessionCodeList.put(Integer.toString(cnt), "세션" + Integer.toString(cnt) + ":" + String.format("%02d", i) + ":00 ~ " + String.format("%02d", i) + ":30");
				}else if(sw == -1){
					sw = sw * -1;
					cnt ++;
					sessionCodeList.put(Integer.toString(cnt), "세션" + Integer.toString(cnt) + ":" + String.format("%02d", i) + ":30 ~ " + String.format("%02d", (i+1)) + ":00");
				}
			}
		}
		
		return sessionCodeList;
	}*/
	
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
	 * 오늘 년 월 일
	 * 
	 * @return
	 * @throws Exception
	 */
	public DataBox reservationToday() throws Exception{
		
		return basicReservationService.reservationToday();
	}
}
