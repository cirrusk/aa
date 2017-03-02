package amway.com.academy.manager.reservation.basePlaza.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 
 * pp정보 관리
 * @author KR620226
 *
 */
public interface BasePlazaService {

	/**
	 * pp정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> basePlazaListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * pp정보 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePlazaListCountAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp정보 등록
	 * 
	 * @param requestBox
	 * @throws Exception
	 */
	public int basePlazaInsertAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp 노출순서 지정 팝업
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<?> basePlazaRowChangeListAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp 노출순서 지정
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePlazaRowChangeUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp정보 상세 정보
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox basePlazaDetailAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp정보 수정
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePlazaUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp정보 수정 이력 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> basePlazaHistoryListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * pp정보 수정 이력 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int basePlazaHistoryInsert(RequestBox requestBox) throws Exception;
}
