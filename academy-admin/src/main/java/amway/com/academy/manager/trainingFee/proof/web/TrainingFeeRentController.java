package amway.com.academy.manager.trainingFee.proof.web;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeRentService;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeSpendService;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620225
 * 교육비_임차료 관리 컨트롤러
 */
@Controller
@RequestMapping("/manager/trainingFee/proof")
public class TrainingFeeRentController {
	
	/** 검색조건  Service */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	@Autowired
	TrainingFeeRentService trainingFeeRentService;

	@Autowired
	TrainingFeeSpendService trainingFeeSpendService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeRentController.class);

	/**
	 * 임차료 관리 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRent.do")
	public ModelAndView trainingFeeRent(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		//공통
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그룹
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //LOA
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));//dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox)); //C.PIN
				
		return mav;
	}
	
	/**
	 * 임차료관리 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeRentListAjax.do")
	public ModelAndView trainingFeeRentListAjax(RequestBox requestBox, ModelAndView mav,ModelMap model) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeRentService.selectRentListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeRentService.selectRentList(requestBox));
		rtnMap.put("getCount",  trainingFeeRentService.selectTotalCount(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	/**
	 * 임차료 신청 정보
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailInfo.do")
	public ModelAndView trainingFeeRentDetailInfo(ModelMap model, HttpServletRequest request,  RequestBox requestBox ) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");

		List<Map<String, Object>> listArrMap = new ArrayList<Map<String,Object>>();
		
		// 임차료 신청 정보
		mav.addObject("rentData", trainingFeeRentService.selectRentDetailInfo(requestBox));
		List<Map<String, Object>> listMap = trainingFeeRentService.selectRentDetailImg(requestBox);
		
		for(int i=0; i<listMap.size();i++) {
			Map<String, Object> rtnMap = listMap.get(i);
			
			String attachFile = StringUtil.getEncryptStr(rtnMap.get("filekey").toString());
			String uploadSeq = StringUtil.getEncryptStr(rtnMap.get("uploadseq").toString());
			String filefullurl = StringUtil.getEncryptStr(rtnMap.get("filefullurl").toString());
			String storefilename = StringUtil.getEncryptStr(rtnMap.get("storefilename").toString());
			rtnMap.put("filekey", attachFile);
			rtnMap.put("uploadseq", uploadSeq);
			rtnMap.put("filefullurl", filefullurl);
			rtnMap.put("storefilename", storefilename);
			
			listArrMap.add(i, rtnMap);
		}
		
		mav.addObject("imgData", listArrMap);				
		return mav;
	}
		
	/**
	 * 임차료 상세보기(개인) - 조회
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailListAjax.do")
	public ModelAndView trainingFeeRentDetailListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeRentService.selectRentDetailCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeRentService.selectRentDetailList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;		
	}
	
	/**
	 * 임차료 상세보기(개인) - 승인
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailConfrim.do")
	public ModelAndView trainingFeeRentDetailConfrim(HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String sY = "Y";
		String errCode = "0";
		String errMsg  = "";
		
		try{
			/**
			 * 임대차 신청 정보를 가져 온다.
			 */
			Map<String, Object> rentData = trainingFeeRentService.selectRentDetailInfo(requestBox);
			
			/**
			 * 사전 계획서 및 지출증빙 제출 상태값을 가져 온다.(임대차 신청 년/월 기준 체크)
			 */
			requestBox.put("giveyear" , rentData.get("giveyear")   );
			requestBox.put("givemonth", rentData.get("givemonth")  );
			requestBox.put("abono"    , requestBox.get("depabo_no"));
			requestBox.put("giveRadio", "1");
			Map<String, Object> statusMap = trainingFeeSpendService.selectStatus(requestBox);

			String planstatus  = statusMap.get("planstatus").toString();
			
			/**
			 * 사전계획서 제출 전이면 승인 및 반려 처리가 불가
			 */
			if( planstatus.equals("N") ) {
				errCode = "-1";
				errMsg = "사전계획서 제출 전에는 승인/반려 할 수 없습니다.";
			} else {
				Map<String, Object> rentDetail = trainingFeeRentService.selectRentDetailInfo(requestBox);
				
				if(!sY.equals(rentDetail.get("checkflag"))) {
					errMsg = "임대차 계약서 확인 후 승인 처리 해 주세요!";
					errCode = "-1";
				} else if("R".equals(rentDetail.get("rentstatus"))){
					errMsg = "반려 처리 된 임대차 계약서는 승인 처리 할 수 없습니다.";
					errCode = "-1";
				} else if("Y".equals(rentDetail.get("rentstatus"))){
					errMsg = "승인 완료 된 임대차 계약서 입니다.";
					errCode = "-1";
				} else {
					trainingFeeRentService.saveRentConfrim(requestBox);
				}
			}
			
			resultMap.put("errCode", errCode);
			resultMap.put("errMsg", errMsg);			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 임차료 상세보기(그룹) - 승인
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailGrpConfrim.do")
	public ModelAndView trainingFeeRentDetailGrpConfrim(HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String sY = "Y";
		String errCode = "0";
		String errMsg  = "승인 처리가 완료 되었습니다.";
		
		try{
			/**
			 * 임대차 신청 정보를 가져 온다.
			 */
			Map<String, Object> rentData = trainingFeeRentService.selectRentDetailInfo(requestBox);
			
			/**
			 * 사전 계획서 및 지출증빙 제출 상태값을 가져 온다.(임대차 신청 년/월 기준 체크)
			 */
			requestBox.put("giveyear" , rentData.get("giveyear")   );
			requestBox.put("givemonth", rentData.get("givemonth")  );
			requestBox.put("abono"    , requestBox.get("depabo_no"));
			requestBox.put("giveRadio", "2");
			Map<String, Object> statusMap = trainingFeeSpendService.selectStatus(requestBox);

			String planstatus  = statusMap.get("planstatus").toString();
			
			/**
			 * 사전계획서 제출 전이면 승인 및 반려 처리가 불가
			 */
			if( planstatus.equals("N") ) {
				errCode = "-1";
				errMsg = "사전계획서 제출 전에는 승인/반려 할 수 없습니다.";
			} else {
				Map<String, Object> rentDetail = trainingFeeRentService.selectRentDetailInfo(requestBox);
				
				if(!sY.equals(rentDetail.get("checkflag"))) {
					errMsg = "임대차 계약서 확인 후 승인 처리 해 주세요!";
					errCode = "-1";
				} else if("R".equals(rentDetail.get("rentstatus"))){
					errMsg = "반려 처리 된 임대차 계약서는 승인 처리 할 수 없습니다.";
					errCode = "-1";
				} else if("Y".equals(rentDetail.get("rentstatus"))){
					errMsg = "승인 완료 된 임대차 계약서 입니다.";
					errCode = "-1";
				} else {
					trainingFeeRentService.saveRentGrpConfrim(requestBox);
				}
			}
			
			resultMap.put("errCode", errCode);
			resultMap.put("errMsg", errMsg);
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 임차료 상세보기(그룹) - 승인
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailCheck.do")
	public ModelAndView trainingFeeRentDetailCheck(HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int result = 0;
		
		try{
			
			result = trainingFeeRentService.saveRentImgCheck(requestBox);
			
			resultMap.put("errCode", result);
			resultMap.put("errMsg", "");			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 임차료 상세보기(개인) - 반려 layer pop
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentRejectPop.do")
	public ModelAndView trainingFeeRentRejectPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		model.addAttribute("lyData", requestBox);
		model.addAttribute("targetInfo",  trainingFeeRentService.selectRentDetailInfo(requestBox));
		
		return mav;
	}
	
	/**
	 * 임차료 상세보기(개인) - 반려
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailReject.do")
	public ModelAndView trainingFeeRentDetailReject(HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String errCode = "0";
		String errMsg  = "";
		
		try{
			/**
			 * 임대차 신청 정보를 가져 온다.
			 */
			Map<String, Object> rentData = trainingFeeRentService.selectRentDetailInfo(requestBox);
			/**
			 * 사전 계획서 및 지출증빙 제출 상태값을 가져 온다.(임대차 신청 년/월 기준 체크)
			 */
			requestBox.put("giveyear" , rentData.get("giveyear")   );
			requestBox.put("givemonth", rentData.get("givemonth")  );
			requestBox.put("abono"    , requestBox.get("depabo_no"));
			Map<String, Object> statusMap = trainingFeeSpendService.selectStatus(requestBox);

			String planstatus  = statusMap.get("planstatus").toString();
			String rentstatus  = rentData.get("rentstatus").toString();
			
			/**
			 * 사전계획서 제출 전이면 승인 및 반려 처리가 불가
			 */
			if( planstatus.equals("N") ) {
				errCode = "-1";
				errMsg = "사전계획서 제출 전에는 승인/반려 할 수 없습니다.";
			} else if(rentstatus.equals("Y")) {
				errCode = "-1";
				errMsg = "승인 완료된 임대차는 반려 할 수 없습니다.";
			} else {
				trainingFeeRentService.updateRentReject(requestBox);
			}
			
			resultMap.put("errCode", errCode);
			resultMap.put("errMsg", errMsg);			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	/**
	 * 임차료 상세보기(그룹) - 조회
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentGrpDetailListAjax.do")
	public ModelAndView trainingFeeRentGrpDetailListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeRentService.selectRentGrpDetailListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeRentService.selectRentGrpDetailList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;		
	}
	
	/**
	 * 임차료 상세보기(개인)
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetail.do")
	public ModelAndView trainingFeeRentDetail(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		return mav;
	}
	
	/**
	 * 임차료 상세보기(그룹)
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trainingFeeRentDetailGrp.do")
	public ModelAndView trainingFeeRentDetailGrp(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		// 임차료 신청 정보
		return mav;
	}
	
	@RequestMapping(value="/trainingFeeRentDetailGrpApproveAjax.do")
	public ModelAndView trainingFeeRentDetailGrpApproveAjax(HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{

		mav.addObject("JSON_OBJECT",  trainingFeeRentService.saveRentGrpApprove(requestBox));
		
		return mav;
	}
	
	/**
	 * 교육비_임차료 관리 계약서 상세보기 레이어 팝업 호출
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeRentLearPop01.do")
	public ModelAndView trainingFeeRentLearPop01(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav
		) throws Exception{
		
		return mav;
	}
}
