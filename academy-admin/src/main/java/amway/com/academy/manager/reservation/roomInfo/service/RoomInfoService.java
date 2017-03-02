package amway.com.academy.manager.reservation.roomInfo.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface RoomInfoService {

	/**
	 * pp별 예약 시설 형태 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomTypeListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 해당 pp 해당 시설타입 년 월 조회
	 * 
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> roomInfoCalendarAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp 해당 시설타입 년 월 별 예약 현황 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomInfoListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약현황 운영자 예약 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 예약현황 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomInfoAdminReservationListInsertAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 예약현황 운영자 예약 취소 화면
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약현황 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomInfoAdminReservationListCancelUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp, 시설, 년, 월, 일 세션 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox roomInfoSessionSelectAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp, 시설, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomInfoSessionListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception;

	/**
	 * 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * 파티션룸 체크 후 조합할 파티션룸 roomseq 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> partitionRoomSeqList(RequestBox requestBox) throws Exception;

}
