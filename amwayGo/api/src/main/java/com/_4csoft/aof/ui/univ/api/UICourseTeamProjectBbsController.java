/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.service.CommentService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.dto.CommentDTO;
import com._4csoft.aof.ui.board.dto.HelpdeskBbsDTO;
import com._4csoft.aof.ui.board.vo.condition.UICommentCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.board.vo.resultset.UICommentRS;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.univ.dto.AttachDTO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseTeamProjectBbsCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectBbsRS;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectBbsService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMutualevalService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseTeamProjectBbsController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 23.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseTeamProjectBbsController extends UIBaseController {
	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService univCourseTeamProjectService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService univCourseTeamProjectTeamService;

	@Resource (name = "UnivCourseTeamProjectMutualevalService")
	private UnivCourseTeamProjectMutualevalService univCourseTeamProjectMutualevalService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	private final String BOARD_REFERENCE_TYPE = "teamproject";

	@Resource (name = "UnivCourseTeamProjectBbsService")
	private UnivCourseTeamProjectBbsService bbsService;

	@Resource (name = "CommentService")
	private CommentService commentService;

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(Long referenceSeq) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference(BOARD_REFERENCE_TYPE, referenceSeq, "BOARD_TYPE::" + BOARD_REFERENCE_TYPE.toUpperCase());
	}

	/**
	 * 강의실의 팀 프로젝트 게시판목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/bbs/teamproject/list")
	public ModelAndView listTeamProjectBbs(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		String resultCode = UIApiConstant._SUCCESS_CODE;
		UIUnivCourseTeamProjectBbsCondition condition = new UIUnivCourseTeamProjectBbsCondition();

		UIUnivCourseTeamProjectTeamVO projectTeam = new UIUnivCourseTeamProjectTeamVO();
		projectTeam.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		projectTeam.setCourseTeamSeq(Long.parseLong(req.getParameter("courseTeamSeq")));
		projectTeam.setCourseTeamProjectSeq(Long.parseLong(req.getParameter("courseTeamProjectSeq")));

		requiredSession(req, projectTeam);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 팀프로젝트 상세 정보
		// mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		int totalRowCount = 0;
		UIBoardRS detailBoard = getDetailBoard(projectTeam.getCourseActiveSeq());

		List<HelpdeskBbsDTO> items = new ArrayList<HelpdeskBbsDTO>();
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			condition.setSrchBoardSeq(boardSeq);
			condition.setSrchCourseActiveSeq(projectTeam.getCourseActiveSeq());
			condition.setSrchCourseTeamProjectseq(projectTeam.getCourseTeamProjectSeq());
			condition.setSrchCourseTeamSeq(projectTeam.getCourseTeamSeq());
			condition.setSrchWord(req.getParameter("srchWord"));
			condition.setSrchKey(req.getParameter("srchKey"));
			condition.setSrchSecretYn(HttpUtil.getParameter(req, "srchSecretYn"));

			// 검색조건 값이 있으면 searchYn을 셋팅.
			if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
				condition.setSrchSearchYn("Y");
			}

			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				condition.setSrchSearchYn("Y");
			}

			Paginate<ResultSet> paginate = bbsService.getList(condition);
			if (paginate != null) {
				totalRowCount = paginate.getTotalCount();

				for (ResultSet rs : paginate.getItemList()) {
					UIUnivCourseTeamProjectBbsRS courseTeamProjectBbsRS = (UIUnivCourseTeamProjectBbsRS)rs;
					HelpdeskBbsDTO dto = new HelpdeskBbsDTO();
					BeanUtils.copyProperties(dto, courseTeamProjectBbsRS.getBbs());

					List<AttachDTO> attList = new ArrayList<AttachDTO>();
					if (courseTeamProjectBbsRS.getBbs().getAttachList() != null) {
						for (int j = 0; j < courseTeamProjectBbsRS.getBbs().getAttachList().size(); j++) {
							UIAttachVO attVO = (UIAttachVO)courseTeamProjectBbsRS.getBbs().getAttachList().get(j);
							AttachDTO attDTO = new AttachDTO();
							attDTO.setFileSize(attVO.getFileSize());
							attDTO.setFileType(attVO.getFileType());
							attDTO.setFileName(attVO.getRealName());
							String fileUrl = config.getString("upload.context.file");
							attDTO.setFileUrl(fileUrl + attVO.getSavePath() + "/" + attVO.getSaveName());

							attList.add(attDTO);
						}

					}

					dto.setAttachList(attList);

					items.add(dto);
				}

			}
			mav.addObject("boardSeq", boardSeq);

		}

		mav.addObject("courseTeamProjectSeq", projectTeam.getCourseTeamProjectSeq());
		mav.addObject("courseTeamSeq", projectTeam.getCourseTeamSeq());
		mav.addObject("courseActiveSeq", projectTeam.getCourseActiveSeq());

		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("items", items);
		mav.addObject("currentPage", condition.getCurrentPage());

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 게시글 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/api/bbs/teamproject/detail" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);

		UIUnivCourseTeamProjectBbsVO bbs = new UIUnivCourseTeamProjectBbsVO();

		bbs.setBbsSeq((Long.parseLong(req.getParameter("bbsSeq"))));

		// UIUnivCourseTeamProjectTeamVO projectTeam = new UIUnivCourseTeamProjectTeamVO();

		bbs.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		bbs.setCourseTeamSeq(Long.parseLong(req.getParameter("courseTeamSeq")));
		bbs.setCourseTeamProjectSeq(Long.parseLong(req.getParameter("courseTeamProjectSeq")));
		//bbs.setBoardSeq(Long.parseLong(req.getParameter("boardSeq")));
		// 조회수 업데이트
		bbsService.updateBbsViewCount(bbs);

		ResultSet rs = bbsService.getDetail(bbs);
		if (rs == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		UIUnivCourseTeamProjectBbsRS bbsRS = (UIUnivCourseTeamProjectBbsRS)rs;

		HelpdeskBbsDTO dto = new HelpdeskBbsDTO();
		BeanUtils.copyProperties(dto, bbsRS.getBbs());

		List<AttachDTO> attList = new ArrayList<AttachDTO>();

		for (int j = 0; j < bbsRS.getBbs().getAttachList().size(); j++) {
			UIAttachVO attVO = (UIAttachVO)bbsRS.getBbs().getAttachList().get(j);
			AttachDTO attDTO = new AttachDTO();
			attDTO.setFileSize(attVO.getFileSize());
			attDTO.setFileType(attVO.getFileType());
			attDTO.setFileName(attVO.getRealName());
			attDTO.setFileUrl("/api/attach/file/response/" + attVO.getAttachSeq() + "/" + StringUtil.encrypt(attVO.getRealName(), Constants.ENCODING_KEY) + "/"
					+ attVO.getSaveName());

			attList.add(attDTO);
		}
		dto.setAttachList(attList);

		UICommentCondition commentCondition = new UICommentCondition();
		commentCondition.setSrchBbsSeq(dto.getBbsSeq());
		commentCondition.setSrchCourseActiveSeq(bbs.getCourseActiveSeq());
		Paginate<ResultSet> commentList = commentService.getList(commentCondition);

		List<CommentDTO> items = new ArrayList<CommentDTO>();

		// String imgPath =
		String imgURL = config.getString("domain.www") + config.getString("upload.context.image");
		if (commentList != null && commentList.getItemList() != null) {
			for (ResultSet comRs : commentList.getItemList()) {

				UICommentRS commentRS = (UICommentRS)comRs;
				CommentDTO cdto = new CommentDTO();
				BeanUtils.copyProperties(cdto, commentRS.getComment());

				if (!StringUtil.isEmpty(cdto.getRegMemberPhoto())) {
					cdto.setRegMemberPhoto(imgURL + cdto.getRegMemberPhoto());
				}

				if (StringUtil.isNotEmpty(commentRS.getComment().getActiveLecturerTypeCd())) {
					cdto.setProfYn("Y");
					cdto.setActiveLecturerTypeCd(commentRS.getComment().getActiveLecturerTypeCd());
					cdto.setActiveLecturerType(getCodeName(cdto.getActiveLecturerTypeCd()));
				} else {
					cdto.setProfYn("N");
				}
				items.add(cdto);
			}
		}

		mav.addObject("items", items);
		mav.addObject("item", dto);
		mav.addObject("courseTeamProjectSeq", bbs.getCourseTeamProjectSeq());
		mav.addObject("courseTeamSeq", bbs.getCourseTeamSeq());
		mav.addObject("courseActiveSeq", bbs.getCourseActiveSeq());
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseTeamProjectBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/bbs/teamproject/insert")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		checkSession(req);

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCourseTeamProjectBbsVO bbs = new UIUnivCourseTeamProjectBbsVO();

		requiredSession(req, bbs);

		//bbs.setBoardSeq(Long.parseLong(req.getParameter("boardSeq")));
		bbs.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		bbs.setCourseTeamSeq(Long.parseLong(req.getParameter("courseTeamSeq")));
		bbs.setCourseTeamProjectSeq(Long.parseLong(req.getParameter("courseTeamProjectSeq")));
		bbs.setDescription(HttpUtil.getParameter(req, "description"));
		bbs.setBbsTitle(HttpUtil.getParameter(req, "bbsTitle"));
		bbs.setDownloadYn(HttpUtil.getParameter(req, "downloadYn"));
		bbs.setSecretYn(HttpUtil.getParameter(req, "secretYn"));

		if (StringUtil.isEmpty(bbs.getDownloadYn())) {
			bbs.setDownloadYn("N");
		}
		if (StringUtil.isEmpty(bbs.getSecretYn())) {
			bbs.setSecretYn("N");
		}

		if (req.getParameter("groupLevel") == null) {
			bbs.setGroupLevel(1L);
		} else {
			bbs.setGroupLevel(Long.parseLong(req.getParameter("groupLevel")));
		}
		if (!StringUtil.isEmpty(req.getParameter("parentSeq"))) {
			bbs.setParentSeq((Long.parseLong(req.getParameter("parentSeq"))));
		} else {
			bbs.setParentSeq(0L);
		}
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y", "htmlYn=N");

		bbsService.insertBbs(bbs, fileAttach(req));

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 게시글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseTeamProjectBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/bbs/teamproject/delete")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		checkSession(req);

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCourseTeamProjectBbsVO bbs = new UIUnivCourseTeamProjectBbsVO();
		//bbs.setBoardSeq(Long.parseLong(req.getParameter("boardSeq")));
		bbs.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		bbs.setCourseTeamSeq(Long.parseLong(req.getParameter("courseTeamSeq")));
		bbs.setCourseTeamProjectSeq(Long.parseLong(req.getParameter("courseTeamProjectSeq")));
		bbs.setBbsSeq(Long.parseLong(req.getParameter("bbsSeq")));
		requiredSession(req, bbs);

		ResultSet rs = bbsService.getDetail(bbs);
		if (rs == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		UIUnivCourseTeamProjectBbsRS bbsRS = (UIUnivCourseTeamProjectBbsRS)rs;

		if (!bbsRS.getBbs().getRegMemberSeq().equals(bbs.getRegMemberSeq())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_ACCESS_DENIED, getErorrMessage(UIApiConstant._INVALID_ACCESS_DENIED));
		}

		bbsService.deleteBbs(bbs);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

}
