/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.lang.reflect.InvocationTargetException;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;

import com._4csoft.aof.infra.vo.base.BaseVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UnivBaseController.java
 * @Title : 대학 BaseController
 * @date : 2014. 3. 11.
 * @author : 서진철
 * @param <C>
 * @descrption : UnivBaseController에서 공통적으로 사용하는 method를 구현한다
 */
public class UnivBaseController extends BaseController {
	/**
	 * 개설과목 정보 VO에 넣어준다.<br>
	 * 
	 * <<자동 셋팅되는 개설과목 정보>><br>
	 * 1. courseMasterSeq(교과목 일련번호)<br>
	 * 2. courseActiveSeq(개설과목 일련번호)<br>
	 * 3. courseActiveTitle(개설과목 제목)<br>
	 * 4. year(년도)<br>
	 * 5. term(학기)<br>
	 * 6. division(분반)<br>
	 * 
	 * @param req
	 * @param vo
	 * @return
	 * @throws NoSuchMethodException
	 * @throws InvocationTargetException
	 * @throws IllegalAccessException
	 */
	protected void setCourseActive(HttpServletRequest req, BaseVO... baseVOs) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {

		Enumeration<?> courseActiveEnum = req.getAttributeNames();

		while (courseActiveEnum.hasMoreElements()) {
			String key = (String)courseActiveEnum.nextElement();

			if (key.indexOf("_CLASS_") == 0) {
				Object value = req.getAttribute(key);
				String methodName = key.replaceAll("_CLASS_", "");

				if (baseVOs != null) {
					for (BaseVO vo : baseVOs) {
						if (vo == null) {
							continue;
						}
						if (PropertyUtils.isWriteable(vo, methodName)) {
							PropertyUtils.setProperty(vo, methodName, value);
						}
					}
				}
			}
		}
	}

	/**
	 * 개설과목 정보 Class에 넣어준다.
	 * 
	 * @param req
	 * @param clazz
	 * @return
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 * @throws InstantiationException
	 */
	protected <C> C getCourseActive(HttpServletRequest req, Class<C> clazz) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException,
			InstantiationException {

		Enumeration<?> courseActiveEnum = req.getAttributeNames();

		C bean = clazz.newInstance();
		while (courseActiveEnum.hasMoreElements()) {
			String key = (String)courseActiveEnum.nextElement();

			if (key.indexOf("_CLASS_") == 0) {
				Object value = req.getAttribute(key);
				String methodName = key.replaceAll("_CLASS_", "");

				if (PropertyUtils.isWriteable(bean, methodName)) {
					PropertyUtils.setProperty(bean, methodName, value);
				}
			}
		}
		return bean;
	}
}
