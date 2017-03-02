package com._4csoft.aof.ui.univ.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseActiveElementMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveElementService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.univ.service.impl.UnivCourseActiveElementServiceImpl;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseActiveElementServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 7. 7.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseActiveElementService")
public class UIUnivCourseActiveElementServiceImpl extends UnivCourseActiveElementServiceImpl implements UIUnivCourseActiveElementService {
	@Resource (name = "UIUnivCourseActiveElementMapper")
	private UIUnivCourseActiveElementMapper uiCourseActiveElementMapper;

	public List<UIUnivCourseActiveElementVO> getListElementCount(UnivCourseActiveElementVO vo) throws Exception {

		// [1]. key값 검사
		if (StringUtil.isEmpty(vo.getCourseActiveSeq())) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "courseActiveSeq" });
		}

		return uiCourseActiveElementMapper.getListElementCount(vo);
	}

}
