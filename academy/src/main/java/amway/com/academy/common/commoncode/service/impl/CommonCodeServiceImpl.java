package amway.com.academy.common.commoncode.service.impl;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.common.commoncode.service.CommonCodeService;

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
public class CommonCodeServiceImpl implements CommonCodeService {

	@Autowired
	private CommonCodeMapper commonCodeMapper;
	
	/**
	 * 공통 코드 리스트
	 */
	@Override
	public List<Map<String, String>> getCodeList(Map<String, String> params) {
		// TODO Auto-generated method stub
		List<Map<String, String>> list = null;
		
		
		if( params.get("majorCd").equals("edukind") ) {
			// 교육비 - 교육종류
			list = commonCodeMapper.getEduKindList(params);
		} else if( params.get("majorCd").equals("spenditem") ) {
			// 교육비 - 지출항목
			list = commonCodeMapper.getSpendItemList(params);
		} else if( params.get("majorCd").equals("schYear") ) {
			// 교육비 - 년도 조회 현재 년도 +1 에서 -3 까지
			list = commonCodeMapper.getSearchYearList(params);
		} else {
			list = commonCodeMapper.getCodeList(params);
		}
		
		return list;
	}

	@Override
	public DataBox getAnalyticsTag(RequestBox requestBox) {

		DataBox checkResult = commonCodeMapper.getAnalyticsTag(requestBox);

		return checkResult;
	}

	@Override
	public DataBox getCheckVisitor(RequestBox requestBox) {

		DataBox checkResult = commonCodeMapper.getCheckVisitor(requestBox);

		return checkResult;
	}
}