package amway.com.academy.lms.eduResource.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.eduResource.service.LmsEduResourceService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsEduResourceServiceImpl  implements LmsEduResourceService{
	@Autowired
	private LmsEduResourceMapper lmsEduResourceMapper;

	/**
	 * 교육과정 리스트 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectEduResourceListCount(RequestBox requestBox){
		
		return (int) lmsEduResourceMapper.selectEduResourceListCount(requestBox);
	}
	
	/**
	 *  교육과정 조회 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectEduResourceList(RequestBox requestBox) throws Exception {
		
		String ascStr = "ASC";
		String courseidStr = "COURSEID";
		if(courseidStr.equals(requestBox.get("sortOrderColumn"))) {
			requestBox.put("sortOrderColumn", "REGISTRANTDATE");
		}
		if(!ascStr.equals(requestBox.get("sortOrderType"))) {
			requestBox.put("sortOrderType", "DESC");
		}
		
		// 교육과정 조회
		List<Map<String, Object>> eduResourceList = lmsEduResourceMapper.selectEduResourceList(requestBox);
		
		return eduResourceList;
	}


	/**
	 *  교육과정 상세보기 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectEduResourceView(RequestBox requestBox) throws Exception {
	
		// 교육과정 조회
		List<Map<String, Object>> eduResourceView = lmsEduResourceMapper.selectEduResourceView(requestBox);
		
		return eduResourceView;
	}

	/**
	 *  교육과정 이전, 다음 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectEduResourceViewPrevNext(RequestBox requestBox) throws Exception {
		
		String ascStr = "ASC";
		String courseidStr = "COURSEID";
		if(courseidStr.equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "REGISTRANTDATE");
		}
		if(!ascStr.equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}
		
		// 교육과정 조회
		List<Map<String, Object>> eduResourceViewList = lmsEduResourceMapper.selectEduResourceViewPrevNext(requestBox);
		
		return eduResourceViewList;
	}
	
	/**
	 *  교육과정 이전, 다음상세보기 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectEduResourceViewList(RequestBox requestBox) throws Exception {
		
		String ascStr = "ASC";
		String courseidStr = "COURSEID";
		if(courseidStr.equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "REGISTRANTDATE");
		}
		if(!ascStr.equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}
		
		// 교육과정 조회
		List<Map<String, Object>> eduResourceViewList = lmsEduResourceMapper.selectEduResourceViewList(requestBox);
		
		return eduResourceViewList;
	}
	
	@Override
	public List<Map<String, Object>> selectEduResourceViewPrevNextList(RequestBox requestBox) throws Exception {
		
		String ascStr = "ASC";
		String courseidStr = "COURSEID";
		if(courseidStr.equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "REGISTRANTDATE");
		}
		if(!ascStr.equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}
		
		// 교육과정 조회
		List<Map<String, Object>> eduResourceViewList = lmsEduResourceMapper.selectEduResourceViewPrevNextList(requestBox);
		
		return eduResourceViewList;
	}
}
