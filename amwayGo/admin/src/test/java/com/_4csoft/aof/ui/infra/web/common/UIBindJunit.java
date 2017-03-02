package com._4csoft.aof.ui.infra.web.common;

import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.mock.jndi.SimpleNamingContextBuilder;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com._4csoft.aof.infra.service.impl.MemberServiceImpl;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;

@RunWith (SpringJUnit4ClassRunner.class)
@ContextConfiguration (locations = { "classpath:com/_4csoft/aof/ui/config/junit-context-common.xml",
		"classpath:com/_4csoft/aof/ui/config/junit-context-sqlMap.xml", "classpath:com/_4csoft/aof/ui/config/junit-context-transaction.xml",
		"classpath:com/_4csoft/aof/ui/config/junit-context-datasource.xml", "classpath:com/_4csoft/aof/ui/config/junit-context-aspect.xml",
		"classpath:com/_4csoft/aof/ui/config/junit-context-egovuserdetailshelper.xml", "classpath:com/_4csoft/aof/ui/config/junit-context-idgen.xml",
		"classpath:com/_4csoft/aof/ui/config/junit-context-properties.xml", "classpath:com/_4csoft/aof/ui/config/junit-context-security.xml",
		"classpath:com/_4csoft/aof/ui/config/junit-context-validator.xml", "classpath:com/_4csoft/aof/ui/config/junit-egov-com-servlet.xml" })
public class UIBindJunit {

	private final static Log LOG = LogFactory.getLog(UIBindJunit.class);

	public static SecurityContext securityContext;

	public static String loginSessioId;

	@BeforeClass
	public static void bindDatasource() throws NamingException {
		System.setProperty("file.encoding", "UTF-8");
		System.setProperty("client.encoding.override", "UTF-8");
		System.setProperty("log4j.path", "/eGovPlatform/log");
		System.setProperty("aof5.mapper.location", "classpath");
		System.setProperty("config.path", "/WEB-INF/config/aof/config.local.xml");
		System.setProperty("except.rmi.url", "0");
		System.setProperty("admin.rmi.port", "1199");
		System.setProperty("www.rmi.port", "1200");

		if ("".equals(Constants.SYSTEM_CODE)) {
			SimpleNamingContextBuilder contextBuiler = SimpleNamingContextBuilder.emptyActivatedContextBuilder();
			DriverManagerDataSource dataSource = new DriverManagerDataSource();
			contextBuiler.bind("java:comp/env/jdbc/aof", dataSource);
			// ApplicationContext context;

			String systConfPath = "com/_4csoft/aof/ui/config";
			String configPath = systConfPath + "/config.local.xml";

			ConfigUtil config = ConfigUtil.getInstance();
			config.setConfiguration(configPath);

			setConstant();
		} else {
			LOG.debug("not setting");
		}

	}

	/**
	 * config정보를 읽어 Constants를 setting한다
	 * 
	 * @throws Exception
	 */
	private static void setConstant() {
		ConfigUtil config = ConfigUtil.getInstance();

		String value = config.getString(Constants.CONFIG_SYSTEM_CODE);
		if (value != null && value.length() > 0) {
			Constants.SYSTEM_CODE = value.trim();
		}
		LOG.debug("SYSTEM_CODE=" + Constants.SYSTEM_CODE);

		value = config.getString(Constants.CONFIG_SYSTEM_NAME);
		if (value != null && value.length() > 0) {
			Constants.SYSTEM_NAME = value.trim();
		}
		LOG.debug("SYSTEM_NAME=" + Constants.SYSTEM_NAME);

		value = config.getString(Constants.CONFIG_SYSTEM_DOMAIN);
		if (value != null && value.length() > 0) {
			Constants.SYSTEM_DOMAIN = value.trim();
		}
		LOG.debug("SYSTEM_DOMAIN=" + Constants.SYSTEM_DOMAIN);

		value = config.getString(Constants.CONFIG_DEFAULT_PERPAGE);
		if (value != null && value.length() > 0) {
			Constants.DEFAULT_PERPAGE = Integer.parseInt(value);
		}
		LOG.debug("DEFAULT_PERPAGE=" + Constants.DEFAULT_PERPAGE);

		value = config.getString(Constants.CONFIG_ENCODING_KEY);
		if (value != null && value.length() > 0) {
			try {
				value = StringUtil.decryptHexString(value.trim(), "!AOF5-MayThe4CbeWithYou!");
			} catch (Exception e) {
				LOG.error("error decryptHexString");
			}
			Constants.ENCODING_KEY = value;
		}
		LOG.debug("ENCODING_KEY=**********");

		value = config.getString(Constants.CONFIG_START_PAGE);
		if (value != null && value.length() > 0) {
			Constants.START_PAGE = value.trim();
		}
		LOG.debug("START_PAGE=" + Constants.START_PAGE);

		value = config.getString(Constants.CONFIG_ACCESS_ROLES_TYPE);
		if (value != null && value.length() > 0) {
			Constants.ACCESS_ROLES_TYPE = value.trim();
		}
		LOG.debug("ACCESS_ROLES_TYPE=" + Constants.ACCESS_ROLES_TYPE);

		String[] values = config.getStringArray(Constants.CONFIG_ACCESS_ROLES);
		if (values != null && values.length > 0) {
			Constants.ACCESS_ROLES = values;
		}
		for (String s : Constants.ACCESS_ROLES) {
			LOG.debug("ACCESS_ROLES=" + s);
		}

		value = config.getString(Constants.CONFIG_FORMAT_TIMEZONE);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_TIMEZONE = value.trim();
		}
		LOG.debug("FORMAT_TIMEZONE=" + Constants.FORMAT_TIMEZONE);

		value = config.getString(Constants.CONFIG_FORMAT_DATE);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_DATE = value.trim();
		}
		LOG.debug("FORMAT_DATE=" + Constants.FORMAT_DATE);

		value = config.getString(Constants.CONFIG_FORMAT_DATETIME);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_DATETIME = value.trim();
		}
		LOG.debug("FORMAT_DATETIME=" + Constants.FORMAT_DATETIME);

		value = config.getString(Constants.CONFIG_FORMAT_DBDATETIME);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_DBDATETIME = value.trim();
		}
		LOG.debug("FORMAT_DBDATETIME=" + Constants.FORMAT_DBDATETIME);

		value = config.getString(Constants.CONFIG_FORMAT_DBDATETIME_START);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_DBDATETIME_START = value.trim();
		}
		LOG.debug("FORMAT_DBDATETIME_START=" + Constants.FORMAT_DBDATETIME_START);

		value = config.getString(Constants.CONFIG_FORMAT_DBDATETIME_END);
		if (value != null && value.length() > 0) {
			Constants.FORMAT_DBDATETIME_END = value.trim();
		}
		LOG.debug("FORMAT_DBDATETIME_END=" + Constants.FORMAT_DBDATETIME_END);

		value = config.getString(Constants.CONFIG_DOMAIN_WEB);
		if (value != null && value.length() > 0) {
			Constants.DOMAIN_WEB = value.trim();
		}
		LOG.debug("DOMAIN_WEB=" + Constants.DOMAIN_WEB);

		value = config.getString(Constants.CONFIG_DOMAIN_IMAGE);
		if (value != null && value.length() > 0) {
			Constants.DOMAIN_IMAGE = value.trim();
		}
		LOG.debug("DOMAIN_IMAGE=" + Constants.DOMAIN_IMAGE);

		value = config.getString(Constants.CONFIG_DOMAIN_LOCALE_IMAGE);
		if (value != null && value.length() > 0) {
			Constants.DOMAIN_LOCALE_IMAGE = value.trim();
		}
		LOG.debug("DOMAIN_LOCALE_IMAGE=" + Constants.DOMAIN_LOCALE_IMAGE);

		value = config.getString(Constants.CONFIG_DOMAIN_NODEJS);
		if (value != null && value.length() > 0) {
			Constants.DOMAIN_NODEJS = value.trim();
		}
		LOG.debug("DOMAIN_NODEJS=" + Constants.DOMAIN_NODEJS);

		value = config.getString(Constants.CONFIG_UPLOAD_PATH_FILE);
		if (value != null && value.length() > 0) {
			Constants.UPLOAD_PATH_FILE = value.trim();
		}
		LOG.debug("UPLOAD_PATH_FILE=" + Constants.UPLOAD_PATH_FILE);

		value = config.getString(Constants.CONFIG_UPLOAD_PATH_IMAGE);
		if (value != null && value.length() > 0) {
			Constants.UPLOAD_PATH_IMAGE = value.trim();
		}
		LOG.debug("UPLOAD_PATH_IMAGE=" + Constants.UPLOAD_PATH_IMAGE);

		value = config.getString(Constants.CONFIG_UPLOAD_PATH_MEDIA);
		if (value != null && value.length() > 0) {
			Constants.UPLOAD_PATH_MEDIA = value.trim();
		}
		LOG.debug("UPLOAD_PATH_MEDIA=" + Constants.UPLOAD_PATH_MEDIA);

		value = config.getString(Constants.CONFIG_UPLOAD_PATH_LCMS);
		if (value != null && value.length() > 0) {
			Constants.UPLOAD_PATH_LCMS = value.trim();
		}
		LOG.debug("UPLOAD_PATH_LCMS=" + Constants.UPLOAD_PATH_LCMS);

		value = config.getString(Constants.CONFIG_CATEGORY_COURSE);
		if (value != null && value.length() > 0) {
			Constants.CATEGORY_COURSE = value.trim();
		}
		LOG.debug("CATEGORY_COURSE=" + Constants.CATEGORY_COURSE);

		value = config.getString(Constants.CONFIG_CATEGORY_CONTENTS);
		if (value != null && value.length() > 0) {
			Constants.CATEGORY_CONTENTS = value.trim();
		}
		LOG.debug("CATEGORY_CONTENTS=" + Constants.CATEGORY_CONTENTS);

		Constants.SECURITY_CONTEXT_KEY = new String(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);

	}

	/**
	 * 로그인 세션 생성
	 * 
	 * @param req
	 * @param memberService
	 * @param loginId
	 */
	public static void setLoginSession(MockHttpServletRequest req, MemberServiceImpl memberService, String loginId) {

		if (securityContext == null || loginSessioId == null || "".equals(loginSessioId)) {

			LOG.debug("session create");
			UserDetails userDetails = memberService.loadUserByUsername(loginId);

			List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
			// authorities.add(new GrantedAuthorityImpl("ROLE_INVALID"));

			/*
			 * vo.setMemberSeq(SessionUtil.getMember(req).getMemberSeq()); 호출시 null 문제로 주석처리 코드수정
			 */
			// Authentication authToken = new UsernamePasswordAuthenticationToken(userDetails.getUsername(), userDetails.getPassword(), authorities);

			Authentication authToken = new UsernamePasswordAuthenticationToken(userDetails, authorities);
			SecurityContextHolder.getContext().setAuthentication(authToken);
			securityContext = SecurityContextHolder.getContext();
			loginSessioId = loginId;

			SessionUtil.setAttribute(req, Constants.SECURITY_CONTEXT_KEY, securityContext);

		} else {

			if (!loginSessioId.equals(loginId)) {
				loginSessioId = null;
				// loginId 다른 경우 재 생성
				setLoginSession(req, memberService, loginId);
			} else {
				if (SessionUtil.getAttribute(req, Constants.SECURITY_CONTEXT_KEY) == null) {
					SessionUtil.setAttribute(req, Constants.SECURITY_CONTEXT_KEY, securityContext);
				}
			}
		}
	}
}
