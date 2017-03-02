package amway.com.academy.manager.lms.category.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.category.service.LmsCategoryService;
import amway.com.academy.manager.lms.common.LmsCode;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsCategoryController.java
 * @DESC :카테고리 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/course")
public class LmsCategoryController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCategoryController.class);	
	
	@Autowired
	LmsCategoryService lmsCategoryService;	

	@Autowired
	SessionUtil sessionUtil;
	
	@RequestMapping(value = "/lmsCategory.do")
	public ModelAndView lmsCategory(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		//basic setting
		if( requestBox.get("searchcoursetype").equals("") ) {
			requestBox.put("searchcoursetype", "O");
		}
		
		//select category list
        List<DataBox> list = lmsCategoryService.selectCategoryList(requestBox);
        
        mav.addObject("categoryGrid", list);

		mav.addObject("courseTypeList", LmsCode.getCourseTypeList());
        
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsCategory.do") );
		
		return mav;
    }	
	
	@RequestMapping(value = "/lmsCategoryAjax.do")
	public ModelAndView lmsCategoryAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
        List<DataBox> list = lmsCategoryService.selectCategoryList(requestBox);
        
        rtnMap.put("categoryGrid",  list);
        
        mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
        
		return mav;
    }	
	
	@RequestMapping(value = "/lmsCategoryPop.do")
	public ModelAndView lmsCategoryPop(RequestBox requestBox, ModelAndView mav, ModelMap model) throws Exception {
		
		//select category 1 data
		if( requestBox.get("categoryid").equals("") ) { //1level
			DataBox categoryDetail = new DataBox();
			categoryDetail.put("categorylevel", "1");
			categoryDetail.put("upcategoryname", "없음");
			categoryDetail.put("upcategorycode", "-");
			categoryDetail.put("openflag", "N");
			categoryDetail.put("complianceflag", "N");
			categoryDetail.put("copyrightflag", "N");
			categoryDetail.put("categoryupid", "0");
			categoryDetail.put("categoryorder", "");
			
			categoryDetail.put("categorytype", requestBox.get("categorytype"));
			categoryDetail.put("inputtype", requestBox.get("inputtype"));
			
			model.addAttribute("categoryDetail", categoryDetail);
		} else {
			String inputtype = requestBox.get("inputtype");
			
			DataBox categoryDetail = lmsCategoryService.selectCategoryDetail(requestBox);
			if( inputtype.equals("in") ) { //sub insert
				categoryDetail.put("categorylevel", categoryDetail.get("upcategorylevel"));
				categoryDetail.put("upcategoryname", categoryDetail.get("categoryname"));
				categoryDetail.put("upcategorycode", categoryDetail.get("categorycode"));

				categoryDetail.put("categorycode", "");
				categoryDetail.put("categoryname", "");
				categoryDetail.put("openflag", "N");
				categoryDetail.put("complianceflag", "N");
				categoryDetail.put("copyrightflag", "N");
				categoryDetail.put("hybrismenu", "");
				
				categoryDetail.put("categoryupid", categoryDetail.get("categoryid"));
			}
			categoryDetail.put("inputtype", requestBox.get("inputtype"));
			
			model.addAttribute("categoryDetail", categoryDetail);
		}
		
		return mav;
    }

	@RequestMapping(value = "/lmsCategorySaveAjax.do")
	public ModelAndView lmsCategorySaveAjax(ModelMap model, RequestBox requestBox, ModelAndView mav) throws Exception{

		mav.setView(new JSONView());
		
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		int result = 0;
		String inputtype =  requestBox.get("inputtype");
		if( inputtype.equals("in") ) {
			//코드 중복 확인
			int sameCodeCount = lmsCategoryService.selectCategorySameCodeCount(requestBox);
			if( sameCodeCount > 0 ) {
				result = 2;
			} else {

				//get order
				int categoryOrderCount = lmsCategoryService.selectCategoryOrderCount(requestBox);
				requestBox.put("categoryorder", requestBox.get("categoryorder") + LmsCode.getMaxOrder(categoryOrderCount));
	
				//get max id
				int maxCategoryId = lmsCategoryService.selectMaxCategoryId(requestBox);
				requestBox.put("categoryid", maxCategoryId);
				
				result = lmsCategoryService.insertCategoryAjax(requestBox);
			}
			
		} else if( inputtype.equals("up") ) {
			//자기 자신외의 공통 코드 확인
			int sameCodeCount = lmsCategoryService.selectCategorySameCodeCount(requestBox);
			if( sameCodeCount > 0 ) {
				result = 2;
			} else {
				result = lmsCategoryService.updateCategoryAjax(requestBox);
			}
			
		} else if( inputtype.equals("del") ) {

			String[] categoryids = requestBox.get("checkcategoryid").split("[,]");
			requestBox.put("categoryids", categoryids);

			result = lmsCategoryService.deleteCategoryAjax(requestBox);
		}
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("result", result);
		
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsCategoryExcelDownload.do")
	public String lmsCategoryExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		if( requestBox.get("searchcoursetype").equals("") ) {
			requestBox.put("searchcoursetype", "O");
		}
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "교육분류목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","카테고리1","카테고리2","카테고리3","저작권동의","Compliance","상태"};
		String[] headId = {"NO","CATEGORYNAME1","CATEGORYNAME2","CATEGORYNAME3","COPYRIGHTFLAG","COMPLIANCEFLAG","OPENFLAG"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = lmsCategoryService.selectCategoryExcelList(requestBox);
		// 카테고리 엑셀다운만 번호 증가형태로 변경 AKL ECM 1.5 AI SITAKEAISIT-1348
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
}