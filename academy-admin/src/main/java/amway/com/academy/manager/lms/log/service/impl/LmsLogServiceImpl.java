package amway.com.academy.manager.lms.log.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.log.service.LmsLogService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsLogServiceImpl implements LmsLogService {

	@Autowired
	private LmsLogMapper lmsLogServiceMapper;
	
	@Override
	public DataBox insertLogAjax(RequestBox requestBox) throws Exception {
		
		DataBox dataBox = new DataBox(); 
		
		int cnt = lmsLogServiceMapper.lmsInsertLogAjax(requestBox);
		requestBox.put("logid",requestBox.get("maxlogid"));
		
		if( cnt > 0 ) {
			dataBox.put("result", "seccess");
			
			dataBox = lmsLogServiceMapper.lmsSelectLog(requestBox);
			
		} else {
			dataBox.put("result", "Fail");
		}
		
		return dataBox;
	}
}
