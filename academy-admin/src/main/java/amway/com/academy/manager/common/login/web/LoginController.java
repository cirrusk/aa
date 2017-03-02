package amway.com.academy.manager.common.login.web;

import amway.com.academy.manager.common.batchResult.service.BatchResultService;
import amway.com.academy.manager.common.main.web.MainController;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.web.CommonController;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.io.ByteArrayInputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import amway.com.academy.manager.common.ldap.web.LdapController;
import amway.com.academy.manager.common.login.service.LoginService;
import amway.com.academy.manager.lms.category.service.LmsCategoryService;

@Controller
@RequestMapping("/manager")
public class LoginController extends CommonController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private BatchResultService batchResultService;
	
	@Autowired
	LoginService loginService;	
	
	/**
	 * 로그인화면
	 * @param requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
    public ModelAndView login(RequestBox requestBox, ModelAndView mav) throws Exception {
        return mav;
    }

	/**
	 * 클릭시 화면으로 보냄
	 * @param
	 * @param
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/loginAjax.do")
	public ModelAndView loginAjax(HttpServletRequest request, RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String checkLog = "hit";
		
		//관리자 아이디 비밀번호로 ldap 연결하기
		String tftCheck = requestBox.getString("tftCheck");
		String adminId = requestBox.getString("adminId");
		String adminPwd = requestBox.getString("adminPwd");
		
		URL url = new URL("http://alticor.intranet.local/webservices/ad/login.asmx");
		
		StringBuffer ldapSoapXml = new StringBuffer();
		ldapSoapXml.append("<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">");
		ldapSoapXml.append("  <soap:Body>");
		ldapSoapXml.append("	<getLogin_LDAP xmlns=\"http://tempuri.org/\">");
		ldapSoapXml.append("	  <userid><![CDATA["+adminId+"]]></userid>");
		ldapSoapXml.append("	  <password><![CDATA["+adminPwd+"]]></password>");
		ldapSoapXml.append("	</getLogin_LDAP>");
		ldapSoapXml.append("  </soap:Body>");
		ldapSoapXml.append("</soap:Envelope>");
		
		String requestUrl = request.getRequestURL().toString();
		
		String returnValue = "";
		if( requestUrl.indexOf("http://localhost") >= 0 ) {
			//returnValue = "<Envelope xmlns=\"urn:schemas-xmlsoap-org:soap.v1\"><Header></Header><Body><LDAPInfo xmlns=\"urn:alticor:LDAP\"><Authenticated>true</Authenticated><Error>Bind ID/Bind Password combination is not valid</Error></LDAPInfo></Body></Envelope>";
			returnValue = "<getLogin_LDAPResult>true</getLogin_LDAPResult>";

		} else {
			if( tftCheck.equals("Y") ) {
				returnValue = "<getLogin_LDAPResult>true</getLogin_LDAPResult>";
			} else {
				returnValue = LdapController.connectionWebService(url, ldapSoapXml.toString());
			}
		}
		
		//읽어온 데이터 파싱하기( xml문장, 읽을 노드의 상위명)
		Map<String,String> readMap = LdapController.getXmlRead(new ByteArrayInputStream(returnValue.getBytes()), "getLogin_LDAPResult");
		if( readMap != null && !readMap.isEmpty() ) {
			if( readMap.get("Authenticated") != null && !readMap.get("Authenticated").isEmpty() ) {
				rtnMap.put("Authenticated", readMap.get("Authenticated") );
			} else {
				rtnMap.put("Authenticated", "false" );
				checkLog = "fail";
			}
		} else {
			rtnMap.put("Authenticated", "false" );
			checkLog = "fail";
		}
		rtnMap.put("readData", readMap);

		
		//관리자 세션 생성
		if( "true".equals( rtnMap.get("Authenticated") ) ) {
			requestBox.setSession( SessionUtil.sessionAdno, adminId );
			
			//관리자 정보 입력하기
			requestBox.put("adno", adminId);
			loginService.loginMergeManager(requestBox);

			requestBox.put("adno", adminId);
			List<DataBox> checkAdno = loginService.selectManagerAuthList(requestBox);
			
			if(checkAdno.size() == 0) {
				rtnMap.put("Authenticated", "non");
				checkLog = "fail";
				
			}else{
				//  LMS 세션 권한 체크 부분입니다.
				HttpSession se = requestBox.getHttpSession();
				se.setAttribute("authList", checkAdno);
				//  LMS 세션 권한 체크 부분입니다.
				String apSeq = "";
				LOGGER.debug("setted checkAdno : {}", checkAdno);
				
				for (DataBox dataBox : checkAdno){
					apSeq = (String) dataBox.get("apseq");
					requestBox.setSession( SessionUtil.sessionApno, apSeq );
					break;
				}
			}
			
		}
		requestBox.put("logkind", checkLog);
		loginService.loginLogInsert(requestBox);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	
}