package com._4csoft.aof.ui.univ.api;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.service.UIPushMessageTargetService;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UISendPushController.java
 * @Title : UISendPush Controller
 * @date : 2015. 6. 5.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 *
 */
@Controller
public class UISendPushController extends UIBaseController{
	
	@Resource (name = "UIPushMessageTargetService")
	private UIPushMessageTargetService pushMessageTargetService;
	
	
	/**
	 * 푸시 알림 보내기 기능
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/device/push/send")
	public ModelAndView pushSend(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		String resultCode = UIApiConstant._SUCCESS_CODE;
		
		UIPushMessageTargetVO pushMessageTarget = new UIPushMessageTargetVO();
		
		requiredSession(req, pushMessageTarget);
		
		String memberSeqs = req.getParameter("memberSeqList");
		
		String[] memberSeqListString = memberSeqs.split(",");
		
		Long[] memberSeqList = new Long[memberSeqListString.length];
		
		for(int i=0; i < memberSeqListString.length; i++){
			memberSeqList[i] = Long.parseLong(memberSeqListString[i]); 
		}
		
		pushMessageTarget.setMemberSeqs(memberSeqList);
		pushMessageTarget.setPushMessageType(req.getParameter("pushType"));
		pushMessageTarget.setPushTitle(req.getParameter("pushTitle"));
		pushMessageTarget.setPushMessage(req.getParameter("pushMessage"));
		
		int resultCnt = pushMessageTargetService.pushSendMember(pushMessageTarget);
		
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.addObject("resultCnt", resultCnt);
		mav.setViewName("jsonView");
		return mav;
	}
}
