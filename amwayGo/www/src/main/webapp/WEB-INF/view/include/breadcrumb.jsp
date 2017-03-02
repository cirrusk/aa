<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>

<div class="title-area">
    <c:choose>
    <%-- 마이페이지 --%>
        <c:when test="${currentMenuId eq '001001001'}">
            <h3><spring:message code="메뉴:마이페이지:학위과정:수강과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001001002'}">
            <h3><spring:message code="메뉴:마이페이지:학위과정:복습과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001002001'}">
            <h3><spring:message code="메뉴:마이페이지:비학위과정:수강과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001002002'}">
            <h3><spring:message code="메뉴:마이페이지:비학위과정:복습과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001007001'}">
            <h3><spring:message code="메뉴:마이페이지:MOOC:수강과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001007002'}">
            <h3><spring:message code="메뉴:마이페이지:MOOC:복습과목"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001003'}">
            <h3><spring:message code="메뉴:마이페이지:일정관리"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001004'}">
            <h3><spring:message code="메뉴:마이페이지:쪽지함"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001005'}">
            <h3><spring:message code="메뉴:마이페이지:주소록"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '001006'}">
            <h3><spring:message code="메뉴:마이페이지:개인정보조회"/></h3>
        </c:when>
        
    <%-- 개설과목 --%>
        <c:when test="${currentMenuId eq '002001'}">
            <h3><spring:message code="메뉴:개설과목:학위과정"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '002002'}">
            <h3><spring:message code="메뉴:개설과목:비학위과정"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '002003'}">
            <h3><spring:message code="메뉴:개설과목:MOOC"/></h3>
        </c:when>
        
    <%-- 학습지원센터 --%>
        <c:when test="${currentMenuId eq '003001'}">
            <h3><spring:message code="메뉴:학습지원센터:공지사항"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '003002'}">
            <h3><spring:message code="메뉴:학습지원센터:자료실"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '003003'}">
            <h3><spring:message code="메뉴:학습지원센터:FAQ"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '003004'}">
            <h3><spring:message code="메뉴:학습지원센터:QNA"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '003005'}">
            <h3><spring:message code="메뉴:학습지원센터:자유게시판"/></h3>
        </c:when>
        
    <%-- 학사서비스 --%>
    	<c:when test="${currentMenuId eq '005001'}">
            <h3><spring:message code="메뉴:학사서비스:휴학신청"/></h3>
        </c:when>
    	<c:when test="${currentMenuId eq '005002'}">
            <h3><spring:message code="메뉴:학사서비스:수강신청"/></h3>
        </c:when>
        <c:when test="${currentMenuId eq '005003'}">
            <h3><spring:message code="메뉴:학사서비스:복학신청"/></h3>
        </c:when>
    </c:choose>

    <div class="location">
        <span><aof:img src="common/home.gif" alt="HOME"/></span>
        <c:choose>
        <%-- 마이페이지 --%>
            <c:when test="${currentMenuId eq '001001001'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span><spring:message code="메뉴:마이페이지:학위과정"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:학위과정:수강과목"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001001002'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span><spring:message code="메뉴:마이페이지:학위과정"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:학위과정:복습과목"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001002001'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span><spring:message code="메뉴:마이페이지:비학위과정"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:비학위과정:수강과목"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001002002'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span><spring:message code="메뉴:마이페이지:비학위과정"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:비학위과정:복습과목"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001003'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:일정관리"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001004'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:쪽지함"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001005'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:주소록"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '001006'}">
                <span><spring:message code="메뉴:마이페이지"/></span>
                <span class="here"><spring:message code="메뉴:마이페이지:개인정보조회"/></span>
            </c:when>
            
        <%-- 개설과목 --%>
            <c:when test="${currentMenuId eq '002001'}">
                <span><spring:message code="메뉴:개설과목"/></span>
                <span class="here"><spring:message code="메뉴:개설과목:학위과정"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '002002'}">
                <span><spring:message code="메뉴:개설과목"/></span>
                <span class="here"><spring:message code="메뉴:개설과목:비학위과정"/></span>
            </c:when>
            
        <%-- 학습지원센터 --%>
            <c:when test="${currentMenuId eq '003001'}">
                <span><spring:message code="메뉴:학습지원센터"/></span>
                <span class="here"><spring:message code="메뉴:학습지원센터:공지사항"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '003002'}">
                <span><spring:message code="메뉴:학습지원센터"/></span>
                <span class="here"><spring:message code="메뉴:학습지원센터:자료실"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '003003'}">
                <span><spring:message code="메뉴:학습지원센터"/></span>
                <span class="here"><spring:message code="메뉴:학습지원센터:FAQ"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '003004'}">
                <span><spring:message code="메뉴:학습지원센터"/></span>
                <span class="here"><spring:message code="메뉴:학습지원센터:QNA"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '003005'}">
                <span><spring:message code="메뉴:학습지원센터"/></span>
                <span class="here"><spring:message code="메뉴:학습지원센터:자유게시판"/></span>
            </c:when>
            
        <%-- 학사서비스 --%>
        	<c:when test="${currentMenuId eq '005001'}">
                <span><spring:message code="메뉴:학사서비스"/></span>
                <span class="here"><spring:message code="메뉴:학사서비스:휴학신청"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '005002'}">
                <span><spring:message code="메뉴:학사서비스"/></span>
                <span class="here"><spring:message code="메뉴:학사서비스:수강신청"/></span>
            </c:when>
            <c:when test="${currentMenuId eq '005003'}">
                <span><spring:message code="메뉴:학사서비스"/></span>
                <span class="here"><spring:message code="메뉴:학사서비스:복학신청"/></span>
            </c:when>
        </c:choose>
    </div>

</div>