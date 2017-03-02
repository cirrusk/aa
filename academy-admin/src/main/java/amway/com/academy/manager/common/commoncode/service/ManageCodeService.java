package amway.com.academy.manager.common.commoncode.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface ManageCodeService {
	
	/**
	 * 공통코드 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, String>> getCodeList(Map<String, String> params);
	
	/**
	 * 공통 개인정보 조회 이력 남기기
	 * @param requestBox
	 */
	public void selectCurrentAdNoHistory(RequestBox requestBox);
	
}
