<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/course/agreement/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/survey/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/survey/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/agreement/create.do"/>";

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
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};
/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	// 등록화면 실행
	forCreate.run();
};

doSelect = function(mapPKs){
	var n = $("input:checkbox[name=agreementSeq]:checked").length;
	if(n < 1){
		alert("약관을 선택해 주세요.");
		return;
	}else if(n >= 4){
		alert("약관은 3가지까지만 선택가능합니다.");
		return;
	}else{
		$("input:checkbox[name=agreementSeq]:checked").each(function(idx, elem){
			$("#srchAgreeSeq"+(idx+1)).val($(elem).val());
		});
	}
	mapPKs.agreementSeq1 = $("#srchAgreeSeq1").val();
	mapPKs.agreementSeq2 = $("#srchAgreeSeq2").val();
	mapPKs.agreementSeq3 = $("#srchAgreeSeq3").val();
	var par = $layer.dialog("option").parent;
    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
        par["<c:out value="${param['callback']}"/>"].call(this,mapPKs);
    }
    $layer.dialog("close");
};

checkSeq = function(){
/* 	var n = $( "input:checked" ).length;
	
	if(n > 3){
		 alert("3가지만 클릭 가능합니다.");
		 $(this).prop("checked", false);
	} */
	var n = 0;
 	$('input:checkbox[name="agreementSeq"]').each(function(){
	      if(n < 1){
	    	  alert("약관을 선택하세요.");
	    	  this.attr("checked", false);
	    	  
	      }
	      if(this.checked && n < 3){
	    	  n++;
	      }
	});	
};
checkSeq = function(){
	
}
</script>
</head>

<body>

	<form id="FormSeq" name="" method="post">
    	<input type="hidden" id="srchAgreeSeq1" name="srchAgreeSeq1" />
      	<input type="hidden" id="srchAgreeSeq2" name="srchAgreeSeq2" />
      	<input type="hidden" id="srchAgreeSeq3" name="srchAgreeSeq3" />
	</form>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 80px" />
		<col style="width: 300px" />
		<col style="width: 60px" />
		<col style="width: 40px" />
	</colgroup>
	<thead>
		<tr>
			<th>No.</th>
			<th><span class="sort" sortid="1">약관 타입</span></th>
			<th>약관 제목</th>
			<th>필수 여부</th>
			<th>버전</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" id="agreementSeq" name="agreementSeq" value="${row.agreement.agreementSeq}">
			</td>
	        <td>
	        	<c:out value='${row.agreement.agreementCodeName}'/>
	        </td>
			<td>
				<c:out value="${row.agreement.agreementTitle}"/>
			</td>
	        <td>
				<c:if test="${row.agreement.agreementChek == 1}">	        
	        		필수
	        	</c:if>
	        	<c:if test="${row.agreement.agreementChek == 2}">	        
	        		선택
	        	</c:if>
	        </td>
			<td><c:out value="${row.agreement.agreementVersion}"/></td>
		</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
		</c:if>
	</table>
		<div class="lybox-btn">
			<div class="lybox-btn-r">
 				<a href="javascript:doSelect({'agreementSeq1' : '', 'agreementSeq2' : '', 'agreementSeq3' : ''});" class="btn black">선택하기</a>
 			</div>
		</div>
	</form>
</body>
</html>