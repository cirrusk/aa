package amway.com.academy.manager.common.searchabo.web;

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

import amway.com.academy.manager.common.searchabo.service.SearchAboService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :ManageExcelController.java
 * @DESC :관리자 Excel 업로드  Controller
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.07. 01. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/common/searchabo")
public class SearchAboController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(SearchAboController.class);
	
	/**
	 * 공통코드 서비스
	 * @param params
	 * @return
	 */
	@Autowired
	private SearchAboService searchAboService;
	
	/**
	 * 검색 할 abo 팝업 오픈
	 * @param majorCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchAbo.do")
	public ModelAndView searchAbo(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int result=0;
		
		result = searchAboService.selectAboDataCount(requestBox);
		int reNum = 1;
		if(result>reNum) {
			// layer pop open
			rtnMap.put("errCode","1");
		} else if(result==0) {
			rtnMap.put("errCode","100");
		} else {
			// 단일 건이면 리턴 한다.
			rtnMap.put("errCode","0");
			rtnMap = searchAboService.selectAboData(requestBox);
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 팝업 오픈
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "/searchAboPopup.do")
	public ModelAndView searchAboPopup(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		model.addAttribute("lyData", requestBox);
		return mav;
	}
	
	/**
	 * 팝업 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchAboList.do")
	public ModelAndView searchAboList(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(searchAboService.selectAboListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  searchAboService.selectAboList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
}
