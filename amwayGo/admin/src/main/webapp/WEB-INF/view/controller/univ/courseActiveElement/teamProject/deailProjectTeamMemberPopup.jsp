<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_TEAM_PROJECT_STATUS_R" value="${aoffn:code('CD.TEAM_PROJECT_STATUS.R')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata           = null;
var forEditdata           = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListdata = $.action();
    forListdata.config.formId = "FormData";
    forListdata.config.url    = "<c:url value="/univ/course/active/teamproject/team/detail/popup.do"/>";
    
    forEditdata = $.action();
    forEditdata.config.formId = "FormData";
    forEditdata.config.url    = "<c:url value="/univ/course/active/teamproject/member/popup.do"/>";
    
    setValidate();
};

setValidate = function() {};

/**
 * 팀원 목록보기 가져오기 실행.
 */
 doProjectTeamMember = function(mapPKs) {
	 // 상세화면 form을 reset한다.
    UT.getById(forListdata.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forListdata.config.formId);
    forListdata.run();
};

/**
 * 팀원 수정
 */
doEditProjectTeamMember = function(){
	forEditdata.run();
}

/**
 * 닫기
 */
doClose = function(){
	var par = $layer.dialog("option").parent;
    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
        par["<c:out value="${param['callback']}"/>"].call(this);
    }
    
    $layer.dialog("close");
}
</script>
</head>

<body>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="courseTeamProjectSeq" value="<c:out value='${projectTeamMamber.courseTeamProjectSeq}'/>">
<input type="hidden" name="courseActiveSeq" value="<c:out value="${projectTeamMamber.courseActiveSeq}" />">
<input type="hidden" name="courseTeamSeq">
<!-- 타이틀 박스 -->
<table class=""><!-- tbl-2column 테이블 상단에 오는 제목 테이블, 별도 클래스는 필요없음-->
    <colgroup>
        <col style="width:9%;" />
        <col style="width:30%;" />
        <col style="width:1%;" /><!-- blank 칼럼(좌우 구분 빈셀) -->
        <col style="width:30%;" />
        <col style="width:30%;" />
    </colgroup>
    <thead>
        <tr>
            <th colspan="2"><!-- colspan = blank 칼럼을 제외한 좌측 칼럼 병합 -->
                <div class="lybox-title">
                    <h4 class="section-title"><spring:message code="필드:팀프로젝트:대기자목록"/></h4>
                </div>
            </th>
            <th colspan="2"><!-- colspan = blank 칼럼을 포함한 우측 칼럼 병합 -->
                <c:forEach var="row" items="${teamList}" varStatus="i">
                    <c:if test="${projectTeamMamber.courseTeamSeq == row.courseTeamProjectTeam.courseTeamSeq}">
                        <c:set var="teamTitle" value="${row.courseTeamProjectTeam.teamTitle}"></c:set>
                    </c:if>
                </c:forEach>
            </th>
            <th>
                <c:if test="${empty teamTitle}">
                    <c:set var="teamTitle" value="${teamList[0].courseTeamProjectTeam.teamTitle}"></c:set>
                </c:if>
                <!-- 미배정 목록이 아닐경우만 보여준다. -->
                <c:if test="${not empty projectTeamMamber.courseTeamSeq}">
                    <div class="lybox-title">
                       <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀이름"/></h4>
                       <input type="text" name="teamTitle" value="<c:out value='${teamTitle}'/>" readonly="readonly">
                    </div>
                </c:if>
                
            </th>
        </tr>
    </thead>
</table>
<!-- //타이틀 박스 -->
<table class="tbl-layout"><!-- table-layout -->
    <colgroup>
        <col style="width:40%;">
        <col style="width:auto;">
    </colgroup>
    <tbody>
        <tr>
            <td class="first"><!-- first -->
                <!-- 팀목록 목록 Start -->
                <div class="scroll-y" style="height:400px;">
                    <table class="tbl-list"><!-- tbl-list -->
                        <colgroup>
                            <col style="width: 200px;">
                            <col/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th><spring:message code="필드:팀프로젝트:팀분류"/></th>
                                <th><spring:message code="필드:팀프로젝트:배정인원" /></th>
                            </tr>
                        </thead>
                        <tbody>
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${unassignMemberCount < 1}">
                                                <spring:message code="필드:팀프로젝트:미배정"/>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="javascript:void(0)" onclick="doProjectTeamMember()">
                                                    <spring:message code="필드:팀프로젝트:미배정"/>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:out value="${unassignMemberCount}"/>
                                        <spring:message code="필드:팀프로젝트:명" />
                                    </td>
                                </tr>
                            <c:set var="assignTotalMember" value="0"></c:set>
                            <c:forEach var="row" items="${teamList}" varStatus="i">
                                <tr>
                                    <td>
                                        <a href="javascript:void(0)" onclick="doProjectTeamMember({courseTeamSeq : <c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>})">
                                            <c:out value="${row.courseTeamProjectTeam.teamTitle}"/>
                                        </a>
                                    </td>
                                    <td>
                                        <c:out value="${row.courseTeamProjectTeam.memberCount}"/>
                                        <spring:message code="필드:팀프로젝트:명" />
                                    </td>
                                </tr>
                                <c:set var="assignTotalMember" value="${assignTotalMember+row.courseTeamProjectTeam.memberCount}"></c:set>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- 대기자 목록 End -->
            </td>

            <td>
                <!--  팀원 목록 Start -->
                <div class="scroll-y" style="height:400px;">
                    <table class="tbl-list">
                        <colgroup>
                            <col style="width: 60px;">
                            <col style="width: 100px;">
                            <col/>
                            <col style="width: 70px">
                        </colgroup>
                        <thead>
                             <tr>
                                <th><spring:message code="필드:번호"/></th>
                                <th><spring:message code="필드:팀프로젝트:이름"/></th>
                                <th><spring:message code="필드:팀프로젝트:아이디" /></th>
                                <th><spring:message code="필드:팀프로젝트:역활" /></th>
                            </tr>
                        </thead>
                        <tbody id="AssignTeamMemberArea">
                           <c:forEach var="row" items="${memberList}" varStatus="i">
                           <tr>
                                <td>
                                    <c:out value="${i.count}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberName}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberId}"/>
                                </td>
                                <td>
                                
                                <aof:code type="print" codeGroup="CHIF_YN" selected="${row.courseTeamProjectMember.chiefYn}" removeCodePrefix="true"></aof:code>
                                </td>
                            </tr>
                            </c:forEach>
                            <tr <c:if test="${not empty memberList}">style="display: none;"</c:if>>
                                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div><!-- //scroll-y -->
                <!--  팀원 목록 Start -->
            </td>
        </tr>
    </tbody>
</table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-l">
        <div class="lybox-title">
            <h4 class="section-title"><spring:message code="필드:팀프로젝트:대상인원"/> : 
                <span class="count"><c:out value="${totalApplyMember}"/><spring:message code="필드:팀프로젝트:명"/></span>
            </h4>
        </div>
        <div class="lybox-title">
            <h4 class="section-title"><spring:message code="필드:팀프로젝트:배정인원"/> : 
                <span class="count"><c:out value="${assignTotalMember}"/><spring:message code="필드:팀프로젝트:명"/></span>
            </h4>
        </div>
    </div>
    <div class="lybox-btn-r">
        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
            <a href="javascript:void(0)" onclick="doEditProjectTeamMember()" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
        </c:if>
        <a href="javascript:void(0)" onclick="doClose()" class="btn blue"><span class="mid"><spring:message code="버튼:닫기"/></span></a>
    </div>
</div>
</body>
</html>