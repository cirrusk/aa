<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_ONOFF_TYPE_ON"                  value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"         value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"    value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"       value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"        value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var forScoreTarget   = null;
var forScoreTargetInput   = null;
var forTemplateLayer   = null;
var forTargetLayer   = null;
var forInsertlist = null;
var forDeletelist = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "<c:out value='${attachSize}'/>MB",
				fileUploadLimit : 0, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
	
	<c:if test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		UI.datepicker(".datepicker",{ showOn: "both", 
			buttonImage: '<aof:img type='print' src='common/calendar.gif'/>', 
			minDate : "<aof:date datetime="${detail.courseHomework.finalEndDtime}"/>"}
		);
	</c:if>
	<c:if test="${detail.courseHomework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>', });
	</c:if>

	// editor
	UI.editor.create("description");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/active/homework/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/course/active/homework/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	forScoreTarget = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScoreTarget.config.url             = "<c:url value="/univ/course/active/homework/target/score/updatecount.do"/>";
	forScoreTarget.config.target          = "hiddenframe";
	forScoreTarget.config.message.confirm = "<spring:message code="글:과제:대상자를재설정하시겠습니까"/>"; 
	forScoreTarget.config.fn.complete     = doCompleteScoreTarget;
	
	forTemplateLayer = $.action("layer");
	forTemplateLayer.config.formId         = "FormBrowseTemplate";
	forTemplateLayer.config.url            = "<c:url value="/univ/course/homework/template/list/popup.do"/>";
	forTemplateLayer.config.options.width  = 700;
	forTemplateLayer.config.options.height = 700;
	forTemplateLayer.config.options.title  = "<spring:message code="필드:과제:과제매핑"/>";
	
	// 탬플릿 내용 호출
	forTemplate = $.action();
	forTemplate.config.formId = "FormUpdate";
	forTemplate.config.url    = "<c:url value="/univ/course/active/homework/edit.do"/>";
	
	// 대상자 카운트만 하여 숫자만 바꿔준다.
	forScoreTargetInput = $.action("submit", {formId : "FormUpdate"});
	forScoreTargetInput.config.formId 		= "FormUpdate";
	forScoreTargetInput.config.url    		= "<c:url value="/univ/course/active/homework/target/count.do"/>";
	forScoreTargetInput.config.target       = "hiddenframe";
	forScoreTargetInput.config.fn.complete  = doCompleteScoreTarget;
	
	forTargetLayer = $.action("layer");
	forTargetLayer.config.formId         = "FormUpdate";
	forTargetLayer.config.url            = "<c:url value="/univ/course/active/homework/target/popup.do"/>";
	forTargetLayer.config.options.width  = 900;
	forTargetLayer.config.options.height = 570;
	forTargetLayer.config.options.title  = "<spring:message code="필드:과제:대상자보기"/>";
	forTargetLayer.config.options.callback  = doScoreTargetView;
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forScoreTarget.validator.set({
        title : "<spring:message code="필드:과제:대상자점수"/>",
        name : "limitScorePrint",
        data : ["!null","number"],
        check : {
        	le : 100
        }
    });
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제:과제제목"/>",
		name : "homeworkTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:과제:과제내용"/>",
		name : "description",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:과제:1차과제시작기간"/>",
        name : "startDate",
        data : ["!null"],
        check : {
            le : {name : "endDate", title : "<spring:message code="필드:과제:1차과제종료기간"/>"}
        }
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="글:과제:1차대비배점"/>",
        name : "rate2",
        data : ["!null", "decimalnumber"],
        when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["useYn"].value == 'Y') {
				return true;
			} else {
				return false;
			}
        },
        check : {
        	le : 100
        }
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:과제:1차과제종료기간"/>",
        name : "endDate",
        data : ["!null"],
        when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["useYn"].value == 'Y') {
				return true;
			} else {
				return false;
			}
        },
        check : {
            le : {name : "start2Date", title : "<spring:message code="필드:과제:2차과제시작기간"/>"}
        }
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:과제:1차과제종료기간"/>",
        name : "start2Date",
        data : ["!null"],
        when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["useYn"].value == 'Y') {
				return true;
			} else {
				return false;
			}
        },
        check : {
            le : {name : "end2Date", title : "<spring:message code="필드:과제:2차과제종료기간"/>"}
        }
    });
	
	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">	
		forUpdate.validator.set({
	        title : "<spring:message code="필드:과제:배점비율"/>",
	        name : "rate",
	        data : ["!null", "decimalnumber"],
	        check : {
	        	le : 100
	        }
	    });
		
		forScoreTarget.validator.set({
	        title : "<spring:message code="필드:과제:대상자점수"/>",
	        name : "limitScorePrint",
	        data : ["!null","number"],
	        check : {
	        	le : 100
	        }
	    });
	</c:if>
};

doScoreTargetView = function(){
	forScoreTargetInput.run();
};

/**
 * 저장
 */
doUpdate = function() {
	
	var startDate = $("input[name=startDate]").val();
	var startTime = $("select[name=startTime]").val();
	var endDate = $("input[name=endDate]").val();
    var endTime = $("select[name=endTime]").val();
	
    $("input[name=startDtime]").val(replaceAll(startDate)+startTime + "00");
    $("input[name=endDtime]").val(replaceAll(endDate)+endTime + "00");
	
    if($("select[name=useYn]").val() == 'Y'){
	    var start2Date = $("input[name=endDate]").val();
		var start2Time = $("select[name=endTime]").val();
		var end2Date = $("input[name=end2Date]").val();
	    var end2Time = $("select[name=end2Time]").val();
		
	    $("input[name=start2Dtime]").val(replaceAll(start2Date)+start2Time + "00");
	    $("input[name=end2Dtime]").val(replaceAll(end2Date)+end2Time + "00");
    }
	// editor 값 복사
	UI.editor.copyValue();
	forUpdate.run();
};

/**
 * 대상자 확인
 */
doScoreTarget = function() {
	jQuery("#limitScore").val(jQuery("#limitScorePrint").val());
	forScoreTarget.run();
};

/**
 * 대상자 확인결과
 */
doCompleteScoreTarget = function(success) {
	jQuery("#applyCountText").val(success + " 명");
};

replaceAll = function(str)
{
    return str.split("-").join("");
};

/**
 * 2차 제출기간 출력여부
 */
changeRate2 = function(input){
	if(input.value == 'Y'){
		jQuery("#rate2_span").show();
	}else{
		jQuery("#rate2_span").hide();
	}
}

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	if (swfu != null) {
		var form = UT.getById(forUpdate.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
};

/**
 * 파일삭제(템플릿 적용파일 삭제)
 */
doDeleteTemplateFile = function(element, seq, copyId) {
    var $element = jQuery(element);
    var $file = $element.closest("div");
    $file.remove();
    
    // 탬플릿 정보 삭제
    $("#"+ copyId + seq).remove();
};

/**
 * 과제 템플릿 팝업호출
 */
doTemplatePopup = function(){
	forTemplateLayer.run();
};

/**
 * 과제 템플릿 데이터 등록
 */
doTemplateInsert = function(returnValue){	
	var $form = jQuery("#" + forTemplate.config.formId);
	jQuery("<input type='hidden' name='templateSeq' value='" + returnValue.templateSeq + "'>").appendTo($form);
	
	forTemplate.run();
		
};

/**
 * 대상자 팝업호출
 */
doTargetLayer = function(){
	forTargetLayer.run();
};

/**
 * 파일삭제(원본파일)
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};

/**
 * 파일삭제(템플릿 적용파일 삭제)
 */
doDeleteTemplateFile = function(element, seq, copyId) {
    var $element = jQuery(element);
    var $file = $element.closest("div");
    $file.remove();
    
    // 탬플릿 정보 삭제
    $("#"+ copyId + seq).remove();
};

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:import url="srchHomework.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:choose>
	<c:when test="${examType eq 'middle'}">
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/>
		</c:import>
	</c:otherwise>
</c:choose>

<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">

	<div class="lybox-title"><!-- lybox-title -->
	    <h4 class="section-title">
			<c:if test="${homework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	    		<c:choose>
					<c:when test="${examType eq 'middle'}">
						<spring:message code="필드:과제:중간고사대체과제수정" />
					</c:when>
					<c:otherwise>
						<spring:message code="필드:과제:기말고사대체과제수정" />
					</c:otherwise>
				</c:choose>
	    	</c:if>
	    	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	    		<c:choose>
					<c:when test="${examType eq 'middle'}">
						<spring:message code="필드:과제:중간고사미응시자보충과제수정" />
					</c:when>
					<c:otherwise>
						<spring:message code="필드:과제:기말고사미응시자보충과제수정" />
					</c:otherwise>
				</c:choose>
	    	</c:if>
	    </h4>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	    <input type="hidden" name="homeworkSeq" value="<c:out value="${detail.courseHomework.homeworkSeq}"/>"/>
	    <input type="hidden" name="referenceSeq" 	value="<c:out value="${detail.courseHomework.referenceSeq}"/>"/>
	    <input type="hidden" name="referenceType" 	value="<c:out value="${detail.courseHomework.referenceType}"/>"/>
	    <input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseHomework.courseActiveSeq}"/>"/>
	    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	    <input type="hidden" name="answerSubmitCount" value="<c:out value="${detail.courseHomework.answerSubmitCount}"/>"/>
	    <input type="hidden" name="editYn" value="Y"/>
	    
	    <input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
	    <input type="hidden" name="start2Dtime"/>
	    <input type="hidden" name="end2Dtime"/>
	    
	    <input type="hidden" name="replaceYn" value="${detail.courseHomework.replaceYn}"/> 
	    <input type="hidden" name="basicSupplementCd" value="${detail.courseHomework.basicSupplementCd}"/> 
	    
	    <c:choose>
			<c:when test="${examType eq 'middle'}">
				<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_MIDDLE}"/>"/> 
			</c:when>
			<c:otherwise>
				<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_FINAL}"/>"/> 
			</c:otherwise>
		</c:choose>
		
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	    <table class="tbl-detail">
	    <colgroup>
	        <col style="width: 140px" />
	        <col/>
	    </colgroup>
	    <tbody>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:온오프라인"/> <span class="star">*</span>
	            </th>
	            <td>
	                <c:if test="${detail.courseHomework.answerSubmitCount eq 0}">
	                	<aof:code name="onoffCd" type="radio" codeGroup="ONOFF_TYPE" defaultSelected="${CD_ONOFF_TYPE_ON}" selected="${detail.courseHomework.onoffCd}"></aof:code>
	                </c:if>
	            	<c:if test="${detail.courseHomework.answerSubmitCount ne 0}">
	                	<aof:code name="onoffCd" type="print" codeGroup="ONOFF_TYPE" defaultSelected="${CD_ONOFF_TYPE_ON}" selected="${detail.courseHomework.onoffCd}"></aof:code>
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:대상자"/> <span class="star">*</span>
	            </th>
	            <td>
	                <c:if test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	            		<c:if test="${detail.courseHomework.answerSubmitCount eq 0}"><!-- 제출자가 없을시 대상자 수정가능 -->
		            		<input type="text"   name="limitScorePrint" id="limitScorePrint" value="" size="6" class="align-r"> 
		            		<input type="hidden" name="limitScore"      id="limitScore"      value="" size="6" class="align-r"> 
		            		<spring:message code="글:과제:점이하"/>&nbsp;
		            		<a onclick="doScoreTarget();" class="btn gray"><span class="small"><spring:message code="버튼:확인"/></span></a>
		            		<div class="vspace"></div>
			                <c:out value="${targetCount}"/> <spring:message code="글:명"/> / <input type="text" id="applyCountText" value="<c:out value="${detail.courseHomework.targetCount}"/> 명" disabled="disabled" size="6" class="align-r"> 
			            	&nbsp;
			            	<a href="#" onclick="doTargetLayer();" class="btn gray"><span class="small"><spring:message code="버튼:과제:대상자수정"/></span></a>
		            		<div class="vspace"></div>
		            		<span style="color: red;">
		            			<spring:message code="글:과제:과제제출자가있을시대상자수정은불가합니다"/> 
		            			<spring:message code="글:과제:제출기간전에대상자를확정하시기바랍니다"/>
		            		</span>
		            	</c:if>
	            		<c:if test="${detail.courseHomework.answerSubmitCount ne 0}"><!-- 제출자가 있을시 수정불가 -->
			                <c:out value="${targetCount}"/> <spring:message code="글:명"/> / <input type="text" id="applyCountText" value="<c:out value="${detail.courseHomework.targetCount}"/> 명" disabled="disabled" size="6" class="align-r"> 
			            	&nbsp;
			            	<a href="#" onclick="doTargetLayer();" class="btn gray"><span class="small"><spring:message code="버튼:과제:대상자보기"/></span></a>
			            	<div class="vspace"></div>
			            	<span style="color: red;">
		            			<spring:message code="글:과제:과제제출자가있을시대상자수정은불가합니다"/> 
		            		</span>
		            	</c:if>
		            </c:if>
		            <c:if test="${detail.courseHomework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            	<c:out value="${detail.courseHomework.targetCount}"/> <spring:message code="글:명"/>
		            </c:if>
	            </td>
	        </tr>
	     <c:if test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
	     	<tr>
	            <th><spring:message code="필드:과제:주차매핑"/></th>
	        	<td>
	        		<c:set var="oldActiveElementSeq"/>
	        		<select name="activeElementSeq">
		           		<option value=""><spring:message code="글:과제:사용안함"/></option>
			           	<c:forEach var="subRow" items="${elementList}" varStatus="j">
			           		<option value="${subRow.element.activeElementSeq}" <c:if test="${subRow.element.referenceSeq eq detail.courseHomework.homeworkSeq}">selected="selected"</c:if>><c:out value="${subRow.element.sortOrder}" /><spring:message code="글:시험:주차"/></option>
			           		<c:if test="${subRow.element.referenceSeq eq detail.courseHomework.homeworkSeq}">
			           			<c:set var="oldActiveElementSeq" value="${subRow.element.activeElementSeq}"/>
			           		</c:if>
			           	</c:forEach>
		            </select>
		            <input type="hidden" name="oldActiveElementSeq" value="${oldActiveElementSeq}"><!-- 주차매핑 미사용으로 할때 사용 -->
	        	</td>
	        </tr>
	     </c:if>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:과제제목"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<a href="#" onclick="doTemplatePopup();" class="pop-call-btn" title="<spring:message code="글:과제:템플릿팝업호출"/>" >&nbsp;</a>
	                <c:choose>
	                	<c:when test="${!empty homeworkTemplate.homeworkTemplate.templateTitle}">
	                		<input type="text" name="homeworkTitle" value="${homeworkTemplate.homeworkTemplate.templateTitle}" style="width:350px;">
	                	</c:when>
	                	<c:otherwise>
	    	            	<input type="text" name="homeworkTitle" style="width:350px;" value="<c:out value="${detail.courseHomework.homeworkTitle}"/>">
		                </c:otherwise>
	                </c:choose>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:과제내용"/> <span class="star">*</span>
	            </th>
	            <td>
	                <input type="hidden" name="editorPhotoInfo">
	            	<c:choose>
						<c:when test="${!empty homeworkTemplate.homeworkTemplate.templateTitle}">
							<textarea name="description" id="description" style="width:99%; height:300px"><c:out value="${homeworkTemplate.homeworkTemplate.templateDescription}" /></textarea>
						</c:when>
						<c:otherwise>
							<textarea name="description" id="description" style="width:99%; height:300px"><c:out value="${detail.courseHomework.description}"/></textarea>
						</c:otherwise>
					</c:choose>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code="필드:게시판:첨부파일"/></th>
	            <td>
					<c:choose>
		        		<%-- 템플릿이 적용된 수정페이지의 경우 --%>
		        		<c:when test="${!empty homeworkTemplate.homeworkTemplate.templateSeq}">
		        			<input type="hidden" name="attachUploadInfo"/>
			        		<%--  템플릿 적용전 삭제대상 파일셋팅 --%>
							<c:if test="${!empty detail.courseHomework.attachList}">
								<c:set var="deleteAttachInfo" value="" />
								<c:forEach var="row" items="${detail.courseHomework.attachList}" varStatus="i">
									<c:if test="${i.first eq true}">
										<c:set var="deleteAttachInfo" value="${row.attachSeq}"/>
									</c:if>
									<c:if test="${i.first ne true}">
										<c:set var="deleteAttachInfo" value="${deleteAttachInfo},${row.attachSeq}"/>			
									</c:if>						
								</c:forEach>
								<input type="hidden" name="attachDeleteInfo" value="${deleteAttachInfo}" />
		        			</c:if>	
		        			        			
		        			<%--  적용된 템플릿에 파일이 존재하는 경우 --%>
		        			<c:if test="${!empty homeworkTemplate.homeworkTemplate.attachList}">
			        			<c:forEach var="row" items="${homeworkTemplate.homeworkTemplate.attachList}" varStatus="i">
			                   		<input type="hidden" name="attachSeqs" id="templateFile${row.attachSeq}" value="${row.attachSeq}"/>
				                </c:forEach>
	
					            <%-- 신규 파일 --%>
					            <%-- <input type="hidden" name="attachDeleteInfo"> --%>
					            <div id="uploader" class="uploader">
					                <c:if test="${!empty homeworkTemplate.homeworkTemplate.attachList}">
					                    <c:forEach var="row" items="${homeworkTemplate.homeworkTemplate.attachList}" varStatus="i">
					                        <div onclick="doDeleteTemplateFile(this, '<c:out value="${row.attachSeq}"/>', 'templateFile')" class="previousFile">
					                            <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					                        </div>
					                    </c:forEach>
					                </c:if>
					            </div>
		        			</c:if>
		        			
		        			<%-- 적용된 템플릿에 파일이 존재하지 않는 경우 --%>
		        			<c:if test="${empty homeworkTemplate.homeworkTemplate.attachList}">
				                <div id="uploader" class="uploader"></div>	 
		        			</c:if>
		        		</c:when>
		        		<%--  템플릿이 적용되지 않은 수정페이지 일시 --%>
		        		<c:otherwise>
							<input type="hidden" name="attachUploadInfo"/>
							<input type="hidden" name="attachDeleteInfo">
							<div id="uploader" class="uploader">
								<c:if test="${!empty detail.courseHomework.attachList}">
									<c:forEach var="row" items="${detail.courseHomework.attachList}" varStatus="i">
										<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
											<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
										</div>
									</c:forEach>
								</c:if>
							</div>
		        		</c:otherwise>
		        	</c:choose>
				</td>
	        </tr>
	     <c:if test="${detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	        <tr>
	            <th><spring:message code="필드:과제:배점비율"/></th>
	            <td>
	                <input type="text" name="rate" style="width: 30px;" class="align-r" value="${detail.courseHomework.rate}"> %
	            </td>
	        </tr>
	     </c:if>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:1차제출기간"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<c:if test="${appToday <= detail.courseHomework.startDtime or empty detail.courseHomework.startDtime}">
		            	<spring:message code="글:시작"/>&nbsp;
		                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.startDtime}"/>">&nbsp;
		                <select name="startTime">
		                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.startDtime,8,12)}"/>
		                </select>
	                </c:if>
	            	<c:if test="${appToday > detail.courseHomework.startDtime and not empty detail.courseHomework.startDtime}"><!-- 1차 시작일시 지나간 경우 기간 변경 불가 -->
		            	<spring:message code="글:시작"/>&nbsp;
		            	<aof:date datetime="${detail.courseHomework.startDtime}"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.startDtime}" pattern="mm"/><spring:message code="글:분"/>
			         	
		                <input type="hidden" name="startDate" id="startDate" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.startDtime}"/>">&nbsp;
		                <select name="startTime" style="display: none;">
		                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.startDtime,8,12)}"/>
		                </select>
	                </c:if>
	                ~
	                <c:if test="${appToday <= detail.courseHomework.endDtime or empty detail.courseHomework.endDtime}">
		                <spring:message code="글:종료"/>&nbsp;
		                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.endDtime}"/>">
		                <select name="endTime">
		                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.endDtime,8,12)}"/>
		                </select>
		                <spring:message code="글:분"/>
	                </c:if>
	                <c:if test="${appToday > detail.courseHomework.endDtime and not empty detail.courseHomework.endDtime}"><!-- 1차 종료일시 지나간 경우 기간 변경 불가 -->
	                	<spring:message code="글:종료"/>&nbsp;
		            	<aof:date datetime="${detail.courseHomework.endDtime}"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
			         	<aof:date datetime="${detail.courseHomework.endDtime}" pattern="mm"/><spring:message code="글:분"/>
			         	
		                <input type="hidden" name="endDate" id="endDate" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.endDtime}"/>">&nbsp;
		                <select name="endTime" style="display: none;">
		                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.endDtime,8,12)}"/>
		                </select>
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:2차제출기간"/>
	            </th>
	            <td>
		             <c:if test="${appToday < detail.courseHomework.end2Dtime or detail.courseHomework.end2Dtime eq ''}">
			             <spring:message code="필드:과제:사용여부"/>&nbsp;
			             <select name="useYn" onchange="changeRate2(this);">
			         		<aof:code type="option" codeGroup="USEYN" removeCodePrefix="true" defaultSelected="N" selected="${detail.courseHomework.useYn}"/>
			         	</select>
			         	<span id="rate2_span" <c:if test="${detail.courseHomework.useYn eq 'N'}">style="display: none;"</c:if>>
				             <spring:message code="글:과제:1차대비배점"/>&nbsp;
				         	<input type="text" name="rate2" style="width: 30px;" class="align-r" value="<c:out value="${detail.courseHomework.rate2}"/>"> %
				         
				             <spring:message code="글:종료"/>&nbsp;
				             <input type="text" name="end2Date" id="end2Date" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.end2Dtime}"/>">&nbsp;
				             <select name="end2Time">
				                 <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.end2Dtime,8,12)}"/>
				             </select>
				             <spring:message code="글:분"/>
			             </span>
		             </c:if>
		             <c:if test="${appToday >= detail.courseHomework.start2Dtime and detail.courseHomework.start2Dtime ne ''}">
		             	<aof:code type="print" codeGroup="USEYN" removeCodePrefix="true" defaultSelected="N" selected="${detail.courseHomework.useYn}"/> &nbsp;
		             	<span id="rate2_span" <c:if test="${detail.courseHomework.useYn eq 'N'}">style="display: none;"</c:if>>
				             <spring:message code="글:과제:1차대비배점"/>&nbsp;
				             <c:out value="${detail.courseHomework.rate2}"/> %&nbsp;
				             
				             <spring:message code="글:종료"/>&nbsp;
			             	<aof:date datetime="${detail.courseHomework.end2Dtime}"/>&nbsp;
					      	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="HH"/><spring:message code="글:시"/>&nbsp;
					      	<aof:date datetime="${detail.courseHomework.end2Dtime}" pattern="mm"/><spring:message code="글:분"/>
					      	
					      	<input type="hidden" name="useYn" value="<c:out value="${detail.courseHomework.useYn}"/>"/>
					      	<input type="hidden" name="rate2" value="<c:out value="${detail.courseHomework.rate2}"/>"/>
				             <input type="hidden" name="end2Date" id="end2Date" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseHomework.end2Dtime}"/>">&nbsp;
				             <select name="end2Time" style="display: none;">
				                 <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseHomework.end2Dtime,8,12)}"/>
				             </select>
			             </span>
		             </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:성적공개여부"/> <span class="star">*</span>
	            </th>
	            <td>
	                
	                <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" removeCodePrefix="true" selected="${detail.courseHomework.openYn}"/>
	            </td>
	        </tr>
	        <%// 관리자가 아닌 사용자만 저장할수 있다. %>
	        <c:if test="${currentRoleCfString ne 'ADM'}">
	            <tr>
	                <th>
	                    <spring:message code="필드:팀프로젝트:템플릿저장"/>
	                </th>
	                <td>
	                    
	                    <aof:code type="radio" codeGroup="SAVE_YN" name="saveYn" defaultSelected="N" removeCodePrefix="true"/>
	                </td>
	            </tr>
	        </c:if>
	    </tbody>
	    </table>
	    </form>
	    <div class="lybox-btn">
	    	<div class="lybox-btn-l">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and (detail.courseHomework.answerSubmitCount eq 0)}"> <!-- 제출이 하나라도 된 과제는 수정이 안된다. -->
					<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
				</c:if>
			</div>
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
	                <a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	        </div>
	    </div>
	  </div>
	</body>
</html>