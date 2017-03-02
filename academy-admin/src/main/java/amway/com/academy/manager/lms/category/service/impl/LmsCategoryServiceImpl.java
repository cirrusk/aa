package amway.com.academy.manager.lms.category.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.lms.category.service.LmsCategoryService;

@Service
public class LmsCategoryServiceImpl implements LmsCategoryService {

	@Autowired
	private LmsCategoryMapper lmsCategoryMapper;
	
	@Override
	public List<DataBox> selectCategoryList(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectCategoryList(requestBox);
	}	
	
	@Override
	public List<Map<String, String>> selectCategoryExcelList(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectCategoryExcelList(requestBox);
	}	
	
	
	@Override
	public DataBox selectCategoryDetail(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectCategoryDetail(requestBox);
	}
	
	@Override
	public int selectCategoryOrderCount(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectCategoryOrderCount(requestBox);
	}
	
	@Override
	public int selectMaxCategoryId(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectMaxCategoryId(requestBox);
	}
	
	@Override
	public int selectCategorySameCodeCount(RequestBox requestBox) throws Exception {
		return lmsCategoryMapper.lmsSelectCategorySameCodeCount(requestBox);
	}
	
	@Override
	public int insertCategoryAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		result = lmsCategoryMapper.lmsInsertCategoryAjax(requestBox);
		
		return result;
	}
	
	@Override
	public int updateCategoryAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		result = lmsCategoryMapper.lmsUpdateCategoryAjax(requestBox);
		
		return result;
	}
	
	@Override
	public int deleteCategoryAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		result = lmsCategoryMapper.lmsDeleteCategoryAjax(requestBox);
		
		return result;
	}
	
}
