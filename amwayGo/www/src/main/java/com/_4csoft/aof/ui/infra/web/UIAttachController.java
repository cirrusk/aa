/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.mapper.AttachMapper;
import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.FileVO;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIAttachController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 22.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIAttachController extends BaseController {

	@Resource (name = "AttachService")
	private AttachService attachService;

	@Resource (name = "AttachMapper")
	private AttachMapper attachMapper;

	private String COMMA_CODE = "&#44;";

	/**
	 * 일반 파일 업로드
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/attach/file/save.do")
	public ModelAndView saveFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		// parameters
		String extensionYn = HttpUtil.getParameter(req, "extension", "Y"); // 확장자 사용

		File saveFile = null;
		FileVO fileVO = new FileVO();
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				fileVO.setFileType(file.getContentType());
				fileVO.setFileSize(file.getSize());
				fileVO.setRealName(file.getOriginalFilename());

				String extension = "";
				int index = fileVO.getRealName().lastIndexOf(".");
				if (index > -1) {
					extension = fileVO.getRealName().substring(index);
				}
				checkFileType(extension);

				String saveName = StringUtil.getRandomString(20) + ("N".equals(extensionYn) ? "" : extension);
				String savePath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				File saveDir = new File(Constants.UPLOAD_PATH_FILE + savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}
				saveFile = new File(saveDir.getAbsolutePath() + "/" + saveName);
				file.transferTo(saveFile);

				fileVO.setSaveName(saveName);
				fileVO.setSavePath(savePath);

				StringBuffer uploadInfo = new StringBuffer();
				uploadInfo.append(fileVO.getFileType()).append(Constants.SEPARATOR);
				uploadInfo.append(fileVO.getFileSize()).append(Constants.SEPARATOR);
				uploadInfo.append(fileVO.getRealName().replaceAll(",", COMMA_CODE)).append(Constants.SEPARATOR);
				uploadInfo.append(fileVO.getSaveName()).append(Constants.SEPARATOR);
				uploadInfo.append(fileVO.getSavePath());
				fileVO.setAttachUploadInfo(uploadInfo.toString());
				mav.addObject("success", 1);
			} else {
				mav.addObject("success", 0);
			}
			mav.addObject("fileInfo", fileVO);

		} catch (Exception e) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			throw new AofException(Errors.PROCESS_FILE.desc);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 미디어 파일 업로드
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/attach/media/save.do")
	public ModelAndView saveMedia(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		File saveFile = null;
		FileVO fileVO = new FileVO();
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				fileVO.setFileType(file.getContentType());
				fileVO.setFileSize(file.getSize());
				fileVO.setRealName(file.getOriginalFilename());

				String extension = "";
				int index = fileVO.getRealName().lastIndexOf(".");
				if (index > -1) {
					extension = fileVO.getRealName().substring(index);
				}
				checkFileType(extension);

				String saveName = StringUtil.getRandomString(20) + extension;
				String savePath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				File saveDir = new File(Constants.UPLOAD_PATH_MEDIA + savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}
				saveFile = new File(saveDir.getAbsolutePath() + "/" + saveName);
				file.transferTo(saveFile);

				fileVO.setSaveName(saveName);
				fileVO.setSavePath(savePath);

				mav.addObject("success", 1);
			} else {
				mav.addObject("success", 0);
			}
			mav.addObject("fileInfo", fileVO);

		} catch (Exception e) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			throw new AofException(Errors.PROCESS_FILE.desc);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 이미지 파일 업로드 - thumbnailWidth, thumbnailHeight가 있으면 해당 크기보다 작은 섬네일을 만든다. thumbnailCrop 이 Y 이면 썸네일 생성시 이미지의 중앙 부분을 crop 한다.
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/attach/image/save.do")
	public ModelAndView saveImage(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		// parameters
		String thumbnailCrop = HttpUtil.getParameter(req, "thumbnailCrop", "N"); // thumbnail 이미지의 crop 여부
		int thumbnailWidth = HttpUtil.getParameter(req, "thumbnailWidth", 0); // thumbnail 이미지 가로 크기
		int thumbnailHeight = HttpUtil.getParameter(req, "thumbnailHeight", 0); // thumbnail 이미지 세로 크기

		File saveFile = null;
		FileVO fileVO = new FileVO();
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				fileVO.setFileType(file.getContentType());
				fileVO.setFileSize(file.getSize());
				fileVO.setRealName(file.getOriginalFilename());

				String extension = "";
				int index = fileVO.getRealName().lastIndexOf(".");
				if (index > -1) {
					extension = fileVO.getRealName().substring(index);
				}
				checkFileType(extension);

				String saveName = StringUtil.getRandomString(20) + extension;
				String savePath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				File saveDir = new File(Constants.UPLOAD_PATH_IMAGE + savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}
				saveFile = new File(saveDir.getAbsolutePath() + "/" + saveName);
				file.transferTo(saveFile);

				String saveFilePath = saveFile.getAbsoluteFile().toString();
				int[] size = FileUtil.imageSize(saveFile.getAbsoluteFile().toString());

				String thumbFilePath = saveFilePath + ".thumb.jpg";
				if ("Y".equals(thumbnailCrop)) {
					FileUtil.cropImageJpg(saveFilePath, thumbFilePath, thumbnailWidth, thumbnailHeight, "center", "center", false);
				} else {
					if (thumbnailWidth > 0 && thumbnailHeight > 0) {
						FileUtil.resizeImageJpg(saveFilePath, thumbFilePath, thumbnailWidth, thumbnailHeight, false);
					} else if (thumbnailWidth > 0) {
						FileUtil.resizeImageJpg(saveFilePath, thumbFilePath, thumbnailWidth, 0, false);
					} else if (thumbnailHeight > 0) {
						FileUtil.resizeImageJpg(saveFilePath, thumbFilePath, 0, thumbnailHeight, false);
					}
				}

				fileVO.setSaveName(saveName);
				fileVO.setSavePath(savePath);
				fileVO.setWidth(size[0]);
				fileVO.setHeight(size[1]);

				mav.addObject("success", 1);
			} else {
				mav.addObject("success", 0);
			}
			mav.addObject("fileInfo", fileVO);

		} catch (Exception e) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			e.printStackTrace();
			throw new AofException(Errors.PROCESS_FILE.desc);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 파일 다운로드
	 * 
	 * @param req
	 * @param res
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping ("/attach/file/response.do")
	public void fileresponse(HttpServletRequest req, HttpServletResponse res) throws Exception {

		// parameters
		String seq = HttpUtil.getParameter(req, "attachSeq", "");
		seq = StringUtil.decrypt(seq, (String)req.getSession().getAttribute(Constants.SECURITY_ENCODING_KEY));
		Long attachSeq = Long.parseLong(seq);

		String filename = HttpUtil.getParameter(req, "filename", "");

		AttachVO attach = (AttachVO)attachMapper.getDetail(attachSeq);

		if (attach != null) {
			try {
				File file = new File(Constants.UPLOAD_PATH_FILE + attach.getSavePath() + "/" + attach.getSaveName());
				responseFile(res, file, StringUtil.isEmpty(filename) ? attach.getRealName() : filename, attach.getFileType());
			} catch (Exception e) {
				// user cancel
			}
		}
	}

	/**
	 * 엑셀파일 업로드 - batch 처리용 - json으로 리턴.
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/attach/excel/save.do")
	public ModelAndView excel(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		File saveFile = null;
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				String extension = "";
				int index = file.getOriginalFilename().lastIndexOf(".");
				if (index > -1) {
					extension = file.getOriginalFilename().substring(index);
				}
				if (".xls".equalsIgnoreCase(extension) == false && ".xlsx".equalsIgnoreCase(extension) == false) {
					throw new AofException(Errors.PROCESS_FILE.desc);
				}

				String saveName = StringUtil.getRandomString(20);
				String savePath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				File saveDir = new File(Constants.UPLOAD_PATH_FILE + savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}
				saveFile = new File(saveDir.getAbsolutePath() + "/" + saveName);
				file.transferTo(saveFile);

				List<List<String>> list = new ArrayList<List<String>>();

				Workbook workbook = null;
				if (".xls".equalsIgnoreCase(extension)) {
					workbook = new HSSFWorkbook(new FileInputStream(saveFile));
				} else if (".xlsx".equalsIgnoreCase(extension)) {
					workbook = new XSSFWorkbook(new FileInputStream(saveFile));
				}

				if (workbook != null) {
					Sheet sheet = workbook.getSheetAt(0);
					if (sheet != null) {
						int startRowIndex = 1;
						int lastRowIndex = sheet.getLastRowNum();
						for (int rowIndex = startRowIndex; rowIndex <= lastRowIndex; rowIndex++) {
							Row row = sheet.getRow(rowIndex);
							if (row != null) {
								List<String> data = new ArrayList<String>();
								data.add(String.valueOf(rowIndex));

								int lastCellIndex = row.getLastCellNum();
								for (int cellIndex = 0; cellIndex <= lastCellIndex; cellIndex++) {
									Cell cell = row.getCell(cellIndex);
									String cellValue = "";
									if (cell != null) {
										switch (cell.getCellType()) {
										case Cell.CELL_TYPE_STRING :
											cellValue = cell.getRichStringCellValue().getString();
											break;
										case Cell.CELL_TYPE_NUMERIC :
											if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)) {
												cellValue = cell.getDateCellValue().toString();
											} else {
												cellValue = String.valueOf(cell.getNumericCellValue());
											}
											break;
										case Cell.CELL_TYPE_BOOLEAN :
											cellValue = String.valueOf(cell.getBooleanCellValue());
											break;
										case Cell.CELL_TYPE_FORMULA :
											cellValue = cell.getCellFormula();
											break;
										default :
											cellValue = "";
										}
									}
									data.add(cellValue);
								}
								list.add(data);
							}
						}
						mav.addObject("success", 1);
						mav.addObject("list", list);
					} else {
						mav.addObject("success", 0);
					}
				}
				if (saveFile != null && saveFile.exists()) {
					saveFile.delete();
				}
			} else {
				mav.addObject("success", 0);
			}

		} catch (Exception e) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			throw new AofException(Errors.PROCESS_FILE.desc);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 파일유형 검사
	 * 
	 * @param filename
	 */
	public void checkFileType(String extension) throws Exception {
		String fileLimitType = config.getString("upload.fileLimitType");
		String[] types = fileLimitType.split(";");
		for (String ext : types) {
			ext = "." + ext.trim();
			if (ext.equalsIgnoreCase(extension)) {
				throw new AofException(Errors.PROCESS_FILE.desc);
			}
		}
	}

	/**
	 * 파일 응답
	 * 
	 * @param response
	 * @param downloadName
	 * @param file
	 * @throws Exception
	 */
	public void responseFile(HttpServletResponse response, File file, String downloadName, String contentType) throws Exception {

		FileInputStream fin = null;
		BufferedInputStream bis = null;
		ServletOutputStream sos = null;

		if (contentType == null || contentType.length() == 0) {
			contentType = "application/octet-stream";
		}
		try {
			response.setContentType(contentType);
			response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(downloadName, "UTF-8") + ";");
			if (file.length() > 0) {
				response.setHeader("Content-Length", String.valueOf(file.length()));
			}
			response.setHeader("Content-Type", contentType);
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Expires", "0");
			if (file.exists()) {
				fin = new FileInputStream(file);
				bis = new BufferedInputStream(fin);

				sos = response.getOutputStream();
				int read = 0;
				while ((read = bis.read()) != -1) {
					sos.write(read);
				}
			}
		} catch (Exception e) {
			throw new AofException(Errors.PROCESS_FILE.desc);
		} finally {
			if (sos != null) {
				sos.close();
			}
			if (bis != null) {
				bis.close();
			}
			if (fin != null) {
				fin.close();
			}
		}

	}

}
