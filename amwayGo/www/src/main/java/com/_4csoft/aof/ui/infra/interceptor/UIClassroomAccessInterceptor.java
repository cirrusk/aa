/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.board.vo.condition.UIBoardCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyVO;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UIAccessInterceptor.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : Access Interceptor
 * @descrption : 강의실에서의 수강생여부 판단 조건입니다.
 * 
 *             1. /usr/classroom/***.do
 * 
 *             2. 필수 파라미터 : courseApplySeq
 * 
 *             3. 수강생 일련번호, 멤버일련번호(세션값)를 가지고 수강생이 맞는지 판단한다.
 * 
 *             4. 수강생이 맞는 경우 개설과목 정보를 set하여 controller 에서 그 정보를 사용한다.
 * 
 *             5. 예제 - www.4csoft.com/usr/classroom/***.do?courseApplySeq=1
 */
@Component
public class UIClassroomAccessInterceptor extends AccessInterceptor {

	@Resource (name = "UnivCourseApplyService")
	protected UnivCourseApplyService courseApplyService;

	@Resource (name = "UnivCourseActiveService")
	protected UnivCourseActiveService courseActiveService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	private final String BOARD_REFERENCE_TYPE = "course";

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		super.preHandle(request, response, handler);

		// excludeUrl
		if ("true".equals((String)request.getAttribute("excludeUrl"))) {
			return true;
		}

		String observerModeYn = SessionUtil.getMember(request).getObserverModeYn();

		UnivCourseActiveVO vo = null;
		Long courseApplySeq = HttpUtil.getParameter(request, "courseApplySeq", 0L);

		if (observerModeYn != null && observerModeYn.equals("Y")) { // 옵저버 권한이 있는 사용자 강의실에 접근 할 경우

			// 개설과목 일련번호가 없으면 비정상적인 접근
			Long courseActiveSeq = HttpUtil.getParameter(request, "courseActiveSeq", 0L);
			if (courseActiveSeq == 0L) {
				throw new AofException(Errors.ACCESS_ClASSROOM_DENIED.desc);
			}

			// 정상적인 수강과목 유무 판단
			vo = courseActiveService.getDetailCourseActiveByUser(courseActiveSeq);
		} else {
			// 수강생 일련번호가 없으면 비정상적인 접근
			if (courseApplySeq == 0L) {
				throw new AofException(Errors.ACCESS_ClASSROOM_DENIED.desc);
			}
			// 정상적인 수강생 유무 판단
			Long memberSeq = SessionUtil.getMember(request).getMemberSeq();
			vo = courseApplyService.getDetailByUser(new UnivCourseApplyVO(courseApplySeq, memberSeq));
		}

		if (vo == null) {
			throw new AofException(Errors.ACCESS_ClASSROOM_DENIED.desc);
		} else {

			request.setAttribute("_CLASS_courseMasterSeq", vo.getCourseMasterSeq());
			request.setAttribute("_CLASS_courseActiveSeq", vo.getCourseActiveSeq());
			request.setAttribute("_CLASS_courseActiveTitle", vo.getCourseActiveTitle());
			request.setAttribute("_CLASS_year", vo.getYear());
			request.setAttribute("_CLASS_term", vo.getTerm());
			request.setAttribute("_CLASS_division", vo.getDivision());
			request.setAttribute("_CLASS_courseTypeCd", vo.getCourseTypeCd());

			// 강의실 게시판 메뉴 구성 정보
			UIBoardCondition condition = new UIBoardCondition();
			condition.setSrchReferenceSeq(vo.getCourseActiveSeq());
			condition.setSrchReferenceType(BOARD_REFERENCE_TYPE);
			condition.setSrchUseYn("Y");

			request.setAttribute("_CLASS_boardInfo", boardService.getList(condition));
		}

		return true;
	}
}
