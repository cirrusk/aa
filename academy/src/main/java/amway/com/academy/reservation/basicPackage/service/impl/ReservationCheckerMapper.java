package amway.com.academy.reservation.basicPackage.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ReservationCheckerMapper {

	public String getUniqTimestamp() throws Exception;
	
	public Map<String, String> getMemberInformation(RequestBox requestBox) throws Exception;

	public List<EgovMap> getPpCodeList() throws Exception;
	
	public List<EgovMap> getMemberGlobalReservationCount(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> getMemberPpReservationCount(RequestBox requestBox) throws Exception;
	
	public Boolean isPossiblePenaltyRange(RequestBox requestBox) throws Exception;
	
	public Boolean isPossibleRoomFromDayToDay(RequestBox requestBox) throws Exception;
	
	public Boolean isPossibleExpFromDayToDay(RequestBox requestBox) throws Exception;
	
	//public boolean isPossibleWeek(RequestBox requestBox) throws Exception;
	
	public Boolean isPossibleRoomDay(RequestBox requestBox) throws Exception;
	
	public Boolean isPossibleExpDay(RequestBox requestBox) throws Exception;
	
	public Boolean isPossibleRoomAnotherReservation(RequestBox requestBox) throws Exception;
	public Boolean isPossibleExpAnotherReservation(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> preparedRoomRoleCondition(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> isPossibleRoomRole(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> preparedExpRoleCondition(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> isPossibleExpRole(RequestBox requestBox) throws Exception;
	
	
	public List<EgovMap> limitCountListByRoomAndRoomTypeAtCondition(RequestBox requestBox) throws Exception;
	public List<EgovMap> limitCountListByRoomAndRoomTypeAtSpecialGroup(RequestBox requestBox) throws Exception;
	public List<EgovMap> limitCountListByRoomAndRoomTypeAtSpecialPP(RequestBox requestBox) throws Exception;
	
	public List<EgovMap> limitCountListByExpAndExpTypeAtCondition(RequestBox requestBox) throws Exception;
	public List<EgovMap> limitCountListByExpAndExpTypeAtSpecialGroup(RequestBox requestBox) throws Exception;
	public List<EgovMap> limitCountListByExpAndExpTypeAtSpecialPP(RequestBox requestBox) throws Exception;
	
	
	public boolean isPossibleSessionBySameRoom(RequestBox requestBox) throws Exception;
	
	public boolean isPossibleLimitCountQueenByVip(RequestBox requestBox) throws Exception;
	
	public int currentAccountDailyReservationCount(RequestBox requestBox) throws Exception;
	
	public int currentAccountWeeklyReservationCount(RequestBox requestBox) throws Exception;
	
	public int currentAccountMonthlyReservationCount(RequestBox requestBox) throws Exception;
	
	public boolean reservationCheckerMapper(RequestBox requestBox) throws Exception;
	
	public boolean isReservedRoomSameHuman(RequestBox requestBox) throws Exception;
	
	public boolean isReservedExpSameHuman(RequestBox requestBox) throws Exception;
	
	public boolean isPossibleGwangjuReservation(RequestBox requestBox) throws Exception;
	
	public boolean isPossibleDaejeonReservation(RequestBox requestBox) throws Exception;
	
	public int getPrimiumCountByRegionRoom(RequestBox requestBox) throws Exception;
	public int getPrimiumCountByRegionExp(RequestBox requestBox) throws Exception;
	
	public int getMonthlyReservedCountByRegion(RequestBox requestBox) throws Exception;

	public boolean bizRoomCheck(RequestBox requestBox) throws Exception;

	public Map<String, String> getRsvAvailabilityCount(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityPpDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityPpWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityPpMonthlyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityGlobalDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityGlobalWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilityGlobalMonthlyCheck(RequestBox requestBox) throws Exception;
	
	/* 특정 교육장[광주 ap]는  따로 예약 횟수 체크를 한다{*/
	public int rsvAvailabilitySpecialPpDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilitySpecialPpWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilitySpecialPpMonthlyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilitySpecialPpGlobalDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilitySpecialPpGlobalWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvAvailabilitySpecialPpGlobalMonthlyCheck(RequestBox requestBox) throws Exception;
	/* 특정 교육장[광주 ap]는  따로 예약 횟수 체크를 한다}*/

	public Map<String, String> getCookMasterRsvAvailabilityCount(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityPpDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityPpWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityPpMonthlyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityGlobalDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityGlobalWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilityGlobalMonthlyCheck(RequestBox requestBox) throws Exception;
	
	/* 특정 교육장[광주 ap]는  따로 예약 횟수 체크를 한다{*/
	public int rsvCookMasterAvailabilitySpecialPpDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilitySpecialPpWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilitySpecialPpMonthlyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilitySpecialPpGlobalDailyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilitySpecialPpGlobalWeeklyCheck(RequestBox requestBox) throws Exception;
	public int rsvCookMasterAvailabilitySpecialPpGlobalMonthlyCheck(RequestBox requestBox) throws Exception;
	/* 특정 교육장[광주 ap]는  따로 예약 횟수 체크를 한다}*/

	public String getCookMasterCode() throws Exception;
	
	public String getSpecialPpseq(RequestBox requestBox) throws Exception;
	
	/* session-seq와 type으로 가격을 쿼리하는 기능 */
	public EgovMap getReservationPriceBySessionSeq(Map requestMap) throws Exception;
	
}
