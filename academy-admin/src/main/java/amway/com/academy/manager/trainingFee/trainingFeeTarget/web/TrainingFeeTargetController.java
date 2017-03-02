package amway.com.academy.manager.trainingFee.trainingFeeTarget.web;

import java.sql.SQLException;
import java.util.HashMap;
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
import amway.com.academy.manager.common.util.PropertiesReader;
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import amway.com.academy.manager.trainingFee.trainingFeeTarget.service.TrainingFeeTargetService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * 
 * @author KR620208
 *
 */
@Controller
@RequestMapping("/manager/trainingFee/trainingFeeTarget")
public class TrainingFeeTargetController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeTargetController.class);

	/*
	 * Service
	 */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	@Autowired
	TrainingFeeTargetService trainingFeeTargetService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 마스터정보 관리 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMaster.do")
    public ModelAndView trainingFeeMaster(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {    	
		/************ 공통 검색조건 ***************/
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox));
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox));
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
    }
	
	@RequestMapping(value = "/trainingFeeGiveTarget.do")
	public ModelAndView trainingFeeGiveTarget(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {    	
		/************ 공통 검색조건 ***************/
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox));
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox));
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
	}
	
	/**
	 * 마스터정보관리 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterListAjax.do")
    public ModelAndView trainingFeeMasterListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeTargetService.selectTargetListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeTargetService.selectTargetList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 마스터 정보 관리 - 운영그룹
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateMasterGroupCode.do")
    public ModelAndView updateMasterGroupCode(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws SQLException {  
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		
		try{
			requestBox.put("adminId", requestBox.getSession(SessionUtil.sessionAdno));	
			
			trainingFeeTargetService.saveGiveTargetGroupCode(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");			
			
		} catch ( SQLException e ) {
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			String msg = ppt.getProperties("errors.system");

			resultMap.put("errMsg", msg);
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
    }
	
	/**
	 * 마스터 정보괸리dbo.TRFEETARGETMONTH테이블에 해당 ABO정보 삭제
	 * @param model
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterGiveTargetDeleteAjax.do")
	public ModelAndView trainingFeeMasterGiveTargetDeleteAjax(ModelMap model, RequestBox requestBox, ModelAndView mav) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		
		try{
			
			trainingFeeTargetService.trainingFeeMasterGiveTargetDeleteAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			String msg = ppt.getProperties("errors.system");

			resultMap.put("errMsg", msg);
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 마스터정보관리 대상자 정보 추가/수정 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterLearPop01.do")
    public ModelAndView trainingFeeMasterLearPop01(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {  
		/************ 공통 검색조건 ***************/
		model.addAttribute("layerMode", requestBox);
		model.addAttribute("targetInfo", trainingFeeCommonService.selectTargetInfoList(requestBox));
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox));
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox));
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));
		
		return mav;
    }
	
	/**
	 * 마스터 정보관리_레이어 팝업 추가/수정
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterSaveAjax.do")
	public ModelAndView trainingFeeMasterSaveAjax(RequestBox requestBox, ModelAndView mav) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		String sErrCode = "0";
		String sErrMsg = "";
		
		try{
			
			// 추가/수정 모드별 분리 프로세스
			if("I".equals(requestBox.get("mode"))) {
				// 1.Calculation ABO 존재 여부 체크( 연도/월 )
				DataBox checkedAboNo = trainingFeeTargetService.trainingFeeMasterCheckedAboNoAjax(requestBox);
				String sCnt = checkedAboNo.get("cnt").toString();
				
				if( !sCnt.equals("0") ){
					// 월별 대상자에 존재하면 에러!
					sErrCode = "-1";
					sErrMsg = "추가 하고자 하는 Calculation ABO는 존재 합니다.\n확인 후 대상자를 추가 해 주세요!!";
				} else {
					// 월별대상자에 존재 하지 않은면 insert
					sErrCode = "0";
					sErrMsg = "대상자 추가를 완료 하였습니다.";
					
					trainingFeeTargetService.trainingFeeMasterInsertAboTrainingfeegivetarget(requestBox);
					
					// 누적 대상자에 존재 하지 않으면 insert
					if("0".equals(checkedAboNo.get("fullcnt"))){
						trainingFeeTargetService.trainingFeeMasterInsertAboTrainingfeetarget(requestBox);
					} else {
						/**dbo.TRFEETARGETFULL 테이블 정보 수정 */
						trainingFeeTargetService.trainingFeeMasterTargetUpdateAjax(requestBox);
					}
				}
				
			} else {
				trainingFeeTargetService.trainingFeeMasterUpdateLearPop01Ajax(requestBox);
				
				sErrCode = "0";
				sErrMsg = "대상자 수정을 완료 하였습니다.";
			}
			
			resultMap.put("errCode", sErrCode);
			resultMap.put("errMsg", sErrMsg);			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			String msg = ppt.getProperties("errors.system");

			resultMap.put("errMsg", msg);
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
	/**
	 * 마스터정보관리 메모장
	 * @param model
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterMemoLearPop01.do")
	public ModelAndView trainingFeeMasterMemoLearPop01(ModelMap model, RequestBox requestBox, ModelAndView mav) throws Exception{
		
		/************ 공통 검색조건 ***************/
//		model.addAttribute("searchTarget", trainingFeeCommonService.selectTargetInfoList(requestBox));
		//메모 조회
//		DataBox trainingFeeMasterMemoDetail = trainingFeeCommonService.selectTargetInfoList(requestBox);
		model.addAttribute("layerMode", requestBox);
		model.addAttribute("memoDetail", trainingFeeCommonService.selectTargetInfoList(requestBox));
		
		return mav;
	}
	
	/**
	 * 마스터정보관리 저장
	 * @param model
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMasterMemoUpdateAjax.do")
	public ModelAndView trainingFeeMasterMemoUpdateAjax(ModelMap model, RequestBox requestBox, ModelAndView mav) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		
		try{
			
			trainingFeeTargetService.trainingFeeMasterMemoUpdateAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			String msg = ppt.getProperties("errors.system");

			resultMap.put("errMsg", msg);
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 지급대상자관리 조회_tab1
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeGiveTargetListAjax.do")
    public ModelAndView trainingFeeGiveTargetListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeTargetService.selectGiveTargetListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeTargetService.selectGiveTargetList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 지급대상자관리 조회_tab2 운영그룹
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeGiveTargetGrpListAjax.do")
    public ModelAndView trainingFeeGiveTargetGrpListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeTargetService.trainingFeeGiveTargetGrpListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeTargetService.trainingFeeGiveTargetGrpList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 지급대상자관리 조회_tab2 운영그룹 대상자
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeGiveTargetGrpDetailListAjax.do")
	public ModelAndView trainingFeeGiveTargetGrpDetailListAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeTargetService.trainingFeeGiveTargetGrpDetailListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeTargetService.trainingFeeGiveTargetGrpDetailList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	
	
}