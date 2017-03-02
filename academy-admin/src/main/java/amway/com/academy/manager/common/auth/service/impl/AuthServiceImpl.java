package amway.com.academy.manager.common.auth.service.impl;

import java.net.Inet4Address;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import amway.com.academy.manager.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.auth.service.AuthService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class AuthServiceImpl extends EgovAbstractServiceImpl implements AuthService {
	@Autowired
	private AuthMapper authDAO;
	
	/**
	 * 관리자 권한 그룹 목록을 조회한다.
	 * @param RequestBox requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	public List<DataBox> selectAuthGroupList(RequestBox requestBox) throws Exception {
		return authDAO.selectAuthGroupList(requestBox);
	}
	
	public int selectAuthGroupListTotalCount(RequestBox requestBox) throws Exception {
		return authDAO.selectAuthGroupListTotalCount(requestBox);
	}
	
	//Pop 리스트
	@Override
	public List<DataBox> authGroupListPopAjax(RequestBox requestBox) throws Exception {
		return authDAO.authGroupListPopAjax(requestBox);
	}
	
	//Pop 리스트 카운트
	@Override
	public int authGroupListPopCount(RequestBox requestBox) throws Exception {
		return authDAO.authGroupListPopCount(requestBox);
	}
	
	//popUp 수정
	@Override
	public int authGroupListPopUpdateAjax(RequestBox requestBox) throws Exception {
		return authDAO.authGroupListPopUpdateAjax(requestBox);
	}

	//운영자 로그 등록
	@Override
	public int userLogInsert(RequestBox requestBox) throws Exception {
		requestBox.put("adminid", requestBox.getSession( SessionUtil.sessionAdno ));

		String conIp;
		try {
			conIp = Inet4Address.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			conIp = "127.0.0.1";
			e.printStackTrace();
		}
		requestBox.put("conip", conIp);

		return authDAO.userLogInsert(requestBox);
	}

	//pp 리스트
	@Override
	public List<DataBox> selectPpList() throws Exception {
		return authDAO.selectPpList();
	}
	
	//메뉴 리스트 불러오기
	@Override
	public List<DataBox> authGroupListRightDivAjax(RequestBox requestBox)throws Exception {
		return authDAO.authGroupListRightDivAjax(requestBox);
	}
	
	//오른쪽 DIv 정보
	@Override
	public DataBox authGroupListManagerInfo(RequestBox requestBox)throws Exception {
		return authDAO.authGroupListManagerInfo(requestBox);
	}
	
	//popUp 운영자 개별 등록
	@Override
	public int authGroupListPopInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		//ad계정 중복 체크
		String checkAdno = authDAO.authGroupListPopCheckAdno(requestBox);
		//popUp 운영자 개별 등록
		if(checkAdno.equals("N"))
		{
			result = authDAO.authGroupListPopInsertAjax(requestBox);

			// 운영자 로그
			requestBox.put("logdetail", "insert");
			this.userLogInsert(requestBox);
		}
		else
		{
			result = 2;
		}
		
		return result;
	}
	
	//EXCEL로 운영자 등록
	@Override
	public Map<String, Object> authGroupListPopExcelUploadAjax(RequestBox requestBox, List<Map<String, String>> retSuccessList)  throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = 0;
		String comment = "";
		StringBuffer comBuffer = new StringBuffer();
		int reNum = 0;
		
		boolean isValid = true;
		if( retSuccessList != null && retSuccessList.size() > reNum ) {
			for( int i=0; i<retSuccessList.size(); i++ ) {
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				requestBox.put("adno",retSuccessMap.get("col0"));
				requestBox.put("ppseq",retSuccessMap.get("col3"));
					
				//MANAGER 테이블에 해당 uid가 있는지 Check하기
				String checkAdno= authDAO.authGroupListPopCheckAdno(requestBox);
				//ppseq가 존재하는지 확인하기
				String ppseqCheck = authDAO.ppseqExistCheck(requestBox);

				if(checkAdno.equals("Y"))
				{	
					isValid = false;
					comBuffer.append((i+2)+"행의 AD번호가 멤버테이블에 존재합니다.\r\n");
				}
				//멤버에 UID존재함
				else if(checkAdno.equals("N"))
				{
					if(!requestBox.get("ppseq").equals("") && ppseqCheck.equals("N"))
					{
						isValid = false;
						comBuffer.append((i+2)+"행의 PP가 존재하지 않는 PP입니다.\r\n");
					}
					
				}
			}//end for
			comment = comBuffer.toString();
			rtnMap.put("comment", comment);
		}
		
		if(isValid)
		{
			for( int i=0; i<retSuccessList.size(); i++ ) {
				
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				requestBox.put("adno",retSuccessMap.get("col0"));
				requestBox.put("managename",retSuccessMap.get("col1"));
				requestBox.put("managedepart",retSuccessMap.get("col2"));
				requestBox.put("ppseq",retSuccessMap.get("col3"));
				
				//EXCEL로 운영자 등록
				authDAO.authGroupListPopInsertAjax(requestBox);
				// 운영자 로그
				requestBox.put("logdetail", "insert");
				this.userLogInsert(requestBox);
				
				cnt++;
			}//end for
			rtnMap.put("cnt", cnt);
		}
		
		return rtnMap;
	}
	
	//메뉴 권한 설정
	@Override
	public int authGroupListMenuAuthSaveAjax(RequestBox requestBox) throws Exception {
		
		//메뉴권한 초기화
		int result = authDAO.authGroupListMenuAuthDelete(requestBox);
		
		for(int i=0;i<requestBox.getVector("menucodes").size();i++)
		{
			String menucode = requestBox.getVector("menucodes").get(i).toString();
			
			requestBox.put("menucode", menucode);
			requestBox.put("menuauth", requestBox.getString(menucode+"authradio"));
			
			authDAO.authGroupListMenuAuthInsert(requestBox);
			
			result ++;
		}
		if (result > 0) {
			authDAO.authGroupListMenuAuthUpdate(requestBox);
			authDAO.authLogInsert(requestBox);
		}
		
		return result;
	}
	
	//운영자 삭제
	@Override
	public int authGroupListManagerDeleteAjax(RequestBox requestBox) throws Exception {
		
		//메뉴권한 초기화
		authDAO.authGroupListMenuAuthDelete(requestBox);
		
		int result = authDAO.authGroupListManagerDeleteAjax(requestBox);
		
		return result;
	}
}
































