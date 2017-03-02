<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
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
	forListdata.config.url    = "<c:url value="/menu/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/menu/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchMenu.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<c:out value="${detail.menu.updMemberName}"/>
		&nbsp;
		<strong><spring:message code="필드:수정일시"/></strong>
		<aof:date datetime="${detail.menu.updDtime}" pattern="${aoffn:config('format.datetime')}"/>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴아이디"/></th>
			<td><c:out value="${detail.menu.menuId}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:메뉴명"/></td>
			<td><c:out value="${detail.menu.menuName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:url"/></td>
			<td><c:out value="${detail.menu.url}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:urlTarget"/></td>
			<td><c:out value="${detail.menu.urlTarget}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:설명"/></td>
			<td><c:out value="${detail.menu.description}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:메뉴:노출여부"/></td>
			<td><aof:code type="print" codeGroup="YESNO" selected="${detail.menu.displayYn}" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'menuSeq' : '<c:out value="${detail.menu.menuSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>