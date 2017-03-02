<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forDeletelist = null;
var forCreate = null;
var forMemoCreate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/memo/group/list/iframe.do"/>";
	forSearch.config.fn.complete = function() {
		doParentResize();
	};

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/memo/group/list/iframe.do"/>";
	forListdata.config.fn.complete = function() {
		doParentResize();
	};
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/memo/group/detail/iframe.do"/>";

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/memo/group/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forCreate = $.action("layer");
	forCreate.config.formId = "FormData";
	forCreate.config.url = "<c:url value="/memo/group/create/popup.do"/>";
	forCreate.config.options.width  = 500;
	forCreate.config.options.height = 100;
	forCreate.config.options.position = "middle";
	forCreate.config.options.title  = "<spring:message code="글:쪽지:그룹추가"/>";
	
	
	forMemoCreate = $.action("layer", {formId : "FormData"}); 
	forMemoCreate.config.formId = "FormData";
	forMemoCreate.config.url = "<c:url value="/memo/group/send/popup.do"/>";
	forMemoCreate.config.options.width  = 500;
	forMemoCreate.config.options.height = 350;
	forMemoCreate.config.options.position = "middle";
	forMemoCreate.config.options.title  = "<spring:message code="글:쪽지:쪽지쓰기"/>";
	forMemoCreate.validator.set({
		title : "<spring:message code="글:쪽지:쪽지를발송할대상자를"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
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
 * 목록에서 삭제할 때 호출되는 함수
 */
doDeletelist = function() { 
	forDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				// 첫페이지로 이동
				doPage(1);
			}
		}
	});
};
/**
 * parent의 iframe 리사이즈 
 */
doParentResize = function() {
	parent.onLoadIframe("frame-memo-group");
};
/**
 * 주소록 그룹 등록
 */
doCreateGroup = function() {
	forCreate.run();
};
/*
 * 등록 완료시 새로 고침
 */
reSetList =function(){
	doList();
};
/*
 * 쪽지쓰기 팝업
 */
doCreateMemo = function(){
	var resultCount =$("input[name=checkkeys]").size();
	
	for(var i =0;i<resultCount; i++){
		if(typeof $("input[name=checkkeys]:checked").eq(i).val() !== "undefined"){
			var index  =$("input[name=checkkeys]:checked").eq(i).val();
			
			if($("input[name=counts]").eq(index).val() > 0	){
				
			}else{
				$("input[name=checkkeys]:checked").eq(index).attr("checked" , false);
			}
		}
	}
	
	if(resultCount >0){
		forMemoCreate.run();
	}else{
		$.alert({
			message : "<spring:message code="글:쪽지:쪽지를발송할대상자를선택하십시오"/>",
			button1 : {
				callback : function() {
					return false;
				}
			}
		});
	} 
	
};
</script>
</head>
<body>
	<c:import url="srchMemoGroupIframe.jsp"/>
	
	<ul class="buttonsTop">
		<li class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreateGroup()" class="btn blue"><span class="mid"><spring:message code="버튼:등록" /></span></a>
				<a href="javascript:void(0)" onclick="doCreateMemo()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지쓰기" /></span></a>
			</c:if>
		</li>
	</ul>	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="callbackValue" value="reSetList" id="callbackValue"/>
		<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: auto" />
				<col style="width: 120px" />		
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
					<th><spring:message code="글:쪽지:그룹명" /></th>
					<th><spring:message code="글:쪽지:인원" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
					<td>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="addressGroupSeqs" value ="<c:out value="${row.memoAddressGroup.addressGroupSeq}"/>">
						<input type="hidden" name="names" value ="<c:out value="${row.memoAddressGroup.name}"/>">
						
					</td>
			        <td><a href="javascript:void(0)" onclick="doDetail({'addressGroupSeq':'${row.memoAddressGroup.addressGroupSeq}'});"><c:out value="${row.memoAddressGroup.name }" /></a></td>
					<td>
						<input type="hidden" name="counts" value="<c:out value="${row.memoAddressGroup.memberCount }" />">
						<c:out value="${row.memoAddressGroup.memberCount }" />
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</tbody>
		</table>
	</form>
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	<ul class="buttons">	
		<li class="left" id="checkButton" style="display:none;">
			<c:if test="${!empty paginate.itemList}">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
					<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
				</c:if>
			</c:if>
		</li>
		<li class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreateGroup()" class="btn blue"><span class="mid"><spring:message code="버튼:등록" /></span></a>
				<a href="javascript:void(0)" onclick="doCreateMemo()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지쓰기" /></span></a>
			</c:if>
		</li>
	</ul>	
</body>
</html>