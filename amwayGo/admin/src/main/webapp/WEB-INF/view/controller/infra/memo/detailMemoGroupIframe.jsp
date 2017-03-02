<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forDetail = null;
var forUpdate = null;
var forInsertMember = null;
var forDeletelist = null;
var forMemoCreate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	forDetailList.run();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/memo/group/list/iframe.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/memo/group/detail/iframe.do"/>";	
	
	forDetailList = $.action("ajax");
	forDetailList.config.formId      = "FormDetailList";
	forDetailList.config.type        = "html";
	forDetailList.config.containerId = "detilMemoList";
	forDetailList.config.url         = "<c:url value="/memo/group/detail/ajax.do"/>";	
	forDetailList.config.fn.complete = function() {};
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/memo/group/member/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = doCompleteUpdate;
	forUpdate.validator.set({
		title : "<spring:message code="글:쪽지:그룹명"/>",
		name : "name",
		data : ["!null"]
	});
	
	
	forInsertMember = $.action("layer");
	forInsertMember.config.formId = "FormUpdate";
	forInsertMember.config.url = "<c:url value="/memo/group/member/popup.do"/>";
	forInsertMember.config.options.width  = 700;
	forInsertMember.config.options.height = 700;
	forInsertMember.config.options.position = "middle";
	forInsertMember.config.options.title  = "<spring:message code="글:쪽지:인적정보검색"/>";	
	forInsertMember.config.options.callback = reSetList;
	
	forDeletelist = $.action("submit", {formId : "FormDetailList"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/memo/group/member/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="글:쪽지:추가할대상자를선택"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forMemoCreate = $.action("layer", {formId : "FormDetailList"});
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
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forDetailList.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	forDetailList.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * parent의 iframe 리사이즈 
 */
doParentResize = function() {
	parent.onLoadIframe("frame-memo-group");
};
/*
 * 인원추가 팝업창 
 */
doInsertMember = function(){
	forInsertMember.run();
};
/*
 * 인원추가후 
 */
reSetList = function(){	
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
/*
 * 주소록 그룹 수정
 */
doUpdate= function(){
	forUpdate.run();
};
/*
 * 수정후 새로고침
 */
doCompleteUpdate= function(){
	forDetail.run();
};
/*
 * 쪽지쓰기 팝업
 */
doCreateMemo = function(){
	var resultCount =$("input[name=checkkeys]").size();
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
	<div style="display:none;">
		<c:import url="srchMemoGroupIframe.jsp"/>
	</div>
	
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">	
	<input type="hidden" name="addressGroupSeq" value="<c:out value="${detail.memoAddressGroup.addressGroupSeq}"/>" >
	<input type="hidden" name="callbackValue" value="reSetList" id="callbackValue"/>
		<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col/>
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code="글:쪽지:그룹명" /></th>
					<td>
						<input type="text" name="name" value="<c:out value="${detail.memoAddressGroup.name}"/>" style="width: 350px" maxlength="200"/>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
		
		<br>		
	</form>
	<form name="FormDetailList" id="FormDetailList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="addressGroupSeq" value="<c:out value="${detail.memoAddressGroup.addressGroupSeq}"/>" >
		<div id ="detilMemoList"></div>
	</form>
	
		
</body>
</html>