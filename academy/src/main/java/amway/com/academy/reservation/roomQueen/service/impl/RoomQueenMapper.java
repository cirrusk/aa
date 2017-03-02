package amway.com.academy.reservation.roomQueen.service.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface RoomQueenMapper {

	/**
	 * 요리명장 사용가능 쿠폰 갯수 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	Map<String, String> getCookMasterCoupon(RequestBox requestBox) throws Exception;
	
}
