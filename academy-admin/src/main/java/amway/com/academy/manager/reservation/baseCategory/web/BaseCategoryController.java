package amway.com.academy.manager.reservation.baseCategory.web;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.spring.web.servlet.view.JsonView;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.reservation.baseCategory.service.BaseCategoryService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.manager.common.file.service.FileUpLoadService;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * <pre>
 * </pre>
 * Program Name  : BaseCategoryController.java
 * Author : KR620207
 * Creation Date : 2016. 9. 1.
 */
@Controller
@RequestMapping(value = "/manager/reservation/baseCategory")
public class BaseCategoryController extends BasicReservationController {

	@Autowired
	public BaseCategoryService baseCategoryService;
	
	@Autowired
	FileUpLoadService fileUpLoadService;
	
	/**
	 * 브랜드 카테고리 목록 화면 페이지 이동
	 * @param codeVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryList.do")
	public String baseCategoryList(CommonCodeVO codeVO, ModelMap model) throws Exception {
		
		model.addAttribute("useStateCodeList", super.stateCodeList());
		return "/manager/reservation/baseCategory/baseCategoryList";
	}
	
	/**
	 * 브랜드 카테고리 입력 팝업
	 * @param modelMap
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryInsertPop.do")
	public ModelAndView baseCategoryInsertPopupForm(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		model.addAttribute("parentCategory", baseCategoryService.parentCategoryInfo(requestBox));
		model.addAttribute("useStateCodeList", super.stateCodeList());
		model.addAttribute("expTypeInfoCodeLIst", super.expTypeInfoCodeList());
		
		model.addAttribute("lyData", requestBox);
		
		return mav; 
	}

	/**
	 * 브랜드 카테고리 수정 팝업
	 * @param modelMap
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryUpdatePop.do")
	public ModelAndView baseCategoryUpdatePopupForm(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		model.addAttribute("parentCategory", baseCategoryService.parentCategoryInfo(requestBox));
		model.addAttribute("useStateCodeList", super.stateCodeList());
		
		model.addAttribute("lyData", requestBox);
		
		return mav; 
	}
	
	/**
	 * 브랜드 카테고리 데이터 조회 기능
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryListAjax.do")
	public ModelAndView baseCategoryListAjax(ModelAndView mav, ModelMap model, RequestBox requestBox) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseCategoryService.baseCategoryListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",baseCategoryService.baseCategoryList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/isAvailableCategoryTypecode.do")
	public ModelAndView isAvailableCategoryTypeCode(ModelMap model, RequestBox requestBox) throws Exception {
		ModelAndView mav = new ModelAndView(new JsonView());
		
		boolean result = baseCategoryService.isAvailableCategoryTypeCode(requestBox);
		
		mav.addObject("result", result);
		return mav;
	}
	
	/**
	 * 브랜드 카테고리 데이터 입력
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryInsertAjax.do")
	public ModelAndView baseCategoryInsertAjax(ModelMap model, RequestBox requestBox, MultipartHttpServletRequest multiRequest) throws Exception {
		ModelAndView mav;
		
		requestBox.put("adminId", requestBox.getSession(SessionUtil.sessionAdno));
		
		// ie 버전 체크
		if(("msie ").equals(requestBox.get("browserName")) && ("9.0").equals(requestBox.get("browserVersion"))){
			mav = new ModelAndView();
		}else{
			mav = new ModelAndView(new JsonView());
		}
		
		Map<String,Object> rtn = new HashMap<String,Object>();
		int count = 0;
		
		/**
		 * 사용자 정보 셋팅 - Session 
		 */
//		AuthVO authVO = SessionUtils.getCurrentAuth(request);
		requestBox.put("work", "RSVBRAND");
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
	     
		if (!files.isEmpty()) {
			rtn = fileUpLoadService.getInsertFile(files, requestBox);
			
			if( !("").equals(rtn.get("filekey")) ) {
				requestBox.put("filekey", rtn);
				requestBox.put("adminId", requestBox.getSession(SessionUtil.sessionAdno));
//				count = baseCategoryService.baseCategoryInsert(requestBox);
			}
		}
		
		
		count = baseCategoryService.baseCategoryInsert(requestBox);
		
		mav.addObject("result", count);
		return mav;
	}
	
	/**
	 * 브랜드 카테고리 데이터 수정
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryUpdateAjax.do")
	public ModelAndView baseCategoryUpdateAjax(ModelMap model, RequestBox requestBox, MultipartHttpServletRequest multiRequest) throws Exception {
		ModelAndView mav;
		
		// ie 버전 체크
		if(("msie ").equals(requestBox.get("browserName")) && ("9.0").equals(requestBox.get("browserVersion"))){
			mav = new ModelAndView();
		}else{
			mav = new ModelAndView(new JsonView());
		}
		
		Map<String,Object> rtn = new HashMap<String,Object>();
		int count = 0;
		
		/**
		 * 사용자 정보 셋팅 - Session 
		 */
		requestBox.put("adminId", requestBox.getSession(SessionUtil.sessionAdno));
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
	    
		if (!files.isEmpty()) {
			requestBox.put("work", "RSVBRAND");
			rtn = fileUpLoadService.getInsertFile(files, requestBox);
			
			if( !("").equals(rtn.get("filekey")) ) {
				requestBox.put("fileKey", rtn.get("fileKey"));
				
				count = baseCategoryService.baseCategoryUpdate(requestBox);
			}
		} else {
			count = baseCategoryService.baseCategoryUpdate(requestBox);
		}
		
		mav.addObject("result", count);
		return mav;
	}
	
	/**
	 * 브랜드 카테고리 데이터 삭제
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseCategoryDeleteAjax.do")
	public ModelAndView baseCategoryDeleteAjax(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
//		Map<String, Object> rtnMap = new HashMap<String, Object>();

		int count = baseCategoryService.baseCategoryDelete(requestBox);
		
		mav.addObject("JSON_OBJECT", count);
		
		return mav;
	}
}
