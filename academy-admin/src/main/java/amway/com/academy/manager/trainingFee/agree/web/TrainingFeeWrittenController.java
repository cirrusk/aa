package amway.com.academy.manager.trainingFee.agree.web;

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
import amway.com.academy.manager.trainingFee.agree.service.TrainingFeeWrittenService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;


/**
 * 교육비 약관문서 관리
 * @author KR620208
 *
 */
@RequestMapping("/manager/trainingFee/agree")
@Controller
public class TrainingFeeWrittenController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeWrittenController.class);
	
	/*
	 * Service
	 */
	@Autowired
	TrainingFeeWrittenService trainingFeeWrittenService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 교육비 약관문서관리 - 교육비서약서
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgree.do")
	public ModelAndView trainingFeeAgree(ModelMap model, HttpServletRequest request, ModelAndView mav ) throws Exception{ return mav; }
	
	/**
	 * 교육비 약관문서관리 - 교육비위임동의
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeDeleg.do")
	public ModelAndView trainingFeeAgreeDeleg(ModelMap model, HttpServletRequest request, ModelAndView mav ) throws Exception{ return mav; }
	
	/**
	 * 교육비 약관문서관리 - 교육비제3자동의
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeThirdPerson.do")
	public ModelAndView trainingFeeAgreeThirdPerson(ModelMap model, HttpServletRequest request, ModelAndView mav ) throws Exception{ return mav; }
	
	/**
	 * 교육비 약관문서관리 - 교육시서약서 조회
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeWrittenSearch.do")
	public ModelAndView trainingFeeWrittenSearch(RequestBox requestBox, ModelAndView mav) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(trainingFeeWrittenService.selectWrittenListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeWrittenService.selectWrittenList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육비 서약서 등록 레이어 팝업 호출
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeWrittenEdit.do")
	public ModelAndView trainingFeeWrittenEdit(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		model.addAttribute("layPopData",requestBox);
		
		if( "list".equals(requestBox.get("type")) ) {
			rtnMap = trainingFeeWrittenService.selectWrittenData(requestBox);
			
			String agreetext = (String) rtnMap.get("agreetext");
			rtnMap.put("agreetext", StringUtil.replaceTag(agreetext));
			
			model.addAttribute("dtlData", rtnMap);
		}
		
		return mav; 
	}

	/**
	 * 교육비 위임자 엑셀 업로드 팝업창 오픈
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeWrittenAuthExcelUpload.do")
	public ModelAndView trainingFeeWrittenAuthExcelUpload(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{ 
		model.addAttribute("layPopData",requestBox);
		
		return mav; 
	}
	
	/**
	 * 교육비 서약서 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveWrittenEdit.do")
	public ModelAndView saveWrittenEdit(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{ 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			trainingFeeWrittenService.saveWrittenEdit(requestBox);
			
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
