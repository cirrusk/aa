package amway.com.academy.manager.reservation.baseRule.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 누적 예약 가능 횟수
 * @author KR620225
 *
 */
public interface BaseRuleService {
	
	/**
	 * 누적 예약 타입 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> baseRuleListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 누적 예약 타입 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseRuleListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 누적 예약타입 등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseRuleInsertAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 누적 예약 타입 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox baseRuleDetailAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 누적 얘약 타입 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseRuleUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 룸타입 조회(셀렉트 박스에서 사용
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchPpToRoomTypeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 제한 기준 타입 코드가 C03일경우 
	 * 	누적 예약 횟수 제한설정 테이블 등록, 특정 교육장 맵핑 테이블등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int ppToRoomTypeInsertAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 제한 기준 타입 코드가 C03에서 C01 or C02로 변경시
	 * 	누적예약 횟수 제한 설정 테이블 수정, 특정 교육장 맵핑 테이블 삭제
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int ppToRoomTypeUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 제한 기준 타입 코드가 C03으로 변경시
	 * 	누적 예약 횟수 제한 설정 테이블 수정, 특정 교육장 맵핑 테이블 등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int baseRuleUpdateAndInsertAjax(RequestBox requestBox) throws Exception;
}
