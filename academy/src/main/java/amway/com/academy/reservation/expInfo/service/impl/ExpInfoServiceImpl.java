package amway.com.academy.reservation.expInfo.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.expBrand.service.impl.ExpBrandMapper;
import amway.com.academy.reservation.expInfo.service.ExpInfoService;
import framework.com.cmm.lib.RequestBox;

@Service
public class ExpInfoServiceImpl extends CommonReservationService implements ExpInfoService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpInfoServiceImpl.class);
	
	@Autowired
	private ExpInfoMapper expInfoDAO;
	
	@Autowired
	private ExpBrandMapper expBrandDAO;

	@Override
	public List<Map<String, String>> expInfoList(RequestBox requestBox) throws Exception {
		
		List<String> list = new ArrayList<String>(); //string array를 list담기
		
		/** 검색조건[체험 종류(브랜드체험, 문화체험 등) 다중 선택시  조건 가공 하여 list에 담는다] */
		if(requestBox.getVector("searchexpType").size() > 0){
			for(int i = 0; i < requestBox.getVector("searchexpType").size(); i++){
				list.add((String) requestBox.getVector("searchexpType").get(i));
			}
//			requestBox.remove("searchexpType");
			requestBox.put("searchexpTypeList", list);
			requestBox.put("searchexpType", list);
		}
		
		return expInfoDAO.expInfoList(requestBox);
	}
		
	@Override
	public int expInfoListCount(RequestBox requestBox) throws Exception {
		
		List<String> list = new ArrayList<String>(); //string array를 list담기
		
		/** 검색조건[체험 종류(브랜드체험, 문화체험 등) 다중 선택시  조건 가공 하여 list에 담는다] */
		if(requestBox.getVector("searchexpType").size() > 0){
			for(int i = 0; i < requestBox.getVector("searchexpType").size(); i++){
				list.add((String) requestBox.getVector("searchexpType").get(i));
			}
//			requestBox.remove("searchexpType");
			requestBox.put("searchexpTypeList", list);
		}
		
		return (int) expInfoDAO.expInfoListCount(requestBox);
	}

	@Override
	public List<Map<String, String>> expInfoDetailList(RequestBox requestBox) throws Exception {
		
		List<Map<String, String>> expInfoDetailList = new ArrayList<Map<String,String>>();
		
		
		List<Map<String, String>> tempExpInfoDetailList = expInfoDAO.expInfoDetailList(requestBox);
		
		for(int i = 0; i < tempExpInfoDetailList.size(); i++){
			
			requestBox.put("reservationdate", String.valueOf(tempExpInfoDetailList.get(i).get("formatreservationdate")));
			requestBox.put("tempreservationdate", String.valueOf(tempExpInfoDetailList.get(i).get("formatreservationdate")));
			requestBox.put("tempExpseq", String.valueOf(tempExpInfoDetailList.get(i).get("expseq")));
			
			// 패널티 정보 
			Map<String, String> tempTypeCode = expInfoDAO.searchExpPenaltyYn(requestBox);
			Map<String, String> map = new HashMap<String, String>();
			
			// 브랜드/프로그램 정보일 경우 동반인 체크 로직 적용
			if(tempTypeCode != null){
				map.put("typecode", tempTypeCode.get("typecode"));
			}else{
				map.put("typecode", "N");
			}
			
			map.put("gettoday",              tempExpInfoDetailList.get(i).get("gettoday")                              );
			map.put("rsvinfoflag",           tempExpInfoDetailList.get(i).get("rsvinfoflag")                           );
			map.put("cancelcode",            tempExpInfoDetailList.get(i).get("cancelcode")                            );
			map.put("expsessionseq",         String.valueOf(tempExpInfoDetailList.get(i).get("expsessionseq"))         );
			map.put("preparation",           String.valueOf(tempExpInfoDetailList.get(i).get("preparation"))           );
			map.put("partnertypename",       String.valueOf(tempExpInfoDetailList.get(i).get("partnertypename"))       );
			map.put("rsvweek",               tempExpInfoDetailList.get(i).get("rsvweek")                               );
			map.put("typeseq",               String.valueOf(tempExpInfoDetailList.get(i).get("typeseq"))               );
			map.put("visitnumber",           String.valueOf(tempExpInfoDetailList.get(i).get("visitnumber"))           );
			map.put("rsvseq",                String.valueOf(tempExpInfoDetailList.get(i).get("rsvseq"))                );
			map.put("reservationdate",       String.valueOf(tempExpInfoDetailList.get(i).get("reservationdate"))       );
			map.put("formatpurchasedate",    String.valueOf(tempExpInfoDetailList.get(i).get("formatpurchasedate"))    );
			map.put("session",               tempExpInfoDetailList.get(i).get("session")                               );
			map.put("name",                  tempExpInfoDetailList.get(i).get("name")                                  );
			map.put("expseq",                String.valueOf(tempExpInfoDetailList.get(i).get("expseq"))                );
			map.put("formatreservationdate", String.valueOf(tempExpInfoDetailList.get(i).get("formatreservationdate")) );
			map.put("ppseq",                 String.valueOf(tempExpInfoDetailList.get(i).get("ppseq"))                 );
			map.put("ppname",                tempExpInfoDetailList.get(i).get("ppname")                                );
			map.put("rsvcancel",             tempExpInfoDetailList.get(i).get("rsvcancel")                             );
			map.put("paymentstatusname",     tempExpInfoDetailList.get(i).get("paymentstatusname")                     );
			map.put("typename",              tempExpInfoDetailList.get(i).get("typename")                              );
			map.put("paymentstatuscode",     tempExpInfoDetailList.get(i).get("paymentstatuscode")                     );
			map.put("partnertypecode",       tempExpInfoDetailList.get(i).get("partnertypecode")                       );
			map.put("transactiontime",       tempExpInfoDetailList.get(i).get("transactiontime")                       );
			map.put("accounttype",           tempExpInfoDetailList.get(i).get("accounttype")                           );
			map.put("randsaveyn",            tempExpInfoDetailList.get(i).get("randsaveyn")                            );
			
			if(!("").equals(tempExpInfoDetailList.get(i).get("canceldatetime"))){
				map.put("canceldatetime", tempExpInfoDetailList.get(i).get("canceldatetime"));
			}
			
			expInfoDetailList.add(map);
		}
		
		return expInfoDetailList;
	}

	@Override
	public int changePartnertAjax(RequestBox requestBox) throws Exception {
		return expInfoDAO.changePartnertAjax(requestBox);
	}

	@Override
	public int updateCancelCodeAjax(RequestBox requestBox) throws Exception {
		
//		Map<String, String> maxStandByNum  = expInfoDAO.searchMaxStandByNumber(requestBox);
		Map<String, String> penaltyInfo;
		
//		if("1".equals(String.valueOf(maxStandByNum.get("standbynumber")))){
//			/**/
//			requestBox.put("standbyrsvseq", maxStandByNum.get("rsvseq"));
//			expInfoDAO.updateStandByNumber(requestBox);
//		}
		
		if(!("N").equals(requestBox.get("typecode"))){
			//패널티 부여
			List<Map<String, String>> searchPenaltyList = expInfoDAO.searchPenaltyList(requestBox);
			
			if(searchPenaltyList.size() != 0){
				if(!("N").equals(searchPenaltyList.get(0).get("penaltyyn"))){
					for(int i = 0; i < searchPenaltyList.size(); i++){
						penaltyInfo = new HashMap<String, String>();
						
						penaltyInfo.put("account", requestBox.get("account"));
						penaltyInfo.put("rsvseq", requestBox.get("rsvseq"));
						
						penaltyInfo.put("expseq", String.valueOf(searchPenaltyList.get(i).get("expseq")));
						penaltyInfo.put("penaltyseq", String.valueOf(searchPenaltyList.get(i).get("penaltyseq")));
//						penaltyInfo.put("reason", searchPenaltyList.get(i).get("typecode"));
						penaltyInfo.put("applytypecode", searchPenaltyList.get(i).get("applytypecode"));
						penaltyInfo.put("applytypevalue", searchPenaltyList.get(i).get("applytypevalue"));
						
						expInfoDAO.insertPenaltyHistory(penaltyInfo);	
						
					}
				}
			}
			
		}
		
		/* cancel code : B02 -> B01 */
		int updateResult = expInfoDAO.updateCancelCodeAjax(requestBox);
		
		/* send message for push & note */
		try {
			
			Map<String, String> messageMap; 
			
			messageMap = super.getSendMessageExpBySeq(requestBox);
			messageMap.put("account",     requestBox.get("account"));
			messageMap.put("standByNumber",     "0");
			
			/** send message - push (측정및 체험은 취소시 PUSH 없음) */
			//super.sendPushMessage(messageMap, "room", "cancel");
			
			/** send message - note */
			if ( -1 != messageMap.get("typeName").indexOf("체험")){
				super.sendNoteMessage(messageMap, "expr", "cancel");
			}
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
		}
		
		return updateResult;
	}

	@Override
	public void updateStandByNumber(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("ExpInfoServiceImpl.updateStandByNumber");
		LOGGER.debug("requestBox : {}", requestBox);

		/* 예약 대기가 있으면 rsvseq 획득 */
		Map<String, String> maxStandByNum = expInfoDAO.searchMaxStandByNumber(requestBox);
		LOGGER.debug("maxStandByNum : {}", maxStandByNum);
		
		/*if ( null != maxStandByNum 
				&& "true".equals(String.valueOf(maxStandByNum.get("rsvcheck"))) ) {
			requestBox.put("standbyrsvseq", maxStandByNum.get("rsvseq"));
			expInfoDAO.updateStandByNumber(requestBox);
		}*/

		if( null != maxStandByNum ){
			/* 대기 상태가 예약상태로 변경 */
			requestBox.put("standbyrsvseq", maxStandByNum.get("rsvseq"));
			expInfoDAO.updateStandByNumber(requestBox);
		}
	}

	@Override
	public Map<String, String> searchThreeMonthMobile(RequestBox requestBox) throws Exception {
		return expInfoDAO.searchThreeMonthMobile(requestBox);
	}

	@Override
	public String expInfoByRsvSeq(RequestBox requestBox) throws Exception {
		return expInfoDAO.expInfoByRsvSeq(requestBox);
	}
}
