package amway.com.academy.manager.lms.regular.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsRegularMapper {

	/**
	 * 정규과정 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsRegularCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularList(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsRegularListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 개별정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsRegular(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsRegular(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 개별 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsRegular(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 개별 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsRegular(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스탬프 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularStampList(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 과정 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsRegularCourseCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 과정 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 과정 테마 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsRegularCourseThemeCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 과정 테마 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularCourseThemeList(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 오프라인과정 테마번호로 검색한 목록
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularOffCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 수강생 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsStudent(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝종료 정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsStepFinish(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝 유닛 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsStepUnit(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 스텝 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsStep(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 스텝 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsStep(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 스텝 유닛 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsStepUnit(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 교육시작일/종료일 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsCourseEduDate(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝 목록
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularStepList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛 목록
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularStepUnitList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛별 수정용 상세
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsRegularStepUnitEditDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 교육시작일/종료일 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsRegularStepUnitEdit(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛별 수정용 상세 시험
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsRegularStepUnitEditTestDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛별 시험 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsRegularStepUnitEditTest(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛별 수정용 상세 오프라인
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsRegularStepUnitEditOffDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛별 오프라인 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsRegularStepUnitEditOff(RequestBox requestBox) throws Exception;
	
}