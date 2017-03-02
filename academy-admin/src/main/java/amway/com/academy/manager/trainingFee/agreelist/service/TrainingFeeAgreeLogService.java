package amway.com.academy.manager.trainingFee.agreelist.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeAgreeLogService {
	
	/**
	 * 교육비 서약서 동의 리스트 count
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int selectAgreeLogListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 서약서 동의 리스트 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectAgreeLogList(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 위임 동의 리스트 count
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int selectAgreeDelegLogListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 위임 동의 리스트 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectAgreeDelegLogList(RequestBox requestBox) throws Exception;

	/**
	 * 교육비 제3자동의 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectThirdpersonLogListCount(RequestBox requestBox);

	/**
	 * 교육비 제3자동의 리스트
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectThirdpersonLogList(RequestBox requestBox);

	/**
	 * 교육비 스페셜 위임 count
	 * @param requestBox
	 * @return
	 */
	public int selectSpecialLogListCount(RequestBox requestBox);

	/**
	 * 교육비 스페셜 위임
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectSpecialLogList(RequestBox requestBox);

	/**
	 * 교육비 스페셜 위임(파일업로드 저장)
	 * @param requestBox
	 * @return
	 */
	public int saveSpecialLog(RequestBox requestBox);

	/**
	 * 교육비 약관 출력
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectAgreePrint(RequestBox requestBox);

	/**
	 * Special위임내역 삭제
	 * @param requestBox
	 * @return
	 */
	public int deleteSpecialLog(RequestBox requestBox) throws SQLException;
	
	
	
}
