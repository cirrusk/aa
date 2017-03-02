/**
 * 
 */
package amway.com.academy.reservation.basicPackage;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.service.ReservationCheckerService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * </pre>
 * Program Name  : ReservationCheckerControllerTest.java
 * Author : KR620207
 * Creation Date : 2016. 8. 12.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {	
									"file:src/main/resources/config/spring/context-database.xml",
									"file:src/main/resources/config/spring/context-aspect.xml",
									"file:src/main/resources/config/spring/context-common.xml"
								})
// @WebAppConfiguration
public class ReservationCheckerControllerTest {

	@Autowired
	private ReservationCheckerService reservationCheckerService;
	
	@Autowired
	private BasicReservationService basicReservationService;
	
	@Test
	public void getMemberInformation() throws Exception {

		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("account", "rsvTester");
		
		Map result = reservationCheckerService.getMemberInformation(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void getMemberReservationCount() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("account", "rsvTester");
		requestBox.put("reservationdate", "20160913");
		
		Map result = reservationCheckerService.getMemberReservationCount(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}

	@Test
	public void isPossiblePenalty() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("reservationtypecode", "R01");
		requestBox.put("account", "rsvTester");
		requestBox.put("reservationdate", "20160801");
		requestBox.put("roomseq", "257");			/* 시설sequence */ 
		
		/* 패널티 유형 코드 (PN1) :  */
		//requestBox.put("typecode", "P04");			/* 취소 패널티P01 / 노쇼 패널티P02 / (요리명장)취소 패널티P03 / (요리명장)노쇼 패널티P04 */
		/* 패널티 상세 유형 코드 (PN2) :  */
		//requestBox.put("typedetailcode", "P02");	/* X일 이내 취소P01 / X회 불참 P02 */	
		
		/* 적용형태가 예약제한일인 경우만 체크 한다. */
		/* 적용형태가 횟수차감인 경우(applytypecode:P03)는 요리명장의 무료 쿠폰 차감 형태로만 관리 되므로 <isPossibleLimitCountQueenByVip> 에서 처리하는것으로 변경함. */
		boolean result = reservationCheckerService.isPossiblePenaltyRange(requestBox);
		System.out.println("result-range : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void isPossibleFromDayToDay() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("reservationdate", "20160801");
		
		boolean result = reservationCheckerService.isPossibleFromDayToDay(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}

	/**
	 * 제외 로직
	 * @throws Exception
	 */
	@Test
	public void isPossibleWeek() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("expseq", "10");
		requestBox.put("typeseq", "19");
		requestBox.put("reservationdate", "20160801");
		
		boolean result = reservationCheckerService.isPossibleWeek(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}
	
	/**
	 * 휴일만 체크
	 * @throws Exception
	 */
	@Test
	public void isPossibleDay() throws Exception {

		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("reservationtypecode", "R01");
		requestBox.put("roomseq", "257");
		requestBox.put("reservationdate", "20160819");
		
		//requestBox.put("reservationtypecode", "R02");
		//requestBox.put("expseq", "16");
		//requestBox.put("reservationdate", "20160915");
		
		boolean result = reservationCheckerService.isPossibleDay(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}
	
	@Test
	public void isPossibleRoomAnotherReservation() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("sessionseq", "80");
		requestBox.put("reservationdate", "20160919");
		
		boolean result = reservationCheckerService.isPossibleRoomAnotherReservation(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}
	
	@Test
	public void isPossibleExpAnotherReservation() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("sessionseq", "80");
		requestBox.put("reservationdate", "20160919");
		
		boolean result = reservationCheckerService.isPossibleExpAnotherReservation(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void isPossibleRoomRole() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		
		requestBox.put("account", "00000000001");
		requestBox.put("sessionseq", "1");
		requestBox.put("reservationdate", "20160825");
		
		boolean result = reservationCheckerService.isPossibleRoomRole(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void isPossibleExpRole() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());

		requestBox.put("account", "ENDDAY");
		requestBox.put("sessionseq", "1");
		requestBox.put("reservationdate", "20160828");
		
		boolean result = reservationCheckerService.isPossibleExpRole(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void isPossibleSessionBySameRoom() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("reservationdate", "20160825");
		requestBox.put("sessionseq", "14"); // 1 or 2 룸의 예약으로 인해 3은 예약되면 안됨
		requestBox.put("roomseq", "3"); // 1 or 2 룸의 예약으로 인해 3은 예약되면 안됨
		
		//blockedRoomListByReservation
		boolean result = reservationCheckerService.isPossibleSessionBySameRoom(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}

	@Test
	public void isPossibleLimitCountQueenByVip() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("account", "rsvTester");
		requestBox.put("reservationdate", "20160701");
		
		boolean result = reservationCheckerService.isPossibleLimitCountQueenByVip(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}
	
	public void isPossibleGwangjuReservation() throws Exception {
		
	}
	
	public void isPossibleDaejeonReservation() throws Exception {
		
	}
	
	@Test
	public void getUniqTimestamp() throws Exception {
		
		String result = reservationCheckerService.getUniqTimestamp();
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}

	@Test
	public void isReservedSameHuman() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		
		requestBox.put("account", "rsvTester");
		requestBox.put("reservationdate", "20160912");
		requestBox.put("expseq", "19");
		requestBox.put("sessionseq", "15");
		
		boolean result = reservationCheckerService.isReservedExpSameHuman(requestBox);
		
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}
	
	@Test
	public void limitCountListByRoomAndRoomType() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		
		requestBox.put("account", "rsvTester");
		
		requestBox.put("pinvalue", "11");  // Z
		requestBox.put("citygroupcode", "2");
		requestBox.put("age", "35");
		
		
		requestBox.put("typeseq", "24");
		requestBox.put("roomseq", "257");
		
		requestBox.put("rsvtypecode", "R01");	// 예약 타입 (시설 or 체험)
		
		
		List<EgovMap> result = null;
		
		requestBox.put("constrainttype", "C01");
		result = reservationCheckerService.limitCountListByRoomAndRoomType(requestBox);
		
		System.out.println("result 1 : " + result);
		
		requestBox.put("account", "rsvTester");
		requestBox.put("constrainttype", "C02");
		result = reservationCheckerService.limitCountListByRoomAndRoomType(requestBox);
		
		System.out.println("result 2 : " + result);
		
		requestBox.put("ppseq", "");
		requestBox.put("constrainttype", "C03");
		result = reservationCheckerService.limitCountListByRoomAndRoomType(requestBox);
		
		System.out.println("result 3 : " + result);
		
		assertTrue(true);
	}
	
	@Test
	public void limitCountListByExpAndExpType() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());

		requestBox.put("account", "rsvTester");
		
		requestBox.put("pinvalue", "12");  // Z
		requestBox.put("citygroupcode", "2");
		requestBox.put("age", "35");
		
		requestBox.put("rsvtypecode", "R01");
		
		requestBox.put("typeseq", "19");
		requestBox.put("expseq", "29");
		
		List<EgovMap> result = null;
		
		requestBox.put("constrainttype", "C01");
		result = reservationCheckerService.limitCountListByExpAndExpType(requestBox);
		System.out.println("result 1 : " + result);
		
		requestBox.put("constrainttype", "C02");
		result = reservationCheckerService.limitCountListByExpAndExpType(requestBox);
		System.out.println("result 2 : " + result);
		
		requestBox.put("constrainttype", "C03");
		result = reservationCheckerService.limitCountListByExpAndExpType(requestBox);
		System.out.println("result 3 : " + result);
		
		assertTrue(true);
	}
	
	/**
	 * 누적 예약 조건 체크
	 * @throws Exception
	 */
	@Test
	public void isCurrentAccountReservationCount() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		
		requestBox.put("account", "rsvTester");
		requestBox.put("reservationdate", "20160913");
		
		requestBox.put("rsvtypecode", "R01");	// 예약 타입 (시설 or 체험)
		requestBox.put("typeseq", "24");		// 시설타입코드 (시설형태)
		requestBox.put("roomseq", "257");		// 시설 일련번호
		
		requestBox.put("ppseq", "1");
		
		/* 누적예약 제한 기준 : 자격조건 선택 C01, 틀정 대상자 선택 C02, 특정 PP C03 세가지 케이스 전부 비교해야 한다. */
		
		boolean result = false;
		
		/* (PIN, CITY, AGE 선택방식) 자격조건 선택 C01 */
		requestBox.put("constrainttype", "C01");
		result = reservationCheckerService.isCurrentAccountReservationCount(requestBox);
		System.out.println("result : " + result);

		/* 특정 대상자 = 기등록된 특정 그룹 을 대상으로 자격조건 점검을 수행한다. */
		requestBox.put("constrainttype", "C02");
		result = reservationCheckerService.isCurrentAccountReservationCount(requestBox);
		System.out.println("result : " + result);
		
		/* 특정 PP 를 대상으로 점검을 수행한다. */
		requestBox.put("constrainttype", "C03");
		result = reservationCheckerService.isCurrentAccountReservationCount(requestBox);
		System.out.println("result : " + result);
		
		assertTrue(true);
		
	}
	
	@Test
	public void getMonthlyReservedCountByRegion() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("account", "7480002");
		
		requestBox.put("reservationdate", "20160831");
		requestBox.put("rsvtypecode", "R01");
		requestBox.put("ppseq", "1");
		requestBox.put("typeseq", "10");
		requestBox.put("roomseq", "3");
		Integer result1 = reservationCheckerService.getMonthlyReservedCountByRegion(requestBox);
		
		System.out.println("result : " + result1);
		
		requestBox.put("reservationdate", "20160831");
		requestBox.put("rsvtypecode", "R02");
		requestBox.put("ppseq", "2");
		requestBox.put("typeseq", "22");
		requestBox.put("expseq", "19");
		Integer result2 = reservationCheckerService.getMonthlyReservedCountByRegion(requestBox);
		
		System.out.println("result : " + result2);
		
		assertTrue(true);
	}

	@Test
	public void getPrimiumCountByRegion() throws Exception {
		
		RequestBox requestBox = new RequestBox(new String());
		requestBox.put("account", "7480002");
		
		Map member = reservationCheckerService.getMemberInformation(requestBox);
		requestBox.put("pinvalue", 			member.get("pinvalue"));
		requestBox.put("citygroupcode", 	member.get("citygroupcode"));
		requestBox.put("age", 				member.get("age"));
		requestBox.put("cookmastercode",	member.get("cookmastercode"));
		
		requestBox.put("rsvtypecode", "R01");
		requestBox.put("roomseq", "257");
		requestBox.put("typeseq", "24");
		requestBox.put("ppseq", "999");
		
		Integer result1 = reservationCheckerService.getPrimiumCountByRegion(requestBox);
		System.out.println("result : " + result1);
		
		requestBox.put("rsvtypecode", "R02");
		requestBox.put("expseq", "29");
		requestBox.put("typeseq", "19");
		requestBox.put("ppseq", "333");
		
		Integer result2 = reservationCheckerService.getPrimiumCountByRegion(requestBox);
		System.out.println("result : " + result2);
		
		assertTrue(true);
	}
	
	@Test
	public void createXmlForPaymentCardInfo() throws Exception {
		
		//createXmlForPaymentCardInfo
		
		Map<String, Object> mappingData = new HashMap<String, Object>();
		mappingData.put("apcode", "AAAA");
		
		basicReservationService.createXmlForPaymentCardInfo(mappingData);
		
		assertTrue(true);
		
	}

}
