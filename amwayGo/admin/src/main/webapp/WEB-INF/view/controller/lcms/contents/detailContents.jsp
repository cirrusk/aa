<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="orgDetailMenuId" value="" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/lcms/organization/list.do'}">
		<c:set var="orgDetailMenuId" value="${row.menu.menuId}" scope="request"/>
	</c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
var forDetail     = null;
var forDetailOrganization = null;
var forCreateOrganization = null;
var forUpdatelistOrg = null;
var forDeletelistOrg = null;
var forScriptOrg = null;
var forPreview  = null;
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
	forListdata.config.url    = "<c:url value="/lcms/contents/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/lcms/contents/edit.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/lcms/contents/detail.do"/>";
	
	forCreateOrganization = $.action("layer");
	forCreateOrganization.config.formId = "FormCreateOrg";
	forCreateOrganization.config.url    = "<c:url value="/lcms/organization/create.do"/>";
	forCreateOrganization.config.options.width = 700;
	forCreateOrganization.config.options.height = 600;
	forCreateOrganization.config.options.callback = doRefresh;

	forScriptOrg = $.action("script", {formId : "FormListOrg"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScriptOrg.validator.set({
		title : "<spring:message code="필드:이동할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forUpdatelistOrg = $.action("submit", {formId : "FormListOrg"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelistOrg.config.url             = "<c:url value="/lcms/contents/organization/updatelist.do"/>";
	forUpdatelistOrg.config.target          = "hiddenframe";
	forUpdatelistOrg.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelistOrg.config.message.success = "<spring:message code="글:저장되었습니다"/>"; 
	forUpdatelistOrg.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelistOrg.config.fn.complete     = doRefresh;
	
	forDeletelistOrg = $.action("submit", {formId : "FormListOrg"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelistOrg.config.url             = "<c:url value="/lcms/contents/organization/deletelist.do"/>";
	forDeletelistOrg.config.target          = "hiddenframe";
	forDeletelistOrg.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelistOrg.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelistOrg.config.fn.complete     = doCompleteDeletelistOrg;
	forDeletelistOrg.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forDetailOrganization = $.action();
	forDetailOrganization.config.formId = "FormOrgDetail";
	forDetailOrganization.config.url    = "<c:url value="/lcms/organization/detail.do"/>";
	
	forPreview = $.action("layer");
	forPreview.config.formId = "FormLearning";
	forPreview.config.url    = "<c:url value="/learning/simple/popup.do"/>";
	forPreview.config.options.title = "<spring:message code="글:콘텐츠:미리보기"/>";
	forPreview.config.options.width = 1006;
	forPreview.config.options.height = 800;
	forPreview.config.options.draggable = false;
	forPreview.config.options.titlebarHide = true;
	forPreview.config.options.backgroundOpacity = 0.9;
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
 * 차시관리의 상세보기 화면을 호출하는 함수
 */
doDetailOrganization = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailOrganization.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailOrganization.config.formId);
	// 상세화면 실행
	forDetailOrganization.run();
};
/**
 * 콘텐츠 추가 및 등록
 */
doCreateOrganization = function(mapPKs) {
	// 콘텐츠 추가 form을 reset한다.
	UT.getById(forCreateOrganization.config.formId).reset();
	// 콘텐츠 추가 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreateOrganization.config.formId);
	// 콘텐츠 추가 실행
	
	if (mapPKs["contentsSeq"] != "") {
		forCreateOrganization.config.options.title = "<spring:message code="글:콘텐츠:주차추가" />";
	} else {
		forCreateOrganization.config.options.title = "<spring:message code="글:콘텐츠:교시추가" />";
	}
	forCreateOrganization.run();
};
/**
 * 새로고침
 */
doRefresh = function() {
	doDetail({'contentsSeq' : '<c:out value="${detail.contents.contentsSeq}"/>'});
};
/**
 * 위로
 */
doUp = function() {
	var valid = forScriptOrg.validator.isValid();
	if (valid == false) {
		return;
	}
	jQuery("#" + forScriptOrg.config.formId + " tbody").each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $prev = $this.prev("tbody");
			if($prev.length > 0) {
				if ($prev.find(":input[name=checkkeys]").filter(":checked").length == 0) {
					$this.insertBefore($prev);
				}
			}
		}
	});
};
/**
 * 아래로
 */
doDown = function() {
	var valid = forScriptOrg.validator.isValid();
	if (valid == false) {
		return;
	}
	jQuery("#" + forScriptOrg.config.formId + " tbody").reverse().each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $next = $this.next("tbody");
			if($next.length > 0) {
				if ($next.find(":input[name=checkkeys]").filter(":checked").length == 0) {
					$this.insertAfter($next);
				}
			}
		}
	});
};
/**
 * 순서 수정하기
 */
doUpdatelistOrg = function() {
	jQuery("#" + forUpdatelistOrg.config.formId + " :input[name=sortOrders]").each(
		function(index) {
			this.value = index + 1;
		}
	);
	forUpdatelistOrg.run();
}; 
/**
 * 목록삭제
 */
doDeletelistOrg = function() {
	jQuery("#" + forDeletelistOrg.config.formId + " :input[name=checkkeys]").each(
		function(index) {
			this.value = index;
		}
	);
	forDeletelistOrg.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelistOrg = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doRefresh();
			}
		}
	});
};
/**
 * 미리보기
 */
doPreview = function(mapPKs) {
	// 미리보기화면 form을 reset한다.
	UT.getById(forPreview.config.formId).reset();
	// 미리보기화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPreview.config.formId);
	// 미리보기화면 실행
	if(forPreview.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
		forPreview.config.popupWindow.close();
		forPreview.config.popupWindow = null;
		setTimeout("forPreview.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	} else {
		forPreview.run();
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchContents.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.contents.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.contents.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠그룹명"/></th>
			<td><c:out value="${detail.contents.title}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:분류"/></th>
			<td><c:out value="${detail.contents.categoryString}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
			<td><c:out value="${detail.contents.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:상태"/></th>
			<td><aof:code type="print" codeGroup="CONTENTS_STATUS_TYPE" selected="${detail.contents.statusCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:설명"/></th>
			<td><c:out value="${detail.contents.description}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:등록자"/></th>
			<td><c:out value="${detail.contents.regMemberName}"/></td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">	
		<div class="lybox-btn-r">	
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'contentsSeq' : '<c:out value="${detail.contents.contentsSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
				<a href="javascript:void(0)" 
					onclick="doCreateOrganization({
					'contentsSeq' : '<c:out value="${detail.contents.contentsSeq}"/>',
					'organizationSeq' : '',
					'contentsTypeCd' : '',
					'title' : ''
					})" class="btn blue"><span class="mid"><spring:message code="버튼:콘텐츠:주차추가" /></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<form id="FormListOrg" name="FormListOrg" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 35px" />
		<col style="width: 50px" />
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: 100px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th></th>
			<th><spring:message code="필드:콘텐츠:주차"/></th>
			<th><spring:message code="필드:콘텐츠:교시"/></th>
			<th><spring:message code="필드:콘텐츠:제목"/></th>
			<th><spring:message code="필드:콘텐츠:콘텐츠구분"/></th>
			<th><spring:message code="버튼:콘텐츠:주차관리"/></th>
		</tr>
	<thead>
	<c:set var="weekCount" value="0"/>
	<c:set var="prevOrganizationSeq" value=""/>
	<c:forEach var="row" items="${contentsList}" varStatus="i">
		<c:if test="${!empty prevOrganizationSeq and prevOrganizationSeq ne row.organization.organizationSeq}">
			</tbody>
		</c:if>
		<c:if test="${prevOrganizationSeq ne row.organization.organizationSeq}">
			<c:set var="weekCount" value="${weekCount + 1}"/>
			<tbody>
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" onclick="FN.onClickCheckbox(this, 'checkButton')">
					<input type="hidden" name="contentsSeqs" value="<c:out value="${row.contentsOrganization.contentsSeq}"/>">
					<input type="hidden" name="organizationSeqs" value="<c:out value="${row.organization.organizationSeq}"/>">
					<input type="hidden" name="sortOrders" value="<c:out value="${row.contentsOrganization.sortOrder}"/>">
				</td>
				<td><c:out value="${weekCount}"/><spring:message code="필드:콘텐츠:주차"/></td>
				<td>&nbsp;</td>
				<td class="align-l"><c:out value="${row.organization.title}"/></td>
				<td><aof:code type="print" codeGroup="CONTENTS_TYPE" selected="${row.organization.contentsTypeCd}"/></td>
				<td>
					<c:if test="${!empty orgDetailMenuId}">
						<a href="javascript:void(0)" 
							onclick="doDetailOrganization({'organizationSeq':'<c:out value="${row.organization.organizationSeq}"/>'})" 
							class="btn black"><span class="small"><spring:message code="버튼:콘텐츠:주차관리"/></span></a>
					</c:if>
				</td>
			</tr>
		</c:if>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><c:out value="${row.item.sortOrder + 1}"/><spring:message code="필드:콘텐츠:교시"/></td>
			<td class="align-l"><c:out value="${row.item.title}"/></td>
			<td>&nbsp;</td>
			<td>
				<a href="#" onclick="doPreview({
				'organizationSeq' : '<c:out value="${row.organization.organizationSeq}"/>'
				,'itemSeq' : '<c:out value="${row.item.itemSeq}"/>'
				,'itemIdentifier' : '<c:out value="${row.item.identifier}"/>'
				,'courseId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
				,'applyId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
				,'width' : ''
				,'height' : ''
				});" class="btn gray"><span class="small"><spring:message code="버튼:미리보기"/></span></a>
			</td>
		</tr>
		<c:set var="prevOrganizationSeq" value="${row.organization.organizationSeq}"/>
		<c:if test="${i.last eq true}">
			</tbody>
		</c:if>
	</c:forEach>
	<c:if test="${empty contentsList}">
		<tbody>
			<tr>
				<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</tbody>
	</c:if>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButton" style="display:none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<c:if test="${!empty contentsList}">
					<a href="javascript:void(0)" onclick="doDeletelistOrg()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
				</c:if>
			</c:if>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<c:if test="${aoffn:size(contentsList) ge 2}">
					<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid"><spring:message code="버튼:위로"/></span></a>
					<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid"><spring:message code="버튼:아래로"/></span></a>
				</c:if>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and aoffn:size(contentsList) ge 2}">
				<a href="javascript:void(0)" onclick="doUpdatelistOrg()" class="btn blue"><span class="mid"><spring:message code="버튼:콘텐츠:순서저장"/></span></a>
			</c:if>
		</div>
	</div>		
			
</body>
</html>