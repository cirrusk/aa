package framework.com.cmm.util;

import framework.com.cmm.lib.RequestBox;

public class PagingUtil {
	/**
	 * 공통 Page Param 처리
	 * @param baseVO
	 * @param request
	 * @param paramMap
	 */
	public static void defaultParmSetting(RequestBox requestBox) {
		if(requestBox != null && requestBox.size() > 0){
			requestBox.put("sortOrderColumn", requestBox.getString("sortColumn"));
			requestBox.put("sortOrderType", requestBox.getString("sortOrder"));
			requestBox.put("firstIndex", requestBox.getInt("firstIndex"));
			requestBox.put("pageIndex", requestBox.getInt("page"));
		}
	}
}