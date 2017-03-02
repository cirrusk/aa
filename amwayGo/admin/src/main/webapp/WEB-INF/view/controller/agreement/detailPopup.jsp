<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html >
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/agreement/list.do"/>";

};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

</script>
</head>

<body>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th>약관 타입</th>
			<td>
				<c:out value="${agreement.agreementCodeName}"/>
			</td>
		</tr>
		<tr>
			<th>약관 버전</th>
			<td>
				<c:out value="${agreement.agreementVersion}"/>
			</td>
		</tr>
		<tr>
			<th>약관 제목</th>
			<td>
				<c:out value="${agreement.agreementTitle}"/>
			</td>
		</tr>
		<tr>
			<th>필수 여부</th>
			<td>
				<c:if test="${agreement.agreementChek == 1}">
					필수
				</c:if>
				<c:if test="${agreement.agreementChek == 2}">
					선택
				</c:if>
			</td>
		</tr>
		<tr>
			<th>약관내용</th>
			<td>
				<c:out value="${agreement.agreementText}"/>
			</td>
		</tr>
	</tbody>
	</table>
	</form>
</body>
</html>