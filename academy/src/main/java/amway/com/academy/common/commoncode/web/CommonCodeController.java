package amway.com.academy.common.commoncode.web;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.commoncode.service.CommonCodeService;
import framework.com.cmm.lib.RequestBox;


/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :CommonCodeController.java
 * @DESC :관리자 Excel 업로드  Controller
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.07. 01. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/common/commoncode")
public class CommonCodeController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeController.class);
	
	/**
	 * 공통코드 서비스
	 * @param params
	 * @return
	 */
	@Autowired
	CommonCodeService commonCodeService;
	
	/**
	 * 공통코드 리스트
	 * @param majorCd
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCodeList.do")
	public ModelAndView getCodeList(RequestBox requestBox, ModelAndView mav) {

		Map<String, String> cMap = new HashMap<String, String>();
		cMap.put("majorCd", requestBox.get("majorCd")); // 유형 : 연구형, 학습형
//		cMap.put("grpCd", grpCd);
		
		mav.addObject("codeList", commonCodeService.getCodeList(cMap));

		return mav;
	}
}
