package amway.com.academy.lms.information.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


/**
 * @author KR620260
 *		date : 2016.08.26
 * lms 정규과정소개 컨트롤러
 */
@Controller
@RequestMapping("/lms/information")
public class LmsRegularController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsRegularController.class);

	@Autowired
	LmsUtil lmsUtil;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	/**
	 * LMS 정규과정소개
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegular.do")
	public ModelAndView lmsRegular(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		// 접속서버에 대한 Link
		String sParam = "";
		String sHybrisDomain = LmsCode.getHybrisHttpDomain();
		String requestUrl = request.getRequestURL().toString();  // 접속서버 URL
		if( requestUrl.indexOf("http://localhost") >= 0 ) {
			sHybrisDomain = "http://localhost:8080";
			sParam = ".do";
		}
		String sLink = sHybrisDomain + "/lms/request/lmsCourse" + sParam;
		
		requestBox.put("DomainUrl", sLink);
		model.addAttribute("scrData", requestBox);

		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/information/lmsRegular");
		
		return mav;
	}
	
	
}
