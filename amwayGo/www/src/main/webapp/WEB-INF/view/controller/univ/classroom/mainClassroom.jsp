<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE"    value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var $contentWrapper = null;
var openedLayerType 		= ""; // 현재 오픈된 레이어 구분
var fElement 				= null; //현재 사용하고 있는 레이어 Element (히든 프레임 사이즈 조정에 사용)
var forClassroom 			= null; //타 강의실 바로가기
var forHomeLayer 			= null; //토론, 과제, 팀프로젝트 상세 이동시 사용되는 action
var forPlanLayer 			= null; //강의계획서
var forBbsLayer 			= null; //게시판 공통
var forHomeAjax 			= null; // 토론, 과제, 팀프로젝트 상세에서 닫힐시 ajax 동작할때 사용되는 action
var forStudyClassroomAjax 	= null; // 온라인 학습 목록
var forLearning 			= null;	// 온라인 학습창
var forTotalProgress 		= null; // 온라인 닫힐 시 최신 강의진도정보 가져올때 사용
var forNowFirstStudy 		= null; // 홈에서 학습하기 클릭시 가장 먼저 학습할수 있는 강의가 무엇인지 가져온다.
var forDetailTeamProject    = null; // 팀프로젝트
var forExamPaper			= null; // 시험지 팝업
var forExamPaperAjax		= null; // 시험지 팝업 후 호출되는 ajax
var forSurveyPaper			= null; // 설문 팝업
var forSurveyPaperAjax		= null; // 설문 팝업 후 호출되는 ajax
var forCourseBbsAjax 		= null; // 과정게시판 호출 ajax
var forCourseBbsNewsAjax 	= null; // 새소식 호출 ajax

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
    //온라인 학습 목록 뿌리기
	doStudyClassroomAjax();
    
    //과정게시판 새소식 호출
	doCourseBbsNewsAjax();
    
    //과정게시판 목록 호출
	doCourseBbsAjax();	
    
	$contentWrapper = jQuery("#content-wrapper");
	$contentWrapper.scrollLeft($contentWrapper.width());
	
	jQuery(".content").on("swipeleft", function() {
		doNext()
	});
	jQuery(".content").on("swiperight", function() {
		
		doPrev()
	});
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	//타 강의실 바로가기에 사용
	forClassroom = $.action();
	forClassroom.config.formId = "FormClassroom";
	forClassroom.config.url    = "<c:url value="/usr/classroom/main.do"/>";
	
	//학습메인 iframe 호출 공통 action
	forHomeLayer = $.action();
	forHomeLayer.config.target = "iframe-home";
	forHomeLayer.config.fn.before = function() {
		jQuery("#content-home").hide();
		jQuery("#waiting-home").show();
		return true;
	};

	//게시판 iframe 호출 공통 action
	forBbsLayer = $.action();
	forBbsLayer.config.formId = "FormBbs";
	forBbsLayer.config.target = "iframe-bbs";
	forBbsLayer.config.fn.before = function() {
		jQuery("#content-bbs").hide();
		jQuery("#waiting-bbs").show();
		return true;
	};
	
	//학습메인 ajax 호출 공통 action
	forHomeAjax = $.action("ajax");
	forHomeAjax.config.type        	= "html";
	forHomeAjax.config.fn.complete = function() {};
	
	//강의계획서 출력
	forPlanLayer = $.action("layer");
	forPlanLayer.config.formId      = "FormHome";
	forPlanLayer.config.url = "<c:url value="/usr/classroom/plan/detail/popup.do"/>";
	forPlanLayer.config.options.width = 1006;
	forPlanLayer.config.options.height = 800;
	forPlanLayer.config.options.draggable = false;
	forPlanLayer.config.options.titlebarHide = true;
	forPlanLayer.config.options.backgroundOpacity = 0.9;
	
	//온라인 학습 리스트 ajax
	forStudyClassroomAjax = $.action("ajax");
	forStudyClassroomAjax.config.formId      = "FormStudyClassroom";
	forStudyClassroomAjax.config.url = "<c:url value="/usr/classroom/course/active/element/organization/list/ajax.do"/>";
	forStudyClassroomAjax.config.type        = "html";
	forStudyClassroomAjax.config.containerId = "online-lecture";
	forStudyClassroomAjax.config.fn.complete = function() {};
	
	//학습창 액션
	forLearning = $.action("layer");
	forLearning.config.formId = "FormLearning";
	forLearning.config.url    = "<c:url value="/learning/simple/popup.do"/>";
	forLearning.config.options.width = 1006;
	forLearning.config.options.height = 860;
	forLearning.config.options.draggable = false;
	forLearning.config.options.titlebarHide = true;
	forLearning.config.options.backgroundOpacity = 0.9;
	forLearning.config.options.callback  = doStudyReplace;
	
	//전체, 학습자 총 진도율 가져오기 json 
	forTotalProgress = $.action("ajax", {formId : "FormTotalProgress"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forTotalProgress.config.type        = "json";
	forTotalProgress.config.url         = "<c:url value="/usr/classroom/course/active/element/organization/total/json.do"/>";
	forTotalProgress.config.fn.complete = function(action, data) {
		
		if(data.totalProgress != null){
			//평균진도 출력 수정
			var tagTotalPercentStr = "<span>" + data.totalProgress.element.totalProgressMeasure + "%</span> (" + data.totalProgress.element.totalAttendMeasure + "/" + data.totalProgress.element.totalItemCnt + ")";
			jQuery("#totalPercent").html(tagTotalPercentStr);
			jQuery("#totalPercentBar").css( "width", data.totalProgress.element.totalProgressMeasure + "%" );
			
			//나의진도 출력 수정
			var tagApplyPercentStr = "<span>" + data.applyTotalProgress.element.totalProgressMeasure + "%</span> (" + data.applyTotalProgress.element.totalAttendMeasure + "/" + data.applyTotalProgress.element.totalItemCnt + ")";
			jQuery("#applyPercent").html(tagApplyPercentStr);
			jQuery("#applyPercentBar").css( "width", data.applyTotalProgress.element.totalProgressMeasure + "%" );
			
			//나의온라인 출석 현황 출력
			var tagApplyAttendStr = "<spring:message code="글:과정:출석"/> : <span>" + data.applyTotalProgress.element.attendTypeAttendCnt + "<spring:message code="글:과정:회"/></span> " +
									"<spring:message code="글:과정:지각"/> : <span>" + data.applyTotalProgress.element.attendTypePerceptionCnt + "<spring:message code="글:과정:회"/></span> " +
									"<spring:message code="글:과정:결석"/> : <span>" + data.applyTotalProgress.element.attendTypeAbsenceCnt + "<spring:message code="글:과정:회"/></span> ";
			jQuery("#applyAttend").html(tagApplyAttendStr);
			
			//총 학습횟수 수정
			jQuery("#attemptTotal").html(data.applyTotalProgress.element.attemptTotal);
		}
	};
	
	//현재 가장 먼저 학습할수 있는 콘텐츠 정보를 가져온다.
	forNowFirstStudy = $.action("ajax", {formId : "FormTotalProgress"});
	forNowFirstStudy.config.type        = "json";
	forNowFirstStudy.config.url         = "<c:url value="/usr/classroom/course/active/element/organization/now/study/json.do"/>";
	forNowFirstStudy.config.fn.complete = function(action, data) {
		if(data.firstStudy != null){
			doLearning({
				'organizationSeq' : data.firstStudy.organization.organizationSeq ,
				'itemSeq' : data.firstStudy.item.itemSeq ,
				'itemIdentifier' : data.firstStudy.item.identifier ,
				'height' : data.firstStudy.organization.height ,
				'width' : data.firstStudy.organization.width ,
				'completionStatus' : data.firstStudy.learnerDatamodel.completionStatus ,
				'courseId' : '<c:out value="${courseActive.courseActive.courseActiveSeq}"/>'
			});
		}else{//현재 학습할 수 있는 강의를 모두 완료 하였을시
			$.alert({message : "<spring:message code='글:과정:현재학습가능한강의는모두완료하였습니다'/>"});
		}
	};
	/*
	forDetailTeamProject = $.action("ajax");
	forDetailTeamProject.config.formId = "FormDetailTeam";
	forDetailTeamProject.config.url    = "<c:url value="/usr/classroom/teamproject/detail.do"/>";
	forDetailTeamProject.config.fn.before = function() {
        jQuery("#content-home").hide();
        jQuery("#waiting-home").show();
        return true;
    };
    */
    forDetailTeamProject = $.action();
    forDetailTeamProject.config.formId = "FormDetailTeam";
    forDetailTeamProject.config.target = "iframe-home";
    forDetailTeamProject.config.url    = "<c:url value="/usr/classroom/teamproject/detail.do"/>";
    forDetailTeamProject.config.fn.before = function() {
        jQuery("#content-home").hide();
        jQuery("#waiting-home").show();
        return true;
    };
    
  //시험지 호출
    forExamPaper = $.action("layer");
    forExamPaper.config.formId         = "FormExamPaper";
    forExamPaper.config.options.titlebarHide = true;
    forExamPaper.config.options.callback = doExamPaperAjax;
    
  //시험지 ajax 호출
	forExamPaperAjax = $.action("ajax");
	forExamPaperAjax.config.type        	= "html";
	forExamPaperAjax.config.formId        	= "FormExamPaper";
	forExamPaperAjax.config.fn.complete = function() {};
	
  //설문지 호출
    forSurveyPaper = $.action("layer");
    forSurveyPaper.config.formId         = "FormSurveyPaper";
    forSurveyPaper.config.url 		= "<c:url value="/usr/classroom/surveypaper/detail/popup.do"/>";
    forSurveyPaper.config.options.width  = 1006;
    forSurveyPaper.config.options.height = 800;
    forSurveyPaper.config.options.titlebarHide = true;
    forSurveyPaper.config.options.callback = doSurveyPaperAjax;
    
  //설문지 ajax 호출
	forSurveyPaperAjax = $.action("ajax");
	forSurveyPaperAjax.config.type        	= "html";
	forSurveyPaperAjax.config.formId        	= "FormSurveyPaper";
	forSurveyPaperAjax.config.url 		= "<c:url value="/usr/classroom/surveypaper/detail/ajax.do"/>";
	forSurveyPaperAjax.config.fn.complete = function() {};
	
	// 과정 게시판 ajax 호출
	forCourseBbsAjax = $.action("ajax");
	forCourseBbsAjax.config.formId      = "FormBbs";
	forCourseBbsAjax.config.url = 	  "<c:url value="/usr/classroom/course/bbs/list/ajax.do"/>";
	forCourseBbsAjax.config.type        = "html";
	forCourseBbsAjax.config.containerId = "content-bbs";
	forCourseBbsAjax.config.fn.complete = function() {};

	//새소식 ajax 호출
	forCourseBbsNewsAjax = $.action("ajax");
	forCourseBbsNewsAjax.config.formId      = "FormBbs";
	forCourseBbsNewsAjax.config.url = 	  "<c:url value="/usr/classroom/course/bbs/news/list/ajax.do"/>";
	forCourseBbsNewsAjax.config.type        = "html";
	forCourseBbsNewsAjax.config.containerId = "bbs-news";
	forCourseBbsNewsAjax.config.fn.complete = function() {};
	
};

/**
 * 타강의실 이동 함수
 */
doClassroom = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forClassroom.config.formId);
	// 상세화면 실행
	forClassroom.run();
};

/**
 * 강의실 나가기
 */
doExit = function(url) {
	var action = $.action();
	action.config.formId = "FormExit";
	action.config.url    = url;
	action.run();
};

/**
 * 강의계획서 팝업 호출
 */
doPlanLayer = function(){
	forPlanLayer.run();
};

/**
 * 레이어 형식의 iframe 닫기
 */
doCloseLayer = function() {
    switch(openedLayerType) {
    case "homework":
    	
        break;
    case "discuss":
    	forHomeAjax.config.formId   = "FormDiscussDetail";
    	forHomeAjax.config.url 		= "<c:url value="/usr/classroom/discuss/detail/ajax.do"/>";
    	forHomeAjax.run();
    	break;
    }	
    
    openedLayerType = ""; // 초기화
    
	if (isOpenedHomeLayer() == true) {
		jQuery("#" + forHomeLayer.config.target).attr("src", "about:blank").hide();
		jQuery("#content-home").show();
	}
	if (isOpenedBbsLayer() == true) {
		
		doCourseBbsAjax(); //과정게시판 재호출
		doCourseBbsNewsAjax(); //새소식 재호출
		
		jQuery("#" + forBbsLayer.config.target).attr("src", "about:blank").hide();
		jQuery("#content-bbs").show();
	}
};
/**
 * 이동
 */
doMove = function(index) {
	if (isOpenedLayer() == true) {
		return;
	}

	var $navigation = jQuery("#content-navigation");
	var $navi = $navigation.find("li");
	var maxIndex = $navi.length - 1;
	var prevIndex = 0;
	$navi.each(function(i) {
		var $this = jQuery(this);
		if ($this.hasClass("on")) {
			prevIndex = i;
			return false; // break each
		}
	});
	if (prevIndex == index) { // no move
		return;
	}
	$navigation.attr("class", "nav");
	$navi.removeClass("on");
	$navi.each(function(i) {
		if (i == index) {
			var $this = jQuery(this);
			$navigation.addClass($this.attr("class"));
			$this.addClass("on");
			return false; // break each
		}
	});
	
	if (prevIndex == 0 && index == maxIndex) {
		doPrev(index);
	} else if (prevIndex == maxIndex && index == 0) {
		doNext(index);
	} else if (prevIndex - index < 0) {
		doNext(index);
	} else if (prevIndex - index > 0) {
		doPrev(index);
	}
};
/**
 * 이전
 */
doPrev = function(index) {
	if (isOpenedLayer() == true) {
		return;
	}
	
	if (typeof index === "number") {
		var $wrapper = jQuery("#content-wrapper");
		var $visible = $wrapper.find(">div:visible");
		$visible.hide();
		$wrapper.find(">div").eq(index).show("slide", {"direction" : "right"});
		
		doCloseLayer();
		
	} else {
		var $navigation = jQuery("#content-navigation");
		var $navi = $navigation.find(".navi-item");
		var currIndex = 0;
		$navi.each(function(i) {
			var $this = jQuery(this);
			if ($this.hasClass("on")) {
				currIndex = i;
				return false; // break each
			}
		});
		var prevIndex = (currIndex == 0 ? $navi.length - 1 : currIndex - 1);  
		doMove(prevIndex);
	}
};
/**
 * 다음
 */
doNext = function(index) {
	if (isOpenedLayer() == true) {
		return;
	}

	if (typeof index === "number") {
		var $wrapper = jQuery("#content-wrapper");
		var $visible = $wrapper.find(">div:visible");
		$visible.hide();
		$wrapper.find(">div").eq(index).show("slide", {"direction" : "left"});
		
		doCloseLayer();
		
	} else {
		var $navigation = jQuery("#content-navigation");
		var $navi = $navigation.find(".navi-item");
		var currIndex = 0;
		$navi.each(function(i) {
			var $this = jQuery(this);
			if ($this.hasClass("on")) {
				currIndex = i;
				return false; // break each
			}
		});
		var nextIndex = (currIndex == $navi.length - 1 ? 0 : currIndex + 1);  
		doMove(nextIndex);
	}
};


/**
 * 스크롤 멈춤
 */
doScrollStop = function() {
	var $navigation = jQuery("#content-navigation");
    var $navi = $navigation.find(".navi-item");
    
    var index = parseInt($contentWrapper.find(".content:eq(1)").attr("index"), 10);
    $navigation.attr("class", "nav"); //reset
    $navi.removeClass("on"); // reset
    
    var $active = $navi.filter(":eq(" + index + ")");
    $navigation.addClass($active.attr("class"));
    $active.addClass("on");
    
    if ($navigation.hasClass("m01")) {
    	jQuery("#sort-icon").show();
    } else {
    	jQuery("#sort-icon").hide();
    }
};
/**
 * 홈 레이어 오픈
 */
doOpenHomeLayer = function(type, mapPKs) {
	openedLayerType = type;
	forHomeLayer.config.formId = "";
	
	switch(type) {
	case "homework":
		
		forHomeLayer.config.formId = "FormHomeworkDetail";
		forHomeLayer.config.url    = "<c:url value="/usr/classroom/homework/create/answer/popup.do"/>";
		break;
	case "discuss":
		
		forHomeLayer.config.formId     = "FormDiscussDetail";
		forHomeLayer.config.url    	   = "<c:url value="/usr/classroom/bbs/discuss/list/iframe.do"/>";
		forHomeAjax.config.containerId = "discuss_" + mapPKs.discussSeq;
    	
		break;
	}
	if (forHomeLayer.config.formId != "") {
	    UT.getById(forHomeLayer.config.formId).reset();
	    UT.copyValueMapToForm(mapPKs, forHomeLayer.config.formId);
	    forHomeLayer.run();
	}
};
/**
 * 과정게시판 레이어
 */
 doOpenBbsLayer = function(url, boardSeq, iconType) {
	forBbsLayer.config.url = url;
	
	var form = UT.getById(forBbsLayer.config.formId);
	form.elements["srchBoardSeq"].value = boardSeq;
	form.elements["iconType"].value = iconType;
	forBbsLayer.run();
};

/**
 * 홈 레이어 로딩 완료
 */
doLoadedHomeLayer = function(element) {
	fElement = element;
	jQuery("#waiting-home").hide();
	if (isOpenedHomeLayer() == true) {
		jQuery("#" + forHomeLayer.config.target).css("height", "760px");
		UT.noscrollIframe(element);
		jQuery("#" + forHomeLayer.config.target).show();
	}
};

/**
 * 과정게시판 레이어 로딩 완료
 */
doLoadedBbsLayer = function(element) {
	jQuery("#waiting-bbs").hide();
	if (isOpenedBbsLayer() == true) {
	
		jQuery("#" + forBbsLayer.config.target).css("height", "760px");
		UT.noscrollIframe(element);
		jQuery("#" + forBbsLayer.config.target).show();
	}
};

//iframe 사이즈 재조정
doNoscrollIframeClassroom = function(){
	jQuery(fElement).css("height", "760px");
	UT.noscrollIframe(fElement);
};

/**
 * 레이어 형식의 iframe이 열려 있는지 검사 
 */
isOpenedLayer = function() {
	if (isOpenedHomeLayer() == true) {
		return true;
	}
	if (isOpenedBbsLayer() == true) {
		return true;
	}
	return false;	
};
/**
 * 홈 레이어 iframe이 열려 있는지 검사
 */
isOpenedHomeLayer = function() {
	try {
		var homeFrame = UT.getById(forHomeLayer.config.target);
		if (typeof homeFrame.contentWindow.initPage === "function") {
			return true;
		}
	} catch (e) {
		return false;
	}
	return false;	
};
/**
 * 과정게시판 레이어 iframe이 열려 있는지 검사
 */
isOpenedBbsLayer = function() {
	try {
		var bbsFrame = UT.getById(forBbsLayer.config.target);
		if (typeof bbsFrame.contentWindow.initPage === "function") {
			return true;
		}
    } catch (e) {
        return false;
    }
	return false;	
};

/**
 * 온라인 학습 강의 목록 가져오기
 */
doStudyClassroomAjax = function(){
	forStudyClassroomAjax.run();
};

/**
 * 전체진도율 json으로 가져오기 호출
 */
doTotalProgress = function(){
	forTotalProgress.run();
};

/**
 * 학습창
 */
doLearning = function(mapPKs) {
	// 학습하기화면 form을 reset한다.
	UT.getById(forLearning.config.formId).reset();
	// 학습하기화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forLearning.config.formId);
	// 학습하기화면 실행
	if(forLearning.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
		forLearning.config.popupWindow.close();
		forLearning.config.popupWindow = null;
		setTimeout("forLearning.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	} else {
		forLearning.run();
	}
};

/**
 * 학습기간이 아닐시 안내 문구
 */
doNotStudyAlert = function (){
	$.alert({message : "<spring:message code='글:과정:현재학습기간이아닙니다'/>"});
};

/**
 * 학습창을 닫을시 호출되는 메소드
 */
doStudyReplace = function(){
	setTimeout("doStudyClassroomAjax()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	doTotalProgress(); 
};

/**
 * 현재 학습을 할수 있는 가장 처음 강의정보 가져오기
 */
doNowFirstStudy = function(){
	forNowFirstStudy.run();
};

/**
 * 과정더보기 열기
 */
doOpenMoreCourse = function() {
	jQuery("#more-course").show();
};
/**
 * 과정더보기 닫기
 */
doCloseMoreCourse = function() {
	jQuery("#more-course").hide();
};

/**
 * 시험, 과제에서 사용합니다. 일반과제 보충과제로 화면에서 바꿔주는 로직
 */
doChangeArticle = function(targetArticle, changeArticle){
	var target = jQuery("#"+targetArticle).html();
	var change = jQuery("#"+changeArticle).html();
	
	change = change.replace("doChangeArticle()","doChangeArticle('" + targetArticle +"','" + changeArticle +"')");
	
	jQuery("#"+targetArticle).html(change);
	jQuery("#"+changeArticle).html(target);
};

/**
 * 공지사항 더보기
 */
doGoNoticeMore = function(url,bbsSeq,iconType){
	jQuery("#content-bbs").hide();
	doMove(2);
	
	setTimeout("doOpenBbsLayer('"+url+"',"+bbsSeq+",'"+iconType+"')", 500);
	//doOpenBbsLayer(url,bbsSeq);
}

/**
 * 팀프로젝트 상세보기 가져오기 실행.
 */
 doDetailTeamProject = function(mapPKs) {
    //UT.getById(forDetailTeamProject.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailTeamProject.config.formId);
    forDetailTeamProject.run();
};
/**
 * 시험지 레이어 팝업 호출
 */
doExamPaperPopup = function(mapPKs) {
	
	if (mapPKs.resultYn == 'Y') {
		if (mapPKs.onOffTypeCd != 'ON') {
			forExamPaper.config.options.width  = 750;
		    forExamPaper.config.options.height = 320;
			forExamPaper.config.url = "<c:url value="/usr/classroom/exampaper/offline/result/detail/layer.do"/>";
		} else {
			forExamPaper.config.options.width  = 1006;
		    forExamPaper.config.options.height = 800;
			forExamPaper.config.url = "<c:url value="/usr/classroom/exampaper/result/detail/layer.do"/>";
		}
	} else {
		forExamPaper.config.options.width  = 1006;
	    forExamPaper.config.options.height = 800;
		forExamPaper.config.url = "<c:url value="/usr/classroom/exampaper/detail/layer.do"/>";
	}
	UT.copyValueMapToForm(mapPKs, forExamPaper.config.formId);
	forExamPaperAjax.config.containerId = mapPKs.targetNumber;
	
	if (mapPKs.elementType == 'exam') {
		forExamPaperAjax.config.url 		= "<c:url value="/usr/classroom/exampaper/detail/ajax.do"/>";
	} else if (mapPKs.elementType == 'quiz'){
		forExamPaperAjax.config.url 		= "<c:url value="/usr/classroom/quiz/detail/ajax.do"/>";
	} else {
		forExamPaperAjax.config.url 		= "<c:url value="/usr/classroom/exampaper/nondegree/detail/ajax.do"/>";
	}
	
    forExamPaper.run();
};
/**
 * 시험지 호출 후 ajax 실행
 */
doExamPaperAjax = function() {
	forExamPaperAjax.run();
};
/**
 * 설문지 레이어 팝업 호출
 */
doSurveyPaperPopup = function(mapPKs) {
	UT.copyValueMapToForm(mapPKs, forSurveyPaper.config.formId);
	forSurveyPaperAjax.config.containerId = "surveyPaper_" + mapPKs.courseActiveSurveySeq;
	
    forSurveyPaper.run();
};
/**
 * 설문지 호출 후 ajax 실행
 */
doSurveyPaperAjax = function() {
	forSurveyPaperAjax.run();
};
/**
 * 정렬 오픈
 */
doOpenSorting = function(obj, isClose){
	if (isClose) {
		$(obj).next().toggle();
	} else {
		$(obj).parent().hide();
	}
};

/**
 * 정렬
 */
doSort = function(element, orderby) {
	var $element = jQuery(element);
	var $parent = $element.closest(".array-list");
	$parent.find("a").removeClass("on");
	$element.addClass("on");
	$parent.hide();
	
	var $content = jQuery("#content-home");
	var sortable = [];
	$content.find(".article").filter(".sortable").each(function() {
		sortable.push(jQuery(this));
	});
	
	var compare = null;
	switch (orderby) {
	case "1" : // 분류순 (오름차순) type [과제-1,중간고사-2,기말고사-3,토론-4,팀프로젝트-5,설문-6,퀴즈-7] 
	    compare = function(a, b) {
		    var typeA = parseInt(a.attr("type"), 10); 
		    var typeB = parseInt(b.attr("type"), 10); 
	        if (typeA > typeB) {
	            return 1;
	        } else if (typeA < typeB) {
	            return -1;
	        } else {
	            var dateA = parseInt(a.attr("date"), 10); 
	            var dateB = parseInt(b.attr("date"), 10); 
	            if (dateA > dateB) {
	                return 1;
	            } else if (dateA < dateB) {
	                return -1;
	            } else {
	                return 0;
	            }
	        }
	    };
	    break;
	case "2" : // 제출종료일순 (오름차순) - date [대기-888,종료-999로 할 것]
	    compare = function(a, b) {
	        var dateA = parseInt(a.attr("date"), 10); 
	        var dateB = parseInt(b.attr("date"), 10); 
	        if (dateA > dateB) {
	            return 1;
	        } else if (dateA < dateB) {
	            return -1;
	        } else {
	            var typeA = parseInt(a.attr("type"), 10); 
	            var typeB = parseInt(b.attr("type"), 10); 
	            if (typeA > typeB) {
	                return 1;
	            } else if (typeA < typeB) {
	                return -1;
	            } else {
	                return 0;
	            }
	        }
	    };
		break;
	default :
		return;
	}
	sortable.sort(compare);
	
	for (var i = 0; i < sortable.length; i++) {
		sortable[i].appendTo($content);
	}
};

/*
 * 과정게시판 호출
 */
doCourseBbsAjax = function(){
	forCourseBbsAjax.run();
};

 
/*
 * 새소식 호출
 */
doCourseBbsNewsAjax = function(){
	forCourseBbsNewsAjax.run();
};

</script>
</head>

<body>

	<!-- 타강의실 바로가기 폼 -->
	<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>
	
	<form name="FormClassroom" id="FormClassroom" method="post" onsubmit="return false;">
		<input type="hidden" name="currentMenuId" value="<c:out value="${currentMenuId}"/>"/>
		<input type="hidden" name="courseApplySeq"/>
        <input type="hidden" name="courseActiveSeq"/>
	</form>		

	<!-- header -->
	<div class="header">
		<!-- 총 진도정보 -->
		<div class="my-info">
			<c:if test="${not empty totalProgress}">
				<div class="average">
					<strong><spring:message code="글:과정:평균진도"/></strong>
					<div class="progress">
						<p class="bar" style="width:<c:out value="${totalProgress.element.totalProgressMeasure}"/>%;" id="totalPercentBar"><aof:img src="bg/bar_blue.png" alt="글:과정:평균진도" /><span class="left"></span><span class="right"></span></p>
					</div>
					<p class="percent" id="totalPercent"><span><c:out value="${totalProgress.element.totalProgressMeasure}"/>%</span> (<aof:number value="${totalProgress.element.totalAttendMeasure}" pattern="###.#"/>/<c:out value="${totalProgress.element.totalItemCnt}"/>)</p>
				</div>
			</c:if>
			<c:if test="${empty totalProgress}">
				<div class="average">
					<strong><spring:message code="글:과정:평균진도"/></strong>
					<div class="progress">
						<p class="bar" style="width:0%;" id="totalPercentBar"><aof:img src="bg/bar_blue.png" alt="글:과정:평균진도" /><span class="round"></span></p>
					</div>
					<p class="percent" id="totalPercent"><span>0%</span> (0/0)</p>
				</div>
			</c:if>
			<c:if test="${not empty applyTotalProgress}">
				<div class="my">
					<strong><spring:message code="글:과정:나의진도"/></strong>
					<div class="progress">
						<p class="bar" style="width:<c:out value="${applyTotalProgress.element.totalProgressMeasure}"/>%;" id="applyPercentBar"><aof:img src="bg/bar_red.png" alt="글:과정:나의진도" /><span class="left"></span><span class="right"></span></p>
					</div>
					<p class="percent" id="applyPercent"><span><aof:number value="${applyTotalProgress.element.totalProgressMeasure}" pattern="###.#"/>%</span> (<aof:number value="${applyTotalProgress.element.totalAttendMeasure}" pattern="###.#"/>/<c:out value="${applyTotalProgress.element.totalItemCnt}"/>)</p>
				</div>
				<p class="attend" id="applyAttend">
					<spring:message code="글:과정:출석"/> : <span><c:out value="${applyTotalProgress.element.attendTypeAttendCnt}"/><spring:message code="글:과정:회"/></span> 
					<spring:message code="글:과정:지각"/> : <span><c:out value="${applyTotalProgress.element.attendTypePerceptionCnt}"/><spring:message code="글:과정:회"/></span> 
					<spring:message code="글:과정:결석"/> : <span><c:out value="${applyTotalProgress.element.attendTypeAbsenceCnt}"/><spring:message code="글:과정:회"/></span>
				</p>
			</c:if>
			<c:if test="${empty applyTotalProgress}"><!-- 온라인 학습 데이터 자체가 없을시 사용 -->
				<div class="my">
					<strong><spring:message code="글:과정:나의진도"/></strong>
					<div class="progress">
						<p class="bar" style="width:0%;" id="applyPercentBar"><aof:img src="bg/bar_red.png" alt="글:과정:나의진도" /><span class="round"></span></p>
					</div>
					<p class="percent" id="applyPercent"><span>0%</span> (0/0)</p>
				</div>
				<p class="attend" id="applyAttend">
					<spring:message code="글:과정:출석"/> : <span>0<spring:message code="글:과정:회"/></span> 
					<spring:message code="글:과정:지각"/> : <span>0<spring:message code="글:과정:회"/></span> 
					<spring:message code="글:과정:결석"/> : <span>0<spring:message code="글:과정:회"/></span>
				</p>
			</c:if>
		</div>
		
		<!-- 개설과목 정보 -->
		<div class="my-subject">
			<h1>
				<span><c:out value="${courseActive.courseActive.year}"/><spring:message code="글:년"/></span> 
				<span><aof:code type="print" codeGroup="TERM_TYPE" selected="${courseActive.courseActive.term}" removeCodePrefix="true"/></span>
				<c:out value="${courseActive.courseActive.courseActiveTitle}"/> 
				
			</h1>
			<p class="info">
				<c:if test="${not empty courseActive.courseMaster.completeDivisionCd}">
					<span><aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${courseActive.courseMaster.completeDivisionCd}"/></span>
				</c:if>
				<span><c:out value="${courseActive.courseMaster.completeDivisionPoint}"/><spring:message code="글:수강:학점"/></span>
				<span>
					<c:forEach var="row" items="${courseActive.lecturerList}" varStatus="i">
						<c:if test="${i.count ne 1}">,</c:if>
						<c:out value="${row.member.memberName}"/>
					</c:forEach>
				</span>
				<a href="javascript:void(0)" class="plan" onclick="doPlanLayer();"><spring:message code="버튼:수강:강의계획서"/></a>
			</p>
			<c:if test="${not empty applyList.itemList}">
				<p class="view"><spring:message code="글:과정:과정더보기"/> <a href="javascript:void(0)" onclick="doOpenMoreCourse()"><aof:img src="/common/icon_view.png" alt="글:과정:과정더보기" /></a></p>
				<!-- my-course -->
				<div class="my-course" style="display: none;" id="more-course">
					<h3><spring:message code="글:과정:수강중인과정이동"/></h3>
					<div class="course-list">
						<ul>
							<c:forEach var="row" items="${applyList.itemList}" varStatus="i">
								<li>
									<a href="#" onclick="doClassroom({'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq}" />','courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq}" />'});">
										<c:if test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}"><!-- 학위 -->
											<span><c:out value="${fn:substring(row.apply.yearTerm,0,4)}"/><spring:message code="글:년"/></span>
											<span><aof:code type="print" codeGroup="TERM_TYPE" selected="${fn:substring(row.apply.yearTerm,4,6)}"/></span>
										</c:if>
										<c:if test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}"><!-- 비학위 -->
											<c:if test="${not empty row.apply.yearTerm}">
												<span><c:out value="${fn:substring(row.apply.yearTerm,0,4)}"/><spring:message code="글:년"/></span>
											</c:if>
										</c:if>
										<c:out value="${row.active.courseActiveTitle}"/>
									</a>
								</li>
							</c:forEach>
						</ul>
					</div>
					<a href="javascript:void(0)" onclick="doCloseMoreCourse()" class="close"><aof:img src="/btn/btn_layer_close.gif" alt="닫기" /></a>
				</div>
			</c:if>
			<!-- //my-course -->
		</div>
		
		<form name="FormExit" id="FormExit" method="post" onsubmit="return false;">
			<input type="hidden" name="currentMenuId" value="<c:out value="${currentMenuId}"/>"/>
		</form>		
		<c:choose>
			<c:when test="${currentMenuId eq '001001001'}"><c:set var="urlExit"><c:url value="/usr/mypage/course/apply/list.do"/></c:set></c:when>
			<c:when test="${currentMenuId eq '001001002'}"><c:set var="urlExit"><c:url value="/usr/mypage/course/apply/review/list.do"/></c:set></c:when>
			<c:when test="${currentMenuId eq '001002001'}"><c:set var="urlExit"><c:url value="/usr/mypage/course/apply/non/list.do"/></c:set></c:when>
			<c:when test="${currentMenuId eq '001002002'}"><c:set var="urlExit"><c:url value="/usr/mypage/course/apply/non/review/list.do"/></c:set></c:when>
			<c:otherwise><c:set var="urlExit"><c:url value="/usr/mypage/course/apply/list.do"/></c:set></c:otherwise>
		</c:choose>
		<a href="javascript:void(0)" class="out" onclick="doExit('<c:out value="${urlExit}"/>')" title="<spring:message code="메뉴:강의실:강의실나가기"/>"><spring:message code="메뉴:강의실:강의실나가기"/></a>
	</div>
	<!-- //header -->

	<!-- container -->
	<div class="container">
		<div class="nav m01" id="content-navigation">
			<ul class="tablist">
				<li class="navi-item m01 on"><a href="javascript:void(0)" onclick="doMove(0)" title="<spring:message code="메뉴:강의실:강의실홈"/>"><spring:message code="메뉴:강의실:강의실홈"/></a></li>
				<li class="navi-item m02"><a href="javascript:void(0)" onclick="doMove(1)" title="<spring:message code="메뉴:강의실:온라인학습"/>"><spring:message code="메뉴:강의실:온라인학습"/></a></li>
				<li class="navi-item m03"><a href="javascript:void(0)" onclick="doMove(2)" title="<spring:message code="메뉴:강의실:과정게시판"/>"><spring:message code="메뉴:강의실:과정게시판"/></a></li>
			</ul>
			
			<a href="javascript:void(0)" onclick="doOpenSorting(this,true)" class="array" id="sort-icon"><aof:img src="/btn/btn_array.gif" alt="필드:강의실:정렬" /></a>
			<!-- array-list -->
			<div class="array-list">
				<strong><spring:message code="필드:강의실:정렬"/></strong>
				<ul>
                    <li><a href="javascript:void(0)" onclick="doSort(this, '1')"><spring:message code="필드:강의실:분류순(과제시험토론팀프로젝트)"/><span class="check"></span></a></li>
					<li><a href="javascript:void(0)" onclick="doSort(this, '2')"><spring:message code="필드:강의실:제출종료일순"/><span class="check"></span></a></li>
				</ul>
				<a href="javascript:void(0)" onclick="doOpenSorting(this,false)"  class="close"><aof:img src="/btn/btn_array_list.gif" alt="닫기" /></a>
			</div>
			<!-- //array-list -->
		</div>
	
		<div id="content-wrapper" class="slides">
               
            <div class="content main" index="0" >
                <c:import url="./include/homeClassroom.jsp"/>
                <div id="waiting-home" style="display:none;"></div>
                <iframe id="iframe-home" name="iframe-home" frameborder="no" scrolling="no" style="width:100%; display:none; " onload="doLoadedHomeLayer(this)" ></iframe>
            </div>
        
            <div class="content" index="1" style="display:none;">
                <c:import url="./include/studyClassroom.jsp"/>  
            </div>
            
            <div class="content" index="2" style="display:none;">
                <c:import url="./include/bbsClassroom.jsp"/>
                <div id="waiting-bbs" style="display:none;"></div>
                <iframe id="iframe-bbs" name="iframe-bbs" frameborder="no" scrolling="no" style="width:100%; display:none;" onload="doLoadedBbsLayer(this)"></iframe>
            </div>
		</div>
		<div class="slides-nav">
			<a href="javascript:void(0)" onclick="doPrev()" class="prev" title="<spring:message code="버튼:이전"/>"><spring:message code="버튼:이전"/></a>
			<a href="javascript:void(0)" onclick="doNext()" class="next" title="<spring:message code="버튼:다음"/>"><spring:message code="버튼:다음"/></a>
		</div>
	</div>
	<!-- //container -->
	
</body>
</html>