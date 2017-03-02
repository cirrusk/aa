package amway.com.academy.mypage.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import amway.com.academy.common.util.CommomCodeUtil;
import framework.com.cmm.lib.DataBox;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.mypage.service.MyPageMessageVO;
import amway.com.academy.mypage.service.MyPageService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import framework.com.cmm.lib.RequestBox;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :TrainingFeeMainController.java
 * @DESC :교육비 모바일 index Controller
 *        - 교육비 메뉴 클릭시 호출 하여 페이지 네이게이션 역할을 함
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.08. 18. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/mobile/mypage")
public class MyPageMobileController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MyPageMobileController.class);
	
	/*
	 * Service
	 */
	@Autowired
    private MyPageService mypageService;

	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	/**
	 * 마이페이지 - 맞춤쪽지
	 * @param mav
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noteSend.do")
	public ModelAndView mypagemessage(@ModelAttribute("MyPageMessageVO")MyPageMessageVO myPageMessageVO, ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		myPageMessageVO.setAbono(requestBox.getSession("abono"));

		requestBox.put("abono",requestBox.getSession("abono"));
		DataBox checkList =  mypageService.checkList(requestBox);
		model.addAttribute("checkList", checkList);

		DataBox totCnt = mypageService.checkListCount(requestBox);
		model.addAttribute("totCnt", totCnt);

		// 목록리스트
		List<MyPageMessageVO> dataList = mypageService.selectMobileMessageList(myPageMessageVO);
		
		model.addAttribute("msgList", dataList);

		model.addAttribute("search", myPageMessageVO);

		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "mobile");
		model.addAttribute("analBox", analBox);
		// adobe analytics

       	return mav;
	}
	
}