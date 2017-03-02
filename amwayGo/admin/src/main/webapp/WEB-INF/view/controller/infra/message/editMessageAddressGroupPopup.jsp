<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/message/group/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";	
	forUpdate.config.fn.complete     = function() {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		$layer.dialog("close");
	};
	setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="글:주소록:그룹명"/>",
		name : "groupName",
		data : ["!null"]
	});
};

/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};

/**
 * 레이어 닫기
 */
doClose = function() {
	$layer.dialog("close");
};

</script>
</head>
<body>
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="addressGroupSeq" value="<c:out value="${detail.addressGroupSeq}"/>" />
		<table>
			<colgroup>
				<col style="width:40px" />
				<col style="width: auto" />
				<col style="width:80px" />
			</colgroup>
			<tbody>
				<tr>
					<th>
						<spring:message code="글:주소록:그룹명" />
					</th>
					<td>
						<input type="text" name="groupName" value="<c:out value="${detail.groupName}"/>" style="width: 350px;" maxlength="200">	
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
					</td>
				</tr>		
			</tbody>
		</table>
	</form>
</body>
</html>