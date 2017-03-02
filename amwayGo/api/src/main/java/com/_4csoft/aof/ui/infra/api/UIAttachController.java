/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.api;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com._4csoft.aof.infra.mapper.AttachMapper;
import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UIAttachController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 28.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIAttachController extends UIBaseController {

	@Resource (name = "AttachService")
	private AttachService attachService;

	@Resource (name = "AttachMapper")
	private AttachMapper attachMapper;

	/**
	 * 파일 다운로드
	 * 
	 * @param req
	 * @param res
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping ("/api/attach/file/response/{attachSeq}/{filename}/{saveName}")
	public void fileresponse(HttpServletRequest req, HttpServletResponse res, @PathVariable ("attachSeq") Long attachSeq,
			@PathVariable ("filename") String filename, @PathVariable ("saveName") String saveName) throws Exception {
		checkSession(req);
		filename = StringUtil.decrypt(filename, Constants.ENCODING_KEY);
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

	/**
	 * 앱 다운로드
	 * 
	 * @param req
	 * @param res
	 * @throws Exception
	 */
	@RequestMapping ("/app")
	public void downloadApp(HttpServletRequest req, HttpServletResponse res) throws Exception {

		try {
			String fileName = "LG_Academy.apk";
			File file = new File(Constants.UPLOAD_PATH_FILE + "/app/" + fileName);
			responseFile(res, file, fileName, "application/vnd.android.package-archive");
		} catch (Exception e) {
			// user cancel
		}
	}
}
