package amway.com.academy.reservation.basicPackage.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.ReservationCheckerService;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;

@Service
public class ReservationCheckerServiceImpl implements ReservationCheckerService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationCheckerServiceImpl.class);
	
	private int one = 1;
	private int eight = 8;
	
	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;

	@Autowired
	private ReservationCheckerMapper reservationCheckerMapper;
	
	@Override
	public String getUniqTimestamp() throws Exception {
		return reservationCheckerMapper.getUniqTimestamp();
	}	
	
	@Override
	public Map<String, String> getMemberInformation(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.getMemberInformation(requestBox);
	}

	@Override
	public Map<String, Object> getMemberReservationCount(RequestBox requestBox) throws Exception {
		
		Map<String, Object> reservationCount = new HashMap<String, Object>();
		
		/* 예약자의 전국 (일,주,월)별 예약 누적 횟수 */
		reservationCount.put("999", reservationCheckerMapper.getMemberGlobalReservationCount(requestBox));
		
		List<EgovMap> ppListCode = reservationCheckerMapper.getPpCodeList();
		
		/* pp의 개수만큼 사용자(account)의 예약정보를 일일히 확인한다. */
		for(EgovMap ppObject : ppListCode){
			
			String ppSeq = String.valueOf(ppObject.get("ppseq"));
					
			requestBox.put("ppseq", ppSeq);
			reservationCount.put(ppSeq, reservationCheckerMapper.getMemberPpReservationCount(requestBox));
		}
		
		return reservationCount;
	}
	
	@Override
	public List<EgovMap> limitCountListByRoomAndRoomType(RequestBox requestBox) throws Exception {
		
		if("C01".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByRoomAndRoomTypeAtCondition(requestBox);
		}else if("C02".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByRoomAndRoomTypeAtSpecialGroup(requestBox);
		}else if("C03".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByRoomAndRoomTypeAtSpecialPP(requestBox);
		}else{
			throw new Exception();
		}
		
	}
	
	@Override
	public List<EgovMap> limitCountListByExpAndExpType(RequestBox requestBox) throws Exception {

		if("C01".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByExpAndExpTypeAtCondition(requestBox);
		}else if("C02".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByExpAndExpTypeAtSpecialGroup(requestBox);
		}else if("C03".equals(requestBox.get("constrainttype"))){
			return reservationCheckerMapper.limitCountListByExpAndExpTypeAtSpecialPP(requestBox);
		}else{
			throw new Exception();
		}

	}

	@Override
	public boolean isPossiblePenaltyRange(RequestBox requestBox) throws Exception {
		Boolean ret = reservationCheckerMapper.isPossiblePenaltyRange(requestBox);
		if(null == ret || ret){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean isPossibleFromDayToDay(RequestBox requestBox) throws Exception {
		
		Boolean ret = null;
		
		if("R01".equals(requestBox.get("rsvtypecode"))){
			ret = reservationCheckerMapper.isPossibleRoomFromDayToDay(requestBox);
		}else{
			ret = reservationCheckerMapper.isPossibleExpFromDayToDay(requestBox);
		}
		
		if(null != ret && ret){
			return true;
		}else{
			return false; 
		}
	}

	@Override
	public boolean isPossibleWeek(RequestBox requestBox) throws Exception {
		return true; //reservationCheckerMapper.isPossibleWeek(requestBox);
	}

	@Override
	public boolean isPossibleDay(RequestBox requestBox) throws Exception {
		
		Boolean ret = null;
		
		if("R01".equals(requestBox.get("rsvtypecode"))){
			ret = reservationCheckerMapper.isPossibleRoomDay(requestBox);
		}else{
			ret = reservationCheckerMapper.isPossibleExpDay(requestBox);
		}
		
		if(null != ret && ret){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean isPossibleRoomAnotherReservation(RequestBox requestBox) throws Exception {
		
		/*비즈룸의 경우 예약 선점 1, 비즈룸이 아닌 경우 예약 선점 0*/
		int rsvCnt = 0;
		if(reservationCheckerMapper.bizRoomCheck(requestBox)){
			rsvCnt = 1;
		}
		requestBox.put("rsvcnt", rsvCnt);
		Boolean ret = null;
		
		ret = reservationCheckerMapper.isPossibleRoomAnotherReservation(requestBox);
		
		if(null != ret && ret){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean isPossibleExpAnotherReservation(RequestBox requestBox) throws Exception {
		
		Boolean ret = null;
		
		ret = reservationCheckerMapper.isPossibleExpAnotherReservation(requestBox);
		
		if(null != ret && ret){
			return true;
		}else{
			return false;
		}
	}
	
	@Override
	public boolean isPossibleRoomRole(RequestBox requestBox) throws Exception {
		
		/* 1 step */
		/* 예약자의 기본 정보를 취득한다. (취득 내용 : pin-no, pin-value, region-name, city-name, city-code, age, cookmaster) */
		/* parameter : account */
		/* return : pinno, pinvalue, regionname, cityname, age, cookmaster, citygroupcode */
		Map result = reservationCheckerMapper.getMemberInformation(requestBox);
		
		/* 2 step */
		/* 예약 가능 룰(=조건)은 세션마다 매칭 되어 있으며, 예약하려는 세션에 설정된 예약 가능 조건중에서 예약자와 맞는 조건의 목록을 취득한다. */
		/* parameter : reservationsessionseq */
		/* return :  */
		requestBox.put("pinvalue", result.get("pinvalue"));
		requestBox.put("citygroupcode", result.get("citygroupcode"));
		requestBox.put("age", result.get("age"));
		
		List<EgovMap> roomRoleSequenceList = reservationCheckerMapper.preparedRoomRoleCondition(requestBox);
		
		
		List<String> rolesequence = new ArrayList<String>();
		for(EgovMap roleSequence : roomRoleSequenceList){
			rolesequence.add( String.valueOf(roleSequence.get("rsvroleseq")) );
		}
		
		requestBox.put("rolesequence", rolesequence);
		
		/* 3 step */
		/* 예약자에 해당하는 조건으로 부터 설정 가능한 날과 기간 정보를 비교해서 예약 가능 여부를 알려준다. */
		/* 단, 예약 가능 조건이 0개이면, 예약자는 예약가능한 조건이 없다는 의미 이므로, 0건일때는 예약이 불가하다. */
		/* parameter : reservationdate */
		List<EgovMap> condition = reservationCheckerMapper.isPossibleRoomRole(requestBox);
		
		boolean isEverythigsAllRight = false;
		
		for(EgovMap element : condition){
			boolean finalResult = Boolean.parseBoolean((String)element.get("result"));
			if(!finalResult){
				isEverythigsAllRight = false;
				break;
			}else{
				isEverythigsAllRight = true;
			}
		}
		
		return isEverythigsAllRight;
	}

	@Override
	public boolean isPossibleExpRole(RequestBox requestBox) throws Exception {
		
		/* 1 step */
		Map result = reservationCheckerMapper.getMemberInformation(requestBox);
		
		/* 2 step */
		requestBox.put("pinvalue", result.get("pinvalue"));
		requestBox.put("citygroupcode", result.get("citygroupcode"));
		requestBox.put("age", result.get("age"));
		
		List<EgovMap> expRoleSequenceList = reservationCheckerMapper.preparedExpRoleCondition(requestBox);
		
		List<String> rolesequence = new ArrayList<String>();
		for(EgovMap roleSequence : expRoleSequenceList){
			rolesequence.add( String.valueOf(roleSequence.get("exproleseq")) );
		}
		
		requestBox.put("rolesequence", rolesequence);
		
		/* 3 step */
		List<EgovMap> condition = reservationCheckerMapper.isPossibleExpRole(requestBox);
		
		boolean isEverythigsAllRight = false;
		
		for(EgovMap element : condition){
			boolean finalResult = Boolean.parseBoolean((String)element.get("result"));
			if(!finalResult){
				isEverythigsAllRight = false;
				break;
			}else{
				isEverythigsAllRight = true;
			}
		}
		
		return isEverythigsAllRight;
	}

	@Override
	public boolean isPossibleSessionBySameRoom(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.isPossibleSessionBySameRoom(requestBox);
	}

	@Override
	public boolean isPossibleLimitCountQueenByVip(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.isPossibleLimitCountQueenByVip(requestBox);
	}
	
	@Override
	public boolean isAvailableReserveTime() throws Exception {
		
		String configuredStartTime = UtilAPI.getFrameworkProperties("reservation.time.start");
		String configuredEndTime = UtilAPI.getFrameworkProperties("reservation.time.end");
		
		String currentTime = DateUtil.getTime();
		
		LOGGER.debug("configuredStartTime	:{}", configuredStartTime);
		LOGGER.debug("configuredEndTime		:{}", configuredEndTime);
		LOGGER.debug("currentTime			:{}", currentTime);
		
		int csTime = Integer.parseInt(configuredStartTime);
		int ceTime = Integer.parseInt(configuredEndTime);
		int currentHour = Integer.parseInt((String) currentTime.subSequence(0, 2));
		
		LOGGER.debug("return :{}", (csTime <= currentHour && ceTime > currentHour) );
		
		/* 현재시간이 10시 이상, 22시 미만이면 예약 가능 */
		if( csTime <= currentHour && ceTime > currentHour ) {
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	public boolean isPossibleGwangjuReservation(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isPossibleDaejeonReservation(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return true;
	}
	
	@Override
	public int getPrimiumCountByRegion(RequestBox requestBox) throws Exception {
		
		if("R01".equals((String)requestBox.get("rsvtypecode"))){
			return reservationCheckerMapper.getPrimiumCountByRegionRoom(requestBox);
		}else if("R02".equals((String)requestBox.get("rsvtypecode"))){
			return reservationCheckerMapper.getPrimiumCountByRegionExp(requestBox);
		}else{
			throw new Exception();
		}
	}
	
	@Override
	public int getMonthlyReservedCountByRegion(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.getMonthlyReservedCountByRegion(requestBox);
	}
	
	@Override
	public boolean isCurrentAccountReservationCount(RequestBox requestBox) throws Exception {
		
		boolean isRunnable = false;

		/* 1 step */
		/* 예약자의 기본 정보를 취득한다. (취득 내용 : pin-no, pin-value, region-name, city-name, city-code, age, cookmaster) */
		/* parameter : account */
		/* return : pinno, pinvalue, regionname, cityname, age, cookmaster, citygroupcode */
		Map memberInformation = reservationCheckerMapper.getMemberInformation(requestBox);

		/* 2 step */
		/* 예약자의 전체 예약 현황 정보를 획득 */
		/* ppseq, reservation-object */
		/* "1", "{daily, weekly, monthly}" */
		/* "2", "{daily, weekly, monthly}" */
		Map<String, Object> memberReservationCount = this.getMemberReservationCount(requestBox);
		
		/* 3 step */
		/* 시설별 시설타입의 누적 예약 조건 중 예약자에 해당하는 조건만 추출한다. */
		requestBox.put("pinvalue", memberInformation.get("pinvalue"));
		requestBox.put("citygroupcode", memberInformation.get("citygroupcode"));
		requestBox.put("age", memberInformation.get("age"));
		
		/* 3-1. 룸타입별 누적예약 제한 횟수 확인 */
		String rsvtypecode = (String) requestBox.get("rsvtypecode");
		List<EgovMap> limitCountList = null;
		
		if("R01".equals(rsvtypecode)){
			limitCountList = this.limitCountListByRoomAndRoomType(requestBox);
		}else if("R02".equals(rsvtypecode)){
			limitCountList = this.limitCountListByExpAndExpType(requestBox);
		}else{
			throw new Exception();
		}

		/* 3-2. 예약자에 해당하는 조건만 추출 */
		for(EgovMap limitCountElement : limitCountList){
			
			int dailyLimitCount = 0;
			int weeklyLimitCount = 0;
			int monthlyLimitCount = 0;
			
			dailyLimitCount = Integer.parseInt(String.valueOf(limitCountElement.get("globaldailycount")));
			weeklyLimitCount = Integer.parseInt(String.valueOf(limitCountElement.get("globalweeklycount")));
			monthlyLimitCount = Integer.parseInt(String.valueOf(limitCountElement.get("globalmonthlycount")));
		
			/* 전체 누적 횟수 체크 */
			EgovMap globalUserReservationCountMap = (EgovMap)((ArrayList)memberReservationCount.get("999")).get(0);
			
			int dailyGlobalAccumulatedCount = Integer.parseInt(String.valueOf(globalUserReservationCountMap.get("daily")));
			int weeklyGlobalAccumulatedCount = Integer.parseInt(String.valueOf(globalUserReservationCountMap.get("weekly")));
			int monthlyGlobalAccumulatedCount = Integer.parseInt(String.valueOf(globalUserReservationCountMap.get("monthly")));
			
			LOGGER.debug("{} < {}",dailyGlobalAccumulatedCount, dailyLimitCount);
			if( dailyGlobalAccumulatedCount > dailyLimitCount ){
				LOGGER.info("하루 예약 가능 수를 초과했습니다.(G)");
				return false;
			}
		
			LOGGER.debug("{} < {}",weeklyGlobalAccumulatedCount, weeklyLimitCount);
			if( weeklyGlobalAccumulatedCount > weeklyLimitCount ){
				LOGGER.info("주별 예약 가능 수를 초과했습니다.(G)");
				return false;
			}
			
			LOGGER.debug("{} < {}",monthlyGlobalAccumulatedCount, monthlyLimitCount);
			if( monthlyGlobalAccumulatedCount > monthlyLimitCount ){
				LOGGER.info("당월 예약 가능 수를 초과했습니다.(G)");
				return false;
			}
			
			/* PP별 누적 횟수 체크 */
			List<EgovMap> ppListCode = reservationCheckerMapper.getPpCodeList();
			
			for (EgovMap ppCode : ppListCode) {
				
				LOGGER.debug("memberReservationCount : {}", memberReservationCount);
				LOGGER.debug("ppListCode : {}", ppCode);
				LOGGER.debug("ppCode.get('ppseq') : {}", ppCode.get("ppseq"));
				
				String ppCodeStringKey = String.valueOf(ppCode.get("ppseq")); 
				EgovMap ppUserReservationCountMap = (EgovMap)((ArrayList)memberReservationCount.get(ppCodeStringKey)).get(0);
				int dailyPpAccumulatedCount = Integer.parseInt(String.valueOf(ppUserReservationCountMap.get("daily")));
				int weeklyPpAccumulatedCount = Integer.parseInt(String.valueOf(ppUserReservationCountMap.get("weekly")));
				int monthlyPpAccumulatedCount = Integer.parseInt(String.valueOf(ppUserReservationCountMap.get("monthly")));
				
				LOGGER.debug("{} < {}", dailyPpAccumulatedCount, dailyLimitCount);
				if( dailyPpAccumulatedCount > dailyLimitCount ){
					LOGGER.info("하루 예약 가능 수를 초과했습니다.");
					return false;
				}
			
				LOGGER.debug("{} < {}", weeklyPpAccumulatedCount, weeklyLimitCount);
				if( weeklyPpAccumulatedCount > weeklyLimitCount ){
					LOGGER.info("주별 예약 가능 수를 초과했습니다.");
					return false;
				}
				
				LOGGER.debug("{} < {}", monthlyPpAccumulatedCount, monthlyLimitCount);
				if( monthlyPpAccumulatedCount > monthlyLimitCount ){
					LOGGER.info("당월 예약 가능 수를 초과했습니다.");
					return false;
				}
				
			}
			
			isRunnable = true;
			
		}

		/* 예약자에 맞는 조건이 한건도 없으면 예약 불가 처리 */
		return isRunnable;
	}

	@Override
	public boolean isReservedRoomSameHuman(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.isReservedRoomSameHuman(requestBox);
	}
	
	@Override
	public boolean isReservedExpSameHuman(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.isReservedExpSameHuman(requestBox);
	}
	
	
	@Override
	public Map<String, String> checkRoomReservationList(RequestBox requestBox, Map<String, String> tupleMap, int selectedCount ) throws Exception {

		Map<String, String> returnObject = new HashMap<String, String>();
		
		/* framework.properties 파일에 설정된 사용자의 예약 가능 시간을 확인한다. */
		if(!this.isAvailableReserveTime()){
			returnObject.put("possibility", "false");
			//returnObject.put("reason", "예약 가능한 시간이 아닙니다.");
			returnObject.put("reason", messageSource.getMessage("rsv.reservationCondition.availableReserveTime"));
			
			return returnObject;
		}
		
		String accountColumnName = "";
		String reservationdateColumnName = "";
		String rsvtypecodeColumnName = "";
		String typeseqColumnName = "";
		String roomseqColumnName = "";
		String ppseqColumnName = "";
		String sessionseqColumnName = "";
		
		/* 개발된 프로그램에서 쓰이는 변수명을 구성 */
		accountColumnName 			= ((String)tupleMap.get("account")).length() > 0 ? (String)tupleMap.get("account") : "account";
		reservationdateColumnName 	= ((String)tupleMap.get("reservationdate")).length() > 0 ? (String)tupleMap.get("reservationdate") : "reservationdate";
		rsvtypecodeColumnName 		= ((String)tupleMap.get("rsvtypecode")).length() > 0 ? (String)tupleMap.get("rsvtypecode") : "rsvtypecode";
		typeseqColumnName 			= ((String)tupleMap.get("typeseq")).length() > 0 ? (String)tupleMap.get("typeseq") : "typeseq";
		roomseqColumnName 			= ((String)tupleMap.get("roomseq")).length() > 0 ? (String)tupleMap.get("roomseq") : "roomseq";
		ppseqColumnName 			= ((String)tupleMap.get("ppseq")).length() > 0 ? (String)tupleMap.get("ppseq") : "ppseq";
		sessionseqColumnName		= ((String)tupleMap.get("sessionseq")).length() > 0 ? (String)tupleMap.get("sessionseq") : "sessionseq";
		
		/* 구성된 변수명의 값을 새로 설정 */
		RequestBox requestBoxNew = null;
		for (int col = 0 ; col < selectedCount ; col++){
			
			requestBoxNew = new RequestBox(new String());
			
			/* account - 한건이면 첫번째 데이터를 활용하도록 했음 */
			if(one < requestBox.getVector(accountColumnName).size()){
				requestBoxNew.put("account", (String) requestBox.getVector(accountColumnName).get(col));
			}else{
				requestBoxNew.put("account", (String) requestBox.getVector(accountColumnName).get(0));
			}
			
			/* 예약타입 - 값이 없으면, 체성분이므로 R02를 고정값으로 설정하도록 했음 */
			if(0 == requestBox.getVector(rsvtypecodeColumnName).size()){
				requestBoxNew.put("rsvtypecode", "R01");
			}else{
				requestBoxNew.put("rsvtypecode", (String) requestBox.getVector(rsvtypecodeColumnName).get(col));
			}
			
			/* 예약일 - 최종 넘겨주는 데이터는 yyyymmdd형태이므로, 8자리 이상이면 데이터를 yyyymmdd형태로 변형 하도록 했음 */
			String reservationDate = (String)requestBox.getVector(reservationdateColumnName).get(col);
			if(eight < reservationDate.length()){
				requestBoxNew.put("reservationdate", reservationDate.replaceAll("-", "").substring(0,8));
			}else{
				requestBoxNew.put("reservationdate", reservationDate);
			}
			requestBoxNew.put("typeseq", (String) requestBox.getVector(typeseqColumnName).get(col));
			requestBoxNew.put("roomseq", (String) requestBox.getVector(roomseqColumnName).get(col));
			requestBoxNew.put("ppseq", (String) requestBox.getVector(ppseqColumnName).get(col));
			requestBoxNew.put("sessionseq", (String) requestBox.getVector(sessionseqColumnName).get(col));
			
			Map<String, String> resultMap = checkRoomReservation(requestBoxNew);
			if("false".equals(resultMap.get("possibility"))){
				return resultMap;
			}
		}
		
		returnObject.put("possibility", "true");
		
		return returnObject;
	}
	
	/**
	 * <pre>
	 * 시설 예약 가능여부 확인 기능
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> checkRoomReservation(RequestBox requestBox) throws Exception {
		
		Map<String, String> returnMapObject = new HashMap<String, String>();
		
		/* 패널티 조건 확인 */
		if(!this.isPossiblePenaltyRange(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.penaltyRange"));
			return returnMapObject;
		}

		/* 예약 가능일인지 확인 : 시설 운영 기간 */
		if(!this.isPossibleFromDayToDay(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.fromDayToDay"));
			return returnMapObject;
		}
		
		/* 예약 가능일인지 확인 : 특정 운영일 or 특정 휴무일 */
		if(!this.isPossibleDay(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.possibleDay"));
			return returnMapObject;
		}
		
		/* 다른 사용자에 의한 예약 선점 확인 */
		if(!this.isPossibleRoomAnotherReservation(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));
			return returnMapObject;
		}

		/* 예약 자격 확인 : pin, 지역, 나이 */
		/* 복잡한 이유로 삭제됨 - 2016/11/09 - alscure
		if(!this.isPossibleRoomRole(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.role"));
			return returnMapObject;
		}
		*/
		
		/* 동일한 room으로 운영이 되는 시설을 확인 후 예약정보가 있는지 확인 */
		if(!this.isPossibleSessionBySameRoom(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.sameRoom"));
			return returnMapObject;
		}
		
		/* 요리명장  */
		if(!this.isPossibleLimitCountQueenByVip(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.noCoupon"));
			return returnMapObject;
		}
		
		/* 광주예외케이스 */
		/*if(!this.isPossibleGwangjuReservation(requestBox)){
			returnMapObject.put("possible", "false");
			returnMapObject.put("reason", "");
			return returnMapObject;
		}*/
		
		/* 대전예외케이스 */
		/*if(!this.isPossibleDaejeonReservation(requestBox)){
			returnMapObject.put("possible", "false");
			returnMapObject.put("reason", "");
			return returnMapObject;
		}*/

		/* 본인 예약건에 대한 대기신청 확인 */
		if(!this.isReservedRoomSameHuman(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.reservedSameHuman"));
			return returnMapObject;
		}
		
		returnMapObject.put("possibility", "true");
		
		return returnMapObject;
	}
	
	/**
	 * 
	 * @param requestBox
	 * @param entityArr - 대상 컬럼 mappingObject
	 * @param selectedCount - 데이터 건수 object.size()
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> checkExpReservationList(RequestBox requestBox, Map<String, String> tupleMap, int selectedCount) throws Exception {
		
		Map<String, String> returnObject = new HashMap<String, String>();
		
		/* framework.properties 파일에 설정된 사용자의 예약 가능 시간을 확인한다. */
		if(!this.isAvailableReserveTime()){
			returnObject.put("possibility", "false");
			//returnObject.put("reason", "예약 가능한 시간이 아닙니다.");
			returnObject.put("reason", messageSource.getMessage("rsv.reservationCondition.availableReserveTime"));
			return returnObject;
		}
		
		String accountColumnName = "";
		String reservationdateColumnName = "";
		String rsvtypecodeColumnName = "";
		String typeseqColumnName = "";
		String expseqColumnName = "";
		String ppseqColumnName = "";
		String sessionseqColumnName = "";
		
		/* 개발된 프로그램에서 쓰이는 변수명을 구성 */
		accountColumnName 			= ((String)tupleMap.get("account")).length() > 0 ? (String)tupleMap.get("account") : "account";
		reservationdateColumnName 	= ((String)tupleMap.get("reservationdate")).length() > 0 ? (String)tupleMap.get("reservationdate") : "reservationdate";
		rsvtypecodeColumnName 		= ((String)tupleMap.get("rsvtypecode")).length() > 0 ? (String)tupleMap.get("rsvtypecode") : "rsvtypecode";
		typeseqColumnName 			= ((String)tupleMap.get("typeseq")).length() > 0 ? (String)tupleMap.get("typeseq") : "typeseq";
		expseqColumnName 			= ((String)tupleMap.get("expseq")).length() > 0 ? (String)tupleMap.get("expseq") : "expseq";
		ppseqColumnName 			= ((String)tupleMap.get("ppseq")).length() > 0 ? (String)tupleMap.get("ppseq") : "ppseq";
		sessionseqColumnName		= ((String)tupleMap.get("sessionseq")).length() > 0 ? (String)tupleMap.get("sessionseq") : "sessionseq";
		
		/* 구성된 변수명의 값을 새로 설정 */
		RequestBox requestBoxNew = null;
		for (int col = 0 ; col < selectedCount ; col++){
			
			requestBoxNew = new RequestBox(new String());
			
			/* account - 한건이면 첫번째 데이터를 활용하도록 했음 */
			if(one < requestBox.getVector(accountColumnName).size()){
				requestBoxNew.put("account", (String) requestBox.getVector(accountColumnName).get(col));
			}else{
				requestBoxNew.put("account", (String) requestBox.getVector(accountColumnName).get(0));
			}
			
			/* 예약타입 - 값이 없으면, 체성분이므로 R02를 고정값으로 설정하도록 했음 */
			if(0 == requestBox.getVector(rsvtypecodeColumnName).size()){
				requestBoxNew.put("rsvtypecode", "R02");
			}else{
				requestBoxNew.put("rsvtypecode", (String) requestBox.getVector(rsvtypecodeColumnName).get(col));
			}
			
			/* 예약일 - 최종 넘겨주는 데이터는 yyyymmdd형태이므로, 8자리 이상이면 데이터를 yyyymmdd형태로 변형 하도록 했음 */
			String reservationDate = (String)requestBox.getVector(reservationdateColumnName).get(col);
			if(eight < reservationDate.length()){
				requestBoxNew.put("reservationdate", reservationDate.replaceAll("-", "").substring(0,8));
			}else{
				requestBoxNew.put("reservationdate", reservationDate);
			}
			requestBoxNew.put("typeseq", (String) requestBox.getVector(typeseqColumnName).get(col));
			requestBoxNew.put("expseq", (String) requestBox.getVector(expseqColumnName).get(col));
			requestBoxNew.put("ppseq", (String) requestBox.getVector(ppseqColumnName).get(col));
			requestBoxNew.put("sessionseq", (String) requestBox.getVector(sessionseqColumnName).get(col));
			
			Map<String, String> resultMap = checkExpReservation(requestBoxNew);
			if("false".equals(resultMap.get("possibility"))){
				return resultMap;
			}
		}
		
		returnObject.put("possibility", "true");
		
		return returnObject;
	}
	
	@Override
	public Map<String, String> checkExpReservation(RequestBox requestBox) throws Exception {
		
		Map<String, String> returnMapObject = new HashMap<String, String>();
		
		/* 패널티 조건 확인 */
		if(!this.isPossiblePenaltyRange(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.penaltyRange"));
			return returnMapObject;
		}

		/* 예약 가능일인지 확인 : 시설 운영 기간 */
		if(!this.isPossibleFromDayToDay(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.fromDayToDay"));
			return returnMapObject;
		}
		
		/* 예약 가능일인지 확인 : 특정 운영일 or 특정 휴무일 */
		if(!this.isPossibleDay(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.possibleDay"));
			return returnMapObject;
		}
		
		/* 다른 사용자에 의한 예약 선점 확인 */
		if(!this.isPossibleExpAnotherReservation(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));
			return returnMapObject;
		}
		
		/* 예약 자격 확인 : pin, 지역, 나이 */
		/* 복잡한 이유로 삭제됨 - 2016/11/09 - alscure
		if(!this.isPossibleExpRole(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.role"));
			return returnMapObject;
		}
		*/
		
		/* 본인 예약건에 대한 대기신청 확인 */
		if(!this.isReservedExpSameHuman(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.reservationCondition.reservedSameHuman"));
			return returnMapObject;
		}
		
		returnMapObject.put("possibility", "true");
		
		return returnMapObject;
	}

	@Override
	public Map<String, String> getRsvAvailabilityCount(RequestBox requestBox) throws Exception {
		return reservationCheckerMapper.getRsvAvailabilityCount(requestBox);
	}

	@Override
	public boolean rsvAvailabilityCheck(RequestBox requestBox) throws Exception {
		LOGGER.debug("invoke ReservationCheckerService.rsvAvailabilityCheck");
		LOGGER.debug("requestBox : {}", requestBox);
		
		/* 누적 예약 횟수 조회(일, 주, 월) */
		Map<String, String> getRsvAvailabilityCountMap = reservationCheckerMapper.getRsvAvailabilityCount(requestBox);
		LOGGER.debug("getRsvAvailabilityCountMap : {}", getRsvAvailabilityCountMap);
		
		/* 요리명장 구분코드 조회 */
		String cookMasterCode = reservationCheckerMapper.getCookMasterCode();
		
		/* 특정 교육장  ppseq조회 [광주 AP] _ 광주 AP는 건물 전체를 파티션룸 개념으로 사용하기 때문에 예약 횟수 쿼리를 따로 체크한다. -->  current pp 를 이용한다. */
		String specialPpseq = reservationCheckerMapper.getSpecialPpseq(requestBox);
		LOGGER.debug("specialPpseq : {}", specialPpseq);
		
		specialPpseq = ( null == specialPpseq ) ? "" : specialPpseq;
		
		
		if(null == getRsvAvailabilityCountMap){
			return false;
		}
		
		/* pp 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i)
						.equals(requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppDailyCount++;
				}
			}
			LOGGER.debug("ppDailyCount : {}", ppDailyCount);
			
			/* 동일 일자 PP 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회] */
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppDailyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpDailyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				ppDailyCount += reservationCheckerMapper.rsvAvailabilityPpDailyCheck(requestBox);
			}
			
			LOGGER.debug("ppDailyCount : {}", ppDailyCount);
			if(null != getRsvAvailabilityCountMap.get("ppdailycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppdailycount"))) < ppDailyCount){
				return false;
			}
			
		}
		
		/* pp 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 주 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppWeeklyCount++;
				}
			}
			LOGGER.debug("ppWeeklyCount : {}", ppWeeklyCount);
			
			/* 동일 주 pp 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회]*/
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppWeeklyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpWeeklyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				ppWeeklyCount += reservationCheckerMapper.rsvAvailabilityPpWeeklyCheck(requestBox);
			}
			
			LOGGER.debug("ppWeeklyCount : {}", ppWeeklyCount);
			if(null != getRsvAvailabilityCountMap.get("ppweeklycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppweeklycount"))) < ppWeeklyCount){
				return false;
			}
			
		}
		
		/* pp 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 월 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppMonthlyCount++;
				}
			}
			LOGGER.debug("ppMonthlyCount : {}", ppMonthlyCount);
			
			/* 동일 월 해당 pp 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회]*/
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppMonthlyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpMonthlyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				ppMonthlyCount += reservationCheckerMapper.rsvAvailabilityPpMonthlyCheck(requestBox);
			}
			
			LOGGER.debug("ppMonthlyCount : {}", ppMonthlyCount);
			if(null != getRsvAvailabilityCountMap.get("ppmonthlycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppmonthlycount"))) < ppMonthlyCount){
				return false;
			}
			
		}
		
		/* global 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i)
						.equals(requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalDailyCount++;
				}
			}
			LOGGER.debug("globalDailyCount : {}", globalDailyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회]*/
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalDailyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpGlobalDailyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				globalDailyCount += reservationCheckerMapper.rsvAvailabilityGlobalDailyCheck(requestBox);
			}
			
			LOGGER.debug("globalDailyCount : {}", globalDailyCount);
			if(null != getRsvAvailabilityCountMap.get("globaldailycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globaldailycount"))) < globalDailyCount){
				return false;
			}
			
		}
		
		/* global 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalWeeklyCount++;
				}
			}
			LOGGER.debug("globalWeeklyCount : {}", globalWeeklyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회]*/
			if(specialPpseq.equals(requestBox.get("ppseq"))){//특정 교육장[광주AP]
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalWeeklyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpGlobalWeeklyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				globalWeeklyCount += reservationCheckerMapper.rsvAvailabilityGlobalWeeklyCheck(requestBox);
			}
			
			LOGGER.debug("globalWeeklyCount : {}", globalWeeklyCount);
			if(null != getRsvAvailabilityCountMap.get("globalweeklycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globalweeklycount"))) < globalWeeklyCount){
				return false;
			}
			
		}
		
		/* global 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건 pass */
			if(!requestBox.getVector("cookMasterCode").isEmpty()
					&& null != requestBox.getVector("cookMasterCode").get(i)
					&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					
					/* 요리명장 무료쿠폰 사용 예약건 pass */
					if(!requestBox.getVector("cookMasterCode").isEmpty()
							&& null != requestBox.getVector("cookMasterCode").get(j)
							&& (cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalMonthlyCount++;
				}
			}
			LOGGER.debug("globalMonthlyCount : {}", globalMonthlyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			/* 특정 교육장 [특정 ap일 경우 예약 횟수 체크 쿼리 따로 조회]*/
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalMonthlyCount += reservationCheckerMapper.rsvAvailabilitySpecialPpGlobalMonthlyCheck(requestBox);
			}else{
				/* 일반 교육장 */
				LOGGER.debug("general pp");
				globalMonthlyCount += reservationCheckerMapper.rsvAvailabilityGlobalMonthlyCheck(requestBox);
			}
			
			LOGGER.debug("globalMonthlyCount : {}", globalMonthlyCount);
			if(null != getRsvAvailabilityCountMap.get("globalmonthlycount")
					&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globalmonthlycount"))) < globalMonthlyCount){
				return false;
			}
			
		}
		
		return true;
	}
	
	/**   
	* 날짜의 주차를 구한다.   
	*    
	* @param YYYYMMDD 일자   
	*    
	* @return 주차   
	*/  
	public int getDateOfWeek(String date) {
		
	   int year = Integer.parseInt(date.substring(0, 4));
	   int month = Integer.parseInt(date.substring(4, 6)) - 1;
	   int day = Integer.parseInt(date.substring(6, 8));
	   
	   Calendar destDate = Calendar.getInstance();
	   
	   destDate.set(year, month, day);
	   
	   return destDate.get(Calendar.WEEK_OF_MONTH);  
	}

	@Override
	public boolean expBrandRsvAvailabilityCheck(RequestBox requestBox) throws Exception {

		List<Map<String, String>> getRsvAvailabilityCountList = new ArrayList<Map<String,String>>();
		
		RequestBox tempRequestBox = new RequestBox(new String());
		
		for(int i = 0; i < requestBox.getVector("typeSeq").size(); i++){
			tempRequestBox.put("typeSeq", requestBox.getVector("typeSeq").get(i));
			tempRequestBox.put("reservationDate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			tempRequestBox.put("typeseq", requestBox.getVector("typeseq").get(0));
			tempRequestBox.put("ppseq", requestBox.getVector("ppseq").get(0));
			tempRequestBox.put("account", requestBox.getVector("account").get(0));
			
			/* 누적 예약 횟수 조회(일, 주, 월) */
			Map<String, String> getRsvAvailabilityCountMap = reservationCheckerMapper.getRsvAvailabilityCount(tempRequestBox);
			
			if(null == getRsvAvailabilityCountMap){
				return false;
			}
			
			getRsvAvailabilityCountList.add(getRsvAvailabilityCountMap);
		}
		
		/* pp 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int ppDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i).equals(requestBox.getVector("reservationDate").get(j))){
					ppDailyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			ppDailyCount += reservationCheckerMapper.rsvAvailabilityPpDailyCheck(tempRequestBox);
			
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				
				LOGGER.debug(" ppdailycount {}", getRsvAvailabilityCountMap.get("ppdailycount"));
				
				if(null != getRsvAvailabilityCountMap.get("ppdailycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppdailycount"))) < ppDailyCount){
					return false;
				}
			}
			
			
		}
		
		/* pp 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int ppWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					ppWeeklyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			ppWeeklyCount += reservationCheckerMapper.rsvAvailabilityPpWeeklyCheck(tempRequestBox);
			
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				if(null != getRsvAvailabilityCountMap.get("ppweeklycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppweeklycount"))) < ppWeeklyCount){
					return false;
				}
			}
			
			
		}
		
		/* pp 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int ppMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					ppMonthlyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			ppMonthlyCount += reservationCheckerMapper.rsvAvailabilityPpMonthlyCheck(tempRequestBox);
			
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				if(null != getRsvAvailabilityCountMap.get("ppmonthlycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("ppmonthlycount"))) < ppMonthlyCount){
					return false;
				}
			}
			
		}
		
		/* global 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int globalDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i)
						.equals(requestBox.getVector("reservationDate").get(j))){
					globalDailyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			
			globalDailyCount += reservationCheckerMapper.rsvAvailabilityGlobalDailyCheck(tempRequestBox);
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				
				LOGGER.debug(" globaldailycount {}", getRsvAvailabilityCountMap.get("globaldailycount"));
				
				if(null != getRsvAvailabilityCountMap.get("globaldailycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globaldailycount"))) < globalDailyCount){
					return false;
				}
			}
			
		}
		
		/* global 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int globalWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					globalWeeklyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			globalWeeklyCount += reservationCheckerMapper.rsvAvailabilityGlobalWeeklyCheck(tempRequestBox);
			
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				
				if(null != getRsvAvailabilityCountMap.get("globalweeklycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globalweeklycount"))) < globalWeeklyCount){
					return false;
				}
			}
			
			
		}
		
		/* global 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			int globalMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					globalMonthlyCount++;
				}
			}
			
			/* 동일 일자 예약 횟수 조회 */
			tempRequestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
			
			globalMonthlyCount += reservationCheckerMapper.rsvAvailabilityGlobalMonthlyCheck(tempRequestBox);
			
			for(Map<String, String> getRsvAvailabilityCountMap : getRsvAvailabilityCountList){
				
				if(null != getRsvAvailabilityCountMap.get("globalmonthlycount")
						&& Integer.parseInt(String.valueOf(getRsvAvailabilityCountMap.get("globalmonthlycount"))) < globalMonthlyCount){
					return false;
				}
			}
			
			
		}
		
		return true;
		
	}

	@Override
	public boolean cookMasterRsvAvailabilityCheck(RequestBox requestBox) throws Exception {
		LOGGER.debug("invoke ReservationChecker.cookMasterRsvAvailabilityCheck");
		LOGGER.debug("requestBox : {}", requestBox);
		
		/* 요리명장 누적 예약 횟수 조회(일, 주, 월) */
		Map<String, String> getCookMasterRsvAvailabilityCountMap = reservationCheckerMapper.getCookMasterRsvAvailabilityCount(requestBox);
		
		/* 요리명장 구분코드 조회 */
		String cookMasterCode = reservationCheckerMapper.getCookMasterCode();
		
		/* 특정 교육장  ppseq조회 [광주 AP]_광주 교육장은 건물 전체를 파티션 룸 개념으로 사용하기 때문에 예약 횟수 체크를 따로 한다. -->   current pp 를 이용한다. */
		String specialPpseq = reservationCheckerMapper.getSpecialPpseq(requestBox);
		LOGGER.debug("specialPpseq : {}", specialPpseq);
		
		specialPpseq = ( null == specialPpseq ) ? "" : specialPpseq;
		
		
		int cookMasterCnt = 0;
		
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			if((cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				cookMasterCnt++;
			}
		}
		
		if(0 != cookMasterCnt && null == getCookMasterRsvAvailabilityCountMap){
			return false;
		}
		
		/* pp 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i)
						.equals(requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppDailyCount++;
				}
			}
			LOGGER.debug("ppDailyCount : {}", ppDailyCount);
			
			/* 동일 일자 PP 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppDailyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpDailyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				ppDailyCount += reservationCheckerMapper.rsvCookMasterAvailabilityPpDailyCheck(requestBox);
			}
			
			LOGGER.debug("ppDailyCount : {}", ppDailyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("ppdailycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("ppdailycount"))) < ppDailyCount){
				return false;
			}
			
		}
		
		/* pp 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 주 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppWeeklyCount++;
				}
			}
			LOGGER.debug("ppWeeklyCount : {}", ppWeeklyCount);
			
			/* 동일 주 pp 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppWeeklyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpWeeklyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				ppWeeklyCount += reservationCheckerMapper.rsvCookMasterAvailabilityPpWeeklyCheck(requestBox);
			}
			
			LOGGER.debug("ppWeeklyCount : {}", ppWeeklyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("ppweeklycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("ppweeklycount"))) < ppWeeklyCount){
				return false;
			}
			
		}
		
		/* pp 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int ppMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 월 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					ppMonthlyCount++;
				}
			}
			LOGGER.debug("ppMonthlyCount : {}", ppMonthlyCount);
			
			/* 동일 월 해당 pp 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				ppMonthlyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpMonthlyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				ppMonthlyCount += reservationCheckerMapper.rsvCookMasterAvailabilityPpMonthlyCheck(requestBox);
			}
			
			LOGGER.debug("ppMonthlyCount : {}", ppMonthlyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("ppmonthlycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("ppmonthlycount"))) < ppMonthlyCount){
				return false;
			}
			
		}
		
		/* global 기준 일 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalDailyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(requestBox.getVector("reservationDate").get(i)
						.equals(requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalDailyCount++;
				}
			}
			LOGGER.debug("globalDailyCount : {}", globalDailyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalDailyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpGlobalDailyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				globalDailyCount += reservationCheckerMapper.rsvCookMasterAvailabilityGlobalDailyCheck(requestBox);
			}
			
			LOGGER.debug("globalDailyCount : {}", globalDailyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("globaldailycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("globaldailycount"))) < globalDailyCount){
				return false;
			}
			
		}
		
		/* global 기준 주 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalWeeklyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(getDateOfWeek((String)requestBox.getVector("reservationDate").get(i)) 
						== getDateOfWeek((String)requestBox.getVector("reservationDate").get(j))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalWeeklyCount++;
				}
			}
			LOGGER.debug("globalWeeklyCount : {}", globalWeeklyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalWeeklyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpGlobalWeeklyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				globalWeeklyCount += reservationCheckerMapper.rsvCookMasterAvailabilityGlobalWeeklyCheck(requestBox);
			}
			
			LOGGER.debug("globalWeeklyCount : {}", globalWeeklyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("globalweeklycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("globalweeklycount"))) < globalWeeklyCount){
				return false;
			}
			
		}
		
		/* global 기준 월 단위 예약 가능 체크 */
		for(int i = 0 ; i < requestBox.getVector("typeSeq").size() ; i++){
			
			/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
			if(null == requestBox.getVector("cookMasterCode").get(i)
					|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(i))){
				continue;
			}
			
			int globalMonthlyCount = 0;
			
			/* 요청된 예약 중 같은 일 예약건 카운트 */
			for(int j = 0 ; j < requestBox.getVector("typeSeq").size() ; j++){
				if(((String)requestBox.getVector("reservationDate").get(i)).substring(4, 6)
						.equals(((String)requestBox.getVector("reservationDate").get(j)).substring(4, 6))){
					
					/* 요리명장 무료쿠폰 사용 예약건이 아니면 pass */
					if(null == requestBox.getVector("cookMasterCode").get(j)
							|| !(cookMasterCode).equals(requestBox.getVector("cookMasterCode").get(j))){
						continue;
					}
					
					globalMonthlyCount++;
				}
			}
			LOGGER.debug("globalMonthlyCount : {}", globalMonthlyCount);
			
			/* 동일 일자 예약 횟수 조회 */
			requestBox.put("reservationdate", requestBox.getVector("reservationDate").get(i));
			
			if(specialPpseq.equals(requestBox.get("ppseq"))){
				/* 특정 교육장 */
				LOGGER.debug("special pp");
				globalMonthlyCount += reservationCheckerMapper.rsvCookMasterAvailabilitySpecialPpGlobalMonthlyCheck(requestBox);
			}else{
				/* 일반교육장 */
				LOGGER.debug("general pp");
				globalMonthlyCount += reservationCheckerMapper.rsvCookMasterAvailabilityGlobalMonthlyCheck(requestBox); 
			}
			
			LOGGER.debug("globalMonthlyCount : {}", globalMonthlyCount);
			if(null != getCookMasterRsvAvailabilityCountMap.get("globalmonthlycount")
					&& Integer.parseInt(String.valueOf(getCookMasterRsvAvailabilityCountMap.get("globalmonthlycount"))) < globalMonthlyCount){
				return false;
			}
			
		}
		
		return true;
	}

	@Override
	public boolean rsvMiddlePenaltyCheck(RequestBox requestBox) throws Exception {
		
		RequestBox requestBoxNew = null;
		for (int col = 0 ; col < requestBox.getVector("typeSeq").size() ; col++){
			
			requestBoxNew = new RequestBox(new String());
			
			/* account - 한건이면 첫번째 데이터를 활용하도록 했음 */
			if(one < requestBox.getVector("account").size()){
				requestBoxNew.put("account", (String) requestBox.getVector("account").get(col));
			}else{
				requestBoxNew.put("account", (String) requestBox.getVector("account").get(0));
			}
			
			/* 예약일 - 최종 넘겨주는 데이터는 yyyymmdd형태이므로, 8자리 이상이면 데이터를 yyyymmdd형태로 변형 하도록 했음 */
			String reservationDate = (String)requestBox.getVector("reservationDate").get(col);
			if(eight < reservationDate.length()){
				requestBoxNew.put("reservationdate", reservationDate.replaceAll("-", "").substring(0,8));
			}else{
				requestBoxNew.put("reservationdate", reservationDate);
			}
			requestBoxNew.put("typeseq", (String) requestBox.getVector("typeSeq").get(col));
			
			if(!isPossiblePenaltyRange(requestBoxNew)){
				return false;
			}
		}
		
		return true;
	}
	
	
	@Override
	public EgovMap getReservationPriceBySessionSeq(Map requestMap) throws Exception {
		return reservationCheckerMapper.getReservationPriceBySessionSeq(requestMap);
	}
	
}
