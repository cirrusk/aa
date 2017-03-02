/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.session.mapper.UISessionMapper;
import com._4csoft.aof.ui.session.service.UISessionService;
import com._4csoft.aof.ui.session.vo.condition.UISessionCondition;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.service.impl
 * @File    : UISessionServiceImpl.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
@Service ("UISessionService")
public class UISessionServiceImpl implements UISessionService {
	
	@Resource (name = "UISessionMapper")
	private UISessionMapper SessionMapper;

	/* (non-Javadoc)
	 * @see com._4csoft.aof.ui.session.service.UISessionService#getDetail(java.lang.String, java.lang.String)
	 */
	public ResultSet getDetail(UISessionCondition conditionVO) {
		return SessionMapper.getDetail(conditionVO);
	}

	/* (non-Javadoc)
	 * @see com._4csoft.aof.ui.session.service.UISessionService#getList(com._4csoft.aof.ui.session.vo.condition.UISessionCondition)
	 */
	public Paginate<ResultSet> getList(UISessionCondition conditionVO) throws Exception {
		int totalCount = SessionMapper.countList(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(SessionMapper.getList(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

}
