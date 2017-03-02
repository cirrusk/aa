package amway.com.academy.manager.common.targetCode.web;

import amway.com.academy.manager.common.targetCode.service.TargetCodeService;
import amway.com.academy.manager.common.util.PropertiesReader;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
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

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/manager/common/targetCode")
public class TargetCodeController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TargetCodeController.class);

	@Autowired
	TargetCodeService targetCodeService;

	/**
	 *  대상자코드 페이지호출
	 * @param  requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeList.do")
	public ModelAndView targetCodeList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

		model.addAttribute("listScope", targetCodeService.codeListScope(requestBox)); //코드분류 리스트

		return mav;
	}

	/**
	 *   대상자코드 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetCodeListAjax.do")
	public ModelAndView targetCodeListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(targetCodeService.targetCodeListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",targetCodeService.targetCodeList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 *   대상자코드 마스터 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetCodeListPop.do")
	public ModelAndView targetCodeListPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		DataBox targetDetail = targetCodeService.targetCodeListPop(requestBox);
		model.addAttribute("targetDetail", targetDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 * 대상자코드 마스터 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeInsert.do")
	public ModelAndView targetCodeInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = targetCodeService.targetCodeInsert(requestBox);

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
	 * 대상자코드 마스터 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeUpdate.do")
	public ModelAndView targetCodeUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = targetCodeService.targetCodeUpdate(requestBox);

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
	 * 대상자코드 마스터 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDelete.do")
	public ModelAndView targetCodeDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		int existyn = 0;
		try {

			//하위코드존재여부 체크
			existyn = targetCodeService.existyn(requestBox);
			if(existyn>0){
				resultMap.put("errCode", "2");
			}else{
				result = targetCodeService.targetCodeDelete(requestBox);

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
	 *  대상자코드상세 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetail.do")
	public ModelAndView targetCodeDetail(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

		model.addAttribute("targetDetail", targetCodeService.targetCodeDetail(requestBox));

		return mav;
	}

	/**
	 *  대상자코드상세 리스트(AJAX)
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetailListAjax.do")
	public ModelAndView targetCodeDetailListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//리스트
		rtnMap.put("dataList",targetCodeService.targetCodeDetailList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 *  대상자코드상세 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetailPop.do")
	public ModelAndView targetCodeDetailPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		DataBox detail = targetCodeService.targetCodeDetailPop(requestBox);

		model.addAttribute("detail", detail);
		model.addAttribute("layerMode", requestBox);
		return mav;
	}

	/**
	 * 대상자코드상세 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetailInsert.do")
	public ModelAndView targetCodeDetailInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));

		try {
			result = targetCodeService.targetCodeDetailInsert(requestBox);

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
	 * 대상자코드상세 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetailUpdate.do")
	public ModelAndView targetCodeDetailUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno ));
		try {
			result = targetCodeService.targetCodeDetailUpdate(requestBox);

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
	 * 대상자코드상세 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetCodeDetailDelete.do")
	public ModelAndView targetCodeDetailDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		try {
			result = targetCodeService.targetCodeDetailDelete(requestBox);

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
	@RequestMapping(value = "/targetCodeDetailOrder.do")
	public ModelAndView targetCodeDetailOrder(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		try {
			String[] orderArr = requestBox.get("neworder").split(",");

			for(int i=0; i<orderArr.length; i++) {
				String[] orderDy = orderArr[i].split("/");

				requestBox.put("targetcodeseq", orderDy[0]);
				requestBox.put("targetcodeorder", orderDy[1]);

				targetCodeService.targetCodeDetailOrder(requestBox);
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