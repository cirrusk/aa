package amway.com.academy.reservation.basicPackage.service.impl;

import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;
import freemarker.template.Configuration;
import freemarker.template.Template;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.reservation.expInfo.service.impl.ExpInfoMapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service
public class BasicReservationServiceImpl extends CommonReservationService implements BasicReservationService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicReservationServiceImpl.class);

	@Autowired
	private BasicReservationMapper basicReservationMapper;
	
	@Autowired
	private ExpInfoMapper expInfoDAO;

	@Override
	public List<Map<String, String>> roomReservationInsert(RequestBox requestBox) throws Exception {
		return super.roomReservationInsert(requestBox);
	}
	
	public String getCommonCodeName(CommonCodeVO codeVO) throws Exception {
		return basicReservationMapper.getCommonCodeName(codeVO);
	}
	
	@Override
	public List<CommonCodeVO> commonCodeList(CommonCodeVO codeVO) throws Exception {
		return basicReservationMapper.commonCodeList(codeVO);
	}

	@Override
	public List<CommonCodeVO> ppCodeList() throws Exception {
		return basicReservationMapper.ppCodeList();
	}

	@Override
	public List<CommonCodeVO> rervationProgramTypeCodeList() throws Exception {
		return basicReservationMapper.rervationProgramTypeCodeList();
	}

	@Override
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception {
		return basicReservationMapper.rervationProgramCodeList();
	}

	@Override
	public List<CommonCodeVO> regionCodeList() throws Exception {
		return basicReservationMapper.regionCodeList();
	}
	
	@Override
	public List<CommonCodeVO> cityCodeListByRegionCode(String regionCode) throws Exception {
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCode(regionCode);
		return basicReservationMapper.cityCodeListByRegionCode(codeVO);
	}

	@Override
	public List<CommonCodeVO> expRsvTypeInfoCodeList() throws Exception {
		return basicReservationMapper.expRsvTypeInfoCodeList();
	}
	
	@Override
	public List<CommonCodeVO> roomRsvTypeInfoCodeList() throws Exception {
		return basicReservationMapper.roomRsvTypeInfoCodeList();
	}

	@Override
	public List<Map<String, String>> getCalendarList(RequestBox requestBox) throws Exception {
		return basicReservationMapper.getCalendarList(requestBox);
	}

	@Override
	public List<Map<String, String>> nextYearMonth(RequestBox requestBox) throws Exception {
		return basicReservationMapper.nextYearMonth(requestBox);
	}
	
	@Override
	public List<Map<String, String>> expReservationInfoDetailList(RequestBox requestBox) throws Exception {
		
		List<Map<String, String>> expReservationInfoDetailList =  new ArrayList<Map<String,String>>();
		
		List<Map<String, String>> tempExpReservationList = basicReservationMapper.expReservationInfoDetailList(requestBox);
		
		for(int i = 0; i < tempExpReservationList.size(); i++){
			
			requestBox.put("reservationdate", tempExpReservationList.get(i).get("reservationdate"));
			requestBox.put("tempreservationdate", tempExpReservationList.get(i).get("reservationdate"));
			requestBox.put("tempExpseq", tempExpReservationList.get(i).get("expseq"));
			
			Map<String, String> tempTypeCode = expInfoDAO.searchExpPenaltyYn(requestBox);
			Map<String, String> map = new HashMap<String, String>();
			
			if(tempTypeCode != null){
				map.put("typecode", tempTypeCode.get("typecode"));
			}else{
				map.put("typecode", "N");
			}
			
			
			map.put("gettoday", String.valueOf(tempExpReservationList.get(i).get("gettoday")));
			map.put("reservationday", String.valueOf(tempExpReservationList.get(i).get("reservationday")));
			map.put("rsvdate", String.valueOf(tempExpReservationList.get(i).get("rsvdate")));
			map.put("typeseq", String.valueOf(tempExpReservationList.get(i).get("typeseq")));
			map.put("rsvseq", String.valueOf(tempExpReservationList.get(i).get("rsvseq")));
			map.put("expseq", String.valueOf(tempExpReservationList.get(i).get("expseq")));
			map.put("week", tempExpReservationList.get(i).get("week"));
			map.put("sessiontime", tempExpReservationList.get(i).get("sessiontime"));
			map.put("typename", tempExpReservationList.get(i).get("typename"));
			map.put("productname", tempExpReservationList.get(i).get("productname"));
			map.put("ppname", tempExpReservationList.get(i).get("ppname"));
			map.put("partnertype", String.valueOf(tempExpReservationList.get(i).get("partnertype")));
			map.put("paymentname", tempExpReservationList.get(i).get("paymentname"));
			map.put("expsessionseq", String.valueOf(tempExpReservationList.get(i).get("expsessionseq")));
			map.put("reservationdate", tempExpReservationList.get(i).get("reservationdate"));
			map.put("ppseq", String.valueOf(tempExpReservationList.get(i).get("ppseq")));
			map.put("standbynumber", String.valueOf(tempExpReservationList.get(i).get("standbynumber")));
			map.put("accounttype", tempExpReservationList.get(i).get("accounttype"));
			map.put("visitnumber", String.valueOf(tempExpReservationList.get(i).get("visitnumber")));
			map.put("rsvcancel", tempExpReservationList.get(i).get("rsvcancel"));
			map.put("canceldatetime", tempExpReservationList.get(i).get("canceldatetime"));
			map.put("paymentstatuscode", tempExpReservationList.get(i).get("paymentstatuscode"));
//			map.put("typecode", tempTypeCode.get("typecode"));
			
			expReservationInfoDetailList.add(map);
		}
		
		return expReservationInfoDetailList;
	}
	
	@Override
	public Map<String, String> searchLastRsvPp(RequestBox requestBox) throws Exception {
		
		Map<String, String> searchLastRsvPp = new HashMap<String, String>();
		
		String ppSeq = basicReservationMapper.searchLastRsvPp(requestBox);
		
		if(ppSeq == null){
			searchLastRsvPp.put("ppseq", "1");
		}else{
			searchLastRsvPp.put("ppseq", ppSeq);
		}
		
		return searchLastRsvPp;
	}

	@Override
	public Map<String, String> searchLastRsvRoom(RequestBox requestBox) throws Exception {
		
		Map<String, String> searchLastRsvRoom = new HashMap<String, String>();
		
		String roomSeq = basicReservationMapper.searchLastRsvRoom(requestBox);
		
		searchLastRsvRoom.put("roomseq", roomSeq);
		
		return searchLastRsvRoom;
	}

	@Override
	public Map<String, String> searchMonthRsvCount(RequestBox requestBox) throws Exception {
		return basicReservationMapper.searchMonthRsvCount(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.BasicReservationService#getClauseContendsByKeyCode(java.lang.String)
	 */
	@Override
	public String getClauseContentsByKeyCode(RequestBox requestBox) throws Exception {
		
		String content = basicReservationMapper.getClauseContentsByKeyCode(requestBox);
		
		if(null != content){
			return StringUtil.replaceTag(content);
		}else{
			return "";
		}
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.BasicReservationService#getReservationInfoByType(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public String getReservationInfoByType(RequestBox requestBox) throws Exception {
		
		Map<String, Integer> searchRsvTypeSeq = basicReservationMapper.searchRsvTypeSeq(requestBox);
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		String content = basicReservationMapper.getReservationInfoByType(requestBox);
		
		if(null != content){
			return StringUtil.replaceTag(content);
		}else{
			return "";
		}
		
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.BasicReservationService#getApCodeByPpCode(framework.com.cmm.lib.RequestBox)
	 */
	@Override
	public String getApCodeByPpCode(RequestBox requestBox) throws Exception {
		return basicReservationMapper.getApCodeByPpCode(requestBox);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.BasicReservationService#creditCardCompany()
	 */
	@Override
	public List creditCardCompany() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.BasicReservationService#createXmlForPaymentCardInfo()
	 */
	@Override
	public String createXmlForPaymentCardInfo(Map<String, Object> mappingData) throws Exception {
		
		Configuration cfg = new Configuration();
		
		try {
			
			Template template = cfg.getTemplate("src/main/resources/template/paymentCard.tfl");
			
			//Map<String, Object> mappingData = new HashMap();
			//mappingData.put("apcode", "AAAA");
			
			Writer outStream = new OutputStreamWriter(System.out);
			template.process(mappingData, outStream);
			outStream.flush();
			
		}catch (SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
		return null;
	}

	@Override
	public List<Map<String, String>> roomImageUrlList(RequestBox requestBox) throws Exception {
		
		List<String> fileKeyList = new ArrayList<String>();
		
		for(int i = 0 ; i < requestBox.getVector("fileKeys").size() ; i++){
			fileKeyList.add((String) requestBox.getVector("fileKeys").get(i));
		}
		requestBox.put("fileKeyList", fileKeyList);
		
		return basicReservationMapper.roomImageUrlList(requestBox);
	}

	@Override
	public List<Map<String, String>> searchExpImageFileKeyList(RequestBox requestBox) throws Exception {
		
		List<String> filekey = new ArrayList<String>();
		
		for(int i = 0; i < requestBox.getVector("filekey").size(); i++){
			filekey.add((String) requestBox.getVector("filekey").get(i));
		}
		
		requestBox.put("filekey", filekey);
		
		return basicReservationMapper.searchExpImageFileKeyList(requestBox);
	}

	@Override
	public Map<String, String> searchTypeName(RequestBox requestBox) throws Exception {
		
		for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
			requestBox.put("tempTypeseq", requestBox.getVector("typeseq").get(0));
		}
		
		return basicReservationMapper.searchTypeName(requestBox);
	}

	@Override
	public int insertRsvClauseHistory(RequestBox requestBox) throws Exception {
		
		for(int i = 0; i < requestBox.getVector("typecode").size(); i++){
			// inset data Map
			Map<String, String> map = new HashMap<String, String>();
			
			map.put("typecode", (String) requestBox.getVector("typecode").get(i));
			
			Map<String, String> tempClauseSeq = basicReservationMapper.searchClauseSeq(map);
			
			map.put("account", (String) requestBox.getVector("account").get(0));
			map.put("clauseseq", String.valueOf(tempClauseSeq.get("clauseseq")));
			
			basicReservationMapper.insertRsvClauseHistory(map);
			
		}
		
		return 0;
	}

	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService#selectReservationInfoStepOneByVirtualNumber(java.lang.String)
	 */
	@Override
	public EgovMap selectReservationInfoStepOneByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		return super.selectReservationInfoStepOneByVirtualNumber(virtualPurchaseNumber);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService#selectReservationInfoStepTwoByVirtualNumber(java.lang.String)
	 */
	@Override
	public List<EgovMap> selectReservationInfoStepTwoByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		// TODO Auto-generated method stub
		return super.selectReservationInfoStepTwoByVirtualNumber(virtualPurchaseNumber);
	}
	
	/* (non-Javadoc)
	 * @see amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService#selectReservationInfoStepThreeByVirtualNumber(java.lang.String)
	 */
	@Override
	public EgovMap selectReservationInfoStepThreeByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		return super.selectReservationInfoStepThreeByVirtualNumber(virtualPurchaseNumber);
	}

	@Override
	public List<Map<String, String>> simpleReservationDataByTransaction(RequestBox requestBox) throws Exception {
		return basicReservationMapper.simpleReservationDataByTransaction(requestBox);
	}

	@Override
	public int expProgramVailabilityCheckAjax(
			RequestBox requestBox) {
		// TODO Auto-generated method stub
		return basicReservationMapper.expProgramVailabilityCheckAjax(requestBox);
	}
	
}
