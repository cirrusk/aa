<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<dl class="tblBizroomState" id="rsvInfoTable">
	<c:forEach items="${expInfoList}" var="item" varStatus="status">
		<c:if test="${item.cancelcodecount eq 0}">
			<dt>
				등록일자 : ${item.purchasedate}<em>|</em>총 ${item.exprsvtotalcounnt}건 예약
				<a href="#none" class="btnTbl" onclick="javascript:expInfoDetailList('${item.purchasedate}', '${item.typeseq}', '${item.ppseq}', '${item.transactiontime}')">상세보기</a>
			</dt>
		</c:if>
		<c:if test="${item.cancelcodecount ne 0}">
			<dt>
				등록일자 : ${item.purchasedate}<em>|</em>${item.exprsvtotalcounnt}건 예약<em>|</em>${item.cancelcodecount}건 취소 
				<a href="#none" class="btnTbl" onclick="javascript:expInfoDetailList('${item.purchasedate}', '${item.typeseq}', '${item.ppseq}', '${item.transactiontime}')">상세보기</a>
			</dt>
		</c:if>
		<dd>${item.typename}<em>|</em>${item.ppname}</dd>
	</c:forEach>
</dl>
