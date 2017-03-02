package amway.com.academy.manager.lms.live.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsLiveService {

	// 라이브 목록 카운트
	public int selectLmsLiveCount(RequestBox requestBox) throws Exception;
	
	// 라이브 목록
	public List<DataBox> selectLmsLiveList(RequestBox requestBox) throws Exception;
	
	// 라이브 Excel  다운로드
	public List<Map<String, String>> selectLmsLiveListExcelDown(RequestBox requestBox) throws Exception;

	// 라이브 삭제
	public int deleteLmsLive(RequestBox requestBox) throws Exception;
		
	// 라이브 상세
	public DataBox selectLmsLive(RequestBox requestBox) throws Exception;
		
	// 라이브 등록
	public int insertLmsLive(RequestBox requestBox) throws Exception;
		
	// 라이브 수정
	public int updateLmsLive(RequestBox requestBox) throws Exception;

}