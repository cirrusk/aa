package amway.com.academy.lms.myAcademy.web;

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

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.web.LmsCommonController;
import amway.com.academy.lms.myAcademy.service.LmsMyContentService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620260
 *		date : 2016.08.16
 * lms 보관함 컨트롤러
 */
@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMyDepositController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsMyDepositController.class);

	@Autowired
	LmsUtil lmsUtil;
	
	@Autowired
	LmsCommonController lmsCommonController;
	
	/*
	 * Service
	 */
	@Autowired
    private LmsMyContentService lmsMyContentService;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	@RequestMapping(value = "/lmsMyDeposit.do")
	public ModelAndView lmsMyDeposit(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
				
		ModelAndView mav = null;
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.get("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		//검색항목 세팅
		String blankStr = "";
		if(blankStr.equals(requestBox.getString("searchcoursetype"))) {requestBox.put("searchcoursetype", "");}
		
		String sortCol = "SAVEDATE";
		String sortOpt = "DESC";
		if(blankStr.equals(requestBox.getString("sortColumn"))) {requestBox.put("sortColumn", sortCol);}
		if(blankStr.equals(requestBox.getString("sortOrder"))) {requestBox.put("sortOrder", sortOpt);}
		
		requestBox.put("savetype", "2");
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);	
		String zeroStr = "0";
		if(blankStr.equals(requestBox.getString("page")) || zeroStr.equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if(blankStr.equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "12");}

		//전체 갯수 읽어오기
		pageVO.setTotalCount(lmsMyContentService.selectLmsSaveLogCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);

		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == 0) {requestBox.put("page", "1");}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> dataList = lmsMyContentService.selectLmsSaveLogList(requestBox);
		
    	model.addAttribute("dataList", dataList);
    	model.addAttribute("data", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/myAcademy/lmsMyDeposit");
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsMyDepositDeleteAjax.do")
	public ModelAndView lmsMyDepositDeleteAjax(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			rtnMap.put("result", "LOGOUT");
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}

		// 보관함 삭제 처리
		requestBox.put("savetype", "2");
		int delCount = lmsMyContentService.deleteLmsSaveLog(requestBox);
		if( delCount < 0 ) {
			rtnMap.put("result", "FAIL");
		} else {
			rtnMap.put("result", "SUCCESS");
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;

	}	
}
