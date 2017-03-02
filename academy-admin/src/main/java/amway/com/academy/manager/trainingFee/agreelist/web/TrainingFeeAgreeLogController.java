package amway.com.academy.manager.trainingFee.agreelist.web;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.common.file.service.FileUpLoadService;
import amway.com.academy.manager.trainingFee.agreelist.service.TrainingFeeAgreeLogService;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620208
 * 교육비_교육비 서약 동의 현황 컨트롤러
 */
@RequestMapping("/manager/trainingFee/agreelist")
@Controller
public class TrainingFeeAgreeLogController {

	/** 검색조건  Service */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	@Autowired
	TrainingFeeAgreeLogService trainingFeeAgreeLogService;
	
	@Autowired
	FileUpLoadService fileUpLoadService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeAgreeLogController.class);
	
	/**
	 * 교육비 서약서 동의
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeLog.do")
	public ModelAndView trainingFeeAgreeLog(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그룹
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //LOA
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));//dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));		
		
		return mav;
	}
	
	/**
	 * 교육비 위임 동의
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeDelegLog.do")
	public ModelAndView trainingFeeAgreeDelegLog(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그룹
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //LOA
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));//dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
	}
	
	@RequestMapping(value = "/trainingFeeAgreeThirdpersonLog.do")
	public ModelAndView trainingFeeAgreeThirdpersonLog(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그룹
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //LOA
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox));//dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
	}
	
	/**
	 * 교육비 서약서 동의 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAgreeLog.do")
	public ModelAndView selectAgreeLog(RequestBox requestBox, ModelAndView mav) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);	
		pageVO.setTotalCount(trainingFeeAgreeLogService.selectAgreeLogListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeAgreeLogService.selectAgreeLogList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 교육비 위임 동의 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAgreeDelegLog.do")
	public ModelAndView selectAgreeDelegLog(RequestBox requestBox, ModelAndView mav) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);	
		pageVO.setTotalCount(trainingFeeAgreeLogService.selectAgreeDelegLogListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeAgreeLogService.selectAgreeDelegLogList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 교육비 제3자 동의 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectThirdpersonLog.do")
	public ModelAndView selectThirdpersonLog(RequestBox requestBox, ModelAndView mav) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);	
		pageVO.setTotalCount(trainingFeeAgreeLogService.selectThirdpersonLogListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeAgreeLogService.selectThirdpersonLogList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 교육비 Special위임
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/trainingFeeAgreeSpecialLog.do")
	public ModelAndView trainingFeeAgreeSpecialLog(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		return mav;
	}
	
	/**
	 * 교육비 Special위임 - 파일업로드
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/trainingFeeAgreeSpecialLogFile.do")
	public ModelAndView trainingFeeAgreeSpecialLogFile(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		model.addAttribute("lyData", requestBox);
		return mav;
	}
	
	/**
	 * 교육비 Special위임 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSpecialLog.do")
	public ModelAndView selectSpecialLog(RequestBox requestBox, ModelAndView mav) throws Exception{
		List<DataBox> listArrMap = new ArrayList<DataBox>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);	
		pageVO.setTotalCount(trainingFeeAgreeLogService.selectSpecialLogListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
				
		List<DataBox> listMap = trainingFeeAgreeLogService.selectSpecialLogList(requestBox);
		
		for(int i=0; i<listMap.size();i++) {
			DataBox forMap = listMap.get(i);
			String attachFile = StringUtil.getEncryptStr(forMap.getObject("attachfile").toString());
			String uploadSeq = StringUtil.getEncryptStr(forMap.getObject("uploadseq").toString());
			forMap.put("attachfile", attachFile);
			forMap.put("uploadseq", uploadSeq);
			listArrMap.add(forMap);
		}
		
		rtnMap.put("dataList", listArrMap );
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 교육비 Special위임 - 파일 업로드
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return 
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/fileUpLoad.do")
	public  ModelAndView fileUpLoad(ModelMap model, HttpServletRequest request,MultipartHttpServletRequest multiRequest, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView();
		Map<String,Object> rtn = new HashMap<String,Object>();
		String sNull = "";
		
		/**
		 * 사용자 정보 셋팅 - Session 
		 */
//		AuthVO authVO = SessionUtils.getCurrentAuth(request);
		requestBox.put("work", "ADMINTRFEE");
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
	    
		if (!files.isEmpty()) {
			rtn = fileUpLoadService.getInsertFile(files, requestBox);
			
			if( !sNull.equals(rtn.get("filekey")) ) {
				requestBox.put("filekey", rtn);
				trainingFeeAgreeLogService.saveSpecialLog(requestBox);
			}
		}
		
		return mav;
	}
	
	/**
	 * 약관동의서 출력	
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreePrint.do")
	public ModelAndView trainingFeeAgreePrint(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		
		List<Map<String, Object>> agreeData = trainingFeeAgreeLogService.selectAgreePrint(requestBox);  
		
		model.addAttribute("agreeData", agreeData);
		model.addAttribute("lyData", requestBox);
		
		return mav;
	}
	
	/**
	 * Special위임내역 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeSpecialLogDelete.do")
	public ModelAndView trainingFeeAgreeSpecialLogDelete(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			trainingFeeAgreeLogService.deleteSpecialLog(requestBox);
			
			resultMap.put("errCode", "0");
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
	
}
