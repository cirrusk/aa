package amway.com.academy.lms.common.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.PropertiesReader;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.LmsCommonService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;


@Controller
@RequestMapping("/mobile/lms/common")
public class LmsCommonMobileController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCommonMobileController.class);	

	@Autowired
	LmsUtil lmsUtil;	
	
	@Autowired
	LmsCommonService lmsCommonService;

	public static final String ROOT_UPLOAD_DIR = StringUtil.uploadPath()+ File.separator + "lms";
	
	/**
	 * 파일업로드
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/lmsFileUploadAjax.do")
    public ModelAndView lmsStampSaveAjax(MultipartHttpServletRequest request, ModelAndView mav ) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//세션값 파람에 추가
		String mode = request.getParameter("mode");
		String name = request.getParameter("name");
		String childFolder = "temp";
		if("stamp".equals(mode)){
			childFolder = "stamp";
		}else if("course".equals(mode)){
			childFolder = "course";
		}else if("test".equals(mode)){
			childFolder = "test";
		}else if("excel".equals(mode)){
			childFolder = "excel";
		}
		List<Map<String, Object>> fileInfoList = lmsUtil.setFileMakeToList(request, ROOT_UPLOAD_DIR, childFolder);
		int sizeCheck = 0;
		if(fileInfoList != null && fileInfoList.size() > sizeCheck){
			rtnMap = fileInfoList.get(0);
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  fileInfoList);
		return mav;
    }
	
	/**
	 * 이미지 보기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/imageView.do")
    public void imageView(RequestBox requestBox, HttpServletRequest req, HttpServletResponse res) throws Exception {
		String mode = requestBox.get("mode");
		String file = requestBox.get("file");
		file = file.replaceAll("\\.\\.\\/", "");
		String folder = "temp";
		if("stamp".equals(mode)){
			folder = "stamp";
		}else if("course".equals(mode)){
			folder = "course";
		}else if("test".equals(mode)){
			folder = "test";
		}
		String fileFullPath = ROOT_UPLOAD_DIR+File.separator+folder+File.separator+file;
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
	 * 공통코드 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsCommonCodeListAjax.do")
    public ModelAndView lmsCommonCodeListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		// 리스트
		rtnMap.put("dataList",  lmsCommonService.selectLmsCommonCodeList(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육분류 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsCommonCategoryListAjax.do")
    public ModelAndView lmsCommonCategoryListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("codefield", "categoryid");
		rtnMap.put("codenamefield", "categoryname");
		// 리스트
		rtnMap.put("dataList",  lmsCommonService.selectLmsCategoryCodeList(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육장소강의실 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRoomCodeListAjax.do")
    public ModelAndView lmsRoomCodeListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		// 리스트
		rtnMap.put("dataList",  lmsCommonService.selectLmsRoomCodeList(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	
	// 
	/**
	 * 파일다운로드
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value = "downloadFile.do")
	 public void downloadFile(RequestBox requestBox, HttpServletRequest req, HttpServletResponse res) throws Exception {
		 	PropertiesReader ppt = new PropertiesReader();	
		 
		 	Map<String, Object> resultMap = new HashMap<String, Object>();
		 	String method = requestBox.get("method");
			String mode = requestBox.get("mode");
			String file = requestBox.get("file");
			file = file.replaceAll("\\.\\.\\/", "");
			String userAgent = req.getHeader("User-Agent");
			String name = requestBox.get("name");
			String methodGet = "get";
			String methodOff = "off";
			LOGGER.debug(" ========= downloadFile.do name ========= " + name);
			if(methodGet.equals(method)){
				req.setCharacterEncoding("utf-8");
				name = req.getParameter("name");
				//name = URLDecoder.decode(name, "UTF8");
				LOGGER.debug(" ========= downloadFile.do method name ========= " + method);
			}else if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
				name = new String(name.getBytes("UTF-8"), "ISO-8859-1");
			}else if(methodOff.equals(method)){
				name = "불참사유서.docx";
			}
			
			LOGGER.debug(" ========= downloadFile.do decode name ========= " + name);
			//안드로이드 기기일경우 파일명 인코딩 (한글깨짐방지)
			if (userAgent.indexOf("ANDROID") == -1 &&( userAgent.indexOf("Android") != -1 || userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Chrome")) ) {
				name = URLEncoder.encode(name,"UTF-8").replaceAll("\\+", "%20");
			}else{
				name = new String(name.getBytes("UTF-8"), "ISO-8859-1");
			}
			LOGGER.debug(" ========= downloadFile.do encode name ========= " + name);
			String folder = "temp";
			if("stamp".equals(mode)){
				folder = "stamp";
			}else if("course".equals(mode)){
				folder = "course";
			}else if("test".equals(mode)){
				folder = "test";
			}
			String fileFullPath = ROOT_UPLOAD_DIR+File.separator+folder+File.separator+file;
			File downFile = new File(fileFullPath);
			if(downFile.isFile()){
				int fSize = (int)downFile.length();
				res.setBufferSize(fSize);
				
				String mimetype = "application/force-download";
				//res.setContentType("application/octet-stream");
				try{
					Path source = Paths.get(fileFullPath);
					mimetype = Files.probeContentType(source); 
				}catch (IOException e){
					e.printStackTrace();
					resultMap.put("errCode", "-1");
					resultMap.put("errMsg", ppt.getProperties("errors.file.mimetype.false"));
				}
				// 강제 파일 다운로드를 위해서 마임타입을 변경한다.
				//mimetype = "application/force-download";
				LOGGER.debug(" ========= downloadFile.do mimetype ========= " + mimetype);
				res.setContentType(mimetype);
				res.setContentLength(fSize);
				res.setHeader("Content-Transfer-Encoding", "binary");
				//res.setHeader("Content-Disposition", "attachment; filename=\""+name+"\"");
				if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
					res.setHeader("Content-Disposition", "attachment; filename="+name+"_;");
				}else{
					res.setHeader("Content-Disposition", "attachment; filename="+name+";");
				}
				
				res.setContentLength(fSize);
				FileInputStream ifo = new FileInputStream(downFile);
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
		 * 파일다운로드
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
		 @RequestMapping(value = "downloadFileCourse.do")
		 public void downloadFileCourseData(RequestBox requestBox, HttpServletRequest req, HttpServletResponse res) throws Exception {
			 	PropertiesReader ppt = new PropertiesReader();	
				 
			 	Map<String, Object> resultMap = new HashMap<String, Object>();
			 
			 	String mode = requestBox.get("mode");
				String file = requestBox.get("file");
				file = file.replaceAll("\\.\\.\\/", "");
				String userAgent = req.getHeader("User-Agent");
				String name = requestBox.get("name");

				DataBox courseDataFileInfo = lmsCommonService.selectLmsCourseDataFileInfo(requestBox);
				if(courseDataFileInfo != null){
					name = courseDataFileInfo.getString("name");
				}
				
				LOGGER.debug(" ========= downloadFile.do decode name ========= " + name);
				//안드로이드 기기일경우 파일명 인코딩 (한글깨짐방지)
				if (userAgent.indexOf("ANDROID") == -1 &&( userAgent.indexOf("Android") != -1 || userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Chrome")) ) {
					name = URLEncoder.encode(name,"UTF-8").replaceAll("\\+", "%20");
				}else if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
					name = new String(name.getBytes("UTF-8"), "ISO-8859-1");
				}else{
					name = new String(name.getBytes("UTF-8"), "ISO-8859-1");
				}
				LOGGER.debug(" ========= downloadFile.do encode name ========= " + name);
				String folder = "temp";
				if("stamp".equals(mode)){
					folder = "stamp";
				}else if("course".equals(mode)){
					folder = "course";
				}else if("test".equals(mode)){
					folder = "test";
				}
				String fileFullPath = ROOT_UPLOAD_DIR+File.separator+folder+File.separator+file;
				File downFile = new File(fileFullPath);
				if(downFile.isFile()){
					int fSize = (int)downFile.length();
					res.setBufferSize(fSize);
					
					String mimetype = "application/force-download";
					//res.setContentType("application/octet-stream");
					try{
						Path source = Paths.get(fileFullPath);
						mimetype = Files.probeContentType(source); 
					}catch (IOException e){
						e.printStackTrace();
						resultMap.put("errCode", "-1");
						resultMap.put("errMsg", ppt.getProperties("errors.file.mimetype.false"));
					}
					// 강제 파일 다운로드를 위해서 마임타입을 변경한다.
					//mimetype = "application/force-download";
					LOGGER.debug(" ========= downloadFile.do mimetype ========= " + mimetype);
					res.setContentType(mimetype);
					res.setContentLength(fSize);
					res.setHeader("Content-Transfer-Encoding", "binary");
					//res.setHeader("Content-Disposition", "attachment;filename=\""+name+"\"");
					if (userAgent.indexOf("ANDROID") != -1  ) { // 안드로이드 어플인경우
						res.setHeader("Content-Disposition", "attachment; filename="+name+"_;");
					}else{
						res.setHeader("Content-Disposition", "attachment; filename="+name+";");
					}
					
					res.setContentLength(fSize);
					FileInputStream ifo = new FileInputStream(downFile);
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
	 * 테스트 로그인
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsCommonLoginAjax.do")
    public ModelAndView lmsCommonLoginAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		// 정보검색
		DataBox data = lmsCommonService.selectLmsLogin(requestBox);
		if (data != null && !"".equals(data.get("uid"))){
			rtnMap.put("result", 1);
			rtnMap.put("msg", "로그인 성공");
			
			HttpSession session = requestBox.getHttpSession();
			session.setAttribute("uid", data.get("uid"));
			session.setAttribute("name", data.get("name"));
			session.setAttribute("abotypecode", data.get("abotypecode"));
			session.setAttribute("abotypeorder", data.get("abotypeorder"));
			session.setAttribute("pincode", data.get("pincode"));
			session.setAttribute("pinorder", data.get("pinorder"));
			session.setAttribute("bonuscode", data.get("bonuscode"));
			session.setAttribute("bonusorder", data.get("bonusorder"));
			session.setAttribute("ageorder", data.get("ageorder"));
			session.setAttribute("loacode", data.get("loacode"));
			session.setAttribute("diacode", data.get("diacode"));

			//추천권한
			session.setAttribute("customercode", data.get("customercode"));
			session.setAttribute("consecutivecode", data.get("consecutivecode"));
			//비즈니스상태4개
			session.setAttribute("businessstatuscode1", data.get("businessstatuscode1"));
			session.setAttribute("businessstatuscode2", data.get("businessstatuscode2"));
			session.setAttribute("businessstatuscode3", data.get("businessstatuscode3"));
			session.setAttribute("businessstatuscode4", data.get("businessstatuscode4"));
		}else{
			rtnMap.put("result", 1);
			rtnMap.put("msg", "로그인 실패");
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 세션 없는 경우 페이지 이동
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/session.do")
    public ModelAndView lmsNoSession(RequestBox requestBox, ModelAndView mav) throws Exception {
		return mav;
    }
 
	/**
	 * SNS 카운트 증가하기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsCommonSnsCountAjax.do")
    public ModelAndView lmsCommonSnsCountAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		// 리스트
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		rtnMap.put("cnt",  lmsCommonService.mergeSnsShareCount(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }

	public Map<String,String> lmsCommonHybrisLogin(RequestBox requestBox) throws Exception {
		Map<String,String> returnMap = new HashMap<String,String>();
		
		//앞의 하이브리스에서 넘어온 세션 값을 가지고 콘트롤하기
		String cookieSessionUid = requestBox.getSession("abono"); 		//하이브리스 세션
		String lmsSessionUid = requestBox.getSession("lmsSessionUid");	//lms 세션
		
		//1. 하이브리스에서 넘어온 세션과 lms 자체 세션을 비교하여 회원 정보 읽는 처리
		if( (lmsSessionUid == null || "".equals(lmsSessionUid)) 
			|| (cookieSessionUid == null || "".equals(cookieSessionUid))
			|| (!"".equals(cookieSessionUid) && !cookieSessionUid.equals(lmsSessionUid))
		) {
			// 하이브리스에서 세션 없이 온 경우
			if( "".equals(cookieSessionUid) ) {
				
				HttpSession session = requestBox.getHttpSession();
				session.setAttribute("lmsSessionUid", "NoUser");
				session.setAttribute("lmsUid", "");
			} else {
				
				requestBox.put("uid", cookieSessionUid);
				DataBox data = lmsCommonService.selectLmsLogin(requestBox);
				if (data != null && !"".equals(data.get("uid"))){
					returnMap.put("result", "SUCCESS");
					returnMap.put("resultMsg", "로그인 성공");
					
					HttpSession session = requestBox.getHttpSession();
					session.setAttribute("lmsSessionUid", data.get("uid"));
					session.setAttribute("lmsUid", data.get("uid"));
					session.setAttribute("name", data.get("name"));
					session.setAttribute("abotypecode", data.get("abotypecode"));
					session.setAttribute("abotypeorder", data.get("abotypeorder"));
					session.setAttribute("pincode", data.get("pincode"));
					session.setAttribute("pinorder", data.get("pinorder"));
					session.setAttribute("bonuscode", data.get("bonuscode"));
					session.setAttribute("bonusorder", data.get("bonusorder"));
					session.setAttribute("ageorder", data.get("ageorder"));
					session.setAttribute("loacode", data.get("loacode"));
					session.setAttribute("diacode", data.get("diacode"));
					session.setAttribute("creationtime", data.get("creationtime"));
					
					//추천권한
					session.setAttribute("customercode", data.get("customercode"));
					session.setAttribute("consecutivecode", data.get("consecutivecode"));
					//비즈니스상태4개
					session.setAttribute("businessstatuscode1", data.get("businessstatuscode1"));
					session.setAttribute("businessstatuscode2", data.get("businessstatuscode2"));
					session.setAttribute("businessstatuscode3", data.get("businessstatuscode3"));
					session.setAttribute("businessstatuscode4", data.get("businessstatuscode4"));
					
					//4. 스탬프 접속 처리 및 접속 로그 처리
					requestBox.put("stampid4", LmsCode.stampId4);
					requestBox.put("stampid12", LmsCode.stampId12);
					requestBox.put("stampid24", LmsCode.stampId24);
					requestBox.put("stampid48", LmsCode.stampId48);
					requestBox.put("rtn", "rtn");
					
					lmsCommonService.updateLmsLoginStamp(requestBox);

				}else{
					HttpSession session = requestBox.getHttpSession();
					session.setAttribute("lmsSessionUid", "NoUser");
					session.setAttribute("lmsUid", "");
					returnMap.put("result", "FAIL");
					returnMap.put("resultMsg", "로그인 실패");
				}
			}
		} else {
			returnMap.put("result", "SUCCESS");
			returnMap.put("resultMsg", "로그인 성공");
		}
		
		return returnMap;
    }
}
