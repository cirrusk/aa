package amway.com.academy.manager.lms.lmsStamp.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsStampService {

	public int selectLmsStampCount(RequestBox requestBox) throws Exception;
	
	public List<DataBox> selectLmsStampList(RequestBox requestBox) throws Exception;
	
	//스탬프 Excel  다운로드
	public List<Map<String, String>> selectLmsStampListExcelDown(RequestBox requestBox) throws Exception;

	public int deleteLmsStamp(RequestBox requestBox) throws Exception;
	
	public DataBox selectLmsStamp(RequestBox requestBox) throws Exception;
	
	public int insertLmsStamp(RequestBox requestBox) throws Exception;
	
	public int updateLmsStamp(RequestBox requestBox) throws Exception;
	
	//스탬프 종류 가져오기
	public List<DataBox> seletLmsStampList() throws Exception;
	
	//기본 회계기간 가져오기
	public Map<String, String> selectLmsStampDate() throws Exception;
	
	//스탬프 통계 정보 가져오기
	public DataBox selectLmsStampRankingInfo(RequestBox requestBox) throws Exception;
	//회원 목록
	public List<DataBox> lmsStampMemberListAjax(RequestBox requestBox) throws Exception;
	
	//회원 목록 카운트
	public int lmsStampMemberListCount(RequestBox requestBox) throws Exception;
	
	//스탬프 목록
	public List<DataBox> lmsStampKindListAjax(RequestBox requestBox) throws Exception;
	
	//스탬프 목록 카운트
	public int lmsStampKindListCount(RequestBox requestBox) throws Exception;
	
	//스탬프 통계 정보 가져오기(스탬프종류 탭)
	public DataBox selectLmsStampKindInfo(RequestBox requestBox) throws Exception;
	
	 //스탬프 획득자 목록
	public List<DataBox> lmsStampObtainMemberPopAjax(RequestBox requestBox) throws Exception;
	
	//스탬프 획득자 목록 카운트
	public int lmsStampObtainMemberPopAjaxCount(RequestBox requestBox) throws Exception;
	
	//StampKind Excel  다운로드
	public List<Map<String, String>> lmsStampKindListExcelDown(RequestBox requestBox) throws Exception;
	
	 //스탬프현황 목록
	public List<DataBox> lmsStampStatusListAjax(RequestBox requestBox) throws Exception;
	
	 //스탬프현황 목록 카운트
	public int lmsStampStatusListCount(RequestBox requestBox) throws Exception;
	
	//페널티관리 목록
	public List<DataBox> lmsPenaltyManageListAjax(RequestBox requestBox) throws Exception;
	
	//페널티관리 목록 카운트
	public int lmsPenaltyManageListCount(RequestBox requestBox) throws Exception;
	
	//페널티 해제
	public void lmsPenaltyClearAjax(RequestBox requestBox) throws Exception;
}



































