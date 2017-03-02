<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var profTypeCd = {};
<c:forEach var="row" items="${profTypeCode}" varStatus="i">
profTypeCd["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
</c:forEach>
var forUpdate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.inputComment("FormUpdate");

	doAutoComplete();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdate = $.action("script", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠소유자"/>",
		name : "memberSeq",
		data : ["!null"]
	});
	forUpdate.config.fn.exec = function() {
		var form = UT.getById(forUpdate.config.formId);
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this, {
				memberSeq : form.elements["memberSeq"].value
			});
		}
		doClose();
	};
};
/**
 * 자동완성
 */
doAutoComplete = function() {
	var form = UT.getById(forUpdate.config.formId);
	UI.autoCompleteByEnter(form.elements["memberName"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);

		var action = $.action("ajax");
		action.config.type        = "json";
		action.config.url         = "<c:url value="/member/prof/like/name/list/json.do"/>";
		action.config.parameters  = param.join("&");
		action.config.fn.complete = function(action, data) {
			if (data != null && data.list != null) {
				var items = [];
				for (var i = 0, len = data.list.length; i < len; i++) {
					var member = data.list[i];
					var label = member.memberName;
					label += (member.profTypeCd != "" ? " - " + profTypeCd[member.profTypeCd] : "");
					label += (member.categoryName != "" ? " - " + categoryName : "");
					items.push({
						"name" : member.memberName,
						"label" : label,
						"value" : member.memberSeq
					});
				}
				response(items);
			}
		};
		action.run();
	}, function(item) { // select callback
		if (item == null) {
			form.elements["memberName"].value = "";
			form.elements["memberSeq"].value = "";
		} else {
			form.elements["memberName"].value = item.name;
			form.elements["memberSeq"].value = item.value;
		}
	});		
};
/**
 * 저장
 */
 doUpdate = function() {
	 forUpdate.run();
};
/**
 * 취소
 */
doClose = function() {
	$layer.dialog("close");
};
</script> 
</head>

<body>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<div><spring:message code="글:콘텐츠:변경하고자하는콘텐츠를선택하셨습니다"/></div>
	<div><spring:message code="글:콘텐츠:아래에새로운콘텐츠소유자를입력하시기바랍니다"/></div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
			<td>
				<input type="hidden" name="memberSeq" value="<c:out value="${detail.contents.memberSeq}"/>">
				<input type="text" name="memberName" value="<c:out value="${detail.contents.memberName}"/>" style="width:250px;">
				<div class="comment"><spring:message code="글:콘텐츠:이름을입력후Enter키를누르십시오"/></div>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>