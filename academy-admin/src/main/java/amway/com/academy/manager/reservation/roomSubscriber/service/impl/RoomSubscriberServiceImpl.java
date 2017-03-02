package amway.com.academy.manager.reservation.roomSubscriber.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.roomSubscriber.service.RoomSubscriberService;

@Service
public class RoomSubscriberServiceImpl implements RoomSubscriberService {
	@Autowired
	private RoomSubscriberMapper roomSubscriberDAO;

	@Override
	public List<DataBox> roomSubscriberListAjax(RequestBox requestBox) throws Exception {
		
//		roomSubscriberDAO.beforSearchRoomPaymentStatuscodeUpdate(requestBox);
		
		return roomSubscriberDAO.roomSubscriberListAjax(requestBox);
	}

	@Override
	public int roomSubscriberListCount(RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.roomSubscriberListCount(requestBox);
	}

	@Override
	public int noShowCodeUpdateAjax(RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.noShowCodeUpdateAjax(requestBox);
	}

	@Override
	public int adminRoomCancelAjax(RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.adminRoomCancelAjax(requestBox);
	}

	@Override
	public int roomUseCompletionAjax(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

//	@Override
//	public List<DataBox> searchRoomTypeAjax(RequestBox requestBox) throws Exception {
//		return roomSubscriberDAO.searchRoomTypeAjax(requestBox);
//	}

	@Override
	public int noShowRoomPenaltyInsert(RequestBox requestBox) throws Exception {
		
		/*		
 		if("R02".equals(requestBox.get("noshowcode"))){
			if(1 == roomSubscriberDAO.noShowRoomPenaltyOnCount(requestBox)){
				 패널티 부여 
				roomSubscriberDAO.noShowRoomPenaltyInsert(requestBox);
			}
		}else{
			if(0 != roomSubscriberDAO.noShowRoomPenaltyOffCount(requestBox)){
				 부여한 패널티 삭제 
				roomSubscriberDAO.noShowRoomPenaltyInsert(requestBox);
			}
		}
		*/
		
		/* 패널티 히스토리 테이블에 패널티 부여 및 취소 데이터 추가 */
		if("R02".equals(requestBox.get("noshowcode"))){
			/* 지정 */
			requestBox.put("penaltystatuscode","B01");
		}else{
			/* 해제 */
			requestBox.put("penaltystatuscode","B02");
		}
		return roomSubscriberDAO.noShowRoomPenaltyInsert(requestBox);
	}

	@Override
	public DataBox roomRefundHistory(RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.roomRefundHistory(requestBox);
	}

	@Override
	public List<DataBox> searchRoomTypeCodeList(RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.searchRoomTypeCodeList(requestBox);
	}

	@Override
	public List<Map<String, String>> roomSubscriberExcelDownload( RequestBox requestBox) throws Exception {
		return roomSubscriberDAO.roomSubscriberExcelDownload(requestBox);
	}

}
