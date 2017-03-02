package amway.com.academy.mypage.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import amway.com.academy.common.util.CommomCodeUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.util.PagingUtil;
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
@RequestMapping("/mypage")
public class MyPageController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MyPageController.class);
	
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
	public ModelAndView mypagemessage(ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		requestBox.put("abono",requestBox.getSession("abono"));

		String sRowPerPage = "10"; // 페이지에 넣을 row수

		if((requestBox.getString("schDt1") != null && requestBox.getString("schDt2") != null) && (!("").equals(requestBox.getString("schDt1")) && !("").equals(requestBox.getString("schDt2")))) {
			String schDt1 = requestBox.getString("schDt1").replaceAll("-", "");
			String year1 = schDt1.substring(0, 4);
			String month1 = schDt1.substring(4, 6);
			String day1 = schDt1.substring(6, 8);

			requestBox.put("year1",year1);
			requestBox.put("month1",month1);
			requestBox.put("day1",day1);

			String schDt2 = requestBox.getString("schDt2").replace("-", "");
			String year2 = schDt2.substring(0, 4);
			String month2 = schDt2.substring(4, 6);
			String day2 = schDt2.substring(6, 8);

			requestBox.put("year2",year2);
			requestBox.put("month2",month2);
			requestBox.put("day2",day2);
		}

		model.addAttribute("search", requestBox);

		/**----------------------------페이징-------------------------------------------*/
		PageVO pageVO = new PageVO(requestBox);
		if (("").equals(requestBox.getString("page"))
				|| ("0").equals(requestBox.getString("page"))) {
			requestBox.put("page", "1");
		}

		if ("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}

		pageVO.setTotalCount(mypageService.selectMessageListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);

		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());

		PagingUtil.defaultParmSetting(requestBox);

		model.addAttribute("scrData", requestBox);
		/**--------------------------------------------------------------------------*/


		DataBox checkList = mypageService.checkList(requestBox);
		model.addAttribute("checkList", checkList);

		// 목록리스트
		List<MyPageMessageVO> dataList = mypageService.selectMessageList(requestBox);
		model.addAttribute("msgList", dataList);

		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return mav;
	}
	
}