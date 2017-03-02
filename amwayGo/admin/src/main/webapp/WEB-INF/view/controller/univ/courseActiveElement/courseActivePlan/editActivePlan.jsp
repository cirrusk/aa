<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_PLAN" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.PLAN')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate   = null;
var forDetail   = null;
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
                fileSizeLimit : "10 MB",
                fileUploadLimit :0, // default : 1, 0이면 제한없음.
                inputHeight : 20, // default : 20
                immediatelyUpload : true,
                successCallback : function(id, file) {}
            }
        }]
    );
 	// editor
    UI.editor.create("courseActivePlan");
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/active/plan/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doDetail();
	};
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/active/plan/detail.do"/>";
};

doUpdate = function() {
	UI.editor.copyValue();
	forUpdate.run();
}

doDetail = function() {
	forDetail.run();
}
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>
<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
    </c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_PLAN}"/>
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>

	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
		<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	
	<div class="lybox-title"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:강의계획서:강의계획서수정" /></h4>
    </div>
    
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<table class="tbl-detail">
			<colgroup>
				<col/>
			</colgroup>
			<tbody>
			<tr>
				<td align="center">
					<textarea name="courseActivePlan" id="courseActivePlan" style="width:98%; height:300px"><c:out value="${detail.courseActivePlan.courseActivePlan}"/></textarea>
				</td>
			</tr>
			</tbody>
		</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doDetail();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
</body>
</html>