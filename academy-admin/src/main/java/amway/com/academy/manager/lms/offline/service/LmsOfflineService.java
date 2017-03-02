package amway.com.academy.manager.lms.offline.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsOfflineService {

	// 오프라인 목록 카운트
	public int selectLmsOfflineCount(RequestBox requestBox) throws Exception;
	
	// 오프라인 목록
	public List<DataBox> selectLmsOfflineList(RequestBox requestBox) throws Exception;
	
	//오프라인 Excel  다운로드
	public List<Map<String, String>> selectLmsOfflineListExcelDown(RequestBox requestBox) throws Exception;

	// 오프라인 삭제
	public int deleteLmsOffline(RequestBox requestBox) throws Exception;
	
	// 오프라인 상세
	public DataBox selectLmsOffline(RequestBox requestBox) throws Exception;
	
	//오프라인 등록
	public int insertLmsOffline(RequestBox requestBox) throws Exception;
	
	// 오프라인 수정
	public int updateLmsOffline(RequestBox requestBox) throws Exception;
}
