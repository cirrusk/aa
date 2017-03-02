package amway.com.academy.manager.common.systemCode.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import amway.com.academy.manager.common.systemCode.service.SystemCodeService;
import amway.com.academy.manager.common.util.PropertiesReader;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import org.apache.ibatis.transaction.TransactionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.lib.RequestBox;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Controller
@RequestMapping("/manager/common/systemCode")
public class SystemCodeController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(SystemCodeController.class);

	@Autowired
	SystemCodeService systemCodeService;

	/**
	 *  코드관리 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/systemCodeList.do")
    public ModelAndView systemCodeList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

		model.addAttribute("listScope", systemCodeService.codeListScope(requestBox)); //코드분류 리스트

		return mav;
    }

	/**
	 *  코드관리 리스트(AJAX)
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/systemCodeListAjax.do")
	public ModelAndView systemCodeListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(systemCodeService.systemCodeListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
        rtnMap.put("dataList",systemCodeService.systemCodeList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 * 코드관리 마스터 팝업
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeListPop.do")
	public ModelAndView systemCodeListPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		DataBox popDetail = systemCodeService.systemCodeListPop(requestBox);
		model.addAttribute("codeDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 * 코드관리 마스터 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeInsert.do")
	public ModelAndView systemCodeInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = systemCodeService.systemCodeInsert(requestBox);

			resultMap.put("errCode", result);
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 * 코드관리 마스터 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeUpdate.do")
	public ModelAndView systemCodeUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = systemCodeService.systemCodeUpdate(requestBox);

			resultMap.put("errCode", result);
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
	 * 코드관리 마스터 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDelete.do")
	public ModelAndView systemCodeDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
        int existyn = 0;

		try {

			//하위코드존재여부체크
		    existyn = systemCodeService.existyn(requestBox);
			if(existyn > 0){
				resultMap.put("errCode","2");
			}else{
				result = systemCodeService.systemCodeDelete(requestBox);

				resultMap.put("errCode", result);
				resultMap.put("errMsg", "");
			}

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
	 *  코드상세 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetail.do")
	public ModelAndView systemCodeDetail(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

		model.addAttribute("codeDetail", systemCodeService.codeListDetail(requestBox)); //코드분류 리스트 LMS , 교육장 , 교육비

		return mav;
	}

	/**
	 * 코드상세 리스트(AJAX)
	 * @param
	 * @param
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value=" /systemCodeDetailAjax.do")
	public ModelAndView systemCodeDetailAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//리스트
		rtnMap.put("dataList", systemCodeService.systemCodeDetail(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 * 코드상세 팝업
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetailPop.do")
	public ModelAndView systemCodeDetailPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		DataBox popDetail = new DataBox();

		if(requestBox.get("mode").equals("U")) {
			popDetail = systemCodeService.systemCodeDetailPop(requestBox);
		}

		model.addAttribute("codeDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 * 코드상세 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetailInsert.do")
	public ModelAndView systemCodeDetailInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = systemCodeService.systemCodeDetailInsert(requestBox);

			resultMap.put("errCode", result);
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
	 * 코드상세 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetailUpdate.do")
	public ModelAndView systemCodeDetailUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = systemCodeService.systemCodeDetailUpdate(requestBox);

			resultMap.put("errCode", result);
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
	 * 코드상세 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetailDelete.do")
	public ModelAndView systemCodeDetailDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		try {
			result = systemCodeService.systemCodeDetailDelete(requestBox);

			resultMap.put("errCode", result);
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
	 * 코드상세 순번 정렬
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/systemCodeDetailOrder.do")
	public ModelAndView systemCodeDetailOrder(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		try {
			String[] orderArr = requestBox.get("neworder").split(",");

			for(int i=0; i<orderArr.length; i++) {
				String[] orderDy = orderArr[i].split("/");

				requestBox.put("commoncodeseq", orderDy[0]);
				requestBox.put("codeorder", orderDy[1]);

				systemCodeService.systemCodeDetailOrder(requestBox);
			}

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