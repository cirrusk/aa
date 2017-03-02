package com._4csoft.aof.ui.infra.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper ("UIMessageReceiveMapper")
public interface UIMessageReceiveMapper {

	
	/**
	 * 메시지수신 검색 목록
	 * 
	 * @param conditionVO
	 * @return List<ResultSet>
	 */
	List<ResultSet> getListMobile(SearchConditionVO conditionVO);
}
