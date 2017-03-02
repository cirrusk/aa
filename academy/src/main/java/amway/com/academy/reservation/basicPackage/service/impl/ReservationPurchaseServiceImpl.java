package amway.com.academy.reservation.basicPackage.service.impl;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * </pre>
 * Program Name  : ReservationPurchaseServiceImpl.java
 * Author : KR620207
 * Creation Date : 2016. 10. 6.
 */
@Service
public class ReservationPurchaseServiceImpl implements ReservationPurchaseService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationPurchaseServiceImpl.class);

	@Autowired
	private ReservationPurchaseMapper reservationPurchaseMapper;
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#roomPayMentInsert(java.util.HashMap)
	 */
	@Override
	public void roomPaymentInsert(HashMap<String, String> map) throws Exception {
		reservationPurchaseMapper.roomPaymentInsert(map);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#selectRoomPurchase(java.util.HashMap)
	 */
	@Override
	public int selectRoomPurchase(HashMap<String, String> map) throws Exception {
		return reservationPurchaseMapper.selectRoomPurchase(map);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#roomPurchaseInsert(java.util.HashMap)
	 */
	@Override
	public void roomPurchaseInsert(HashMap<String, String> map) throws Exception {
		reservationPurchaseMapper.roomPurchaseInsert(map);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#roomReservationInsert(java.util.HashMap)
	 */
	@Override
	public void roomReservationInsert(HashMap<String, String> map) throws Exception {
		reservationPurchaseMapper.roomReservationInsert(map);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#updateCurrentCardTraceNumber()
	 */
	@Override
	public void increaseCardTraceNumber() throws Exception {
		reservationPurchaseMapper.increaseCardTraceNumber();
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#getCurrentCardTraceNumber()
	 */
	@Override
	public int getCurrentCardTraceNumber() throws Exception {
		return reservationPurchaseMapper.getCurrentCardTraceNumber();
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#selectKiccCompleteStep1(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public EgovMap selectKiccCompleteStep1(RequestBox requestBox) throws Exception {
		return reservationPurchaseMapper.selectKiccCompleteStep1(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#selectKiccCompleteStep2(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public List<EgovMap> selectKiccCompleteStep2(RequestBox requestBox) throws Exception {
		return reservationPurchaseMapper.selectKiccCompleteStep2(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.ReservationPurchaseService#selectKiccCompleteStep3(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public EgovMap selectKiccCompleteStep3(RequestBox requestBox) throws Exception {
		return reservationPurchaseMapper.selectKiccCompleteStep3(requestBox);
	}
}
