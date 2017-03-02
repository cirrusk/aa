package amway.com.academy.manager.reservation.roomPenalty.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.roomPenalty.service.RoomPenaltyService;

/**
 * @author KR620226
 *
 */
@Service
public class RoomPenaltyServiceImpl implements RoomPenaltyService {
	
	@Autowired
	private RoomPenaltyMapper roomPenaltyDAO;

	/**
	 * 시설 패널티 현황 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomPenaltyListCountAjax(RequestBox requestBox) throws Exception {
		return roomPenaltyDAO.roomPenaltyListCountAjax(requestBox);
	}

	/**
	 * 시설 패널티 현황 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomPenaltyListAjax(RequestBox requestBox) throws Exception {
		return roomPenaltyDAO.roomPenaltyListAjax(requestBox);
	}

	/**
	 * 시설 패널티 현황 상세
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox roomPenaltyDetailAjax(RequestBox requestBox) throws Exception {
		return roomPenaltyDAO.roomPenaltyDetailAjax(requestBox);
	}

	/**
	 * 시설 패널티 해제
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception {
		return roomPenaltyDAO.roomPenaltyCancelLimitUpdateAjax(requestBox);
	}

	/**
	 * 시설 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> roomPenaltyExcelListSelect(RequestBox requestBox) throws Exception {
		return roomPenaltyDAO.roomPenaltyExcelListSelect(requestBox);
	}
	
}
