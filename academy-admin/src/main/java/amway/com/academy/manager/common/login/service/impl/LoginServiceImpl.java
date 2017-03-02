package amway.com.academy.manager.common.login.service.impl;

import java.net.Inet4Address;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.login.service.LoginService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginMapper loginMapper;
	
	@Override
	public int loginMergeManager(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		result = loginMapper.loginMergeManager(requestBox);
		
		return result;
	}
	
	
	@Override
	public List<DataBox> selectManagerAuthList(RequestBox requestBox) throws Exception {
		return loginMapper.selectManagerAuthList(requestBox);
	}

	@Override
	public int loginLogInsert(RequestBox requestBox) throws Exception {

		int result = 0;
		String conIp = Inet4Address.getLocalHost().getHostAddress();

		requestBox.put("conip", conIp);

		result = loginMapper.loginLogInsert(requestBox);

		return result;
	}
}
