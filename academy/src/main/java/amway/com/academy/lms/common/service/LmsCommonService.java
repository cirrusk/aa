package amway.com.academy.lms.common.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsCommonService {
	
	//공통코드 리스트
	public List<DataBox> selectLmsCommonCodeList(RequestBox requestBox) throws Exception;
	
	//교육분류 리스트
	public List<DataBox> selectLmsCategoryCodeList(RequestBox requestBox) throws Exception;
	
	//교육분류 3단
	public DataBox selectLmsCategoryCode3Depth(RequestBox requestBox) throws Exception;
	
	//교육장소 코드 리스트
	public List<DataBox> selectLmsApCodeList(RequestBox requestBox) throws Exception;
	
	//교육장소강의실 코드 리스트
	public List<DataBox> selectLmsRoomCodeList(RequestBox requestBox) throws Exception;

	//로그인 테스트
	public DataBox selectLmsLogin(RequestBox requestBox) throws Exception;
	
	//SNS 카운트 증가하기
	public int mergeSnsShareCount(RequestBox requestBox) throws Exception;
	
	//stamp login
	public int updateLmsLoginStamp(RequestBox requestBox) throws Exception;
	
	//쪽지 등록
	public int insertLmsNoteSend(RequestBox requestBox) throws Exception;	

	// 회원정보 잃기
	public DataBox selectLmsMemberInfo(RequestBox requestBox) throws Exception;

	// 교육자료 파일정보 읽기
	public DataBox selectLmsCourseDataFileInfo(RequestBox requestBox) throws Exception;
}