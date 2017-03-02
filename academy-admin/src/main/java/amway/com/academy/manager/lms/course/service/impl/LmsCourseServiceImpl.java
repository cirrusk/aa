package amway.com.academy.manager.lms.course.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.course.service.LmsCourseService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsCourseServiceImpl implements LmsCourseService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCourseServiceImpl.class);
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;

	// 과정 공통 상세
	@Override
	public DataBox selectLmsCourse(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsCourse(requestBox);
	}
	
	
	// 테마 리스트
	@Override
	public List<DataBox> selectLmsThemeList(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsThemeList(requestBox);
	}

	// 검색 조건 리스트
	@Override
	public List<DataBox> selectLmsCourseConditionList(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsCourseConditionList(requestBox);
	}

	@Override
	public List<DataBox> selectLmsCourseConditionDiaList(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsCourseConditionDiaList(requestBox);
	}
	
	@Override
	public List<DataBox> selectLmsTargetCodeList(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsTargetCodeList(requestBox);
	}
	
	@Override
	public List<DataBox> selectLmsTargetConditionList(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.selectLmsTargetConditionList(requestBox);
	}
	
}
