<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<script type="text/javascript">
var forListdata = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
};
//팝업 닫기
doClose = function() {
	$layer.dialog("close");
};

/**
 * 목록보기
 */
doGoMemo = function() {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this);
	}
	$layer.dialog("close");
	
	//parent.document.location.href = FN.doGoMenu('<c:url value="/usr/memo.do"/>', '009009');
	//doClose();
};
</script>
</head>
<body>
	<div style="display:none;">
		<c:import url="srchMemoReceiveIframe.jsp"/>
	</div>
	<table class="boardView">
	<caption><spring:message code="필드:받은쪽지"/> <spring:message code="필드:상세내용"/></caption>
	<colgroup>
		<col style="width:15%" />
        <col style="width:auto" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:쪽지:보낸사람"/></th>
			<td><c:out value="${memoRecent.sendMember.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:전송일시"/></th>
			<td><aof:date datetime="${memoRecent.memoSend.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:쪽지내용"/></th>
			<td style="line-height:22px;">
				<aof:text type="text" value="${memoRecent.memoSend.memo}"/>
			</td>
		</tr>
	</tbody>
	</table>
	<div class="btnArea_r">
		<a class="btn_type02" href="#" onclick="doGoMemo();"><strong><spring:message code="메뉴:쪽지함"/></strong></a>
		<a href="#" onclick="doClose()" class="btn_pop"><strong><spring:message code="버튼:닫기" /></strong></a>
	</div>
</body>
</html>