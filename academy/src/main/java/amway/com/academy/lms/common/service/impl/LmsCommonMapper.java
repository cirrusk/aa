package amway.com.academy.lms.common.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsCommonMapper {
	
	/**
	 * 공통코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsCommonCodeList(RequestBox requestBox) throws Exception;


	/**
	 * 교육분류 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsCategoryCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 교육분류 3단 가져오기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsCategoryCode3Depth(RequestBox requestBox) throws Exception;

	/**
	 * 교육장소 코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsApCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 교육장소강의실 코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRoomCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 로그인 테스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsLogin(RequestBox requestBox) throws Exception;
	
	/**
	 * DW 데이터 읽기 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsDW(RequestBox requestBox) throws Exception;
	
	/**
	 * 단계별 수료 처리하기
	 * 단계의 필수 과목 전부 수료할 것, 전체 수료 갯수가 단계의 과정수 보다 같거나 클 것
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int updatetLmsStepFinish(RequestBox requestBox) throws Exception;
	
	/**
	 * 전체 수료 처리하기
	 * 각 단게를 모두 수료함
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int updatetLmsTotalFinish(RequestBox requestBox) throws Exception;
	
	
	/**
	 * SNS 카운트 증가하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int mergeSnsShareCount(RequestBox requestBox) throws Exception;

	/**
	 * 코스 뷰 카운트 증가
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int mergeViewCourseCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 과정수 뷰 증가하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int updateCourseViewCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 로그인 증가 및 스탬프 획득 처리
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int insertLmsconnectStamp(RequestBox requestBox) throws Exception;

	/**
	 * 오프라인, 교육자료, sns 공유, 스템프 등록 호출
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int insertLmsStamp(RequestBox requestBox) throws Exception;

	/**
	 * sns 증가 및 스탬프 발행
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int insertLmsStampSns(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 스템프 등록 호출
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int insertLmsRegularStamp(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 쪽지 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsNoteSend(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 현재 날짜 가져오기 2016년 9월 25일(일) 10:00:00
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectNowDate(RequestBox requestBox) throws Exception;
	
	/**
	 *  회원정보 잃기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsMemberInfo(RequestBox requestBox) throws Exception;
	
	/**
	 *  교육자료 첨부파일 잃기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsCourseDataFileInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * AmwayGo 그룹방 동기화 procedure 
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void lmsAmwayGoDataSynch(RequestBox requestBox) throws Exception;
}