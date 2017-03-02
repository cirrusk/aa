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
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.infra.mapper.UIPushMessageTargetMapper;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseActiveBbsMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveBbsService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.univ.service.impl.UnivCourseActiveBbsServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseActiveBbsServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 25.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseActiveBbsService")
public class UIUnivCourseActiveBbsServiceImpl extends UnivCourseActiveBbsServiceImpl implements UIUnivCourseActiveBbsService {

	@Resource (name = "UIPushMessageTargetMapper")
	private UIPushMessageTargetMapper pushMessageTargetMapper;

	@Resource (name = "UIUnivCourseActiveBbsMapper")
	private UIUnivCourseActiveBbsMapper courseActiveBbsMapper;

	@Resource (name = "CodeService")
	private CodeService codeService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.impl.UnivCourseActiveBbsServiceImpl#insertBbs(com._4csoft.aof.univ.vo.UnivCourseActiveBbsVO,
	 * com._4csoft.aof.infra.vo.AttachVO)
	 */
	public int insertBbs(UIUnivCourseActiveBbsVO vo, AttachVO voAttach) throws Exception {
		int success = super.insertBbs(vo, voAttach);

		UIUnivCourseActiveBbsVO courseActiveBbs = (UIUnivCourseActiveBbsVO)vo;

		/*
		 * 푸시수신 여부에 따라 푸시를 발송한다.
		 */
		if ("Y".equals(courseActiveBbs.getPushYn())) {
			UIPushMessageTargetVO pushMessageTarget = new UIPushMessageTargetVO();
			pushMessageTarget.copyAudit(vo);
			pushMessageTarget.setCourseActiveSeq(courseActiveBbs.getCourseActiveSeq());
			pushMessageTarget.setPushMessage(courseActiveBbs.getBbsTitle());

			// 구분자
			// IOS : §¿
			// Android : 
			// 메시지 타입 = 메시지타입 + 구분자 + 운영과정일련번호 + 구분자 +게시글 일련번호 + boardType + boardSeq + applyType 추가
			String pushMessageType = courseActiveBbs.getPushMessageType() + Constants.SEPARATOR + courseActiveBbs.getCourseActiveSeq() + Constants.SEPARATOR
					+ vo.getBbsSeq() + Constants.SEPARATOR + courseActiveBbs.getBoardTypeCd() + Constants.SEPARATOR + courseActiveBbs.getBoardSeq() + Constants.SEPARATOR;
			pushMessageTarget.setPushMessageType(pushMessageType);
			pushMessageTarget.setPushTitle(codeService.getCodeName(vo.getBoardTypeCd()));

			if (pushMessageTargetMapper.countMessageOfCourseApply(pushMessageTarget) > 0) {
				pushMessageTargetMapper.insertlistMessageOfCourseApply(pushMessageTarget);
			}
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseActiveBbsService#getListBbsStatistics(com._4csoft.aof.infra.vo.base.SearchConditionVO)
	 */
	public Paginate<ResultSet> getListBbsStatistics(SearchConditionVO conditionVO) throws Exception {
		int totalCount = courseActiveBbsMapper.countListBbsStatistics(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(courseActiveBbsMapper.getListBbsStatistics(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}
}
