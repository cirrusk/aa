package amway.com.academy.manager.common.batchResult.service.impl;

import amway.com.academy.manager.common.batchResult.service.BatchResultService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BatchResultServiceImpl extends EgovAbstractServiceImpl implements BatchResultService {
	@Autowired
	private BatchResultMapper batchResultMapper;

	@Override
	public List<DataBox> batchResultNameList(RequestBox requestBox) throws Exception {
		return batchResultMapper.batchResultNameList(requestBox);
	}

	/**
	 * 배치결과로그 리스트
	 * @param requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	public List<DataBox> batchResultList(RequestBox requestBox) throws Exception {
		return batchResultMapper.batchResultList(requestBox);
	}

	/**
	 * 배치결과로그 카운트
	 * @param requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	@Override
	public int batchResultListCount(RequestBox requestBox) throws Exception {
		return batchResultMapper.batchResultListCount(requestBox);
	}
}