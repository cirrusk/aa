package amway.com.academy.manager.reservation.programInfo.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.util.StringUtil;
import net.sf.json.spring.web.servlet.view.JsonView;

import org.apache.ibatis.session.SqlSessionException;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.file.service.FileUpLoadService;
import amway.com.academy.manager.reservation.baseRule.service.BaseRuleService;
import amway.com.academy.manager.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.manager.reservation.programInfo.service.ProgramInfoService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

@Controller
@RequestMapping("/manager/reservation/programInfo")
public class ProgramInfoController {
    /** log */
    @SuppressWarnings("unused")
    private static final Logger LOGGER = LoggerFactory.getLogger(ProgramInfoController.class);

    @Autowired
    ProgramInfoService programInfoService;

    @Autowired
    BasicReservationService basicReservationService;

    @Autowired
    public BaseRuleService baseRuleService;

    @Autowired
	FileUpLoadService fileUpLoadService;
    
    /**
     * 프로그램정보 페이지호출
     * @param  requestBox
     * @param  mav
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoList.do")
    public ModelAndView programInfoList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
    	
    	/* 사용자의 담당 AP */
    	String allowApCode = (String) requestBox.getSession("sessionApno");
    	
		/*----------------검색조건---------------*/
        model.addAttribute("ppCodeList", basicReservationService.ppCodeList(allowApCode));

        return mav;
    }

    /**
     * 프로그램정보 엑셀다운
     * @param  requestBox
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoExcelDownload.do")
    public String programInfoExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
        // 1. init
        Map<String, Object> head = new HashMap<String, Object>();

        String fileNm = "프로그램정보";
        // 엑셀 헤더명 정의
        String[] headName = {"No.","PP","타입","프로그램 명","수용인원","운영시작","운영종료","최종수정일시","최종수정자","상태"};
        String[] headId = {"NO","PPNAME","CATEGORYTYPE1","PRODUCTNAME","SEATCOUNT1","STARTDATE","ENDDATE","UPDATEDATE","UPDATEUSER","STATUSCODE"};
        head.put("headName", headName);
        head.put("headId", headId);

        // 2. 파일 이름
        String sFileName = fileNm + ".xlsx";

        // 3. excel 양식 구성
        List<Map<String, String> > dataList = programInfoService.programInfoExcelDownload(requestBox);
        XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
        model.addAttribute("type", "xlsx");
        model.addAttribute("fileName", sFileName);
        model.addAttribute("workbook", workbook);

        return "excelDownload";
    }


    /**
     *   프로그램정보 리스트( AJAX)
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoListAjax.do")
    public ModelAndView programInfoListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //페이징
        PageVO pageVO = new PageVO(requestBox);
        pageVO.setTotalCount(programInfoService.programInfoListCount(requestBox));

        requestBox.putAll(pageVO.toMapData());
        PagingUtil.defaultParmSetting(requestBox);

        //리스트
        rtnMap.putAll(pageVO.toMapData());
        rtnMap.put("dataList",programInfoService.programInfoList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }

    /**
     *   프로그램정보 측정프로그램 리스트
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailOne.do")
    public ModelAndView programInfoDetailOne(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        String mode = requestBox.get("listMode");
        model.addAttribute("ppCodeList", basicReservationService.ppCodeList()); //pplist
        model.addAttribute("layerMode", requestBox);
         if(mode.equals("CHECK")){
            model.addAttribute("typeCheck", programInfoService.programInfoCheck(requestBox));
        }
        return mav;
    }
    
    @RequestMapping(value = "/programInfoDetailOneInit.do")
    public ModelAndView programInfoDetailOneInit(ModelAndView mav, RequestBox requestBox)throws Exception{
    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
    	rtnMap.put("dataList",programInfoService.selectcategorytypelist(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        
    	return mav;
    }

    /**
     *  프로그램정보 측정프로그램 등록
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoOneInsert.do")
    public ModelAndView programInfoOneInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            int check = 0;
            if(requestBox.get("categorytype1").equals("E01") || requestBox.get("categorytype1").equals("E02")) {
                if(requestBox.get("statuscode").equals("B01")) {
                    check = programInfoService.programInsCheck(requestBox);
                }
            }
            if(check <= 0) {
                programInfoService.programInfoOneInsert(requestBox);
                int listtype = programInfoService.programInfoSeq(requestBox);
                rtnMap.put("listtype", listtype);
                requestBox.put("expseq", listtype);
                programInfoService.programInfoSearchRsvInsert(requestBox);
                resultMap.put("errCode", "0");
                resultMap.put("errMsg", "");
            } else {
                resultMap.put("errCode", "2");
                resultMap.put("errMsg", "");
            }
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
     *  프로그램정보 파일 등록
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/fileUpload.do")
    public ModelAndView fileUpload(ModelMap model,HttpServletRequest request,RequestBox requestBox,MultipartHttpServletRequest multiRequest)throws Exception{
    	ModelAndView mav = new ModelAndView(new JsonView());
		Map<String,Object> rtnMap = new HashMap<String,Object>();
        Map<String, Object> resultMap = new HashMap<String, Object>();
    	final Map<String, MultipartFile> files = multiRequest.getFileMap();
    	
    	try {
    		requestBox.put("work", "RESERVATION");
    		
    		if (!files.isEmpty()) {
                rtnMap = fileUpLoadService.getInsertFile(files, requestBox);
    		}

    	} catch ( SqlSessionException e ) {
    		e.printStackTrace();
    	}
        resultMap.put("fileKey",requestBox.get("fileKey"));
        mav.addObject("result", rtnMap);
        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", resultMap);
    	return mav;
    }
    
    /**
     *   프로그램정보 측정프로그램등록 리스트 - 2번쨰
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailTwo.do")
    public ModelAndView programInfoDetailTwo(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        model.addAttribute("listtype", requestBox);
        model.addAttribute("layerMode", requestBox);
        return mav;
    }

    /**
     *   프로그램정보 디테일 B 요일저장 : 요일
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoInsert.do")
    public ModelAndView programInfoInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String[] sesArr = requestBox.get("weekRow").split(",");

            String hiddenseq = "";
            int jay = 1;
            int sesArrLen = sesArr.length;
            if(sesArr[0].equals("")) {
                sesArrLen = 0;
            }

            for(int i=0; i<sesArrLen; i++) {
                String[] sesDy = sesArr[i].split("/");

                if(!sesDy[0].equals("")) {
                    if (jay == 1) {
                        hiddenseq = sesDy[0];
                        jay = jay + 1;
                    } else {
                        hiddenseq = hiddenseq + "," + sesDy[0];
                    }
                }
            }
            requestBox.put("hiddenseq",hiddenseq);

            programInfoService.programInfoDelete(requestBox);

            for(int i=0; i<sesArrLen; i++) {
                int sNo = i+1;
                String[] sesDy = sesArr[i].split("/");

                requestBox.put("sessionname", "세션"+sNo);
                requestBox.put("expsessionseq", sesDy[0]);
                requestBox.put("startdatetime", sesDy[1]);
                requestBox.put("enddatetime", sesDy[2]);

                if(!sesDy[0].equals("")) {
                    programInfoService.programInfoTwoUpdate(requestBox);
                } else {
                    programInfoService.programInfoInsert(requestBox);
                    String expseq = requestBox.get("expseq");
                    requestBox.put("expseq",expseq);
                    int allSessionCount = programInfoService.allSessionTypeSearch(requestBox); //모든세션인 경우.

                    if(allSessionCount>0){
                        requestBox.put("expsessionseq", requestBox.get("expsessionseq"));
                        programInfoService.programinfoInsertRoomrole(requestBox);
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
     *   프로그램정보 요일저장 : 전체
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoInsertAll.do")
    public ModelAndView programInfoInsertAll(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
        	requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String[] sesArr = requestBox.get("weekRow").split(",");
            if(sesArr[0].equals("")){
                programInfoService.programInfoDeleteAll(requestBox);
            }else{
                programInfoService.programInfoDeleteAll(requestBox);
                for(int j=0; j<8; j++) {
                    int aNo = j + 1;
                    for (int i = 0; i < sesArr.length; i++) {
                        int sNo = i + 1;
                        String[] sesDy = sesArr[i].split("/");

                        requestBox.put("sessionname", "세션" + sNo);
                        requestBox.put("setweek", "W0" + aNo);
                        requestBox.put("startdatetime", sesDy[1]);
                        requestBox.put("enddatetime", sesDy[2]);

                        programInfoService.programInfoInsert(requestBox);
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
     *   프로그램정보 디테일 B
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoSelectWeek.do")
    public ModelAndView facilityInfoSelectWeek(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //요일별 리스트
        List<DataBox> dataList = programInfoService.programInfoSelectWeek(requestBox);
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
    @RequestMapping(value = "/programInfoDetailTwoPop.do")
    public ModelAndView programInfoDetailTwoPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        model.addAttribute("checkList",programInfoService.checkList(requestBox));
        model.addAttribute("rsvCheckList",programInfoService.rsvCheckList(requestBox));
        model.addAttribute("listtype", requestBox);
        return mav;
    }

    /**
     *   시설정보 디테일 Two 우선운영요일/휴무지정 일정추가 팝업 : 운영일 저장
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoInsertEarly.do")
    public ModelAndView programInfoInsertEarly(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String mode = requestBox.get("worktypecode");
            String expseq = requestBox.get("expseq");

            programInfoService.programInfoEarlyDel(requestBox);

            if(mode.equals("S01")) {
                String[] sesArr = requestBox.get("weekRow").split(",");
                for (int i = 0; i < sesArr.length; i++) {
                    int sNo = i + 1;
                    String[] sesDy = sesArr[i].split("/");

                    requestBox.put("sessionname", "세션" + sNo);
                    requestBox.put("startdatetime", sesDy[0]);
                    requestBox.put("enddatetime", sesDy[1]);

                    programInfoService.programInfoInsertEarly(requestBox);
                    //수정인경우 예약자격테이블에 모든세션이 있으면 같이 insert
                    if(requestBox.get("listMode").equals("U")){
                        requestBox.put("expseq",expseq);
                        int allSessionCount = programInfoService.allSessionTypeSearch(requestBox);
                        if(allSessionCount>0){
                            requestBox.put("expsessionseq",requestBox.get("expsessionseq"));
                            programInfoService.programinfoInsertRoomrole(requestBox);
                        }
                    }
                }
            } else {
                programInfoService.programInfoInsertEarly(requestBox);
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
     *   시설정보 디테일 Two 상세보기 팝업
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailSessionPop.do")
    public ModelAndView programInfoDetailSessionPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        model.addAttribute("listtype", programInfoService.programInfoDetailSessionPop(requestBox));
        model.addAttribute("type",programInfoService.programInfoDetailTwoPreview(requestBox));
        model.addAttribute("weektype",requestBox);
        return mav;
    }

    /**
     *   시설정보 디테일 Two 팝업 미리보기
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailTwoPreview.do")
    public ModelAndView programInfoDetailTwoPreview(ModelMap model,RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailTwoPreview(requestBox));
        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);

        return mav;
    }


    /**
     *   시설정보 디테일 Two 우선운영요일/휴무지정 일정추가 팝업 : 삭제
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoEarlyDel.do")
    public ModelAndView programInfoEarlyDel(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
        	requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
        	
            programInfoService.programInfoEarlyDel(requestBox);

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
     *   프로그램정보 디테일 Two 우선운영요일/휴무지정 리스트
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailTwoListAjax.do")
    public ModelAndView programInfoDetailTwoListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailTwoList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }

    /**
     *   프로그램정보 측정프로그램등록 리스트 - 3번째
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailThree.do")
    public ModelAndView programInfoDetailThree(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        model.addAttribute("listtype", requestBox);
        return mav;
    }

    /**
     *   프로그램정보 디테일 C 예약자격/기간 팝업
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailThreeTermPop.do")
    public ModelAndView programInfoDetailThreeTermPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

        List<DataBox> pinInfo = programInfoService.programInfoDetailPinInfo(requestBox);
        model.addAttribute("pininfo",pinInfo);

        List<DataBox> ageInfo = programInfoService.programInfoDetailAgeInfo(requestBox);
        model.addAttribute("ageinfo",ageInfo);

        List<DataBox> areaInfo = programInfoService.programInfoDetailAreaInfo(requestBox);
        model.addAttribute("areainfo",areaInfo);

        List<DataBox> specialInfo = programInfoService.programInfoDetailSpecialInfo(requestBox);
        model.addAttribute("specialinfo",specialInfo);

        requestBox.put("codemasterseq", "WK1");
        model.addAttribute("weekinfo", programInfoService.codeCombo(requestBox));

        model.addAttribute("listtype", requestBox);

        return mav;
    }

    /**
     *   시설정보 디테일 Three 누적예약제한 팝업
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailThreeDisPop.do")
    public ModelAndView programInfoDetailThreeDisPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        model.addAttribute("listtype", requestBox);

        return mav;
    }

    /**
     *   프로그램정보 디테일 Three 취소/패널티 팝업
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailThreeCancelPop.do")
    public ModelAndView programInfoDetailThreeCancelPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        model.addAttribute("listtype", requestBox);
        return mav;
    }

    /**
     *   프로그램정보 디테일 Three 적용 세션 세션 리스트
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailSessionAjax.do")
    public ModelAndView programInfoDetailSessionAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailSession(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }

    /**
     *   프로그램정보 디테일 Three 예약자격/기간 팝업 등록
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailTermInsert.do")
    public ModelAndView programInfoDetailTermInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String[] sesArr = requestBox.get("weekRow").split(",");
            for (int i = 0; i < sesArr.length; i++) {
                requestBox.put("expsessionseq", sesArr[i]);

                programInfoService.programInfoDetailTermInsert(requestBox);
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
     *   프로그램정보 디테일 Three - 모든세션저장
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoAllSessionInsert.do")
    public ModelAndView programInfoAllSessionInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            programInfoService.programInfoAllSessionInsert(requestBox);
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
     *   프로그램정보 디테일 Three 예약 자격/기간 리스트
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailTermListAjax.do")
    public ModelAndView programInfoDetailTermListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailTermList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }


    /**
     * 프로그램정보 디테일 Three 예약자격/기간 삭제
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
        	requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            programInfoService.termListDelete(requestBox);

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
     * 프로그램정보 디테일 Three 누적 예약 제한 팝업 리스트
     * @param model
     * @param request
     * @param mav
     * @param requestBox
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailDisPopListAjax.do")
    public ModelAndView programInfoDetailDisPopListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailDisPopList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);

        return mav;
    }

    /**
     *   프로그램정보 디테일 Three 누적 예약 제한 팝업 저장
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailDisInsert.do")
    public ModelAndView programInfoDetailDisInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
        	requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String[] typeArr = requestBox.get("settingseq").split(",");

            for(int i=0;i<typeArr.length;i++){
                String[] typeDy = typeArr[i].split("/");

                requestBox.put("settingseq", typeDy[0]);
                programInfoService.programInfoDetailDisInsert(requestBox);
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
     * 프로그램정보 디테일 Three 누적 예약 제한 리스트
     * @param model
     * @param request
     * @param mav
     * @param requestBox
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailDisListAjax.do")
    public ModelAndView programInfoDetailDisListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList",programInfoService.programInfoDetailDisList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);

        return mav;
    }

    /**
     * 프로그램정보 디테일 Three 누적예약 삭제
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
            programInfoService.disListDelete(requestBox);

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
     * 프로그램정보 디테일 Three 취소패널티 팝업 리스트
     * @param model
     * @param request
     * @param mav
     * @param requestBox
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailThreeCancelPopListAjax.do")
    public ModelAndView programInfoDetailThreeCancelPopListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList", programInfoService.programInfoDetailThreeCancelPopList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);

        return mav;
    }

    /**
     *   프로그램정보 디테일 Three 취소패널티 팝업 저장
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailCancelInsert.do")
    public ModelAndView programInfoDetailCancelInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
        	requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            String[] typeArr = requestBox.get("penaltyseq").split(",");

            for(int i=0;i<typeArr.length;i++){
                String[] typeDy = typeArr[i].split("/");

                requestBox.put("penaltyseq", typeDy[0]);
                programInfoService.programInfoDetailCancelInsert(requestBox);
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
     * 프로그램정보 디테일 Three 취소패널티 리스트
     * @param model
     * @param request
     * @param mav
     * @param requestBox
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailCancelListAjax.do")
    public ModelAndView programInfoDetailCancelListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        //리스트
        rtnMap.put("dataList", programInfoService.programInfoDetailCancelList(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT", rtnMap);

        return mav;
    }

    /**
     * 프로그램정보 디테일 Three 취소패널티 삭제
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
            programInfoService.cancelListDelete(requestBox);

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
     *   프로그램정보 디테일 수정 페이지
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoUpdatePage.do")
    public ModelAndView programInfoUpdatePage(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        DataBox check = programInfoService.exptypecheck(requestBox);
        model.addAttribute("check",check);
        DataBox detailpage = programInfoService.programInfoDetailOne(requestBox);
        model.addAttribute("detailpage",detailpage);
        model.addAttribute("ppCodeList", basicReservationService.ppCodeList()); //pplist
        requestBox.put("codemasterseq", "YN3");
        model.addAttribute("codeCombo", programInfoService.codeCombo(requestBox));
        List<DataBox> detailfile = programInfoService.programInfoDetailOneFile(requestBox);
        model.addAttribute("detailfile",detailfile);

        List<DataBox> otherfile = programInfoService.programInfoDetailOtherFile(requestBox);
        model.addAttribute("otherfile",otherfile);


        if(check.get("categorytype1").equals("E01") || check.get("categorytype1").equals("E02")){
            model.addAttribute("typeCheck", programInfoService.programInfoCheck(requestBox));
        }else if(check.get("categorytype1").equals("E03") ||check.get("categorytype1").equals("E04")){
            model.addAttribute("typeCheck", programInfoService.programInfoType(requestBox)); //type - E03,E04
        }
        //리스트
        model.addAttribute("listtype",requestBox);
        return mav;
    }


    /**
     *   프로그램정보 디테일 상세 페이지
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailPage.do")
    public ModelAndView facilityInfoDetailPage(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
        List<Map<String, Object>> listArrMap = new ArrayList<Map<String,Object>>();

        DataBox check = programInfoService.exptypecheck(requestBox);
        model.addAttribute("typecheck",check);
        DataBox detailpage = programInfoService.programInfoDetailOne(requestBox);
        model.addAttribute("detailpage",detailpage);
        List<DataBox> detailfile = programInfoService.programInfoDetailOneFile(requestBox);
        for(int i=0; i<detailfile.size();i++) {
            DataBox rtnMap = detailfile.get(i);

            String uploadSeq = StringUtil.getEncryptStr(rtnMap.get("filefullurl").toString());
            rtnMap.put("filefullurl", uploadSeq);
            String uploadName = StringUtil.getEncryptStr(rtnMap.get("storefilename").toString());
            rtnMap.put("storefilename", uploadName);
            listArrMap.add(i, rtnMap);
        }
        model.addAttribute("detailfile",listArrMap);

        if(check.get("categorytype1").equals("E01") || check.get("categorytype1").equals("E02") || check.get("categorytype1").equals("E03") || check.get("categorytype1").equals("E04")){
            model.addAttribute("check",programInfoService.programInfoDetailOne(requestBox));
        }
        //리스트
        model.addAttribute("listtype",requestBox);
        return mav;
    }

    /**
     *   프로그램정보 디테일 상세 페이지 -  날짜세션
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoDetailDateAjax.do")
    public ModelAndView programInfoDetailDateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        rtnMap.put("dataList",programInfoService.programInfoDetailDate(requestBox));

        mav.setView(new JSONView());
        mav.addObject("JSON_OBJECT",  rtnMap);
        return mav;
    }

    /**
     *   프로그램정보 디테일 수정
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    @RequestMapping(value = "/programInfoUpdate.do")
    public ModelAndView systemCodeUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        try {
            requestBox.put("sysId", requestBox.getSession( SessionUtil.sessionAdno )); //세션정보
            int check = 0;
            if(requestBox.get("categorytype1").equals("E01") || requestBox.get("categorytype1").equals("E02")) {
                if(requestBox.get("statuscode").equals("B01")) {
                    check = programInfoService.programInsCheck(requestBox);
                }
            }
            if(check <= 0) {
                programInfoService.programInfoUpdate(requestBox);

                resultMap.put("errCode", "0");
                resultMap.put("errMsg", "");
            } else {
                resultMap.put("errCode", "2");
                resultMap.put("errMsg", "");
            }
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
