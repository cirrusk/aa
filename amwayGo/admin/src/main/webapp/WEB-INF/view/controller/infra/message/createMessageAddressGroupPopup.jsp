<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/message/group/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsert;
	forInsert.validator.set({
		title : "<spring:message code="글:주소록:그룹명"/>",
		name : "groupName",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};

/*
 * 등록 완료시 부모 iframe 새로고침
 */
doCompleteInsert  = function(){
	
	$layer.dialog("close");	
};

</script>
</head>
<body>	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		<table >
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
						<input type="text" name="groupName" style="width: 350px;" maxlength="200">
					</td>
					<td >
						<a href="javascript:void(0)" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
					</td>
				</tr>		
			</tbody>
		</table>
	</form>
</body>
</html>