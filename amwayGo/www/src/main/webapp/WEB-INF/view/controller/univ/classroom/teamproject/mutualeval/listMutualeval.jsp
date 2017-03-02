<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom-layer">
<head>
<title><spring:message code="필드:팀프로젝트:상호평가" /></title>
<script type="text/javascript">
var forDetailHomework   = null;
var forTeamProjectHome  = null;
var forMutualeval       = null;
var forListBbsdata      = null;
var doSaveListScore     = null; 
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
    
    forTeamProjectHome = $.action();
    forTeamProjectHome.config.formId = "FormProjectTeamHome";
    forTeamProjectHome.config.url    = "<c:url value="/usr/classroom/teamproject/list.do"/>";

    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/usr/classroom/teamproject/mutualeval/list.do"/>";
    
    forListBbsdata = $.action();
    forListBbsdata.config.formId = "FormSrch";
    forListBbsdata.config.url    = "<c:url value="/usr/classroom/bbs/teamproject/list.do"/>";
    
    doSaveListScore = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    doSaveListScore.config.url             = "<c:url value="/usr/classroom/teamproject/mutualeval/insert.do"/>";
    doSaveListScore.config.target          = "hiddenframe";
    doSaveListScore.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>";
    doSaveListScore.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    doSaveListScore.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    doSaveListScore.config.fn.complete     = function(){
    	doMutualeval({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseActiveSeq :'<c:out value="${detail.courseTeamProject.courseActiveSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'});
    };
    
    setValidate();
};

setValidate = function() {
	doSaveListScore.validator.set({
        title : "<spring:message code="필드:팀프로젝트:점수"/>",
        name : "mutualScores",
        check : {
            le : 100,
            gt : -1
        }
    });
};

/**
 * 과제물상세보기 가져오기 실행.
 */
 doDetailHomework = function(mapPKs) {
    UT.getById(forDetailHomework.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailHomework.config.formId);
    forDetailHomework.run();
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
 * 점수저장
 */
 doSaveScore = function(){
	 doSaveListScore.run();
}
</script>
</head>

<body>
<!-- 팀 프로젝트 팀 정보 Start -->
<c:import url="../include/commonTeamProject.jsp"></c:import>
<!-- 팀 프로젝트 팀 정보 End -->

<div id="tabs" class="mt10 ui-tabs ui-widget ui-widget-content ui-corner-all"
    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <li class="ui-state-default ui-corner-top">
            <a onclick="doListBoard({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
                <spring:message code="필드:팀프로젝트:게시판" />
            </a>
        </li>
        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
            <a href="#"><spring:message code="필드:팀프로젝트:상호평가" /></a>
        </li>
        <li class="ui-state-default ui-corner-top">
            <a onclick="doDetailHomework({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
                <spring:message code="필드:팀프로젝트:과제물" />
            </a>
        </li>
    </ul>
</div>
<div class="vspace"></div>
<div style="display: none;">
<c:import url="../board/bbs/srchBbs.jsp"/>
<c:import url="../srchTeamProject.jsp"></c:import>
</div>
<div class="vspace"></div>
<c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<c:set var="homeworkStartDtime"><aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<c:set var="homeworkEndDtime"><aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>"/>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 10%" />
        <col style="width: 30%" />
        <col style="width: 30%" />
        <col style="width: 30%" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:팀프로젝트:이름" /></th>
            <th><spring:message code="필드:팀프로젝트:게시글수" /></th>
            <th><spring:message code="필드:팀프로젝트:점수" /></th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td>
                <c:out value="${i.count}"/>
            </td>
            <td>
                <c:out value="${row.member.memberName}"/>
            </td>
            <td>
                <a href="javascript:void(0)" onclick="doListBoard({srchKey: 'regMemberName',srchWord : '<c:out value="${row.member.memberName}"/>',srchRegMemberSeq : '<c:out value="${row.courseTeamProjectMutualeval.teamMemberSeq}"/>'})">
                    <c:out value="${row.courseTeamProjectMutualeval.bbsCount}"/>
                    <spring:message code="필드:팀프로젝트:개" />
                </a>
            </td>
            <td>
                <input type="hidden" name="courseTeamSeqs" value="<c:out value="${row.courseTeamProjectMutualeval.courseTeamSeq}"/>">
                <input type="hidden" name="teamMemberSeqs" value="<c:out value="${row.courseTeamProjectMutualeval.teamMemberSeq}"/>">
                <input type="hidden" name="courseApplySeqs" value="<c:out value="${row.courseTeamProjectMutualeval.courseApplySeq}"/>">
                
                <c:choose>
                    <c:when test="${appToday >= homeworkStartDtime && appToday <= homeworkEndDtime}">
                        <input type="text" name="mutualScores" value="<c:out value="${row.courseTeamProjectMutualeval.mutualScore}"/>" style="width: 40px; text-align: center;" maxlength="4">
                    </c:when>
                    <c:otherwise>
                        <c:out value="${row.courseTeamProjectMutualeval.mutualScore}"/>
                    </c:otherwise>
                </c:choose>
                
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty itemList}">
        <tr>
            <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
</table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-l">
        <div class="comment">※ <spring:message code="글:팀프로젝트:상호평가점수미입력시해당팀원은0점처리됩니다." /> </div>
    </div>
    <div class="lybox-btn-r">
        <c:if test="${appToday >= homeworkStartDtime && appToday <= homeworkEndDtime}">
            <a href="javascript:void(0)" onclick="doSaveScore()" class="btn blue"><span class="mid"><spring:message code="버튼:팀프로젝트:점수저장" /></span></a>
        </c:if>
    </div>
</div>
</body>
</html>