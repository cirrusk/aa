package amway.com.academy.manager.reservation.baseCategory.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 
 * 브랜드 카테고리 관리
 * @author KR620207
 *
 */
public interface BaseCategoryService {

	public List<DataBox> baseCategoryList(RequestBox requestBox) throws Exception;
	
	public int baseCategoryListCount(RequestBox requestBox) throws Exception;
	
	public DataBox parentCategoryInfo(RequestBox requestBox) throws Exception;
	
	public boolean isAvailableCategoryTypeCode(RequestBox requestBox) throws Exception;
	
	public int baseCategoryInsert(RequestBox requestBox) throws Exception;
	
	public int baseCategoryUpdate(RequestBox requestBox) throws Exception;
	
	public int baseCategoryDelete(RequestBox requestBox) throws Exception;
	
}
