package amway.com.academy.manager.reservation.expSubscriber.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.expSubscriber.service.ExpSubscriberService;

@Service
public class ExpSubscriberServiceImpl implements ExpSubscriberService{
	@Autowired
	private ExpSubscriberMapper expSubscriberDAO;

	@Override
	public List<DataBox> expSubscriberListAjax(RequestBox requestBox) throws Exception {
		
//		expSubscriberDAO.beforSearchExpPaymentStatuscodeUpdate(requestBox);
		
		return expSubscriberDAO.expSubscriberListAjax(requestBox);
	}

	@Override
	public int expSubscriberListCount(RequestBox requestBox) throws Exception {
		return expSubscriberDAO.expSubscriberListCount(requestBox);
	}

	@Override
	public int adminExpCancelAjax(RequestBox requestBox) throws Exception {
		return expSubscriberDAO.adminExpCancelAjax(requestBox);
	}

	@Override
	public int expNoShowConfirmChkeck(RequestBox requestBox) throws Exception {
		
		return expSubscriberDAO.expNoShowConfirmChkeck(requestBox);
	}
	
	@Override
	public int noShowExpPenaltyInsert(RequestBox requestBox) throws Exception {
		
		/* 패널티 히스토리 테이블에 패널티 부여 및 취소 데이터 추가 */
		if("R02".equals(requestBox.get("noshowcode"))){
			/* 지정 */
			requestBox.put("penaltystatuscode","B01");
		}else{
			/* 해제 */
			requestBox.put("penaltystatuscode","B02");
		}
		
		return expSubscriberDAO.noShowExpPenaltyInsert(requestBox);
	}

//	@Override
//	public List<DataBox> searchProgramTypeAjax(RequestBox requestBox) throws Exception {
//		return expSubscriberDAO.searchProgramTypeAjax(requestBox);
//	}


	public List<DataBox> searchExpTypeCodeList(RequestBox requestBox) throws Exception{
		return expSubscriberDAO.searchExpTypeCodeList(requestBox);
	}

	@Override
	public List<Map<String, String>> expSubscriberExcelDownload(RequestBox requestBox) throws Exception {
		return expSubscriberDAO.expSubscriberExcelDownload(requestBox);
	}
}
