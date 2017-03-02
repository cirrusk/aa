<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"           value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_ONOFF_TYPE_ON"                value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"       value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"  value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forScoreTarget   = null;
var forTemplateLayer   = null;
var forTargetLayer   = null;
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
	
	//datepicker
	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>', minDate : "<aof:date datetime="${homework.endDtime}"/>"});
	</c:if>
	<c:if test="${homework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
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
	forListdata.config.url    = "<c:url value="/univ/course/active/homework/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/active/homework/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	forScoreTarget = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScoreTarget.config.url             = "<c:url value="/univ/course/active/homework/target/score/count.do"/>";
	forScoreTarget.config.target          = "hiddenframe";
	forScoreTarget.config.fn.complete     = doCompleteScoreTarget;

	forTemplateLayer = $.action("layer");
	forTemplateLayer.config.formId         = "FormBrowseTemplate";
	forTemplateLayer.config.url            = "<c:url value="/univ/course/homework/template/list/popup.do"/>";
	forTemplateLayer.config.options.width  = 700;
	forTemplateLayer.config.options.height = 500;
	forTemplateLayer.config.options.title  = "<spring:message code="필드:과제:과제매핑"/>";
	
	// 탬플릿 내용 호출
	forTemplate = $.action();
	forTemplate.config.formId = "FormInsert";
	forTemplate.config.url    = "<c:url value="/univ/course/active/homework/create.do"/>";
	
	forTargetLayer = $.action("layer");
	forTargetLayer.config.formId         = "FormInsert";
	forTargetLayer.config.url            = "<c:url value="/univ/course/active/homework/target/popup.do"/>";
	forTargetLayer.config.options.width  = 900;
	forTargetLayer.config.options.height = 530;
	forTargetLayer.config.options.title  = "<spring:message code="필드:과제:대상자보기"/>";
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:과제:과제제목"/>",
		name : "homeworkTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:과제:과제내용"/>",
		name : "description",
		data : ["!null"]
	});
	
	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		
		forInsert.validator.set({
	        title : "<spring:message code="필드:과제:1차과제시작기간"/>",
	        name : "startDate",
	        data : ["!null"],
	        check : {
	            le : {name : "endDate", title : "<spring:message code="필드:과제:1차과제종료기간"/>"}
	        }
	    });
		
		forInsert.validator.set({
	        title : "<spring:message code="글:과제:1차대비배점"/>",
	        name : "rate2",
	        data : ["!null", "decimalnumber"],
	        when : function() {
				var form = UT.getById(forInsert.config.formId);
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
		
		forInsert.validator.set({
	        title : "<spring:message code="필드:과제:1차과제종료기간"/>",
	        name : "endDate",
	        data : ["!null"],
	        when : function() {
				var form = UT.getById(forInsert.config.formId);
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
	</c:if>
	
	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	
		forInsert.validator.set({
	        title : "<spring:message code="필드:과제:제출시작기간"/>",
	        name : "startDay",
	        data : ["!null","number"],
	        check : {
	            le : {name : "endDay", title : "<spring:message code="필드:과제:제출종료기간"/>"}
	        }
	    });
		
		forInsert.validator.set({
	        title : "<spring:message code="필드:과제:제출종료기간"/>",
	        name : "endDay",
	        data : ["!null","number"],
	        check : {
	        	le : {name : "studyDayOfCourseActive", title : "<spring:message code="글:총학습일수"/>"}
	        }
	    });
		
	</c:if>
	
	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		forInsert.validator.set({
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

/**
 * 저장
 */
doInsert = function() {
	
	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
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
    </c:if>
    
	// editor 값 복사
	UI.editor.copyValue();
	forInsert.run();
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
 * 과제 템플릿 팝업호출
 */
doTemplatePopup = function(){
	forTemplateLayer.run();
};

/**
 * 대상자 팝업호출
 */
doTargetLayer = function(){
	forTargetLayer.run();
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
 * 파일삭제(템플릿 적용시)
 */
doDeleteFile = function(element, seq, copyId) {
    var $element = jQuery(element);
    var $file = $element.closest("div");
    var $uploader = $element.closest(".uploader");
    var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
    var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
    seqs.push(seq);
    $attachDeleteInfo.val(seqs.join(","));
    $file.remove();
    
    // 탬플릿 정보 삭제
    $("#"+ copyId + seq).remove();
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	if (swfu != null) {
		var form = UT.getById(forInsert.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

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
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_HOMEWORK}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">

	<div class="lybox-title"><!-- lybox-title -->
	    <h4 class="section-title">
	    	<c:if test="${homework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	    		<spring:message code="필드:과제:과제등록" />
	    	</c:if>
	    	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	    		<spring:message code="필드:과제:보충과제등록" />
	    	</c:if>
	    </h4>
	</div>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${homework.courseActiveSeq}"/>"/>
	    <input type="hidden" name="referenceSeq" 	value="<c:out value="${homework.referenceSeq}"/>"/>
	    <input type="hidden" name="referenceRate" 		value="<c:out value="${homework.referenceRate}"/>"/>
	    <input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
	    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	    <input type="hidden" name="answerSubmitCount" value="0"/>
	    <input type="hidden" name="editYn" value="N"/>
	    
	    <input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
	    <input type="hidden" name="start2Dtime"/>
	    <input type="hidden" name="end2Dtime"/>
	    
	    <input type="hidden" name="replaceYn" value="${empty homework.replaceYn ? 'N':homework.replaceYn}"/> 
	    <input type="hidden" name="basicSupplementCd" value="${empty homework.basicSupplementCd ? CD_BASIC_SUPPLEMENT_BASIC : homework.basicSupplementCd}"/> 
	    
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
	                <aof:code name="onoffCd" type="radio" codeGroup="ONOFF_TYPE" defaultSelected="${CD_ONOFF_TYPE_ON}"></aof:code>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:대상자"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	            		<input type="text"   name="limitScorePrint" id="limitScorePrint" value="0" size="6" class="align-r"> 
	            		<input type="hidden" name="limitScore"      id="limitScore"      value="0" size="6"> 
	            		<spring:message code="글:과제:점이하"/>&nbsp;
	            		<a onclick="doScoreTarget();" class="btn gray"><span class="small"><spring:message code="버튼:확인"/></span></a>
	            		<div class="vspace"></div>
		                <c:out value="${applyCount}"/> <spring:message code="글:명"/> / <input type="text" id="applyCountText" value="<c:out value="${nonSubmitCount}"/> 명" disabled="disabled" size="6" class="align-r"> 
		            	&nbsp;
		            	<a href="#" onclick="doTargetLayer();" class="btn gray"><span class="small"><spring:message code="버튼:과제:대상자보기"/></span></a>
		            </c:if>
		            <c:if test="${homework.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            	<c:out value="${applyCount}"/> <spring:message code="글:명"/>
		            </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:과제제목"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<a href="#" onclick="doTemplatePopup();" class="pop-call-btn" title="<spring:message code="글:과제:템플릿팝업호출"/>" >&nbsp;</a>
	                <input type="text" name="homeworkTitle" style="width:350px;" value="<c:out value="${homeworkTemplate.homeworkTemplate.templateTitle}"/>">
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:과제내용"/> <span class="star">*</span>
	            </th>
	            <td>
	                <input type="hidden" name="editorPhotoInfo">
	                <textarea name="description" id="description" style="width:100%; height:300px"><c:out value="${homeworkTemplate.homeworkTemplate.templateDescription}" /></textarea>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code="필드:게시판:첨부파일"/></th>
	            <td>
	                <!-- 탬플릿 파일-->
	                <c:forEach var="row" items="${homeworkTemplate.homeworkTemplate.attachList}" varStatus="i">
	                    <input type="hidden" name="attachSeqs" id="templateFile${row.attachSeq}" value="${row.attachSeq}"/>
	                </c:forEach>
	                <!--  신규 파일-->
	                <input type="hidden" name="attachUploadInfo"/>
	                <input type="hidden" name="attachDeleteInfo">
	                <div id="uploader" class="uploader">
	                    <c:if test="${!empty homeworkTemplate.homeworkTemplate.attachList}">
	                        <c:forEach var="row" items="${homeworkTemplate.homeworkTemplate.attachList}" varStatus="i">
	                            <div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>', 'templateFile')" class="previousFile">
	                                <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
	                            </div>
	                        </c:forEach>
	                    </c:if>
	                </div>
	                <span class="vbom"><c:out value="${attachSize}"/>MB</span>
	            </td>
	        </tr>
	     <c:if test="${homework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	        <tr>
	            <th><spring:message code="필드:과제:배점비율"/></th>
	            <td>
	                <input type="text" name="rate" style="width: 30px;" class="align-r"> %
	            </td>
	        </tr>
	     </c:if>
	     <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	        <tr>
	            <th>
	                <spring:message code="필드:과제:1차제출기간"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<spring:message code="글:시작"/>&nbsp;
	                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;">&nbsp;
	                <select name="startTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	                <spring:message code="글:분"/>
	                ~
	                <spring:message code="글:종료"/>&nbsp;
	                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;">&nbsp;
	                <select name="endTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	                <spring:message code="글:분"/>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:2차제출기간"/>
	            </th>
	            <td>
	            	<spring:message code="필드:과제:사용여부"/>&nbsp;
	            	<select name="useYn" onchange="changeRate2(this);">
	            		<aof:code type="option" codeGroup="USEYN" removeCodePrefix="true" defaultSelected="N"></aof:code>
	            	</select>
	            	<span id="rate2_span" style="display: none;">
		            	<spring:message code="글:과제:1차대비배점"/>&nbsp;
		            	<input type="text" name="rate2" style="width: 30px;" class="align-r"> %
		                <spring:message code="글:종료"/>&nbsp;
		                <input type="text" name="end2Date" id="end2Date" class="datepicker" readonly="readonly" style="width: 70px;">&nbsp;
		                <select name="end2Time">
		                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
		                </select>
		                <spring:message code="글:분"/>
	                </span>
	            </td>
	        </tr>
	     </c:if>
	     <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	     	<tr>
	            <th>
	                <spring:message code="필드:과제:제출기간"/> <span class="star">*</span>
	            </th>
				<td>
					<spring:message code="글:수강시작"/>
	                <input type="text" name="startDay" id="startDay" class="align-r" style="width: 50px;">&nbsp;
	                <spring:message code="글:일부터"/>
	                ~
	                <input type="text" name="endDay" id="endDay" class="align-r" style="width: 50px;">&nbsp;
	                <spring:message code="글:일까지"/>
	                (<spring:message code="글:이과정은"/><c:out value="${studyDayOfCourseActive}"/><spring:message code="글:일과정입니다"/>)
	                <input type="hidden" name="studyDayOfCourseActive" value="<c:out value="${studyDayOfCourseActive}"/>"/>
				</td>
	        </tr>
	     </c:if>
	        <tr>
	            <th>
	                <spring:message code="필드:과제:성적공개여부"/> <span class="star">*</span>
	            </th>
	            <td>
	                
	                <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" removeCodePrefix="true"/>
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
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	        </div>
	    </div>
	  </div>
	</body>
</html>