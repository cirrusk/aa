/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.ui.infra.mapper.UIPushMessageTargetMapper;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;
import com._4csoft.aof.ui.univ.service.UIUnivCourseTeamProjectBbsService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;
import com._4csoft.aof.univ.service.impl.UnivCourseTeamProjectBbsServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseTeamProjectBbsServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 20.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseTeamProjectBbsService")
public class UIUnivCourseTeamProjectBbsServiceImpl extends UnivCourseTeamProjectBbsServiceImpl implements UIUnivCourseTeamProjectBbsService {

	@Resource (name = "UIPushMessageTargetMapper")
	private UIPushMessageTargetMapper pushMessageTargetMapper;

	@Resource (name = "CodeService")
	private CodeService codeService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseTeamProjectBbsService#insertBbs(com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO,
	 * com._4csoft.aof.ui.infra.vo.UIAttachVO)
	 */
	public int insertBbs(UIUnivCourseTeamProjectBbsVO vo, UIAttachVO voAttach) throws Exception {

		int success = super.insertBbs(vo, voAttach);

		/*
		 * 푸시수신 여부에 따라 푸시를 발송한다.
		 */
		if ("Y".equals(vo.getPushYn())) {
			UIPushMessageTargetVO pushMessageTarget = new UIPushMessageTargetVO();
			pushMessageTarget.copyAudit(vo);
			pushMessageTarget.setCourseActiveSeq(vo.getCourseActiveSeq());
			pushMessageTarget.setPushMessage(vo.getBbsTitle());

			// 구분자
			// IOS : §¿
			// Android : 
			// 메시지 타입 = 메시지타입 + 구분자 + 운영과정일련번호 + 구분자 +게시글 일련번호
			String pushMessageType = vo.getPushMessageType() + Constants.SEPARATOR + vo.getCourseActiveSeq() + Constants.SEPARATOR + vo.getBbsSeq();
			pushMessageTarget.setPushMessageType(pushMessageType);
			pushMessageTarget.setPushTitle(codeService.getCodeName(vo.getBoardTypeCd()));

			if (pushMessageTargetMapper.countMessageOfCourseApply(pushMessageTarget) > 0) {
				pushMessageTargetMapper.insertlistMessageOfCourseApply(pushMessageTarget);
			}
		}

		return success;
	}
}
