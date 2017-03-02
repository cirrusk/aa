package amway.com.academy.manager.lms.regular.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsRegularService {

	// 정규과정 목록 카운트
	public int selectLmsRegularCount(RequestBox requestBox) throws Exception;
	
	// 정규과정 목록
	public List<DataBox> selectLmsRegularList(RequestBox requestBox) throws Exception;
	
	// 정규과정 Excel  다운로드
	public List<Map<String, String>> selectLmsRegularListExcelDown(RequestBox requestBox) throws Exception;

	// 정규과정 삭제
	public int deleteLmsRegular(RequestBox requestBox) throws Exception;
		
	// 정규과정 상세
	public DataBox selectLmsRegular(RequestBox requestBox) throws Exception;
		
	// 정규과정 등록
	public int insertLmsRegular(RequestBox requestBox) throws Exception;
		
	// 정규과정 수정
	public int updateLmsRegular(RequestBox requestBox) throws Exception;
	
	// 정규과정 스탬프 목록
	public List<DataBox> selectLmsRegularStampList(RequestBox requestBox) throws Exception;
	
	// 정규과정 과정 목록 카운트
	public int selectLmsRegularCourseCount(RequestBox requestBox) throws Exception;
	
	// 정규과정 과정 목록
	public List<DataBox> selectLmsRegularCourseList(RequestBox requestBox) throws Exception;
	
	// 정규과정 과정 테마 목록 카운트
	public int selectLmsRegularCourseThemeCount(RequestBox requestBox) throws Exception;
	
	// 정규과정 과정 테마 목록
	public List<DataBox> selectLmsRegularCourseThemeList(RequestBox requestBox) throws Exception;	
	
	// 정규과정 오프라인과정 테마번호로 검색한 목록
	public List<DataBox> selectLmsRegularOffCourseList(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝/유닛 삭제 및 등록
	public int deleteInsertLmsStepUnit(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝 유닛 합친 목록
	public List<DataBox> selectLmsRegularStepUnitSumList(RequestBox requestBox) throws Exception;

	// 정규과정 스텝유닛별 수정용 상세
	public DataBox selectLmsRegularStepUnitEditDetail(RequestBox requestBox) throws Exception;

	// 정규과정 스텝유닛별 수정
	public int updateLmsRegularStepUnitEdit(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝유닛별 수정용 상세 시험
	public DataBox selectLmsRegularStepUnitEditTestDetail(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝유닛별 시험 수정
	public int updateLmsRegularStepUnitEditTest(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝유닛별 수정용 상세 오프라인
	public DataBox selectLmsRegularStepUnitEditOffDetail(RequestBox requestBox) throws Exception;
	
	// 정규과정 스텝유닛별 오프라인 수정
	public int updateLmsRegularStepUnitEditOff(RequestBox requestBox) throws Exception;
	
}