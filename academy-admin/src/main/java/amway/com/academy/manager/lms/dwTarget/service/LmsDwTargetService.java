package amway.com.academy.manager.lms.dwTarget.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsDwTargetService {

	int selectLmsDwTargetCount(RequestBox requestBox);
	List<DataBox> selectLmsDwTargetList(RequestBox requestBox);
	
	public int insertDwTargetExcelAjax(RequestBox requestBox, List<Map<String,String>> list) throws Exception;
}
