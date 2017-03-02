package amway.com.academy.manager.lms.lmsStamp.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsStampMapper {

	/**
	 * 스탬프 관리 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsStampCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프 관리 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsStampList(RequestBox requestBox) throws Exception;

	/**
	 * 스탬프 관리 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsStampListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsStamp(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsStamp(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsStamp(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsStamp(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 종류 가져오기
	 * @return List
	 */
	List<DataBox> seletLmsStampList() throws Exception;
	
	/**
	 * //기본 회계기간 가져오기
	 * @return Map
	 */
	int selectLmsStampDate() throws Exception;
	
	/**
	 * //스탬프 통계 정보 가져오기
	 * @param requestBox
	 * @return
	 */
	DataBox selectLmsStampRankingInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //회원 목록
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsStampMemberListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //회원 목록 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsStampMemberListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 목록 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsStampKindListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 목록
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsStampKindListAjax(RequestBox requestBox) throws Exception;
	/**
	 * //스탬프 통계 정보 가져오기(스탬프종류 탭)
	 * @param requestBox
	 * @return Map
	 */
	DataBox selectLmsStampKindInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 획득자 목록 카운트
	 * @param requestBox
	 * @return int
	 */ 
	int lmsStampObtainMemberPopAjaxCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 획득자 목록
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsStampObtainMemberPopAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * StampKind Excel  다운로드
	 * @param requestBox
	 * @return List
	 */
	List<Map<String, String>> lmsStampKindListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프현황 목록 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsStampStatusListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 스탬프현황 목록
	 * @param requestBox
	 * @return
	 */
	List<DataBox> lmsStampStatusListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 페널티관리 목록 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsPenaltyManageListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 페널티관리 목록
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsPenaltyManageListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 페널티 해제
	 * @param requestBox
	 */
	void lmsPenaltyClearAjax(RequestBox requestBox) throws Exception;
}