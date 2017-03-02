package amway.com.academy.common.commoncode.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;
import java.util.Map;

public interface CommonCodeService {
	
	/**
	 * 공통코드 리스트
	 * @param params
	 * @return
	 * @throws Exception 
	 */
	public List<Map<String, String>> getCodeList(Map<String, String> params);

	public DataBox getAnalyticsTag(RequestBox request);

	public DataBox getCheckVisitor(RequestBox request);

}
