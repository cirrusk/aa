package amway.com.academy.manager.lms.category.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsCategoryMapper {

	List<DataBox> lmsSelectCategoryList(RequestBox requestBox) throws Exception;
	List<Map<String, String>> lmsSelectCategoryExcelList(RequestBox requestBox) throws Exception;
	
	public DataBox lmsSelectCategoryDetail(RequestBox requestBox) throws Exception;
	public int lmsSelectCategoryOrderCount(RequestBox requestBox) throws Exception;
	public int lmsSelectMaxCategoryId(RequestBox requestBox) throws Exception;
	public int lmsSelectCategorySameCodeCount(RequestBox requestBox) throws Exception;
	
	public int lmsInsertCategoryAjax(RequestBox requestBox) throws Exception;
	public int lmsUpdateCategoryAjax(RequestBox requestBox) throws Exception;
	public int lmsDeleteCategoryAjax(RequestBox requestBox) throws Exception;
	
}