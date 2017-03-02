package amway.com.academy.manager.reservation.roomInfo.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomInfoMapper {

	public List<DataBox> roomTypeListAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> roomInfoCalendarAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> roomInfoListAjax(RequestBox requestBox) throws Exception;

	public DataBox roomInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception;

	public int roomInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> roomInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception;

	public int roomInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception;

	public DataBox roomInfoSessionSelectAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> roomInfoSessionListAjax(RequestBox requestBox) throws Exception;

	public String partitionCheck(RequestBox requestBox) throws Exception;

	public List<DataBox> partitionRoomSeqList(RequestBox requestBox) throws Exception;

	public List<DataBox> partitionRoomParentSeqList(RequestBox requestBox) throws Exception;
	
}