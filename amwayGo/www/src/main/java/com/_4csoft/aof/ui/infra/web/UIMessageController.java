/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.service.MessageAddressGroupService;
import com._4csoft.aof.infra.service.MessageAddressService;
import com._4csoft.aof.infra.service.MessageReceiveService;
import com._4csoft.aof.infra.service.MessageSendService;
import com._4csoft.aof.infra.service.MessageTemplateService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.CategoryVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.MessageAddressGroupVO;
import com._4csoft.aof.infra.vo.MessageAddressVO;
import com._4csoft.aof.infra.vo.MessageReceiveVO;
import com._4csoft.aof.infra.vo.MessageSendVO;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressGroupVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressVO;
import com._4csoft.aof.ui.infra.vo.UIMessageReceiveVO;
import com._4csoft.aof.ui.infra.vo.UIMessageSendVO;
import com._4csoft.aof.ui.infra.vo.UIMessageTemplateVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMemberCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageAddressCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageAddressGroupCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageReceiveCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageSendCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageTemplateCondition;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMessageController.java
 * @Title : 쪽지함,주소록
 * @date : 2014. 3. 6.
 * @author : 김영학
 * @descrption : 쪽지함,주소록
 */
@Controller
public class UIMessageController extends BaseController {

	@Resource (name = "MessageSendService")
	private MessageSendService messageSendService;

	@Resource (name = "MessageReceiveService")
	private MessageReceiveService messageReceiveService;

	@Resource (name = "MemberService")
	private MemberService memberService;

	@Resource (name = "MessageAddressGroupService")
	private MessageAddressGroupService messageAddressGroupService;

	@Resource (name = "MessageAddressService")
	private MessageAddressService messageAddressService;

	@Resource (name = "MessageTemplateService")
	private MessageTemplateService messageTemplateService;

	@Resource (name = "AttachService")
	private AttachService attachService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	/**
	 * 프론트 쪽지 메인 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/list.do")
	public ModelAndView message(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/message/memo/memo");
		return mav;
	}

	/**
	 * 프론트 받은쪽지 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/receive/list/iframe.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchReceiveMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		/** TODO : 코드 */
		condition.setSrchMessageTypeCd("MESSAGE_TYPE::MEMO");

		mav.addObject("paginate", messageReceiveService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/memo/listMemoReceiveIframe");
		return mav;
	}

	/**
	 * 프론트 받은쪽지 상세
	 * 
	 * @param req
	 * @param res
	 * @param messageReceive
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/receive/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveVO messageReceive, UIMessageReceiveCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageReceive);

		// 쪽지수신확인 코드
		messageReceive.setReceiveTypeCd("MESSAGE_RECEIVE_TYPE::003");

		mav.addObject("detail", messageReceiveService.getDetail(messageReceive));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/memo/detailMemoReceiveIframe");
		return mav;
	}

	/**
	 * 프론트 받은쪽지 삭제
	 * 
	 * @param req
	 * @param res
	 * @param UIMessageReceiveVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/receive/delete.do")
	public ModelAndView deleteReceive(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveVO messageReceive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageReceive);

		messageReceiveService.deleteMessageReceive(messageReceive);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 받은쪽지 다중삭제
	 * 
	 * @param req
	 * @param res
	 * @param messageReceive
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/receive/deletelist.do")
	public ModelAndView deletelistReceive(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveVO messageReceive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageReceive);

		List<MessageReceiveVO> messageReceives = new ArrayList<MessageReceiveVO>();
		for (String index : messageReceive.getCheckkeys()) {
			UIMessageReceiveVO vo = new UIMessageReceiveVO();
			vo.setMessageReceiveSeq(messageReceive.getMessageReceiveSeqs()[Integer.parseInt(index)]);
			vo.copyAudit(messageReceive);

			messageReceives.add(vo);
		}

		if (messageReceives.size() > 0) {
			mav.addObject("result", messageReceiveService.deletelistMessageReceive(messageReceives));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 보낸쪽지 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/send/list/iframe.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMessageSendCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchSendMemberSeq(SessionUtil.getMember(req).getMemberSeq());

		/** TODO : 코드 */
		condition.setSrchMessageTypeCd("MESSAGE_TYPE::MEMO");

		mav.addObject("paginate", messageSendService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/memo/listMemoSendIframe");
		return mav;
	}

	/**
	 * 프론트 보낸쪽지 상세
	 * 
	 * @param req
	 * @param res
	 * @param messageSend
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/send/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO messageSend, UIMessageSendCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", messageSendService.getDetail(messageSend));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/memo/detailMemoSendIframe");
		return mav;
	}

	/**
	 * 프론트 보낸쪽지 그룹상세
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/send/groupdetail/popup.do")
	public ModelAndView groupSendDetail(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveCondition condition, UIMessageSendVO messageSend)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		/** TODO : 코드 */
		condition.setSrchMessageTypeCd("MESSAGE_TYPE::MEMO");
		condition.setSrchMessageSendSeq(messageSend.getMessageSendSeq());

		mav.addObject("messageSend", messageSendService.getDetail(messageSend));
		mav.addObject("paginate", messageReceiveService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/memo/listMemoReceiveGroupPopup");

		return mav;
	}

	/**
	 * 프론트 보낸쪽지 삭제
	 * 
	 * @param req
	 * @param res
	 * @param messageSend
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/send/delete.do")
	public ModelAndView deleteSendMessage(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO messageSend) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageSend);

		messageSendService.deleteMessageSend(messageSend);

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 프론트 보낸쪽지 다중삭제
	 * 
	 * @param req
	 * @param res
	 * @param messageSend
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/send/deletelist.do")
	public ModelAndView deletelistSendMessage(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO messageSend) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageSend);

		List<MessageSendVO> messageSends = new ArrayList<MessageSendVO>();
		for (String index : messageSend.getCheckkeys()) {
			UIMessageSendVO vo = new UIMessageSendVO();
			vo.setMessageSendSeq(messageSend.getMessageSendSeqs()[Integer.parseInt(index)]);
			vo.copyAudit(messageSend);

			messageSends.add(vo);
		}

		if (messageSends.size() > 0) {
			mav.addObject("result", messageSendService.deletelistMessageSend(messageSends));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/****************************************** 주소록 *************************************************************************/

	/**
	 * 프론트 주소록 전체목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMessageAddressCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		condition.setRegMemberSeq(ssMember.getMemberSeq());

		mav.addObject("paginate", messageAddressService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/addressGroup/listMessageAddress");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹멤버 다중삭제(전체목록)
	 * 
	 * @param req
	 * @param res
	 * @param messageAddress
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/deletelist.do")
	public ModelAndView deletelistGroupMember(HttpServletRequest req, HttpServletResponse res, UIMessageAddressVO messageAddress) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageAddress);

		List<MessageAddressVO> members = new ArrayList<MessageAddressVO>();
		for (String index : messageAddress.getCheckkeys()) {
			UIMessageAddressVO vo = new UIMessageAddressVO();
			vo.setAddressGroupSeq(messageAddress.getAddressGroupSeqs()[Integer.parseInt(index)]);
			vo.setMemberSeq(messageAddress.getMemberSeqs()[Integer.parseInt(index)]);
			vo.copyAudit(messageAddress);

			members.add(vo);
		}

		if (members.size() > 0) {
			mav.addObject("result", messageAddressService.deletelistMessageAddress(members));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/group/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		condition.setRegMemberSeq(ssMember.getMemberSeq());

		mav.addObject("paginate", messageAddressGroupService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/addressGroup/listMessageAddressGroup");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹등록 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/create/popup.do")
	public ModelAndView createGroup(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/message/addressGroup/createMessageAddressGroupPopup");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		messageAddressGroupService.insertMessageAddressGroup(vo);
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹 다중삭제(그룹목록)
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/group/deletelist.do")
	public ModelAndView deletelistGroup(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupVO messageAddressGroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageAddressGroup);

		List<MessageAddressGroupVO> groups = new ArrayList<MessageAddressGroupVO>();
		for (String index : messageAddressGroup.getCheckkeys()) {
			UIMessageAddressGroupVO vo = new UIMessageAddressGroupVO();
			vo.setAddressGroupSeq(messageAddressGroup.getAddressGroupSeqs()[Integer.parseInt(index)]);
			vo.copyAudit(messageAddressGroup);

			groups.add(vo);
		}

		if (groups.size() > 0) {
			mav.addObject("result", messageAddressGroupService.deletelistMessageAddressGroup(groups));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹 상세
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupVO vo, UIMessageAddressCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		condition.setRegMemberSeq(ssMember.getMemberSeq());

		mav.addObject("detail", messageAddressGroupService.getDetail(vo));
		mav.addObject("paginate", messageAddressService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/message/addressGroup/detailMessageAddressGroup");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹명 수정팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/memo/address/group/edit/popup.do")
	public ModelAndView updateGroup(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("detail", vo);
		mav.setViewName("/infra/message/addressGroup/editMessageAddressGroupPopup");

		return mav;
	}

	/**
	 * 프론트 주소록 그룹명 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/message/group/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		messageAddressGroupService.updateMessageAddressGroup(vo);
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프론트 주소록 그룹에 인원 추가
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/message/group/member/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMessageAddressVO messageAddress) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageAddress);

		List<MessageAddressVO> members = new ArrayList<MessageAddressVO>();
		for (Long memberSeq : messageAddress.getMemberSeqs()) {
			UIMessageAddressVO vo = new UIMessageAddressVO();
			vo.setMemberSeq(memberSeq);
			vo.setAddressGroupSeq(messageAddress.getAddressGroupSeq());
			vo.copyAudit(messageAddress);

			members.add(vo);
		}

		if (members.size() > 0) {
			mav.addObject("result", messageAddressService.insertlistMessageAddress(members));
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/************************************************* 쪽지발송 ****************************************************/

	/**
	 * 프론트 쪽지발송 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param addVo
	 * @param addGroupVo
	 * @param memberVo
	 * @param sendVo
	 * @param receiveVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/message/group/send/popup.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIMessageAddressVO addVo, UIMessageAddressGroupVO addGroupVo,
			UIMemberVO memberVo, UIMessageSendVO sendVo, UIMessageReceiveVO receiveVo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		List<UIMessageAddressGroupVO> addGroups = new ArrayList<UIMessageAddressGroupVO>();
		List<UIMessageAddressVO> adds = new ArrayList<UIMessageAddressVO>();
		List<UIMessageReceiveVO> addMessageReceives = new ArrayList<UIMessageReceiveVO>();

		if (addVo.getCheckkeys() != null) {
			// 개별 쪽지쓰기
			if (addVo.getMemberSeqs() != null) {
				for (String index : addVo.getCheckkeys()) {
					UIMessageAddressVO o = new UIMessageAddressVO();
					o.setMemberSeq(addVo.getMemberSeqs()[Integer.parseInt(index)]);
					o.setMemberName(addVo.getMemberNames()[Integer.parseInt(index)]);
					// 동일 발신인 제외
					if (adds.contains(o) == false) {
						adds.add(o);
					}
				}
				mav.addObject("AddList", adds);
			} else if (receiveVo.getMessageSendSeqs() != null) { // 보낸쪽지에서 쪽지쓰기
				for (String index : receiveVo.getCheckkeys()) {
					UIMessageReceiveVO o = new UIMessageReceiveVO();
					o.setMessageSendSeq(receiveVo.getMessageSendSeqs()[Integer.parseInt(index)]);
					o.setMemberName(receiveVo.getMemberNames()[Integer.parseInt(index)]);
					addMessageReceives.add(o);
				}
				mav.addObject("ReceiveGroupList", addMessageReceives);
			} else if (addGroupVo.getAddressGroupSeqs() != null) {
				for (String index : addGroupVo.getCheckkeys()) {
					UIMessageAddressGroupVO o = new UIMessageAddressGroupVO();
					o.setAddressGroupSeq(addGroupVo.getAddressGroupSeqs()[Integer.parseInt(index)]);
					o.setGroupName(addGroupVo.getGroupNames()[Integer.parseInt(index)]);
					addGroups.add(o);
				}
				mav.addObject("GroupList", addGroups);
			}
		}

		// 받은쪽지 상세에서 답장보내기
		if (addVo.getCheckkeys() == null && addVo.getMemberSeq() != null) {
			UIMessageAddressVO o = new UIMessageAddressVO();
			o.setMemberSeq(addVo.getMemberSeq());
			o.setMemberName(addVo.getMemberName());
			adds.add(o);

			mav.addObject("AddList", adds);
			mav.addObject("description", sendVo.getDescription());
		}

		mav.setViewName("/infra/message/memo/createMemoSendGroupPopup");

		return mav;
	}

	/**
	 * 주소록 그룹 쪽지보내기 팝업 받는사람
	 * 
	 * @param req
	 * @param res
	 * @param addVo
	 * @param addGroupVo
	 * @param memberVo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/message/group/list/popup.do", "/message/group/detail/send/popup.do" })
	public ModelAndView sendListPopup(HttpServletRequest req, HttpServletResponse res, UIMessageAddressVO addVo, UIMessageAddressGroupVO addGroupVo,
			UIMemberVO memberVo, UIMessageAddressGroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		if ("/message/group/detail/send/popup.do".equals(req.getServletPath())) {
			mav.addObject("choice", "add");
		} else {
			mav.addObject("choice", "group");
		}

		mav.setViewName("/infra/memo/createMemoSendGroupListPopup");

		return mav;
	}

	/**
	 * 주소록 그룹 받는사람 인원 ajax
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/message/add/list/ajax.do")
	public ModelAndView sendAddAjax(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", memberService.getList(condition));

		mav.addObject("condition", condition);

		mav.setViewName("/infra/memo/addMemberAjax");

		return mav;
	}

	/**
	 * 주소록 그룹 받는사람 그룹 ajax
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/message/group/list/ajax.do", "/message/group/list/Iframe.do" })
	public ModelAndView sendGroupAjax(HttpServletRequest req, HttpServletResponse res, UIMessageAddressGroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		condition.setRegMemberSeq(ssMember.getMemberSeq());

		mav.addObject("paginate", messageAddressGroupService.getList(condition));
		mav.addObject("condition", condition);

		if ("/message/group/list/ajax.do".equals(req.getServletPath())) {
			mav.setViewName("/infra/message/addressGroup/addGroupAjax");
		} else {
			mav.setViewName("/infra/message/addressGroup/addGroupIframe");
			mav.addObject("choice", "add");
			mav.addObject("srchType", "individual");
		}

		return mav;
	}

	/**
	 * 쪽지발송 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param messageSend
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/message/send/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO messageSend, UIMessageReceiveVO messageReceive,
			UIMessageAddressGroupVO messageMessageAddressGroup, UICategoryVO category, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, messageSend);
		messageSend.setSendMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		messageSend.setSendCount(0L);
		messageSend.setReferenceSeq(0L);
		// 메세지 예약발송구분
		messageSend.setSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");

		if ("MESSAGE_TYPE::EMAIL".equals(messageSend.getMessageTypeCd())) {
			messageSend.setReferenceInfo(SessionUtil.getMember(req).getEmail());
		} else if ("MESSAGE_TYPE::SMS".equals(messageSend.getMessageTypeCd())) {
			messageSend.setReferenceInfo(SessionUtil.getMember(req).getPhoneMobile());
			messageSend.setSmsTypeCd(messageSend.getSmsTypeCd());
		}

		// 개별발송
		List<MessageReceiveVO> messageReceiveList = new ArrayList<MessageReceiveVO>();
		if (messageReceive != null && messageReceive.getMemberSeqs() != null) {
			for (Long member : messageReceive.getMemberSeqs()) {
				UIMessageReceiveVO o = new UIMessageReceiveVO();
				o.setReceiveMemberSeq(member);

				messageReceiveList.add(o);
			}
		}
		// 그룹발송
		List<MessageAddressGroupVO> messageGroupList = new ArrayList<MessageAddressGroupVO>();
		if (messageMessageAddressGroup != null && messageMessageAddressGroup.getAddressGroupSeqs() != null) {
			for (Long seq : messageReceive.getAddressGroupSeqs()) {
				UIMessageAddressGroupVO o = new UIMessageAddressGroupVO();
				o.setAddressGroupSeq(seq);

				messageGroupList.add(o);
			}
		}

		// 소속별 단체발송
		List<CategoryVO> categoryList = new ArrayList<CategoryVO>();
		if (category != null && category.getCategorySeqs() != null) {
			for (Long seq : category.getCategorySeqs()) {
				UICategoryVO o = new UICategoryVO();
				o.setCategorySeq(seq);

				categoryList.add(o);
			}
		}

		// 보낸쪽지에서 체크후 쪽지발송(단체발송건이 존재하기 때문에 sendSeq로 발신자를 조회하여 처리해야함)
		List<MessageSendVO> messageSendList = new ArrayList<MessageSendVO>();
		if (messageSend != null && messageSend.getMessageSendSeqs() != null) {
			for (Long seq : messageSend.getMessageSendSeqs()) {
				UIMessageSendVO o = new UIMessageSendVO();
				o.setMessageSendSeq(seq);

				messageSendList.add(o);
			}
		}

		List<MemberVO> failReceiveList = new ArrayList<MemberVO>();

		mav.addObject("result",
				messageSendService.insertMessageSend(messageSend, attach, messageReceiveList, messageSendList, messageGroupList, categoryList, failReceiveList));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 쪽지수신 읽지않은 쪽지수
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/message/receive/unread.do")
	public ModelAndView unread(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		try {
			requiredSession(req);

			UIMessageReceiveCondition condition = new UIMessageReceiveCondition();
			condition.setSrchReceiveMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			condition.setSrchMessageTypeCd("MESSAGE_TYPE::MEMO");

			mav.addObject("unreadMessage", messageReceiveService.getCountUnread(condition));
		} catch (Exception e) {
			mav.addObject("unreadMessage", 0);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * SMS 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/message/sms/popup.do")
	public ModelAndView createSmsMessagePopup(HttpServletRequest req, HttpServletResponse res, UIMemberVO memberVo, UIMessageSendVO sendVo,
			UIMessageAddressVO addVo, UIMessageAddressGroupVO addGroupVo, UIMessageTemplateVO messageTemplateVo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		List<UIMessageAddressGroupVO> addGroups = new ArrayList<UIMessageAddressGroupVO>();

		List<UIMemberVO> members = new ArrayList<UIMemberVO>();

		// 목록에서 체크된 수신자
		if (memberVo.getCheckkeys() != null) {
			// 개별 쪽지쓰기
			if (memberVo.getMemberSeqs() != null) {
				for (String index : memberVo.getCheckkeys()) {
					if (memberVo.getPhoneMobiles()[Integer.parseInt(index)] != null && !"".equals(memberVo.getPhoneMobiles()[Integer.parseInt(index)])) {
						UIMemberVO o = new UIMemberVO();
						o.setMemberSeq(memberVo.getMemberSeqs()[Integer.parseInt(index)]);
						o.setMemberName(memberVo.getMemberNames()[Integer.parseInt(index)]);
						o.setPhoneMobile(memberVo.getPhoneMobiles()[Integer.parseInt(index)]);

						// 동일 발신인 제외
						if (members.contains(o) == false) {
							members.add(o);
						}
					}
				}
				mav.addObject("AddList", members);
			} else if (addGroupVo.getAddressGroupSeqs() != null) {
				for (String index : addGroupVo.getCheckkeys()) {
					UIMessageAddressGroupVO o = new UIMessageAddressGroupVO();
					o.setAddressGroupSeq(addGroupVo.getAddressGroupSeqs()[Integer.parseInt(index)]);
					o.setGroupName(addGroupVo.getGroupNames()[Integer.parseInt(index)]);
					addGroups.add(o);
				}
				mav.addObject("GroupList", addGroups);
			}
		}

		// 상세페이지에서 sms발송
		if (memberVo.getCheckkeys() == null && memberVo.getMemberSeq() != null) {
			if (memberVo.getPhoneMobile() != null && !"".equals(memberVo.getPhoneMobile())) {
				UIMemberVO o = new UIMemberVO();
				o.setMemberSeq(memberVo.getMemberSeq());
				o.setMemberName(memberVo.getMemberName());
				o.setPhoneMobile(memberVo.getPhoneMobile());
				members.add(o);

				mav.addObject("AddList", members);
			}
		}

		// 메일템플릿 목록가져오기위한 셋팅
		UIMessageTemplateCondition condition = new UIMessageTemplateCondition();
		condition.setSrchTemplateType("sms");
		condition.setSrchUseYn("Y");

		// 메일템플릿 목록
		mav.addObject("templateList", messageTemplateService.getList(condition));
		mav.addObject("messageSend", sendVo);

		mav.setViewName("/infra/message/addressGroup/createSmsMessagePopup");

		return mav;
	}

	/**
	 * SMS 템플릿 데이터조회
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/message/sms/create/ajax.do")
	public ModelAndView createSmsMessagePopup(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO sendVo, UIMessageTemplateVO messageTemplateVo)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		if (messageTemplateVo.getTemplateSeq() != null) {
			UIMessageTemplateVO vo = new UIMessageTemplateVO();
			vo.setTemplateSeq(messageTemplateVo.getTemplateSeq());

			// 메일템플릿 목록
			mav.addObject("templateDetail", messageTemplateService.getDetail(vo));
		}

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * Email 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param sendVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/message/email/popup.do")
	public ModelAndView createEmailMessagePopup(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO sendVo, UIMessageAddressVO addVo,
			UIMessageAddressGroupVO addGroupVo, UIMessageTemplateVO messageTemplateVo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		// 발송자정보
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		List<UIMessageAddressGroupVO> addGroups = new ArrayList<UIMessageAddressGroupVO>();
		List<UIMessageAddressVO> adds = new ArrayList<UIMessageAddressVO>();

		// 목록에서 체크된 수신자
		if (addVo.getCheckkeys() != null) {
			// 개별 쪽지쓰기
			if (addVo.getMemberSeqs() != null) {
				for (String index : addVo.getCheckkeys()) {
					UIMessageAddressVO o = new UIMessageAddressVO();
					o.setMemberSeq(addVo.getMemberSeqs()[Integer.parseInt(index)]);
					o.setMemberName(addVo.getMemberNames()[Integer.parseInt(index)]);

					// 동일 발신인 제외
					if (adds.contains(o) == false) {
						adds.add(o);
					}
				}
				mav.addObject("AddList", adds);
			} else if (addGroupVo.getAddressGroupSeqs() != null) {
				for (String index : addGroupVo.getCheckkeys()) {
					UIMessageAddressGroupVO o = new UIMessageAddressGroupVO();
					o.setAddressGroupSeq(addGroupVo.getAddressGroupSeqs()[Integer.parseInt(index)]);
					o.setGroupName(addGroupVo.getGroupNames()[Integer.parseInt(index)]);
					addGroups.add(o);
				}
				mav.addObject("GroupList", addGroups);
			}
		}

		// 상세페이지에서 Email 발송
		if (addVo.getCheckkeys() == null && addVo.getMemberSeq() != null) {
			UIMessageAddressVO o = new UIMessageAddressVO();
			o.setMemberSeq(addVo.getMemberSeq());
			o.setMemberName(addVo.getMemberName());
			adds.add(o);

			mav.addObject("AddList", adds);
		}

		// 메일템플릿 목록가져오기위한 셋팅
		UIMessageTemplateCondition condition = new UIMessageTemplateCondition();
		condition.setSrchTemplateType("email");
		condition.setSrchUseYn("Y");

		// 메일템플릿 목록
		mav.addObject("templateList", messageTemplateService.getList(condition));
		mav.addObject("emailSendMember", ssMember);
		mav.addObject("messageSend", sendVo);

		mav.setViewName("/infra/message/addressGroup/createEmailSendPopup");

		return mav;
	}

	/**
	 * Email 팝업화면 템플릿적용 후
	 * 
	 * @param req
	 * @param res
	 * @param sendVo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/message/email/create/popup.do")
	public ModelAndView createEmailPopup(HttpServletRequest req, HttpServletResponse res, UIMessageSendVO sendVo, UIMessageAddressVO addVo,
			UIMessageAddressGroupVO addGroupVo, UIMessageTemplateVO messageTemplateVo, UICategoryVO categoryVo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		// 발송자정보
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		List<UIMessageAddressGroupVO> addGroups = new ArrayList<UIMessageAddressGroupVO>();
		List<UIMessageAddressVO> adds = new ArrayList<UIMessageAddressVO>();
		List<UICategoryVO> categorys = new ArrayList<UICategoryVO>();

		// 템플릿적용으로 인해 페이지 리플레쉬 후
		// 개별 멤버
		if (addVo.getMemberSeqs() != null) {
			for (int i = 0; i < addVo.getMemberSeqs().length; i++) {
				UIMessageAddressVO o = new UIMessageAddressVO();
				o.setMemberSeq(addVo.getMemberSeqs()[i]);
				o.setMemberName(addVo.getMemberNames()[i]);
				adds.add(o);
			}
			mav.addObject("AddList", adds);
		}
		// 주소록그룹
		if (addGroupVo.getAddressGroupSeqs() != null) {
			for (int i = 0; i < addGroupVo.getAddressGroupSeqs().length; i++) {
				UIMessageAddressGroupVO o = new UIMessageAddressGroupVO();
				o.setAddressGroupSeq(addGroupVo.getAddressGroupSeqs()[i]);
				o.setGroupName(addGroupVo.getGroupNames()[i]);
				addGroups.add(o);
			}
			mav.addObject("GroupList", addGroups);
		}
		// 단체발송소속학과
		if (categoryVo.getCategorySeqs() != null) {
			for (int i = 0; i < categoryVo.getCategorySeqs().length; i++) {
				UICategoryVO o = new UICategoryVO();
				o.setCategorySeq(categoryVo.getCategorySeqs()[i]);
				o.setCategoryName(categoryVo.getCategoryNames()[i]);
				categorys.add(o);
			}
			mav.addObject("CategoryList", categorys);
		}

		// 메일템플릿 목록가져오기위한 셋팅
		UIMessageTemplateCondition condition = new UIMessageTemplateCondition();
		condition.setSrchTemplateType("email");
		condition.setSrchUseYn("Y");

		// 탬플릿상세정보
		if (StringUtil.isNotEmpty(messageTemplateVo.getTemplateSeq())) {
			mav.addObject("detailTemplate", messageTemplateService.getDetail(messageTemplateVo));
		}

		// 메일템플릿 목록
		mav.addObject("templateList", messageTemplateService.getList(condition));
		mav.addObject("emailSendMember", ssMember);
		mav.addObject("messageSend", sendVo);
		mav.addObject("emailTemplate", messageTemplateVo.getTemplateSeq());

		mav.setViewName("/infra/message/addressGroup/createEmailSendPopup");

		return mav;
	}

	/**
	 * 쪽지발송 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMessageReceiveVO
	 * @return ModelAndView
	 * @throws Exception TODO : 발송한 쪽지를 삭제시 받은쪽지함에서도 취소하는 기능이 추가될 것인지 결정필요.
	 * @RequestMapping ("/message/send/deletelist.do") public ModelAndView deletelistSend(HttpServletRequest req, HttpServletResponse res, UIMessageReceiveVO
	 *                 messageReceive) throws Exception { ModelAndView mav = new ModelAndView();
	 * 
	 *                 requiredSession(req, messageReceive);
	 * 
	 *                 List<MessageReceiveVO> messageReceives = new ArrayList<MessageReceiveVO>(); for (String index : messageReceive.getCheckkeys()) {
	 *                 UIMessageReceiveVO o = new UIMessageReceiveVO(); o.setMessageSendSeq(messageReceive.getMessageSendSeqs()[Integer.parseInt(index)]);
	 *                 o.setMessageReceiveSeq(messageReceive.getMessageReceiveSeqs()[Integer.parseInt(index)]); o.copyAudit(messageReceive);
	 * 
	 *                 messageReceives.add(o); }
	 * 
	 *                 if (messageReceives.size() > 0) { mav.addObject("result", messageReceiveService.deletelistSenderMessageReceive(messageReceives)); } else
	 *                 { mav.addObject("result", 0); } mav.setViewName("/common/save"); return mav; }
	 */

}