package amway.com.academy.manager.reservation.basePenalty.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface BasePenaltyService {

	/**
	 * 패널티 정책 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePenaltyListCountAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 패널티 정책 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> basePenaltyListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 패널티 정책 취소 패널티 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePenaltyCencelInsertAjax(RequestBox requestBox) throws Exception;

	/**
	 * 패널티 정책 상세 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox basePenaltyDetailAjax(RequestBox requestBox) throws Exception;

	/**
	 * 패널티 정책 수정
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePenaltyUpdateAjax(RequestBox requestBox) throws Exception;

}
