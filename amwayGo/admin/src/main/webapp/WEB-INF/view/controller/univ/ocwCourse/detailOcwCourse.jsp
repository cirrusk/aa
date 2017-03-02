<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
var forListdata = null;
var forEdit = null;
var forEditOrganization = null;

initPage = function() {
	// 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.tabs("#tabs");
	
	initPageComment();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
	
	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/ocw/course/edit.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";
	
	forEditOrganization = $.action();
	forEditOrganization.config.formId = "FormDetail";
	forEditOrganization.config.url    = "<c:url value="/univ/ocw/course/organization/edit.do"/>";
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/**
 * 구성정보로 이동
 */
doEditOrganization = function(mapPKs) {
	// 구성정보로 이동 form을 reset한다.
	UT.getById(forEditOrganization.config.formId).reset();
	// 구성정보로 이동 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEditOrganization.config.formId);
	// 구성정보로 이동
	forEditOrganization.run();
};

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"></c:param>
	</c:import>
	
	<div id="tabs"> 
		<ul class="ui-widget-header-tab-custom">
			<li id="tab1"><a href="javascript:void(0)" 
				onclick="javascript:doDetail({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />'});"><spring:message code="글:상세정보" /></a>
			</li>
			<li id="tab2"><a href="javascript:void(0)" 
				onclick="javascript:doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />',
														'courseActiveSeq' : '<c:out value="${detail.courseActive.courseActiveSeq}" />'});"><spring:message code="필드:개설과목:구성정보" /></a>
			</li>
		</ul>
	</div>
	
	<div style="display:none;">
		<c:import url="srchOcwCourse.jsp"/>
	</div>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:개설과목:과목명"/></th>
			<td colspan="3">
				<c:out value="${detail.courseActive.courseActiveTitle}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:교과목분류"/></th>
			<td colspan="3">
				<c:out value="${detail.cate.categoryString}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:과목소개"/></th>
			<td colspan="3">
				<aof:text type="text" value="${detail.courseActive.introduction}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:강사"/></th>
			<td>
				<c:out value="${detail.ocwCourse.profMemberName}"/>
			</td>
			<th><spring:message code="필드:개설과목:별점"/></th>
			<td>
				<c:import url="/WEB-INF/view/controller/univ/ocwCourse/starOcwCourse.jsp">
					<c:param name="ocwAvgResult" value="${scoreAvg}"/>
				</c:import>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:제공자"/></th>
			<td>
				<c:out value="${detail.ocwCourse.offerName}"/>
			</td>
			<th><spring:message code="필드:개설과목:출저"/></th>
			<td>
				<c:out value="${detail.ocwCourse.source}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:등록자"/></th>
			<td colspan="3">
				<c:out value="${detail.ocwCourse.regMemberName}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:보조자료"/></th>
			<td>
				<c:forEach var="row" items="${detail.ocwCourse.attachFileList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
					[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
			</td>
			<th><spring:message code="필드:개설과목:참고서적"/></th>
			<td>
				<c:out value="${detail.ocwCourse.referenceBook}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:대표이미지"/>1</th>
			<td>
				<c:choose>
					<c:when test="${!empty detail.ocwCourse.photo1}">
						<c:set var="ocwPhoto1" value ="${aoffn:config('upload.context.image')}${detail.ocwCourse.photo1}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="ocwPhoto1"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-120">
					<img src="${ocwPhoto1}" title="<spring:message code="필드:멤버:사진"/>">
				</div>
			</td>
			<th><spring:message code="필드:개설과목:대표이미지"/>2</th>
			<td>
				<c:choose>
					<c:when test="${!empty detail.ocwCourse.photo2}">
						<c:set var="ocwPhoto2" value ="${aoffn:config('upload.context.image')}${detail.ocwCourse.photo2}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="ocwPhoto2"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-120">
					<img src="${ocwPhoto2}" title="<spring:message code="필드:멤버:사진"/>">
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:키워드"/></th>
			<td colspan="3">
				<c:out value="${detail.ocwCourse.keyword}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:운영기간"/></th>
			<td colspan="3">
				<aof:date datetime="${detail.courseActive.studyStartDate}"/> ~ 
				<c:choose>
					<c:when test="${detail.ocwCourse.limitOpenYn eq 'Y'}"><spring:message code="글:개설과목:제한없음"/></c:when>
					<c:otherwise><aof:date datetime="${detail.courseActive.studyEndDate}"/></c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
            <th><spring:message code="필드:개설과목:상태"/></th>
            <td colspan="3"><aof:code type="print" name="courseActiveStatusCd" codeGroup="COURSE_ACTIVE_STATUS" selected="${detail.courseActive.courseActiveStatusCd}" ></aof:code></td>
        </tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />'});"
							class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" class="btn blue" onclick="doList();"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
	<c:import url="/WEB-INF/view/controller/univ/ocwCourse/comment/comment.jsp">
		<c:param name="srchCommentTypeCd" value="COURSE"/>
		<c:param name="srchCourseActiveSeq" value="${detail.courseActive.courseActiveSeq}"/>
		<c:param name="parentResizingYn" value="Y"/>
	</c:import>
</body>
</html>