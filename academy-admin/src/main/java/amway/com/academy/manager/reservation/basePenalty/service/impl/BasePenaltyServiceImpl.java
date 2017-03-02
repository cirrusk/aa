package amway.com.academy.manager.reservation.basePenalty.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.basePenalty.service.BasePenaltyService;

@Service
public class BasePenaltyServiceImpl implements BasePenaltyService {
	
	@Autowired
	private BasePenaltyMapper basePenaltyDAO;
	
	/**
	 * 패널티 정책 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePenaltyListCountAjax(RequestBox requestBox) throws Exception {
		return basePenaltyDAO.basePenaltyListCountAjax(requestBox);
	}

	/**
	 * 패널티 정책 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> basePenaltyListAjax(RequestBox requestBox) throws Exception {
		return basePenaltyDAO.basePenaltyListAjax(requestBox);
	}
	
	/**
	 * 패널티 정책 취소 패널티 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePenaltyCencelInsertAjax(RequestBox requestBox) throws Exception {
		return basePenaltyDAO.basePenaltyCencelInsertAjax(requestBox);
	}

	/**
	 * 패널티 정책 상세 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox basePenaltyDetailAjax(RequestBox requestBox) throws Exception {
		return basePenaltyDAO.basePenaltyDetailAjax(requestBox);
	}

	/**
	 * 패널티 정책 수정
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePenaltyUpdateAjax(RequestBox requestBox) throws Exception {
		return basePenaltyDAO.basePenaltyUpdateAjax(requestBox);
	}

}
