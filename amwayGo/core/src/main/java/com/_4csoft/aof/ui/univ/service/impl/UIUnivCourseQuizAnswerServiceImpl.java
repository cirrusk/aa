/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseQuizAnswerMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseQuizAnswerServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseQuizAnswerService")
public class UIUnivCourseQuizAnswerServiceImpl extends AbstractServiceImpl implements UIUnivCourseQuizAnswerService {

	@Resource (name = "UIUnivCourseQuizAnswerMapper")
	private UIUnivCourseQuizAnswerMapper courseQuizAnswerMapper;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService#insertCourseQuizAnswer(com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO)
	 */
	public int insertCourseQuizAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception {

		return courseQuizAnswerMapper.insertCourseQuizAnswer(vo);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService#getListQuiz(com._4csoft.aof.infra.vo.base.SearchConditionVO)
	 */
	public Paginate<ResultSet> getListQuiz(SearchConditionVO conditionVO) throws Exception {
		int totalCount = courseQuizAnswerMapper.countListQuiz(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(courseQuizAnswerMapper.getListQuiz(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService#getListQuizAnswer(com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO)
	 */
	public List<ResultSet> getListQuizAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception {
		return courseQuizAnswerMapper.getListQuizAnswer(vo);
	}
	
	
	/* (non-Javadoc)
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService#getListQuizShortAnswer(com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO)
	 */
	public List<ResultSet> getListQuizShortAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception {
		return courseQuizAnswerMapper.getListQuizShortAnswer(vo);
	}

	public ResultSet getDetailQuiz(UIUnivCourseQuizAnswerVO vo)
			throws Exception {
		// TODO Auto-generated method stub
		return courseQuizAnswerMapper.getDetailQuiz(vo);
	}
	
}
