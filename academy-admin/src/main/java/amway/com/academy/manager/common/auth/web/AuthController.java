package amway.com.academy.manager.common.auth.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import amway.com.academy.manager.common.util.SessionUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.auth.service.AuthService;
import amway.com.academy.manager.common.main.web.MainController;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.LmsUtil;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.common.web.CommonController;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/manager/common/auth")
public class AuthController extends CommonController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private AuthService authService;
	
	@Autowired
	LmsUtil lmsUtil;

	/**
	 * 관리자 권한 그룹 리스트
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/authGroupList.do")
    public ModelAndView authGroupList(RequestBox requestBox, ModelAndView mav) throws Exception {
        return mav;
    }
	
    /**
     * 관리자 권한그룹 리스트 Ajax
     * @param manageSystemAuthVO
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/authGroupListAjax.do")
    public ModelAndView selectManageAuthGroupListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(authService.selectAuthGroupListTotalCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  authService.selectAuthGroupList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }

	//팝업
	@RequestMapping(value = "/authGroupListPop.do")
	public ModelAndView authGroupListPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		/************ 공통 검색조건 ***************/
		mav.addObject("ppList", authService.selectPpList());
		
		//정보 조회하기
		mav.addObject("info", authService.authGroupListManagerInfo(requestBox));

		model.addAttribute("layerMode", requestBox);
		
		return mav;
	}

	  /**
		 * 관리자 권한그룹 rightDiv 불러오기
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/authGroupListRightDivAjax.do")
	    public ModelAndView authGroupListRightDivAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
			//메뉴 리스트 불러오기
			List<DataBox> menuList = authService.authGroupListRightDivAjax(requestBox);
			
			//오른쪽 DIv 정보
			mav.addObject("managerInfo",authService.authGroupListManagerInfo(requestBox));
			mav.addObject("menuList", menuList);
			mav.setViewName("/manager/common/auth/authGroupListRightDiv");

			return mav;
	    }
		
		/**
		 * 메뉴 권한 설정 insert
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/authGroupListMenuAuthSaveAjax.do")
		public ModelAndView authGroupListMenuAuthSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
	    	Map<String, Object> rtnMap = new HashMap<String, Object>();

			//session값 넣는 곳
			requestBox.put("adminid", requestBox.getSession( SessionUtil.sessionAdno ));

			//메뉴 권한 설정
			int result = authService.authGroupListMenuAuthSaveAjax(requestBox);
			rtnMap.put("result", result);
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}

		/**
		 * 메뉴 권한 설정 운영자 삭제
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/authGroupListManagerDeleteAjax.do")
		public ModelAndView authGroupListManagerDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
			Map<String, Object> rtnMap = new HashMap<String, Object>();

			//운영자 삭제
			int result = authService.authGroupListManagerDeleteAjax(requestBox);
			rtnMap.put("result", result);

			// 운영자 로그
			requestBox.put("logdetail", "delete");
			authService.userLogInsert(requestBox);
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}
		
		/**
		 * 운영자 기본정보 등록 POP insert or Update
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/authGroupListPopInsertUpdateAjax.do")
		public ModelAndView authGroupListPopInsertAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
			//session값 넣는 곳
			requestBox.put("adminid", requestBox.getSession( SessionUtil.sessionAdno ));

			int result = 0;
			int reNum = 2;
			
			Map<String, Object> rtnMap = new HashMap<String, Object>();
	    	if(requestBox.get("mode").equals("I"))
	    	{
	    		//popUp 운영자 개별 등록
	    		result = authService.authGroupListPopInsertAjax(requestBox);
	    		if(result == reNum)
	    		{
	    			rtnMap.put("comment", "해당 AD계정은 이미 등록 된 계정입니다.");
	    		}
	    	}
	    	else if(requestBox.get("mode").equals("U"))
	    	{
	    		result = authService.authGroupListPopUpdateAjax(requestBox);

				// 운영자 로그
				requestBox.put("logdetail", "update");
				authService.userLogInsert(requestBox);
	    	}
	    	rtnMap.put("adno", requestBox.get("adno"));
	    	rtnMap.put("result", result);
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}
		
		/**
		 * sample excel down
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value="/authGroupListPopExcelDownload.do")
		public String authGroupListPopExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
			 
			 // 1. init
	    	Map<String, Object> head = new HashMap<String, Object>();
	    	
	    	String fileNm = "운영자등록_샘플파일";
	    	
			// 엑셀 헤더명 정의
			String[] headName = {"AD계정","이름","부서","PP소속 해당"};
			String[] headId = {"adno","managename","managedepart","ppseq"};
			head.put("headName", headName);
			head.put("headId", headId);

	    	// 2. 파일 이름
			String sFileName = fileNm + ".xlsx";
			
			// 3. excel 양식 구성
			List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
			XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
			model.addAttribute("type", "xlsx");
			model.addAttribute("fileName", sFileName);
			model.addAttribute("workbook", workbook);
		  
			return "excelDownload";
		}
		
		
		/**
		 * auth excel  Register 
		 * @param requestBox
		 * @param mav
		 * @return ModelAndView
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		@RequestMapping(value="/authGroupListPopExcelUploadAjax.do")
		public ModelAndView authGroupListPopExcelUploadAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
			requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
			Map<String, Object> rtnMap = new HashMap<String, Object>();
			
			//excel 파일 데이터 읽기
			String addapplicantexcelfile = requestBox.get("authregisterexcelfile");

			//ROOT_UPLOAD_DIR
			String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + addapplicantexcelfile;
			int totalColCount = 4; //전체 컬럼 갯수
			int startIndexRow = 1; //헤더제외
			String colChk = "Y,Y,Y,N"; //필수값 체크 Y.필수 N선택
			String colTypeChk = "S,S,S,S"; //I.숫자 S.문자
			
			Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
			
			//String retStatus = retMap.get("status").toString();
			List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
			List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
			
			boolean isValid = true;
			//실패 데이터 확인
			String failStr = "";
			StringBuffer failBuffer = new StringBuffer();
			int failNum = 0;
			if( retFailList != null && retFailList.size() > failNum ) {
				for( int i=0; i<retFailList.size(); i++ ) {
					Map<String,String> retFailMap = retFailList.get(i);
					failBuffer.append(retFailMap.get("data") + "\r\n");
					isValid = false;
				}
				failStr = failBuffer.toString();
				rtnMap.put("comment",failStr);
			}
			
			//EXCEL로 운영자 등록
			if(isValid)
			{
				rtnMap.putAll(authService.authGroupListPopExcelUploadAjax(requestBox,retSuccessList));
			}
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			
			return mav;
		}

}




































