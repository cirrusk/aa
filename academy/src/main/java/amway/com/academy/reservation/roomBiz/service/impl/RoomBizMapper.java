package amway.com.academy.reservation.roomBiz.service.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomBizMapper {
	
	public Map<String, String> roomBizPaymentCheck(RequestBox requestBox) throws Exception;
	
}
