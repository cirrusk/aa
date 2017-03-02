package amway.com.academy.manager.common.searchabo.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.searchabo.service.SearchAboService;
import framework.com.cmm.lib.DataBox;
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
public class SearchAboServiceImpl implements SearchAboService {

	@Autowired
	private SearchAboMapper searchAboMapper;
	
	@Override
	public Map<String, Object> selectAboData(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return searchAboMapper.selectAboData(requestBox);
	}

	@Override
	public int selectAboDataCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return searchAboMapper.selectAboDataCount(requestBox);
	}

	@Override
	public int selectAboListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return searchAboMapper.selectAboDataCount(requestBox);
	}

	@Override
	public List<DataBox> selectAboList(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return searchAboMapper.selectAboList(requestBox);
	}

	
}