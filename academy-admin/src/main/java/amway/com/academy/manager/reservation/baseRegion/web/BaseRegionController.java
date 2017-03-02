package amway.com.academy.manager.reservation.baseRegion.web;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.category.web.LmsCategoryController;
import amway.com.academy.manager.reservation.baseRegion.service.BaseRegionService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * 지역군 정보 Controller
 * @author KR620207
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/baseRegion")
public class BaseRegionController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicReservationController.class);
	
	@Autowired
	private BaseRegionService baseRegionService;

	/**
	 * 기본 목록 화면 (main-page)
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/regionList.do")
	public String reservationRegionList(ModelMap model) throws Exception {
		return "manager/reservation/baseRegion/regionList";
	}

	/**
	 * 상세보기화면 popup
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/detailPopup.do")
	public String reservationRegionDetailPopup(ModelMap model, RequestBox requestBox) throws Exception {
		String seqNumber = requestBox.get("seqNumber");
		model.addAttribute("seqNumber", seqNumber);
		return "manager/reservation/baseRegion/detailPopup";
	}
	
	/**
	 * 수정화면 popup
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePopup.do")
	public String reservationRegionUpdatePopup(ModelMap model, RequestBox requestBox) throws Exception {
		
		String cityGroupCode = requestBox.get("cityGroupCode");
		String cityGroupName = requestBox.get("cityGroupName");
		Map<String, String> cityGroupMap = baseRegionService.cityGroupDetail(requestBox);
		String statusCode = cityGroupMap.get("statuscode");

		model.addAttribute("frmId", requestBox.get("frmId"));
		model.addAttribute("regionCodeList", super.regionCodeList());
		model.addAttribute("cityGroupCode", cityGroupCode);
		model.addAttribute("cityGroupName", cityGroupName);
		model.addAttribute("statusCode", statusCode);
		
		return "manager/reservation/baseRegion/updatePopup";
	}

	/**
	 * 신규등록 popup
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertPopup.do")
	public String reservationRegionInsertPopup(ModelMap model, RequestBox requestBox) throws Exception {
		
		model.addAttribute("frmId", requestBox.get("frmId"));
		model.addAttribute("regionCodeList", super.regionCodeList());
		
		return "manager/reservation/baseRegion/insertPopup";
	}

	/**
	 * 행정구역으로 소속 도시의 목록을 얻어오는 기능
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/allCityCodeListAjax.do")
	public ModelAndView allCityCodeList(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		rtnMap.put("cityCodeList", baseRegionService.allCityCodeList(requestBox));
		
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 설정된 지역군 정보 목록을 받아오는 기능
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/regionListAjax.do")
	public ModelAndView reservationRegionListAjax(RequestBox requestBox, ModelMap model) throws Exception{
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseRegionService.reservationRegionListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList", baseRegionService.reservationRegionList(requestBox));
		
		mav.addObject("JSON_OBJECT", rtnMap);		
		
		return mav;
	}
	
	/**
	 * 지역군 내 선택된 행정구역 목록
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/regionDetailListAjax.do")
	public ModelAndView reservationRegionDetailListAjax(RequestBox requestBox, ModelMap model) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		rtnMap.put("ppCodeList", super.ppCodeList());	/* amway plaza list */
		rtnMap.put("regionCodeList", super.regionCodeList());	/* 전체 행정구역 목록 */
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseRegionService.cityGroupDetailListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("cityGroupDetailList", baseRegionService.cityGroupDetailList(requestBox));
		
		mav.addObject("JSON_OBJECT", rtnMap);		

		return mav;
	}
	
	/**
	 * 지역군 등록 action
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/regionDetailInsertAjax.do", method = RequestMethod.POST)
	public ModelAndView reservationRegionDetailInsert(RequestBox requestBox, ModelMap model) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			baseRegionService.cityGroupInsert(requestBox);
			rtnMap.put("resultMessage", "success");
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
			rtnMap.put("resultMessage", "fail");
		}
		
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 지역군 수정(편집) action
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/regionDetailUpdateAjax.do", method = RequestMethod.POST)
	public ModelAndView reservationRegionDetailUpdate(RequestBox requestBox, ModelMap model) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			baseRegionService.cityGroupUpdate(requestBox);
			rtnMap.put("resultMessage", "success");
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
			rtnMap.put("resultMessage", "fail");
		}

		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 지역군 삭제
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteRegionAjax.do", method = RequestMethod.POST)
	public ModelAndView deleteRegionAjax(RequestBox requestBox, ModelMap model) throws Exception {
		
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			baseRegionService.deleteRegion(requestBox);
			rtnMap.put("resultMessage", "success");
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
			rtnMap.put("resultMessage", "fail");
		}
		
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
}
