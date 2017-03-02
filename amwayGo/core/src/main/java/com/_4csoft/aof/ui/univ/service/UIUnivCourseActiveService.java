/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.univ.service.UnivCourseActiveService;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseActiveService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseActiveService extends UnivCourseActiveService {

	public int updateCourseActive(UIUnivCourseActiveVO vo, UIAttachVO attach) throws Exception;
}
