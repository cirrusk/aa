package amway.com.academy.lms.share.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.eduResource.service.LmsEduResourceService;
import amway.com.academy.lms.request.service.LmsRequestService;
import framework.com.cmm.lib.RequestBox;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsShareController.java
 * @DESC : 무권한 페이지 상세 화면
 *        - SNS로 공유된 무권한 페이지 화면임
 * @Author:KR620243
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/lms/share")
public class LmsShareController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsShareController.class);
	
	@Autowired
	LmsRequestService lmsRequestService;
	
	@Autowired
	LmsEduResourceService lmsEduResourceService;
	
	@Autowired
	LmsUtil lmsUtil;

	
	/**
	 * 무권한 페이지
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsCourseView.do")
	public ModelAndView lmsShareCourseDetail(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		// 상세
		mav.addObject("detail", lmsRequestService.selectLmsShareCourseDetail(requestBox));
			
		mav.addObject("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		return mav;
	}
	
}
