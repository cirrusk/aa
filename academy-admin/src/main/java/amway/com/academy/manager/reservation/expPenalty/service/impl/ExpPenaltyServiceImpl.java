package amway.com.academy.manager.reservation.expPenalty.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.expPenalty.service.ExpPenaltyService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class ExpPenaltyServiceImpl implements ExpPenaltyService {
	
	@Autowired
	private ExpPenaltyMapper expPenaltyDAO;

	/**
	 * 측정/체험 패널티 현황 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expPenaltyListCountAjax(RequestBox requestBox) throws Exception {
		return expPenaltyDAO.expPenaltyListCountAjax(requestBox);
	}

	/**
	 * 측정/체험 패널티 현황 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expPenaltyListAjax(RequestBox requestBox) throws Exception {
		return expPenaltyDAO.expPenaltyListAjax(requestBox);
	}

	/**
	 * 측정/체험 패널티 현황 상세
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox expPenaltyDetailAjax(RequestBox requestBox) throws Exception {
		return expPenaltyDAO.expPenaltyDetailAjax(requestBox);
	}

	/**
	 * 측정/체험 패널티 해제
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception {
		return expPenaltyDAO.expPenaltyCancelLimitUpdateAjax(requestBox);
//		return 0;
	}

	/**
	 * 측정/체험 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> expPenaltyExcelListSelect(RequestBox requestBox) throws Exception {
		return expPenaltyDAO.expPenaltyExcelListSelect(requestBox);
	}
	
}
