package amway.com.academy.lms.liveedu.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsLiveEduService {

	/**
	 * 라이브교육 시청
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectLiveEduList(RequestBox requestBox) throws Exception;
	
	public void updateFinishProcess(RequestBox requestBox) throws Exception;
	public void updateFinishProcess2(RequestBox requestBox) throws Exception;
	
}
