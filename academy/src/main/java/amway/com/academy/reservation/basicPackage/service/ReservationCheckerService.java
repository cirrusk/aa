package amway.com.academy.reservation.basicPackage.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * 	예약시 체크 해야할 조건 Class
 * </pre>
 * Program Name  : ReservationCheckerService.java
 * Author : KR620207
 * Creation Date : 2016. 8. 12.
 */
public interface ReservationCheckerService {
	
	/**
	 * TIME-STAMP 를 기반으로 한 고유키 생성 (14자리 String)
	 * @return
	 * @throws Exception
	 */
	public String getUniqTimestamp() throws Exception;

	/**
	 * <pre>
	 * 예약자{예약 하려는}의 예약 기준정보를 얻어오는 기능
	 * 
	 * == key list ==
	 * - pinno : PIN Number [code]
	 * - citygroup : 지역군 정보 [seq]
	 * - age : 나이 [number]
	 * - cookmaster : 요리명장 [true/false]
	 * </pre>
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getMemberInformation(RequestBox requestBox) throws Exception;

	/**
	 * <pre>
	 * 예약자{예약 하려는}의 누적 예약 횟수
	 * 
	 * == key list
	 * 
	 *		= 999 [전국]
	 *			gl_daily : 전국 합산 당일 누적 예약 횟수 [0 ~ 99..]
	 *			gl_weekly : 전국 합산 당주 누적 예약 횟수 [0 ~ 99..]
	 *			gl_monthly : 전국 합산 당월 누적 예약 횟수 [0 ~ 99..]
	 *
	 *		= 1 [ RSVPPINFO 테이블의 PPSEQ 번호 ]
	 * 			daily : PP별 당일 예약 횟수 집계 [0 ~ 99..]
	 * 			weekly : PP별 당주 예약 횟수 집계 [0 ~ 99..]
	 * 			monthly : PP별 당월 예약 횟수 집계 [0 ~ 99..]
	 * 
	 * ex ) 광주 PP의 당월 예약 횟수 집계 (광주의 일련번호가 1임을 가정)
	 * 		- getMemberReservationCount(userInformation).get("1").get("monthly")
	 * </pre>
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getMemberReservationCount(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 패널티 확인
	 * 
	 * 과거 예약건과 예약의 패널티 부여일로 예약 불가능한 기간내 예약을 못하도록 하는 기능
	 * 
	 * - 예약 가능하면 true, 패널티 부여일로부터 예약 제한 기간에 해당이 되면 false 를 리턴한다.
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossiblePenaltyRange(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약 가능일 확인 : 운영기간
	 * 
	 * 예약 신청일이 예약 마스터에 설정되어있는 기간인지 확인하는 기능
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleFromDayToDay(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * ** Deprecated
	 * 예약 가능일 확인 : 요일 + 세션
	 * 
	 * 신청중인 룸 또는 세션이 유효한 요일인지 확인하는 기능
	 * 시설및 측정에서 해당 요일에 설정된 요일인지 확인하는 로직이나  불필요한 로직으로 판단되어 제크로직에서 제외시킴
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleWeek(RequestBox requestBox) throws Exception;

	/**
	 * <pre>
	 * 예약 가능일 확인 : 일별 + 세션
	 * 
	 * 신청중인 시설 또는 체험이 휴일로 지정되어 있지 않은 날인지 확인
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleDay(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 시설 예약 가능일 확인 : 다른 사용자에 의한 예약 선점
	 * 
	 * 다른 사용자에 의한 예약이 있는지 확인하는 기능
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleRoomAnotherReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 체험 예약 가능일 확인 : 다른 사용자에 의한 예약 선점
	 * 
	 * 다른 사용자에 의한 예약이 있는지 확인하는 기능
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleExpAnotherReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약 자격 확인
	 * 
	 * 세션별(시간대)로 할당 되어있는 자격(핀,지역,나이)을 확인
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleRoomRole(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약 자격 확인
	 * 
	 * 세션별(시간대)로 할당 되어있는 자격(핀,지역,나이)을 확인
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleExpRole(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 시설타입별 누적예약 제한 횟수 확인
	 *
	 * 1. 예약자의 자격에 해당하는 global 조건을 전부 목록화 한다.
	 * 2. 목록화 한 내용중 일별 조건 확인
	 * 3. 목록화 한 내용중 주별 조건 확인
	 * 4. 목록화 한 내용중 월별 조건 확인
	 * 
	 * 5. 예약자의 자격에 해당하는 PP의 조건을 전부 목록화 한다.
	 * 6. 목록화 한 내용중 일별 조건 확인
	 * 7. 목록화 한 내용중 주별 조건 확인
	 * 8. 목록화 한 내용중 월별 조건 확인
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> limitCountListByRoomAndRoomType(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 체험타입별 누적예약 제한 횟수 확인
	 *
	 * 1. 예약자의 자격에 해당하는 global 조건을 전부 목록화 한다.
	 * 2. 목록화 한 내용중 일별 조건 확인
	 * 3. 목록화 한 내용중 주별 조건 확인
	 * 4. 목록화 한 내용중 월별 조건 확인
	 * 
	 * 5. 예약자의 자격에 해당하는 PP의 조건을 전부 목록화 한다.
	 * 6. 목록화 한 내용중 일별 조건 확인
	 * 7. 목록화 한 내용중 주별 조건 확인
	 * 8. 목록화 한 내용중 월별 조건 확인
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> limitCountListByExpAndExpType(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약하려는 날의 세션의 ROOM이 동일한 용도로 쓰이는 ROOM이 있는지 확인한다.
	 * 
	 * - PARTITION 룸에만 해당하며, 광주의 교육장과 퀸룸을 같이 쓰는 형태는 다른 메소드에서 확인한다.
	 * - 현재 예약 하려는 시설과 동일한 용도로 쓰이고 있는지를 RSVSAMEROOMINFO에서 찾은 후. 동일날짜에 예약 정보가 있는지 확인한다.
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleSessionBySameRoom(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 요리명장 예약 횟수 확인
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleLimitCountQueenByVip(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약 가능한 시간인지 확인한다.
	 * 
	 * 예약가능 설정은 framework.properties 파일에 설정되어있음.
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public boolean isAvailableReserveTime() throws Exception;
	
	/**
	 * <pre>
	 * 광주의 예외 케이스를 관리한다.
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleGwangjuReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 대전의 예외 케이스를 관리한다.
	 * 
	 * 예약 가능일이면 true, 예약 불가일이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isPossibleDaejeonReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약자의 현재 시설별 예약 누적횟수가 초과 했는지 체크 하는 기능
	 * 
	 * 예약 가능한 상태이면 true, 누적횟수 초과로 인해서 예약이 불가하면 false
	 * </pre> 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isCurrentAccountReservationCount(RequestBox requestBox) throws Exception; 	
	
	/**
	 * <pre>
	 * ( 시설 비즈룸만 )
	 * 예약 하려는 시설의 예약시 기존 예약자가 본인인지 확인
	 * 
	 * 예약 가능한상태이면 true, 예약 불가 상태이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isReservedRoomSameHuman(RequestBox requestBox) throws Exception;

	/**
	 * <pre>
	 * ( 체험, 측정 프로그램만 )
	 * 예약 하려는 프로그램의 예약시 기존 예약자가 본인인지 확인
	 * 
	 * 예약 가능한상태이면 true, 예약 불가 상태이면 false
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean isReservedExpSameHuman(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 	시설 예약 체크 (단일건)
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> checkRoomReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 	시설 예약 체크 (object 전체)
	 * </pre>
	 * @param requestBox
	 * @param tupleMap
	 * @param selectedCount
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> checkRoomReservationList(RequestBox requestBox, Map<String, String> tupleMap, int selectedCount ) throws Exception;
	
	/**
	 * <pre>
	 *  시설 예약 체크 (단일건)
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> checkExpReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 *  시설 예약 체크 (object 전체)
	 * </pre>
	 * @param requestBox
	 * @param tupleMap
	 * @param selectedCount
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> checkExpReservationList(RequestBox requestBox, Map<String, String> tupleMap, int selectedCount ) throws Exception;
	
	/**
	 * <pre>
	 * 예약자의 조건에 맞는 (우대조건에 의해)예약 가능한 횟수를 얻어오는 기능
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int getPrimiumCountByRegion(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 예약자의 예약 횟수를 얻어오는 기능 (월단위)
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int getMonthlyReservedCountByRegion(RequestBox requestBox) throws Exception;

	/**
	 * 누적 예약 가능 횟수 (월, 주, 일) 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getRsvAvailabilityCount(RequestBox requestBox) throws Exception;

	/**
	 * 누적예약 가능 횟수 예약가능 체크 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean rsvAvailabilityCheck(RequestBox requestBox) throws Exception;
	
	/** 누적예약 가능 횟수 예약가능 체크 기능(브랜드 카테고리_날짜먼저 선택)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean expBrandRsvAvailabilityCheck(RequestBox requestBox) throws Exception;

	/**
	 * 요리명장 누적예약 가능 횟수 예약가능 체크 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean cookMasterRsvAvailabilityCheck(RequestBox requestBox) throws Exception;

	/**
	 * 중간 패널티 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public boolean rsvMiddlePenaltyCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public EgovMap getReservationPriceBySessionSeq(Map requestMap) throws Exception;
}
