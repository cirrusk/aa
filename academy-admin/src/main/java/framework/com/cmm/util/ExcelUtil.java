package framework.com.cmm.util;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * ---------------------------------------------------------Project<br>
 * ---------------------------------------------------------Description<br>
 * Description : Excel 공통 모듈<br>
 * <br>
 * ---------------------------------------------------------JavaDocs<br>
 * 
 * @author KTW<br>
 * @version v1.0<br>
 */
public class ExcelUtil {

	/**
	 * 생성자
	 */
	public ExcelUtil() {
	}

	public static int checkExcelFileValidity(HSSFWorkbook workbook,
			int valid_col_cnt, int required_col_cnt) throws Exception {
		return checkExcelFileValidity(workbook, valid_col_cnt,
				required_col_cnt, 0);
	}

	public static String[][] readExcelFile(String pathName, int valid_col_cnt,
			int required_col_cnt) throws Exception {
		return readExcelFile(pathName, valid_col_cnt, required_col_cnt, 0, 0);
	}

	public static String[][] readExcelFile(String pathName, int valid_col_cnt,
			int required_col_cnt, int chsheet) throws Exception {
		return readExcelFile(pathName, valid_col_cnt, required_col_cnt,
				chsheet, 0);
	}

	// 엑셀다운로드 헤더 셀 스타일
	private HSSFCellStyle headerCellStyle;
	// 엑셀다운로드 데이터 셀 스타일
	private HSSFCellStyle dataCellStyle;

	// 엑셀다운로드 헤더 셀 스타일
	private XSSFCellStyle headerCellStylex;
	// 엑셀다운로드 데이터 셀 스타일
	private XSSFCellStyle dataCellStylex;

	/**
	 * 엑셀파일 유효성 체크
	 * 
	 * @param workbook
	 *            엑셀 핸들링하기 위한 workbook
	 * @param valid_col_cnt
	 *            원하는 엑셀파일 포맷의 컬럼 수
	 * @param required_col_cnt
	 *            꼭 채워져있어야할 컬럼 수(0부터 required_col_cnt 컬럼까지는 데이터가 꼭 있어야한다.)
	 * @return 체크 결과 int 0 보다 크면 유효한 로우의 맥스 넘버. 0 이면 빈 엑셀파일임. -2 이면 컬럼수가 형식에 맞지
	 *         않음. -3 이면 빈 컬럼이 있는 행이 있음. -4 이면 중간에 빈 행이 있음. -1 이면 로직 에러.
	 */
	// return int
	public static int checkExcelFileValidity(HSSFWorkbook workbook,
			int valid_col_cnt, int required_col_cnt, int chsheet)
			throws Exception {
		// 엑셀파일 핸들링
		Map<String, String> mp = checkExcelFileValidity(workbook,
				valid_col_cnt, required_col_cnt, chsheet, "", 0);
		int result = Integer.parseInt(mp.get("validRow"));
		return result;
	}

	/**
	 * 
	 * @param workbook
	 * @param valid_col_cnt
	 * @param required_col_cnt
	 * @param chsheet
	 * @param ckval
	 * @return
	 * @throws Exception
	 */
	public static Map<String, String> checkExcelFileValidity(
			HSSFWorkbook workbook, int valid_col_cnt, int required_col_cnt,
			int chsheet, String ckval, int startIndexRow) throws Exception {

		HSSFSheet sheet = null;
		HSSFCell cell = null;
		HSSFRow row = null;

		// 계속 진행 여부
		boolean f_keep_go = true;

		// 유효성 체크 결과
		int result = 0;

		String strResult = "";

		Map<String, String> mp = new HashMap<String, String>();

		// 필수 컬럼 유효성 체크
		int essential_col_cnt = 0;

		try {
			sheet = workbook.getSheetAt(chsheet);
			String tt = "";

			if (sheet.getPhysicalNumberOfRows() == 0) {
				result = 0;
			} else {
				for (int i = startIndexRow; i <= sheet.getLastRowNum(); i++) {
					row = sheet.getRow(i);
					if (f_keep_go) {
						for (int j = 0; j < row.getLastCellNum(); j++) {
							cell = row.getCell(j);
							if (cell != null) {
								switch (cell.getCellType()) {
								case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
									// tt = "FORMULA value=" +
									// cell.getCellFormula();
									result = -1; // 셀의 형식이 맞지 않음
									f_keep_go = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(수식) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + valid_col_cnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;

								case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
									// tt = "NUMERIC value=" +
									// cell.getNumericCellValue();
									result = -1; // 셀의 형식이 맞지 않음
									f_keep_go = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(숫자) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + valid_col_cnt
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
									f_keep_go = false;
									strResult = "컬럼이 형식에 맞지 않습니다.(BYTE) \n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + valid_col_cnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;
								default:
								}
							} else
								tt = "";

							if (j < required_col_cnt) {
								if (tt == null || tt.length() < 1) {
									break;
								}
								essential_col_cnt++;
							} else if (j >= valid_col_cnt) {
								if (!tt.equals("")) {

									f_keep_go = false;
									result = -2; // 컬럼수가 형식에 맞지 않음.
									strResult = "컬럼수가 형식에 맞지 않습니다.\n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + valid_col_cnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;
								}
							}
						}
						if (f_keep_go) {
							if (essential_col_cnt == required_col_cnt) {
								result = i + 1;
							} else {
								f_keep_go = false;
								result = -3; // 필수 데이터가 없음.
								strResult = "필수 데이터가 없습니다.\n\n" + "행 : ["
										+ (i + 1) + "] \n\n" + "필요한 컬럼수 : ["
										+ required_col_cnt
										+ "]\n\n 업로드한 엑셀 컬럼수 : ["
										+ essential_col_cnt + "]";
								break;
							}
						}
						essential_col_cnt = 0;
					} else {
						break;
					}
				}
			}
		} catch (Exception e) {
			strResult += e.toString();
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
	 * @param valid_col_cnt
	 * @param required_col_cnt
	 * @param chsheet
	 * @return int
	 * @throws Exception
	 */
	public static int checkExcelFileValidityXL(XSSFWorkbook workbook,
			int valid_col_cnt, int required_col_cnt, int chsheet)
			throws Exception {
		Map<String, String> mp = checkExcelFileValidityXL(workbook,
				valid_col_cnt, required_col_cnt, chsheet, "", 0);
		int result = Integer.parseInt(mp.get("validRow"));
		return result;
	}

	/**
	 * 
	 * @param workbook
	 * @param valid_col_cnt
	 * @param required_col_cnt
	 * @param chsheet
	 * @param ckval
	 * @return Map<String, String>
	 * @throws Exception
	 */
	public static Map<String, String> checkExcelFileValidityXL(
			XSSFWorkbook workbook, int valid_col_cnt, int required_col_cnt,
			int chsheet, String ckval, int startIndexRow) throws Exception {
		// 엑셀파일 핸들링
		XSSFSheet sheet = null;
		Cell cell = null;
		XSSFRow row = null;

		String strResult = "";

		Map<String, String> mp = new HashMap<String, String>();

		// 계속 진행 여부
		boolean f_keep_go = true;

		// 유효성 체크 결과
		int result = 0;

		// 필수 컬럼 유효성 체크
		int essential_col_cnt = 0;

		try {
			sheet = workbook.getSheetAt(chsheet);
			String tt = "";

			if (sheet.getPhysicalNumberOfRows() == 0
					&& sheet.getRow(0).getPhysicalNumberOfCells() == 0) {
				result = 0;
			} else {
				for (int i = startIndexRow; i < sheet.getPhysicalNumberOfRows(); i++) {
					if (f_keep_go) {
						row = sheet.getRow(i);

						for (int j = 0; j < sheet.getRow(0)
								.getPhysicalNumberOfCells(); j++) {
							cell = row.getCell(j);
							switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
								// tt = "FORMULA value=" +
								// cell.getCellFormula();
								result = -1; // 셀의 형식이 맞지 않음
								f_keep_go = false;
								strResult = "컬럼이 형식에 맞지 않습니다.(수식) \n\n"
										+ "행 : [" + (i + 1) + "] \n\n"
										+ "최대컬럼수 : [" + valid_col_cnt
										+ "], 업로드한엑셀컬럼수 : [" + (j + 1) + "]";
								break;

							case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
								// tt = "NUMERIC value=" +
								// cell.getNumericCellValue();
								tt = String.valueOf(new Double(cell
										.getNumericCellValue()).intValue());
								// result = -1; // 셀의 형식이 맞지 않음
								// f_keep_go = false;
								// strResult = "컬럼이 형식에 맞지 않습니다.(숫자) \n\n" +
								// "행 : [" + (i + 1) + "] \n\n" + "최대컬럼수 : [" +
								// valid_col_cnt + "], 업로드한엑셀컬럼수 : [" + (j + 1)
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
								f_keep_go = false;
								strResult = "컬럼이 형식에 맞지 않습니다.(BYTE) \n\n"
										+ "행 : [" + (i + 1) + "] \n\n"
										+ "최대컬럼수 : [" + valid_col_cnt
										+ "], 업로드한엑셀컬럼수 : [" + (j + 1) + "]";
								break;
							default:
							}

							if (j < required_col_cnt) {
								if (tt == null || tt.length() < 1) {
									break;
								}
								essential_col_cnt++;
							} else if (j >= valid_col_cnt) {
								if (!tt.equals("")) {
									f_keep_go = false;
									result = -2; // 컬럼수가 형식에 맞지 않음.
									strResult = "컬럼수가 형식에 맞지 않습니다.\n\n"
											+ "행 : [" + (i + 1) + "] \n\n"
											+ "최대컬럼수 : [" + valid_col_cnt
											+ "], 업로드한엑셀컬럼수 : [" + (j + 1)
											+ "]";
									break;
								}
							}
						}
						if (f_keep_go) {
							if (essential_col_cnt == required_col_cnt) {
								result = i + 1;
							} else {
								f_keep_go = false;
								result = -3; // 필수 데이터가 없음.
								strResult = "필수 데이터가 없습니다.\n\n" + "행 : ["
										+ (i + 1) + "] \n\n" + "필요한 컬럼수 : ["
										+ required_col_cnt
										+ "]\n\n 업로드한 엑셀 컬럼수 : ["
										+ essential_col_cnt + "]";
								break;
							}
						}
						essential_col_cnt = 0;
					} else {
						break;
					}
				}
			}
		} catch (Exception e) {
			strResult += e.toString();
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
	 * @param valid_col_cnt
	 * @param valid_row_cnt
	 * @param chsheet
	 * @param startIndexRow
	 * @return String[][]
	 */
	public static String[][] readExcel(HSSFWorkbook workbook,
			int valid_col_cnt, int valid_row_cnt, int chsheet, int startIndexRow) {
		HSSFSheet sheet = null;
		HSSFRow row = null;
		sheet = workbook.getSheetAt(chsheet);
		// 실제 생성 데이터의 행수는 전체 Sheet 내 행 갯수에서 시작지점을 뺀값
		String[][] resultSet = new String[valid_row_cnt - startIndexRow][valid_col_cnt];

		for (int i = startIndexRow; i < valid_row_cnt; i++) {
			row = sheet.getRow(i);

			for (int j = 0; j < valid_col_cnt; j++) {
				if (j < sheet.getRow(0).getPhysicalNumberOfCells()) {
					if (row.getCell(j) == null) {
						continue;
					}
					switch (row.getCell(j).getCellType()) {
					case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
						// resultSet[i- startIndexRow][j] = "FORMULA value=" +
						// row.getCell(j).getCellFormula();
						break;

					case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
						// resultSet[i- startIndexRow][j] = "NUMERIC value=" +
						// row.getCell(j).getNumericCellValue();
						break;

					case HSSFCell.CELL_TYPE_STRING: // 문자
						resultSet[i - startIndexRow][j] = row.getCell(j)
								.getStringCellValue();
						break;

					case HSSFCell.CELL_TYPE_BLANK: // 빈칸
						// resultSet[i- startIndexRow][j] = "BOOLEAN value = " +
						// row.getCell(j).getBooleanCellValue();
						break;

					case HSSFCell.CELL_TYPE_ERROR: // BYTE
						// resultSet[i- startIndexRow][j] = "ERROR vALUE=" +
						// row.getCell(j).getErrorCellValue();
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
	 * @param valid_col_cnt
	 * @param valid_row_cnt
	 * @param chsheet
	 * @param startIndexRow
	 * @return String[][]
	 */
	public static String[][] readExcel(XSSFWorkbook workbook,
			int valid_col_cnt, int valid_row_cnt, int chsheet, int startIndexRow) {
		XSSFSheet sheet = null;
		XSSFRow row = null;
		sheet = workbook.getSheetAt(chsheet);
		String[][] resultSet = new String[valid_row_cnt - startIndexRow][valid_col_cnt];
		for (int i = startIndexRow; i < valid_row_cnt; i++) {
			row = sheet.getRow(i);

			for (int j = 0; j < valid_col_cnt; j++) {
				if (j < sheet.getRow(0).getPhysicalNumberOfCells()) {
					if (row.getCell(j) == null) {
						break;
					}
					switch (row.getCell(j).getCellType()) {
					case HSSFCell.CELL_TYPE_FORMULA: // 수식자체
						// resultSet[i- startIndexRow][j] = "FORMULA value=" +
						// row.getCell(j).getCellFormula();
						break;

					case HSSFCell.CELL_TYPE_NUMERIC:// 숫자
						// resultSet[i- startIndexRow][j] = "NUMERIC value=" +
						// row.getCell(j).getNumericCellValue();
						break;

					case HSSFCell.CELL_TYPE_STRING: // 문자
						resultSet[i - startIndexRow][j] = row.getCell(j)
								.getStringCellValue();
						break;

					case HSSFCell.CELL_TYPE_BLANK: // 빈칸
						// resultSet[i- startIndexRow][j] = "BOOLEAN value = " +
						// row.getCell(j).getBooleanCellValue();
						break;

					case HSSFCell.CELL_TYPE_ERROR: // BYTE
						// resultSet[i- startIndexRow][j] = "ERROR vALUE=" +
						// row.getCell(j).getErrorCellValue();
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
	 * 엑셀파일을 읽어서 이차원 String 배열에 넣어 return
	 * 
	 * @param filePathName
	 *            읽어들일 Excel 파일의 경로와 이름
	 * @param valid_col_cnt
	 *            원하는 엑셀파일 포맷의 컬럼 수
	 * @param required_col_cnt
	 *            꼭 채워져있어야할 컬럼 수(0부터 required_col_cnt 컬럼까지는 데이터가 꼭 있어야한다.)
	 * @return 읽어들인 결과 String 배열, 에러발생시 null을 return
	 */
	public static String[][] readExcelFile(String pathName, int valid_col_cnt,
			int required_col_cnt, int chsheet, int startIndexRow)
			throws Exception {

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
		if (extension != "" && extension.equalsIgnoreCase("xls")) {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(
					new File(pathName)));
			// 엑셀 파일이 유효한지 체크 한다
			Map<String, String> checkEFV = checkExcelFileValidity(workbook,
					valid_col_cnt, required_col_cnt, chsheet, "", startIndexRow);

			int valid_row = Integer.parseInt(checkEFV.get("validRow"));

			if (valid_row > 0) {
				resultSet = readExcel(workbook, valid_col_cnt, valid_row,
						chsheet, startIndexRow);
			} else {
				throw new Exception(checkEFV.get("msg"));
			}
			workbook = null;

		} else if (extension != "" && extension.equalsIgnoreCase("xlsx")) {
			XSSFWorkbook workbook = null;

			workbook = new XSSFWorkbook(new FileInputStream(new File(pathName)));
			// 엑셀 파일이 유효한지 체크 한다
			Map<String, String> checkEFV = checkExcelFileValidityXL(workbook,
					valid_col_cnt, required_col_cnt, chsheet, "", startIndexRow);

			int valid_row = Integer.parseInt(checkEFV.get("validRow"));

			if (valid_row > 0) {
				resultSet = readExcel(workbook, valid_col_cnt, valid_row,
						chsheet, startIndexRow);
			} else {
				throw new Exception(checkEFV.get("msg"));
			}
			workbook = null;
		}

		return resultSet;
	}

	/**
	 * 셀을 만들어서 값을 넣어 전달
	 * 
	 * @param rowData
	 *            행객체
	 * @param style
	 *            셀스타일
	 * @param rownum
	 *            행번호
	 * @param value
	 *            값
	 * @return
	 */
	public void appendCell(HSSFRow rowData, HSSFCellStyle style, int columnNo,
			Object value) {
		HSSFCell tmpCell = rowData.createCell(columnNo);
		tmpCell.setCellStyle(style);
		if (value == null) {
			tmpCell.setCellValue("");
		} else {
			tmpCell.setCellValue(String.valueOf(value));
		}
	}

	/**
	 * 셀을 만들어서 값을 넣어 전달
	 * 
	 * @param rowData
	 *            행객체
	 * @param style
	 *            셀스타일
	 * @param rownum
	 *            행번호
	 * @param value
	 *            값
	 * @return
	 */
	public void appendCell(XSSFRow rowData, XSSFCellStyle style, int columnNo,
			Object value) {
		XSSFCell tmpCell = rowData.createCell(columnNo);
		tmpCell.setCellStyle(style);
		if (value == null) {
			tmpCell.setCellValue("");
		} else {
			tmpCell.setCellValue(String.valueOf(value));
		}
	}

	/**
	 * 엑셀 다운로드 칼럼 헤더 셀 스타일 전달
	 * 
	 * @param workbook
	 * @return
	 */
	public HSSFCellStyle getHeaderCellStyle(HSSFWorkbook workbook) {
		if (headerCellStyle == null) {
			headerCellStyle = workbook.createCellStyle();
			headerCellStyle
					.setFillBackgroundColor(new HSSFColor.GREY_50_PERCENT()
							.getIndex());
			headerCellStyle.setAlignment(headerCellStyle.ALIGN_CENTER);
			headerCellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerCellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
			headerCellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerCellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
			headerCellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerCellStyle.setRightBorderColor(HSSFColor.BLACK.index);
			headerCellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerCellStyle.setTopBorderColor(HSSFColor.BLACK.index);
		}
		return headerCellStyle;
	}

	/**
	 * 엑셀 다운로드 데이터 셀 스타일 전달
	 * 
	 * @param workbook
	 * @return
	 */
	public HSSFCellStyle getDataCellStyle(HSSFWorkbook workbook) {
		if (dataCellStyle == null) {
			dataCellStyle = workbook.createCellStyle();
			dataCellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			dataCellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
			dataCellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			dataCellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
			dataCellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			dataCellStyle.setRightBorderColor(HSSFColor.BLACK.index);
			dataCellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			dataCellStyle.setTopBorderColor(HSSFColor.BLACK.index);
		}
		return dataCellStyle;
	}

	/**
	 * 엑셀 다운로드 칼럼 헤더 셀 스타일 전달
	 * 
	 * @param workbook
	 * @return
	 */
	public XSSFCellStyle getHeaderCellStyle(XSSFWorkbook workbook) {
		if (headerCellStylex == null) {
			headerCellStylex = workbook.createCellStyle();
			XSSFColor myColor = new XSSFColor(java.awt.Color.BLACK);
			headerCellStylex.setFillBackgroundColor(myColor);
			headerCellStylex.setAlignment(headerCellStyle.ALIGN_CENTER);
			headerCellStylex.setBorderBottom(XSSFCellStyle.BORDER_THIN);
			headerCellStylex.setBottomBorderColor(myColor);
			headerCellStylex.setBorderLeft(XSSFCellStyle.BORDER_THIN);
			headerCellStylex.setLeftBorderColor(myColor);
			headerCellStylex.setBorderRight(XSSFCellStyle.BORDER_THIN);
			headerCellStylex.setRightBorderColor(myColor);
			headerCellStylex.setBorderTop(XSSFCellStyle.BORDER_THIN);
			headerCellStylex.setTopBorderColor(myColor);
		}
		return headerCellStylex;
	}

	/**
	 * 엑셀 다운로드 데이터 셀 스타일 전달
	 * 
	 * @param workbook
	 * @return
	 */
	public XSSFCellStyle getDataCellStyle(XSSFWorkbook workbook) {
		if (dataCellStylex == null) {
			dataCellStylex = workbook.createCellStyle();
			dataCellStylex.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			dataCellStylex.setBottomBorderColor(HSSFColor.BLACK.index);
			dataCellStylex.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			dataCellStylex.setLeftBorderColor(HSSFColor.BLACK.index);
			dataCellStylex.setBorderRight(HSSFCellStyle.BORDER_THIN);
			dataCellStylex.setRightBorderColor(HSSFColor.BLACK.index);
			dataCellStylex.setBorderTop(HSSFCellStyle.BORDER_THIN);
			dataCellStylex.setTopBorderColor(HSSFColor.BLACK.index);
		}
		return dataCellStylex;
	}

	/**
	 * 엑셀 다운로드
	 * 
	 * @param workbook
	 * @return
	 */
	public static HSSFWorkbook getExcelExport(
			List<Map<String, String>> excelList, String fileName,
			Map<String, Object> head) {

		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet();
		// 엑셀 시트명 설정
		workbook.setSheetName(0, fileName);
		ExcelUtil eu = new ExcelUtil();
		
		int i = 0;
		HSSFRow row = sheet.createRow(0);

		// 헤더 셀스타일
		HSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);

		// 데이터 셀스타일
		HSSFCellStyle dataCellStyle = eu.getDataCellStyle(workbook);

		// Head 정보
		String[] headName = (String[]) head.get("headName");
		String[] headId = (String[]) head.get("headId");

		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			HSSFCell cell = row.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
		}

		// 데이터 셀 생성
		for (int rowNo = 0; excelList != null && rowNo < excelList.size(); rowNo++) {
			Map<String, String> record = excelList.get(rowNo);
			HSSFRow rowData = sheet.createRow(rowNo + 1);

			int j = 0;

			for (int k = 0; k < headId.length; k++) {
				eu.appendCell(rowData, dataCellStyle, j++,
						record.get(headId[k]));
			}
		}

		return workbook;
	}

	/**
	 * 엑셀 다운로드
	 * 
	 * @param workbook
	 * @return
	 */
	public static HSSFWorkbook getExcelExportObject(
			List<Map<String, Object>> excelList, String fileName,
			Map<String, Object> head) {

		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet();
		// 엑셀 시트명 설정
		workbook.setSheetName(0, fileName);
		ExcelUtil eu = new ExcelUtil();

		
		int i = 0;
		HSSFRow row = sheet.createRow(0);

		// 헤더 셀스타일
		HSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);

		// 데이터 셀스타일
		HSSFCellStyle dataCellStyle = eu.getDataCellStyle(workbook);

		// Head 정보
		String[] headName = (String[]) head.get("headName");
		String[] headId = (String[]) head.get("headId");

		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			HSSFCell cell = row.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
		}

		// 데이터 셀 생성
		for (int rowNo = 0; excelList != null && rowNo < excelList.size(); rowNo++) {
			Map<String, Object> record = excelList.get(rowNo);
			HSSFRow rowData = sheet.createRow(rowNo + 1);

			int j = 0;

			for (int k = 0; k < headId.length; k++) {
				eu.appendCell(rowData, dataCellStyle, j++,
						record.get(headId[k]));
			}
		}

		return workbook;
	}

	/**
	 * 교육비 지급대상자 엑셀양식 다운로드
	 * @param sheetName
	 * @param head
	 * @param type
	 * @return
	 */
	public static XSSFWorkbook getExcelExportObject( String sheetName, Map<String, Object> head, String type) {
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet();
		
		// 엑셀 시트명 설정
		workbook.setSheetName(0, sheetName);
		ExcelUtil eu = new ExcelUtil();

		
		int i = 0;
		XSSFRow row = sheet.createRow(0);
		XSSFRow row1 = sheet.createRow(1);
		XSSFRow row2 = sheet.createRow(2);

		// 헤더 셀스타일
		XSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);

		// 데이터 셀스타일
		XSSFCellStyle dataCellStyle = eu.getDataCellStyle(workbook);

		// Head 정보
		String[] headName = (String[]) head.get("headName");
		String[] bodyName = (String[]) head.get("bodyName");
		
		XSSFCell cell = null;
		
		cell = row.createCell(0);
		cell.setCellStyle(headerCellStyle);
		cell.setCellValue("Calculation ABO");
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 10));
		
		cell = row.createCell(11);
		cell.setCellStyle(headerCellStyle);
		cell.setCellValue("Deposit ABO");
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 11, 12));
		
		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			cell = row1.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
			
			cell = row2.createCell(i);
			cell.setCellStyle(dataCellStyle);
			cell.setCellValue(bodyName[i]);
		}
		
		// 컬럼 사이즈 자동 조절
		sheet.autoSizeColumn(0);

		return workbook;
	}
	
	/**
	 * 교육비 지급대상자 엑셀양식 다운로드
	 * @param sheetName
	 * @param head
	 * @param type
	 * @return
	 */
	public static XSSFWorkbook getExcelExportObjectOneRow( String sheetName, Map<String, Object> head, String type) {
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet();
		
		// 엑셀 시트명 설정
		workbook.setSheetName(0, sheetName);
		ExcelUtil eu = new ExcelUtil();
		
		
		int i = 0;
		XSSFRow row = sheet.createRow(0);
		
		// 헤더 셀스타일
		XSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);
		
		// Head 정보
		String[] headName = (String[]) head.get("headName");
		
		XSSFCell cell = null;
		
		cell = row.createCell(0);
		cell.setCellStyle(headerCellStyle);
		
		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			cell = row.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
		}
		
		// 컬럼 사이즈 자동 조절
		sheet.autoSizeColumn(0);
		
		return workbook;
	}

	/**
	 * 엑셀 다운로드
	 * 
	 * @param workbook
	 * @return
	 */
	public static XSSFWorkbook getExcelExport(List<Map<String, String>> excelList, String fileName, Map<String, Object> head, String type) {
	
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet();
		// 엑셀 시트명 설정
		workbook.setSheetName(0, fileName);
		ExcelUtil eu = new ExcelUtil();

		
		int i = 0;
		XSSFRow row = sheet.createRow(0);

		// 헤더 셀스타일
		XSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);

		// 데이터 셀스타일
		XSSFCellStyle dataCellStyle = eu.getDataCellStyle(workbook);

		// Head 정보
		String[] headName = (String[]) head.get("headName");
		String[] headId = (String[]) head.get("headId");

		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			XSSFCell cell = row.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
		}

		// 데이터 셀 생성
		for (int rowNo = 0; excelList != null && rowNo < excelList.size(); rowNo++) {
			Map<String, String> record = excelList.get(rowNo);
			XSSFRow rowData = sheet.createRow(rowNo + 1);

			int j = 0;

			for (int k = 0; k < headId.length; k++) {
				eu.appendCell(rowData, dataCellStyle, j++,
						record.get(headId[k]));
			}
		}

		return workbook;
	}


	/**
	 * 엑셀 다운로드 교육 숫자를 반대로 해달라는...
	 * 
	 * @param workbook
	 * @return
	 */
	public static XSSFWorkbook getExcelExportCountReverse(List<Map<String, String>> excelList, String fileName, Map<String, Object> head, String type) {
	
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet();
		// 엑셀 시트명 설정
		workbook.setSheetName(0, fileName);
		ExcelUtil eu = new ExcelUtil();

		
		int i = 0;
		XSSFRow row = sheet.createRow(0);

		// 헤더 셀스타일
		XSSFCellStyle headerCellStyle = eu.getHeaderCellStyle(workbook);

		// 데이터 셀스타일
		XSSFCellStyle dataCellStyle = eu.getDataCellStyle(workbook);

		// Head 정보
		String[] headName = (String[]) head.get("headName");
		String[] headId = (String[]) head.get("headId");

		// 칼럼헤더 셀 생성
		for (i = 0; i < headName.length; i++) {
			XSSFCell cell = row.createCell(i);
			cell.setCellStyle(headerCellStyle);
			cell.setCellValue(headName[i]);
		}

		// 데이터 셀 생성
		int size = excelList.size();
		for (int rowNo = 0; excelList != null && rowNo < size; rowNo++) {
			Map<String, String> record = excelList.get(rowNo);
			XSSFRow rowData = sheet.createRow(rowNo + 1);

			int j = 0;

			for (int k = 0; k < headId.length; k++) {
				if(headId[k].equals("NO")){
					eu.appendCell(rowData, dataCellStyle, j++, size - rowNo);
				}else{
					eu.appendCell(rowData, dataCellStyle, j++, record.get(headId[k]));
				}
			}
		}

		return workbook;
	}
	
	
	/**
	 * 출석부 다운로드
	 * 
	 * @param workbook
	 * @return
	 */
	// public static HSSFWorkbook getAttendanceExcelExport(List<Map<String,
	// Object>> excelList){
	//
	// Model model = null;
	// HSSFWorkbook workbook = new HSSFWorkbook();
	// HSSFSheet sheet = workbook.createSheet();
	//
	// // 엑셀 시트명 설정
	// workbook.setSheetName(0, "출석부");
	// ExcelUtil eu = new ExcelUtil();
	//
	// SimpleDateFormat dataFormat = new SimpleDateFormat("yyyy/MM/dd");
	//
	// // HSSFRow row = sheet.createRow(3);
	// //
	// //
	// // sheet.addMergedRegion(new CellRangeAddress((int) 3, (short) 5, (int)
	// 0, (short) 0));
	// // sheet.addMergedRegion(new CellRangeAddress((int) 3, (short) 3, (int)
	// 1, (short) 1));
	// // sheet.addMergedRegion(new CellRangeAddress((int) 4, (short) 4, (int)
	// 1, (short) 1));
	// // sheet.addMergedRegion(new CellRangeAddress((int) 5, (short) 5, (int)
	// 1, (short) 1));
	// //
	// // row.createCell(0).setCellValue(new HSSFRichTextString("연번"));
	// // row.createCell(1).setCellValue(new HSSFRichTextString("날짜"));
	// // row.createCell(2).setCellValue(new HSSFRichTextString("결재"));
	// // row.createCell(3).setCellValue(new HSSFRichTextString("성명"));
	//
	// // 헤더 셀스타일
	// //HSSFCellStyle headerCellStyle = eu.getHeaderCellStyle( workbook );
	//
	// // 데이터 셀스타일
	// //HSSFCellStyle dataCellStyle = eu.getDataCellStyle( workbook );
	//
	// HSSFCell cell = null;
	//
	//
	//
	// // 데이터 셀 생성
	// for ( int rowNo = 0; excelList != null && rowNo < excelList.size();
	// rowNo++) {
	// Map<String, Object> record = excelList.get(rowNo);
	// HSSFRow rowData = sheet.createRow(rowNo+1);
	//
	// int j = 0;
	//
	// // for ( int k = 0; k < headId.length; k++) {
	// // eu.appendCell( rowData, dataCellStyle, j++, record.get(headId[k]));
	// // }
	// }
	//
	// System.out.println("=======================ExcelUtil.java===============================");
	//
	// return workbook;
	// }
}
