package egovframework.com.cmm.interceptor;

import java.io.InputStream;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hsqldb.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import amway.com.academy.common.util.CheckSSO;

/**
 * 인증여부 체크 인터셉터
 * @author 공통서비스 개발팀 서준식
 * @since 2011.07.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011.07.01  서준식          최초 생성
 *  2011.09.07  서준식          인증이 필요없는 URL을 패스하는 로직 추가
 *  </pre>
 */


public class AuthenticInterceptor extends HandlerInterceptorAdapter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticInterceptor.class);
	
	/*
	private boolean isVariableImarFromCookie(Cookie [] cookies) throws Exception {
		
		if(null != cookies){
			
			for(Cookie cookie : cookies){
				String cookieName = cookie.getName();
				String cookieValue = cookie.getValue();
				
				if("i_mar".equals(cookieName)){
					
					//TODO: check validation i_mar-value
					
					return true;
				}
			}
		}
		
		return false;
	}
	*/
	
	/*
	private String getAccountFromCookie(Cookie [] cookies) throws Exception {

		String accountFromCookie = null;
		
		if(null != cookies) {
			// 유효한 연결이면 requestMap 객체 생성
			for(Cookie cookie : cookies){
				String cookieName = cookie.getName();
				String cookieValue = cookie.getValue();

				if("username".equals(cookieName)){
					accountFromCookie = cookieValue;
					break;
				}
			}
		}
		
		return accountFromCookie;
	}
	*/

	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		//삼성 하이브리스 연결
		String ssoValue = "";
		
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
				urlString = props.getProperty("Hybris.ssoUrl");
				
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
					ssoValue = CheckSSO.ssoCheck(request, urlString);
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
				
			} catch( Exception e) {
				//LOGGER.error("/config/props/framework.properties File not found.");
				LOGGER.error(e.getMessage(), e);
				
				ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				throw new ModelAndViewDefiningException(modelAndView);
			}
		}

		String requestUri = request.getRequestURI().toString();
		LOGGER.debug("================== sso인증 requestUri : " + requestUri);
		LOGGER.debug("================== sso인증 ssoValue   : " + ssoValue);
		
		if( ssoValue.equals("ERROR") || ssoValue.equals("") ) {
			// 세션 아웃
			request.getSession().invalidate();
			LOGGER.debug("================== sso인증 오류로 로그아웃");

			if(0 <= requestUri.indexOf("/lms/main.do") || 0 <= requestUri.indexOf("/mobile/lms/main.do")  || 0 <= requestUri.indexOf("/lms/eduResource")
					|| 0 <= requestUri.indexOf("/reservation/expProgramVailabilityCheckAjax") || 0 <= requestUri.indexOf("/mobile/reservation/expProgramVailabilityCheckAjax") ){

			} else {
				ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
				throw new ModelAndViewDefiningException(modelAndView);
			}

		} else {
			if( !"".equals(ssoValue) ) {
				request.getSession().setAttribute("abono", ssoValue);
				LOGGER.debug("================== sso인증 로그인 완료");
			} else {
				// 세션 아웃
				request.getSession().invalidate();
				LOGGER.debug("================== imar값이 없어서 로그아웃 시킴" + requestUri);
				
				if(-1 == requestUri.indexOf("/lms")){
					ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
					throw new ModelAndViewDefiningException(modelAndView);
				}
			}
		}
		
		return true;
		
		/*
		Cookie [] cookies = request.getCookies();
		
		if(null != cookies && isVariableImarFromCookie(cookies)){
			
			account = getAccountFromCookie(cookies);
			
			if(null != account){
				// 매번 쿠키 확인 후 session에 갱신
				request.getSession().setAttribute("abono", account);
			}else{
				
				String requestUrl = request.getRequestURL().toString();
				String requestUri = request.getRequestURI().toString();
				
				LOGGER.debug("requestUrl : " + requestUrl);
				LOGGER.debug("requestUri : " + requestUri);
				
				LOGGER.debug(">>" + requestUrl.indexOf("/lms"));
				LOGGER.debug(">>" + requestUri.indexOf("/lms"));
				
				// lms 요청 url은 익명을 따로 관리한다.
				if(-1 == requestUri.indexOf("/lms")){
					ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
					throw new ModelAndViewDefiningException(modelAndView);
				}
			}
				
			return true;
			
		}else if(!isPermittedURL){
			ModelAndView modelAndView = new ModelAndView("framework/com/cmm/error/loginException");
			throw new ModelAndViewDefiningException(modelAndView);
		}else{
			return true;
		}
		*/
	}

}
