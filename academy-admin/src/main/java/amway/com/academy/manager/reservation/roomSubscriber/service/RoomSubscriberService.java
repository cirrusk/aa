package amway.com.academy.manager.reservation.roomSubscriber.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface RoomSubscriberService {

	/**
	 * 예약자 관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomSubscriberListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomSubscriberListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리_no show 유무 갱신
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowCodeUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리_관리자 예약 취소(코드 갱신)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int adminRoomCancelAjax(RequestBox requestBox)throws Exception;
	
	/**
	 * 예약자 관리_사용완료
	 * 		- 에약일이 XXXX년 XX월 XX일에  XX:XX~XX:XX시간이 지날 경우
	 * 			예약 형태를 사용완료로 갱신(미정)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomUseCompletionAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp의 시설 타입 리스트 조회(셀렉트 박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
//	public List<DataBox> searchRoomTypeAjax(RequestBox requestBox) throws Exception;

	/**
	 * <pre>
	 * 불참(no show) 시설 패널티 등록
	 * - 시설에 관련된 패널티를 PENALTYSETTING 테이블에서 찾은 후 RSVPENALTYHISTORY 테이블에 모두 삽입한다. 
	 * </pre>
	 * @param requestBox [rsvseq,roomseq, typeseq, cookmastercode]
	 * @return
	 * @throws Exception
	 */
	public int noShowRoomPenaltyInsert(RequestBox requestBox) throws Exception;


	public DataBox roomRefundHistory(RequestBox requestBox) throws Exception;

	/**
	 * 룸타입 조회(셀렉트박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> searchRoomTypeCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 엑셀다운로드
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomSubscriberExcelDownload(RequestBox requestBox) throws Exception;
}
