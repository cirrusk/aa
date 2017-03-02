<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var forBrowseCategory = null;
var profTypeCd = {};
<c:forEach var="row" items="${profTypeCode}" varStatus="i">
profTypeCd["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
</c:forEach>
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

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/lcms/contents/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/lcms/contents/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/lcms/contents/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	forBrowseCategory = $.action("layer");
	forBrowseCategory.config.formId = "FormParameters";
	forBrowseCategory.config.url    = "<c:url value="/category/contents/list/popup.do"/>";
	forBrowseCategory.config.parameters = "callback=doSetCategory&limitCategoryLevel=maxSelect";
	forBrowseCategory.config.options.width = 500;
	forBrowseCategory.config.options.height = 400;
	forBrowseCategory.config.options.title = "<spring:message code="글:콘텐츠:분류선택"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠그룹명"/>",
		name : "title",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:분류"/>",
		name : "categorySeq",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠소유자"/>",
		name : "memberSeq",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:설명"/>",
		name : "description",
		check : {
			maxlength : 1000
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
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 분류찾기
 */
doBrowseCategory = function() {
	forBrowseCategory.run();	
};
/**
 * 분류세팅
 */
doSetCategory = function(returnValue) {
	if (typeof returnValue === "object") {
		var form = UT.getById(forUpdate.config.formId);
		form.elements["categorySeq"].value = returnValue.categorySeq;
		form.elements["categoryName"].value = returnValue.categoryString;
	}
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
</script> 
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchContents.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="contentsSeq" value="<c:out value="${detail.contents.contentsSeq}"/>"/>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠그룹명"/></th>
			<td><input type="text" name="title" value="<c:out value="${detail.contents.title}"/>" style="width:50%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:분류"/></th>
			<td>
				<input type="hidden" name="categorySeq" value="<c:out value="${detail.contents.categorySeq}"/>">
				<input type="hidden" name="oldCategorySeq" value="<c:out value="${detail.contents.categorySeq}"/>">
				<input type="text" name="categoryName" value="<c:out value="${detail.contents.categoryString}"/>" style="width:50%;" readonly="readonly">
				<a href="javascript:void(0)" onclick="doBrowseCategory()" class="btn gray"><span class="small"><spring:message code="버튼:분류선택"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
			<td>
				<input type="hidden" name="memberSeq" value="<c:out value="${detail.contents.memberSeq}"/>">
				<input type="text" name="memberName" value="<c:out value="${detail.contents.memberName}"/>" style="width:250px;">
				<div class="comment"><spring:message code="글:콘텐츠:이름을입력후Enter키를누르십시오"/></div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:상태"/></th>
			<td><aof:code type="radio" codeGroup="CONTENTS_STATUS_TYPE" name="statusCd" selected="${detail.contents.statusCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:설명"/></th>
			<td><textarea name="description" id="description" style="width:90%; height:100px"><c:out value="${detail.contents.description}"/></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:등록자"/></th>
			<td><c:out value="${detail.contents.regMemberName}"/></td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="contentsSeq" value="<c:out value="${detail.contents.contentsSeq}"/>"/>
		<input type="hidden" name="categorySeq" value="<c:out value="${detail.contents.categorySeq}"/>">
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>