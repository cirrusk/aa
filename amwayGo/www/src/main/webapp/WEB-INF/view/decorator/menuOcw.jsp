<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="currentMenuId" value="${param['currentMenuId']}" scope="request"/>

<script type="text/javascript">

//OCW 카테고리 리스트 이동
doOcwCourseList = function(categoryOcwDepth2Seq, categoryOcwDepth3Seq, srchCategorySeq, srchGroupOrder){
	var action = $.action();
	action.config.formId      = "FormOcwCourseList";
	action.config.url = "<c:url value="/univ/ocw/course/list.do"/>";
	
	var form = UT.getById("FormOcwCourseList");
	form.categoryOcwDepth2Seq.value = categoryOcwDepth2Seq;
	form.categoryOcwDepth3Seq.value = categoryOcwDepth3Seq;
	form.srchCategorySeq.value = srchCategorySeq;
	form.srchGroupOrder.value = srchGroupOrder;
	
	action.run();
}

</script>

<form id="FormOcwCourseList" name="FormOcwCourseList" method="get" onsubmit="return false;">
	<input type="hidden" name="categoryOcwDepth2Seq" value="">
	<input type="hidden" name="categoryOcwDepth3Seq" value="">
	<input type="hidden" name="srchCategorySeq" value="">
	<input type="hidden" name="srchGroupOrder" value="">
	<input type="hidden" name="currentMenuId" value="002">
</form>

<c:choose>
	<c:when test="${param['location'] eq 'main'}">
		<div id="lnb">
			<h2 class="blind"><spring:message code="필드:OCW:메인메뉴"/></h2>
			<ul>
				<li <c:if test="${currentMenuId eq '001'}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/about.do"/>','001001','','');" title="<spring:message code="필드:OCW:About"/>"><spring:message code="필드:OCW:About"/></a></li>
				<li <c:if test="${currentMenuId eq '002'}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/course/list.do"/>','002','','');" title="<spring:message code="필드:OCW:OCW"/>"><spring:message code="필드:OCW:OCW"/></a></li>
				<li <c:if test="${currentMenuId eq '003'}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/bbs/ocwnotice/list.do"/>','003001','','');" title="<spring:message code="필드:OCW:학습지원센터"/>"><spring:message code="필드:OCW:학습지원센터"/></a></li>
				<%-- <li <c:if test="${currentMenuId eq '004'}">class="on"</c:if>><a href="javascript:void(0)" onclick="alert('준비중입니다.');" title="<spring:message code="필드:OCW:카페"/>"><spring:message code="필드:OCW:카페"/></a></li> --%>
			</ul>
		</div>
	</c:when>
	<c:when test="${param['location'] eq 'left'}">
	
		<div id="snb">
		<c:choose>
			<c:when test="${fn:startsWith(currentMenuId,'001')}"><%-- About --%>
				<h2><spring:message code="필드:OCW:About"/></h2>
				<ul>
					<li class="on"><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/about.do"/>','001001','','');" title="<spring:message code="필드:OCW:About"/>"><spring:message code="필드:OCW:About"/></a></li>
				</ul>
			</c:when>
			<c:when test="${fn:startsWith(currentMenuId,'002')}"><%-- OCW --%>
				<h2><spring:message code="필드:OCW:OCW"/></h2>
				<ul>
					<c:forEach var="row" items="${categoryOcwDepth2List}" varStatus="i">
						<c:if test="${categoryOcwDepth2Seq eq row.category.categorySeq}">
							<li class="on"><a href="#" onclick="doOcwCourseList('<c:out value="${row.category.categorySeq}"/>','','<c:out value="${row.category.categorySeq}"/>','<c:out value="${row.category.groupOrder}"/>');"><c:out value="${row.category.categoryName}"/></a>
							<c:if test="${not empty categoryOcwDepth3List}">
								<ul>
									<c:forEach var="row2" items="${categoryOcwDepth3List}" varStatus="z">
										<li <c:if test="${categoryOcwDepth3Seq eq row2.category.categorySeq}">class="on"</c:if>><a href="#" onclick="doOcwCourseList('<c:out value="${row.category.categorySeq}"/>','<c:out value="${row2.category.categorySeq}"/>','<c:out value="${row2.category.categorySeq}"/>','<c:out value="${row2.category.groupOrder}"/>');"><c:out value="${row2.category.categoryName}"/></a></li>
									</c:forEach>
								</ul>
							</c:if>
						</c:if>
						<c:if test="${categoryOcwDepth2Seq ne row.category.categorySeq}">
							<li><a href="#" onclick="doOcwCourseList('<c:out value="${row.category.categorySeq}"/>','','<c:out value="${row.category.categorySeq}"/>','<c:out value="${row.category.groupOrder}"/>');"><c:out value="${row.category.categoryName}"/></a>
						</c:if>
					</c:forEach>
				</ul>
			</c:when>
			<c:when test="${fn:startsWith(currentMenuId,'003')}"><%-- 학습지원센터 --%>
				<h2><spring:message code="필드:OCW:학습지원센터"/></h2>
				<ul>
					<li <c:if test="${fn:startsWith(currentMenuId,'003001')}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/bbs/ocwnotice/list.do"/>','003001','','');" title="Notice">Notice</a></li>
					<li <c:if test="${fn:startsWith(currentMenuId,'003002')}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/bbs/ocwfaq/list.do"/>','003002','','');" title="Notice">FAQ</a></li>
					<li <c:if test="${fn:startsWith(currentMenuId,'003003')}">class="on"</c:if>><a href="javascript:void(0)" onclick="FN.doGoMenu('<c:url value="/univ/ocw/bbs/ocwcontact/list.do"/>','003003','','');" title="Notice">Contact US</a></li>
				</ul>
			</c:when>
			<c:when test="${fn:startsWith(currentMenuId,'004')}"><%-- 카페 --%>
			
			</c:when>
		</c:choose>
		</div>
	</c:when>
</c:choose>