<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSubListdata   = null;
var forSubDetail     = null;
var forSubCreate     = null;
var forSubDeletelist = null;
var forSortUpdate	 = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();
};
/**
 * 설정
 */
doSubInitializeLocal = function() {
	
	// 하위코드를 다져온다.
	forSubListdata = $.action("ajax");
	forSubListdata.config.formId      = "SubFormList";
	forSubListdata.config.type        = "html";
	forSubListdata.config.containerId = "tabContainer";
	forSubListdata.config.url         = "<c:url value="/code/sub/list/ajax.do"/>";
	forSubListdata.config.fn.complete = function() {};
	
	//코드 추가 레이어 팝업을 띄운다.
	forSubCreate = $.action("layer");
	forSubCreate.config.formId         = "FormBrowseCode";
	forSubCreate.config.url            = "<c:url value="/code/create/popup.do"/>";
	forSubCreate.config.options.width  = 380;
	forSubCreate.config.options.height = 480;
	forSubCreate.config.options.title  = "<spring:message code="필드:코드:코드추가"/>";
	
	//코드 수정 레이어 팝업을 띄운다.
	forSubDetail = $.action("layer");
	forSubDetail.config.formId         = "SubFormDetail";
	forSubDetail.config.url            = "<c:url value="/code/edit/popup.do"/>";
	forSubDetail.config.options.width  = 380;
	forSubDetail.config.options.height = 480;
	forSubDetail.config.options.title  = "<spring:message code="필드:코드:코드수정"/>";

	// 하위 코드 삭제
	// validator를 사용하는 action은 formId를 생성시 setting한다
	forSubDeletelist = $.action("submit", {formId : "SubFormData"}); 
	forSubDeletelist.config.url             = "<c:url value="/code/sub/deletelist.do"/>";
	forSubDeletelist.config.target          = "hiddenframe";
	forSubDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forSubDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubDeletelist.config.fn.complete     = doSubCompleteDeletelist;
	forSubDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	//정렬순서 수정 레이어 팝업을 띄운다.
	forSortUpdate = $.action("layer");
	forSortUpdate.config.formId         = "FormSub";
	forSortUpdate.config.url            = "<c:url value="/code/edit/sort/popup.do"/>";
	forSortUpdate.config.options.width  = 380;
	forSortUpdate.config.options.height = 380;
	forSortUpdate.config.options.title  = "<spring:message code="필드:코드:정렬수정"/>";
	
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doSubPage = function(pageno) {
	var form = UT.getById(forSubListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doSubList();
};
/**
 * 목록보기 가져오기 실행.
 */
doSubList = function() {
	forSubListdata.run();
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doSubDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forSubDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSubDetail.config.formId);
	// 상세화면 실행
	forSubDetail.run();
};
/**
 * 등록화면을 호출하는 함수
 */
doSubCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forSubCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSubCreate.config.formId);
	// 등록화면 실행
	forSubCreate.run();
};

/**
 * 코드 추가 완료
 */
 doSubCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가추가되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSubList();
			}
		}
	});
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doSubDeletelist = function() { 
	forSubDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doSubCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSubList();
			}
		}
	});
};

/**
 * 정렬순서 수정화면을 호출하는 함수
 */
doSortOrderUpdate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forSortUpdate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSortUpdate.config.formId);
	// 등록화면 실행
	forSortUpdate.run();
};

</script>
</head>

<body>

	<table>
	<colgroup>
		<col style="width: 100%" />
	</colgroup>
	<tr>
		<td id="containerLeft" style="vertical-align:top;">
			<c:import url="srchCodegroupAjax.jsp"/>
		
			<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
			<table id="listSubTable" class="tbl-list">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: 120px" />
				<col style="width: 150px" />
				
				<col style="width: 120px" />
				<col style="width: 120px;" />
				<col style="width: 120px;" />
				<col style="width: auto;" />
				
				<col style="width: 60px;" />
				<col style="width: 60px;" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:번호" /></th>
					<th><spring:message code="필드:코드:코드" /></th>
					<th><spring:message code="필드:코드:코드명" /></th>
					
					<th><spring:message code="필드:코드:참조1" /></th>
					<th><spring:message code="필드:코드:참조2" /></th>
					<th><spring:message code="필드:코드:참조3" /></th>
					<th><spring:message code="필드:코드:설명" /></th>
					
					<th><spring:message code="필드:코드:사용" /></th>
					<th><spring:message code="필드:코드:정렬" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${itemList}" varStatus="i">
				<tr>
			        <td><c:out value="${i.count}"/></td>
			        <td><c:out value="${fn:replace(fn:replace(row.code,row.codeGroup,''),'::','')}"/></td>
					<td>
						<a href="javascript:doSubDetail({'codeGroup' : '<c:out value="${row.codeGroup}" />','code': '<c:out value="${row.code}" />'});">
							<c:out value="${row.codeName}" />
						</a>
					</td>
					<td><c:out value="${row.codeNameEx1}" /></td>
					<td><c:out value="${row.codeNameEx2}" /></td>
					<td><c:out value="${row.codeNameEx3}" /></td>
					<td class="align-l"><c:out value="${row.description}" /></td>
					<td>
						<aof:code type="print" codeGroup="YESNO" selected="${row.useYn}" removeCodePrefix="true"/>
					</td>
					<td>
						<c:out value="${row.sortOrder}" />
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty itemList}">
				<tr>
					<td colspan="9" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</table>
			</form>
            <div class="lybox-btn">
                <div class="lybox-btn-l">
                    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                        <a href="javascript:void(0)" onclick="doSortOrderUpdate({'srchCodeGroup' : '<c:out value="${condition.srchCodeGroup}" />'})" class="btn blue"><span class="mid"><spring:message code="버튼:정렬수정" /></span></a>
                    </c:if>
                    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                        <a href="javascript:void(0)" onclick="doSubCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
                    </c:if>
                </div>
                <div class="lybox-btn-r">
                </div>
            </div>
			<script type="text/javascript">
			initSubPage();
			</script>
		</td>
	</tr>
	</table>
	
</body>
</html>