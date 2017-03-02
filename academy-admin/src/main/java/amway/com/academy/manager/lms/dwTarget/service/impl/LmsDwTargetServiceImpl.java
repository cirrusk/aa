package amway.com.academy.manager.lms.dwTarget.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.dwTarget.service.LmsDwTargetService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsDwTargetServiceImpl implements LmsDwTargetService {
	
	@Autowired
	private LmsDwTargetMapper lmsDwTargetMapper;


	@Override
	public int selectLmsDwTargetCount(RequestBox requestBox) {
		return lmsDwTargetMapper.selectLmsDwTargetCount(requestBox);
	}

	@Override
	public List<DataBox> selectLmsDwTargetList(RequestBox requestBox) {
		return lmsDwTargetMapper.selectLmsDwTargetList(requestBox);
	}
	
	
	@Override
	public int insertDwTargetExcelAjax(RequestBox requestBox, List<Map<String,String>> list) throws Exception {
		
		int cnt = 0;
		
		for( int i=0; i<list.size(); i++ ) {
			Map<String,String> retMap = (Map<String,String>)list.get(i);
			
			requestBox.put("uid", retMap.get("col0"));
			requestBox.put("businessstatuscode1", retMap.get("col1"));
			requestBox.put("businessstatuscode2", retMap.get("col2"));
			requestBox.put("businessstatuscode3", retMap.get("col3"));
			requestBox.put("businessstatuscode4", retMap.get("col4"));
			
			// 추천조건 Merge
			int targetDwCnt = lmsDwTargetMapper.mergeDwTargetExcelAjax(requestBox);
			
			cnt += targetDwCnt;
		}
		
		return cnt;
		
	}
}
