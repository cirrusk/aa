package amway.com.academy.manager.common.batchResult.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface BatchResultService {

	/**
	 * 배치결과로그 배치네임
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> batchResultNameList(RequestBox requestBox) throws Exception;

	/**
	 * 배치결과로그 리스트
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> batchResultList(RequestBox requestBox) throws Exception;

	/**
	 * 배치결과로그 리스트 카운트
	 * @param requestBox
	 * @throws Exception
	 */
	public int batchResultListCount(RequestBox requestBox) throws Exception;

}