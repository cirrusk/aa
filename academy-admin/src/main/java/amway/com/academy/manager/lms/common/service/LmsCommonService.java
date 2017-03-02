package amway.com.academy.manager.lms.common.service;

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
	
	//쪽지 등록
	public int insertLmsNoteSend(RequestBox requestBox) throws Exception;

	//현재 날짜 가져오기 YYYYMMDDHHMMSS
	public DataBox selectYYYYMMDDHHMISS(RequestBox requestBox) throws Exception;
	
	//하루전 날짜 가져오기 YYYYMMDDHHMMSSMINUS
	public DataBox selectYYYYMMDDHHMISSMINUS(RequestBox requestBox) throws Exception;

	//개인화 콘텐츠 푸시 등록
	public DataBox insertLmsPushSendSubsribe(RequestBox requestBox) throws Exception;
	
}
