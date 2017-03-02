package amway.com.academy.manager.reservation.baseCategory.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryMapper;
import amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService;
import amway.com.academy.manager.reservation.programInfo.web.ProgramInfoController;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

/**
 * <pre>
 * </pre>
 * Program Name  : BaseCategoryServiceImpl.java
 * Author : KR620207
 * Creation Date : 2016. 9. 1.
 */
@Service
public class BaseCategoryServiceImpl implements BaseCategoryService{

	private static final Logger LOGGER = LoggerFactory.getLogger(BaseCategoryServiceImpl.class);
	
	private int numberOne = 1;
	private int numberTwo = 2;
	private int numberThree = 3;
	
	@Autowired
	public BaseCategoryMapper baseCategoryDAO;

	@Override
	public List<DataBox> baseCategoryList(RequestBox requestBox) throws Exception {
		List<DataBox> listMap = baseCategoryDAO.baseCategoryList(requestBox);
		List<DataBox> returnList = new ArrayList<DataBox>();
		
		
		for(int i = 0; i < listMap.size(); i++){
			DataBox forMap = listMap.get(i);
			
			if(!("").equals(forMap.get("filekey"))){
				
				String filekey = StringUtil.getEncryptStr(forMap.getObject("filekey").toString());
				String uploadseq = StringUtil.getEncryptStr(forMap.getObject("uploadseq").toString());
				
				forMap.put("filekey", filekey);
				forMap.put("uploadseq", uploadseq);
				
			}
			
			returnList.add(forMap);
		}
		
		return returnList;
	}
	
	@Override
	public int baseCategoryListCount(RequestBox requestBox) throws Exception {
		return baseCategoryDAO.baseCategoryListCount(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService#parentCategoryInfo(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public DataBox parentCategoryInfo(RequestBox requestBox) throws Exception {
		DataBox map = baseCategoryDAO.parentCategoryInfo(requestBox);
		
		
		if(map != null){
			if(!("").equals(map.get("filekey"))){
				String filekey = StringUtil.getEncryptStr(map.getObject("filekey").toString());
				String uploadseq = StringUtil.getEncryptStr(map.getObject("uploadseq").toString());
				
				map.put("filekey", filekey);
				map.put("uploadseq", uploadseq);
			}
		}
		
		return map;
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService#isAvailableCategoryTypeCode(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public boolean isAvailableCategoryTypeCode(RequestBox requestBox) throws Exception {
		return baseCategoryDAO.isAvailableCategoryTypeCode(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService#baseCategoryInsertAjax(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public int baseCategoryInsert(RequestBox requestBox) throws Exception {

 		int transactionResult = 0;
 		
		
		try {
			
//			DataBox searchExpTypeSeq = baseCategoryDAO.searchExpTypeSeq(requestBox);
//			if(searchExpTypeSeq != null){
// 			requestBox.remove("typeseq");
//				requestBox.put("typeseq", searchExpTypeSeq.get("typeseq"));
				
				int typeLevel = Integer.parseInt("".equals(requestBox.getString("typelevel")) ? "0" : requestBox.getString("typelevel"));
				typeLevel++;
				requestBox.put("typelevel", typeLevel);
				
				if(numberOne == typeLevel){
					DataBox categorytype1MaxValue = baseCategoryDAO.searchCategorty1MaxValue(requestBox);
					
					requestBox.put("categorytype1", categorytype1MaxValue.get("categorytype1"));
					requestBox.put("categoryname1", requestBox.getString("categoryname"));
				}else if(numberTwo == typeLevel){
					DataBox categorty2MaxValue = baseCategoryDAO.searchCategorty2MaxValue(requestBox);
					
					requestBox.put("categorytype2", categorty2MaxValue.get("categorytype2"));
					requestBox.put("categoryname2", requestBox.getString("categoryname"));
				}else if(numberThree == typeLevel){
					DataBox categorty3MaxValue = baseCategoryDAO.searchCategorty3MaxValue(requestBox);
					
					requestBox.put("categorytype3", categorty3MaxValue.get("categorytype3"));
					requestBox.put("categoryname3", requestBox.getString("categoryname"));
				}else{
					throw new Exception("require typelevel");
				}
				
				transactionResult = baseCategoryDAO.baseCategoryInsert(requestBox); 
//			}
		
			
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
 		return transactionResult;
	}

	/* (non-Javadoc)
	 * @see amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService#baseCategoryUpdateAjax(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public int baseCategoryUpdate(RequestBox requestBox) throws Exception {
		
		int transactionResult = 0;
		
		try{
			int typeLevel = Integer.parseInt("".equals(requestBox.getString("typelevel")) ? "0" : requestBox.getString("typelevel"));
			
			if(numberOne == typeLevel){
				requestBox.put("categorytype1", requestBox.getString("categorytype"));
				requestBox.put("categoryname1", requestBox.getString("categoryname"));
			}else if(numberTwo == typeLevel){
				requestBox.put("categorytype2", requestBox.getString("categorytype"));
				requestBox.put("categoryname2", requestBox.getString("categoryname"));
			}else if(numberThree == typeLevel){
				requestBox.put("categorytype3", requestBox.getString("categorytype"));
				requestBox.put("categoryname3", requestBox.getString("categoryname"));
			}else{
				throw new Exception("require typelevel");
			}

			transactionResult = baseCategoryDAO.baseCategoryUpdate(requestBox);
			
			/* sync category name */
			baseCategoryDAO.updateOneLevelCategoryName(requestBox);
			baseCategoryDAO.updateTwoLevelCategoryName(requestBox);
			baseCategoryDAO.updateThreeLevelCategoryName(requestBox);
			
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
		return transactionResult;
	}

	/* (non-Javadoc)
	 * @see amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService#baseCategoryDeleteAjax(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public int baseCategoryDelete(RequestBox requestBox) throws Exception {
		return baseCategoryDAO.baseCategoryDelete(requestBox);
	}

}
