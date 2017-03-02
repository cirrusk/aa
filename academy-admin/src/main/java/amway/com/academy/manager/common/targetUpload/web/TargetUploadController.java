package amway.com.academy.manager.common.targetUpload.web;

import amway.com.academy.manager.common.excel.service.ManageExcelService;
import amway.com.academy.manager.common.excel.web.ManageExcelController;
import amway.com.academy.manager.common.targetUpload.service.TargetUploadService;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.common.vo.UploadItemVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager/common/targetUpload")
public class TargetUploadController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TargetUploadController.class);
	
	@Autowired
	TargetUploadService targetUploadService;

	@Autowired
	ManageExcelController excelController;

	@Autowired
	ManageExcelService svc;

	/**
	 *  대상자일괄업로드 페이지호출
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadList.do")
    public ModelAndView targetUploadList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox) throws Exception {
		return mav;
    }

	/**
	 *   대상자일괄업로드 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetUploadListAjax.do")
	public ModelAndView targetUploadListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(targetUploadService.targetUploadListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",targetUploadService.targetUploadList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",rtnMap);
		return mav;
	}

	/**
	 *  대상자일괄 업로드 디테일팝업 리스트호출
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadDetailCntPop.do")
	public ModelAndView targetUploadListCntPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		/************ 공통 검색조건 ***************/
		DataBox popDetail = targetUploadService.targetUploadDetailPop(requestBox);
		model.addAttribute("popDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 *   대상자일괄업로드 리스트 디테일 팝업List
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetUploadListCntPopAjax.do")
	public ModelAndView targetUploadListCntPopAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		rtnMap.put("dataList",targetUploadService.targetUploadListCntPop(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",rtnMap);

		return mav;
	}

	/**
	 *  대상자일괄업로드 샘플다운로드
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/targetUploadSampleExcelDownload.do")
	public String targetUploadSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{

		// 1. init
		Map<String, Object> head = new HashMap<String, Object>();

		String fileNm = "";
		fileNm = requestBox.get("downloadfile");
		if("testpool".equals(requestBox.get("exceltype"))){

			// 엑셀 헤더명 정의
			String[] headName = {"대상자이름","ABO번호"};
			String[] headId = {"TARGETGROUPNAME","ABONO"};
			head.put("headName", headName);
			head.put("headId", headId);

		}
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
	 *  대상자일괄업로드 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadPop.do")
	public ModelAndView targetUploadListPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> excelMap = new HashMap<String, Object>();
		DataBox popDetail = targetUploadService.targetUploadDetailPop(requestBox);
		model.addAttribute("popDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		excelMap.put("excelType", requestBox.get("excelType")); // 팝업 구분
		model.addAttribute("popupPage", excelMap);

		return mav;
	}

	/**
	 *  대상자일괄업로드 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadDetailPop.do")
	public ModelAndView targetUploadDetailPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> excelMap = new HashMap<String, Object>();
		DataBox popDetail = targetUploadService.targetUploadDetailPop(requestBox);
		model.addAttribute("popDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		excelMap.put("excelType", requestBox.get("excelType")); // 팝업 구분
		model.addAttribute("popupPage", excelMap);

		return mav;
	}

	/**
	 * 대상자일괄업로드 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadDetailDelete.do")
	public ModelAndView targetUploadDetailDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//삭제처리
		int cnt = targetUploadService.targetUploadDetailDelete(requestBox); // rsvrolegroup
		rtnMap.put("cnt",cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",rtnMap);

		return mav;
	}

	/**
	 * 글등록 및 엑셀 업로드
	 * @param request
	 * @param response
	 * @param multiRequest
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/excelFileUpload.do")
	public ModelAndView targetUploadExcelFileUpload(HttpServletRequest request, RequestBox requestBox,HttpServletResponse response, final MultipartHttpServletRequest multiRequest, Model model) throws Exception{

		ModelAndView mav = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));

		// Files 담기
		List<MultipartFile> files = multiRequest.getFiles("file");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String[] strData = {};

		UploadItemVO uploadItem = new UploadItemVO();
		uploadItem.setFileData( files );
		uploadItem.setTargetExts("xls,xlsx");

		String docBase = "tmpExcelUpload";
		int validColCnt = 0; // 엑셀 컬럼 수
		int requiredColCnt = 0;
		int startIndexRow = 0;

		startIndexRow = 1; // 헤더를 제외하고 가져 왔음.
		validColCnt = 3;
		requiredColCnt = 2;
		if( "target".equals("target") ) {
			startIndexRow = 1; // 헤더를 제외하고 가져 왔음.
			validColCnt = 3;
			requiredColCnt = 2;
		}

		paramMap.put("excelType", "target" );

		/**
		 * 파일 내용을 읽어 온다.
		 */
		String[][] importData = excelController.excelUpload(uploadItem, docBase, validColCnt, requiredColCnt, startIndexRow, paramMap);

		/** 유효성 체크
		 * */
		//멤버테이블과 ABONO 맞으면 insert
		if("target".equals("target")){
			//대상자 업로드 유효성 체크
			importData = targetUploadService.validExcel(importData, requestBox);
		}

		if("-1".equals(importData[0][0])) {
			resultMap.put("errCode"    , importData[0][0]);
			resultMap.put("errMsg"     , importData[0][1]);
		} else {
			int upSeq;
			if(requestBox.get("gubun").equals("one")) {
				upSeq = targetUploadService.targeterUploadInsert(requestBox); //상위 글 등록
			} else {
				upSeq = Integer.parseInt(requestBox.get("groupseq").toString());
			}

			// 루프를 돌면서 VO객체에 값을 세팅하여 인서트 하면 됨
			// 가져온 데이터에 결과를 출력하기 위해 칼럼헤더도 함께 추출하니 등록시에는 importData[1] 부터 조회하여 사용할 것 ( importData[0] 은 칼럼 헤더 임 )
			for(int i=0;i<importData.length;i++) {
				strData = importData[i];

				// 저장할 item을 맵으로 구성하여 저장 서비스를 호출 한다.
				if( "target".equals("target") ) {
					//컬럼셋팅
					paramMap.put("groupseq", upSeq);
					paramMap.put("aboname", strData[0]);
					paramMap.put("abono", strData[1]);

					targetUploadService.insertExcelData(paramMap);
				}

				resultMap.put("importCount", importData.length);
				resultMap.put("errCode"    , "0");
				resultMap.put("errMsg"     , "");
			}
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  resultMap);

		return mav;
	}


	/**
	 * 대상자일괄업로드 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUploadDelete.do")
	public ModelAndView targetUploadDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//삭제파람 체크시작
		requestBox.put("groupseqdels",requestBox.getVector("groupseq"));
		requestBox.put("groupseqdel",requestBox.getVector("groupseq"));
		//삭제Param 체크끝

		//삭제처리
		int cnt = targetUploadService.targetUploadDelete(requestBox); // rsvrolegroup
		rtnMap.put("cnt",cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",rtnMap);

		return mav;
	}

}