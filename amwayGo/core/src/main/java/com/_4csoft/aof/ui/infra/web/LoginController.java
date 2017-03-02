package com._4csoft.aof.ui.infra.web;


import java.io.ByteArrayInputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.vo.UIMemberVO;

@Controller
public class LoginController extends BaseController{

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);	
	
	/**
	 * 클릭시 화면으로 보냄
	 * @param
	 * @param
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/Ldap/login.do")
	public ModelAndView loginAjax(HttpServletRequest request, UIMemberVO member, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//관리자 아이디 비밀번호로 ldap 연결하기
		String tftCheck = "Y";
		String adminId = "";
		String adminPwd = "";
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
			}
		} else {
			rtnMap.put("Authenticated", "false" );
		}
		rtnMap.put("readData", readMap);
		
/*		//관리자 세션 생성
		if( "true".equals( rtnMap.get("Authenticated") ) ) {
			requestBox.setSession( SessionUtil.sessionAdno, adminId );
			
			//관리자 정보 입력하기
			requestBox.put("adno", adminId);
			loginService.loginMergeManager(requestBox);
		}*/
		
		mav.setViewName("jsonView");
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	
}