<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"    value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"  value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<option value=""><spring:message code="글:개설과목:개설과목을선택하십시오" /></option>
<c:forEach var="row" items="${comboListCourseActive}" varStatus="i">
    <c:choose>
         <c:when test="${CD_CATEGORY_TYPE_DEGREE eq param['shortcutCategoryTypeCd']}">
             <!-- 학위 -->
             <option value='{"courseActiveSeq" : "<c:out value='${row.courseActive.courseActiveSeq}'/>","courseTypeCd": "<c:out value='${row.courseActive.courseTypeCd}'/>"}' <c:out value="${param['shortcutCourseActiveSeq'] eq row.courseActive.courseActiveSeq ? 'selected' : ''}"/>>
             [<c:out value="${row.yearTerm.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.yearTerm.term}" removeCodePrefix="true"/>] <c:out value="${row.courseActive.courseActiveTitle}"/>
             </option>
         </c:when>
         <c:otherwise>
             <!-- 비학위 or Mooc-->
             <option value='{"courseActiveSeq" : "<c:out value='${row.courseActive.courseActiveSeq}'/>","courseTypeCd": "<c:out value='${row.courseActive.courseTypeCd}'/>"}' <c:out value="${param['shortcutCourseActiveSeq'] eq row.courseActive.courseActiveSeq ? 'selected' : ''}"/>>
              <%--<c:if test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
              	[<c:out value='${row.courseActive.periodNumber}'/><spring:message code="필드:개설과목:기" />]
              </c:if> 
               --%>
              <c:out value="${row.courseActive.courseActiveTitle}"/>
             </option>
         </c:otherwise>
     </c:choose>
</c:forEach>