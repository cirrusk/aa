<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<dl class="tblBizroomState" id="rsvInfoTable">
	<c:forEach items="${roomInfoList}" var="item">
		<dt>등록일자 : ${fn:substring(item.purchasedate,0,4)}-${fn:substring(item.purchasedate,4,6)}-${fn:substring(item.purchasedate,6,8)}
			<em>|</em>${item.roomrsvtotalcounnt}건 예약
			<em>|</em>
			<c:if test="${item.cancelcodecount eq 0}">
				<td>0건 취소</td>
			</c:if>
			<c:if test="${item.cancelcodecount ne 0}">
				<td>${item.cancelcodecount}건 취소</td>
			</c:if>
			<a href="#none" class="btnTbl" onclick="javascript:roomInfoDetailList('${item.purchasedate}', '${item.roomseq}', '${item.virtualpurchasenumber}', '${item.transactiontime}');">상세보기</a>
		</dt>
		<dd>${item.typename}<em>|</em>${item.ppname} - ${item.roomname}</dd>
	</c:forEach>
</dl>
<%-- <c:if test="${scrData.totalPage ne scrData.page}"> --%>
<!-- 	<div class="more"> -->
<!-- 		<a href="#none" id="nextPage" onclick="javascript:nextPage();">20개 <span>더보기</span></a> -->
<!-- 	</div> -->
<%-- </c:if> --%>
