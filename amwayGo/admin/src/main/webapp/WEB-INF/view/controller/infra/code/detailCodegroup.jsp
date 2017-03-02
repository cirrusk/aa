<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata      = null;
var forEdit          = null;
var forSub           = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doSub({'srchCodeGroup' : '<c:out value="${detail.code.codeGroup}"/>'});
	
	UI.tabs("#tabs");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/code/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/code/edit.do"/>";
	
	forSub = $.action("ajax");
	forSub.config.formId      = "FormSub";
	forSub.config.type        = "html";
	forSub.config.containerId = "tabContainer";
	
	forSub.config.fn.complete = function() {
		$("#tabs").show();
	};
	
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

/**
 * 하위 코드를 가져온다(AJAX)
 */
doSub = function(mapPKs, tab) {
	UT.copyValueMapToForm(mapPKs, forSub.config.formId);
	forSub.config.url = "<c:url value="/code/sub/list/ajax.do"/>";
	forSub.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCodegroup.jsp"/>
	</div>

	<div class="lastupdate">
		<strong><spring:message code="필드:수정일시"/></strong>
		<aof:date datetime="${detail.code.updDtime}" pattern="${aoffn:config('format.datetime')}"/>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:코드:그룹코드명"/></th>
			<td><c:out value="${detail.code.codeName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:코드:그룹코드"/></td>
			<td><c:out value="${detail.code.code}"/></td>
		</tr>
	</tbody>
	</table>

    <div class="lybox-btn">
        <div class="lybox-btn-l">
            
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                <a href="#" onclick="doEdit({'codeGroup' : '<c:out value="${detail.code.codeGroup}"/>','code' : '<c:out value="${detail.code.code}"/>'});"
                    class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
        </div>
    </div>

	<div class="clear"></div>

<div id="tabs" style="display: none;">
    <ul class="ui-widget-header-tab-custom"><!-- ui-widget-header-tab-custom -->
        <li><a href="#tabContainer"><spring:message code="필드:코드:코드"/></a></li>
    </ul>
    <div id="tabContainer"><!-- ajax 데이터 --></div>
</div>

</body>
</html>