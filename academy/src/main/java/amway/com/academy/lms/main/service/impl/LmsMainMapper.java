package amway.com.academy.lms.main.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMainMapper {

	/**
	 * 과정조회조건 count
	 * @param requestBox
	 * @return
	 */
	int selectCourseListCount(RequestBox requestBox);
	
	/**
	 * 과정조회조건
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCourseList(RequestBox requestBox) throws Exception;

	/**
	 * 회원 쪽지 count
	 * @param requestBox
	 * @return
	 */
	int selectMemberMessageCount(RequestBox requestBox);
	
	/**
	 * 회원 쪽지 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectMemberMessageList(RequestBox requestBox) throws Exception;
	

	/**
	 * 과정 기본정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCourseDetail(RequestBox requestBox) throws Exception;

	/**
	 * 수강신청정보 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCourseStudentView(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육수강생 - 수강신청 등록
	 * @param Map
	 * @return
	 */
	int insertLmsCourseStudentRequest(RequestBox requestBox);

	/**
	 * 교육수강생 - 수강신청 수정
	 * @param Map
	 * @return
	 */
	int updateLmsCourseStudentRequest(RequestBox requestBox);

	/**
	 * 교육수강생 - 수강신청 등록,수정
	 * @param Map
	 * @return
	 */
	int mergeLmsCourseStudentRequest(RequestBox requestBox);
	
	/**
	 * 카테고리 분류 1,2,3 단계를 1단계 CATEGORYID 값을 가져온다
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCategoryLevelONE(RequestBox requestBox) throws Exception;
	
	/**
	 * 강의자료 보기전 허용여부 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCourseViewAcces(RequestBox requestBox) throws Exception;

	/**
	 * 교육수강생 - 수료처리 수정
	 * @param Map
	 * @return
	 */
	int updateLmsStudentFinish(Map<String, Object> sMap);
		

	/**
	 * COMPLIANCEFLAG 조회 count 
	 * @param Map
	 * @return
	 */
	int selectComplianceCount(RequestBox requestBox);
	
	/**
	 * 조회 로그 count
	 * @param Map
	 * @return
	 */
	int selectViewLogCount(RequestBox requestBox);
	
	/**
	 * 로그 count - 등록
	 * @param Map
	 * @return
	 */
	int insertLmsViewLogCnt(RequestBox requestBox);
	
	/**
	 * 로그 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	int updateLmsViewLogCnt(RequestBox requestBox);

	/**
	 * 로그 count 1증가 - 등록,수정
	 * @param Map
	 * @return
	 */
	int mergeViewLogCount(RequestBox requestBox);
	

	/**
	 * 교육과정 좋아요 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	int updateLmsCourseLikeCnt(RequestBox requestBox);
	

	/**
	 * 교육과정 조회수 1증가 - 수정
	 * @param Map
	 * @return
	 */
	int updateLmsCourseViewCnt(RequestBox requestBox);
	

	/**
	 * 교육과정 좋아요 count
	 * @param Map
	 * @return
	 */
	List<Map<String, Object>> selectCourseLikeCount(RequestBox requestBox);
	

	/**
	 * 교육과정 조회수
	 * @param Map
	 * @return
	 */
	List<Map<String, Object>> selectCourseViewCount(RequestBox requestBox);

	/**
	 * 저장로그 count
	 * @param Map
	 * @return
	 */
	int selectSaveLogCount(RequestBox requestBox);

	/**
	 * 저장로그 - 등록,수정
	 * @param Map
	 * @return
	 */
	int mergeSaveLog(RequestBox requestBox);

	/**
	 * 저장로그 - 등록
	 * @param Map
	 * @return
	 */
	int insertLmsSaveLog(RequestBox requestBox);

	/**
	 * 저장로그 - 수정
	 * @param Map
	 * @return
	 */
	int updateLmsSaveLog(RequestBox requestBox);

	/**
	 * 저장로그 - 삭제
	 * @param Map
	 * @return
	 */
	int deleteLmsSaveLog(RequestBox requestBox);
	

	/**
	 * 저작권 동의 count - 온라인강의.
	 * @param Map
	 * @return
	 */
	int selectCategoryAgree(RequestBox requestBox);

	/**
	 * 저작권 동의 count
	 * @param Map
	 * @return
	 */
	int selectAgreeCount(RequestBox requestBox);
	
	/**
	 * 저작권동의 - 등록
	 * @param Map
	 * @return
	 */
	int insertLmsCategoryAgree(RequestBox requestBox);

	/**
	 * 개인정보활용동의 count
	 * @param Map
	 * @return
	 */
	int selectOnlinePersonInfoAgreeCnt(RequestBox requestBox);
	
	/**
	 * 개인정보활용동의 - 등록
	 * @param Map
	 * @return
	 */
	int insertLmsOnlinePersonInfoAgree(RequestBox requestBox);

	/**
	 * LMSSTEPUNIT - 조회.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectStepunitList(RequestBox requestBox) throws Exception;

	/**
	 * 배너 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsBannerList(RequestBox requestBox) throws Exception;
	
}
