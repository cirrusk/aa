<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>

<c:set var="attachSize" value="10"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata         = null;
var forEdit           = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/teamproject/list.do"/>";
	
    forEdit = $.action();
    forEdit.config.formId = "FormDetail";
    forEdit.config.url    = "<c:url value="/univ/course/active/teamproject/edit.do"/>";

	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 수정하기
 */
doEdit = function(mapPKs){
 // 상세화면 form에 키값을 셋팅한다.
   UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
   // 상세화면 실행
	forEdit.run();
};
</script>
</head>

<body>
<c:import url="srchTeamProject.jsp"></c:import>

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
    <c:param name="courseActiveSeq" value="${teamProject.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div class="lybox-title mt10">
    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀프로젝트"/></h4>
</div>

<table class="tbl-detail">
    <colgroup>
        <col style="width: 140px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트제목"/>
            </th>
            <td>
                <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트내용"/>
            </th>
            <td>
                <aof:text type="whiteTag" value="${detail.courseTeamProject.description}"/>
            </td>
        </tr>
        <c:if test="${not empty detail.courseTeamProject.attachList}">
	        <tr>
				<th><spring:message code="필드:게시판:다운로드가능여부"/></th>
				<td>
					<aof:code type="print" name="downloadYn" codeGroup="YESNO" selected="${detail.courseTeamProject.downloadYn}" removeCodePrefix="true"/>
		            </span>
				</td>
			</tr>
		</c:if>
        <tr>
            <th><spring:message code="필드:게시판:첨부파일"/></th>
            <td>
                <c:forEach var="row" items="${detail.courseTeamProject.attachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                    <c:if test="${!i.last}"><br/></c:if>
                </c:forEach>
                <c:if test="${empty detail.courseTeamProject.attachList}">-</c:if>
            </td>
        </tr>
        <%-- 
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:평가비율"/>
            </th>
            <td>
                <spring:message code="필드:팀프로젝트:과제평가"/> : <c:out value="${detail.courseTeamProject.rateHomework}"/>%
                <spring:message code="필드:팀프로젝트:상호평가"/> : <c:out value="${detail.courseTeamProject.rateRelation}"/>%
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간"/>
            </th>
            <td>
                <aof:date datetime="${detail.courseTeamProject.startDtime}" pattern="${aoffn:config('format.datetimeHm')}"></aof:date>
                ~
                <aof:date datetime="${detail.courseTeamProject.endDtime}" pattern="${aoffn:config('format.datetimeHm')}"></aof:date>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제제출기간"/>
            </th>
            <td>
                <aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}" pattern="${aoffn:config('format.datetimeHm')}"></aof:date>
                ~
                <aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}" pattern="${aoffn:config('format.datetimeHm')}"></aof:date>
            </td>
        </tr>
        --%>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물공개여부"/>
            </th>
            <td>
                <aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseTeamProject.openYn}" removeCodePrefix="true"/>
            </td>
        </tr>
    </tbody>
    </table>
    
    <div class="lybox-btn">
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="javascript:void(0)" onclick="doEdit({courseTeamProjectSeq : <c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>