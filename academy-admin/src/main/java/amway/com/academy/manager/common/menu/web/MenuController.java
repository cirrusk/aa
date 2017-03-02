package amway.com.academy.manager.common.menu.web;

import java.util.HashMap;
import java.util.Map;

import amway.com.academy.manager.common.util.PropertiesReader;
import org.apache.commons.collections.map.HashedMap;
import org.apache.ibatis.transaction.TransactionException;
import org.apache.logging.log4j.core.appender.rewrite.MapRewritePolicy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.main.web.MainController;
import amway.com.academy.manager.common.menu.service.MenuService;
import amway.com.academy.manager.lms.common.LmsCode;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/manager/common/menu")
public class MenuController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	MenuService menuService;
	
	/**
	 *  메뉴 리스트
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/menuList.do")
    public ModelAndView menuList(RequestBox requestBox, ModelAndView mav) throws Exception {
        return mav;
    }

	/**
	 *  메뉴 리스트 Ajax
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */

    @RequestMapping(value = "/menuListAjax.do")
    public ModelAndView selectManageMenuListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
    	Map<String, Object> rtnMap = new HashMap<String, Object>();

		// 메뉴 리스트(트리)
		rtnMap.put("treeList",  menuService.selectMenuList(requestBox) );

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	/**
	 *  메뉴 등록
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/insertMenu.do")
	public ModelAndView insertMenu(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		try {
			menuService.insertMenu(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 *  메뉴 수정
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
    @RequestMapping(value="/updateMenu.do")
	public ModelAndView updateMenu(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		try {
			menuService.updateMenu(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 *  메뉴 삭제
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
     @RequestMapping(value = "/deleteMenu.do")
	public ModelAndView deleteMenu(ModelMap map, HttpServletRequest request, ModelAndView mav, RequestBox requestBox)throws  Exception{
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 PropertiesReader ppt = new PropertiesReader();

		 try {
			 menuService.deleteMenu(requestBox);

			 resultMap.put("errCode", "0");
			 resultMap.put("errMsg", "");
		 } catch ( TransactionException e ) {
			 e.printStackTrace();
			 String msg = ppt.getProperties("errors.system");
			 resultMap.put("errMsg", msg);
		 }

		 rtnMap.put("result", resultMap);
		 mav.setView(new JSONView());
		 mav.addObject("JSON_OBJECT", rtnMap);
		 return mav;
	 }


}