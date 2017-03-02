package com._4csoft.aof.ui.univ.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.service.MessageAddressService;
import com._4csoft.aof.infra.service.MessageSendService;
import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.MessageReceiveVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.service.UIMessageReceiveService;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.UIMessageReceiveVO;
import com._4csoft.aof.ui.infra.vo.UIMessageSendVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageAddressCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageReceiveCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIMessageAddressRS;
import com._4csoft.aof.ui.infra.vo.resultset.UIMessageReceiveRS;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.dto.MessageAddressGroupDTO;
import com._4csoft.aof.ui.univ.dto.MessageReceiveDTO;

import egovframework.com.cmm.EgovMessageSource;

/**
 * 
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.api.web
 * @File : UIApiMypageController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 6. 16.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIMypageController extends BaseController {

	@Resource (name = "UIMessageReceiveService")
	private UIMessageReceiveService messageReceiveService;

	@Resource (name = "MessageSendService")
	private MessageSendService messageSendService;

	@Resource (name = "MessageAddressService")
	private MessageAddressService messageAddressService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "egovMessageSource")
	EgovMessageSource messageSource;

	private Codes codes = Codes.getInstance();

	/**
	 * 주소록 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/mypage/contact/list")
	public ModelAndView addressGroupList(HttpServletRequest req, HttpServletResponse res) throws Exception {
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
		int pageNum = HttpUtil.getParameter(req, "pageNum", 0);
		int perPage = HttpUtil.getParameter(req, "perPage", 10);
		if ("0".equals(resultCode)) {
			try {

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		// 데이터세팅
		List<MessageAddressGroupDTO> addressGroupList = new ArrayList<MessageAddressGroupDTO>();
		if ("0".equals(resultCode)) {
			try {
				UIMessageAddressCondition condition = new UIMessageAddressCondition();
				condition.setCurrentPage(pageNum);
				condition.setPerPage(perPage);
				condition.setOrderby(0);
				condition.setRegMemberSeq(SessionUtil.getMember(req).getMemberSeq());

				// 받은메세지 목록
				Paginate<ResultSet> paginate = messageAddressService.getList(condition);

				if (paginate != null) {
					List<ResultSet> listItem = paginate.getItemList();
					if (listItem != null) {
						for (int index = 0; index < listItem.size(); index++) {
							UIMessageAddressRS rs = (UIMessageAddressRS)listItem.get(index);
							MessageAddressGroupDTO item = new MessageAddressGroupDTO(rs);

							addressGroupList.add(item);
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
		mav.addObject("totalRowCount", addressGroupList.size());
		mav.addObject("contactList", addressGroupList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 받은쪽지목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/mypage/message/list")
	public ModelAndView messageReceiveList(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		final String CD_MESSAGE_TYPE_MEMO = codes.get("CD.MESSAGE_TYPE.MEMO");

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
		UIMessageReceiveCondition condition = new UIMessageReceiveCondition();
		condition.setSrchMessageTypeCd(CD_MESSAGE_TYPE_MEMO);
		if ("0".equals(resultCode)) {
			try {
				condition.setSrchTargetMemberSeq(Long.parseLong(req.getParameter("srchMemberSeq")));
				condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		// 받은메세지 목록
		List<MessageReceiveDTO> messageList = new ArrayList<MessageReceiveDTO>();
		if ("0".equals(resultCode)) {
			try {
				List<ResultSet> listItem = messageReceiveService.getListMobile(condition);
				if (listItem != null) {
					for (int index = 0; index < listItem.size(); index++) {
						UIMessageReceiveRS rs = (UIMessageReceiveRS)listItem.get(index);
						MessageReceiveDTO dto = new MessageReceiveDTO();
						dto.setMessageSeq(rs.getMessageReceive().getMessageReceiveSeq());
						dto.setMessage(rs.getMessageSend().getDescription());
						dto.setRegDate(rs.getMessageReceive().getRegDtime());
						dto.setName(rs.getReceiveMember().getMemberName());
						dto.setMessageType(rs.getMessageSend().getMessageTypeCd());

						messageList.add(dto);
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
		mav.addObject("totalRowCount", messageList.size());
		mav.addObject("messageList", messageList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 쪽지삭제
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/mypage/message/delete")
	public ModelAndView messageDelete(HttpServletRequest req, HttpServletResponse res) throws Exception {
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
		UIMessageReceiveVO messageReceive = new UIMessageReceiveVO();
		UIMessageSendVO messageSend = new UIMessageSendVO();
		requiredSession(req, messageReceive, messageSend);
		String messageType = "";
		if ("0".equals(resultCode)) {
			try {
				messageReceive.setMessageReceiveSeq(Long.parseLong(req.getParameter("messageSeq")));
				messageSend.setMessageSendSeq(Long.parseLong(req.getParameter("messageSeq")));
				messageType = req.getParameter("messageType");
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		if ("0".equals(resultCode)) {
			try {
				if ("recv".equals(messageType)) {
					messageReceiveService.deleteMessageReceive(messageReceive);
				} else {
					messageSendService.deleteMessageSend(messageSend);
				}
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
	 * 쪽지 보내기
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/mypage/message/send/insert")
	public ModelAndView messageSend(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		final String CD_MESSAGE_TYPE_MEMO = codes.get("CD.MESSAGE_TYPE.MEMO");
		final String CD_MESSAGE_SCHEDULE_TYPE_001 = codes.get("CD.MESSAGE_SCHEDULE_TYPE.001");

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
		UIMessageSendVO messageSend = new UIMessageSendVO();
		UIMessageReceiveVO messageReceive = new UIMessageReceiveVO();
		requiredSession(req, messageSend);
		if ("0".equals(resultCode)) {
			try {
				messageSend.setDescription(req.getParameter("message"));
				messageReceive.setReceiveMemberSeq(Long.parseLong(req.getParameter("memberSeq")));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		UIAttachVO attach = new UIAttachVO();
		List<MemberVO> failReceiveList = new ArrayList<MemberVO>();

		messageSend.setSendMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		messageSend.setMessageTitle(messageSource.getMessage("글:쪽지:쪽지"));
		messageSend.setSendCount(0L);
		messageSend.setReferenceSeq(0L);
		messageSend.setMessageTypeCd(CD_MESSAGE_TYPE_MEMO);
		messageSend.setSendScheduleCd(CD_MESSAGE_SCHEDULE_TYPE_001);

		List<MessageReceiveVO> messageReceiveList = new ArrayList<MessageReceiveVO>();
		messageReceiveList.add(messageReceive);

		if ("0".equals(resultCode)) {
			try {
				messageSendService.insertMessageSend(messageSend, attach, messageReceiveList, null, null, null, failReceiveList);
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
}
