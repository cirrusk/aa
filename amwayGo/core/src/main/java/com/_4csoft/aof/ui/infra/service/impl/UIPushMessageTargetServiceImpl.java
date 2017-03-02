package com._4csoft.aof.ui.infra.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.service.impl.PushMessageTargetServiceImpl;
import com._4csoft.aof.ui.infra.mapper.UIPushMessageTargetMapper;
import com._4csoft.aof.ui.infra.service.UIPushMessageTargetService;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;

/**
 * @Package : com._4csoft.aof.infra.service
 * @File : UIPushMessageTargetServiceImpl.java
 * @Title : 푸시 발송
 * @date : 2015. 6. 5.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */

@Service("UIPushMessageTargetService")
public class UIPushMessageTargetServiceImpl extends PushMessageTargetServiceImpl implements UIPushMessageTargetService{
	@Resource (name = "UIPushMessageTargetMapper")
	private UIPushMessageTargetMapper uiPushMessageTargetMapper;
	
	public int pushSendMember(UIPushMessageTargetVO vo) throws Exception {
		int successCnt = uiPushMessageTargetMapper.countPushSendMember(vo);
		if(successCnt > 0){
			uiPushMessageTargetMapper.insertPushSendMember(vo);
		}
		return successCnt;
	}
}
