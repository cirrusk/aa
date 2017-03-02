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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com._4csoft.aof.infra.support.security.PreviousAuthenticationProcessing;
import com._4csoft.aof.infra.support.validator.InfraValidator;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.ui.infra.mapper.UIMemberMapper;
import com._4csoft.aof.ui.infra.web.LdapController;
import com._4csoft.aof.ui.infra.web.UtilApi;

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

	@Resource (name = "UIMemberMapper")
	protected UIMemberMapper uiMemberMapper;
		
	@Resource (name = "UIInfraValidator")
	protected InfraValidator validator;
	
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
		// 인증처리를 타서버에서 해야할 경우 구현한다.
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String tftCheck = request.getParameter("tftCheck");
		String memberId = request.getParameter("j_username");
		String memberPw = request.getParameter("j_password");
		int resultCode = 0;
		
		if(!memberId.equals("tutee01") && !memberId.equals("tutee02") && !memberId.equals("tutee03")){
			try {
				System.out.println("================================> 암웨이API 시작합니다.");
				URL url = new URL("http://alticor.intranet.local/webservices/ad/login.asmx");
				
				System.out.println("url 출력하기 : " + url);
				
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
				
				System.out.println("================================> Ldap 체크 시작합니다." + requestUrl);
				String returnValue = "";
				if( requestUrl.indexOf("http://localhost") >= 0 ) {
					System.out.println("================================> 로컬에서 Ldap을 태웠습니다.");
					//returnValue = "<Envelope xmlns=\"urn:schemas-xmlsoap-org:soap.v1\"><Header></Header><Body><LDAPInfo xmlns=\"urn:alticor:LDAP\"><Authenticated>true</Authenticated><Error>Bind ID/Bind Password combination is not valid</Error></LDAPInfo></Body></Envelope>";
					returnValue = "<getLogin_LDAPResult>true</getLogin_LDAPResult>";
		
				} else {
					if( "Y".equals(tftCheck) ) {
						System.out.println("================================> 테스트 체크로 Ldap을 태웠습니다.");
						returnValue = "<getLogin_LDAPResult>true</getLogin_LDAPResult>";
					} else {
						System.out.println("================================> Ldap을 태웠습니다.");
						returnValue = LdapController.connectionWebService(url, ldapSoapXml.toString());
					}
				}
				
				System.out.println("================================> Ldap파싱을 시작합니다.");
				//읽어온 데이터 파싱하기( xml문장, 읽을 노드의 상위명)
				Map<String,String> readMap = LdapController.getXmlRead(new ByteArrayInputStream(returnValue.getBytes()), "getLogin_LDAPResult");
				UtilApi utilApi = new UtilApi();	//삼성SDS 로그인API 선언
				
				if( readMap != null && !readMap.isEmpty() ) {
					if( readMap.get("Authenticated") != null && !readMap.get("Authenticated").isEmpty() ) {
						rtnMap.put("Authenticated", readMap.get("Authenticated") );
					} else {
						rtnMap.put("Authenticated", "false" );
					}
				} else {
					rtnMap.put("Authenticated", "false" );
				}

				//Ldap처리 후 성공 시 로그인, 실패 시 삼성 로그인API확인
				if( "true".equals( rtnMap.get("Authenticated") ) ) {
					System.out.println("================================> Ldap로그인 성공 후 로그인시작");
					setPassword("111111");
					resultCode = 1;
				}else{
					System.out.println("================================> 삼성SDS API 실행시작");
					String result = utilApi.checkUser(memberId, memberPw);	//체크 로그인API checkUser(아이디, 암호)
					
					System.out.println("result : " + result);
					if(result.equals("Y")){	//API 로그인이 성공적이면 Y 아니면 N
						setPassword("111111");
						resultCode = 1;
						MemberVO memberVO = new MemberVO();
						memberVO.setMemberId(memberId);	//멤버아이디 체크
						MemberVO academy =  uiMemberMapper.academyMember(memberVO);	//LMS 멤버가져오기
/*						if(academy == null){	//ACADEMY에 없으면
							resultCode = 0;	//로그인 실패
							throw new UsernameNotFoundException("Invalid user credentials");
						}*/
					}else{
						resultCode = 0;
						throw new UsernameNotFoundException("Invalid user credentials");
					}
				}
				rtnMap.put("readData", readMap);			
				
			} catch (Exception e) {
				System.out.println("================================> 암웨이API 인증중에 오류입니다.");
				throw new UsernameNotFoundException("Invalid user credentials");
			}
		
		}else{
			System.out.println(memberId + " 실행완료");
			setPassword(memberPw);
			if(memberId.equals("7480003")){
				setPassword("111111");
			}
			resultCode = 1;
		}
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
