package amway.com.academy.manager.common.auth.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface AuthService {
	public List<DataBox> selectAuthGroupList(RequestBox requestBox) throws Exception;
	
	public int selectAuthGroupListTotalCount(RequestBox requestBox) throws Exception;
	
	//Pop 리스트
	public List<DataBox> authGroupListPopAjax(RequestBox requestBox) throws Exception;
	//Pop 리스트 카운트
	public int authGroupListPopCount(RequestBox requestBox) throws Exception;
	
	//popUp 수정
	public int authGroupListPopUpdateAjax(RequestBox requestBox) throws Exception;

	//운영자 로그 등록
	public int userLogInsert(RequestBox requestBox) throws Exception;
	
	//pp 리스트
	public List<DataBox> selectPpList() throws Exception;
	
	//메뉴 리스트 불러오기
	public List<DataBox> authGroupListRightDivAjax(RequestBox requestBox) throws Exception;
	
	//오른쪽 DIv 정보
	public DataBox authGroupListManagerInfo(RequestBox requestBox) throws Exception;
	
	//popUp 운영자 개별 등록
	public int authGroupListPopInsertAjax(RequestBox requestBox) throws Exception;
	
	//EXCEL로 운영자 등록
	public Map<String,Object> authGroupListPopExcelUploadAjax(RequestBox requestBox, List<Map<String, String>> retSuccessList) throws Exception;
	
	//메뉴 권한 설정
	public int authGroupListMenuAuthSaveAjax(RequestBox requestBox) throws Exception;
	
	//운영자 삭제
	public int authGroupListManagerDeleteAjax(RequestBox requestBox) throws Exception;
}