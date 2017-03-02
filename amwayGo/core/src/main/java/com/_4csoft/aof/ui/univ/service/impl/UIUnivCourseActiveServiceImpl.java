/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveService;
import com._4csoft.aof.ui.univ.support.UIUnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.support.UnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.impl.UnivCourseActiveServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseActiveServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseActiveService")
public class UIUnivCourseActiveServiceImpl extends UnivCourseActiveServiceImpl implements UIUnivCourseActiveService {

	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;

	@Resource (name = "UIUnivCourseActiveAttachReference")
	protected UIUnivCourseActiveAttachReference courseActiveAttachReference;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseActiveService#updateCourseActive(com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO,
	 * com._4csoft.aof.ui.infra.vo.UIAttachVO)
	 */
	public int updateCourseActive(UIUnivCourseActiveVO vo, UIAttachVO attach) throws Exception {

		// 시간표
		// 임시경로에서 실제저장 경로로 파일 이동.
		/*		String timetable1Path = vo.getTimetable1();
		vo.setPhoto(attachUtil.getSavePath(timetable1Path,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable1Path, vo.getPhoto(), true);
		vo.setTimetable1(vo.getPhoto());*/

		String thumNailPath = vo.getThumNail();
		vo.setPhoto(attachUtil.getSavePath(thumNailPath,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(thumNailPath, vo.getPhoto(), true);
		vo.setThumNail(vo.getPhoto());

/*		
		String timetable2Path = vo.getTimetable2();
		vo.setPhoto(attachUtil.getSavePath(timetable2Path,
		"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable2Path, vo.getPhoto(), true);
		vo.setTimetable2(vo.getPhoto());
 		
 		String timetable3Path = vo.getTimetable3();
		vo.setPhoto(attachUtil.getSavePath(timetable3Path,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable3Path, vo.getPhoto(), true);
		vo.setTimetable3(vo.getPhoto());

		String timetable4Path = vo.getTimetable4();
		vo.setPhoto(attachUtil.getSavePath(timetable4Path,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable4Path, vo.getPhoto(), true);
		vo.setTimetable4(vo.getPhoto());

		String timetable5Path = vo.getTimetable5();
		vo.setPhoto(attachUtil.getSavePath(timetable5Path,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable5Path, vo.getPhoto(), true);
		vo.setTimetable5(vo.getPhoto());

		String timetable6Path = vo.getTimetable6();
		vo.setPhoto(attachUtil.getSavePath(timetable6Path,
				"/" + courseActiveAttachReference.getAttachReference(UIUnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE).getSavePath()));
		attachUtil.movePhoto(timetable6Path, vo.getPhoto(), true);
		vo.setTimetable6(vo.getPhoto());*/
		
		int success = super.updateCourseActive(vo);

		UIUnivCourseApplyVO courseApply = new UIUnivCourseApplyVO();
		courseApply.copyAudit(vo);
		courseApply.setCourseActiveSeq(vo.getCourseActiveSeq());
		courseApply.setStudyStartDate(vo.getStudyStartDate());
		courseApply.setStudyEndDate(vo.getStudyEndDate());

		courseApplyService.updateCourseApply(courseApply);

		// [3]. 삭제된 첨부파일이 있으면 삭제처리
		attachUtil.deleteByAttachSeqs(attach.getAttachDeleteInfo(), vo.getUpdMemberSeq(), vo.getUpdIp());

		// 첨부파일 복사
		AttachReferenceVO voReference = courseActiveAttachReference.getAttachReference(UnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE);

		// [4]. 신규추가된 첨부파일 저장
		attach.copyAudit(vo);
		attachUtil.insert(attach, vo.getCourseActiveSeq(), voReference);

		return success;
	}
}
