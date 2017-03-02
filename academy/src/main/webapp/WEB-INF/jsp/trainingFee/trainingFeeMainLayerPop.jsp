<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
</head>

<body>
	<div class="pbLayerWrap" id="uiLayerPop_w02" tabindex="0" style="width: 450px; display: block; position: fixed; top: 180px; left: 50%; margin-top: 100px; margin-left: -225px;">
		<div class="pbLayerHeader">
			<strong><img src="/_ui/desktop/images/academy/h1_w020400400_pop.gif" alt="상세보기"></strong>
			<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="닫기"></a>
		</div>
		<div class="pbLayerContent">
			
			<table class="tblList lineLeft">
				<caption>상세보기</caption>
				<colgroup>
					<col style="width:15%">
					<col style="width:25%">
					<col style="width:30%">
					<col style="width:30%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">이름</th>
						<th scope="col">ABO번호</th>
						<th scope="col">교육비(원)</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${ptlist}" varStatus="status">
					<tr>
						<td>${status.index + 1 }</td>
						<td>${item.mdispname }</td>
						<td>${item.mDistNo }</td>
						<td class="textR">${item.monthSales }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>