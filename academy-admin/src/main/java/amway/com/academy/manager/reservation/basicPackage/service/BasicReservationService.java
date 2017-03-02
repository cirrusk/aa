package amway.com.academy.manager.reservation.basicPackage.service;

import java.util.List;

import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface BasicReservationService {
	
	/**
	 * 공통 코드 목록 조회 기능
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> commonCodeList(CommonCodeVO codeVO) throws Exception;

	/**
	 * 공통 코드명 취득
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public String getCommonCodeName(CommonCodeVO codeVO) throws Exception;
	
	/**
	 * PP(교육장)
	 * 		- 운영자 일 경우 본인의 PP만 조회
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ppCodeList() throws Exception;
	
	/**
	 * PP(교육장)
	 * 		- 운영자 일 경우 본인의 PP만 조회
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ppCodeList(String allowApCode) throws Exception;
	
	/**
	 * 특정 대상자 그룹 조회
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roleGroupCodeList() throws Exception;
	
	/**
	 * 특정 대상자 그룹 조회 ( 전체 ) 
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roleGroupWithCookMasterCodeList() throws Exception;
	
	/**
	 * 룸타입 코드 리스트[예약  향테 정보 테이블 ]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roomTypeInfoCodeList() throws Exception;
	
	/**
	 * 체험형태 코드 리스트[예약  향테 정보 테이블 ]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> expTypeInfoCodeList() throws Exception;
	
	/**
	 * 예약 현황_프로그램 타입
	 * 		-[RSVEXPINFO table - 카테고리1 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramTypeCodeList() throws Exception;
	
	/**
	 * 예약현황_프로그램명
	 * 		-[RSVEXPINFO table - 프로그램명 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception;
	
	/**
	 * 행정구역 리스트
	 * 		-[RSVREGIONINFO table - 행정구역 조회(서울시, 경기도, 경상남도 등)]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> regionCodeList() throws Exception;
	
	/**
	 * <pre>
	 * 행정구역에 속한 군/구 단위의 도시 목록
	 * parameter [충남cd]
	 * return [서천cd, 서산cd, 태안cd ...]
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> cityCodeListByRegionCode(String regionCode) throws Exception;
	
	/**
	 * 나이 우대 코드 리스트
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ageCodeList() throws Exception;
	
	/**
	 * 지역 코드 리스트
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> cityGroupCodeList() throws Exception;
	
	/**
	 * 핀코드 구간 리스트
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> pinCodeList() throws Exception;
	

	/**
	 * 교육장_세션 조회(셀렉트 박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> searchSessionNameList(RequestBox requestBox) throws Exception;
	
	/**
	 * 체험_세션조회(셀렉트박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> searchExpSessionNameList(RequestBox requestBox) throws Exception;

	/**
	 * 오늘 년 월 일
	 * @return
	 * @throws Exception
	 */
	public DataBox reservationToday()throws Exception;
}
