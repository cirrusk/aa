<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
	<c:when test="${boardType eq 'notice'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_NOTICE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'resource'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_RESOURCE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'qna'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'one2one'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'free'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'appeal'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
</c:choose>

<c:set var="exceptEvaluateBoardType" value="notice,resource,appeal,one2one" scope="request"/>

<c:choose>
    <c:when test="${empty detailBoard}"> <%-- 생성되지 않은 게시판 --%>
        <div class="lybox align-c">
            <spring:message code="글:게시판:생성되지않은게시판입니다" />
        </div>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${detailBoard.board.useYn ne 'Y'}"> <%-- 사용하지 않는 게시판 --%>
                <div class="lybox align-c">
                    <spring:message code="글:게시판:사용하지않는게시판입니다" />
                </div>
            </c:when>
            <c:otherwise>
                <table id="listTable" class="tbl-list">
                <colgroup>
                    <col style="width: 50px" />
                    <c:if test="${!empty codeGroupBbsType}">
                        <col style="width: 90px" />
                    </c:if>
                    <col style="width: auto" />
                    <col style="width: 80px" />
                    <col style="width: 80px" />
                    <col style="width: 60px" />
                    <c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}"> <%-- 평가대상 --%>
                        <col style="width: 80px" />
                    </c:if>
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="필드:번호" /></th>
                        <c:if test="${!empty codeGroupBbsType}">
                            <th><spring:message code="필드:게시판:구분" /></th>
                        </c:if>
                        <th><spring:message code="필드:게시판:제목" /></th>
                        <th><spring:message code="필드:등록자" /></th>
                        <th><spring:message code="필드:등록일" /></th>
                        <th><spring:message code="필드:게시판:조회수" /></th>
                        <c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
                            <th><spring:message code="필드:게시판:평가대상" /></th>
                        </c:if>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="row" items="${alwaysTopList}" varStatus="i">
                    <tr>
                        <td><spring:message code="필드:게시판:공지" /></td>
                        <c:if test="${!empty codeGroupBbsType}">
                            <td><aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/></td>
                        </c:if>
                        <td class="align-l">
                            <c:if test="${row.bbs.secretYn eq 'Y'}">
                                [<spring:message code="필드:게시판:비밀글" />]
                            </c:if>
                            <c:out value="${row.bbs.bbsTitle}" />
                            <c:if test="${row.bbs.attachCount gt 0}">
                                <aof:img src="icon/ico_file.gif"/>
                            </c:if>
                        </td>
                        <td><c:out value="${row.bbs.regMemberName}"/></td>
                        <td><aof:date datetime="${row.bbs.regDtime}"/></td>
                        <td><c:out value="${row.bbs.viewCount}"/></td>
                        <c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
                            <td>&nbsp;</td>
                        </c:if>
                    </tr>
                </c:forEach>
                <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
                    <tr>
                        <td><c:out value="${paginate.descIndex - i.index}"/></td>
                        <c:if test="${!empty codeGroupBbsType}">
                            <td>
                                <c:if test="${row.bbs.groupLevel eq 1}">
                                    <aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/>
                                </c:if>
                            </td>
                        </c:if>
                        <c:if test="${flatModeYn eq 'N'}">
                            <c:set var="padding" value="${(row.bbs.groupLevel - 1) * 15}"/>
                        </c:if>
                        <td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
                            <c:if test="${row.bbs.groupLevel gt 1}">
                                re:
                            </c:if>
                            <c:if test="${row.bbs.secretYn eq 'Y'}">
                                [<spring:message code="필드:게시판:비밀글" />]
                            </c:if>
                            <c:out value="${row.bbs.bbsTitle}" />
                            <c:if test="${row.bbs.attachCount gt 0}">
                                <aof:img src="icon/ico_file.gif"/>
                            </c:if>
                        </td>
                        <td><c:out value="${row.bbs.regMemberName}"/></td>
                        <td><aof:date datetime="${row.bbs.regDtime}"/></td>
                        <td><c:out value="${row.bbs.viewCount}"/></td>
                        <c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
                            <td>
                                <aof:code type="print" codeGroup="YESNO" selected="${row.bbs.evaluateYn}" removeCodePrefix="true"/>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                <c:if test="${empty alwaysTopList and empty paginate.itemList}">
                    <tr>
                        <c:set var="colspan" value="5"/>
                        <c:if test="${!empty codeGroupBbsType}">
                            <c:set var="colspan" value="${colspan + 1}"/>
                        </c:if>
                        <c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
                            <c:set var="colspan" value="${colspan + 1}"/>
                        </c:if>
                        <td colspan="<c:out value="${colspan}"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
                    </tr>
                </c:if>
                </table>
            </c:otherwise>
        </c:choose>
    
    </c:otherwise>
</c:choose>