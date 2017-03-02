package com._4csoft.aof.ui.infra.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UIInfoController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 16.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIInfoController extends UIBaseController {

	/**
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/common/info")
	public ModelAndView sample(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		String randomString = StringUtil.getRandomString(24);
		String now = DateUtil.getToday("yyyyMMddHHmmss");
		String linkCd = HttpUtil.getParameter(req, "linkCd");

		if (!UIApiConstant._LNK_CODE.equals(linkCd)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		
		//TODO accessToken 임시
		/*String enkey = StringUtil.encrypt(linkCd + "|" + now, randomString);

		String processKey = enkey + randomString;*/
		
		String processKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" ; 

		String resultMessage = getErorrMessage(resultCode);

		String version_adroid = getCodeName("MOBILE_VERSION::ANDROID");
		String version_ios = getCodeName("MOBILE_VERSION::IOS");

		mav.addObject("accessToken", processKey);
		mav.addObject("version_adroid", version_adroid);
		mav.addObject("version_ios", version_ios);
		mav.addObject("now", now);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.setViewName("jsonView");
		return mav;
	}

}
