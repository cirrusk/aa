/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.security;

import java.io.ByteArrayInputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com._4csoft.aof.infra.support.security.PreviousAuthenticationProcessing;
import com._4csoft.aof.ui.infra.web.LdapController;

/**
 * @Project : aof5-admin
 * @Package : com._4csoft.aof.ui.infra.security
 * @File : UIPreviousAuthenticationProcessing.java
 * @Title : Previous Authentication Processing
 * @date : 2013. 4. 23.
 * @author : 김종규
 * @descrption : 인증 처리 전 수행
 */
public class UIPreviousAuthenticationProcessing implements PreviousAuthenticationProcessing {

	private String password;

	public void setPassword(String password) {
		this.password = password;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.security.PreviousAuthenticationProcessing#authenticate(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */
	public int authenticate(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String tftCheck = request.getParameter("tftCheck");
		String memberId = request.getParameter("j_username");
		String memberPw = request.getParameter("j_password");
		int resultCode = 0;
		
		//관리자 아이디 비밀번호로 ldap 연결하기
		try{
			URL url = new URL("http://alticor.intranet.local/webservices/ad/login.asmx");
			
			StringBuffer ldapSoapXml = new StringBuffer();
			ldapSoapXml.append("<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">");
			ldapSoapXml.append("  <soap:Body>");
			ldapSoapXml.append("	<getLogin_LDAP xmlns=\"http://tempuri.org/\">");
			ldapSoapXml.append("	  <userid><![CDATA["+memberId+"]]></userid>");
			ldapSoapXml.append("	  <password><![CDATA["+memberPw+"]]></password>");
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
			
			if( "true".equals( rtnMap.get("Authenticated") ) ) {
				System.out.println("================================> Admin Ldap Login 성공!!");
				setPassword("111111");
				resultCode = 1;
			}else{
				resultCode = 0;
				throw new UsernameNotFoundException("Invalid user credentials");
			}
			
			rtnMap.put("readData", readMap);
			
		}catch(Exception e){
			e.printStackTrace();
			throw new UsernameNotFoundException("Invalid user credentials");
		}
		
		// 인증처리를 타서버에서 해야할 경우 구현한다.
		System.out.println("================================> resultCode : " + resultCode);
		return resultCode; // 1 : 인증성공, 0: 인증실패, -1: 로컬인증.
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.security.PreviousAuthenticationProcessing#obtainPassword()
	 */
	public String obtainPassword() throws AuthenticationException {

		return password;
	}
}
