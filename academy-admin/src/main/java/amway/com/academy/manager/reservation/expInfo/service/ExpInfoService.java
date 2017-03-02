package amway.com.academy.manager.reservation.expInfo.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface ExpInfoService {
	
	/**
	 * pp별 예약 측정/체험 프로그램 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expProgramListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 해당 pp 해당 측정/체험타입 년 월 조회
	 * 
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> expInfoCalendarAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp 해당 측정/체험타입 년 월 별 예약 현황 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expInfoListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 예약현황 운영자 예약 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험 예약현황 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expInfoAdminReservationListInsertAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정/체험 예약현황 운영자 예약 취소 화면
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception;

	/**
	 * 측정/체험 예약현황 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expInfoAdminReservationListCancelUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp, 측정/체험, 년, 월, 일 세션 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox expInfoSessionSelectAjax(RequestBox requestBox) throws Exception;

	/**
	 * pp, 측정/체험, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> expInfoSessionListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception;

	/**
	 * 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int expInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception;
	
}
