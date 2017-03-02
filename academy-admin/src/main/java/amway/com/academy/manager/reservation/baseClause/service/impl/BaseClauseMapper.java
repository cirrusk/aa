package amway.com.academy.manager.reservation.baseClause.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BaseClauseMapper {

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
	 * 약관 관리  등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseClauseInsertAjax(RequestBox requestBox) throws Exception;
	
	public DataBox baseClauseDatail(RequestBox requestBox) throws Exception;;
	
	public int baseClauseUpdate(RequestBox requestBox) throws Exception;
}
