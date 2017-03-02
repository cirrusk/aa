package amway.com.academy.manager.lms.test.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsTestPoolService {

	public int selectCategoryTestCount(RequestBox requestBox) throws Exception;
	public List<DataBox> selectCategoryTestList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectCategoryTestExcelList(RequestBox requestBox) throws Exception;

	public int selectMaxCategoryTestId(RequestBox requestBox) throws Exception;
	
	public int deleteCategoryTest(RequestBox requestBox) throws Exception;
	public int insertCategoryTestAjax(RequestBox requestBox) throws Exception;
	public int updateCategoryTestAjax(RequestBox requestBox) throws Exception;
	
	public DataBox selectCategoryTestDetail(RequestBox requestBox) throws Exception;

	
	public int selectTestPoolCount(RequestBox requestBox) throws Exception;
	public List<DataBox> selectTestPoolList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectTestPoolExcelList(RequestBox requestBox) throws Exception;
	
	public DataBox selectTestPoolDetail(RequestBox requestBox) throws Exception;
	public List<DataBox> selectTestPoolAnswerList(RequestBox requestBox) throws Exception;
	
	
	public int insertTestPoolAjax(RequestBox requestBox) throws Exception;
	public int updateTestPoolAjax(RequestBox requestBox) throws Exception;
	public int deleteTestPool(RequestBox requestBox) throws Exception;
	
	public int insertTestPoolExcelAjax(RequestBox requestBox, List<Map<String,String>> list) throws Exception;
	
}
