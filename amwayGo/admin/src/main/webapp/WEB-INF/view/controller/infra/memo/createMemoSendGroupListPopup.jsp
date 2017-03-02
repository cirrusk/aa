<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch = null;
var forListdata = null;
var forAdd = null;
var forGroup = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	//[2]. 기본 설정 그룹
	onChange('<c:out value="${choice}" />');

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action("ajax");
	forSearch.config.formId = "FormSrch";
	forSearch.config.type        = "html";
	forSearch.config.containerId = "ajaxList";
	forSearch.config.fn.complete = function() {
		
	};

	forListdata = $.action("ajax");
	forListdata.config.formId = "FormList";
	forListdata.config.type        = "html";
	forListdata.config.containerId = "ajaxList";		
	forListdata.config.fn.complete = function() {
		
	};
	
	forAdd = $.action("ajax");
	forAdd.config.formId      = "FormAjax";
	forAdd.config.type        = "html";
	forAdd.config.containerId = "ajaxList";
	forAdd.config.url         = "<c:url value="/message/add/list/ajax.do"/>";	
	forAdd.config.fn.complete = function() {};
	
	forGroup = $.action("ajax");
	forGroup.config.formId      = "FormAjax";
	forGroup.config.type        = "html";
	forGroup.config.containerId = "ajaxList";
	forGroup.config.url         = "<c:url value="/message/group/list/ajax.do"/>";	
	forGroup.config.fn.complete = function() {};
	
};
/*
 * 변경될때 진행되는 ajax
 */
onChange = function(element){
	if(element.value == "add"){
		forSearch.config.url    = "<c:url value="/message/add/list/ajax.do"/>";
		forListdata.config.url    = "<c:url value="/message/add/list/ajax.do"/>";
		forAdd.run();
	}else{
		forSearch.config.url    = "<c:url value="/message/group/list/ajax.do"/>";	
		forListdata.config.url    = "<c:url value="/message/group/list/ajax.do"/>";	
		forGroup.run();
	}
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
/*
 * 추가 버튼 클릭시 부모 jsp 값 셋팅 그룹
 */
doSelectGroup = function(){
	var returnValue = null;	
	var form = UT.getById("FormData"); 
	returnValue = [];
	
	if($("input[name=checkkeys]:checked").length >0){
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				if (form.elements["checkkeys"][i].checked == true) {
					var values = {
						addressGroupSeq : form.elements["addressGroupSeqs"][i].value, 	
						name : form.elements["groupNames"][i].value
					};
					returnValue.push(values);
				}
			}		
			
		}else{
			
			var values = {
					addressGroupSeq : form.elements["addressGroupSeqs"].value, 	
					name : form.elements["groupNames"].value
				};
			returnValue.push(values);
		}
		
		if(returnValue.length > 0){
			var par = $layer.dialog("option").parent;
			if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
				par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
			}
			$layer.dialog("close");
		}
	}else{
		$.alert({message : "<spring:message code="글:쪽지:쪽지를발송할대상자를선택하십시오"/>"});
		return false;
	}
};
/*
 * 추가 버튼 클릭시 부모 jsp 값 셋팅 회원
 */
doSelectMember = function(){
	var returnValue = null;	
	var form = UT.getById("FormData"); 
	returnValue = [];
	if($("input[name=checkkeys]:checked").length >0){
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				if (form.elements["checkkeys"][i].checked == true) {
					var values = {
						memberSeq : form.elements["memberSeqs"][i].value, 	
						memberName : form.elements["memberNames"][i].value
					};
					returnValue.push(values);
				}
			}
		}else{
			var values = {
					memberSeq : form.elements["memberSeqs"].value, 	
					memberName : form.elements["memberNames"].value
				};
			returnValue.push(values);
		}	
		
		if(returnValue.length > 0){
			var par = $layer.dialog("option").parent;
			if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
				par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
			}		
			$layer.dialog("close");
		}
	}else{
		$.alert({message : "<spring:message code="글:쪽지:쪽지를발송할대상자를선택하십시오"/>"});
		return false;
	}
	
};
</script>
</head>
<body>
<form id="FormAjax" name="FormAjax" method="post" onsubmit="return false;">
<input type="hidden" name="callback" value="doAddReceiver"/>
</form>
	<c:set var="Select">group=<spring:message code="필드:쪽지:그룹"/>,add=<spring:message code="필드:쪽지:개별"/></c:set>
	<div class="lybox search">
		<fieldset>
			<spring:message code="필드:쪽지:쪽지대상선택"/>	
			<select name="changeSelect" onchange="onChange(this)" id="changeSelect">
				<aof:code type="option" codeGroup="${Select}" selected="${choice}"/>
			</select>
		</fieldset>
	</div>
	<div id ="ajaxList"></div>
</body>
</html>