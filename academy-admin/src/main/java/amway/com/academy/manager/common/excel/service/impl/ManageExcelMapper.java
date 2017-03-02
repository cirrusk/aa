package amway.com.academy.manager.common.excel.service.impl;
import java.util.Map;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public class ManageExcelMapper extends EgovAbstractMapper{

	/**
	 * 일정관리 존재여부 체크
	 * @param params
	 * @return
	 */
	public int selectScheduleExcelData(Map<String, Object> params) {
		return selectOne("ManageExcelMapper.selectScheduleExcelData", params);	
	}
	
	/**
	 * 일정관리 insert
	 * @param params
	 * @return
	 */
	public int insertScheduleExcelData(Map<String, Object> params) {
		return insert("ManageExcelMapper.insertScheduleExcelData", params);		
	}
	
	/**
	 * 일정관리 update
	 * @param params
	 * @return
	 */
	public int updateScheduleExcelData(Map<String, Object> params) {
		return update("ManageExcelMapper.updateScheduleExcelData", params);
	}
	
	/**
	 * 누적대상자 존재 여부
	 * @param params
	 * @return
	 */
	public int selectTargetExcelData(Map<String, Object> params) {
		return selectOne("ManageExcelMapper.selectTargetExcelData", params);	
	}
	
	/**
	 * 누적대상자 insert
	 * @param params
	 * @return
	 */
	public int insertTargetExcelData(Map<String, Object> params) {
		return insert("ManageExcelMapper.insertTargetExcelData", params);		
	}
	
	/**
	 * 누적대상자 update
	 * @param params
	 * @return
	 */
	public int updateTargetExcelData(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return update("ManageExcelMapper.updateTargetExcelData", params);
	}
	
	/**
	 * 월별대상자 존재여부
	 * @param params
	 * @return
	 */
	public int selectGiveTargetExcelData(Map<String, Object> params) {
		return selectOne("ManageExcelMapper.selectGiveTargetExcelData", params);	
	}
	
	/**
	 * 월별대상자 insert
	 * @param params
	 * @return
	 */
	public int insertGiveTargetExcelData(Map<String, Object> params) {
		return insert("ManageExcelMapper.insertGiveTargetExcelData", params);		
	}
	
	/**
	 * 월별대상자 update
	 * @param params
	 * @return
	 */
	public int updateGiveTargetExcelData(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return update("ManageExcelMapper.updateGiveTargetExcelData", params);
	}
	
	/**
	 * 운영그룹 존재 여부 체크
	 * @param params
	 * @return
	 */
	public int selectGroupCodeExcelData(Map<String, Object> params) {
		return selectOne("ManageExcelMapper.selectGroupCodeExcelData", params);	
	}
	
	/**
	 * 운영그룹 코드 insert
	 * @param params
	 * @return
	 */
	public int insertGroupCodeExcelData(Map<String, Object> params) {
		return insert("ManageExcelMapper.insertGroupCodeExcelData", params);
	}

	public int selectValidAgree(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return selectOne("ManageExcelMapper.selectValidAgree", paramMap);
	}

	public int insertAgreeExcelData(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return insert("ManageExcelMapper.insertAgreeExcelData", params);
	}

	public int selectAgreeExcelData(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return selectOne("ManageExcelMapper.selectAgreeExcelData", params);
	}

	public int insertAgreeExcelData1(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return insert("ManageExcelMapper.insertAgreeExcelData1", params);
	}

	public int selectAgreeExcelData1(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return selectOne("ManageExcelMapper.selectAgreeExcelData1", params);
	}
	
	
	

	
	
	
}
