package com._4csoft.aof.ui.infra.mapper;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UXCompetitionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper ("UXCompetitionMapper")
public interface UXCompetitionMapper {

	
	/**
	 * 대회여부 목록
	 * 
	 * @param conditionVO
	 * @return List<ResultSet>
	 */
	ResultSet getListCompetition();
	
	/**
	 * 대회여부 상태값 저장
	 * 
	 * @param VO
	 * @return int
	 */
	int update(UXCompetitionVO vo);
}
