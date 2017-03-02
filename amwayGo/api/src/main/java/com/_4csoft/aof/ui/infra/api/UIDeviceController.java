/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.api;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.DeviceService;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.DeviceVO;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.dto.AgentHeaderDTO;
import com._4csoft.aof.ui.infra.vo.UIDeviceVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com.google.gson.Gson;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UIDeviceController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIDeviceController extends UIBaseController {
	@Resource (name = "DeviceService")
	private DeviceService deviceService;

	/**
	 * 단말기 정보 등록 및 체크 단말기는 3대 이상 등록 되지 않는다.
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/device/check")
	public ModelAndView checkDevice(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;

		checkSession(req);

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		Gson gson = new Gson();
		String gsonString = req.getHeader("User-Agent");

		log.debug("request.getHeader('User-Agent)::::" + req.getHeader("User-Agent"));
		AgentHeaderDTO agentHeaderVO = new AgentHeaderDTO();
		// System.out.println("request.getHeader('User-Agent)::::" + request.getHeader("User-Agent"));
		if (gsonString.startsWith("{") == false) {

			// gsonString = "{\"screen_width\":100, \"screen_height\":100, \"os\":\"web\", \"device\":\"mobile\", \"deviceId\":\"7878798498219\"}";

			log.debug("gsonString device off :: " + gsonString);
			// System.out.println("gsonString device off :: " + gsonString);
		} else {
			log.debug("gsonString device on :: " + gsonString);
			// System.out.println("gsonString device on :: " + gsonString);
			agentHeaderVO = gson.fromJson(gsonString, AgentHeaderDTO.class);
		}

		UIDeviceVO device = new UIDeviceVO();

		device.setMemberSeq(ssMember.getMemberSeq());
		requiredSession(req, device);

		List<DeviceVO> deviceList = deviceService.getListDeviceByMember(ssMember.getMemberSeq());

		String deviceMemberId = ssMember.getMemberId();

		if (StringUtil.isEmpty(agentHeaderVO.getDeviceId())) {
			deviceService.deleteInitialization(device);
		} else {

			if (deviceList != null) {
				// 기존 등록되어 있으면 delete
				deviceService.deleteInitialization(device);
			}

			// 등록가능
			device.setDeviceId(agentHeaderVO.getDeviceId());

			// 단말기 구분
			if (agentHeaderVO.getDevice().equals("tablet")) {
				device.setDeviceType("T");
			} else if (agentHeaderVO.getDevice().equals("mobile")) {
				device.setDeviceType("P");
			} else {
				device.setDeviceType("P");
			}

			// 단말기 벤더 구분
			if (agentHeaderVO.getOs().equals("ios")) {
				device.setDeviceVendorType("01");
			} else if (agentHeaderVO.getOs().equals("android")) {
				device.setDeviceVendorType("02");
			} else {
				device.setDeviceVendorType("02");
			}

			deviceService.insertDevice(device);

		}
		mav.addObject("deviceMemberId", deviceMemberId);
		mav.addObject("deviceId", agentHeaderVO.getOs());
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
}
