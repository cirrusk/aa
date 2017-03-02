<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"          value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forTemplateLayer = null;
var forTemplateInsert = null;
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
	
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});

	// editor
	UI.editor.create("description");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/discuss/list.do"/>";
	
	forTemplateLayer = $.action("layer");
	forTemplateLayer.config.formId         = "FormBrowseTemplate";
	forTemplateLayer.config.url            = "<c:url value="/univ/course/discuss/template/list/popup.do"/>";
	forTemplateLayer.config.options.width  = 700;
	forTemplateLayer.config.options.height = 500;
	forTemplateLayer.config.options.title  = "<spring:message code="필드:토론:토론매핑"/>";	
		
	// 탬플릿 내용 호출
	forTemplate = $.action();
	forTemplate.config.formId = "FormCreate";
	forTemplate.config.url    = "<c:url value="/univ/course/active/discuss/create.do"/>";
		
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/active/discuss/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function() {
		doList();
	};

	setValidate();
	
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:토론:토론주제"/>",
		name : "discussTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:토론:내용"/>",
		name : "description",
		data : ["!null"]
	});
	
	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		forInsert.validator.set({
	        title : "<spring:message code="필드:토론:시작기간"/>",
	        name : "startDate",
	        data : ["!null"],
	        check : {
	            le : {name : "endDate", title : "<spring:message code="필드:토론:종료기간"/>"}
	        }
	    });
		
		forInsert.validator.set({
	        title : "<spring:message code="필드:토론:종료기간"/>",
	        name : "endDate",
	        data : ["!null"]
	    });
	</c:if>
	
	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		forInsert.validator.set({
	        title : "<spring:message code="필드:토론:시작기간"/>",
	        name : "startDay",
	        data : ["!null","number"],
	        check : {
	            le : {name : "endDay", title : "<spring:message code="필드:토론:종료기간"/>"}
	        }
	    });
		
		forInsert.validator.set({
	        title : "<spring:message code="필드:토론:종료기간"/>",
	        name : "endDay",
	        data : ["!null","number"],
	        check : {
	        	le : {name : "studyDayOfCourseActive", title : "<spring:message code="글:총학습일수"/>"}
	        }
	    });
	</c:if>
	
	//평가점수 벨리데이션
	forInsert.validator.set({
		title : "<spring:message code="필드:과정:게시글수"/>",
		name : "fromCounts",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:과정:게시글수"/>",
		name : "toCounts",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0
		}
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:과정:배점"/>",
		name : "scores",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0,
			le : 100
		}
	});
	
	forInsert.validator.set(function() {
		var $form = jQuery("#" + forInsert.config.formId);
		var fromCount = $form.find(":input[name='fromCounts']").eq(1).val();
		fromCount = fromCount == "" ? 0 : parseInt(fromCount, 10);
		var toCount = $form.find(":input[name='toCounts']").eq(1).val();
		toCount = toCount == "" ? 0 : parseInt(toCount, 10);
		if (fromCount > toCount) {
			$.alert({message : "<spring:message code="글:과정:게시글수설정이정확하지않습니다"/>"});
			return false;
		}
		var prevScore = 0;
		var error = false;
		$form.find(":input[name='scores']").each(function(index) {
			var thisValue = this.value == "" ? 0 : parseInt(this.value);
			if (index > 0 && thisValue > prevScore) {
				error = true;
				return false;
			}
			prevScore = thisValue;
		});
		if (error == true) {
			$.alert({message : "<spring:message code="글:과정:배점설정이정확하지않습니다"/>"});
			return false;
		}
		return true;
	});
	
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
 * 게시글 평가기준 수정
 */
doChangeCount = function(element, code) {
	var $element = jQuery(element);
	var value = element.value == "" ? 0 : parseInt(element.value, 10);
	if (code == "from") {
		$element.closest("tr").next().find(":input[name='toCounts']").val(value - 1);
	} else if (code == "to") {
		$element.closest("tr").prev().find(":input[name='fromCounts']").val(value + 1);
	}
};


/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
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
 * 토론 템플릿 팝업호출
 */
doTemplatePopup = function(){
	forTemplateLayer.run();
};

/**
 * 토론 템플릿 데이터 등록
 */
doTemplateInsert = function(returnValue){
				
	var $form = jQuery("#" + forTemplate.config.formId);
	jQuery("<input type='hidden' name='templateSeq' value='" + returnValue.templateSeq + "'>").appendTo($form);
	
	forTemplate.run();
		
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

<c:import url="srchDiscuss.jsp"></c:import>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Select Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Select Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${detail.discuss.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_DISCUSS}"/>
</c:import>
<!-- 교과목 구성정보 Tab Area End -->

<!-- 템플릿팝업 호출용 -->
<form name="FormBrowseTemplate" id="FormBrowseTemplate" method="post" onsubmit="return false;">    
	<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${discuss.courseActiveSeq}"/>"/>    
	<input type="hidden" name="callback" value="doTemplateInsert"/>
</form>

<!-- 토론 데이터 등록용 -->
<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${discuss.courseActiveSeq}"/>"/>
    <input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
    <input type="hidden" name="postType" value="discuss" />
    <input type="hidden" name="startDtime"/>
    <input type="hidden" name="endDtime"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    
	<div class="lybox-title mt10">
        <h4 class="section-title">
        	<spring:message code="글:토론:토론등록" />
        </h4>
    </div>	
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 140px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:토론:토론주제"/>
            </th>
            <td>
            	<a href="javascript:void(0)" onclick="doTemplatePopup();" class="pop-call-btn" title="<spring:message code="글:토론:템플릿팝업호출"/>" >&nbsp;</a>
			  	<input type="text" name="discussTitle"  value="${discussTemplate.discussTemplate.templateTitle}" style="width:350px;">
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:내용"/>
            </th>
			<td>
			    <input type="hidden" name="editorPhotoInfo">
			    <textarea name="description" id="description" style="width:99%; height:300px"><c:out value="${discussTemplate.discussTemplate.templateDescription}" /></textarea>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:토론:첨부파일"/></th>
			<td>
                <!-- 탬플릿 파일-->
                <c:forEach var="row" items="${discussTemplate.discussTemplate.attachList}" varStatus="i">
                    <input type="hidden" name="attachSeqs" id="templateFile${row.attachSeq}" value="${row.attachSeq}"/>
                </c:forEach>
                <!--  신규 파일-->
                <input type="hidden" name="attachUploadInfo"/>
                <input type="hidden" name="attachDeleteInfo">
                <div id="uploader" class="uploader">
                    <c:if test="${!empty discussTemplate.discussTemplate.attachList}">
                        <c:forEach var="row" items="${discussTemplate.discussTemplate.attachList}" varStatus="i">
                            <div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>', 'templateFile')" class="previousFile">
                                <c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
                <span class="vbom"><c:out value="${attachSize}"/>MB</span>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:토론:토론기간"/>
            </th>
            <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	            <td>
	                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;">
	                <select name="startTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	                 ~
	                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;">
	                <select name="endTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	            </td>
	        </c:if>
	        <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
				<td>
					<spring:message code="글:수강시작"/>&nbsp;
	                <input type="text" name="startDay" id="startDay" class="align-r" style="width: 50px;">&nbsp;
	                <spring:message code="글:일부터"/>
	                ~
	                <input type="text" name="endDay" id="endDay" class="align-r" style="width: 50px;">&nbsp;
	                <spring:message code="글:일까지"/>
	                (<spring:message code="글:이과정은"/><c:out value="${studyDayOfCourseActive}"/><spring:message code="글:일과정입니다"/>)
	                <input type="hidden" name="studyDayOfCourseActive" value="<c:out value="${studyDayOfCourseActive}"/>"/>
				</td>
	        </c:if>
        </tr>
        <!-- 관리자가 아닌 사용자만 저장할수 있다. -->
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
    
	<div class="vspace"></div>
	<div class="vspace"></div>
    
    <!-- 평가 테이블 --> 
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 80px" />
		<col style="width: auto" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th class="align-c"><spring:message code="필드:과정:등급분류"/></th>
			<th class="align-c"><spring:message code="필드:과정:게시글수"/></th>
			<th class="align-c"><spring:message code="필드:과정:배점"/></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="rowSub" begin="1" end="3" varStatus="iSub">
		<tr>
			<c:choose>
				<c:when test="${rowSub eq 1}">
					<th class="align-c"><spring:message code="글:과정:상"/></th>
					<td style="padding-left:30px;">
						<input type="hidden" name="postEvaluateSeqs" value="0"/>
						<input type="text" name="fromCounts" value="0" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
						<spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
						<input type="hidden" name="toCounts" value="999"/>
					</td>
					<td class="align-c">
						<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
						<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
					</td>
				</c:when>
				<c:when test="${rowSub eq 2}">
					<th class="align-c"><spring:message code="글:과정:중"/></th>
					<td style="padding-left:30px;">
						<input type="hidden" name="postEvaluateSeqs" value="0"/>
						<input type="text" name="fromCounts" value="0" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'from')"/>
						<spring:message code="글:과정:부터"/>&nbsp;&nbsp;
						<input type="text" name="toCounts" value="0" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'to')"/>
						<spring:message code="글:과정:까지"/>
					</td>
					<td class="align-c">									
						<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
						<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
					</td>
				</c:when>
				<c:when test="${rowSub eq 3}">
					<th class="align-c"><spring:message code="글:과정:하"/></th>
					<td style="padding-left:30px;">
						<input type="hidden" name="postEvaluateSeqs" value="0"/>
						<input type="hidden" name="fromCounts" value="0"/>
						<input type="text" name="toCounts" value="0" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
						<spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
					</td>
					<td class="align-c">
						<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
						<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
					</td>
				</c:when>
			</c:choose>
		</tr>
	</c:forEach>
	</tbody>
	</table>    
</form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l">
            <div class="comment">※  <spring:message code="글:토론:저장후등록된모든토론정보의합계가100%인지확인바랍니다"/></div>
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>