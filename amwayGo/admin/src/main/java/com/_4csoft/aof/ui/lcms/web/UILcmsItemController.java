/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.FileVO;
import com._4csoft.aof.lcms.service.LcmsItemResourceVersionService;
import com._4csoft.aof.lcms.service.LcmsItemService;
import com._4csoft.aof.lcms.vo.LcmsItemVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemResourceVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemResourceVersionVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UIItemController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsItemController extends BaseController {

	protected final String[] TEXT_EXTENSIONS = { "html", "htm", "js", "xml", "xsd", "txt", "css", "dtd" };
	protected final String[] IMAGE_EXTENSIONS = { "jpg", "jpeg", "gif", "png", "bmp" };
	protected final String[] MEDIA_EXTENSIONS = { "mp3", "wav", "mp4", "webm", "wmv", "avi", "mov", "mpg", "mpeg", "swf" };

	@Resource (name = "LcmsItemService")
	private LcmsItemService itemService;

	@Resource (name = "LcmsItemResourceVersionService")
	private LcmsItemResourceVersionService itemResourceVersionService;

	/**
	 * 아이템 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param item
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/item/list/ajax.do")
	public ModelAndView listAjax(HttpServletRequest req, HttpServletResponse res, UILcmsItemVO item) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("itemList", itemService.getList(item.getOrganizationSeq()));

		mav.setViewName("/lcms/item/listItemAjax");

		return mav;
	}

	/**
	 * 아이템 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param organization
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/item/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsItemVO item) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, item);

		List<LcmsItemVO> items = new ArrayList<LcmsItemVO>();
		for (int i = 0; i < item.getItemSeqs().length; i++) {
			UILcmsItemVO o = new UILcmsItemVO();
			o.setItemSeq(item.getItemSeqs()[i]);
			o.setSortOrder(item.getSortOrders()[i]);
			o.setTitle(item.getTitles()[i]);
			if ("COMPLETION_TYPE::PROGRESS".equals(item.getCompletionTypes()[i])) {
				Double completionThreshold = (Double.parseDouble(item.getCompletionThresholds()[i]) / 100);
				o.setCompletionThreshold(completionThreshold.toString());
			} else {
				o.setCompletionThreshold(item.getCompletionThresholds()[i]);
			}
			o.setCompletionType(item.getCompletionTypes()[i]);
			o.copyAudit(item);

			UILcmsItemResourceVO resource = new UILcmsItemResourceVO();
			if (item.getResourceSeqs() != null) {
				resource.setResourceSeq(item.getResourceSeqs()[i]);
			}
			if (item.getHrefs() != null) {
				resource.setHref(item.getHrefs()[i]);
			}
			resource.copyAudit(item);
			o.setItemResource(resource);

			items.add(o);
		}

		if (items.size() > 0) {
			mav.addObject("result", itemService.updatelistItem(items));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 아이템 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param organization
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/item/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UILcmsItemVO item) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, item);

		List<LcmsItemVO> items = new ArrayList<LcmsItemVO>();
		for (String index : item.getCheckkeys()) {
			UILcmsItemVO o = new UILcmsItemVO();
			o.setItemSeq(item.getItemSeqs()[Integer.parseInt(index)]);
			o.copyAudit(item);

			UILcmsItemResourceVO resource = new UILcmsItemResourceVO();
			resource.setResourceSeq(item.getResourceSeqs()[Integer.parseInt(index)]);
			resource.copyAudit(item);

			o.setItemResource(resource);

			items.add(o);
		}

		if (items.size() > 0) {
			mav.addObject("result", itemService.deletelistItem(items));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 리소스관리
	 * 
	 * @param req
	 * @param res
	 * @param item
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/item/resource.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UILcmsItemVO item) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", itemService.getDetail(item));

		mav.setViewName("/lcms/item/resource");

		return mav;
	}

	/**
	 * 리소스파일 목록
	 * 
	 * @param req
	 * @param res
	 * @param item
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/list.do")
	public ModelAndView listresource(HttpServletRequest req, HttpServletResponse res, UILcmsItemVO item) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		List<FileVO> fileInfos = new ArrayList<FileVO>();
		List<FileVO> files = new ArrayList<FileVO>();
		List<File> subfiles = FileUtil.list(Constants.UPLOAD_PATH_LCMS + "/" + item.getFilepath());
		if (subfiles != null) {
			FileUtil.sortByName(subfiles);
			for (File file : subfiles) {
				if (file.getName().endsWith(".ver") == false && file.getName().endsWith(".tmp") == false) {
					FileVO fileInfo = new FileVO();
					fileInfo.setSaveName(file.getName());
					fileInfo.setFileSize(file.length());
					fileInfo.setDirectory(file.isDirectory());
					if (file.isDirectory()) {
						fileInfos.add(fileInfo);
					} else {
						files.add(fileInfo);
					}
				}
			}
			fileInfos.addAll(files);
		}
		mav.addObject("files", fileInfos);
		mav.addObject("filepath", item.getFilepath());
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 리소스파일 상세정보. 버전목록 포함.
	 * 
	 * @param req
	 * @param res
	 * @param itemResourceVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/detail/iframe.do")
	public ModelAndView detailresource(HttpServletRequest req, HttpServletResponse res, UILcmsItemResourceVersionVO itemResourceVersion) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		int index = itemResourceVersion.getHrefOriginal().lastIndexOf(".");
		String extension = "";
		if (index > -1) {
			extension = itemResourceVersion.getHrefOriginal().substring(index + 1).toLowerCase();
		}
		List<String> listTexts = (List<String>)Arrays.asList(TEXT_EXTENSIONS);
		List<String> listImgs = (List<String>)Arrays.asList(IMAGE_EXTENSIONS);
		List<String> listMedias = (List<String>)Arrays.asList(MEDIA_EXTENSIONS);
		if (listTexts.contains(extension)) {
			try {
				String encoding = StringUtil.isEmpty(itemResourceVersion.getEncoding()) ? "utf-8" : itemResourceVersion.getEncoding();
				String filedata = FileUtil.read(Constants.UPLOAD_PATH_LCMS + "/" + itemResourceVersion.getHrefOriginal(), encoding);
				mav.addObject("filedata", filedata);
			} catch (IOException e) {
				throw new AofException(Errors.PROCESS_FILE.desc);
			}
			mav.addObject("filetype", "text");
		} else if (listImgs.contains(extension)) {
			mav.addObject("filetype", "img");
		} else if (listMedias.contains(extension)) {
			mav.addObject("filetype", "media");
		} else {
			File file = new File(Constants.UPLOAD_PATH_LCMS + "/" + itemResourceVersion.getHrefOriginal());
			if (file.isDirectory()) {
				mav.addObject("filetype", "dir");
			} else {
				mav.addObject("filetype", "object");
			}
		}
		mav.addObject("extension", extension);

		mav.addObject("versionList", itemResourceVersionService.getList(itemResourceVersion.getResourceSeq(), itemResourceVersion.getHrefOriginal()));
		mav.addObject("detail", itemResourceVersion);

		mav.setViewName("/lcms/resource/detailResourceIframe");
		return mav;
	}

	/**
	 * 리소스파일 새로운 버전 insert
	 * 
	 * @param req
	 * @param res
	 * @param itemResourceVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/insertversion.do")
	public ModelAndView updateversion(HttpServletRequest req, HttpServletResponse res, UILcmsItemResourceVersionVO itemResourceVersion) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, itemResourceVersion);

		itemResourceVersion.setTextExtensions(TEXT_EXTENSIONS);
		mav.addObject("result", itemResourceVersionService.insertItemResourceVersion(itemResourceVersion));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 리소스파일 이전버전으로 복원
	 * 
	 * @param req
	 * @param res
	 * @param itemResourceVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/updaterevert.do")
	public ModelAndView updaterevert(HttpServletRequest req, HttpServletResponse res, UILcmsItemResourceVersionVO itemResourceVersion) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, itemResourceVersion);

		mav.addObject("result", itemResourceVersionService.updateRevertItemResourceVersion(itemResourceVersion));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 리소스 파일 업로드. 새로 업로드 된 파일을 마지막버전의 tmp로 저장한다.
	 * 
	 * @param req
	 * @param res
	 * @param itemResourceVersion
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/filesave.do")
	public ModelAndView filesave(HttpServletRequest req, HttpServletResponse res, UILcmsItemResourceVersionVO itemResourceVersion) throws Exception {
		ModelAndView mav = new ModelAndView();

		if (StringUtil.isEmpty(itemResourceVersion.getHrefOriginal())) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		if (StringUtil.isEmpty(itemResourceVersion.getVersion())) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		File saveFile = null;
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				String path = Constants.UPLOAD_PATH_LCMS + "/";
				String backup = itemResourceVersion.getHrefOriginal() + "." + itemResourceVersion.getVersion() + ".tmp";

				saveFile = new File(path + backup);
				file.transferTo(saveFile);

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
	 * 리소스 파일 업로드. 새로운 파일을 업로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView - json
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/newfile.do")
	public ModelAndView newfile(HttpServletRequest req, HttpServletResponse res, UILcmsItemResourceVersionVO itemResourceVersion) throws Exception {
		ModelAndView mav = new ModelAndView();

		String dir = HttpUtil.getParameter(req, "dir", "");
		if (StringUtil.isEmpty(dir)) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		File saveFile = null;
		try {
			MultipartRequest multipart = (MultipartRequest)req;
			MultipartFile file = multipart.getFile("FileData");

			if (file != null && file.getSize() > 0) {
				String path = Constants.UPLOAD_PATH_LCMS + "/" + dir + "/" + file.getOriginalFilename();
				saveFile = new File(path);
				file.transferTo(saveFile);

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
	 * 리소스 파일 업로드. 새로운 파일을 업로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/resource/newfolder.do")
	public ModelAndView newFolder(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String dir = HttpUtil.getParameter(req, "dir", "");
		String folderName = HttpUtil.getParameter(req, "folderName", "");
		if (StringUtil.isEmpty(dir)) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		if (StringUtil.isEmpty(folderName)) {
			throw new AofException(Errors.DATA_REQUIRED.desc);
		}
		try {
			File targetDir = new File(Constants.UPLOAD_PATH_LCMS + "/" + dir);
			if (targetDir.exists() && targetDir.isDirectory()) {
				File newFolder = new File(Constants.UPLOAD_PATH_LCMS + "/" + dir + "/" + folderName);
				newFolder.mkdir();
			}
		} catch (Exception e) {
			throw new AofException(Errors.PROCESS_FILE.desc);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 리소스 파일 생성
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView - json
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping ("/lcms/create/resource/file/response.do")
	public ModelAndView createResourceFileResponse(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String targetBasePath = Constants.UPLOAD_PATH_LCMS + "/";
		String targetFileFullPath = targetBasePath + req.getParameter("downPath");
		String zipFileFullPath = targetBasePath + StringUtil.getRandomString(20);

		List<String> addFilePaths = new ArrayList<String>();
		List<File> fileList = FileUtil.list(targetFileFullPath);

		for (File data : fileList) {
			addFilePaths.add(data.getAbsolutePath());
		}

		FileUtil.zip(zipFileFullPath, addFilePaths, "UTF-8");

		mav.addObject("fileFullPath", zipFileFullPath);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 리소스 다운로드
	 * 
	 * @param req
	 * @param res
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping ("/lcms/resource/file/response.do")
	public void resourceFileResponse(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String fileFullName = req.getParameter("fileFullName") + ".zip";
		String fileFullPath = req.getParameter("fileFullPath");

		File responseFile = new File(fileFullPath);

		try {
			responseFile(res, responseFile, fileFullName, "application/octet-stream");
		} catch (Exception e) {
			log.debug("resourceFileResponse responseFile error : " + e.getMessage());
		}

		try {
			FileUtil.delete(fileFullPath);
		} catch (Exception e) {
			log.debug("resourceFileResponse deleteFile error : " + e.getMessage());
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
