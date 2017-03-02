package amway.com.academy.manager.reservation.facilityInfo.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.crypto.Data;

import amway.com.academy.manager.common.util.SessionUtil;

import framework.com.cmm.util.StringUtil;
import org.apache.commons.lang.ObjectUtils;
import org.apache.ibatis.session.SqlSessionException;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.reservation.baseRule.service.BaseRuleService;
import amway.com.academy.manager.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.manager.reservation.facilityInfo.service.FacilityInfoService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

@Controller
@RequestMapping("/manager/reservation/facilityInfo")
public class FacilityInfoController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(FacilityInfoController.class);

	@Autowired
	FacilityInfoService facilityInfoService;

	@Autowired
	BasicReservationService basicReservationService;

	@Autowired
	public BaseRuleService baseRuleService;

	/**
	 * 시설정보 페이지호출
	 * @param  requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoList.do")
	public ModelAndView facilityInfoList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

    	/* 사용자의 담당 AP */
    	String allowApCode = (String) requestBox.getSession("sessionApno");
		
		/*----------------검색조건---------------*/
		model.addAttribute("ppCodeList", basicReservationService.ppCodeList(allowApCode));
		requestBox.put("rsvtypecode", "R01");
		model.addAttribute("rsvType", facilityInfoService.rsvType(requestBox));

		return mav;
	}

	/**
	 * 시설정보 엑셀다운
	 * @param  requestBox
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityinfoExcelDownload.do")
	public String facilityinfoExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		// 1. init
		Map<String, Object> head = new HashMap<String, Object>();

		String fileNm = "시설정보";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","PP","시설 명","시설 타입","파티션 룸","수용 인원","운영시작","운영종료","상태","최종수정일시","최종수정자"};
		String[] headId = {"NO","PPNAME","ROOMNAME","TYPENAME","SAMEROOMSEQ","SEATCOUNT","STARTDATE","ENDDATE","STATUSCODE","UPDATEDATE","UPDATEUSER"};
		head.put("headName", headName);
		head.put("headId", headId);

		// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";

		// 3. excel 양식 구성
		List<Map<String, String> > dataList = facilityInfoService.facilityinfoExcelDownload(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);

		return "excelDownload";
	}


	/**
	 *   시설정보 리스트( AJAX)
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfListAjax.do")
	public ModelAndView targetCodeListAjax(ModelMap model,RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",facilityInfoService.facilityInfoList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 *   시설정보 디테일 One
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailOne.do")
	public ModelAndView facilityInfoDetailOne(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		model.addAttribute("listseq", requestBox);
		model.addAttribute("ppCodeList", basicReservationService.ppCodeList());

		requestBox.put("codemasterseq", "YN3");
		model.addAttribute("codeCombo", facilityInfoService.codeCombo(requestBox));

		requestBox.put("rsvtypecode", "R01");
		model.addAttribute("rsvType", facilityInfoService.rsvType(requestBox));
		
		if(requestBox.get("roomMode").equals("I")){
			requestBox.put("roomseq", "");
		} else {
			requestBox.put("facilityseq", requestBox.get("roomseq"));
			model.addAttribute("updateType", facilityInfoService.updateType(requestBox));
		}
		
		DataBox detailpage = facilityInfoService.facilityInfoDetailOne(requestBox);
		model.addAttribute("detailpage", detailpage);


		model.addAttribute("ptype",facilityInfoService.ptype(requestBox));

		List<DataBox> detailfile = facilityInfoService.facilityInfoDetailOneFile(requestBox);
		model.addAttribute("detailfile",detailfile);

		return mav;
	}

	/**
	 *   시설코드 디테일 One 저장
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailOneSave.do")
	public ModelAndView facilityInfoDetailOneSave(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보

			facilityInfoService.facilityInfoDetailOneInsert(requestBox);
			rtnMap.put("listseq",facilityInfoService.facilityInfoDetailOneSeq(requestBox));
			requestBox.put("roomseq", rtnMap.get("listseq"));
			facilityInfoService.facilityInfoDetailOneInsertTypeSeq(requestBox);
			DataBox typesearch = facilityInfoService.typesearch(requestBox); //요리명장
			rtnMap.put("typesearch",typesearch);

			facilityInfoService.facilityInfoSearchRsvInsert(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설코드 디테일 One 수정
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailOneUpdate.do")
	public ModelAndView facilityInfoDetailOneUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			facilityInfoService.facilityInfoDetailOneUpdate(requestBox);
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Two
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailTwo.do")
	public ModelAndView facilityInfoDetailTwo(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		model.addAttribute("cookType",facilityInfoService.cookType(requestBox)); //요리명장여부 체크
		model.addAttribute("facilityType",facilityInfoService.facilityType(requestBox)); // 시설타입 체크
		model.addAttribute("listseq", requestBox);
		return mav;
	}

	/**
	 *   시설정보 파티션룸 디테일 Two
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoPartitionDetailTwo.do")
	public ModelAndView facilityInfoPartitionDetailTwo(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		model.addAttribute("cookType",facilityInfoService.cookType(requestBox)); //요리명장여부 체크
		model.addAttribute("facilityType",facilityInfoService.facilityType(requestBox)); // 시설타입 체크
		model.addAttribute("listseq", requestBox);
		return mav;
	}

	/**
	 * 시설정보 파티션룸 여부 체크(세션수,세션요일,PP체크)함.
	 * @param  requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilitySessionPartitionCheck.do")
	public ModelAndView facilitySessionPartitionCheck(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		String sameCheck = facilityInfoService.facilitySessionPartitionCheck(requestBox);

		if(("Y").equals(sameCheck)) {
			rtnMap.put("err","1");
		}else{
			rtnMap.put("err","0");
			rtnMap.put("msg","파티션룸 기본 룸들의 요일별 세션이 동일하지 않습니다.\n확인 후 파티션룸을 설정 해 주세요.");
		}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 * 시설정보 파티션룸 여부 체크(세션수,세션요일,PP체크)함.
	 * @param  requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityPartyCheck.do")
	public ModelAndView facilityPartyCheck(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		String sameCheck = facilityInfoService.facilityPartyCheck(requestBox);

		String typeCheck = facilityInfoService.facilityPartyTypeCheck(requestBox);

		if(("Y").equals(sameCheck) && ("Y").equals(typeCheck)) {
			rtnMap.put("err","1");
		} else if(("N").equals(sameCheck) && ("Y").equals(typeCheck)) {
			rtnMap.put("err","0");
			rtnMap.put("msg","파티션룸 기본 룸들과 요일별 세션이 동일하지 않습니다.\n확인 후 파티션룸을 설정 해 주세요.");
		} else if(("Y").equals(sameCheck) && ("N").equals(typeCheck)) {
			rtnMap.put("err","0");
			rtnMap.put("msg","파티션룸 기본 룸들과 우선운영일/휴무일이 동일하지 않습니다.\n확인 후 파티션룸을 설정 해 주세요.");
		} else {
			rtnMap.put("err","0");
			rtnMap.put("msg","파티션룸 기본 룸들과 요일별 세션, 우선운영일/휴무일이 동일하지 않습니다.\n확인 후 파티션룸을 설정 해 주세요.");
		}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 *   시설정보 디테일 Two 요일저장 : 요일
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoInsert.do")
	public ModelAndView facilityInfoInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			String[] sesArr = requestBox.get("weekRow").split(",");
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보

			String hiddenseq = "";
			int jay = 1;
			int sesArrLen = sesArr.length;
			if(sesArr[0].equals("")) {
				sesArrLen = 0;
			}
			for (int i = 0; i < sesArrLen; i++) {
				String[] sesDy = sesArr[i].split("/");

				if (!sesDy[0].equals("")) {
					if (jay == 1) {
						hiddenseq = sesDy[0];
						jay = jay + 1;
					} else {
						hiddenseq = hiddenseq + "," + sesDy[0];
					}
				}
			}
			requestBox.put("hiddenseq",hiddenseq);

			facilityInfoService.facilityInfoDelete(requestBox);

			for(int i=0; i<sesArrLen; i++) {
				int sNo = i+1;
				String[] sesDy = sesArr[i].split("/");

				requestBox.put("sessionname", "세션"+sNo);
				requestBox.put("rsvsessionseq", sesDy[0]);
				requestBox.put("startdatetime", sesDy[1]);
				requestBox.put("enddatetime", sesDy[2]);
				requestBox.put("price", sesDy[3]);
				requestBox.put("discountprice", sesDy[4]);
				requestBox.put("queenprice", sesDy[5]);
				requestBox.put("queendiscountprice", sesDy[6]);

				if(!sesDy[0].equals("")) {
					facilityInfoService.facilityInfoUpdate(requestBox);
				} else {
					facilityInfoService.facilityInfoInsert(requestBox);
					String roomseq = requestBox.get("roomseq");
					requestBox.put("roomseq",roomseq);
					int allSessionCount = facilityInfoService.allSessionTypeSearch(requestBox); //모든세션인 경우.

					if(allSessionCount>0){
						requestBox.put("rsvsessionseq", requestBox.get("rsvsessionseq"));
						facilityInfoService.facilityinfoInsertRoomrole(requestBox);
					}

				}
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Two 요일저장 : 전체
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoInsertAll.do")
	public ModelAndView facilityInfoInsertAll(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보

			String roomseq =  requestBox.get("roomseq");
			String[] sesArr = requestBox.get("weekRow").split(",");

			if(sesArr[0].equals("")){
				facilityInfoService.facilityInfoDeleteAll(requestBox);
			}else{
				facilityInfoService.facilityInfoDeleteAll(requestBox);

				for (int j = 0; j < 8; j++) {
					int aNo = j + 1;
					for (int i = 0; i < sesArr.length; i++) {
						int allSessionCount = facilityInfoService.allSessionTypeSearch(requestBox); //모든세션인 경우.
						int sNo = i + 1;
						String[] sesDy = sesArr[i].split("/");

						requestBox.put("sessionname", "세션" + sNo);
						requestBox.put("setweek", "W0" + aNo);
						requestBox.put("startdatetime", sesDy[1]);
						requestBox.put("enddatetime", sesDy[2]);
						requestBox.put("price", sesDy[3]);
						requestBox.put("discountprice", sesDy[4]);
						requestBox.put("queenprice", sesDy[5]);
						requestBox.put("queendiscountprice", sesDy[6]);

						facilityInfoService.facilityInfoInsert(requestBox);
						//수정인경우 예약자격/기간 테이블에 roomseq 추가하기.
						//1.수정인경우 체크(I- Insert / U - Update)
						//2.Rsvroomrole 테이블에 applySessionTypeCode == "P01"인 경우 roomseq로 조회시 있는경우.
						//3.rsvsessionseq 가져와서 Insert Select
						if (requestBox.get("roomMode").equals("U")) {
							requestBox.put("roomseq", roomseq);
							if (allSessionCount > 0) {
								requestBox.put("rsvsessionseq", requestBox.get("rsvsessionseq"));
								facilityInfoService.facilityinfoInsertRoomrole(requestBox);
							}
						}
					}
				}
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Two 날짜/세션정보
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoSelectWeek.do")
	public ModelAndView facilityInfoSelectWeek(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//요일별 리스트
		List<DataBox> dataList = facilityInfoService.facilityInfoSelectWeek(requestBox);
		rtnMap.put("listWeek",  dataList);

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 *   시설정보 디테일 Two 우선운영요일/휴무지정 일정추가 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailTwoPop.do")
	public ModelAndView facilityInfoDetailTwoPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		model.addAttribute("cookType",facilityInfoService.cookType(requestBox));
		model.addAttribute("checkList",facilityInfoService.checkList(requestBox));
		model.addAttribute("rsvCheckList",facilityInfoService.rsvCheckList(requestBox));
		model.addAttribute("listseq", requestBox);
		return mav;
	}

	/**
	 *   시설정보 디테일 Two 우선운영요일/휴무지정 일정추가 팝업 : 운영일 저장
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoInsertEarly.do")
	public ModelAndView facilityInfoInsertEarly(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try {
			String mode = requestBox.get("worktypecode");
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보

			String roomseq =  requestBox.get("roomseq");

			facilityInfoService.facilityInfoEarlyDel(requestBox);

			if(mode.equals("S01")) {
				String[] sesArr = requestBox.get("weekRow").split(",");
				for (int i = 0; i < sesArr.length; i++) {
					int sNo = i + 1;
					String[] sesDy = sesArr[i].split("/");

					requestBox.put("sessionname", "세션" + sNo);
					requestBox.put("startdatetime", sesDy[0]);
					requestBox.put("enddatetime", sesDy[1]);
					requestBox.put("price", sesDy[2]);
					requestBox.put("discountprice", sesDy[3]);
					requestBox.put("queenprice", sesDy[4]);
					requestBox.put("queendiscountprice", sesDy[5]);

					facilityInfoService.facilityInfoInsertEarly(requestBox);
					//수정인경우 예약자격/기간 테이블에 roomseq 추가하기.
					//1.수정인경우 체크(I- Insert / U - Update)
					//2.Rsvroomrole 테이블에 applySessionTypeCode == "P01"인 경우 roomseq로 조회시 있는경우.
					//3.rsvsessionseq 가져와서 Insert Select
					if(requestBox.get("roomMode").equals("U")){
						requestBox.put("roomseq",roomseq);
						int allSessionCount = facilityInfoService.allSessionTypeSearch(requestBox);
						if(allSessionCount > 0){
							requestBox.put("rsvsessionseq",requestBox.get("rsvsessionseq"));
							facilityInfoService.facilityinfoInsertRoomrole(requestBox);
						}
					}
				}

			} else {
				facilityInfoService.facilityInfoInsertEarly(requestBox);
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Two 우선운영요일/휴무지정 일정추가 : 삭제
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoEarlyDel.do")
	public ModelAndView programInfoEarlyDel(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			facilityInfoService.facilityInfoEarlyDel(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Two 상세보기 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailSessionPop.do")
	public ModelAndView facilityInfoDetailSessionPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		model.addAttribute("listseq", facilityInfoService.facilityInfoDetailSessionPop(requestBox));
		model.addAttribute("checkType",requestBox);
		return mav;
	}


	/**
	 *   시설정보 디테일 Two 우선운영요일/휴무지정 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailTwoListAjax.do")
	public ModelAndView facilityInfoDetailTwoListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailTwoList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 *   시설정보 디테일 Two 팝업 미리보기
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailTwoPreview.do")
	public ModelAndView facilityInfoDetailTwoPreview(ModelMap model,RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailTwoPreview(requestBox));
		model.addAttribute("listpop", requestBox);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}


	/**
	 *   시설정보 디테일 Three
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThree.do")
	public ModelAndView facilityInfoDetailThree(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		model.addAttribute("cookType",facilityInfoService.cookType(requestBox));
		model.addAttribute("ptype",facilityInfoService.ptype(requestBox));
		model.addAttribute("listseq", requestBox);
		return mav;
	}

	/**
	 *   시설정보 디테일 Three 예약자격/기간 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeTermPop.do")
	public ModelAndView facilityInfoDetailThreeTermPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		List<DataBox> pinInfo = facilityInfoService.facilityInfoDetailThreePinInfo(requestBox);
		model.addAttribute("pininfo",pinInfo);

		List<DataBox> ageInfo = facilityInfoService.facilityInfoDetailThreeAgeInfo(requestBox);
		model.addAttribute("ageinfo",ageInfo);

		List<DataBox> areaInfo = facilityInfoService.facilityInfoDetailThreeAreaInfo(requestBox);
		model.addAttribute("areainfo",areaInfo);

		List<DataBox> specialInfo = facilityInfoService.facilityInfoDetailThreeSpecialInfo(requestBox);
		List<DataBox> cookInfo = facilityInfoService.facilityInfoDetailThreeSpecialCookInfo(requestBox);
		model.addAttribute("layerMode", requestBox);

		String mode = requestBox.get("cookType");  //요리명장인경우:Y  아니면:N
		if(mode.equals("Y")){
			model.addAttribute("specialinfo",cookInfo);
		}else{
			model.addAttribute("specialinfo",specialInfo);
		}

		requestBox.put("codemasterseq", "WK1");
		model.addAttribute("weekinfo", facilityInfoService.codeCombo(requestBox));



		return mav;
	}

	/**
	 *   시설정보 디테일 Three 적용 세션 세션 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeSessionAjax.do")
	public ModelAndView facilityInfoDetailThreeSessionAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailThreeSession(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 *   시설정보 디테일 Three 예약자격/기간 팝업 등록
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeTermInsert.do")
	public ModelAndView facilityInfoDetailThreeTermInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			String[] sesArr = requestBox.get("weekRow").split(",");
			for (int i = 0; i < sesArr.length; i++) {
				requestBox.put("rsvsessionseq", sesArr[i]);

				facilityInfoService.facilityInfoDetailThreeTermInsert(requestBox);
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 예약자격/기간 팝업 - 모든세션가져오기
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoAllSession.do")
	public ModelAndView facilityInfoAllSession(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

			Map<String, Object> rtnMap = new HashMap<String, Object>();
			//리스트
			rtnMap.put("dataList",facilityInfoService.facilityInfoAllSession(requestBox));

			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 *   시설정보 디테일 Three - 모든세션저장
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoAllSessionInsert.do")
	public ModelAndView facilityInfoAllSessionInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
   		    facilityInfoService.facilityInfoAllSessionInsert(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 예약 자격/기간 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeTermListAjax.do")
	public ModelAndView facilityInfoDetailThreeTermListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailThreeTermList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 * 시설정보 디테일 Three 예약자격/기간 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/termListDelete.do")
	public ModelAndView termListDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			facilityInfoService.termListDelete(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 누적예약제한 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeDisPop.do")
	public ModelAndView facilityInfoDetailThreeDisPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		model.addAttribute("listseq", requestBox);
		return mav;
	}

	/**
	 * 시설정보 디테일 Three 누적 예약 제한 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeDisListAjax.do")
	public ModelAndView facilityInfoDetailThreeDisListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailThreeDisList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 * 시설정보 디테일 Three 누적 예약 제한 팝업 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeDisPopListAjax.do")
	public ModelAndView facilityInfoDetailThreeLimitPopListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailThreeDisPopList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 *   시설정보 디테일 Three 누적 예약 제한 팝업 저장 - 누적예약제한 리스트가 등록되어있는경우 - 삭제하지 않고 등록만 한다.
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeDisExistInsert.do")
	public ModelAndView facilityInfoDetailThreeDisExistInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			String[] typeArr = requestBox.get("settingseq").split(",");

			for(int i=0;i<typeArr.length;i++){
				String[] typeDy = typeArr[i].split("/");

				requestBox.put("settingseq", typeDy[0]);
				facilityInfoService.facilityInfoDetailThreeDisInsert(requestBox);
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 누적 예약 제한 팝업 저장 - 누적예약제한 리스트가 없는경우 - 삭제하고 등록한다.
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeDisInsert.do")
	public ModelAndView facilityInfoDetailThreeDisInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			String[] typeArr = requestBox.get("settingseq").split(",");
			// 일괄 삭제
			facilityInfoService.facilityInfoDetailThreeDisDelete(requestBox);

			for(int i=0;i<typeArr.length;i++){
                String[] typeDy = typeArr[i].split("/");

    			requestBox.put("settingseq", typeDy[0]);
				facilityInfoService.facilityInfoDetailThreeDisInsert(requestBox);
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 * 시설정보 디테일 Three 누적예약 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/disListDelete.do")
	public ModelAndView disListDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			facilityInfoService.disListDelete(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 취소/패널티 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCancelPop.do")
	public ModelAndView facilityInfoDetailThreeCancelPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		model.addAttribute("listseq", requestBox);
		model.addAttribute("sessionseq", requestBox);
		model.addAttribute("layerMode", requestBox);
		return mav;
	}

	/**
	 * 시설정보 디테일 Three 취소패널티 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCancelListAjax.do")
	public ModelAndView facilityInfoDetailThreeCancelListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList", facilityInfoService.facilityInfoDetailThreeCancelList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 * 시설정보 디테일 Three 취소패널티 팝업 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCancelPopListAjax.do")
	public ModelAndView facilityInfoDetailThreeCancelPopListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList", facilityInfoService.facilityInfoDetailThreeCancelPopList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 * 시설정보 디테일 Three 취소패널티 팝업 리스트 - 요리
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCookCancelPopListAjax.do")
	public ModelAndView facilityInfoDetailThreeCookCancelPopListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList", facilityInfoService.facilityInfoDetailThreeCookCancelPopList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 *   시설정보 디테일 Three 취소패널티 팝업 저장
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCancelInsert.do")
	public ModelAndView facilityInfoDetailThreeCancelInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			String[] typeArr = requestBox.get("penaltyseq").split(",");

			for(int i=0;i<typeArr.length;i++){
				String[] typeDy = typeArr[i].split("/");

				requestBox.put("penaltyseq", typeDy[0]);
				facilityInfoService.facilityInfoDetailThreeCancelInsert(requestBox);
			}

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 * 시설정보 디테일 Three 취소패널티 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cancelListDelete.do")
	public ModelAndView cancelListDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			facilityInfoService.cancelListDelete(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 디테일 Three 예약 자격/기간 리스트 - 요리명장
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailThreeCookTermListAjax.do")
	public ModelAndView facilityInfoDetailThreeCookTermListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailThreeCookTermList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}


	/**
	* 시설정보 파티션룸 여부 체크(세션수,세션요일,PP체크)함.
	* @param  requestBox
	* @param  mav
	* @return ModelAndView
	* @throws Exception
	*/
	@RequestMapping(value = "/facilityInfoPartitionCheck.do")
	public ModelAndView facilityInfoPartitionCheck(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

        String roomseq[] = requestBox.get("roomseq").split(",");
		String roomseq1 = roomseq[0];
		String roomseq2 = roomseq[1];

		requestBox.put("roomseq1",roomseq1);
		requestBox.put("roomseq2",roomseq2);
		String sameCheck = facilityInfoService.facilityInfoSameCheck(requestBox);

		if(("Y").equals(sameCheck)) {
			String rtnSession = facilityInfoService.facilityInfoPartitionCheck(requestBox); //세션 요일별 체크(카운트)
			String rtnType = facilityInfoService.facilityInfoRtnType(requestBox); //type 체크
			String rtnSessionType = facilityInfoService.facilitySessionTypeCheck(requestBox); // 우성운영일 휴무일 체크

			if(("Y").equals(rtnSession) && ("Y").equals(rtnType) && ("Y").equals(rtnSessionType)){
				rtnMap.put("err","1");
			}else{
				if(("N").equals(rtnSession) && ("Y").equals(rtnType) && ("Y").equals(rtnSessionType)) {
					rtnMap.put("err","0");
					rtnMap.put("msg","요일별 세션정보가 다릅니다.\n확인 후 파티션룸을 설정 해 주세요.");
				}else if(("N").equals(rtnType) && ("Y").equals(rtnSession) && ("Y").equals(rtnSessionType)){
					rtnMap.put("err","0");
					rtnMap.put("msg","시설타입이 교육장, 퀸룸/파티룸만 가능합니다.\n확인 후 파티션룸을 설정 해주세요.");
				}else if(("Y").equals(rtnType) && ("Y").equals(rtnSession) && ("N").equals(rtnSessionType)){
					rtnMap.put("err","0");
					rtnMap.put("msg","우선운영일/휴무일의 세션정보가 다릅니다.\n확인 후 파티션룸을 설정 해주세요.");
				}else if(("N").equals(rtnType) && ("N").equals(rtnSession)){
					rtnMap.put("msg","요일별 세션정보가 다르고, 시설타입이 교육장, 퀸룸/파티룸이 아닙니다.\n 확인후 파티션룸을 설정 해주세요");
				}
			}
		}else{
			rtnMap.put("err","0");
			rtnMap.put("msg","이미등록 된 파티션룸이 존재합니다.\n확인 후 파티션룸을 설정 해 주세요.");
		}
/*
		String rolecomparison = facilityInfoService.facilityInfoRoleComparison(requestBox); //예약자격조건 비교

		String discomparison = facilityInfoService.facilityInfoDisComparison(requestBox); //누적예약자격 비교

		String cancelcomparison = facilityInfoService.facilityInfoCancelComparison(requestBox); //취소패널티 비교

		if(("Y").equals(rolecomparison) && ("Y").equals(discomparison) && ("Y").equals(cancelcomparison)){
			rtnMap.put("err","1");
		}else{
			if(("N").equals(rolecomparison) && ("Y").equals(discomparison) && ("Y").equals(cancelcomparison)) {
				rtnMap.put("err","0");
				rtnMap.put("msg","예약자격/기간 조건이 다릅니다.\n확인 후 파티룸 설정 해 주세요.");
			}else if(("Y").equals(rolecomparison) && ("N").equals(discomparison) && ("Y").equals(cancelcomparison)) {
				rtnMap.put("err", "0");
				rtnMap.put("msg", "누적예약제한 조건이 다릅니다.\n확인 후 파티룸 설정 해 주세요.");
			}else if(("Y").equals(rolecomparison) && ("Y").equals(discomparison) && ("N").equals(cancelcomparison)) {
				rtnMap.put("err", "0");
				rtnMap.put("msg", "취소패널티 조건이 다릅니다.\n확인 후 파티룸 설정 해 주세요.");
			}else if(("Y").equals(rolecomparison) && ("N").equals(discomparison) && ("N").equals(cancelcomparison)) {
				rtnMap.put("err", "0");
				rtnMap.put("msg", "누적예약제한,취소패널티 조건이 다릅니다.\n확인 후 파티룸 설정 해 주세요.");
			}else if(("N").equals(rolecomparison) && ("Y").equals(discomparison) && ("N").equals(cancelcomparison)){
				rtnMap.put("err","0");
				rtnMap.put("msg","예약자격/기간,취소패널티 조건이 다릅니다.\n확인 후 파티룸 설정 해주세요.");
			}else if(("N").equals(rolecomparison) && ("N").equals(discomparison) && ("Y").equals(cancelcomparison)){
				rtnMap.put("err","0");
				rtnMap.put("msg","예약자격/기간,누적예약제한 조건이 다릅니다.\n확인 후 파티룸 설정 해주세요.");
			}else if(("N").equals(rolecomparison) && ("N").equals(discomparison) && ("N").equals(cancelcomparison)){
				rtnMap.put("msg","예약자격/기간,누적예약제한,취소패널티 조건이 모두 다릅니다..\n 확인후 파티룸 설정 해주세요");
			}
		}
*/

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 * 시설정보 파티션룸으로 설정
	 * @param  requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoPartitionDetail.do")
	public ModelAndView facilityInfoPartyList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();

		String roomseq[] = requestBox.get("roomseq").split(",");
		String roomseq1 = roomseq[0];
		String roomseq2 = roomseq[1];

		requestBox.put("roomseq1",roomseq1);
		requestBox.put("roomseq2",roomseq2);

		model.addAttribute("listseq",requestBox);

		try {
			DataBox detailpage = facilityInfoService.facilityInfoPartitionOne(requestBox); //roomseq1 으로 셋팅
			model.addAttribute("detailpage",detailpage);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ) {
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		return mav;
	}

	/**
	 * 시설정보 파티션룸으로 설정 저장
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoPartitionInsert.do")
	public ModelAndView facilityInfoPartitionInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			//1.RSVROOMINFO INSERT
			facilityInfoService.facilityInfoPartitionInsert(requestBox); // 파티션룸 insert 1.master insert  2.sameroom insert  and 다른테이블에서 정보가져오기 3.rsvroomsessioninfo insert 4.rsvroomrole insert
			                                                            // 5.rsvroomtypemap insert 6.rsvroompenaltymap insert
			//2.RSVROOMINFO 생성된 SEQ 찾아오기 (listseq.infoseq)
			rtnMap.put("listseq",facilityInfoService.facilityInfoDetailOneSeq(requestBox)); //seq 가져오기

			requestBox.put("infoseq", rtnMap.get("listseq"));          //테이블에 생성된 seq = infoseq
			requestBox.put("seqa",requestBox.get("roomseqa"));         // 리스트에서 선택된 seq = seqa, seqb
			requestBox.put("seqb",requestBox.get("roomseqb"));         // 리스트에서 선택된 seq = seqa, seqb

			requestBox.put("roomseq", rtnMap.get("listseq"));          //테이블에 생성된 seq = infoseq

			facilityInfoService.facilityInfoDetailOneInsertTypeSeq(requestBox);
			//RSVSAMEROOMINFO에 집어넣기
			facilityInfoService.facilityInfoSeqaInsert(requestBox); //seqa
			facilityInfoService.facilityInfoSeqbInsert(requestBox); //seqb
			facilityInfoService.facilityInfoSeqInsert(requestBox);//infoseq

			facilityInfoService.facilityInfoSearchRsvInsert(requestBox); //검색키워드 insert

			//3.기존에 체크박스로 선택한(ROOMSEQ1 , ROOMSEQ2)로
			// RSVROOMSESSIONINFO ,RSVROOMROLE , RSVROOMTYPEMAP , RSVROOMPENALTYMAP 테이블에 셀렉트 인서트
			/*
			facilityInfoService.facilityInfoSessionInsert(requestBox); //Session Insert

			facilityInfoService.facilityInfoRoomroleInsert(requestBox); //rsvroomrole Insert
			facilityInfoService.facilityInfotypemapInsert(requestBox);//roomtypemap Insert
			facilityInfoService.facilityInfopenaltymapInsert(requestBox);//penaltymap Insert
			*/

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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
	 *   시설정보 파티션룸 디테일 Two
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoPartitionTwo.do")
	public ModelAndView facilityInfoPartitionTwo(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		model.addAttribute("cookType",facilityInfoService.cookType(requestBox)); //요리명장여부 체크
		model.addAttribute("facilityType",facilityInfoService.facilityType(requestBox)); // 시설타입 체크
		model.addAttribute("listseq", requestBox);
		return mav;
	}
    
	/**
	 *   시설정보 디테일 상세 페이지
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPage.do")
	public ModelAndView facilityInfoDetailPage(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		List<Map<String, Object>> listArrMap = new ArrayList<Map<String,Object>>();

		DataBox detailpage = facilityInfoService.facilityInfoDetailOne(requestBox);
		List<DataBox> detailfile = facilityInfoService.facilityInfoDetailOneFile(requestBox);
		DataBox typecheck = facilityInfoService.facilityInfoCheckType(requestBox);

		for(int i=0; i<detailfile.size();i++) {
			DataBox rtnMap = detailfile.get(i);

			String uploadSeq = StringUtil.getEncryptStr(rtnMap.get("filefullurl").toString());
			rtnMap.put("filefullurl", uploadSeq);
			String uploadName = StringUtil.getEncryptStr(rtnMap.get("storefilename").toString());
			rtnMap.put("storefilename", uploadName);
			listArrMap.add(i, rtnMap);
		}

		model.addAttribute("checkCount",typecheck);
		model.addAttribute("detailfile",listArrMap);
		model.addAttribute("detailpage",detailpage);

		return mav;
	}

	/**
	 *   시설정보 디테일 상세 페이지 -  날짜 세션정보
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailDateAjax.do")
	public ModelAndView facilityInfoDetailDateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//리스트
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailDate(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	/**
 	 *   시설정보 디테일 상세 페이지 -  예약 자격/기간 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageResListAjax.do")
	public ModelAndView facilityInfoDetailPageResListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageResListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailPageResList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

   /**
	 * 시설정보 디테일 상세 페이지 - 누적 예약 제한 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageLimitListAjax.do")
	public ModelAndView facilityInfoDetailPageLimitListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageLimitListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailPageLimitList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

   /**
	 * 시설정보 디테일 상세 페이지 - 취소패널티 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageCancelListAjax.do")
	public ModelAndView facilityInfoDetailPageCancelListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{

		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageCancelListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.put("dataList", facilityInfoService.facilityInfoDetailPageCancelList(requestBox));
		rtnMap.putAll(pageVO.toMapData());

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

        
   /**
	 *   시설정보 디테일 상세 페이지  요리명장 - 예약 자격/기간 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageCookResListAjax.do")
	public ModelAndView facilityInfoDetailPageCookResListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageCookResListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailPageCookResList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

        
   /**
	 * 시설정보 디테일 상세 페이지 요리명장 - 누적 예약 제한 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageCookLimitListAjax.do")
	public ModelAndView facilityInfoDetailPageCookLimitListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{

		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageCookLimitListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",facilityInfoService.facilityInfoDetailPageCookLimitList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}  


   /**
	 * 시설정보 디테일 상세 페이지 요리명장 - 취소패널티 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoDetailPageCookCancelListAjax.do")
	public ModelAndView facilityInfoDetailPageCookCancelListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{

		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(facilityInfoService.facilityInfoDetailPageCookCancelListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.put("dataList", facilityInfoService.facilityInfoDetailPageCookCancelList(requestBox));
		rtnMap.putAll(pageVO.toMapData());

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);

		return mav;
	}

	/**
	 * 시설정보 디테일 페이지 - 예약자격정보 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/facilityInfoPartitionDetailDelete.do")
	public ModelAndView facilityInfoPartitionDetailDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		try {
			requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
			facilityInfoService.facilityInfoPartitionDetailDelete(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( SqlSessionException e ) {
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