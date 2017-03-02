package amway.com.academy.manager.common.login.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LoginService {

	public int loginMergeManager(RequestBox requestBox) throws Exception;
	
	public List<DataBox> selectManagerAuthList(RequestBox requestBox) throws Exception;

	public int loginLogInsert(RequestBox requestBox) throws Exception;
}
