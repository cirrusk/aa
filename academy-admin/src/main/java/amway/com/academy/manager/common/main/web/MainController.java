package amway.com.academy.manager.common.main.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.menu.service.MenuService;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.web.CommonController;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Controller
@RequestMapping("/manager/common/main")
public class MainController extends CommonController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	MenuService menuService;	
	
    @RequestMapping(value = "/main.do")
    public ModelAndView adminMainIndex(RequestBox requestBox, ModelAndView mav) throws Exception {
        
    	//관리자 세션 체크
    	if( "".equals( requestBox.getSession( SessionUtil.sessionAdno ) ) ) {
    		//관리자 세션 에러
   			return new ModelAndView("/manager/common/session/session"); //session :일반, sessionPop : 팝업
    	}
    	
    	requestBox.put("adno", requestBox.getSession( SessionUtil.sessionAdno));
    	
    	List<DataBox> list = menuService.selectMainMenuList(requestBox);
        mav.addObject("adminLeftMenu",  list);

        // view name 을 지정하지 않으면 Request URL 과 동일한 파일명을 자동으로 찾는다.
        // jsp 페이지의 경로나 파일명이 Request URL 과 일치하지 않는경우 명시적으로 view name 을 지정해 준다.
        // mav.setViewName("sample");
        return mav;
    }
    
    @RequestMapping(value = "/logout.do")
    public ModelAndView adminMainLogout(HttpServletRequest request, ModelAndView mav) throws Exception {
    	
    	//세션 삭제
    	request.getSession().invalidate();
    	
        return mav;
    }
    
    @RequestMapping(value = "/gridDetail.do")
    public ModelAndView gridDetail(ModelMap model, RequestBox requestBox, HttpServletRequest request, ModelAndView mav) throws Exception {
    	System.out.println(requestBox.getObject("json"));
    	model.addAttribute("scrData", requestBox);
		
		return mav;
    }
}