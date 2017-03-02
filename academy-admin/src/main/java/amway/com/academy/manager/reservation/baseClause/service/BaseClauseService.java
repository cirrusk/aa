package amway.com.academy.manager.reservation.baseClause.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 약관 관리
 * @author KR620225
 *
 */
public interface BaseClauseService {
	
	/**
	 * 약관 관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> baseClauseListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 약관 관리 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseClauseListCount(RequestBox requestBox) throws Exception;

	/**
	 * 약관 관리 등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseClauseInsertAjax(RequestBox requestBox) throws Exception;
	
	public DataBox baseClauseDatail(RequestBox requestBox) throws Exception;
	
	public int baseClauseUpdate(RequestBox requestBox) throws Exception;
}
