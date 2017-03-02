package amway.com.academy.manager.lms.testMg.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsTestMgMapper {

	List<DataBox> selectLmsTestMgCategoryList();

	int selectLmsTestMgCount(RequestBox requestBox);

	List<DataBox> selectLmsTestMgList(RequestBox requestBox);
	List<Map<String, String>> selectLmsTestMgExcelList(RequestBox requestBox) throws Exception;

	DataBox selectLmsTestMgDetail(RequestBox requestBox);
	List<Map<String,String>> selectLmsTestPoolTotalList(RequestBox requestBox);
	
	List<Map<String,String>> selectLmsTestMgSubmitList(RequestBox requestBox);
	
	public int insertLmsTest(RequestBox requestBox) throws Exception;
	public int insertLmsTestSubmit(RequestBox requestBox) throws Exception;
	public int updateLmsTest(RequestBox requestBox) throws Exception;
	public int deleteLmsTestSubmit(RequestBox requestBox) throws Exception;
}
