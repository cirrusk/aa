package amway.com.academy.manager.lms.online.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsOnlineService {

	// 온라인 목록 카운트
	public int selectLmsOnlineCount(RequestBox requestBox) throws Exception;
	
	// 온라인 목록
	public List<DataBox> selectLmsOnlineList(RequestBox requestBox) throws Exception;
	
	//온라인 Excel  다운로드
	public List<Map<String, String>> selectLmsOnlineListExcelDown(RequestBox requestBox) throws Exception;

	// 온라인 삭제
	public int deleteLmsOnline(RequestBox requestBox) throws Exception;
	
	// 온라인 상세
	public DataBox selectLmsOnline(RequestBox requestBox) throws Exception;
	
	//온라인 등록
	public int insertLmsOnline(RequestBox requestBox) throws Exception;
	
	// 온라인 수정
	public int updateLmsOnline(RequestBox requestBox) throws Exception;
}
