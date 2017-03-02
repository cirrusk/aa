package amway.com.academy.manager.reservation.baseCategory.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * </pre>
 * Program Name  : BaseCategoryMapper.java
 * Author : KR620207
 * Creation Date : 2016. 9. 1.
 */
@Mapper
public interface BaseCategoryMapper {
	
	public List<DataBox> baseCategoryList(RequestBox requestBox) throws Exception;
	
	public int baseCategoryListCount(RequestBox requestBox) throws Exception;
	
	public DataBox parentCategoryInfo(RequestBox requestBox) throws Exception;
	
	public boolean isAvailableCategoryTypeCode(RequestBox requestBox) throws Exception;

	public int baseCategoryInsert(RequestBox requestBox) throws Exception;
	
	public int baseCategoryUpdate(RequestBox requestBox) throws Exception;
	
	public int baseCategoryDelete(RequestBox requestBox) throws Exception;
	
	
	public int updateOneLevelCategoryName(RequestBox requestBox) throws Exception;
	public int updateTwoLevelCategoryName(RequestBox requestBox) throws Exception;
	public int updateThreeLevelCategoryName(RequestBox requestBox) throws Exception;
	
	public DataBox searchExpTypeSeq (RequestBox requestBox) throws Exception;
	
	public DataBox searchCategorty1MaxValue(RequestBox requestBox) throws Exception;
	
	public DataBox searchCategorty2MaxValue(RequestBox requestBox) throws Exception;
	
	public DataBox searchCategorty3MaxValue(RequestBox requestBox) throws Exception;
}
