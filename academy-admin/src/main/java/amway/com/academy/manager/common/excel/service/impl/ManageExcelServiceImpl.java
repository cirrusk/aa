package amway.com.academy.manager.common.excel.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.excel.service.ManageExcelService;
import framework.com.cmm.lib.RequestBox;

/**-----------------------------------------------------------------------------
 * @PROJ  :Win
 * @NAME  :ManageBbsServiceImpl.java
 * @DESC  :관리자 게시판 관리 ( 공지사항, Q&A, 자료실 ) ServiceImpl
 * @Author:huny9224
 * @VER : 1.0
 *------------------------------------------------------------------------------
 *                  변         경         사         항                       
 *------------------------------------------------------------------------------
 *    DATE         AUTHOR                        DESCRIPTION                        
 * -------------   ------    ---------------------------------------------------
 * 2015. 11. 02.   IHJ       최초작성
 * -----------------------------------------------------------------------------
 */
@Service
public class ManageExcelServiceImpl implements ManageExcelService {

	@Autowired
	private ManageExcelMapper dao;

	@Override
	public int insertExcelData(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		int result = 0;
		if( params.get("cnt").equals(0)){
			result = dao.insertTargetExcelData(params);
		} else {
			result = dao.updateTargetExcelData(params);
		}
		
		if( params.get("giveCnt").equals(0)){
			result = dao.insertGiveTargetExcelData(params);
		} else {			
			result = dao.updateGiveTargetExcelData(params);
		}
		
		if( params.get("scheduleCnt").equals(0)){
			result = dao.insertScheduleExcelData(params);
		} else {
			result = dao.updateScheduleExcelData(params);
		}
		
		if( params.get("groupCdCnt").equals(0)){
			result = dao.insertGroupCodeExcelData(params);
		}
				
		return result;
	}
	
	@Override
	public int insertAgreeExcelData(Map<String, Object> params) throws Exception {
		int result = 0;
		int selcnt = 0;
		selcnt = dao.selectAgreeExcelData(params);
		
		if(selcnt==0) {
			result = dao.insertAgreeExcelData(params);
		}
		
//		selcnt = dao.selectAgreeExcelData1(params);
//		
//		if(selcnt==0) {
//			result = dao.insertAgreeExcelData1(params);
//		}		
		
		return result;
	}

	@Override
	public int selectTargetExcelData(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return dao.selectTargetExcelData(paramMap);
	}
	
	@Override
	public int selectGiveTargetExcelData(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return dao.selectGiveTargetExcelData(paramMap);
	}
	
	@Override
	public int selectScheduleExcelData(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return dao.selectScheduleExcelData(paramMap);
	}

	@Override
	public int selectGroupCodeExcelData(Map<String, Object> paramMap)
			throws Exception {
		// TODO Auto-generated method stub
		return dao.selectGroupCodeExcelData(paramMap);
	}

	@Override
	public String[][] validExcelData(String[][] importData, RequestBox requestBox) {
		// TODO Auto-generated method stub
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String[] strData = {};
		
		for(int i=0;i<importData.length;i++) {
  			strData = importData[i];
  			
  			if("agree".equals(requestBox.get("page"))) {
  				paramMap.put("fiscalyear"   , requestBox.get("fiscalyear"));
  				paramMap.put("abono"   , strData[1]);
  				paramMap.put("depabono", strData[0]);
  				
  				int result = dao.selectValidAgree(paramMap);
  				int reNum = 1;
  				if( result < reNum ) {
  					importData[0][0] = "-1";
  					importData[0][1] = "["+(i+2)+"행] 교육비 위임 대상자에 존재 하지 않는 ABO 입니다.";
  					break;
  				} else {
  					continue;
  				}
  			}
		}
		
		return importData;
	}
	
}