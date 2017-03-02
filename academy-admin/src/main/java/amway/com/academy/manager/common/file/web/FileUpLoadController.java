package amway.com.academy.manager.common.file.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.spring.web.servlet.view.JsonView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.file.service.FileUpLoadService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

@Controller
@RequestMapping("/manager/common/trfeefile")
public class FileUpLoadController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUpLoadController.class);
	
	@Autowired
	FileUpLoadService fileUpLoadService;

	/**
	 * 파일 업로드
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value = "/fileUpLoad.do")
	public ModelAndView fileUpLoad(ModelMap model, HttpServletRequest request,MultipartHttpServletRequest multiRequest, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JsonView());
		
		Map<String, String> params = new HashMap<String, String>();
		Map<String,Object> rtn = new HashMap<String,Object>();

		/**
		 * 사용자 정보 셋팅 - Session 
		 */
//		AuthVO authVO = SessionUtils.getCurrentAuth(request);
		params.put("userId", "Session");
		params.put("work", "TRFEE");
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
	    
		if (!files.isEmpty()) {
			rtn = fileUpLoadService.getInsertFile(files, requestBox);
		}
		
		mav.addObject("result", rtn);
		return mav;
	}
	
	/**
	 * 파일 다운로드
	 * @param request
	 * @param response
	 * @param model
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	@RequestMapping(value = "/trfeeFileDownload.do")
	public void fileDownload(HttpServletRequest request, HttpServletResponse response, ModelMap model)  throws FileNotFoundException, IOException, SQLException
	{

		Map<String, Object> fileMap = new HashMap<String, Object>();

		String sWork      = request.getParameter("work");
		String sfileKey   = "";
		String suploadSeq = "";
		
			try {
				if(sWork.equals("TRFEE")||sWork.equals("ADMINTRFEE")) {
					sfileKey = StringUtil.getDecryptStr(request.getParameter("fileKey").toString());
					suploadSeq = StringUtil.getDecryptStr(request.getParameter("uploadSeq").toString());
				} else {
//					sfileKey = request.getParameter("fileKey");
//					suploadSeq = request.getParameter("uploadSeq"); 
					sfileKey = StringUtil.getDecryptStr(request.getParameter("fileKey").toString());
					suploadSeq = StringUtil.getDecryptStr(request.getParameter("uploadSeq").toString()); 
				}
				
				LOGGER.debug(" ============== work : " + request.getParameter("work"));
				LOGGER.debug(" ============== fileKey : " + request.getParameter("fileKey"));
				LOGGER.debug(" ============== uploadSeq : " + request.getParameter("uploadSeq"));

				model.put("work"     , sWork);
				model.put("fileKey"  , sfileKey);
				model.put("uploadSeq", suploadSeq);
					
				fileMap = fileUpLoadService.getSelectFileDetail(model);
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			// fileMap null Cehck
			if(null != fileMap){
			
				String filePath = (String)fileMap.get("filefullurl") + (String)fileMap.get("storefilename");
				String fileName = (String)fileMap.get("realfilename");

				File downloadFile = new File(filePath);
				FileInputStream inStream = new FileInputStream(downloadFile);
		
				// if you want to use a relative path to context root:
//				String relativePath = request.getSession().getServletContext().getRealPath("");
//				LOGGER.debug("relativePath = " + relativePath);
		
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
		
				// forces download
				/*
				String headerKey = "Content-Disposition";
				String headerValue = String.format("attachment; filename=\"%s\"", fileName);
				response.setHeader(headerKey, headerValue);
				
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
				
			}	// fileMap null Cehck

	}
	
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
}
