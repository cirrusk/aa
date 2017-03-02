package amway.com.academy.common.ssoTest.web;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.commoncode.service.CommonCodeService;
import amway.com.academy.common.util.CommonAPI;
import framework.com.cmm.lib.RequestBox;


/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :CommonCodeController.java
 * @DESC :관리자 Excel 업로드  Controller
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.07. 01. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/ssoSubTest")
public class SsoTestSubController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(SsoTestSubController.class);
	
	/**
	 * 공통코드 서비스
	 * @param params
	 * @return
	 */
	@Autowired
	CommonCodeService commonCodeService;
	
	/**
	 * 공통코드 리스트
	 * @param majorCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ssoTest.do")
	public ModelAndView getCodeList(RequestBox requestBox, ModelAndView mav, HttpServletRequest request, HttpServletResponse response)  throws Exception  {
		Map<String, String> rMap = new HashMap<String, String>();
		//삼성 하이브리스 연결
		String ssoValue = "";
		String ssoResult = "";
		
		String requestUrl = request.getRequestURL().toString();
		if( requestUrl.indexOf("http://localhost") >= 0 ) {
			//로컬 테스트
			Cookie[] cookies = request.getCookies();
			
	        if(null != cookies) {
				/* 유효한 연결이면 requestMap 객체 생성 */
	        	for(Cookie cookie : cookies){
					String cookieName = cookie.getName();
					String cookieValue = cookie.getValue();

					if("username".equals(cookieName)){
						ssoValue = cookieValue;
						
						break;
					}
				}
	        }
		} else {
			
			//프로퍼티의 Hybris.ssoUrl정보를 읽어서 https://localhost 이면 체크하지 않는다.
			String urlString = "";
			
			String resourceName = "/config/props/framework.properties";
			ClassLoader loader = Thread.currentThread().getContextClassLoader();
			Properties props = new Properties();
			try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
				props.load(resourceStream);
				//삼성 하이브리스 체크 url
				urlString = props.getProperty("Hybris.temporary.ssoUrl");
				
				if( urlString.indexOf("https://localhost") >= 0 ) {
					Cookie[] cookies = request.getCookies();
					
			        if(null != cookies) {
						/* 유효한 연결이면 requestMap 객체 생성 */
			        	for(Cookie cookie : cookies){
							String cookieName = cookie.getName();
							String cookieValue = cookie.getValue();

							if("username".equals(cookieName)){
								ssoValue = cookieValue;
								
								break;
							}
						}
			        }
				} else {
					ssoValue = ssoCheck(request, urlString);
					// 성능 테스트를 위해서 다음과 같이 세션있는경우 SSO를 통과시킨다 성능 테스트 후 위 소스로 회귀해야 한다.
					/*
					if(request.getSession().getAttribute("abono") == null || request.getSession().getAttribute("abono").toString().equals("") ){
						LOGGER.debug("세션없는 경우 SSO 호출");
						ssoValue = CheckSSO.ssoCheck(request, urlString);
					}else{
						LOGGER.debug("세션있는 경우 SSO 호출없이 세션값 셋팅");
						ssoValue = (String) request.getSession().getAttribute("abono");
					}
					*/
				}
				
			} catch( IOException e) {
				LOGGER.error("/config/props/framework.properties File not found.");
				ssoResult = "/config/props/framework.properties File not found.";
				//ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				//throw new ModelAndViewDefiningException(modelAndView);
			}
		}

		if( ssoValue.equals("ERROR") ) {
			// 세션 아웃
			request.getSession().invalidate();
			LOGGER.debug("================== sso인증 오류로 로그아웃");
			ssoResult = "================== sso인증 오류로 로그아웃";
			String requestUri = request.getRequestURI().toString();
			int zero = 0;
			if(zero <= requestUri.indexOf("/lms/main.do") || zero <= requestUri.indexOf("/mobile/lms/main.do")  || zero <= requestUri.indexOf("/lms/eduResource") ){
				LOGGER.debug("================== 아카데미 메인");
				ssoResult = "================== 아카데미 메인";
			} else {
				//ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				//throw new ModelAndViewDefiningException(modelAndView);
				ssoResult = "================== sso인증 오류로 로그아웃";
			}

		} else {
			String blankStr = "";
			if( !blankStr.equals(ssoValue) ) {
				request.getSession().setAttribute("abono", ssoValue);
				LOGGER.debug("================== sso인증 로그인 완료 " + requestUrl);
				ssoResult = "================== sso인증 로그인 완료";
			} else {
				// 세션 아웃
				request.getSession().invalidate();
				LOGGER.debug("================== imar값이 없어서 로그아웃 시킴 " + requestUrl);
				ssoResult = "================== imar값이 없어서 로그아웃 시킴";
				String requestUri = request.getRequestURI().toString();
				
				if(-1 == requestUri.indexOf("/lms")){
					//ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
					//throw new ModelAndViewDefiningException(modelAndView);
					ssoResult = "================== imar값이 없어서 로그아웃 시킴";
				}
			}
		}
		rMap.put("ssoResult", ssoResult);
		rMap.put("uid", ssoValue);
		mav.addObject("resultMap", rMap);
		return mav;
	}

	/**
	 * ssoCheck
	 * 
	 * @param request
	 * @param urlString
	 * @return
	 */
	public String ssoCheck(HttpServletRequest request, String urlString) {

		String distNo = "";

		try {
			String ssoToken = "";

			LOGGER.debug("urlString="+urlString);

	        Cookie[] cookies = request.getCookies();

	        if(null != cookies) {
				/* 유효한 연결이면 requestMap 객체 생성 */
	            for(Cookie cookie : cookies){
	                String cookieName = cookie.getName();
	                String cookieValue = cookie.getValue();

	                LOGGER.debug("cookieName = " + cookieName);
	                if("i_mar".equals(cookieName)){
	                    ssoToken = cookieValue;
	                    break;
	                }
	            }
	        }

	        LOGGER.debug("ssoToken="+ssoToken);
			if(!ssoToken.equals("")) {
				URL url = new URL(urlString);
				CommonAPI.getCommHTTPS("SSL");
				HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
				urlConnection.setDoOutput(true);
				urlConnection.setRequestMethod("GET");
				urlConnection.setRequestProperty("ssoToken", ssoToken);

				urlConnection.getHeaderFields();

				int responsCode = urlConnection.getResponseCode();
				LOGGER.debug("responsCode=" + responsCode);

				int success = 202;
				int fail = 401;

				// 성공 202 / 실패 401
				if (responsCode == fail) {
					distNo = "ERROR";
				} else if (responsCode == success) {
					String deDistNo = urlConnection.getHeaderField("dist_no");
					// 복호화
					byte[] byteDistNo = Base64.decodeBase64(deDistNo);
					distNo = new String(byteDistNo);
					LOGGER.debug("dist_no=" + distNo);
				}
				urlConnection.disconnect();
			}
		} catch ( IOException e) {
			LOGGER.error(e.getMessage(), e);
			distNo = "ERROR";
		}

        return distNo;
    }

}
