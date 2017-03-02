package amway.com.academy.manager.common.commoncode.service.impl;

import java.net.Inet4Address;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
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
public class ManageCodeServiceImpl implements ManageCodeService {

	@Autowired
	private ManageCodeMapper manageCodeMapper;
	
	public static String sessionAdno = "sessionAdno";
	
	/**
	 * 공통 코드 리스트
	 */
	@Override
	public List<Map<String, String>> getCodeList(Map<String, String> params) {
		// TODO Auto-generated method stub
		List<Map<String, String>> list = null;
		
		
		if( params.get("majorCd").equals("pageCnt") ) {
			// pageCnt 교육비 그리드 페이지 리스트
			list = manageCodeMapper.getPageCntList(params);
		} else if( params.get("majorCd").equals("timeList") ) {
			// 교육비 시간 리스트
			list = manageCodeMapper.getTimeList(params);
		} else {
			list = manageCodeMapper.getCodeList(params);
		}
		
		return list;
	}
	
	/**
	 * 공통 개인정보 조회 이력 남기기
	 */
	@Override
	public void selectCurrentAdNoHistory(RequestBox requestBox) {
		Map<String, Object> requestMap = new HashMap<String, Object>();
		
		// 접속자 정보
		HttpSession session = requestBox.getHttpSession();
		
		// 접속자 IP
		String conIp;
		try {
			conIp = Inet4Address.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			conIp = "127.0.0.1";
			e.printStackTrace();
		}
		
		String addr = requestBox.get("reqeustServletName").toString();
		String arrUrl[] = addr.split("/");
		String pageUrl = "";
		String menuCode = "";
		int lastNum = arrUrl.length-1;
		
		for(int i=0; i<arrUrl.length;i++){
			if(i>0) {
				if(i==lastNum) menuCode = arrUrl[i];
				if(i!=lastNum) pageUrl = pageUrl + "/" + arrUrl[i];
			}
		}
				
		requestMap.put("adno", session.getAttribute(sessionAdno));
		requestMap.put("conip", conIp);
		requestMap.put("pageurl", pageUrl);
		requestMap.put("menucode", menuCode);
		requestMap.put("logdetail", "select");

		manageCodeMapper.selectCurrentAdd(requestMap);
	}

	
}