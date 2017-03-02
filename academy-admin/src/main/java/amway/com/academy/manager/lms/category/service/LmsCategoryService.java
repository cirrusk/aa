package amway.com.academy.manager.lms.category.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.lib.DataBox;

public interface LmsCategoryService {

	public List<DataBox> selectCategoryList(RequestBox requestBox) throws Exception;
	public List<Map<String, String>> selectCategoryExcelList(RequestBox requestBox) throws Exception;
	
	public DataBox selectCategoryDetail(RequestBox requestBox) throws Exception;
	public int selectCategoryOrderCount(RequestBox requestBox) throws Exception;
	public int selectMaxCategoryId(RequestBox requestBox) throws Exception;
	public int selectCategorySameCodeCount(RequestBox requestBox) throws Exception;
	
	public int insertCategoryAjax(RequestBox requestBox) throws Exception;
	public int updateCategoryAjax(RequestBox requestBox) throws Exception;
	public int deleteCategoryAjax(RequestBox requestBox) throws Exception;
	
}
