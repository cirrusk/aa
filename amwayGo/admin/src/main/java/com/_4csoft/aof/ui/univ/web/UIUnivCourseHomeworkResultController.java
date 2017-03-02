/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseHomeworkCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkRS;
import com._4csoft.aof.univ.service.UnivCourseHomeworkAnswerService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkAnswerVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseHomeworkResultController.java
 * @Title : 과제 결과 컨트롤러
 * @date : 2014. 03. 12.
 * @author : 류정희
 * @descrption : 과제 결과 컨트롤러
 */
@Controller
public class UIUnivCourseHomeworkResultController extends BaseController {

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	@Resource (name = "UnivCourseHomeworkAnswerService")
	private UnivCourseHomeworkAnswerService courseHomeworkAnswerService;

	protected ConfigUtil config = ConfigUtil.getInstance();

	/**
	 * 과제 결과 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/result/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);
		homework.copyShortcut();

		int totalCount = courseHomeworkService.countListHomeworkResult(homework);

		mav.addObject("totalCount", totalCount);
		if (totalCount > 0) {
			mav.addObject("itemList", courseHomeworkService.getListHomeworkResult(homework));
		} else {
			mav.addObject("itemList", null);
		}
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseHomeworkResult/listCourseHomeworkResult");
		return mav;
	}

	/**
	 * 과제 결과 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/result/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);
		homework.copyShortcut();

		mav.addObject("detail", courseHomeworkService.getDetailHomeworkResult(homework));
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseHomeworkResult/detailCourseHomeworkResult");
		return mav;
	}

	/**
	 * 과제 결과 학습자 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/member/list.do")
	public ModelAndView listMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseHomeworkCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", courseHomeworkService.getListHomeworkMember(condition));
		mav.addObject("condition", condition);
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseHomeworkResult/listCourseHomeworkMember");
		return mav;
	}

	/**
	 * 과제 결과 취득점수 저장
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/member/update/list.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		int success = 0;

		if (homework.getHomeworkAnswerSeqs() != null && homework.getHomeworkAnswerSeqs().length > 0) {

			List<UnivCourseHomeworkAnswerVO> updateList = new ArrayList<UnivCourseHomeworkAnswerVO>();
			UnivCourseHomeworkAnswerVO pushData = null;
			String scoreDate = DateUtil.getFormatString(new Date(), config.getString(Constants.CONFIG_FORMAT_DBDATETIME));

			for (int i = 0; i < homework.getHomeworkAnswerSeqs().length; i++) {
				if (!homework.getHomeworkScores()[i].equals(homework.getOldHomeworkScores()[i])) {
					pushData = new UnivCourseHomeworkAnswerVO();
					pushData.setHomeworkAnswerSeq(homework.getHomeworkAnswerSeqs()[i]);
					pushData.setCourseActiveSeq(homework.getCourseActiveSeq());
					pushData.setActiveElementSeq(homework.getActiveElementSeq());
					pushData.setProfCommentMemberSeq(homework.getProfMemberSeq());
					pushData.setHomeworkSeq(homework.getHomeworkSeq());
					pushData.setCourseApplySeq(homework.getCourseApplySeqs()[i]);
					pushData.setOpenYn(homework.getOpenYns()[i]);
					pushData.setRate2(homework.getRate2());
					pushData.setHomeworkScore(homework.getHomeworkScores()[i]);
					pushData.setSendDtime(homework.getSendDtimes()[i]);
					pushData.setScoreDtime(scoreDate);
					requiredSession(req, pushData);
					updateList.add(pushData);
				}
			}

			success = courseHomeworkAnswerService.updatelistHomeworkAnswer(updateList);
		}

		mav.addObject("result", success);
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 학습자 과제 결과 상세 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/member/detail/popup.do")
	public ModelAndView detilMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("answer", courseHomeworkService.getDetailHomeworkMember(homework));
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseHomeworkResult/detailHomeworkMemberPopup");

		return mav;
	}

	/**
	 * 과제결과 수정
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/homework/member/update.do")
	public ModelAndView updateMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework,
			UIUnivCourseHomeworkAnswerVO homeworkAnwser, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homeworkAnwser, attach);
		String scoreDate = DateUtil.getFormatString(new Date(), "yyyyMMddHHmmss");
		homeworkAnwser.setScoreDtime(scoreDate);

		int success = 0;

		if (homeworkAnwser.getHomeworkAnswerSeq() > 0) {
			success = courseHomeworkAnswerService.updateHomeworkAnswer(homeworkAnwser, attach);
		} else {
			success = courseHomeworkAnswerService.insertHomeworkAnswer(homeworkAnwser, attach);
		}

		mav.addObject("result", success);
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 과제결과 첨부파일 일괄 다운로드
	 * 
	 * @param req
	 * @param res
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping ("/univ/course/homework/result/collective/file/response.do")
	public void collectiveFileResponse(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseHomeworkCondition condition)
			throws Exception {

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Paginate<ResultSet> result = courseHomeworkService.getListHomeworkMember(condition);
		UIUnivCourseHomeworkRS homeworkDetail = (UIUnivCourseHomeworkRS)courseHomeworkService.getDetailHomework(homework);

		if (result.getTotalCount() > 0) {

			List<ResultSet> homeworkList = result.getItemList();

			String randomFolder = StringUtil.getRandomString(20);
			String copyDirectory = Constants.UPLOAD_PATH_FILE + "/" + randomFolder;
			String copyFileName = "";
			String targetFileFullPath = "";
			String copyFileFullPath = "";
			String collectiveFileFullPath = "";
			List<String> addFilePaths = new ArrayList<String>();

			try {
				
				for (ResultSet data : homeworkList) {
					UIUnivCourseHomeworkRS homeworkResult = (UIUnivCourseHomeworkRS)data;
	
					if (homeworkResult.getAnswer().getUnviAttachList().size() > 0) {
	
						for (AttachVO fileInfo : homeworkResult.getAnswer().getUnviAttachList()) {
	
							copyFileName = homeworkResult.getMember().getMemberId() + "_" + homeworkResult.getMember().getMemberName() + "_"
									+ fileInfo.getRealName();
							targetFileFullPath = Constants.UPLOAD_PATH_FILE + fileInfo.getSavePath() + "/" + fileInfo.getSaveName();
							copyFileFullPath = copyDirectory + "/" + copyFileName;
	
							FileUtil.createFile(copyDirectory, copyFileName);
							FileUtil.copy(targetFileFullPath, copyFileFullPath);
	
							addFilePaths.add(copyFileFullPath);
						}
					}
				}
	
				String collectiveFileName = homeworkDetail.getCourseHomework().getHomeworkTitle() + ".zip";
				collectiveFileFullPath = Constants.UPLOAD_PATH_FILE + "/" + collectiveFileName;
	
				FileUtil.zip(collectiveFileFullPath, addFilePaths, "UTF-8");
				File collectiveFile = new File(collectiveFileFullPath);
			
				responseFile(res, collectiveFile, collectiveFileName, "application/octet-stream");
				
			} catch (Exception e) {
				
				log.debug("collectiveFileResponse responseFile error : " + e.getMessage());
			
			} finally { 
				try {
					if(StringUtil.isNotEmpty(copyDirectory)){
						FileUtil.deleteDirectory(copyDirectory);
					}
				} catch (Exception e) {
					log.debug("collectiveFileResponse deleteDirectory error : " + e.getMessage());
				}

				try {
					if(StringUtil.isNotEmpty(collectiveFileFullPath)){
						FileUtil.delete(collectiveFileFullPath);
					}
				} catch (Exception e) {
					log.debug("collectiveFileResponse deleteFile error : " + e.getMessage());
				}
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
