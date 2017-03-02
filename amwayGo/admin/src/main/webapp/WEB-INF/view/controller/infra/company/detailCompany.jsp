<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
var forSub      = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doSub();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/company/cdms/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/company/cdms/edit.do"/>";
	
	forSub = $.action("ajax");
	forSub.config.formId      = "FormSub";
	forSub.config.url         = "<c:url value="/company/member/list/ajax.do"/>";
	forSub.config.type        = "html";
	forSub.config.containerId = "subContainer";
	forSub.config.fn.complete = function() {
		SUB.initPage();
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
 * 소속 회원 목록
 */
doSub = function() {
	forSub.run();
};
var SUB = {
	forSearch   : null,
	forListdata : null,
	initPage : function() {
		// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
		SUB.doInitializeLocal();
	
	},
	/**
	 * 설정
	 */
	doInitializeLocal : function() {
	
		SUB.forSearch = $.action("ajax");
		SUB.forSearch.config.formId = "SubFormSrch";
		SUB.forSearch.config.url    = "<c:url value="/company/member/list/ajax.do"/>";
		SUB.forSearch.config.type   = "html";
		SUB.forSearch.config.containerId = "subContainer";
		SUB.forSearch.config.fn.complete = function() {}
	
		SUB.forListdata = $.action("ajax");
		SUB.forListdata.config.formId = "SubFormList";
		SUB.forListdata.config.url    = "<c:url value="/company/member/list/ajax.do"/>";
		SUB.forListdata.config.type        = "html";
		SUB.forListdata.config.containerId = "subContainer";
		SUB.forListdata.config.fn.complete = function() {}
	},
	/**
	 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
	 */
	doSearch : function(rows) {
		var form = UT.getById(SUB.forSearch.config.formId);
		
		// 목록갯수 셀렉트박스의 값을 변경 했을 때
		if (rows != null && form.elements["perPage"] != null) {  
			form.elements["perPage"].value = rows;
		}
		SUB.forSearch.run();
		
	},
	/**
	 * 검색조건 초기화
	 */
	doSearchReset : function() {
		FN.resetSearchForm(SUB.forSearch.config.formId);
	},
	/**
	 * 목록페이지 이동. page navigator에서 호출되는 함수
	 */
	doPage : function(pageno) {
		var form = UT.getById(SUB.forListdata.config.formId);
		if(form.elements["currentPage"] != null && pageno != null) {
			form.elements["currentPage"].value = pageno;
		}
		SUB.doList();
	},
	/**
	 * 목록보기 가져오기 실행.
	 */
	doList : function() {
		SUB.forListdata.run();
	}
}
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCompany.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.company.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.company.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
		<col style="width: 140px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:소속:소속"/><span class="star">*</span></th>
			<td><c:out value="${detail.company.companyName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:사업자번호"/></th>
			<td><c:out value="${detail.company.businessNumber}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:전화번호"/></th>
			<td><c:out value="${detail.company.phoneOffice}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:팩스번호"/></th>
			<td><c:out value="${detail.company.phoneFax}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:소속:주소"/></th>
			<td>
				<c:if test="${!empty detail.company.zipcode and !empty detail.company.address}">
					<c:out value="${fn:substring(detail.company.zipcode, 0, 3)}"/>-<c:out value="${fn:substring(detail.company.zipcode, 3, 6)}"/> 
					&nbsp;<c:out value="${detail.company.address}"/>&nbsp;<c:out value="${detail.company.addressDetail}"/>
				</c:if>
			</td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'companySeq' : '<c:out value="${detail.company.companySeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
	<div class="vspace"></div>
	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="글:소속:소속회원"/></h4>
	</div>
	<div id="subContainer"></div>

	<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCompanySeq" value="<c:out value="${detail.company.companySeq}"/>"/>
	</form>
	
</body>
</html>