<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forEditHomework     = null;
var forDetailHomework   = null;
var forTeamProjectHome  = null;
var forMutualeval       = null;
var forListBbsdata      = null;
var forCreateHomework   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forDetailHomework = $.action();
    forDetailHomework.config.formId = "FormDetailHomework";
    forDetailHomework.config.url    = "<c:url value="/usr/classroom/teamproject/homework/detail.do"/>";
    
    forEditHomework = $.action();
    forEditHomework.config.formId = "FormDetailHomework";
    forEditHomework.config.url    = "<c:url value="/usr/classroom/teamproject/homework/edit.do"/>";
    
    forTeamProjectHome = $.action();
    forTeamProjectHome.config.formId = "FormProjectTeamHome";
    forTeamProjectHome.config.url    = "<c:url value="/usr/classroom/teamproject/list.do"/>";

    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/usr/classroom/teamproject/mutualeval/list.do"/>";
    
    forListBbsdata = $.action();
    forListBbsdata.config.formId = "FormSrch";
    forListBbsdata.config.url    = "<c:url value="/usr/classroom/bbs/teamproject/list.do"/>";
    
	forCreateHomework = $.action();
	forCreateHomework.config.formId = "FormDetailHomework";
	forCreateHomework.config.url    = "<c:url value="/usr/classroom/teamproject/homework/create.do"/>";

    setValidate();
};

setValidate = function() {
};

/**
 * 과제물 등록 화면 이동
 */
doCreateHomework = function(mapPKs){
	UT.getById(forCreateHomework.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forCreateHomework.config.formId);
	forCreateHomework.run();
};

/**
 * 과제물상세보기 가져오기 실행.
 */
 doDetailHomework = function(mapPKs) {
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    forDetail.run();
};

/**
 * 팀프로젝트 홈 이동
 */
doTeamProjectHome = function(mapPKs){
    UT.getById(forTeamProjectHome.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forTeamProjectHome.config.formId);
    forTeamProjectHome.run();
};

/**
 * 상호평가 이동
 */
doMutualeval = function(mapPKs){
    UT.getById(forMutualeval.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forMutualeval.config.formId);
    
    forMutualeval.run();
};

/**
 * 참여게시판 가져오기 실행.
 */
 doListBoard = function(mapPKs) {
    UT.getById(forListBbsdata.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forListBbsdata.config.formId);
    forListBbsdata.run();
};

/**
 * 과제 수정
 */
doEditHomework = function(mapPKs){
	UT.getById(forEditHomework.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forEditHomework.config.formId);
    forEditHomework.run();
}
</script>
</head>

<body>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<!-- 팀 프로젝트 팀 정보 Start -->
<c:import url="../include/commonTeamProject.jsp"></c:import>
<!-- 팀 프로젝트 팀 정보 End -->

<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <li class="ui-state-default ui-corner-top">
            <a onclick="doListBoard({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})"><spring:message code="필드:팀프로젝트:게시판" /></a>
        </li>
        <li class="ui-state-default ui-corner-top">
        <a onclick="doMutualeval({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
            <spring:message code="필드:팀프로젝트:상호평가" />
        </a>
        </li>
        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
            <a href="#"><spring:message code="필드:팀프로젝트:과제물" /></a>
        </li>
    </ul>
</div>
<div style="display: none;">
<c:import url="../board/bbs/srchBbs.jsp"/>
<c:import url="../srchTeamProject.jsp"></c:import>
</div>
<c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<c:set var="homeworkStartDtime"><aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<c:set var="homeworkEndDtime"><aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<c:choose>
    <c:when test="${empty homework}">
        <div class="lybox align-c mt10"><spring:message code="글:팀프로젝트:제출된과제물이없습니다." /></div>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <c:if test="${detail.member.memberSeq == ssMemberSeq}">
                    <c:if test="${appToday >= homeworkStartDtime && appToday <= homeworkEndDtime}">
                        <a href="javascript:void(0)" onclick="doCreateHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})" class="btn blue">
                            <span class="mid"><spring:message code="버튼:등록" /></span>
                        </a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <table id="listTable" class="tbl-list mt10">
            <colgroup>
                <col style="width: 140px;" />
                <col/>
            </colgroup>
            <tbody>
            <table class="tbl-detail">
                <colgroup>
                    <col style="width:120px" />
                    <col/>
                </colgroup>
                <tbody>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:제목"/>
                        </th>
                        <td>
                            <c:out value="${homework.answer.homeworkAnswerTitle}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:작성자"/>
                        </th>
                        <td>
                            <c:out value="${homework.answer.memberName}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:내용"/>
                        </th>
                        <td>
                            <aof:text type="whiteTag" value="${homework.answer.description}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:첨부파일"/>
                        </th>
                        <td>
                            <c:forEach var="row" items="${homework.answer.unviAttachList}" varStatus="i">
                                <a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
                                [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                            </c:forEach>
                        </td>
                    </tr>
                </tbody>
                </table>
            </tbody>
        </table>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <c:if test="${detail.member.memberSeq == ssMemberSeq}">
                    <c:if test="${appToday >= homeworkStartDtime && appToday <= homeworkEndDtime}">
                        <a href="javascript:void(0)" onclick="doEditHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})" class="btn blue">
                            <span class="mid"><spring:message code="버튼:수정" /></span>
                        </a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>