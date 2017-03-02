package amway.com.academy.trainingFee.trainingFeeMain.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeMainService {
	
	/**
	 * 교육비 일정관리 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectSchedule(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 대상자 인지 확인 한다.
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectTargetInformation(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 메인 월별 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectMainList(RequestBox requestBox) throws Exception;

	/**
	 * 교육비 약관 동의서
	 * @param requestBox
	 * @return
	 */
	public Map<String, String> selectTrFeeAgreeText(RequestBox requestBox);

	/**
	 * 교육비 서약서 동의 약관
	 * @param requestBox
	 * @return
	 * @throws SQLException 
	 */
	public int inserTrfeeAgreePledge(RequestBox requestBox) throws SQLException;

	/**
	 * 제3자 동의 대상자가 존재 하는지 체크 한다.
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrfeeAgreeThirdperson(RequestBox requestBox);

	/**
	 * 다이아 위임자 인지 확인 한다.
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrfeeAgreeDeleg(RequestBox requestBox);

	/**
	 * 위임동의 저장
	 * @param requestBox
	 * @return
	 * @throws SQLException 
	 */
	public int inserTrfeeAgreeDeleg(RequestBox requestBox) throws SQLException;

	/**
	 * 에메랄드 위임자
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrfeeAgreeDelegEm(RequestBox requestBox);

	/**
	 * 제3자 동의서
	 * @param requestBox 
	 * @param multiRequest
	 * @return
	 * @throws SQLException 
	 */
	public int inserTrfeeThirdperson(RequestBox requestBox) throws SQLException;

	/**
	 * 교육비 그룹 리스트 상세
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectGroupTargetList(RequestBox requestBox);

	/**
	 * 교육비 서약서 동의현황
	 * @param requestBox
	 * @return
	 */
	public Map<String, String> selectTrFeeAgreePledge(RequestBox requestBox);

	/**
	 * 교육비 제3자 동의서
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectTrFeeThirdPerson(RequestBox requestBox);

	/**
	 * 교육비 위임 동의서
	 * @param requestBox
	 * @return
	 */
	public Map<String, String> selectTrFeeAgreeDeleg(RequestBox requestBox);

	/**
	 * 메인 등록 가능기간
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectPF(RequestBox requestBox);

	/**
	 * 약관 전체보기 상세
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrFeeAgreeTextPop(RequestBox requestBox);

	/**
	 * 약관 위임 동의 전체 현황
	 * @param requestBox
	 * @return
	 */
	public Map<String, String> selectTrFeeAgreeDelegFull(RequestBox requestBox);

	/**
	 * 제3자 동의 리스트
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrFeeThirdPersonList(RequestBox requestBox);

	/**
	 * 동의현황 리스트
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectTrFeeAgreeDelegFullList(RequestBox requestBox);

	public List<Map<String, Object>> selectPtList(RequestBox requestBox);

	public int updateThirdpersonAgree(RequestBox requestBox);	
	
}
