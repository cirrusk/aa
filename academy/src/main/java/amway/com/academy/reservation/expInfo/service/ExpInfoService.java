package amway.com.academy.reservation.expInfo.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 체험_체험 예약 현황
 * @author KR620225
 *
 */
public interface ExpInfoService {

	public List<Map<String, String>> expInfoList(RequestBox requestBox) throws Exception;
	
	public int expInfoListCount(RequestBox requestBox) throws Exception;
	
	public List<Map<String, String>> expInfoDetailList(RequestBox requestBox) throws Exception;
	
	public int changePartnertAjax(RequestBox requestBox) throws Exception;
	
	public int updateCancelCodeAjax(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchThreeMonthMobile(RequestBox requestBox) throws Exception;
	
	public String expInfoByRsvSeq(RequestBox requestBox) throws Exception;

	public void updateStandByNumber(RequestBox requestBox) throws Exception;
	
}
