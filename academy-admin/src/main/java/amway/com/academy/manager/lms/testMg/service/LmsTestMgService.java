package amway.com.academy.manager.lms.testMg.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsTestMgService {

	List<DataBox> selectLmsTestMgCategoryList();
	public List<Map<String, String>> selectLmsTestMgExcelList(RequestBox requestBox) throws Exception;
	
	int selectLmsTestMgCount(RequestBox requestBox);

	List<DataBox> selectLmsTestMgList(RequestBox requestBox);

	DataBox selectLmsTestMgDetail(RequestBox requestBox);

	List<Map<String,String>> selectLmsTestPoolTotalList(RequestBox requestBox);
	
	List<Map<String,String>> selectLmsTestMgSubmitList(RequestBox requestBox);
	
	
	public int insertLmsTestMgAjax(RequestBox requestBox) throws Exception;
	public int updateLmsTestMgAjax(RequestBox requestBox) throws Exception;
	
	public int deleteLmsTestMgAjax(RequestBox requestBox) throws Exception;
	
}
