package amway.com.academy.manager.lms.common.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.lms.common.LmsUtil;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;



@Controller
@RequestMapping("/manager/lms/common")
public class LmsCommonController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCommonController.class);	

	@Autowired
	LmsUtil lmsUtil;	
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	public static final String ROOT_UPLOAD_DIR = StringUtil.uploadPath()+ File.separator + "lms";
	
	//검색 조건의 회원타입 abo회원의 기본 값으로 TARGETCODE의 ABOTYPE의 ABO회원의 TARGETCODESEQ값을 맞게 세팅해야 함
	public static final String ABOTYPECODE_BAISC = "I";
	public static final String ABOTYPECODE_BAISC_VALUE = "3";

	// 배너용
	public static final String BANNER_ABOTYPECODE_BAISC = "N";
	public static final String BANNER_ABOTYPECODE_BAISC_VALUE = "1";
	
	/**
	 * 파일업로드
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsFileUploadAjax.do")
    public ModelAndView lmsStampSaveAjax(MultipartHttpServletRequest request, ModelAndView mav ) throws Exception {
		//세션값 파람에 추가
		String mode = request.getParameter("mode");
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
		rtnMap.put("compliancefield", "complianceflag");
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
			String mode = requestBox.get("mode");
			String file = requestBox.get("file");
			file = file.replaceAll("\\.\\.\\/", "");
			String name = requestBox.get("name");
			name = URLEncoder.encode(name, "UTF-8");
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
				res.setContentType("text/html");
				res.setHeader("Content-Disposition", "attachment; filename="+name+";");
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

	 
	 
}


