package amway.com.academy.manager.reservation.expPenalty.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface ExpPenaltyService {

	/**
	 * 측정/체험 패널티 현황 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expPenaltyListCountAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 패널티 현황 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expPenaltyListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 패널티 현황 상세
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox expPenaltyDetailAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 패널티 해제
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expPenaltyExcelListSelect(RequestBox requestBox) throws Exception;

}
