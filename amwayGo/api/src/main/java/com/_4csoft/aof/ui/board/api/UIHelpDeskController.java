package com._4csoft.aof.ui.board.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.mapper.BoardMapper;
import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.infra.mapper.CodeMapper;
import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.dto.HelpdeskBbsDTO;
import com._4csoft.aof.ui.board.dto.SystemBoardCategoryDTO;
import com._4csoft.aof.ui.board.dto.SystemBoardDTO;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.board.vo.condition.UIBbsCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBbsRS;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.resultset.UICodeRS;
import com._4csoft.aof.ui.univ.dto.AttachDTO;

/**
 * 
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.api.web
 * @File : UIApiMypageController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 4. 29.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIHelpDeskController extends UIBaseController {

	@Resource (name = "BbsService")
	private BbsService bbsService;

	@Resource (name = "BoardMapper")
	private BoardMapper boardMapper;

	@Resource (name = "CodeMapper")
	private CodeMapper codeMapper;

	private Codes codes = Codes.getInstance();

	/**
	 * 학습지원센터 게시판 목록
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/helpdesk/board/list")
	public ModelAndView listBoard(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 데이터세팅
		if ("0".equals(resultCode)) {
			try {
				List<ResultSet> listItem = boardMapper.getListByReference("system", -1L);

				List<SystemBoardDTO> boardList = new ArrayList<SystemBoardDTO>();
				if (listItem != null && !listItem.isEmpty()) {
					for (int i = 0; i < listItem.size(); i++) {
						UIBoardRS rs = (UIBoardRS)listItem.get(i);

						SystemBoardDTO dto = new SystemBoardDTO();
						BeanUtils.copyProperties(dto, rs.getBoard());

						boardList.add(dto);
					}
				}

				mav.addObject("totalRowCount", boardList.size());
				mav.addObject("boardList", boardList);
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 학습지원센터 게시판 글 목록
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/helpdesk/board/page/list")
	public ModelAndView listBbs(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		UIBbsCondition condition = new UIBbsCondition();
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		if ("0".equals(resultCode)) {
			try {
				condition.setSrchBoardSeq(Long.parseLong(req.getParameter("srchBoardSeq")));
				condition.setCurrentPage(Integer.parseInt(req.getParameter("currentPage")));
				condition.setPerPage(Integer.parseInt(req.getParameter("perPage")));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}
		condition.setSrchWord(req.getParameter("srchWord"));
		condition.setSrchKey(req.getParameter("srchKey"));
		if ("".equals(condition.getSrchKey())) {
			condition.setSrchKey("mobile");
		}

		List<HelpdeskBbsDTO> bbsList = new ArrayList<HelpdeskBbsDTO>();
		BoardVO boardVO = new BoardVO();
		int totalRowCount = 0;
		if ("0".equals(resultCode)) {
			try {
				// 게시판 정보
				boardVO = boardMapper.getDetailVO(condition.getSrchBoardSeq());
				// 게시글 목록
				Paginate<ResultSet> paginate = bbsService.getList(condition);
				totalRowCount = bbsService.countList(condition);

				// 데이터 세팅
				if (paginate != null) {
					List<ResultSet> listItem = paginate.getItemList();
					if (listItem != null) {
						for (int i = 0; i < listItem.size(); i++) {
							UIBbsRS rs = (UIBbsRS)listItem.get(i);
							HelpdeskBbsDTO dto = new HelpdeskBbsDTO();
							BeanUtils.copyProperties(dto, rs.getBbs());

							List<AttachDTO> attList = new ArrayList<AttachDTO>();
							for (int j = 0; j < rs.getBbs().getAttachList().size(); j++) {
								UIAttachVO attVO = (UIAttachVO)rs.getBbs().getAttachList().get(j);
								AttachDTO attDTO = new AttachDTO();
								attDTO.setFileSize(attVO.getFileSize());
								attDTO.setFileType(attVO.getFileType());
								attDTO.setFileName(attVO.getRealName());
								attDTO.setFileUrl(Constants.UPLOAD_PATH_FILE + attVO.getSavePath() + "/" + attVO.getSaveName());

								attList.add(attDTO);
							}
							dto.setAttachList(attList);
							dto.setArticleUrl("/api/helpdesk/board/page/detail/" + dto.getBbsSeq());
							bbsList.add(dto);
						}
					}
				}
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("currentPage", condition.getCurrentPage());
		mav.addObject("boardTypeCd", boardVO.getBoardTypeCd());
		mav.addObject("bbsList", bbsList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 학습지원센터 게시판 글 상세
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/helpdesk/board/page/detail/{bbsSeq}")
	public ModelAndView detailBbs(HttpServletRequest req, HttpServletResponse res, @PathVariable ("bbsSeq") Long bbsSeq) throws Exception {
		ModelAndView mav = new ModelAndView();

		System.out.println("@@@@@@@@@@@@@@@개발예정@@@@@@@@@@@@@@@@@");
		System.out.println("@@@@@@@@@@@@@@@개발예정@@@@@@@@@@@@@@@@@");

		return mav;
	}

	/**
	 * 학습지원센터 카테고리 목록
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/helpdesk/board/page/category/list")
	public ModelAndView listCategory(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();
		List<SystemBoardCategoryDTO> codeList = new ArrayList<SystemBoardCategoryDTO>();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		Long boardSeq = 0L;
		if ("0".equals(resultCode)) {
			try {
				boardSeq = Long.parseLong(req.getParameter("srchBoardSeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		if ("0".equals(resultCode)) {
			// 데이터 세팅
			try {
				UIBoardVO baordVO = (UIBoardVO)boardMapper.getDetailVO(boardSeq);
				UICodeRS rs = (UICodeRS)codeMapper.getDetail("", baordVO.getBoardTypeCd());

				List<CodeVO> listItem = codeMapper.getListCode(rs.getCode().getCodeNameEx3());
				if (listItem != null) {
					for (int i = 0; i < listItem.size(); i++) {
						UICodeVO codeVO = (UICodeVO)listItem.get(i);
						SystemBoardCategoryDTO dto = new SystemBoardCategoryDTO();

						dto.setCategoryCode(codeVO.getCode());
						dto.setCategoryName(codeVO.getCodeName());

						codeList.add(dto);
					}
				}

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", codeList.size());
		mav.addObject("cateList", codeList);

		mav.setViewName("jsonView");

		return mav;
	}
}
