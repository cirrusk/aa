package com._4csoft.aof.ui.infra.service;

import com._4csoft.aof.infra.service.PushMessageTargetService;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;


/**
 * @Package : com._4csoft.aof.infra.service
 * @File : UIPushMessageTargetService.java
 * @Title : 푸시 발송
 * @date : 2015. 6. 5.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */

public interface UIPushMessageTargetService extends PushMessageTargetService {
	
	public int pushSendMember(UIPushMessageTargetVO vo) throws Exception;
}
