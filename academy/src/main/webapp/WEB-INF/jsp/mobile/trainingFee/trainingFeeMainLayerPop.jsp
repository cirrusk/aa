<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
	
	<div class="pbLayerPopup" id="uiLayerPop_mTFDetail" tabindex="0" style="display: block; top: 338px;">
		<div class="pbLayerHeader">
			<strong>상세보기</strong>
		</div>
		<div class="pbLayerContent">
			<div class="tblPopWrap">
				<table class="tblPop">
					<caption>상세보기</caption>
					<colgroup>
						<col style="width:55%">
						<col style="width:auto">
					</colgroup>
					<thead>
					<tr>
						<th scope="col">이름(ABO번호)</th>
						<th scope="col" class="textR">교육비</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach var="item" items="${ptlist}" varStatus="status">
					<tr>
						<td><span class="listDot">${item.mdispname }(${item.mDistNo })</span></td>
						<td class="textR">${item.monthSales }</td>
					</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
