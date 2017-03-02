package amway.com.academy.manager.lms.data.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsDataService {

	// 교육자료 목록 카운트
	public int selectLmsDataCount(RequestBox requestBox) throws Exception;
	
	// 교육자료 목록
	public List<DataBox> selectLmsDataList(RequestBox requestBox) throws Exception;
	
	//교육자료 Excel  다운로드
	public List<Map<String, String>> selectLmsDataListExcelDown(RequestBox requestBox) throws Exception;

	// 교육자료 삭제
	public int deleteLmsData(RequestBox requestBox) throws Exception;
	
	// 교육자료 상세
	public DataBox selectLmsData(RequestBox requestBox) throws Exception;
	
	//교육자료 등록
	public int insertLmsData(RequestBox requestBox) throws Exception;
	
	// 교육자료 수정
	public int updateLmsData(RequestBox requestBox) throws Exception;
	
	public int copyLmsDataAjax(RequestBox requestBox) throws Exception;
}
