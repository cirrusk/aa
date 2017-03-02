package amway.com.academy.manager.reservation.baseRule.web;

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

import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.reservation.baseRule.service.BaseRuleService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;

/**
 * 누적 예약 가능 횟수
 * @author KR620225
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/baseRule")
public class BaseRuleController extends BasicReservationController{
	
	@Autowired
	public BaseRuleService baseRuleService;
	
	/**
	 * 누적 예약 가능 횟수 페이지 호출 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleList.do")
	public String baseRuleListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav) throws Exception{
		
		/** 검색 조건 조회*/
		model.addAttribute("useStateCodeList", super.useStateCodeList());
		
		return "/manager/reservation/baseRule/baseRuleList";
	}
	
	
	/**
	 * 누적 예약 가능 횟수 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleListAjax.do")
	public ModelAndView baseRuleListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseRuleService.baseRuleListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",baseRuleService.baseRuleListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 누적 예약 가능 횟수 등록폼
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleInsertPop.do")
	public ModelAndView baseRuleInsertFormAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
	
		/**--------------------------검색 조건 조회-------------------------------------*/
		//지역 우대 여부
		model.addAttribute("cityGroupCodeList", super.cityGroupCodeList());
		//pin구간 추가 해야함
		model.addAttribute("pinCodeList", super.pinCodeList());
		//나이 우대
		model.addAttribute("ageCodeList", super.ageCodeList());
		
		//pp_List
		model.addAttribute("ppCodeList", super.ppCodeList());
		//룸타입 코드 리스트
		model.addAttribute("roomTypeCodeList", super.roomTypeCodeList());
		//제한기준 타입 코드 리스트
		model.addAttribute("constraintTypeCodeList", super.constraintTypeCodeList());
		
		// 특정 대상자 그룹 
		//model.addAttribute("roleGroupCodeList", super.roleGroupCodeList());
		model.addAttribute("roleGroupCodeList", super.roleGroupWithCookMasterCodeList());
		
		// 사용여부
		model.addAttribute("stateCodeList", super.stateCodeList());
		
		model.addAttribute("searchPpToRoomTypeList", baseRuleService.searchPpToRoomTypeList(requestBox));
		
		/**-----------------------------------------------------------------------*/
		
		return mav;
	}
	
	/**
	 * 누적 예약 가능 횟수
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleInsertAjax.do")
	public ModelAndView baseRuleInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseRuleService.baseRuleInsertAjax(requestBox);
			
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
	 * 누적 예약 타입 상세보기
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleDetailPop.do")
	public ModelAndView baseRuleDatailAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/**--------------------------검색 조건 조회-------------------------------------*/
		//지역 우대 여부
		model.addAttribute("cityGroupCodeList", super.cityGroupCodeList());
		//pin구간 추가 해야함
		model.addAttribute("pinCodeList", super.pinCodeList());
		//나이 우대
		model.addAttribute("ageCodeList", super.ageCodeList());
		
		//pp_List
		model.addAttribute("ppCodeList", super.ppCodeList());
		//룸타입 코드 리스트
		model.addAttribute("roomTypeCodeList", super.roomTypeCodeList());
		//제한기준 타입 코드 리스트
		model.addAttribute("constraintTypeCodeList", super.constraintTypeCodeList());
		
		// 특정 대상자 그룹 
		//model.addAttribute("roleGroupCodeList", super.roleGroupCodeList());
		model.addAttribute("roleGroupCodeList", super.roleGroupWithCookMasterCodeList());
		
		// 사용여부
		model.addAttribute("stateCodeList", super.stateCodeList());
		
		mav.addObject("settingSeq", requestBox.get("settingSeq"));
		
		model.addAttribute("searchPpToRoomTypeList", baseRuleService.searchPpToRoomTypeList(requestBox));
		
		/**-----------------------------------------------------------------------*/
		
		return mav;
	}
	
	@RequestMapping(value = "/baseRuleDetailInfoAjax.do")
	public ModelAndView baseRuleDetailInfoAjax(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//리스트
		rtnMap.put("baseRuleDetail",  baseRuleService.baseRuleDetailAjax(requestBox));
		rtnMap.put("roomTypeInfoCodeList", baseRuleService.searchPpToRoomTypeList(requestBox));
		
		mav.addObject("JSON_OBJECT", rtnMap);		
		
		
		return mav;
	}
	
	/**
	 * 누적 예약 타입 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleUpdateAjax.do")
	public ModelAndView baseRuleUpdateAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseRuleService.baseRuleUpdateAjax(requestBox);
			
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
	 * 룸타입 조회(셀렉트 박스에서 사용)
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchPpToRoomTypeListAjax.do")
	public ModelAndView searchPpToRoomTypeList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//리스트
		rtnMap.put("searchPpToRoomTypeList", baseRuleService.searchPpToRoomTypeList(requestBox));
		rtnMap.put("roomTypeCodeList", super.roomTypeCodeList());
		
		mav.addObject("JSON_OBJECT", rtnMap);		
		
		return mav;
	}
	
	/**
	 * 제한 기준 타입 코드가 C03일경우 
	 * 	누적 예약 횟수 제한설정 테이블 등록, 특정 교육장 맵핑 테이블등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ppToRoomTypeInsertAjax.do")
	public ModelAndView ppToRoomTypeInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseRuleService.ppToRoomTypeInsertAjax(requestBox);
			
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
	 * 제한 기준 타입 코드가 C03에서 C01 or C02로 변경시
	 * 	누적예약 횟수 제한 설정 테이블 수정, 특정 교육장 맵핑 테이블 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ppToRoomTypeUpdateAjax.do")
	public ModelAndView ppToRoomTypeUpdateAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseRuleService.ppToRoomTypeUpdateAjax(requestBox);
			
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
	 * 제한 기준 타입 코드가 C03으로 변경시
	 * 	누적 예약 횟수 제한 설정 테이블 수정, 특정 교육장 맵핑 테이블 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseRuleUpdateAndInsertAjax.do")
	public ModelAndView baseRuleUpdateAndInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseRuleService.baseRuleUpdateAndInsertAjax(requestBox);
			
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
