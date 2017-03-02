<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<form id="basePlaza" name="basePlaza" method="POST">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">변경 이력</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
<!-- 						<colgroup> -->
<!-- 							<col width="15%" /> -->
<!-- 							<col width="40"  /> -->
<!-- 							<col width="10%" /> -->
<!-- 							<col width="40%" /> -->
<!-- 						</colgroup> -->
						<tr>
							<th>NO</th>
							<th>pp명</th>
							<th>pp코드</th>
							<th>웨어하우스코드</th>
							<th>상태</th>
							<th>수정일시</th>
							<th>수정자</th>
						</tr>
						<c:forEach var="result" items="${dataList}" varStatus="status">
						<tr>
							<td><c:out value="${result.historyseq}"/></td>
							<td><c:out value="${result.ppname}"/></td>
							<td><c:out value="${result.ppseq}"/></td>
							<td><c:out value="${result.warehousecode}"/></td>
							<td><c:out value="${result.statuscode}"/></td>
							<td><c:out value="${result.modifydatetime}"/></td>
							<td><c:out value="${result.modifier}"/></td>
						</tr>
						</c:forEach>
					</table>
				</div>
				<div class="btnwrap clear">
<!-- 					<a href="javascript:planSave();" id="aInsert" class="btn_orange">저장</a> -->
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
