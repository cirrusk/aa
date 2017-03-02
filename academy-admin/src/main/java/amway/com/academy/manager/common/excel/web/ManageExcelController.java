package amway.com.academy.manager.common.excel.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.excel.service.ManageExcelService;
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.trainingFee.trainingFeeTarget.web.TrainingFeeTargetController;
import framework.com.cmm.common.vo.UploadItemVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;


/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :ManageExcelController.java
 * @DESC :관리자 Excel 업로드  Controller
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.07. 01. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/common/excel")
public class ManageExcelController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeTargetController.class);
	
	/**
	 * 관리자로그인 Service
	 */
	/*
	 * Service
	 */
	@Autowired
	ManageExcelService svc;
	
	@Value("#['Globals.fileStorePath']}")
	protected String rootUpLoadDir;

    /**
     * Excel 업로드 팝업 창(교육비 지급 대상자, 교육비 EM위임자)
     * @param model
     * @param request
     * @param mav
     * @param requestBox
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/excelUpload.do")
    public ModelAndView excelAgreePopup(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception {
    	ModelAndView mav = null;
    	
//        AuthVO auth = SessionUtils.getCurrentAuth( request ); // 공통 로그인 정보
    	
    	if("target".equals(requestBox.get("page"))) {
    		requestBox.put("downloadfile","월별 지급대상자 업로드 양식");
    		mav = new ModelAndView("/manager/common/excel/excelPopup");
    	} else if("agree".equals(requestBox.get("page"))) {
    		requestBox.put("downloadfile","Emerald 위임 대상자 업로드 양식");
    		mav = new ModelAndView("/manager/common/excel/excelAgreePopup");
    	}
        
        model.addAttribute("layPopData", requestBox);
        
        return mav;
    }
    
    /**
     * Excel 양식 다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/excelDownload.do")
	public String manageExcelDownloadAjax(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm      = "";
    	XSSFWorkbook workbook = null;
    	
    	if( "target".equals(requestBox.get("page")) ) {
    		fileNm = requestBox.get("downloadfile");
    		// 엑셀 헤더명 정의
    		String[] headName = {"ABO No","Code","매출액","교육비","BR","Dept","운영그룹","위임","개인권한","그룹권한","총무유무","ABO No","Code"};
    		String[] bodyName = {"","교육비\n운영Code","","","","","","1:Emerald\n2:Diamond\n3:Special","1:개인\n2:상세","0:없음\n1:개인\n2:상세","Y/N","","교육비\n운영Code"};
    		    		
    		head.put("headName", headName);
    		head.put("bodyName", bodyName);
    		 
    		// 3. excel 양식 구성
    		workbook = ExcelUtil.getExcelExportObject(fileNm, head, "xlsx");
    	} else if("agree".equals(requestBox.get("page"))) {
    		fileNm = requestBox.get("downloadfile");
    		// 엑셀 헤더명 정의
    		String[] headName = {"피위임자 ABO No","위임자 ABO No"};
    		    		
    		head.put("headName", headName);
    		
    		// 3. excel 양식 구성
    		workbook = ExcelUtil.getExcelExportObjectOneRow(fileNm, head, "xlsx");
    	}
    	
    	// 2. 파일 이름
		String sFileName = requestBox.get("downloadfile") + ".xlsx";
		
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    
    /**
     * 엑셀 업로드
     * @param request
     * @param response
     * @param multiRequest
     * @param model
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/excelFileUpload.do")
  	public ModelAndView manageExcelFileUpload(HttpServletRequest request, RequestBox requestBox, final MultipartHttpServletRequest multiRequest, Model model) throws Exception{
    	ModelAndView mav = new ModelAndView();
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
  		// Files 담기
//    	AuthVO auth = SessionUtils.getCurrentAuth( request ); // 공통 로그인 정보
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
  		String sPage = requestBox.get("page");
  		
  		if( "target".equals(sPage) ) {
  			startIndexRow = 2; // 헤더를 제외하고 가져 왔음.
  			validColCnt = 13;
  			requiredColCnt = 6;
  		} else if("agree".equals(sPage)) {
  			startIndexRow = 1; // 헤더를 제외하고 가져 왔음.
  			validColCnt = 2;
  			requiredColCnt = 2;
  		}
  		
  		paramMap.put("excelType", sPage );
  		
  		/**
  		 * 파일 내용을 읽어 온다.
  		 */
  		String[][] importData = this.excelUpload(uploadItem, docBase, validColCnt, requiredColCnt, startIndexRow, paramMap);
  		
  		/** 유효성 체크
  		 * */
  		if( "target".equals(sPage) ) {
  			for(int i=0;i<importData.length;i++) {
  	  			strData = importData[i];
  	  			
  	  			// 위임구분
  	  			if(!strData[7].equals("0")&&!strData[7].equals("1")&&!strData[7].equals("2")&&!strData[7].equals("3")) {
	  	  			resultMap.put("errCode"    , "-1");
	  				resultMap.put("errMsg"     , "["+(i+2)+"행] 교육비 위임 대상자에 위임구분값은 (0 : 없음,1 : Emabled,2 : Diamond,3 : Special)로 구분해 주세요.");
  	  				break;
  	  			}
  	  			
  	  			// 개인권한
  	  			if(!strData[8].equals("0")&&!strData[8].equals("1")&&!strData[8].equals("2")) {
  	  				resultMap.put("errCode"    , "-1");
  	  				resultMap.put("errMsg"     , "["+(i+2)+"행] 교육비 위임 대상자에 개인권한값은 (0:없음,1:개인,2:상세)로 구분해 주세요.");
  	  				break;
  	  			}
  	  			
  	  			// 그룹권한
  	  			if(!strData[9].equals("0")&&!strData[9].equals("1")&&!strData[9].equals("2")) {
  	  				resultMap.put("errCode"    , "-1");
  	  				resultMap.put("errMsg"     , "["+(i+2)+"행] 교육비 위임 대상자에 그룹권한값은 (0:없음,1:개인,2:상세)로 구분해 주세요.");
  	  				break;
  	  			}
  	  			
  	  			// 총무여부
  	  			if(!strData[10].equals("Y")&&!strData[10].equals("N")) {
  	  				resultMap.put("errCode"    , "-1");
  	  				resultMap.put("errMsg"     , "["+(i+2)+"행] 교육비 위임 대상자에 총무구분값은 (Y,N)로 구분해 주세요.");
  	  				break;
  	  			}
  			}
  		} else if( "agree".equals(sPage) ) {
  			// 교육비 위임 대상자 유효성 체크
			importData = svc.validExcelData(importData, requestBox);
  		}
  		
  		String errCode = importData[0][0];  		
  		if( "-1".equals(errCode) ) {
  			resultMap.put("errCode"    , importData[0][0]);
			resultMap.put("errMsg"     , importData[0][1]);
  		} else {
	  		// 루프를 돌면서 VO객체에 값을 세팅하여 인서트 하면 됨
	  		// 가져온 데이터에 결과를 출력하기 위해 칼럼헤더도 함께 추출하니 등록시에는 importData[1] 부터 조회하여 사용할 것 ( importData[0] 은 칼럼 헤더 임 )
	  		for(int i=0;i<importData.length;i++) {
	  			strData = importData[i];
	  			
	  			// 저장할 item을 맵으로 구성하여 저장 서비스를 호출 한다.
				if( "target".equals(sPage) ) {
					paramMap.put("abono", strData[0]);
					paramMap.put("code", strData[1]);
					paramMap.put("salesfee", strData[2]);
					paramMap.put("trainingfee", strData[3]);
					paramMap.put("br", strData[4]);
					paramMap.put("dept", strData[5]);
					paramMap.put("groupcode", strData[6]);
					paramMap.put("authtype", strData[7]);
					paramMap.put("authperson", strData[8]);
					paramMap.put("authgroup", strData[9]);
					paramMap.put("authmanager", strData[10]);
					paramMap.put("depositabono", strData[11]);
					paramMap.put("depositcode", strData[12]);
					paramMap.put("modifier","admin");
					paramMap.put("registrant","admin");
					paramMap.put("giveyear", requestBox.get("giveyear"));
					paramMap.put("startdate", requestBox.get("startdate"));
					paramMap.put("starttime", requestBox.get("starttime"));
					paramMap.put("enddate", requestBox.get("enddate"));
					paramMap.put("endtime", requestBox.get("endtime"));
					paramMap.put("smssendflag", requestBox.get("smssendflag"));
					paramMap.put("cnt", svc.selectTargetExcelData(paramMap));
					paramMap.put("giveCnt", svc.selectGiveTargetExcelData(paramMap));
					paramMap.put("scheduleCnt", svc.selectScheduleExcelData(paramMap));
					paramMap.put("groupCdCnt", svc.selectGroupCodeExcelData(paramMap));
					paramMap.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
					
					svc.insertExcelData(paramMap);
		  		} else if( "agree".equals(sPage) ) {
	  				
		  			paramMap.put("fiscalyear"     , requestBox.get("fiscalyear"));
		  			paramMap.put("delegabo_no"    , strData[0]);
					paramMap.put("delegatorabo_no", strData[1]);
					paramMap.put("delegtypecode"  , "1");
					paramMap.put("adminId"       , requestBox.getSession(SessionUtil.sessionAdno));
					
					svc.insertAgreeExcelData(paramMap);					
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
    
    public String[][] excelUpload(UploadItemVO uploadItem, String docBase,  int validColCnt, int requiredColCnt, int startIndexRow, Map<String, Object> paramMap) throws IOException
    {
        String exts = uploadItem.getTargetExts(); // 입력예 : jpg,gif,png
        String tmpFilePath = createTempWhenEmpty(docBase);
        
        String[][] result  = null;
        if(null == tmpFilePath) {
            return null;
        }

        List<MultipartFile> multiFileList = uploadItem.getFileData();
        
        
        for(MultipartFile mpFile : multiFileList) {
            
            if(mpFile.isEmpty()) {
                continue;
            }
            
            InputStream io = null;
            FileOutputStream fos = null;
            String filePathName;
            String upLoadFileName;
            
            if(uploadItem.getName() == null || uploadItem.getName().isEmpty()){
                upLoadFileName = mpFile.getOriginalFilename();
                filePathName = tmpFilePath + "/" + upLoadFileName;
            }else{
                String ext = getExtByStrName(mpFile.getOriginalFilename());
                upLoadFileName = uploadItem.getName() + "." + ext;
                filePathName = tmpFilePath + "/" + upLoadFileName;
            }                             
            try {

                fos = new FileOutputStream(new File(filePathName));
                io = mpFile.getInputStream();
                int readBytes = 0;
                int bufferSize = 1024;
                
                byte[] buffer = new byte[bufferSize];
                while((readBytes = io.read(buffer, 0, bufferSize)) != -1) {
                    fos.write(buffer, 0, readBytes);
                }
                
                fos.close();
                io.close();
                
                fos = null;
                io = null;
                
                
                File tmpFile = new File(filePathName);
                boolean isValidExt = false;
                // 확장자및 체크
                if(null != exts && exts.length() > 0) {
                    List<String> checkExts = Arrays.asList(exts.split(","));
                    String fileExt = getExtByStrName(mpFile.getOriginalFilename());
                    
                    for(String ext : checkExts) {
                        if(ext.length() == 0) { continue; }
                        if(fileExt.equalsIgnoreCase(ext.trim())) {
                            isValidExt = true;
                        }
                    }
                    
                    if(false == isValidExt) {
                        FileUtils.forceDelete(tmpFile); // 임시파일 삭제한다.                       

                    }
                }
                if(isValidExt){
                    result = readExcelFile(filePathName, validColCnt, requiredColCnt, 0, startIndexRow, paramMap) ;
                }
                else{
                    result = new String [1][2] ;
                    result[0][0]="-1";
                    result[0][1]="컬럼이 형식에 맞지 않습니다.<br/> 셀서식을 TEXT형식으로 맞춰 주세요";
                }
                if (tmpFile.exists() ){
                    FileUtils.forceDelete(tmpFile); // 임시파일 삭제한다.
                }               
               
            } catch(IOException e) {
            	result = new String [1][2] ;
                result[0][0]="-1";
                result[0][1]=e.toString();
                e.printStackTrace();

                //throw new AppException(e.toString());
            } finally {
                try {
                    if(fos != null) {
                        fos.close();
                    }
                    if(io != null) {
                        io.close();
                    }
                } catch (IOException e) { }
            }
        }               
        return result;
    }
     
 	/**
 	 * 임시 디렉토리 생성
 	 * @param docBase
 	 * @return
 	 * @throws IOException
 	 */
 	public String createTempWhenEmpty(String docBase) 
 	{
 		StringUtil.uploadPath();
 		if(!docBase.startsWith("/") && !docBase.startsWith("\\")) {
 			docBase = "/" + docBase;
 		}
 		
 		File tmpDir = new File(StringUtil.uploadPath() + docBase);
 		
 		if(!tmpDir.exists()) {
 			if(!tmpDir.mkdirs()){
 				return null;
 			}
 		}
 	
 		return StringUtil.uploadPath() + docBase;
 	}
 	
 	/**
	 * 파일 확장자 가져오기
	 * @param file
	 * @return
	 */
	public String getExtByStrName(String filename) {
		
		String ext = null;
		
		int i = filename.lastIndexOf(".");
		
		if(i > 0 && i < filename.length() - 1) {
			ext = filename.substring(i + 1);
		}
		
		if(ext == null) {
			return "";
		}
		
		return ext;
	}
	
	/**
	 * 엑셀파일을 읽어서 이차원 String 배열에 넣어 return
	 * 
	 * @param filePathName
	 *            읽어들일 Excel 파일의 경로와 이름
	 * @param validColCnt
	 *            원하는 엑셀파일 포맷의 컬럼 수
	 * @param requiredColCnt
	 *            꼭 채워져있어야할 컬럼 수(0부터 requiredColCnt 컬럼까지는 데이터가 꼭 있어야한다.)
	 * @return 읽어들인 결과 String 배열, 에러발생시 null을 return
	 */
	public static String[][] readExcelFile(String pathName, int validColCnt, int requiredColCnt, int chsheet, int startIndexRow, Map<String, Object> paramMap) throws IOException {

		String extension = "";
		int index = -1;

		String[][] resultSet = null;

		index = pathName.lastIndexOf(".");

		if (index != -1) {
			extension = pathName.substring(index + 1, pathName.length());
		} else {
			extension = "";
		}
		// 엑셀 2007 버젼과 이전 버젼의 확장자가 다름
		if (!"".equals(extension) && extension.equalsIgnoreCase("xls")) {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(
					new File(pathName)));
			// 엑셀 파일이 유효한지 체크 한다
			Map<String, String> checkEFV = checkExcelFileValidity(workbook,
					validColCnt, requiredColCnt, chsheet, "", startIndexRow, paramMap);

			int validRow = Integer.parseInt(checkEFV.get("validRow"));

			if (validRow > 0) {
				resultSet = readExcel(workbook, validColCnt, validRow,
						chsheet, startIndexRow);
			} else {
				throw new IOException(checkEFV.get("msg"));
			}
			workbook = null;

		} else if (!"".equals(extension) && extension.equalsIgnoreCase("xlsx")) {
			XSSFWorkbook workbook = null;

			workbook = new XSSFWorkbook(new FileInputStream(new File(pathName)));
			// 엑셀 파일이 유효한지 체크 한다
			Map<String, String> checkEFV = checkExcelFileValidityXL(workbook, validColCnt, requiredColCnt, chsheet, "", startIndexRow, paramMap);

			int validRow = Integer.parseInt(checkEFV.get("validRow"));

			if (validRow > 0) {
				resultSet = readExcel(workbook, validColCnt, validRow,
						chsheet, startIndexRow);
			} else {
				throw new IOException(checkEFV.get("msg"));
			}
			workbook = null;
		}

		return resultSet;
	}
	
	/**
	 * 
	 * @param workbook
	 * @param validColCnt
	 * @param requiredColCnt
	 * @param chsheet
	 * @return int
	 * @throws Exception
	 */
	public static int checkExcelFileValidityXL(XSSFWorkbook workbook, int validColCnt, int requiredColCnt, int chsheet) throws Exception {
		Map<String, String> mp = checkExcelFileValidityXL(workbook, validColCnt, requiredColCnt, chsheet, "", 0, null);
		int result = Integer.parseInt(mp.get("validRow"));
		
		return result;
	}

	/**
	 * 
	 * @param workbook
	 * @param validColCnt
	 * @param requiredColCnt
	 * @param chsheet
	 * @param ckval
	 * @return Map<String, String>
	 * @throws Exception
	 */
	public static Map<String, String> checkExcelFileValidityXL(XSSFWorkbook workbook, int validColCnt, int requiredColCnt,int chsheet, String ckval, int startIndexRow, Map<String, Object> paramMap) {
		// 엑셀파일 핸들링
		XSSFSheet sheet = null;
		Cell cell = null;
		XSSFRow row = null;
		
		String strResult = "";

		Map<String, String> mp = new HashMap<String, String>();

		// 계속 진행 여부
		boolean fKeepGo = true;

		// 유효성 체크 결과
		int result = 0;

		// 필수 컬럼 유효성 체크
		int essentialColCnt = 0;

		sheet = workbook.getSheetAt(chsheet);
		String tt = "";
		
		/** 유효성 체크 파라미터 셋팅
		 * */
		if (sheet.getPhysicalNumberOfRows() == 0
				&& sheet.getRow(0).getPhysicalNumberOfCells() == 0) {
			result = 0;
		} else {
			for (int i = startIndexRow; i < sheet.getPhysicalNumberOfRows(); i++) {
				if (fKeepGo) {
					row = sheet.getRow(i);

					for (int j = 0; j < sheet.getRow(0).getPhysicalNumberOfCells(); j++) {
						cell = row.getCell(j);
						switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
								// tt = "FORMULA value=" +
								// cell.getCellFormula();
								result = -1; // 셀의 형식이 맞지 않음
								fKeepGo = false;
								strResult = "컬럼이 형식에 맞지 않습니다.(수식) \n\n"
										+ "행 : [" + (i + 1) + "] \n\n"
										+ "최대컬럼수 : [" + validColCnt
										+ "], 업로드한엑셀컬럼수 : [" + (j + 1) + "]";
								break;

							case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
								// tt = "NUMERIC value=" +
								// cell.getNumericCellValue();
								tt = String.valueOf(new Double(cell
										.getNumericCellValue()).intValue());
								// result = -1; // 셀의 형식이 맞지 않음
								// fKeepGo = false;
								// strResult = "컬럼이 형식에 맞지 않습니다.(숫자) \n\n" +
								// "행 : [" + (i + 1) + "] \n\n" + "최대컬럼수 : [" +
								// validColCnt + "], 업로드한엑셀컬럼수 : [" + (j + 1)
								// + "]";
								break;

							case HSSFCell.CELL_TYPE_STRING: // 문자
								tt = cell.getStringCellValue();
								break;

							case HSSFCell.CELL_TYPE_BLANK: // 빈칸
								tt = "";
								break;

							case HSSFCell.CELL_TYPE_ERROR: // BYTE
								// tt = "ERROR vALUE=" +
								// cell.getErrorCellValue();
								result = -1; // 셀의 형식이 맞지 않음
								fKeepGo = false;
								strResult = "컬럼이 형식에 맞지 않습니다.(BYTE) \n\n"
										+ "행 : [" + (i + 1) + "] \n\n"
										+ "최대컬럼수 : [" + validColCnt
										+ "], 업로드한엑셀컬럼수 : [" + (j + 1) + "]";
								break;
							default:
						}

						if (j < requiredColCnt) {
							if (tt == null || tt.length() < 1) {
								break;
							}
							essentialColCnt++;
						} else if (j >= validColCnt) {
							if (!tt.equals("")) {
								fKeepGo = false;
								result = -2; // 컬럼수가 형식에 맞지 않음.
								strResult = "컬럼수가 형식에 맞지 않습니다.\n\n"
										+ "행 : [" + (i + 1) + "] \n\n"
										+ "최대컬럼수 : [" + validColCnt
										+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
										+ "]";
								break;
							}
						}
						
						// 업로드 데이터 유효성 체크 ( 사번, 과정키, 과정차수 )
//							if( "02".equals(paramMap.get("excelType")) ) {
//								if( j == 1 ) {
//									// 과정키 검수
//									paramMap.put("lecCd", cell);
//								} else if( j == 21 ) {
//									// 과정키 검수
//									paramMap.put("charger", cell);
//								}
//							}
					}
					if (fKeepGo) {
						if (essentialColCnt == requiredColCnt) {
							result = i + 1;
						} else {
							fKeepGo = false;
							result = -3; // 필수 데이터가 없음.
							strResult = "필수 데이터가 없습니다.\n\n" + "행 : ["
									+ (i + 1) + "] \n\n" + "필요한 컬럼수 : ["
									+ requiredColCnt
									+ "]\n\n 업로드한 엑셀 컬럼수 : ["
									+ essentialColCnt + "]";
							break;
						}
					}
					essentialColCnt = 0;						
				} else {
					break;
				}
			}
		}
			
		mp.put("validRow", String.valueOf(result));
		mp.put("msg", strResult);
		return mp;
	}
	
	public static int checkExcelFileValidity(HSSFWorkbook workbook,
			int validColCnt, int requiredColCnt) throws Exception {
		return checkExcelFileValidity(workbook, validColCnt,
				requiredColCnt, 0);
	}
	
	/**
	 * 엑셀파일 유효성 체크
	 * 
	 * @param workbook
	 *            엑셀 핸들링하기 위한 workbook
	 * @param validColCnt
	 *            원하는 엑셀파일 포맷의 컬럼 수
	 * @param requiredColCnt
	 *            꼭 채워져있어야할 컬럼 수(0부터 requiredColCnt 컬럼까지는 데이터가 꼭 있어야한다.)
	 * @return 체크 결과 int 0 보다 크면 유효한 로우의 맥스 넘버. 0 이면 빈 엑셀파일임. -2 이면 컬럼수가 형식에 맞지
	 *         않음. -3 이면 빈 컬럼이 있는 행이 있음. -4 이면 중간에 빈 행이 있음. -1 이면 로직 에러.
	 */
	// return int
	public static int checkExcelFileValidity(HSSFWorkbook workbook, int validColCnt, int requiredColCnt, int chsheet) throws Exception {
		// 엑셀파일 핸들링
		Map<String, String> mp = checkExcelFileValidity(workbook, validColCnt, requiredColCnt, chsheet, "", 0, null);
		int result = Integer.parseInt(mp.get("validRow"));
		
		return result;
	}

	/**
	 * 
	 * @param workbook
	 * @param validColCnt
	 * @param requiredColCnt
	 * @param chsheet
	 * @param ckval
	 * @return
	 * @throws Exception
	 */
	public static Map<String, String> checkExcelFileValidity(HSSFWorkbook workbook, int validColCnt, int requiredColCnt, int chsheet, String ckval, int startIndexRow, Map<String, Object> paramMap) throws IOException {
    	
		HSSFSheet sheet = null;
		HSSFCell cell = null;
		HSSFRow row = null;

		// 계속 진행 여부
		boolean fKeepGo = true;

		// 유효성 체크 결과
		int result = 0;

		String strResult = "";

		Map<String, String> mp = new HashMap<String, String>();

		// 필수 컬럼 유효성 체크
		int essentialColCnt = 0;

		try {
			sheet = workbook.getSheetAt(chsheet);
			String tt = "";

			if (sheet.getPhysicalNumberOfRows() == 0) {
				result = 0;
			} else {
				for (int i = startIndexRow; i <= sheet.getLastRowNum(); i++) {
					row = sheet.getRow(i);
					if (fKeepGo) {
						for (int j = 0; j < row.getLastCellNum(); j++) {
							cell = row.getCell(j);
							
							if (cell != null) {
								switch (cell.getCellType()) {
								case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
									// tt = "FORMULA value=" +
									// cell.getCellFormula();
									result = -1; // 셀의 형식이 맞지 않음
									fKeepGo = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(수식) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + validColCnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;

								case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
									// tt = "NUMERIC value=" +
									// cell.getNumericCellValue();
									result = -1; // 셀의 형식이 맞지 않음
									fKeepGo = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(숫자) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + validColCnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;

								case HSSFCell.CELL_TYPE_STRING: // 문자
									tt = cell.getStringCellValue();
									break;

								case HSSFCell.CELL_TYPE_BLANK: // 빈칸
									tt = "";
									break;

								case HSSFCell.CELL_TYPE_ERROR: // BYTE
									// tt = "ERROR vALUE=" +
									// cell.getErrorCellValue();
									result = -1; // 셀의 형식이 맞지 않음
									fKeepGo = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(BYTE) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + validColCnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;
								default:
								}
							} else if (j < requiredColCnt) {
								if (tt == null || tt.length() < 1) {
									break;
								}
								essentialColCnt++;
							} else if (j >= validColCnt) {
								if (!tt.equals("")) {

									fKeepGo = false;
									result = -2; // 컬럼수가 형식에 맞지 않음.
									strResult = "컬럼수가 형식에 맞지 않습니다.\n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + validColCnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;
								}
							}
							
						}
						if (fKeepGo) {
							if (essentialColCnt == requiredColCnt) {
								result = i + 1;
							} else {
								fKeepGo = false;
								result = -3; // 필수 데이터가 없음.
								strResult = "필수 데이터가 없습니다.\n\n" + "행 : ["
										+ (i + 1) + "] \n\n" + "필요한 컬럼수 : ["
										+ requiredColCnt
										+ "]\n\n 업로드한 엑셀 컬럼수 : ["
										+ essentialColCnt + "]";
								break;
							}
						}
						essentialColCnt = 0;
					} else {
						break;
					}
				}
			}
		} finally {
			sheet = null;
			cell = null;
		}
		mp.put("validRow", String.valueOf(result));
		mp.put("msg", strResult);
		return mp;
	}
	
	/**
	 * 
	 * @param workbook
	 * @param validColCnt
	 * @param validRowCnt
	 * @param chsheet
	 * @param startIndexRow
	 * @return String[][]
	 */
	public static String[][] readExcel(HSSFWorkbook workbook,
			int validColCnt, int validRowCnt, int chsheet, int startIndexRow) {
		HSSFSheet sheet = null;
		HSSFRow row = null;
		sheet = workbook.getSheetAt(chsheet);
		// 실제 생성 데이터의 행수는 전체 Sheet 내 행 갯수에서 시작지점을 뺀값
		String[][] resultSet = new String[validRowCnt - startIndexRow][validColCnt];

		for (int i = startIndexRow; i < validRowCnt; i++) {
			row = sheet.getRow(i);

			for (int j = 0; j < validColCnt; j++) {
				if (j < sheet.getRow(0).getPhysicalNumberOfCells()) {
					if (row.getCell(j) == null) {
						continue;
					}
					switch (row.getCell(j).getCellType()) {
					case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
//						resultSet[i - startIndexRow][j] = row.getCell(j)
//						.getStringCellValue();
						 resultSet[i- startIndexRow][j] =
						 row.getCell(j).getCellFormula();
						break;

					case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
						resultSet[i- startIndexRow][j] = 
						 String.valueOf(new Double(row.getCell(j).getNumericCellValue()).intValue());
//						 resultSet[i- startIndexRow][j] = "NUMERIC value=" +
//						 row.getCell(j).getNumericCellValue();
						break;

					case HSSFCell.CELL_TYPE_STRING: // 문자
						resultSet[i - startIndexRow][j] = row.getCell(j)
								.getStringCellValue();
						break;

					case HSSFCell.CELL_TYPE_BLANK: // 빈칸
						 resultSet[i- startIndexRow][j] = ""+
						 row.getCell(j).getBooleanCellValue();
						break;

					case HSSFCell.CELL_TYPE_ERROR: // BYTE
						 resultSet[i- startIndexRow][j] = "" +
						 row.getCell(j).getErrorCellValue();
						break;
					default:
					}
				} else {
					resultSet[i - startIndexRow][j] = "";
				}
			}
		}

		sheet = null;
		row = null;
		return resultSet;
	}

	/**
	 * 
	 * @param workbook
	 * @param validColCnt
	 * @param validRowCnt
	 * @param chsheet
	 * @param startIndexRow
	 * @return String[][]
	 */
	public static String[][] readExcel(XSSFWorkbook workbook,
			int validColCnt, int validRowCnt, int chsheet, int startIndexRow) {
		XSSFSheet sheet = null;
		XSSFRow row = null;
		sheet = workbook.getSheetAt(chsheet);
		String[][] resultSet = new String[validRowCnt - startIndexRow][validColCnt];
		for (int i = startIndexRow; i < validRowCnt; i++) {
			row = sheet.getRow(i);

			for (int j = 0; j < validColCnt; j++) {
				if (j < sheet.getRow(0).getPhysicalNumberOfCells()) {
					if (row.getCell(j) == null) {
						break;
					}
					switch (row.getCell(j).getCellType()) {
					case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
						resultSet[i- startIndexRow][j] = 
						 String.valueOf(new Double(row.getCell(j).getNumericCellValue()).intValue());
						break;

					case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
						 resultSet[i- startIndexRow][j] = 
						 String.valueOf(new Double(row.getCell(j).getNumericCellValue()).intValue());
						 
						break;

					case HSSFCell.CELL_TYPE_STRING: // 문자
						resultSet[i - startIndexRow][j] = row.getCell(j)
								.getStringCellValue();
						break;

					case HSSFCell.CELL_TYPE_BLANK: // 빈칸
						resultSet[i- startIndexRow][j] = 
						 String.valueOf(new Double(row.getCell(j).getNumericCellValue()).intValue());
						break;

					case HSSFCell.CELL_TYPE_ERROR: // BYTE
						resultSet[i- startIndexRow][j] = 
						 String.valueOf(new Double(row.getCell(j).getNumericCellValue()).intValue());
						break;
					default:
					}
				} else {
					resultSet[i - startIndexRow][j] = "";
				}
			}
		}
		sheet = null;
		row = null;
		return resultSet;
	}
}
