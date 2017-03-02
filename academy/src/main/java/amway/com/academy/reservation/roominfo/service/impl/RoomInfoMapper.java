package amway.com.academy.reservation.roominfo.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomInfoMapper {

	public List<Map<String, String>> roomInfoList(Map<String, Object> map) throws Exception;
	
	public int roomInfoListCount(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> roomInfoDetailList(RequestBox requestBox) throws Exception;
//	
//	public int changePartnertAjax(RequestBox requestBox) throws Exception;
//	
//	public int updateCancelCodeAjax(RequestBox requestBox) throws Exception;
//	
//	public Map<String, String> searchMaxStandByNumber(RequestBox requestBox) throws Exception;
//	
//	public int updateStandByNumber(RequestBox requestBox) throws Exception;

	public List<Map<String, String>> searchRoomPenaltyList(RequestBox requestBox) throws Exception;

	public void insertRoomPenaltyHistory(Map<String, String> penaltyInfo) throws Exception;

	public int updateRoomCancelCodeAjax(RequestBox requestBox) throws Exception;
	
	public Map<String, String> roomInfoRsvInfo(RequestBox requestBox) throws Exception;

	public Map<String, String> roomInfoRsvPaybackInfo(RequestBox requestBox) throws Exception;

	public Map<String, String> selectRoomWaitingInfo(RequestBox requestBox) throws Exception;

	public void updateRoomWaitingInfo(RequestBox requestBox) throws Exception;

	public void deleteRoomReservation(RequestBox requestBox) throws Exception;

	public Map<String, String> searchThreeMonthRoom(RequestBox requestBox) throws Exception;

	public Map<String, String> roomInfoRsvPayCancelPenalty(RequestBox requestBox) throws Exception;

	public Map<String, String> roomInfoRsvFreeCancelPenalty(RequestBox requestBox) throws Exception;

	public Map<String, String> roomInfoRsvCookFreeCancelPenalty(RequestBox requestBox) throws Exception;

	public Map<String, String> searchRoomPayPenalty(RequestBox requestBox) throws Exception;

	public Map<String, String> searchRoomFreePenalty(RequestBox requestBox) throws Exception;

	public Map<String, String> searchRoomCookFreePenalty(RequestBox requestBox) throws Exception;

	public int selectCountItemBackInfo(RequestBox requestBox) throws Exception;
	
	public int insertItemBackInfo(RequestBox requestBox) throws Exception;

}
