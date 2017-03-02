package amway.com.academy.lms.online.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.RequestBox;
import amway.com.academy.lms.online.service.LmsOnlineService;

@Service
public class LmsOnlineServiceImpl  implements LmsOnlineService{
	@Autowired
	private LmsOnlineMapper lmsOnlineMapper;

	/**
	 * 온라인강의 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectOnlineListCount(RequestBox requestBox) {
		
		return (int) lmsOnlineMapper.selectOnlineListCount(requestBox);
	}
	
	/**
	 * 온라인강의 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectOnlineList(RequestBox requestBox) throws Exception {
		
		String ascStr = "ASC";
		String courseidStr = "COURSEID";
		if(courseidStr.equals(requestBox.get("sortOrderColumn"))) {
			requestBox.put("sortOrderColumn", "REGISTRANTDATE");
		}
		if(!ascStr.equals(requestBox.get("sortOrderType"))) {
			requestBox.put("sortOrderType", "DESC");
		}
		// 교육과정 조회
		List<Map<String, Object>> onlineList = lmsOnlineMapper.selectOnlineList(requestBox);
		
		return onlineList;
	}
	
	/**
	 * 온라인강의 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectOnlineView(RequestBox requestBox) throws Exception {
	
		// 교육과정 조회
		List<Map<String, Object>> onlineList = lmsOnlineMapper.selectOnlineView(requestBox);
		
		return onlineList;
	}
	
	
	@Override
	public int selectOnlineViewCount(RequestBox requestBox) {
		
		return (int) lmsOnlineMapper.selectOnlineViewCount(requestBox);
	}
}
