package com._4csoft.aof.ui.infra.service;

import java.util.List;

import com._4csoft.aof.infra.service.MessageReceiveService;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;


/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIMessageReceiveService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 7. 9.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIMessageReceiveService extends MessageReceiveService {
	
	/**
	 * 메시지수신 검색 목록
	 * 
	 * @param conditionVO
	 * @return List<ResultSet>
	 * @throws Exception
	 */
	public List<ResultSet> getListMobile(SearchConditionVO conditionVO) throws Exception;
	
}
