/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.BookmarkService;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.infra.vo.UIBookmarkVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIBookmarkController.java
 * @Title : 즐겨찾기
 * @date : 2014. 4. 4.
 * @author : 김영학
 * @descrption : 즐겨찾기
 */
@Controller
public class UIBookmarkController extends BaseController {

    @Resource (name = "BookmarkService")
    private BookmarkService bookMarkService;
    
    private final Boolean IS_REMOTE_SESSION_SYNC = true;

    /**
     * Favorite list
     * 
     * @param req
     * @param res
     * @param condition
     * @return
     * @throws Exception
     */
    @RequestMapping ("/infra/bookmark/list/ajax.do")
    public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIBookmarkVO vo) throws Exception {
        ModelAndView mav = new ModelAndView();

        requiredSession(req);
        
        mav.setViewName("/infra/bookmark/listBookmarkAjax");
        return mav;
    }

    /**
     * Favorite insert
     * 
     * @param req
     * @param res
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping ("/infra/bookmark/insert.do")
    public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIBookmarkVO vo) throws Exception {
        ModelAndView mav = new ModelAndView();

        requiredSession(req, vo);

        vo.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
        vo.setRoleGroupSeq(SessionUtil.getMember(req).getCurrentRolegroupSeq());

        bookMarkService.insert(vo, IS_REMOTE_SESSION_SYNC);

        mav.setViewName("/common/save");
        return mav;
    }

    /**
     * Favorite delete
     * 
     * @param req
     * @param res
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping ("/infra/bookmark/delete.do")
    public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIBookmarkVO vo) throws Exception {
        ModelAndView mav = new ModelAndView();

        requiredSession(req, vo);

        vo.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
        vo.setRoleGroupSeq(SessionUtil.getMember(req).getCurrentRolegroupSeq());

        bookMarkService.delete(vo, IS_REMOTE_SESSION_SYNC);

        mav.setViewName("/common/save");
        return mav;
    }

}
