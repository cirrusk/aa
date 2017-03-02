package com._4csoft.aof.ui.infra.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.service.impl.MessageReceiveServiceImpl;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.infra.mapper.UIMessageReceiveMapper;
import com._4csoft.aof.ui.infra.service.UIMessageReceiveService;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File : UIMessageReceiveServiceImpl.java
 * @Title : 받은메시지
 * @date : 2014. 7. 10.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIMessageReceiveService")
public class UIMessageReceiveServiceImpl extends MessageReceiveServiceImpl implements UIMessageReceiveService {
	@Resource (name = "UIMessageReceiveMapper")
	private UIMessageReceiveMapper uiMessageReceiveMapper;
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.infra.service.UIMessageReceiveService#getListMobile(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public List<ResultSet> getListMobile(SearchConditionVO conditionVO) throws Exception {
		return uiMessageReceiveMapper.getListMobile(conditionVO);
	}

}
