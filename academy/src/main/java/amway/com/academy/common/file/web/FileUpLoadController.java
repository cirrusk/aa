package amway.com.academy.common.file.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.file.service.FileUpLoadService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

@Controller
@RequestMapping("/trfee/common/file")
public class FileUpLoadController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory
			.getLogger(FileUpLoadController.class);

	@Autowired
	FileUpLoadService fileUpLoadService;

	/**
	 * 파일 업로드( 모바일 전용 API )
	 * 
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileUpLoad.do")
	public ModelAndView fileUpLoad(ModelMap model, HttpServletRequest request, MultipartHttpServletRequest multiRequest, RequestBox requestBox) throws Exception {
		ModelAndView mav = new ModelAndView(new JSONView());

		Map<String, Object> rtn = new HashMap<String, Object>();
		/**
		 * 사용자 정보 셋팅 - Session
		 */
		// AuthVO authVO = SessionUtils.getCurrentAuth(request);
		requestBox.put("userId", requestBox.getSession("abono"));
		requestBox.put("work", "TRFEE");

		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		
		if (!files.isEmpty()) {
			rtn = fileUpLoadService.getInsertFile(files, requestBox);
		}

		mav.addObject("JSON_OBJECT", rtn);

		return mav;
	}

	/**
	 * 파일 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	@RequestMapping(value = "/fileDownload.do")
	public void fileDownload(RequestBox requestBox, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws FileNotFoundException, IOException, SQLException {
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		model.put("work"     , "TRFEE");
		model.put("fileKey"  , request.getParameter("fileKey"));
		model.put("uploadSeq", request.getParameter("uploadSeq"));
		model.put("depaboNo" , requestBox.getSession("abono"));

			try {
				fileMap = fileUpLoadService.getSelectFileDetail(model);
			} catch (SQLException e) {
				e.printStackTrace();
			}

			// fileMap null Cehck
			if (null != fileMap) {

				String filePath = (String) fileMap.get("filefullurl") + (String) fileMap.get("storefilename");
				String fileName = (String) fileMap.get("realfilename");

				File downloadFile = new File(filePath);
				FileInputStream inStream = new FileInputStream(downloadFile);

				// obtains ServletContext
				ServletContext context = request.getSession().getServletContext();

				// gets MIME type of the file
				String mimeType = context.getMimeType(filePath);
				if (mimeType == null) {
					// set to binary type if MIME mapping not found
					mimeType = "application/octet-stream";
				}

				// modifies response
				String header = getBrowser(request);
				if (header.contains("MSIE")) {
					String docName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
					response.setHeader("Content-Disposition","attachment;filename=" + docName + ";");
				} else if (header.contains("Firefox")) {
					String docName = new String(fileName.getBytes("UTF-8"),"ISO-8859-1");
					response.setHeader("Content-Disposition","attachment; filename=\"" + docName + "\"");
				} else if (header.contains("Opera")) {
					String docName = new String(fileName.getBytes("UTF-8"),"ISO-8859-1");
					response.setHeader("Content-Disposition","attachment; filename=\"" + docName + "\"");
				} else if (header.contains("Chrome")) {
					String docName = new String(fileName.getBytes("UTF-8"),"ISO-8859-1");
					response.setHeader("Content-Disposition","attachment; filename=\"" + docName + "\"");
				} else if(header.contains("Android")) {
					String docName = new String(fileName.getBytes("UTF-8"),"ISO-8859-1");
					response.setHeader("Content-Disposition","attachment; filename=" + docName + "_;");
				}
				
				response.setHeader("Content-Type", "application/octet-stream");
				response.setHeader("Pragma", "no-cache;");
				response.setHeader("Expires", "-1;");
				
				response.setContentLength((int) downloadFile.length());
				response.setBufferSize((int) downloadFile.length());
				response.setHeader("Content-Transfer-Encoding", "binary;");

				response.setContentType(mimeType);
				response.setContentLength((int) downloadFile.length());

				// forces download
				/*
				 * String headerKey = "Content-Disposition"; String headerValue
				 * = String.format("attachment; filename=\"%s\"", fileName);
				 * response.setHeader(headerKey, headerValue);
				 */

				// obtains response's output stream
				ServletOutputStream outStream = response.getOutputStream();

				byte[] buffer = new byte[1024];
				int bytesRead = -1;

				while ((bytesRead = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, bytesRead);
				}

				inStream.close();
				outStream.close();
			} // fileMap null Cehck
	}
	
	/**
	 * 모바일파일다운로드
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mobile/fileDownload.do")
	 public void downloadFileCourseData(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		Map<String, Object> fileMap = new HashMap<String, Object>();
		String userAgent = request.getHeader("User-Agent");
		
		model.put("work", "TRFEE");
		model.put("fileKey", request.getParameter("fileKey"));
		model.put("uploadSeq", request.getParameter("uploadSeq"));

		try {
			fileMap = fileUpLoadService.getSelectFileDetail(model);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// fileMap null Cehck
		if (null != fileMap) {
			String filePath = (String) fileMap.get("filefullurl") + (String) fileMap.get("storefilename");
			String fileName = (String) fileMap.get("realfilename");

			File downloadFile = new File(filePath);
			FileInputStream inStream = new FileInputStream(downloadFile);
			
			//안드로이드 기기일경우 파일명 인코딩 (한글깨짐방지)
			if (userAgent.indexOf("ANDROID") == -1 &&( userAgent.indexOf("Android") != -1 || userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Chrome")) ) {
				fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
			}else if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			}else{
				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			if(downloadFile.isFile()){
				int fSize = (int)downloadFile.length();
				response.setBufferSize(fSize);
				
				String mimetype = "application/force-download";
				try{
					Path source = Paths.get(filePath);
					mimetype = Files.probeContentType(source); 
				}catch (IOException e){
					e.printStackTrace();
				}
								
				response.setContentType(mimetype);
				response.setContentLength(fSize);
				response.setHeader("Content-Transfer-Encoding", "binary");

				if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
					response.setHeader("Content-Disposition", "attachment; filename="+fileName+"_;");
				}else{
					response.setHeader("Content-Disposition", "attachment; filename="+fileName+";");
				}
				
				response.setContentLength(fSize);
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				byte[] buf = new byte[1024];
				int readlength = 0;
				while((readlength = inStream.read(buf)) != -1){
					baos.write(buf, 0, readlength);
				}
				byte[] imgbuf = null;
				imgbuf = baos.toByteArray();
				baos.close();
				inStream.close();
				
				int length = imgbuf.length;
				OutputStream out = response.getOutputStream();
				out.write(imgbuf, 0, length);
				out.close();
			}
		}
	 }
	
	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		
		if(header.contains("ANDROID") || header.contains("Android")) {
			if(header.contains("AMWAY") || header.contains("amway")) {
				return "Android";
			} else {
				return "Chrome";
			}
		} else {
			if (header.contains("MSIE") || header.contains("TRIDENT") || header.contains("Trident")) {
				return "MSIE";
			} else if (header.contains("Chrome")) {
				return "Chrome";
			} else if (header.contains("Opera")) {
				return "Opera";
			}
		}
			
		return "Firefox";
	}

}
