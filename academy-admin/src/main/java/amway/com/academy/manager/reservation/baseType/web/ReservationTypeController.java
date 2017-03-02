package amway.com.academy.manager.reservation.baseType.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSessionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.reservation.baseType.service.ReservationTypeService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * 예약 형태 정보& 예약 타입 정보
 * @author KR620225
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/baseType")
public class ReservationTypeController extends BasicReservationController {

	@Autowired
	public ReservationTypeService reservationTypeService;
	
	/**
	 * 예약 형태 조회 화면 이동 및 초기 설정
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeList.do")
	public String reservationTypeListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav) throws Exception {

		/** 검색 조건 조회*/
		model.addAttribute("typeClassifyList", super.typeClassifyCodeList());

		/** finally forwarding page **/
		return "manager/reservation/baseType/reservationTypeList";
	}

	/**
	 * 예약 형태 목록 조회 기능
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeListAjax.do")
	public ModelAndView reservationTypeListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		 reservationTypeService.reservationTypeListCountAjax(requestBox);

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(reservationTypeService.reservationTypeListCountAjax(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",reservationTypeService.reservationTypeListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 예약 형태 상세 보기 기능 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeDetailPop.do")
	public ModelAndView reservationTypeDetailAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		
		/**-------------------- 검색 조건 조회-------------------------*/
		//타입분류
		model.addAttribute("typeClassifyList", super.typeClassifyCodeList());
		//상태
		model.addAttribute("useStateCodeList", super.useStateCodeList());
		/**------------------------- --------------------------*/
		
		model.addAttribute("layPopData",requestBox);
		
		model.addAttribute("reservationTypeDetail", reservationTypeService.reservationTypeDetailAjax(requestBox));
		
		return mav;
	}
	
	/**
	 * 예약타입 정보 등록폼(레이어 팝업)
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeInsertPop.do")
	public ModelAndView reservationTypeInsertFormAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		/**-------------------- 검색 조건 조회-------------------------*/
		//타입분류
		model.addAttribute("typeClassifyList", super.typeClassifyCodeList());
		//상태
		model.addAttribute("useStateCodeList", super.useStateCodeList());
		/**------------------------- --------------------------*/
		
		model.addAttribute("layPopData",requestBox);
		
		return mav;
	}
	
	/**
	 * 예약 형태 등록 기능
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeInsertAjax.do")
	public ModelAndView reservationTypeInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			reservationTypeService.reservationTypeInsertAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
		
		
	
	/**
	 * 예약 형태 수정 기능
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reservationTypeUpdateAjax.do")
	public ModelAndView reservationTypeUpdateAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			reservationTypeService.reservationTypeUpdateAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
}
