<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
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
	forListdata.config.url    = "<c:url value="/lcms/organization/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/lcms/organization/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/lcms/organization/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:주차제목"/>",
		name : "title",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:가로"/>)",
		name : "width",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:세로"/>)",
		name : "height",
		data : ["number"],
		check : {
			maxlength : 4
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
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchOrganization.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="organizationSeq" value="<c:out value="${detail.organization.organizationSeq}"/>"/>
		<input type="hidden" name="contentsTypeCd" value="<c:out value="${detail.organization.contentsTypeCd}"/>"/>
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.organization.memberSeq}"/>"/>
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 100px" />
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:콘텐츠:주차제목"/></th>
				<td><input type="text" name="title" style="width:90%;" value="<c:out value="${detail.organization.title}"/>"></td>
			</tr>
			<tr>
				<th><spring:message code="필드:콘텐츠:구분"/></th>
				<td><aof:code type="print" codeGroup="CONTENTS_TYPE" selected="${detail.organization.contentsTypeCd}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:콘텐츠:콘텐츠크기"/></th>
				<td>
					<spring:message code="필드:콘텐츠:가로"/>
					<input type="text" name="width" value="<c:out value="${detail.organization.width}"/>" 
						class="align-c" style="width:50px;"/> px &nbsp;&nbsp;
					<spring:message code="필드:콘텐츠:세로"/>
					<input type="text" name="height" value="<c:out value="${detail.organization.height}"/>"
						class="align-c" style="width:50px;"/> px
				</td>
			</tr>
		</tbody>
		</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="organizationSeq" value="<c:out value="${detail.organization.organizationSeq}"/>"/>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and detail.organization.useCount eq 0}">
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