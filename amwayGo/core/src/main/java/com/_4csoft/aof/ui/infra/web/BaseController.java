/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;

import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.References;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.vo.base.BaseVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : BaseController.java
 * @Title : Base Controller
 * @date : 2013. 4. 25.
 * @author : 김종규
 * @descrption : Controller에서 공통적으로 사용하는 method를 구현한다
 */
public class BaseController {
	protected final Log log = LogFactory.getLog(getClass());
	protected ConfigUtil config = ConfigUtil.getInstance();

	// 공통코드 프로퍼티
	protected Codes codes = Codes.getInstance();
	// 참조값 프로퍼티
	protected References references = References.getInstance();

	/**
	 * 세션의 유효성을 검사한다
	 * 
	 * @param req
	 * @throws AofException
	 */
	public void requiredSession(HttpServletRequest req) throws Exception {
		if (SessionUtil.isValid(req) == false) {
			throw new AofException(Errors.INVALID_SESSION.desc);
		}
	}

	/**
	 * 세션의 유효성을 검사하고, Model의 regMemberSeq 와 updMemberSeq를 현재 세션의 사용자 정보로 set한다 insert, update, delete 등 db에 저장하는 controller에서 사용함.
	 * 
	 * @param req
	 * @param baseModel
	 * @throws AofException
	 */
	public void requiredSession(HttpServletRequest req, BaseVO... baseVOs) throws Exception {
		if (SessionUtil.isValid(req) == false) {
			throw new AofException(Errors.INVALID_SESSION.desc);
		}
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		if (baseVOs != null) {
			for (BaseVO vo : baseVOs) {
				if (vo == null) {
					continue;
				}
				vo.setRegMemberSeq(ssMember.getMemberSeq());
				vo.setRegIp(req.getRemoteAddr());
				vo.setUpdMemberSeq(ssMember.getMemberSeq());
				vo.setUpdIp(req.getRemoteAddr());
			}
		}
	}

	/**
	 * empty value 에 대해 디폴트값 설정
	 * 
	 * @param target
	 * @param pairValues
	 * @throws AofException
	 */
	public void emptyValue(Object target, String... pairValues) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();
		if (pairValues != null) {
			for (String pair : pairValues) {
				String[] values = pair.split("=");
				if (values.length == 2) {
					map.put(values[0], values[1]);
				}
			}
		}
		Iterator<String> it = map.keySet().iterator();
		while (it.hasNext()) {
			try {
				String name = it.next();
				PropertyDescriptor desc = BeanUtils.getPropertyDescriptor(target.getClass(), name);
				Method writeMethod = desc.getWriteMethod();
				if (writeMethod != null) {
					String writeValue = map.get(name);
					Method readMethod = desc.getReadMethod();
					Object readValue = readMethod.invoke(target, new Object[0]);
					String returnType = desc.getPropertyType().getName();
					if ("int".equals(returnType) || "java.lang.Integer".equals(returnType)) {
						if (readValue == null || Integer.parseInt(String.valueOf(readValue)) == 0) {
							writeMethod.invoke(target, new Object[] { Integer.parseInt(writeValue.trim()) });
						}
					} else if ("long".equals(returnType) || "java.lang.Long".equals(returnType)) {
						if (readValue == null || Long.parseLong(String.valueOf(readValue)) == 0) {
							writeMethod.invoke(target, new Object[] { Long.parseLong(writeValue.trim()) });
						}
					} else if ("float".equals(returnType) || "java.lang.Float".equals(returnType)) {
						if (readValue == null || Float.parseFloat(String.valueOf(readValue)) == 0) {
							writeMethod.invoke(target, new Object[] { Float.parseFloat(writeValue.trim()) });
						}
					} else if ("double".equals(returnType) || "java.lang.Double".equals(returnType)) {
						if (readValue == null || Double.parseDouble(String.valueOf(readValue)) == 0) {
							writeMethod.invoke(target, new Object[] { Double.parseDouble(writeValue.trim()) });
						}
					} else if ("java.lang.String".equals(returnType)) {
						if (readValue == null || String.valueOf(readValue).length() == 0) {
							writeMethod.invoke(target, new Object[] { writeValue });
						}
					}
				}
			} catch (Exception e) {
				log.debug(e.getMessage());
			}
		}

	}

}
