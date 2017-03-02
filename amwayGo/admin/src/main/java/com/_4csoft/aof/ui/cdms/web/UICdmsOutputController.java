/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

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

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.cdms.service.CdmsChargeService;
import com._4csoft.aof.cdms.service.CdmsOutputService;
import com._4csoft.aof.cdms.service.CdmsProjectService;
import com._4csoft.aof.cdms.service.CdmsSectionService;
import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.FileVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsCommentVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Output : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsOutputController.java
 * @Title : CDMS 산출물
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsOutputController extends BaseController {

	@Resource (name = "CdmsOutputService")
	private CdmsOutputService outputService;

	@Resource (name = "CdmsSectionService")
	private CdmsSectionService sectionService;

	@Resource (name = "CdmsChargeService")
	private CdmsChargeService chargeService;

	@Resource (name = "CdmsProjectService")
	private CdmsProjectService projectService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	/**
	 * 산출물 추가 등록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/insert/json.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		UICdmsOutputVO voOutput = new UICdmsOutputVO();
		requiredSession(req, voOutput);

		Long projectSeq = HttpUtil.getParameter(req, "projectSeq", 0L);
		Long sectionIndex = HttpUtil.getParameter(req, "sectionIndex", 0L);
		voOutput.setProjectSeq(projectSeq);
		voOutput.setSectionIndex(sectionIndex);

		outputService.insertOutput(voOutput);

		mav.addObject("detailOutput", outputService.getDetail(voOutput));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 산출물 및 차시모듈 삭제
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/delete/json.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		UICdmsOutputVO voOutput = new UICdmsOutputVO();
		requiredSession(req, voOutput);

		Long projectSeq = HttpUtil.getParameter(req, "projectSeq", 0L);
		Long sectionIndex = HttpUtil.getParameter(req, "sectionIndex", 0L);
		Long outputIndex = HttpUtil.getParameter(req, "outputIndex", 0L);
		voOutput.setProjectSeq(projectSeq);
		voOutput.setSectionIndex(sectionIndex);
		voOutput.setOutputIndex(outputIndex);

		mav.addObject("success", outputService.deleteOutput(voOutput));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 산출물 상태수정(검수요청, 승인, 반려 처리)
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/status/update.do")
	public ModelAndView updateStatus(HttpServletRequest req, HttpServletResponse res, UICdmsOutputVO output) throws Exception {
		ModelAndView mav = new ModelAndView();

		UICdmsCommentVO comment = new UICdmsCommentVO();
		requiredSession(req, output, comment);
		output.setCompleteYn("CDMS_OUTPUT_STATUS::ACCEPT".equals(output.getOutputStatusCd()) ? "Y" : "N");

		comment.setProjectSeq(output.getProjectSeq());
		comment.setSectionIndex(output.getSectionIndex());
		comment.setOutputIndex(output.getOutputIndex());
		comment.setAutoYn("Y");
		comment.setOutputStatusCd(output.getOutputStatusCd());
		comment.setIp(HttpUtil.getRemoteAddr(req));

		comment.setDescription(output.getAutoDescription());

		outputService.updateOutputStatus(output, comment);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 산출물의 파일 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param output
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/file/detail/popup.do")
	public ModelAndView detailFile(HttpServletRequest req, HttpServletResponse res, UICdmsOutputVO output) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listSection", sectionService.getListByProject(output.getProjectSeq()));
		mav.addObject("listOutput", outputService.getListByProject(output.getProjectSeq()));
		mav.addObject("listCharge", chargeService.getListByProject(output.getProjectSeq()));
		mav.addObject("detailOutput", outputService.getDetail(output));

		// 프로젝트 상세정보
		UICdmsProjectVO project = new UICdmsProjectVO();
		project.setProjectSeq(output.getProjectSeq());
		mav.addObject("detailProject", projectService.getDetail(project));

		String rootPath = "/cdms/" + ((output.getProjectSeq() / 100 + 1) * 100) + "/" + output.getProjectSeq();
		String subPath = Constants.UPLOAD_PATH_FILE + rootPath + "/" + output.getSectionIndex() + "/" + output.getOutputIndex();

		Long moduleIndex = HttpUtil.getParameter(req, "moduleIndex", 0L);
		if (StringUtil.isNotEmpty(moduleIndex)) {
			subPath += "/module" + moduleIndex;
			mav.addObject("moduleIndex", moduleIndex);
		}

		File dir = new File(subPath);
		if (dir.exists() == false) {
			dir.mkdirs();
		}

		mav.addObject("rootPath", rootPath);

		mav.setViewName("/cdms/output/detailOutputFile");
		return mav;
	}

	/**
	 * 산출물의 파일 등록/수정/삭제 화면
	 * 
	 * @param req
	 * @param res
	 * @param output
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/file/edit/popup.do")
	public ModelAndView editFile(HttpServletRequest req, HttpServletResponse res, UICdmsOutputVO output) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listSection", sectionService.getListByProject(output.getProjectSeq()));
		mav.addObject("listOutput", outputService.getListByProject(output.getProjectSeq()));
		mav.addObject("listCharge", chargeService.getListByProject(output.getProjectSeq()));
		mav.addObject("detailOutput", outputService.getDetail(output));
		// 프로젝트 상세정보
		UICdmsProjectVO project = new UICdmsProjectVO();
		project.setProjectSeq(output.getProjectSeq());
		mav.addObject("detailProject", projectService.getDetail(project));

		String rootPath = "/cdms/" + ((output.getProjectSeq() / 100 + 1) * 100) + "/" + output.getProjectSeq();
		String subPath = Constants.UPLOAD_PATH_FILE + rootPath + "/" + output.getSectionIndex() + "/" + output.getOutputIndex();

		Long moduleIndex = HttpUtil.getParameter(req, "moduleIndex", 0L);
		if (StringUtil.isNotEmpty(moduleIndex)) {
			subPath += "/module" + moduleIndex;
			mav.addObject("moduleIndex", moduleIndex);
		}

		File dir = new File(subPath);
		if (dir.exists() == false) {
			dir.mkdirs();
		}

		mav.addObject("rootPath", rootPath);

		mav.setViewName("/cdms/output/editOutputFile");
		return mav;
	}

	/**
	 * 파일목록
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/file/list/json.do")
	public ModelAndView listFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String filepath = HttpUtil.getParameter(req, "filepath", "");
		List<FileVO> fileInfos = new ArrayList<FileVO>();
		if (StringUtil.isNotEmpty(filepath)) {
			List<File> files = FileUtil.list(Constants.UPLOAD_PATH_FILE + filepath);
			if (files != null) {
				FileUtil.sortByName(files);
				for (File file : files) {
					if (file.isDirectory() == true) {
						FileVO fileInfo = new FileVO();
						fileInfo.setSaveName(file.getName());
						fileInfo.setFileSize(file.length());
						fileInfo.setDirectory(file.isDirectory());
						fileInfos.add(fileInfo);
					}
				}
				for (File file : files) {
					if (file.isDirectory() == false) {
						FileVO fileInfo = new FileVO();
						fileInfo.setSaveName(file.getName());
						fileInfo.setFileSize(file.length());
						fileInfo.setDirectory(file.isDirectory());
						fileInfos.add(fileInfo);
					}
				}
			}
		}
		mav.addObject("files", fileInfos);
		mav.addObject("filepath", filepath);
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 파일업로드
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 * 
	 *             /attach/../save.do 패턴 적용함(firefox에서 session 유지가 안되는 문제)
	 */
	@RequestMapping ("/attach/cdms/output/file/upload/json/save.do")
	public ModelAndView uploadFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String filepath = HttpUtil.getParameter(req, "filepath", "");
		String unzipYn = HttpUtil.getParameter(req, "unzipYn", "N");
		if (StringUtil.isEmpty(filepath)) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		File saveFile = null;
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				String path = Constants.UPLOAD_PATH_FILE + filepath + "/" + file.getOriginalFilename();
				saveFile = new File(path);
				file.transferTo(saveFile);

				String extension = "";
				int index = file.getOriginalFilename().lastIndexOf(".");
				if (index > -1) {
					extension = file.getOriginalFilename().substring(index);
				}

				if ("Y".equals(unzipYn) && ".zip".equalsIgnoreCase(extension)) {
					String extractDir = Constants.UPLOAD_PATH_FILE + filepath + "/" + file.getOriginalFilename().substring(0, index) + "/";
					try {
						extractDir = FileUtil.unzip(path, extractDir);
					} catch (IOException e) {
						throw new AofException(Errors.PROCESS_FILE.desc);
					} finally {
						if (saveFile != null && saveFile.exists()) {
							saveFile.delete();
						}
					}
				}
				mav.addObject("success", 1);
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
	 * 파일 / 폴더 삭제
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/file/delete/json.do")
	public ModelAndView deleteFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String filepath = HttpUtil.getParameter(req, "filepath", "");
		boolean success = false;
		try {
			if (StringUtil.isNotEmpty(filepath)) {
				String path = Constants.UPLOAD_PATH_FILE + filepath;
				File file = new File(path);
				if (file != null && file.exists()) {
					if (file.isDirectory()) {
						success = FileUtil.deleteDirectory(path);
					} else {
						success = file.delete();
					}
				}
			}
		} catch (Exception e) {
		}
		mav.addObject("success", success == true ? 1 : 0);
		mav.addObject("deleteOption", HttpUtil.getParameter(req, "deleteOption", ""));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 파일 / 폴더 다운로드
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/output/file/download.do")
	public void downloadFile(HttpServletRequest req, HttpServletResponse res) throws Exception {

		requiredSession(req);

		String filepath = HttpUtil.getParameter(req, "filepath", "");
		String downOption = HttpUtil.getParameter(req, "downOption", "select");
		String rootDonwloadName = HttpUtil.getParameter(req, "rootDonwloadName", "");
		if (StringUtil.isNotEmpty(filepath)) {
			String path = Constants.UPLOAD_PATH_FILE + filepath;
			File file = new File(path);
			if (file != null && file.exists()) {
				File download = null;
				if (file.isDirectory()) {

					String savePath = Constants.UPLOAD_PATH_FILE + Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd") + "/"
							+ StringUtil.getRandomString(20);
					String zipFilePath = savePath + "/" + file.getName() + ".zip";

					List<String> addFilePaths = new ArrayList<String>();
					List<File> list = FileUtil.list(path);
					for (File f : list) {
						addFilePaths.add(f.getAbsolutePath());
					}
					if ("root".equals(downOption) && StringUtil.isNotEmpty(rootDonwloadName)) {
						zipFilePath = savePath + "/" + rootDonwloadName;
					}

					File saveDir = new File(savePath);
					if (saveDir.exists() == false) {
						saveDir.mkdirs();
					}
					download = FileUtil.zip(zipFilePath, addFilePaths, "UTF-8");

				} else {
					download = file;
				}
				if (download != null && download.exists()) {
					FileInputStream fin = null;
					BufferedInputStream bis = null;
					ServletOutputStream sos = null;

					String contentType = "application/octet-stream";
					try {
						res.setContentType(contentType);
						res.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(download.getName(), "UTF-8") + ";");
						if (download.length() > 0) {
							res.setHeader("Content-Length", String.valueOf(download.length()));
						}
						res.setHeader("Content-Type", contentType);
						res.setHeader("Content-Transfer-Encoding", "binary");
						res.setHeader("Pragma", "no-cache");
						res.setHeader("Expires", "0");
						if (download.exists()) {
							fin = new FileInputStream(download);
							bis = new BufferedInputStream(fin);

							sos = res.getOutputStream();
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

				if (file.isDirectory()) {
					if (download != null && download.exists()) {
						download.delete();
					}
				}
			}
		}
	}

}
