<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
var forSearch   = null;
var forListdata = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action("ajax");
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/zipcode/list.do"/>";
	forSearch.config.type        = "html";
	forSearch.config.containerId = "containerListdata"; 
	forSearch.config.fn.complete = function() {};

	forListdata = $.action("ajax");
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/zipcode/list.do"/>";
	forListdata.config.type        = "html";
	forListdata.config.containerId = "containerListdata"; 
	forListdata.config.fn.complete = function() {};
};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	var form = UT.getById(forSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearch.run();
};
/**
 * 검색조건 초기화
 */
doSearchReset = function() {
	FN.resetSearchForm(forSearch.config.formId);
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doList();
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};
/**
 * 우편번호(주소) 선택
 */
doSelect = function(index) {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		var form = UT.getById("FormData");
		if (form.elements["zipcode"].length) {
			var returnValue = {zipcode : form.elements["zipcode"][index].value, address : form.elements["address"][index].value};
			par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
		} else {
			par["<c:out value="${param['callback']}"/>"].call(this, {zipcode : form.elements["zipcode"].value, address : form.elements["address"].value});
		}
	}
	$layer.dialog("close");
};
/**
 * 우편번호 찾기 타입 변경(구주소<->신주소)
 */
doChangeSrchType = function(type) {
	jQuery("#type").hide();	
	jQuery("#zipcode").show();	
	jQuery("#srchType").val(type);	
	jQuery(".comments").find(".comment-" + type).show().siblings().hide();	
};
</script>
</head>

<body>
<div id="type">
	<div class="lybox align-c" style="background-color: #74D36D">
		<a href="javascript:void(0)" onclick="doChangeSrchType('new')"><p class="description"><font color="#ffffff"><spring:message code="글:우편번호:새주소찾기"/></font></p></a>
	</div>
	<div class="vspace"></div>
	<div class="lybox align-c" style="background-color: #FFBB00">
		<a href="javascript:void(0)" onclick="doChangeSrchType('old')"><p class="description"><font color="#ffffff"><spring:message code="글:우편번호:구주소찾기"/></font></p></a>
	</div>
</div>
<div id="zipcode" style="display: none;">
	<c:set var="srchColumn">street=<spring:message code="글:우편번호:도로명"/>,building=<spring:message code="글:우편번호:건물명"/>,buildingNum1=<spring:message code="글:우편번호:건물번호"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchType" id="srchType" value="<c:out value="${condition.srchType}"/>" />
				<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>">
				<div class="comments">
					<div class="comment-old" style="display:"><spring:message code="글:우편번호:입력예시" /></div>
					<div class="comment-new" style="display:none;">
						<aof:code type="radio" codeGroup="${srchColumn}" defaultSelected="street" name="srchKey" />
					</div>
				</div>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="javascript:void(0);" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchType"    value="<c:out value="${condition.srchType}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>">
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<div id="containerListdata" class="scroll-y" style="height:375px;"></div>
	</form>
</div>
</body>
</html>