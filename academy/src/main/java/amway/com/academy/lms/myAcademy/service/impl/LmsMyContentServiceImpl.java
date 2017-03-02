package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.myAcademy.service.LmsMyContentService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMyContentServiceImpl  implements LmsMyContentService{
	@Autowired
	private LmsMyContentMapper lmsMyContentMapper;
	
	@Override
	public int selectLmsSaveLogCount(RequestBox requestBox) throws Exception {
		return lmsMyContentMapper.selectLmsSaveLogCount(requestBox);
	}
	
	@Override
	public List<Map<String, Object>> selectLmsSaveLogList(RequestBox requestBox) throws Exception {
		return lmsMyContentMapper.selectLmsSaveLogList(requestBox);
	}
	
	@Override
	public int deleteLmsSaveLog(RequestBox requestBox) throws Exception {
		return lmsMyContentMapper.deleteLmsSaveLog(requestBox);
	}

}
