/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.FileVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.lcms.service.LcmsContentsOrganizationService;
import com._4csoft.aof.lcms.service.LcmsItemService;
import com._4csoft.aof.lcms.service.LcmsMetadataElementService;
import com._4csoft.aof.lcms.service.LcmsOrganizationService;
import com._4csoft.aof.lcms.vo.LcmsMetadataVO;
import com._4csoft.aof.lcms.vo.LcmsOrganizationVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsMetadataVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.condition.UILcmsMetadataElementCondition;
import com._4csoft.aof.ui.lcms.vo.condition.UILcmsOrganizationCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UIOrganizationController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsOrganizationController extends BaseController {

	@Resource (name = "LcmsOrganizationService")
	private LcmsOrganizationService organizationService;

	@Resource (name = "LcmsContentsOrganizationService")
	private LcmsContentsOrganizationService contentsOrganizationService;

	@Resource (name = "LcmsItemService")
	private LcmsItemService itemService;

	@Resource (name = "LcmsMetadataElementService")
	private LcmsMetadataElementService metadataElementService;

	@Resource (name = "AttachService")
	private AttachService attachService;

	/**
	 * 학습구조 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if ("ADM".equals(ssMember.getCurrentRoleCfString()) == false) { // 관리자 그룹은 전체, 다른 그룹은 자신이 등록한 것 또는 소유자인 것만.
			// 조교, 튜터는 자신이 등록한거 아니면 자신을 자신이 담당하고있는 강사
			if ("ASSIST".equals(ssMember.getCurrentRoleCfString()) || "TUTOR".equals(ssMember.getCurrentRoleCfString())) {
				condition.setSrchAssistMemberSeq(ssMember.getMemberSeq());
			} else {// 교강사 권한일시
				condition.setSrchMemberSeq(ssMember.getMemberSeq());
			}
		}

		mav.addObject("paginate", organizationService.getList(condition));
		mav.addObject("condition", condition);

		UILcmsMetadataElementCondition metadataElementCondition = new UILcmsMetadataElementCondition();
		emptyValue(metadataElementCondition, "currentPage=0");
		Paginate<ResultSet> paginateMetadataElement = metadataElementService.getList(metadataElementCondition);
		if (paginateMetadataElement != null && paginateMetadataElement.getItemList() != null) {
			mav.addObject("listMetadataElement", paginateMetadataElement.getItemList());
		}

		mav.setViewName("/lcms/organization/listOrganization");
		return mav;
	}

	/**
	 * 학습구조 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/list/iframe.do")
	public ModelAndView listIframe(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		if ("ADM".equals(ssMember.getCurrentRoleCfString()) == false) { // 관리자 그룹은 전체, 다른 그룹은 자신이 등록한 것 또는 소유자인 것만.
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}

		mav.addObject("paginate", organizationService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/organization/listOrganizationIframe");
		return mav;
	}

	/**
	 * 학습구조 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/list/ajax.do")
	public ModelAndView listAjax(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		mav.addObject("paginate", organizationService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/organization/listOrganizationAjax");
		return mav;
	}

	/**
	 * 학습구조 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization, UILcmsOrganizationCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", organizationService.getDetail(organization));
		mav.addObject("condition", condition);

		UILcmsContentsOrganizationVO contentsOrganization = new UILcmsContentsOrganizationVO();
		contentsOrganization.setOrganizationSeq(organization.getOrganizationSeq());
		mav.addObject("contentsList", contentsOrganizationService.getListMappingContents(contentsOrganization));

		mav.addObject("itemList", itemService.getList(organization.getOrganizationSeq()));

		mav.setViewName("/lcms/organization/detailOrganization");
		return mav;
	}

	/**
	 * 학습구조 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization, UILcmsOrganizationCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);
		mav.addObject("detail", organization);

		UILcmsMetadataElementCondition metadataElementCondition = new UILcmsMetadataElementCondition();
		emptyValue(metadataElementCondition, "currentPage=0");
		Paginate<ResultSet> paginateMetadataElement = metadataElementService.getList(metadataElementCondition);
		if (paginateMetadataElement != null && paginateMetadataElement.getItemList() != null) {
			mav.addObject("listMetadataElement", paginateMetadataElement.getItemList());
		}
		mav.setViewName("/lcms/organization/createOrganization");
		return mav;
	}

	/**
	 * 학습구조 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @param UILcmsOrganizationCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization, UILcmsOrganizationCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", organizationService.getDetail(organization));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/organization/editOrganization");
		return mav;
	}

	/**
	 * 콘텐츠 수정 화면(소유자변경)
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/member/edit/popup.do")
	public ModelAndView editPopup(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/lcms/organization/editMemberPopup");
		return mav;
	}

	/**
	 * 학습구조 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization, UILcmsMetadataVO metadata) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, organization);

		// 스콤일 경우
		// 업로드 한 경우 : filepath에 값이 있다. (압축 파일 상태)
		// 서버에서 파일을 선택한 경우 : filename에 값이 있다
		if ("CONTENTS_TYPE::SCORM".equals(organization.getContentsTypeCd())) {
			if (StringUtil.isNotEmpty(organization.getFilename())) { // 임시디렉토리로 카피.
				String randomName = StringUtil.getRandomString(20);
				String filepath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd");
				String source = Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP + "/" + organization.getFilename();
				String targetPath = Constants.UPLOAD_PATH_LCMS + filepath;

				File targetDir = new File(targetPath);
				targetDir.mkdirs();

				FileUtil.copy(source, targetPath + "/" + randomName);
				organization.setFilepath(filepath + "/" + randomName);
			}

		} else if ("CONTENTS_TYPE::LINK".equals(organization.getContentsTypeCd())) { // link 일 경우에는 업로드 파일이 존재하지 않으므로 filepath를 만든다.
			organization.setFilepath(Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd") + "/" + StringUtil.getRandomString(20));

		} else {
			// 스콤이 아닌경우(압축이 풀린 상태)
			// 압축이 풀려 있는 상태이므로 파일경로만 넘겨준다.(서비스에서 이동 시킴)
		}

		// item의 메타데이타(비표준 일때만)
		List<LcmsMetadataVO> voList = new ArrayList<LcmsMetadataVO>();
		if (metadata.getMetadataValues() != null) {
			for (int i = 0; i < metadata.getMetadataValues().length; i++) {
				UILcmsMetadataVO o = new UILcmsMetadataVO();
				if (StringUtil.isNotEmpty(metadata.getMetadataValues()[i])) {
					o.setMetadataElementSeq(metadata.getMetadataElementSeqs()[i]);
					o.setMetadataValue(metadata.getMetadataValues()[i]);
					o.setMetadataPath(metadata.getMetadataPaths()[i]);
					o.setReferenceType("item");
					o.copyAudit(organization);

					voList.add(o);
				}
			}
		}
		organization.setMetadataList(voList); // item의 메타데이타
		try {
			organizationService.insertOrganization(organization);
			mav.addObject("result", 1);
		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습구조 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, organization);

		organizationService.updateOrganization(organization);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습구조 다중 수정 처리(소유자변경)
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, organization);

		List<LcmsOrganizationVO> voList = new ArrayList<LcmsOrganizationVO>();
		for (String index : organization.getCheckkeys()) {
			UILcmsOrganizationVO o = new UILcmsOrganizationVO();
			o.setOrganizationSeq(organization.getOrganizationSeqs()[Integer.parseInt(index)]);
			o.setMemberSeq(organization.getMemberSeq());
			o.copyAudit(organization);
			voList.add(o);
		}

		if (voList.size() > 0) {
			mav.addObject("result", organizationService.updatelistOrganizationMemberSeq(voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습구조 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, organization);

		mav.addObject("result", organizationService.deleteOrganization(organization));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습구조 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, organization);

		List<LcmsOrganizationVO> organizations = new ArrayList<LcmsOrganizationVO>();
		for (String index : organization.getCheckkeys()) {
			UILcmsOrganizationVO o = new UILcmsOrganizationVO();
			if (Integer.parseInt(index) > -1) {
				o.setOrganizationSeq(organization.getOrganizationSeqs()[Integer.parseInt(index)]);
				o.copyAudit(organization);

				organizations.add(o);
			}
		}

		if (organizations.size() > 0) {
			mav.addObject("result", organizationService.deletelistOrganization(organizations));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * server의 ftp 디렉토리의 zip 파일 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/serverfile.do")
	public ModelAndView serverfile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String dir = HttpUtil.getParameter(req, "dir", "");
		List<FileVO> dirInfos = new ArrayList<FileVO>();
		List<FileVO> fileInfos = new ArrayList<FileVO>();

		String path = Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP;
		File ftpDir = new File(path);
		if (ftpDir.exists() == false) {
			ftpDir.mkdir();
		}
		if (StringUtil.isNotEmpty(dir)) {
			path += "/" + dir;
		}

		List<File> files = FileUtil.listFiles(path);
		if (files != null) {
			FileUtil.sortByName(files);
			for (File file : files) {
				if (file.getName().toLowerCase().endsWith(".zip")) {
					FileVO fileInfo = new FileVO();
					fileInfo.setSaveName(file.getName());
					fileInfo.setFileSize(file.length());
					fileInfos.add(fileInfo);
				}
			}
		}
		List<File> dirs = FileUtil.listDirectory(path);
		if (dirs != null) {
			FileUtil.sortByName(dirs);
			for (File directory : dirs) {
				FileVO fileInfo = new FileVO();
				fileInfo.setSaveName(directory.getName());
				fileInfo.setFileSize(directory.length());
				dirInfos.add(fileInfo);
			}
		}

		mav.addObject("files", fileInfos);
		mav.addObject("dirs", dirInfos);
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 콘텐츠 zip 파일의 압축풀기<br>
	 * 파일업로드의 경우 : organization.getFilepath()에 임시 저장 파일 경로가 있다.<br>
	 * <br>
	 * server ftp 폴더의 파일이 선택된 경우 : organization.getFilepath()은 empty 이고, organization.getFilename()에 선택된 파일명이 있다.<br>
	 * 해당 파일명(확장자 제외)과 같은 폴더에 압축을 푼다.<br>
	 * <br>
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/organization/unzipfile.do")
	public ModelAndView unzipfile(HttpServletRequest req, HttpServletResponse res, UILcmsOrganizationVO organization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String extractDir = "";
		String filepath = "";
		if (StringUtil.isNotEmpty(organization.getFilepath())) { // 파일업로드의 경우
			String extension = "";
			int index = organization.getFilepath().lastIndexOf(".");
			if (index > -1) {
				extension = organization.getFilepath().substring(index);
			}
			filepath = organization.getFilepath().substring(0, index);

			if (".zip".equalsIgnoreCase(extension) || ".esz".equalsIgnoreCase(extension)) { // 확장자 검사 후 zip 파일이면 압축을 푼다. .esz 파일도 zip 형식이며 자이닉스 콘텐츠가 해당된다.
				String zipFileName = Constants.UPLOAD_PATH_LCMS + organization.getFilepath();
				extractDir = Constants.UPLOAD_PATH_LCMS + filepath + "/";
				try {
					extractDir = FileUtil.unzip(zipFileName, extractDir);
				} catch (IOException e) {
					throw new AofException(Errors.PROCESS_FILE.desc);
				}
			} else { // zip 파일이 아니면 파일명과 같은(확장자 제외) 디렉토리로 파일 이동.

				File source = new File(Constants.UPLOAD_PATH_LCMS + organization.getFilepath());
				extractDir = Constants.UPLOAD_PATH_LCMS + filepath + "/" + source.getName();
				FileUtil.move(source.getAbsolutePath(), extractDir);
			}

			File file = new File(Constants.UPLOAD_PATH_LCMS + organization.getFilepath());
			if (file.exists()) {
				file.delete();
			}

		} else { // 서버의 ftp 경로의 파일을 압축풀기
			filepath = Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd") + "/" + StringUtil.getRandomString(20);
			String zipFileName = Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP + "/" + organization.getFilename();
			extractDir = Constants.UPLOAD_PATH_LCMS + filepath + "/";

			try {
				extractDir = FileUtil.unzip(zipFileName, extractDir);
			} catch (IOException e) {
				throw new AofException(Errors.PROCESS_FILE.desc);
			}
		}

		// 동영상 또는 플래시로만 구성된 콘텐츠인경우 시작파일을 만든다.
		if ("CONTENTS_TYPE::MOVIE".equalsIgnoreCase(organization.getContentsTypeCd())
				|| "CONTENTS_TYPE::FLASH".equalsIgnoreCase(organization.getContentsTypeCd())) {

			List<File> files = FileUtil.listFiles(extractDir);
			FileUtil.sortByName(files);
			String movieFileName = "contents";
			for (File file : files) {
				movieFileName = file.getName();
				break;
			}
			String html = StringUtil.isEmpty(organization.getIndexHtml()) ? "" : organization.getIndexHtml().replaceAll("##REPLACE##", movieFileName);
			try {
				FileUtil.write(extractDir + "index.html", html, "utf-8");
			} catch (IOException e) {
				throw new AofException(Errors.PROCESS_FILE.desc);
			}
		}

		List<File> files = FileUtil.listFiles(extractDir);
		FileUtil.sortByName(files);
		List<FileVO> fileInfos = new ArrayList<FileVO>();

		for (File file : files) {
			String filename = file.getName().toLowerCase();
			if (filename.endsWith(".html") || filename.endsWith(".htm")) {
				FileVO fileInfo = new FileVO();
				fileInfo.setSaveName(file.getName());
				fileInfo.setFileSize(file.length());
				fileInfos.add(fileInfo);
			}
		}
		mav.addObject("files", fileInfos); // 시작 페이지를 지정하기 위한 html 목록
		mav.addObject("filepath", filepath.replaceAll("\\\\", "/"));
		mav.setViewName("jsonView");
		return mav;
	}

}
