package amway.com.academy.manager.lms.course.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsCourseService {

	// 과정기본정보 상세
	public DataBox selectLmsCourse(RequestBox requestBox) throws Exception;

	//테마 리스트
	public List<DataBox> selectLmsThemeList(RequestBox requestBox) throws Exception;
	public List<DataBox> selectLmsCourseConditionList(RequestBox requestBox) throws Exception;
	public List<DataBox> selectLmsCourseConditionDiaList(RequestBox requestBox) throws Exception;
	
	public List<DataBox> selectLmsTargetCodeList(RequestBox requestBox) throws Exception;
	public List<DataBox> selectLmsTargetConditionList(RequestBox requestBox) throws Exception;

}
