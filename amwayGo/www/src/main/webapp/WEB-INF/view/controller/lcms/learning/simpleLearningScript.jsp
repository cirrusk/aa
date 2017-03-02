<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CONTENTS_TYPE_SCORM"  value="${aoffn:code('CD.CONTENTS_TYPE.SCORM')}"/>
<c:set var="CD_CONTENTS_TYPE_XINICS" value="${aoffn:code('CD.CONTENTS_TYPE.XINICS')}"/>

<script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/lib/jquery.learning.simple.api.min.js"></script>
<script type="text/javascript">
var API_1484_11 = API;
var contentsFrame = null;
var blankPage = "<c:url value="/common/learningBlank.jsp"/>";
var SUB = {
	/**
	 * 페이지 시작
	 */
	initPage : function() {
		
		var checkResult = "<c:out value="${checkResult}"/>";
		
		if(checkResult == "N"){
			$.alert({
		        message : "<spring:message code='글:콘텐츠:유효하지않은데이터입니다'/>",
		        button1 : {
		            callback : function() {
		            	SUB.doClose();
		            }
		        }
		    });
			
		}else{
			<c:if test="${ocwYn eq 'Y'}">
				API.url.initialize = "<c:url value="/learning/api/simple/ocw/initialize.do"/>";
				API.url.terminate  = "";
				API.url.commit     = "";
				API.url.restore    = "";
				API.url.othersData = "";
			</c:if>
			<c:if test="${ocwYn ne 'Y'}">
				API.url.initialize = "<c:url value="/learning/api/simple/initialize.do"/>";
				API.url.terminate  = "<c:url value="/learning/api/simple/terminate.do"/>";
				API.url.commit     = "<c:url value="/learning/api/simple/commit.do"/>";
				API.url.restore    = "<c:url value="/learning/api/simple/restore.do"/>";
				API.url.othersData = "<c:url value="/learning/api/simple/get/others/data.do"/>";
			</c:if>
			var contentsValid = "<c:out value="${empty learning.itemSeq ? 'false' : 'true'}"/>";
			if (contentsValid === "false") {
				$.alert({
					message : "<spring:message code="글:콘텐츠:준비중인강좌입니다"/>",
					button1 : {
						callback : function() {
							SUB.doClose();
						}
					}
				});
				return;
			}
			var $contents = jQuery("#contentsFrame");
			$contents.show();
			SUB.doStart();
			//SUB.doDebug(); // debug 창에서 doStart가 호출된다. 
		}
	},
	/**
	 * 콘텐츠 시작
	 */
	doStart : function() {
		API_1484_11.restore();
		contentsFrame = UT.getById("contentsFrame");
		var ctx = "<c:out value="${aoffn:config('upload.context.lcms')}"/>";
		var url = "<c:out value="${learning.itemToLaunch}"/>";
		var found = true;
		if (url != "") {
			API_1484_11.learningData.organizationSeq = "<c:out value="${learning.organizationSeq}"/>";
			API_1484_11.learningData.itemSeq = "<c:out value="${learning.itemSeq}"/>";
			API_1484_11.learningData.courseId = "<c:out value="${learning.courseId}"/>";
			API_1484_11.learningData.applyId = "<c:out value="${learning.applyId}"/>";
			API_1484_11.learningData.startTime = "<c:out value="${learning.startTime}"/>";
			API_1484_11.learningData.contentTypeCd = "<c:out value="${learning.contentTypeCd}"/>";
			API_1484_11.learningData.completionType = "<c:out value="${learning.completionType}"/>";
			API_1484_11.learningData.accessToken = "<c:out value="${learning.accessToken}"/>";
		}
		if (found && url != "") {
			contentsFrame.src = ctx + "/" + url;
		} else {
			contentsFrame.src = blankPage;
		}
		
		$(window).bind('beforeunload', function() {
			contentsFrame.src = blankPage;
		});
		
		<c:if test="${learning.contentTypeCd ne CD_CONTENTS_TYPE_SCORM}">
			API_1484_11.Initialize("");// 비표준 Initialize는 콘텐츠 프레임영역이 호출되기 이전에 동작하게 수정하였습니다.
		</c:if>
	},
	/**
	 * 콘텐츠 영역이 로드가 완료되었을 때 호출됨.
	 */
	onLoadIframe : function() {
		if (contentsFrame != null && contentsFrame.src.endsWith(blankPage) == false) {
			<c:if test="${learning.contentTypeCd ne CD_CONTENTS_TYPE_SCORM && learning.contentTypeCd ne CD_CONTENTS_TYPE_XINICS}">
				jQuery(window).unload(function() {
					API_1484_11.Terminate("");
				});	
			</c:if>
		};
	},
	/**
	 * 창 닫기
	 */
	doClose : function() {
		if ($layer != null) {
			$layer.dialog("close");
		}
	},
	/**
	 * 탭 보기기/감추기
	 */
	doToggleTab : function(element, targetId) {
		var $element = jQuery(element);
		var $target = jQuery("#" + targetId);
		
		if ($target.is(":visible")) {
			$element.removeClass("tab-on");
			$target.removeClass("tab-section-visible");
			jQuery(".section-contents > .data").removeClass("chrome-downsize-height");
		} else {
			jQuery(".tabs-bottom-left > .tab").removeClass("tab-on");
			jQuery(".tabs-bottom-right > .tab").removeClass("tab-on");
			$element.addClass("tab-on");
			$target.addClass("tab-section-visible").siblings(".tab-section").removeClass("tab-section-visible");
			jQuery(".section-contents > .data").addClass("chrome-downsize-height");
	
			if (targetId == "log") {
	
			} else if (targetId == "external-search") {
				var searchFrame = UT.getById("searchFrame");
				if (typeof searchFrame.contentWindow.SUB === "undefined") {
					SUB.doExternalSearch(element);
				}
			}
		}
	},
	/**
	 * 탭 닫기
	 */
	doCloseTab : function(element) {
		jQuery(".tabs-www-bottom-left > .tab").removeClass("tab-on");
		jQuery(".tabs-www-bottom-right > .tab").removeClass("tab-on");
		jQuery(".section-contents > .data").removeClass("chrome-downsize-height");
		jQuery(element).closest(".tab-section").removeClass("tab-section-visible");
	},
	/**
	 * 외부 검색
	 */
	doExternalSearch : function(element) {
		var action = $.action();
		action.config.formId = "SubFormSrch";
		action.config.target = "searchFrame";
		action.config.url    = "<c:url value="/learning/external/search.do"/>";
	
		var $element = jQuery(element);
		if ($element.length == 0) {
			$element = jQuery(".tabs-www-bottom-left > .tab-on");
		}
		if ($element.length == 0) {
			return;
		}
		var site = $element.attr("site");
		var form = UT.getById(action.config.formId);
		form.elements["site"].value = site;
		if (form.elements["site"].value == "") {
			return;
		}
		action.run();
	},
	/**
	 * 로깅
	 */
	doDebug : function() {
		var action = $.action();
		action.config.formId = "SubFormLog";
		action.config.target = "logFrame";
		action.config.url = "<c:url value="/learning/simple/log.do"/>";
		action.run();
		
		API_1484_11.debug.on = true;
		API_1484_11.debug.callback = function(log) {
			window.frames["logFrame"].SUB.doLogging(log);
			SUB.doLearningStatus(log);
		};
	},
	/**
	 * 상태
	 */
	doLearningStatus : function(log) {
		if (typeof log.state === "string" && typeof log.success === "boolean") {
			var showId = "";
			var hideId = "";
			switch(log.state) {
			case "[Initialize]":
				showId = "initialize-" + String(log.success);
				hideId = "initialize-" + String(!log.success);
				break;
			case "[Terminate]":
				showId = "terminate-" + String(log.success);
				hideId = "terminate-" + String(!log.success);
				break;
			default: // setValue, getValue
				showId = "values-" + String(log.success);
			    hideId = "values-" + String(!log.success);
				break;
			}
			jQuery("#" + showId).show();
			jQuery("#" + hideId).hide();
		}
	},
	/**
	 * 버튼
	 */
	doButton : function(button) {
		switch (button) {
		case "exit": // 학습종료
			contentsFrame.src = blankPage;
			break;
		case "clear": // 로그지우기
			window.frames["logFrame"].SUB.doClearConsole();
			break;
		}
	}
};

//비표준 진도율 쌓을때 사용되는 스크립트 진도저장
function _progressSave(progress){
	var oldProgress = API_1484_11.GetValue("cmi.progress_measure");
	if(oldProgress < progress){
		API_1484_11.SetValue("cmi.progress_measure", progress);
		API_1484_11.Commit();
	};
};

//비표준 진도율 쌓을때 사용되는 스크립트 마지막 학습한 페이지 가져오기
function _getPageInfo(){
	var pageInfo = API_1484_11.GetValue("cmi.location");
	if(pageInfo == 'false'){
		return '';
	}else{
		return pageInfo;
	};
};

//비표준 진도율 쌓을때 사용되는 스크립트 학습페이지 저장
function _setPageInfo(page){
	API_1484_11.SetValue("cmi.location", page);
	API_1484_11.Commit();
};

//비표준 특정 값 등록
function _setValue(element, value){
	API_1484_11.SetValue(element, value);
	API_1484_11.Commit();
};

//비표준 특정 입력한 값 가져오기
function _getValue(element){
	var value = API_1484_11.GetValue(element);
	if(value == 'false'){
		return '';
	}else{
		return value;
	};
};

//해당 element에 해당 하는 값이 들어있는지 확인하는 메소드 리턴값 true&false로 전달
function _isValue(element){
	var value = API_1484_11.GetValue(element);
	if(value == 'false'){
		return false;
	}else{
		return true;
	};
};

</script>
