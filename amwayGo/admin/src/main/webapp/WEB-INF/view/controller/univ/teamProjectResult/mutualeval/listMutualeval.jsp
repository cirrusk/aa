<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forTeamProjectHome  = null;
var forMutualeval       = null;
var forListBbsdata      = null;
var forMutualScorePopup = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forTeamProjectHome = $.action();
    forTeamProjectHome.config.formId = "FormProjectTeamHome";
    forTeamProjectHome.config.url    = "<c:url value="/univ/teamproject/result/detail.do"/>";

    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/univ/teamproject/mutualeval/list.do"/>";
    
    forListBbsdata = $.action();
    forListBbsdata.config.formId = "FormSrch";
    forListBbsdata.config.url    = "<c:url value="/univ/bbs/teamproject/list.do"/>";

    forMutualScorePopup = $.action("layer");
    forMutualScorePopup.config.formId = "FormPersonEvalPopup";
    forMutualScorePopup.config.url    = "<c:url value="/univ/teamproject/personal/eval/popup.do"/>";
    forMutualScorePopup.config.options.width = 800;
    forMutualScorePopup.config.options.height = 600;
    forMutualScorePopup.config.options.title = "<spring:message code="필드:팀프로젝트:개인별상호평가상세정보"/>";
    
    setValidate();
};

setValidate = function() {
};

/**
 * 팀프로젝트 홈 이동
 */
doTeamProjectHome = function(mapPKs){
    UT.copyValueMapToForm(mapPKs, forTeamProjectHome.config.formId);
    forTeamProjectHome.run();
};

/**
 * 상호평가 이동
 */
doMutualeval = function(mapPKs){
    UT.copyValueMapToForm(mapPKs, forMutualeval.config.formId);
    forMutualeval.run();
};

/**
 * 참여게시판 가져오기 실행.
 */
 doListBoard = function(mapPKs) {
    UT.copyValueMapToForm(mapPKs, forListBbsdata.config.formId);
    forListBbsdata.run();
};

/**
 * 개인별 상호 평가 상세 팝업
 */
doMutualScorePopup = function(mapPKs){
	UT.copyValueMapToForm(mapPKs, forMutualScorePopup.config.formId);
	forMutualScorePopup.run();
}

</script>
</head>

<body>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 팀 프로젝트 팀 정보 Start -->
<c:import url="../include/commonTeamProject.jsp"></c:import>
<!-- 팀 프로젝트 팀 정보 End -->

<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <li class="ui-state-default ui-corner-top">
            <a onclick="doListBoard({courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
                <spring:message code="필드:팀프로젝트:게시판" />
            </a>
        </li>
        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
            <a href="#"><spring:message code="필드:팀프로젝트:상호평가" /></a>
        </li>
    </ul>
</div>
<div class="vspace"></div>
<div style="display: none;">
<c:import url="../board/bbs/srchBbs.jsp"/>
<c:import url="../srchTeamProjectResult.jsp"/>
</div>
<div class="vspace"></div>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 60px;" />
        <col style="width: 60px;" />
        <col style="width: 140px" />
        <col style="width: 140px" />
        
        <%-- <col/>--%>
        <col style="width: 140px" />
        <col style="width: 140px" />
    </colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:팀프로젝트:이름" /></th>
            <th><spring:message code="필드:팀프로젝트:아이디" /></th>
            <%--<th><spring:message code="필드:팀프로젝트:학과" /></th> --%>
            <th><spring:message code="필드:팀프로젝트:역활" /></th>
            <th><spring:message code="필드:팀프로젝트:상세" /></th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td>
                <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
                <input type="hidden" name="memberSeqs" value="<c:out value="${row.courseTeamProjectMutualeval.teamMemberSeq}" />">
                <input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
                <input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
            </td>
            <td>
                <c:out value="${i.count}"/>
            </td>
            <td>
                <c:out value="${row.member.memberName}"/>
            </td>
            <td>
                <c:out value="${row.member.memberId}"/>
            </td>
            <%--
            <td>
                <c:out value="${row.member.organizationString}"/>
            </td>
             --%>
            <td>
                <aof:code type="print" codeGroup="CHIF_YN" selected="${row.courseTeamProjectMember.chiefYn}" removeCodePrefix="true"/>
            </td>
            <td>
                <a href="javascript:void(0)" onclick="doMutualScorePopup({courseTeamProjectSeq: '<c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq : '<c:out value="${row.courseTeamProjectMutualeval.courseTeamSeq}"/>', mutualMemberSeq : '<c:out value="${row.courseTeamProjectMutualeval.teamMemberSeq}"/>'})" class="btn blue">
                    <span class="mid"><spring:message code="버튼:팀프로젝트:보기" /></span>
                </a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty itemList}">
        <tr>
            <td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
</table>
</form>

<div class="lybox-btn">
    <div class="lybox-btn-l">
    </div>
    <div class="lybox-btn-r" style="display: none;" id="checkButtonBottom">
       <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
       	<%--
           <a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
           <a href="javascript:void(0)" onclick="FN.doCreateSms('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS"/></span></a>
           <a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일"/></span></a>
            --%>
       </c:if>
    </div>
</div>
</body>
</html>