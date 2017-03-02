package amway.com.academy.manager.reservation.roomSubscriber.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomSubscriberMapper {

	/**
	 * 예약자 관리_리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomSubscriberListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리_리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomSubscriberListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리 no show 유무 갱신
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowCodeUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약자 관리_관리자 예약취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int adminRoomCancelAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp의 시설 타입 조회(셀렉트 박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
//	public List<DataBox> searchRoomTypeAjax(RequestBox requestBox) throws Exception;

	/**
	 * 불참(no show) 시설 패널티 지정 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowRoomPenaltyOnCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 불참(no show) 시설 패널티 해제 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowRoomPenaltyOffCount(RequestBox requestBox) throws Exception;

	/**
	 * 불참(no show) 시설 패널티 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowRoomPenaltyInsert(RequestBox requestBox) throws Exception;
	
	public int beforSearchRoomPaymentStatuscodeUpdate()  throws Exception;

	public DataBox roomRefundHistory(RequestBox requestBox) throws Exception;
	
	public List<DataBox> searchRoomTypeCodeList(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> roomSubscriberExcelDownload(RequestBox requestBox) throws Exception;
}
