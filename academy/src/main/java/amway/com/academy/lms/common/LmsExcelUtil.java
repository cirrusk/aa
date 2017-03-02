package amway.com.academy.lms.common;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Repository;

@Repository("LmsExcelUtil")
public class LmsExcelUtil {
	
	public static Map<String,Object> readExcelFile(String pathName, int validColCnt, int chsheet, int startIndexRow, String colChk, String colTypeChk)
			throws Exception {

		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		
		String extension = "";
		int index = -1;

		index = pathName.lastIndexOf(".");

		if (index != -1) {
			extension = pathName.substring(index + 1, pathName.length());
		} else {
			extension = "";
		}
		
		String[] colChkArr = colChk.split("[,]");
		String[] colTypeChkArr = colTypeChk.split("[,]");
		
		// 엑셀 2007 버젼과 이전 버젼의 확장자가 다름
		String blnakStr = "";
		if (!blnakStr.equals(extension) && extension.equalsIgnoreCase("xls")) {
			
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(new File(pathName)));
			
			resultMap = checkExcelFileValidityRead(workbook, validColCnt, chsheet, "", startIndexRow, colChkArr, colTypeChkArr);
			
			workbook = null;
			

		} else if (!blnakStr.equals(extension) && extension.equalsIgnoreCase("xlsx")) {
			
			XSSFWorkbook workbook = new XSSFWorkbook(new FileInputStream(new File(pathName)));
			
			resultMap = checkExcelFileValidityXLRead(workbook, validColCnt, chsheet, "", startIndexRow, colChkArr, colTypeChkArr);
			
			workbook = null;
		}
		
		//excel File delete
		File excelFile = new File(pathName);
		if( excelFile.isFile() ) {
			excelFile.delete();
		}

		return resultMap;
	}
	
	public static Map<String, Object> checkExcelFileValidityXLRead(
			XSSFWorkbook workbook, int totalColCnt, int chsheet, String ckval, int startIndexRow, String[] colChk, String[] colTypeChk) throws Exception {
    	
		XSSFSheet sheet = null;
		XSSFCell cell = null;
		XSSFRow row = null;

		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String,String>> successList = new ArrayList<Map<String,String>>(); 
		List<Map<String,String>> failList = new ArrayList<Map<String,String>>();
		
			sheet = workbook.getSheetAt(chsheet);

			if( sheet.getLastRowNum() == 0 ) {
				Map<String,String> failMap = new HashMap<String,String>();
				failMap.put("row", "0");
				failMap.put("data", "데이터가 없습니다.");
				failList.add(failMap);
				
				resultMap.put("status", "F");
				resultMap.put("successList", successList);
				resultMap.put("failList", failList);
				
			} else {
				
				int headCellCount = sheet.getRow(0).getLastCellNum();
				
				if( headCellCount != totalColCnt ) {
					Map<String,String> failMap = new HashMap<String,String>();
					failMap.put("row", "0");
					failMap.put("data", "데이터의 컬럼수가 정확하지 않습니다.");
					failList.add(failMap);
				} else {
					//read row
					for (int i = startIndexRow; i <= sheet.getLastRowNum(); i++) {
						row = sheet.getRow(i);
						
						Map<String,String> celMap = new HashMap<String,String>();
						Map<String,String> failMap = new HashMap<String,String>();
						
						celMap.put("row", i+"");
						
						//read col
						boolean colFlag = true;
						int colIdx = 0;
						if( row != null ) {
							for (colIdx = 0; colIdx < totalColCnt; colIdx++) {
								
								String tt = "";
								String colCheckVal = colChk[colIdx];
								String colTypeCheckVal = colTypeChk[colIdx];
								
								if (row.getCell(colIdx) != null) {
									cell = row.getCell(colIdx);
									
									switch (cell.getCellType()) {
										case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
											break;
				
										case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
											tt = String.valueOf(new Double(cell.getNumericCellValue()).intValue());
											break;
				
										case HSSFCell.CELL_TYPE_STRING: // 문자
											tt = cell.getStringCellValue();
											break;
				
										case HSSFCell.CELL_TYPE_BLANK: // 빈칸
											tt = "";
											break;
				
										case HSSFCell.CELL_TYPE_ERROR: // BYTE
											break;
										default:
											break;
									}
								} else {
									tt = "";
								}
								String blankStr = "";
								String yStr = "Y";
								if( yStr.equals(colCheckVal) && blankStr.equals(tt) ) {
									colFlag = false;
									failMap.put("data", (i+1) + " 행 " + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
								} else {
									
									//숫자 타입은 체크할 것
									boolean typeChk = true;
									String iStr = "I";
									if( iStr.equals(colTypeCheckVal) && !fnCheckInteger(tt) ) {
										typeChk = false;
									}
									
									if( typeChk ) {
										celMap.put("col" + colIdx, tt);
									} else {
										colFlag = false;
										failMap.put("data", (i+1) + " 행 " + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
									}
								}
							}
						} else {
							colFlag = false;
							failMap.put("data", (i+1) + " 행 " + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
						}
						
						if( !colFlag ) {
							failList.add(failMap);
						} else {
							successList.add(celMap);
						}
					} // end for row
				}
				int sizeCheck = 0;
				if( failList != null && failList.size() > sizeCheck ) {
					resultMap.put("status", "F");
					resultMap.put("successList", successList);
					resultMap.put("failList", failList);
				} else {
					resultMap.put("status", "S");
					resultMap.put("successList", successList);
					resultMap.put("failList", failList);
				}
			}
			
/*		} catch (Exception e) {
			e.printStackTrace();
			
			resultMap.put("status", "E");
			resultMap.put("successList", successList);
			resultMap.put("failList", failList);
		} finally {
			sheet = null;
			cell = null;
		}*/
		sheet = null;
		cell = null;		
		return resultMap;
	}
	
	public static Map<String, Object> checkExcelFileValidityRead(
			HSSFWorkbook workbook, int totalColCnt, int chsheet, String ckval, int startIndexRow, String[] colChk, String[] colTypeChk) throws Exception {
    	
		HSSFSheet sheet = null;
		HSSFCell cell = null;
		HSSFRow row = null;

		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String,String>> successList = new ArrayList<Map<String,String>>(); 
		List<Map<String,String>> failList = new ArrayList<Map<String,String>>();
		
		/*try {*/
			sheet = workbook.getSheetAt(chsheet);

			if( sheet.getLastRowNum() == 0 ) {
				Map<String,String> failMap = new HashMap<String,String>();
				failMap.put("row", "0");
				failMap.put("data", "데이터가 없습니다.");
				failList.add(failMap);
				
				resultMap.put("status", "F");
				resultMap.put("successList", successList);
				resultMap.put("failList", failList);
				
			} else {
				
				int headCellCount = sheet.getRow(0).getLastCellNum();
				
				if( headCellCount != totalColCnt ) {
					Map<String,String> failMap = new HashMap<String,String>();
					failMap.put("row", "0");
					failMap.put("data", "데이터의 컬럼수가 정확하지 않습니다.");
					failList.add(failMap);
				} else {
					//read row
					for (int i = startIndexRow; i <= sheet.getLastRowNum(); i++) {
						row = sheet.getRow(i);
						
						Map<String,String> celMap = new HashMap<String,String>();
						Map<String,String> failMap = new HashMap<String,String>();
						
						celMap.put("row", i+"");
						
						//read col
						boolean colFlag = true;
						int colIdx = 0;
						if( row != null ) {
							for (colIdx = 0; colIdx < totalColCnt; colIdx++) {
								
								String tt = "";
								String colCheckVal = colChk[colIdx];
								String colTypeCheckVal = colTypeChk[colIdx];
								
								if (row.getCell(colIdx) != null) {
									cell = row.getCell(colIdx);
									
									switch (cell.getCellType()) {
										case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
											break;
				
										case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
											tt = String.valueOf(new Double(cell.getNumericCellValue()).intValue());
											break;
				
										case HSSFCell.CELL_TYPE_STRING: // 문자
											tt = cell.getStringCellValue();
											break;
				
										case HSSFCell.CELL_TYPE_BLANK: // 빈칸
											tt = "";
											break;
				
										case HSSFCell.CELL_TYPE_ERROR: // BYTE
											break;
										default:
											break;
									}
								} else {
									tt = "";
								}
								String yStr = "Y";
								String blankStr = "";
								if( yStr.equals(colCheckVal) && blankStr.equals(tt) ) {
									colFlag = false;
									failMap.put("data", (i+1) + " 행" + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
								} else {
									
									//숫자 타입은 체크할 것
									boolean typeChk = true;
									String iStr = "I";
									if( iStr.equals(colTypeCheckVal) && !fnCheckInteger(tt) ) {
										typeChk = false;
									}
									
									if( typeChk ) {
										celMap.put("col" + colIdx, tt);
									} else {
										colFlag = false;
										failMap.put("data", (i+1) + " 행 " + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
									}
								}
							}
						} else {
							colFlag = false;
							failMap.put("data", (i+1) + " 행 " + ( colIdx + 1) + "번째 데이터가 잘못되었습니다."); 
						}
						
						if( !colFlag ) {
							failList.add(failMap);
						} else {
							successList.add(celMap);
						}
					} // end for row
				}
				int sizeCheck = 0; 
				if( failList != null && failList.size() > sizeCheck ) {
					resultMap.put("status", "F");
					resultMap.put("successList", successList);
					resultMap.put("failList", failList);
				} else {
					resultMap.put("status", "S");
					resultMap.put("successList", successList);
					resultMap.put("failList", failList);
				}
			}
			
		/*} catch (Exception e) {
			e.printStackTrace();
			
			resultMap.put("status", "E");
			resultMap.put("successList", successList);
			resultMap.put("failList", failList);
		} finally {
			sheet = null;
			cell = null;
		}
		*/
		sheet = null;
		cell = null;		
		return resultMap;
	}
	
	public static boolean fnCheckInteger(String inputVal) {
		
		boolean isNumber = true;
		try {
			Integer.parseInt(inputVal);
			
		} catch( NumberFormatException e) {
			isNumber = false;
		}
		
		return isNumber;
	}
}
