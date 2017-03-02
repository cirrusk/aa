package amway.com.academy.manager.trainingFee.proof.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.common.file.service.FileUpLoadService;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeSpendService;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;

/**
 * @author KR620225
 * 교육비_지출증빙관리 컨트롤러
 */
@RequestMapping("/manager/trainingFee/proof")
@Controller
public class TrainingFeeSpendController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeSpendController.class);
	

	/** 검색조건  Service */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	@Autowired
	TrainingFeeSpendService trainingFeeSpendService;
	
	@Autowired
	FileUpLoadService fileUpLoadService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 교육비 지출 증비 서류 페이지 호출
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpend.do")
	public ModelAndView trainingFeeSpend(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		

		/************ 공통 검색조건 ***************/
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox)); //br
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그릅
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox)); //code
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //loa
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox)); //dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		model.addAttribute("getCount" , trainingFeeSpendService.selectSpendDoNotIt(requestBox));
		
		return mav;
	}
	
	/**
	 * 교육비 지출증빙 상세보기 tab
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendDetail.do")
	public ModelAndView trainingFeeSpendDetail(ModelMap model, HttpServletRequest request, ModelAndView mav,	RequestBox requestBox) throws Exception{
		
		return mav;
	}
	
	/**
	 * 교육비 지출증빙 list
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendList.do")
    public ModelAndView trainingFeeSpendList(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
    	
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		int mon = Integer.parseInt(requestBox.get("searchGiveYear").substring(5,7));
		int fiscalyear = Integer.parseInt(requestBox.get("searchGiveYear").substring(0,4));
		String fiscalYear = fiscalyear+"";
		
		if( mon > 10 ) {
			fiscalYear = (fiscalyear + 1)+"";
		} 
		
		requestBox.put("fiscalyear", fiscalYear);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeSpendService.selectTrainingFeeSpendListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeSpendService.selectTrainingFeeSpendList(requestBox));
		rtnMap.put("getCount" , trainingFeeSpendService.selectSpendDoNotIt(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육비 지출증빙 상세 list
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendDetailList.do")
	public ModelAndView trainingFeeSpendDetailList(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		int mon = Integer.parseInt(requestBox.get("givemonth"));
		int fiscalyear = Integer.parseInt(requestBox.get("giveyear"));
		String fiscalYear = fiscalyear+"";
		
		if( mon > 10 ) {
			fiscalYear = (fiscalyear + 1)+"";
		}
		
		requestBox.put("fiscalyear", fiscalYear);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeSpendService.selectTrainingFeeSpendDetailListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeSpendService.selectTrainingFeeSpendDetailList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	/**
	 * 교육비 지출증빙 - 영수증 확인 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendReceiptPop.do")
	public ModelAndView trainingFeeSpendReceiptPop(ModelMap model, HttpServletRequest request, ModelAndView mav,	RequestBox requestBox) throws Exception{
		List<Map<String, Object>> listArrMap = new ArrayList<Map<String,Object>>();
		model.addAttribute("lyData", requestBox);
		
		List<Map<String, Object>> listMap = trainingFeeSpendService.selectTrainingFeeSpendReceiptList(requestBox);
		
		for(int i=0; i<listMap.size();i++) {
			Map<String, Object> rtnMap = listMap.get(i);
			
			String attachFile = StringUtil.getEncryptStr(rtnMap.get("attachfile").toString());
			String uploadSeq = StringUtil.getEncryptStr(rtnMap.get("uploadseq").toString());
			String filefullurl = StringUtil.getEncryptStr(rtnMap.get("filefullurl").toString());
			String storefilename = StringUtil.getEncryptStr(rtnMap.get("storefilename").toString());
			rtnMap.put("attachfile", attachFile);
			rtnMap.put("uploadseq", uploadSeq);
			rtnMap.put("filefullurl", filefullurl);
			rtnMap.put("storefilename", storefilename);
			listArrMap.add(i, rtnMap);
		}
		
		model.addAttribute("dataList", listArrMap);
		return mav;
	}	
	
	@RequestMapping(value = "/trainingFeeSpendReceiptList.do")
	public ModelAndView trainingFeeSpendReceiptList(RequestBox requestBox, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("dataList", trainingFeeSpendService.selectTrainingFeeSpendReceiptList(requestBox));
		
		return mav;
	}
	
	/**
	 * 지출 영수증 읽어 오기
	 * @param requestBox
	 * @param req
	 * @param res
	 * @throws Exception
	 */
	@RequestMapping(value = "/imageView.do")
    public void imageView(RequestBox requestBox, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String fileFullPath = StringUtil.getDecryptStr(requestBox.get("filefullurl").toString()) + StringUtil.getDecryptStr(requestBox.get("storefilename").toString());
		
		File imgFile = new File(fileFullPath);
		if(imgFile.isFile()){
			FileInputStream ifo = new FileInputStream(imgFile);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			while((readlength = ifo.read(buf)) != -1){
				baos.write(buf, 0, readlength);
			}
			byte[] imgbuf = null;
			imgbuf = baos.toByteArray();
			baos.close();
			ifo.close();
			
			int length = imgbuf.length;
			OutputStream out = res.getOutputStream();
			out.write(imgbuf, 0, length);
			out.close();
		}
		
    }
	
	/**
	 * 교육비 지출증빙 - 지급반려 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendRejectPop.do")
	public ModelAndView trainingFeeSpendRejectPop(ModelMap model, HttpServletRequest request, ModelAndView mav,	RequestBox requestBox) throws Exception{
		Map<String, Object> targetInfoMap = new HashMap<String, Object>();
		
		model.addAttribute("lyData", requestBox);
		targetInfoMap = trainingFeeCommonService.selectTargetInfoList(requestBox);
		
		model.addAttribute("targetInfo", targetInfoMap  );
		
		return mav;
	}
	
	/**
	 * 교육비 지출증빙 - 지급 승인
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendConfrim.do")
    public ModelAndView trainingFeeSpendConfrim(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws SQLException {  
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> statusMap = new HashMap<String, Object>();
		String errCode = "";
		String errMsg  = "";
		
		try{
			
			statusMap = trainingFeeSpendService.selectStatus(requestBox);
			String planstatus  = statusMap.get("planstatus").toString();
			String spendstatus = statusMap.get("spendstatus").toString();
			int rentConfrimCnt = trainingFeeSpendService.selectNotRentConfrim(requestBox);
			
			if(rentConfrimCnt>0) {
				errCode = "-1";
				errMsg = "임대차 미 처리건이 존재 하여 승인/반려 할 수 없습니다.";
			} else if( planstatus.equals("N") || spendstatus.equals("N") ) {
				errCode = "-1";
				errMsg = "지출증빙 제출 전에는 승인/반려 할 수 없습니다.";
			} else {
				trainingFeeSpendService.saveSpendConfrim(requestBox);
				errCode = "0";
			}		
						
			resultMap.put("errCode", errCode);
			resultMap.put("errMsg", errMsg);			
			
		} catch ( SQLException e )
		{
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
	 * 교육비 지출증빙 반려
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendReject.do")
	public ModelAndView trainingFeeSpendReject(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws SQLException {  
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> statusMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> smsMap = new HashMap<String, Object>();
		int errCode = 0;
		String errMsg = "";
		
		try{
			
			statusMap = trainingFeeSpendService.selectStatus(requestBox);
			String planstatus  = statusMap.get("planstatus").toString();
			String spendstatus = statusMap.get("spendstatus").toString();
			
			if( planstatus.equals("N") || spendstatus.equals("N") ) {
				errCode = -1;
				errMsg = "지출증빙 제출 전에는 승인/반려 할 수 없습니다.";
			} else {
				String smsyn = requestBox.get("smsyn");
				
				smsMap.put("giveyear", requestBox.get("giveyear"));
				smsMap.put("givemonth", requestBox.get("givemonth"));
				smsMap.put("abono", requestBox.get("abono"));
				smsMap.put("errCode", "");
				smsMap.put("errMsg", "");
				
				// 반려 SMS발송 여부에 따라서 전송됨
				if( smsyn.equals("Y") ) {
					trainingFeeSpendService.callSmsRejectSend(smsMap);
					
					errCode = (int) smsMap.get("errCode");
					
					if(errCode<0) {
						errMsg = "SMS 발송중 오류가 발생 하였습니다.";
					} else {
						trainingFeeSpendService.saveSpendReject(requestBox);
						errMsg = "저장 완료 되었습니다.";
					}
				} else {
					trainingFeeSpendService.saveSpendReject(requestBox);
					errMsg = "저장 완료 되었습니다.";
				}
				
			}
			
			resultMap.put("errCode", errCode);
			resultMap.put("errMsg", errMsg);
			
		} catch ( SQLException e )
		{
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
	 * 지출증빙 확인
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendChecking.do")
	public ModelAndView trainingFeeSpendChecking(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws SQLException {  
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int result = 0;
		
		try{
			
			result = trainingFeeSpendService.saveSpendChecking(requestBox);
			
			resultMap.put("errCode", result);
			resultMap.put("errMsg", "");			
			
		} catch ( SQLException e )
		{
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
	 * 브라우져 체크
	 * @param request
	 * @return
	 */
	private String getBrowser(HttpServletRequest request) {
        String header =request.getHeader("User-Agent");
        if (header.contains("MSIE") || header.contains("TRIDENT") || header.contains("Trident") ) {
               return "MSIE";
        } else if(header.contains("Chrome")) {
               return "Chrome";
        } else if(header.contains("Opera")) {
               return "Opera";
        }
        return "Firefox";
	}
	
	/**
	 * @param request String fileKey, String uploadSeq - fileKey 와 uploadSeq 를 받아 FILE_MANAGEMENT Table을 조회 후 해당 file을 찾아 Download 한다.
	 * @param response
	 * @param model
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	@RequestMapping(value = "/fileDownload")
	public void fileDownload(HttpServletRequest request, HttpServletResponse response, ModelMap model, RequestBox requestBox)  throws FileNotFoundException, IOException
	{

		Map<String, Object> fileMap = new HashMap<String, Object>();

		model.put("work"  ,"TRFEE");
		model.put("fileKey"  ,request.getParameter("fileKey"));
		model.put("uploadSeq",request.getParameter("uploadSeq"));

		try {
			fileMap = fileUpLoadService.getSelectFileDetail(model);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// fileMap null Cehck
		if(null != fileMap){
		
			String filePath = (String)fileMap.get("fileFullUrl") + (String)fileMap.get("streFileNm");
			String fileName = (String)fileMap.get("realFileNm");

			File downloadFile = new File(filePath);
			FileInputStream inStream = new FileInputStream(downloadFile);
	
			// if you want to use a relative path to context root:
			String relativePath = request.getSession().getServletContext().getRealPath("");
			LOGGER.debug("relativePath = " + relativePath);
	
			// obtains ServletContext
			ServletContext context = request.getSession().getServletContext();
	
			// gets MIME type of the file
			String mimeType = context.getMimeType(filePath);
			if (mimeType == null) {        
				// set to binary type if MIME mapping not found
				mimeType = "application/octet-stream";
			}
			LOGGER.debug("MIME type: " + mimeType);
	
			// modifies response
			String header = getBrowser(request);
			if (header.contains("MSIE")) {
			       String docName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
			       response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
			} else if (header.contains("Firefox")) {
			       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			} else if (header.contains("Opera")) {
			       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			} else if (header.contains("Chrome")) {
			       String docName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			       response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
			}
			response.setHeader("Content-Type", "application/octet-stream");
			response.setContentLength((int)downloadFile.length() );
			response.setHeader("Content-Transfer-Encoding", "binary;");
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");

			response.setContentType(mimeType);
			response.setContentLength((int) downloadFile.length());
	
			// obtains response's output stream
			OutputStream outStream = response.getOutputStream();

			byte[] buffer = new byte[10240];
			int bytesRead = -1;
	
			while ((bytesRead = inStream.read(buffer)) != -1) {
				outStream.write(buffer, 0, bytesRead);
			}
	
			inStream.close();
			outStream.close();
			
		}	// fileMap null Cehck
	}	// select value check

}
