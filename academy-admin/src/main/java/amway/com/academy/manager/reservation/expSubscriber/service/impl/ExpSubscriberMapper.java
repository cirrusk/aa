package amway.com.academy.manager.reservation.expSubscriber.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpSubscriberMapper {

	/**
	 * 측정/체험_예약자 관리  리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expSubscriberListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험_예약자 관리  리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expSubscriberListCount (RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험_예약자 관리  관리자 우선예약 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int adminExpCancelAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험_예약자 관리  노쇼 지정/해지
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expNoShowConfirmChkeck(RequestBox requestBox) throws Exception;
	
	/**
	 * 체험 노쇼 이력 정보 입력
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noShowExpPenaltyInsert(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험_예약자 관리 해당 pp에 따라 프로그램 타입 리스트 호출(셀렉트 박스)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
//	public List<DataBox> searchProgramTypeAjax(RequestBox requestBox) throws Exception;
	
	public int beforSearchExpPaymentStatuscodeUpdate() throws Exception;
	
	public List<DataBox> searchExpTypeCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 엑셀다운로드
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expSubscriberExcelDownload(RequestBox requestBox) throws Exception;
}
