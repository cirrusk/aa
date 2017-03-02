package amway.com.academy.lms.main.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMainService {
	

	/**
	 * 과정조회조건 count
	 * @param requestBox
	 * @return
	 */
	public int selectCourseListCount(RequestBox requestBox);
	
	/**
	 *  과정조회조건
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCourseList(RequestBox requestBox) throws Exception;

	/**
	 * 회원 쪽지 count
	 * @param requestBox
	 * @return
	 */
	public int selectMemberMessageCount(RequestBox requestBox);

	/**
	 * 회원 쪽지 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectMemberMessageList(RequestBox requestBox) throws Exception;
	
	/**
	 *  과정 기본정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCourseDetail(RequestBox requestBox) throws Exception;

	/**
	 * 수강신청정보 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCourseStudentView(RequestBox requestBox) throws Exception;

	/**
	 * 교육수강생 - 수강신청 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsCourseStudentRequest(RequestBox requestBox) throws Exception;

	/**
	 * 교육수강생 - 수강신청 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsCourseStudentRequest(RequestBox requestBox) throws Exception;

	/**
	 * 교육수강생 - 수강신청 등록,수정
	 * @param Map
	 * @return
	 */
	public int mergeLmsCourseStudentRequest(RequestBox requestBox) throws Exception;
	
	/**
	 * 카테고리 분류 1,2,3 단계를 1단계 CATEGORYID 값을 가져온다
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCategoryLevelONE(RequestBox requestBox) throws Exception;

	/**
	 * 강의자료 보기전 허용여부 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCourseViewAcces(RequestBox requestBox) throws Exception;

	/**
	 * 교육수강생 - 수료처리 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsStudentFinish(RequestBox requestBox) throws Exception;

	/**
	 * COMPLIANCEFLAG 조회 count 
	 * @param Map
	 * @return
	 */
	public int selectComplianceCount(RequestBox requestBox);

	/**
	 * 조회로그 count
	 * @param Map
	 * @return
	 */
	public int selectViewLogCount(RequestBox requestBox);
	
	/**
	 * 조회로그 count - 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsViewLogCnt(RequestBox requestBox) throws Exception;
	
	/**
	 * 조회로그 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsViewLogCnt(RequestBox requestBox) throws Exception;

	/**
	 * 조회로그 count 1증가 - 등록,수정
	 * @param Map
	 * @return
	 */
	public int mergeViewLogCount(RequestBox requestBox) throws Exception;

	/**
	 * 교육과정 좋아요 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsCourseLikeCnt(RequestBox requestBox) throws Exception;

	/**
	 * 교육과정 조회수 1증가 - 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsCourseViewCnt(RequestBox requestBox) throws Exception;

	/**
	 * 교육과정 좋아요 count
	 * @param Map
	 * @return
	 */
	public List<Map<String, Object>> selectCourseLikeCount(RequestBox requestBox);
	
	/**
	 * 교육과정 조회수
	 * @param Map
	 * @return
	 */
	public List<Map<String, Object>> selectCourseViewCount(RequestBox requestBox);
	

	/**
	 * 저장로그 count
	 * @param Map
	 * @return
	 */
	public int selectSaveLogCount(RequestBox requestBox);

	/**
	 * 저장로그 - 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsSaveLog(RequestBox requestBox) throws Exception;

	/**
	 * 저장로그 - 수정
	 * @param Map
	 * @return
	 */
	public int updateLmsSaveLog(RequestBox requestBox) throws Exception;

	/**
	 * 저장로그 - 등록,수정
	 * @param Map
	 * @return
	 */
	public int mergeSaveLog(RequestBox requestBox) throws Exception;

	/**
	 * 저장로그 - 삭제
	 * @param Map
	 * @return
	 */
	public int deleteLmsSaveLog(RequestBox requestBox) throws Exception;
	

	/**
	 * 저작권 동의 count - 온라인강의.
	 * @param RequestBox
	 * @return
	 */
	public int selectCategoryAgree(RequestBox requestBox);

	/**
	 * 저작권 동의 count
	 * @param Map
	 * @return
	 */
	public int selectAgreeCount(RequestBox requestBox);

	/**
	 * 저작권동의 - 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsCategoryAgree(RequestBox requestBox) throws Exception;

	/**
	 * 개인정보활용동의 count
	 * @param RequestBox
	 * @return
	 */
	public int selectOnlinePersonInfoAgreeCnt(RequestBox requestBox);

	/**
	 * 개인정보활용동의 - 등록
	 * @param RequestBox
	 * @return
	 */
	public int insertLmsOnlinePersonInfoAgree(RequestBox requestBox) throws Exception;

	/**
	 * LMSSTEPUNIT - 조회.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectStepunitList(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 수료처리.
	 * @param void
	 * @return
	 */
	public void updateFinishProcess2(RequestBox requestBox) throws Exception;
	
	/**
	 *  배너 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectLmsBannerList(RequestBox requestBox) throws Exception;
	
}
