package amway.com.academy.manager.common.excel.service;

import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface ManageExcelService {
	
	/**
	 * 지급대상자 업로드 - 1.일정관리 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectScheduleExcelData(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 지급대상자 업로드 - 2.교육비 대상자 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectTargetExcelData(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 지급대상자 업로드 - 3.교육비 지급대상자 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectGiveTargetExcelData(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 지급대상자 업로드 - 4.그룹코드 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectGroupCodeExcelData(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 교육비 지급대상자 엑셀 업로드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	int insertExcelData(Map<String, Object> params) throws Exception;

	int insertAgreeExcelData(Map<String, Object> params) throws Exception;

	String[][] validExcelData(String[][] importData, RequestBox requestBox);
	
	
	
}
