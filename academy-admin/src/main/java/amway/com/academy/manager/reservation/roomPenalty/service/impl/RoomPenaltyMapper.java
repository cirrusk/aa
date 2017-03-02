package amway.com.academy.manager.reservation.roomPenalty.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomPenaltyMapper {

	int roomPenaltyListCountAjax(RequestBox requestBox) throws Exception;

	List<DataBox> roomPenaltyListAjax(RequestBox requestBox) throws Exception;

	DataBox roomPenaltyDetailAjax(RequestBox requestBox) throws Exception;

	int roomPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception;

	List<Map<String, String>> roomPenaltyExcelListSelect(RequestBox requestBox) throws Exception;

}
