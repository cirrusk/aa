package amway.com.academy.manager.lms.test.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsTestPoolMapper {

	public int lmsSelectCategoryTestCount(RequestBox requestBox) throws Exception;
	public int lmsSelectMaxCategoryTestId(RequestBox requestBox) throws Exception;
	
	public List<DataBox> lmsSelectCategoryTestList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> lmsSelectCategoryTestExcelList(RequestBox requestBox) throws Exception;
	
	public int lmsDeleteCategoryTest(RequestBox requestBox) throws Exception;
	public int lmsInsertCategoryTestAjax(RequestBox requestBox) throws Exception;
	public int lmsUpdateCategoryTestAjax(RequestBox requestBox) throws Exception;
	
	public DataBox lmsSelectCategoryTestDetail(RequestBox requestBox) throws Exception;
	
	public int lmsSelectTestPoolCount(RequestBox requestBox) throws Exception;
	public List<DataBox> lmsSelectTestPoolList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> lmsSelectTestPoolExcelList(RequestBox requestBox) throws Exception;
	
	public DataBox lmsSelectTestPoolDetail(RequestBox requestBox) throws Exception;
	public List<DataBox> lmsSelectTestPoolAnswerList(RequestBox requestBox) throws Exception;

	public int lmsInsertTestPoolAjax(RequestBox requestBox) throws Exception;
	public int lmsInsertTestPoolAnswerAjax(RequestBox requestBox) throws Exception;
	public int lmsUpdateTestPoolAjax(RequestBox requestBox) throws Exception;
	public int lmsDeleteTestPoolAnswerAjax(RequestBox requestBox) throws Exception;
	
	public int lmsDeleteTestPool(RequestBox requestBox) throws Exception;
	
}
