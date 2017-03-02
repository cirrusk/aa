package amway.com.academy.manager.reservation.scheduler.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ReservationSchedulerMapper {
	
	/**
	 * 실주문번호 없는 주문내역 목록 조회(현재시간 기준 10분 이내)
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectVirtualPurchaseNumber() throws Exception;
	
	/**
	 * 실주문번호 업데이트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void updateRegularPurchaseNumber(Map<String, Object> map) throws Exception;

	/** 
	 * 예약 대기자 삭제
	 * 
	 * @throws Exception
	 */
	void beforeWatingReservationDelete() throws Exception;

	/**
	 * 비회원 휴대폰 인증 정보 삭제
	 * 
	 * @throws Exception
	 */
	void nonMemberCertInfoDelete() throws Exception;
	
	/**
	 * 예약 알림 - 시설
	 * @throws Exception
	 */
	List<Map<String, String>> reservationRemindNotificationPushRoom() throws Exception;

	/**
	 * 예약 알림 - 체험
	 * @throws Exception
	 */
	List<Map<String, String>> reservationRemindNotificationPushExpr() throws Exception;

	/**
	 * 예약 알림 - 체성분 측정
	 * @throws Exception
	 */
	List<Map<String, String>> reservationRemindNotificationPushChck1() throws Exception;
	/**
	 * 예약 알림 - 피부 측정
	 * @throws Exception
	 */
	List<Map<String, String>> reservationRemindNotificationPushChck2() throws Exception;
	
}