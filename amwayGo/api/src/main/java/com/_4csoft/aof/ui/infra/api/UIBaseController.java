package com._4csoft.aof.ui.infra.api;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.base.FileVO;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UIBaseController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 16.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBaseController extends BaseController {

	@Resource (name = "CodeService")
	private CodeService codeService;
	private String COMMA_CODE = "&#44;";

	/**
	 * 에러코드 공통 모듈
	 * 
	 * @param resultCode
	 * @return UICodeVO
	 * @throws Exception
	 */
	public UICodeVO getCode(String resultCode) throws Exception {
		List<CodeVO> listCodeCache = codeService.getListCodeCache("ERROR_TYPE");
		UICodeVO codeVO = new UICodeVO();

		for (CodeVO code : listCodeCache) {
			if (code.getCode().equals(resultCode)) {
				codeVO.setCode(code.getCode().split("::")[1]);
				codeVO.setCodeName(code.getCodeName());
			}
		}

		return codeVO;
	}

	/**
	 * 에러코드 공통 모듈
	 * 
	 * @param resultCode
	 * @return UICodeVO
	 * @throws Exception
	 */
	public String getErorrMessage(String resultCode) throws Exception {
		List<CodeVO> listCodeCache = codeService.getListCodeCache("ERROR_TYPE");
		String erorrMessage = null;
		for (CodeVO code : listCodeCache) {
			if (code.getCode().equals("ERROR_TYPE::" + resultCode)) {
				erorrMessage = code.getCodeName();
			}
		}

		return erorrMessage;
	}

	/**
	 * 에러코드 공통 모듈
	 * 
	 * @param resultCode
	 * @return UICodeVO
	 * @throws Exception
	 */
	public String getCodeName(String cd) throws Exception {
		String codeName = "";
		if (!StringUtil.isEmpty(cd)) {
			String codeGroup = cd.split("::")[0];
			List<CodeVO> listCodeCache = codeService.getListCodeCache(codeGroup);
			for (CodeVO code : listCodeCache) {
				if (code.getCode().equals(cd)) {
					codeName = code.getCodeName();
				}
			}

		}

		return codeName;
	}

	/**
	 * 세션 체크
	 * 
	 * @param req
	 * @throws Exception
	 */
	public void checkSession(HttpServletRequest req) throws Exception {
		try {
			requiredSession(req);
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_SESSTION, getErorrMessage(UIApiConstant._INVALID_SESSTION));
		}
	}

	/**
	 * 파일 업로드 정보
	 * 
	 * @param req
	 * @return
	 * @throws Exception
	 */
	public UIAttachVO fileAttach(HttpServletRequest req) throws Exception {
		// parameters
		String extensionYn = HttpUtil.getParameter(req, "extension", "Y"); // 확장자 사용
		UIAttachVO attach = new UIAttachVO();
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

				String saveName = StringUtil.getRandomString(20) + ("N".equals(extensionYn) ? "" : extension);
				String savePath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				File saveDir = new File(Constants.UPLOAD_PATH_FILE + savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}
				saveFile = new File(saveDir.getAbsolutePath() + "/" + saveName);
				
				//파일 복사
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
				attach.setAttachUploadInfo(fileVO.getAttachUploadInfo());
			}

		} catch (Exception e) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			// throw new AofException(Errors.PROCESS_FILE.desc);
		}
		return attach;
	}

}
