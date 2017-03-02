package amway.com.academy.manager.common.batchResult.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

@Mapper
public interface BatchResultMapper {

	/**
	 * 배치결과로그 배치네임
	 * @param requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<DataBox> batchResultNameList(RequestBox requestBox) throws Exception;
	/**
	 * 배치결과로그 리스트
	 * @param requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<DataBox> batchResultList(RequestBox requestBox) throws Exception;

	/**
	 * 배치결과로그 리스트 카운트
	 * @param requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	int batchResultListCount(RequestBox requestBox) throws Exception;

}