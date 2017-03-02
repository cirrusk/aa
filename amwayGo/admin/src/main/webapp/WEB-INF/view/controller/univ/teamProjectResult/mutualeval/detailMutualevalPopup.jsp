<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    setValidate();
};

setValidate = function() {};

doClose = function(){
    $layer.dialog("close");
};


</script>
</head>

<body>
<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:평가자정보" />
    </h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width:25%" />
        <col style="width:25%" />
        <col/>
        <col style="width:25%" />
    </colgroup>
    <tbody>
        <thead>
            <tr>
                <th><spring:message code="필드:팀프로젝트:이름" /></th>
                <th><spring:message code="필드:팀프로젝트:아이디" /></th>
                <th><spring:message code="필드:팀프로젝트:학과" /></th>
                <th><spring:message code="필드:팀프로젝트:역활" /></th>
            </tr>
        </thead>
        <tr>
            <td>
                <c:out value="${detail.member.memberName}"/>
            </td>
            <td>
                <c:out value="${detail.member.memberId}"/>
            </td>
            <td>
                <c:out value="${detail.member.organizationString}"/>
            </td>
            <td>
                <aof:code type="print" codeGroup="CHIF_YN" selected="${detail.courseTeamProjectMember.chiefYn}" removeCodePrefix="true"/>
            </td>
        </tr>
    </tbody>
</table>

<div class="lybox-title mt10">
    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀원별점수" /></h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width: 60px;" />
        <col/>
        <col style="width: 140px;" />
        
        <col style="width: 120px;" />
        <col style="width: 70px;" />
        <col style="width: 140px;" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:팀프로젝트:이름" /></th>
            <th><spring:message code="필드:팀프로젝트:아이디" /></th>
            
            <th><spring:message code="필드:팀프로젝트:역활" /></th>
            <th><spring:message code="필드:팀프로젝트:게시글수" /></th>
            <th><spring:message code="필드:팀프로젝트:평가점수" /></th>
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
                    <c:out value="${row.member.memberId}"/>
                </td>
                <td>
                    <aof:code type="print" codeGroup="CHIF_YN" selected="${row.courseTeamProjectMember.chiefYn}" removeCodePrefix="true"/>
                </td>
                <td>
                    <c:out value="${row.courseTeamProjectMutualeval.bbsCount}"/>
                    <spring:message code="필드:팀프로젝트:개" />
                </td>
                <td>
                    <c:out value="${row.courseTeamProjectMutualeval.mutualScore}"/>
                    <spring:message code="필드:팀프로젝트:점" />
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty itemList}">
            <tr>
                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
</table>

<div class="lybox-btn">
    <div class="lybox-btn-l">
        <spring:message code="필드:팀프로젝트:평가점수" /> : <spring:message code="글:팀프로젝트:수강자가개별팀원에대해부여한상호평가점수" />
    </div>
    <div class="lybox-btn-r">
        <a href="javascript:void(0)" onclick="doClose()" class="btn black">
            <span class="mid"><spring:message code="버튼:닫기" /></span>
        </a>
    </div>
</div>
</body>
</html>