package amway.com.academy.manager.lms.log.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsLogService {

	public DataBox insertLogAjax(RequestBox requestBox) throws Exception;
	
}
