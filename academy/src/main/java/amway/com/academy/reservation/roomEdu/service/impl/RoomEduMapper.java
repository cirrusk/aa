package amway.com.academy.reservation.roomEdu.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomEduMapper {

	/**
	 * 시설 키값 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Integer> searchRsvRoomTypeSeq(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 시설 예약 타입 PP 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> ppRsvRoomCodeList(RequestBox  requestBox) throws Exception;

	/**
	 * 마지막 예약 pp정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String searchLastRsvRoomPp(RequestBox requestBox) throws Exception;

	/**
	 * 교육장 예약 해당 pp의 시설(룸) 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> rsvRoomInfoList(RequestBox requestBox) throws Exception;

	/**
	 * 해당 시설의 정원, 이용시간, 예약자격, 부대시설 등을 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomEduRsvRoomDetailInfo(RequestBox requestBox) throws Exception;

	/**
	 * 해당 월 달력 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomEduCalendar(RequestBox requestBox) throws Exception;

	/**
	 * 년, 월  조회(jsp에서 클래스 명으로 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomEduYearMonth(RequestBox requestBox) throws Exception;

	/**
	 * 오늘 날짜 조회
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomEduToday() throws Exception;

	/**
	 * 날짜별 예약 정보(남은예약카운트, 예약마감 유무, 휴무일) 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomEduReservationInfoList(RequestBox requestBox) throws Exception;

	/**
	 * 선택 날짜에 세션 시간 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomEduSeesionList(RequestBox requestBox) throws Exception;

	/**
	 * 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomEduPaymentCheck(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약 등록
	 * @param map
	 * @throws Exception
	 */
	public void roomEduReservationInsert(HashMap<String, String> map) throws Exception;

	/**
	 * 시설 결제 이력정보 등록
	 * @param map
	 * @throws Exception
	 */
	public void roomEduPayMentInsert(HashMap<String, String> map) throws Exception;

	/**
	 * 날짜별 예약 정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomReservationInfoList(RequestBox requestBox) throws Exception;

	/**
	 * 해당 날짜 시설 예약 정보 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> roomDayReservationList(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 년, 월 시설 예약 정보 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> roomMonthReservationList(RequestBox requestBox) throws Exception;

	/**
	 * 해당 room 이 다목적룸인지 맞으면 설정된 예약타입 정보 조회(typeseq)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> multipurposeRoomCheck(RequestBox requestBox) throws Exception;


	public List<Map<String, String>> partitionRoomSeqList(RequestBox requestBox) throws Exception;

	public List<Map<String, String>> partitionRoomParentSeqList(RequestBox requestBox) throws Exception;

	public String partitionCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
}
