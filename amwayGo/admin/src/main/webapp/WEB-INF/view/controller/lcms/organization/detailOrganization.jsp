<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CONTENTS_TYPE_SCORM"      value="${aoffn:code('CD.CONTENTS_TYPE.SCORM')}"/>
<c:set var="CD_CONTENTS_TYPE_MOVIE"      value="${aoffn:code('CD.CONTENTS_TYPE.MOVIE')}"/>
<c:set var="CD_CONTENTS_TYPE_FLASH"      value="${aoffn:code('CD.CONTENTS_TYPE.FLASH')}"/>
<c:set var="CD_COMPLETION_TYPE_TIME"     value="${aoffn:code('CD.COMPLETION_TYPE.TIME')}"/>
<c:set var="CD_COMPLETION_TYPE_PROGRESS" value="${aoffn:code('CD.COMPLETION_TYPE.PROGRESS')}"/>

<c:set var="contentsDetailMenuId" value="" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/lcms/contents/list.do'}">
		<c:set var="contentsDetailMenuId" value="${row.menu.menuId}" scope="request"/>
	</c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COMPLETION_TYPE_TIME = "<c:out value="${CD_COMPLETION_TYPE_TIME}"/>";
var CD_COMPLETION_TYPE_PROGRESS = "<c:out value="${CD_COMPLETION_TYPE_PROGRESS}"/>";

var forListdata = null;
var forEdit     = null;
var forPreview  = null;
var forItemDetail = null;
var forDetail     = null;
var forCreateItem = null;
var forUpdatelistItem = null;
var forDeletelistItem = null;
var forScriptItem = null;
var forFilelist = null;
var forDetailContents = null;
var forEditMetadata = null;
var startfileGetted = []; // 시작파일을 ajax로 가져왔는지 체크.
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
	forListdata.config.url    = "<c:url value="/lcms/organization/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/lcms/organization/edit.do"/>";
	
	forPreview = $.action("layer");
	forPreview.config.formId = "FormLearning";
	forPreview.config.url    = "<c:url value="/learning/simple/popup.do"/>";
	forPreview.config.options.title = "<spring:message code="글:콘텐츠:미리보기"/>";
	forPreview.config.options.width = 1006;
	forPreview.config.options.height = 800;
	forPreview.config.options.draggable = false;
	forPreview.config.options.titlebarHide = true;
	forPreview.config.options.backgroundOpacity = 0.9;

	forItemDetail = $.action("layer");
	forItemDetail.config.formId = "FormItemDetail";
	forItemDetail.config.url    = "<c:url value="/lcms/item/resource.do"/>";
	forItemDetail.config.parameters = "decorator=popup&confirm=true";
	forItemDetail.config.options.width = 800;
	forItemDetail.config.options.height = 600;
	forItemDetail.config.options.title = "<spring:message code="글:콘텐츠:리소스관리" />";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/lcms/organization/detail.do"/>";
	
	forCreateItem = $.action("layer");
	forCreateItem.config.formId = "FormCreateItem";
	forCreateItem.config.url    = "<c:url value="/lcms/organization/create.do"/>";
	forCreateItem.config.options.width = 650;
	forCreateItem.config.options.height = 500;
	forCreateItem.config.options.title = "<spring:message code="글:콘텐츠:교시추가" />";
	forCreateItem.config.options.callback = doRefresh;
	
	forScriptItem = $.action("script", {formId : "FormListItem"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScriptItem.validator.set({
		title : "<spring:message code="필드:이동할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forUpdatelistItem = $.action("submit", {formId : "FormListItem"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelistItem.config.url             = "<c:url value="/lcms/item/updatelist.do"/>";
	forUpdatelistItem.config.target          = "hiddenframe";
	forUpdatelistItem.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelistItem.config.message.success = "<spring:message code="글:저장되었습니다"/>"; 
	forUpdatelistItem.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelistItem.config.fn.complete     = doRefresh;
	forUpdatelistItem.validator.set({
		title : "<spring:message code="필드:콘텐츠:교시제목"/>",
		name : "titles",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdatelistItem.validator.set({
		title : "<spring:message code="필드:콘텐츠:키워드"/>",
		name : "keywords",
		check : {
			maxlength : 255
		}
	});
	forUpdatelistItem.validator.set({
		title : "<spring:message code="필드:콘텐츠:시작파일"/>",
		name : "hrefs",
		data : ["!null"]
	});
	
	
	forUpdatelistItem.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습완료기준"/>",
		name : "completionThresholds",
		data : ["!null", "number"]
	});
	
	forDeletelistItem = $.action("submit", {formId : "FormListItem"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelistItem.config.url             = "<c:url value="/lcms/item/deletelist.do"/>";
	forDeletelistItem.config.target          = "hiddenframe";
	forDeletelistItem.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelistItem.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelistItem.config.fn.complete     = doCompleteDeletelistItem;
	forDeletelistItem.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forFilelist = $.action("ajax");
	forFilelist.config.url = "<c:url value="/lcms/resource/list.do"/>";
	forFilelist.config.type = "json";
	
	
	forDetailContents = $.action();
	forDetailContents.config.formId = "FormContentsDetail";
	forDetailContents.config.url    = "<c:url value="/lcms/contents/detail.do"/>";
	
	forEditMetadata = $.action("layer");
	forEditMetadata.config.formId = "FormEditMetadata";
	forEditMetadata.config.url    = "<c:url value="/lcms/metadata/item/edit/popup.do"/>";
	forEditMetadata.config.options.width = 500;
	forEditMetadata.config.options.height = 500;
	forEditMetadata.config.options.title = "<spring:message code="글:콘텐츠:메타데이터수정" />";
	
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
/**
 * 리소스관리화면을 호출하는 함수
 */
doItemDetail = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forItemDetail.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forItemDetail.config.formId);
	// 수정화면 실행
	forItemDetail.run();
};
/**
 * 콘텐츠 추가 및 등록
 */
doCreateItem = function(mapPKs) {
	// 콘텐츠 추가 form을 reset한다.
	UT.getById(forCreateItem.config.formId).reset();
	// 콘텐츠 추가 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreateItem.config.formId);
	// 콘텐츠 추가 실행
	forCreateItem.run();
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
 * 메타데이터 수정 화면을 호출하는 함수
 */
doEditMetadata = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forEditMetadata.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEditMetadata.config.formId);
	// 상세화면 실행
	forEditMetadata.run();
};
/**
 * 새로고침
 */
doRefresh = function() {
	doDetail({'organizationSeq' : '<c:out value="${detail.organization.organizationSeq}"/>'});
};
/**
 * 위로
 */
doUp = function() {
	var valid = forScriptItem.validator.isValid();
	if (valid == false) {
		return;
	}
	var selects = new Array();
	jQuery("#" + forScriptItem.config.formId + " :input[name=checkkeys]").each(
		function() {
			if (this.checked == true) {
				selects.push(jQuery(this).closest("tr").get(0));
			}
		}
	);
	var firstRow = null;
	var table = null;
	jQuery(selects).each(
		function() {
			table = jQuery(this).closest("table").get(0);
			if (this.rowIndex == 1) {
				firstRow = this;
				return;
			} 
			UT.moveTableRow(table, this.rowIndex, this.rowIndex - 1);
		}
	);
	if (firstRow != null) {
		UT.moveTableRow(table, firstRow.rowIndex, 1);
	}
};
/**
 * 아래로
 */
doDown = function() {
	var valid = forScriptItem.validator.isValid();
	if (valid == false) {
		return;
	}
	var selects = new Array();
	jQuery("#" + forScriptItem.config.formId + " :input[name=checkkeys]").each(
		function() {
			if (this.checked == true) {
				selects.push(jQuery(this).closest("tr").get(0));
			}
		}
	);
	var lastRow = null;
	var table = null;
	jQuery(selects.reverse()).each(
		function() {
			table = jQuery(this).closest("table").get(0);
			if (this.rowIndex == table.rows.length - 1) {
				lastRow = this;
				return;
			}
			UT.moveTableRow(table, this.rowIndex, this.rowIndex + 1);
		}
	);
	if (lastRow != null) {
		UT.moveTableRow(table, lastRow.rowIndex, table.rows.length - 1);
	}
};
/**
 * 순서 수정하기
 */
doUpdatelistItem = function() {
	jQuery("#" + forUpdatelistItem.config.formId + " :input[name=sortOrders]").each(
		function(index) {
			this.value = index;
		}
	);
	forUpdatelistItem.run();
}; 
/**
 * 목록삭제
 */
doDeletelistItem = function() {
	jQuery("#" + forDeletelistItem.config.formId + " :input[name=checkkeys]").each(
			function(index) {
				this.value = index;
			}
		);
	forDeletelistItem.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelistItem = function(success) {
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
 * 시작파일위치의 html목록 가져오기
 */
doGetStartFile = function(element) {
	if (element.length > 1) {
		return;
	}
	var text = element.options[0].text;
	var value = element.options[0].value.split("/");
	value.pop(value.length - 1);
	var filepath = value.join("/");

	if (jQuery.inArray(filepath, startfileGetted) > -1) {
		return;
	} else {
		startfileGetted.push(filepath);
	}

	forFilelist.config.parameters = "filepath=" + filepath;
	forFilelist.config.fn.complete = function(action, data) {
		if (data != null && data.files != null) {
			for (var i = 0; i < data.files.length; i++) {
				if (data.files[i].dir != true && text != data.files[i].saveName && (data.files[i].saveName.endsWith("html") || data.files[i].saveName.endsWith("htm"))) {
					element.length += 1;
					element.options[element.length - 1].value = filepath + "/" + data.files[i].saveName;
					element.options[element.length - 1].text = data.files[i].saveName;
				}
			}
		}
	};
	forFilelist.run();
};
/**
 * 콘텐츠관리의 상세보기 화면을 호출하는 함수
 */
doDetailContents = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailContents.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailContents.config.formId);
	// 상세화면 실행
	forDetailContents.run();
};

var oldCompletionThreshold = "";

/**
 * 학습완료기준 진도체크 구분 변경시
 */
doChangeCompletionType = function(val, index){
	
	if(val.value == CD_COMPLETION_TYPE_TIME){
		jQuery("#completionThresholds" + index).val(oldCompletionThreshold);
		jQuery("#second_text_id" + index).show();
		jQuery("#second_text2_id" + index).hide();
	}else{
		oldCompletionThreshold = jQuery("#completionThresholds" + index).val();
		jQuery("#completionThresholds" + index).val("100");
		jQuery("#second_text_id" + index).hide();
		jQuery("#second_text2_id" + index).show();
	}
};

doCompletionThresholdCheck = function(index){
	if(jQuery("#completionTypes" + index).val() == CD_COMPLETION_TYPE_PROGRESS){
		if(jQuery("#completionThresholds" + index).val() > 100){
			$.alert({
				message : "<spring:message code="글:콘텐츠:진도율은100%이하로등록가능합니다"/>"
			});
			jQuery("#completionThresholds" + index).val("100");
		};
	};
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchOrganization.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.organization.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.organization.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 115px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:콘텐츠:주차제목"/></th>
			<td><c:out value="${detail.organization.title}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:구분"/></th>
			<td><aof:code type="print" codeGroup="CONTENTS_TYPE" selected="${detail.organization.contentsTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
			<td><c:out value="${detail.organization.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:콘텐츠:콘텐츠크기"/></th>
			<td>
				<spring:message code="필드:콘텐츠:가로"/>&nbsp;:
				<c:choose>
					<c:when test="${!empty detail.organization.width}"><c:out value="${detail.organization.width}"/> px &nbsp;&nbsp;</c:when>
					<c:otherwise><spring:message code="글:콘텐츠:자동"/>&nbsp;&nbsp;</c:otherwise>
				</c:choose>
				<spring:message code="필드:콘텐츠:세로"/>&nbsp;:
				<c:choose>
					<c:when test="${!empty detail.organization.height}"><c:out value="${detail.organization.height}"/> px &nbsp;&nbsp;</c:when>
					<c:otherwise><spring:message code="글:콘텐츠:자동"/>&nbsp;&nbsp;</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${!empty contentsList}">
		<tr>
			<th><spring:message code="필드:콘텐츠:사용중인콘텐츠"/></th>
			<td>
				<ul style="line-height:20px;">
					<c:forEach var="row" items="${contentsList}" varStatus="i">
						<li style="list-style:circle;margin-left:13px;">
							<c:choose>
								<c:when test="${!empty contentsDetailMenuId}">
									<a href="javascript:void(0)" 
										onclick="doDetailContents({'contentsSeq':'<c:out value="${row.contents.contentsSeq}"/>'})"><c:out value="${row.contents.title}"/></a>
								</c:when>
								<c:otherwise>
									<c:out value="${row.contents.title}"/>
								</c:otherwise>
							</c:choose>
						</li>
					</c:forEach>
				</ul>
			</td>
		</tr>
		</c:if>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'organizationSeq' : '<c:out value="${detail.organization.organizationSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
				<c:choose>
					<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
						<c:forEach var="row" items="${itemList}" varStatus="i">
							<c:if test="${i.first}">
								<a href="javascript:void(0)" onclick="doItemDetail({'itemSeq' : '${row.item.itemSeq}'});" class="btn blue"><span class="mid"><spring:message code="글:콘텐츠:리소스"/></span></a>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" 
							onclick="doCreateItem({
							'contentsSeq' : '',
							'organizationSeq' : '<c:out value="${detail.organization.organizationSeq}"/>',
							'contentsTypeCd' : '<c:out value="${detail.organization.contentsTypeCd}"/>',
							'title' : '<c:out value="${detail.organization.title}"/>'
							})"
							class="btn blue"><span class="mid"><spring:message code="버튼:콘텐츠:교시추가" /></span></a>
					</c:otherwise>
				</c:choose>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<form id="FormListItem" name="FormListItem" method="post" onsubmit="return false;">
	<input type="hidden" name="contentsTypeCd" value="<c:out value="${detail.organization.contentsTypeCd}"/>"/>
	<table id="listTable" class="tbl-list">
	<colgroup>
		<c:choose>
			<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
				<col style="width:50px" />
				<col style="width:auto" />
				<col style="width:100px" />
				<col style="width:90px" />
				<col style="width:80px" />
			</c:when>
			<c:otherwise>
				<col style="width:40px" />
				<col style="width:50px" />
				<col style="width:auto" />
				<col style="width:200px" />
				<col style="width:170px" />
				<col style="width:90px" />
				<col style="width:70px" />
				<col style="width:80px" />
			</c:otherwise>
		</c:choose>
	</colgroup>
	<thead>
	<tr>
		<c:choose>
			<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:콘텐츠:교시제목" /></th>
				<th><spring:message code="필드:콘텐츠:학습완료기준" /></th>
				<th><spring:message code="필드:콘텐츠:메타데이터" /></th>
				<th><spring:message code="버튼:미리보기" /></th>
			</c:when>
			<c:otherwise>
				<th></th>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:콘텐츠:교시제목" /></th>
				<th><spring:message code="필드:콘텐츠:시작파일" /></th>
				<th><spring:message code="필드:콘텐츠:학습완료기준" /></th>
				<th><spring:message code="필드:콘텐츠:메타데이터" /></th>
				<th><spring:message code="필드:콘텐츠:리소스" /></th>
				<th><spring:message code="버튼:미리보기" /></th>
			</c:otherwise>
		</c:choose>
	</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${itemList}" varStatus="i">
		<tr>
			<c:choose>
				<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
			        <td>
			        	<c:out value="${i.count}"/>
						<input type="hidden" name="itemSeqs" value="<c:out value="${row.item.itemSeq}"/>">
						<input type="hidden" name="sortOrders" value="<c:out value="${row.item.sortOrder}"/>">
			        </td>
					<td><input type="text" name="titles" value="<c:out value="${row.item.title}"/>" style="width:95%;"></td>
					<td>
						<input type="hidden" name="completionTypes" id="completionTypes<c:out value="${i.count}"/>" value="<c:out value="${row.item.completionType}"/>"/>
						<input type="text" name="completionThresholds" id="completionThresholds<c:out value="${i.count}"/>" value="<aof:number value="${row.item.completionThreshold * 100}" pattern="###"/>" class="align-c" style="width:50px;" onkeyup="doCompletionThresholdCheck(<c:out value="${i.count}"/>);"/> %
					</td>
					<td>
						<a href="javascript:void(0)" 
					       onclick="doEditMetadata({'referenceSeq' : '${row.item.itemSeq}'});"
					       class="btn gray"><span class="small"><spring:message code="버튼:보기"/></span></a>
					</td>
					<td>
						<a href="#" onclick="doPreview({'organizationSeq' : '<c:out value="${detail.organization.organizationSeq}"/>'
						,'itemSeq' : '${row.item.itemSeq}'
						,'itemIdentifier' : '${row.item.identifier}'
						,'courseId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						,'applyId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						});" class="btn gray"><span class="small"><spring:message code="버튼:미리보기"/></span></a>
					</td>
				</c:when>
				<c:otherwise>
					<td>
						<input type="checkbox" name="checkkeys" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="itemSeqs" value="<c:out value="${row.item.itemSeq}"/>">
						<input type="hidden" name="sortOrders" value="<c:out value="${row.item.sortOrder}"/>">
						<input type="hidden" name="resourceSeqs" value="<c:out value="${row.itemResource.resourceSeq}"/>">
					</td>
			        <td><c:out value="${i.count}"/></td>
			        <td><input type="text" name="titles" value="<c:out value="${row.item.title}"/>" style="width:95%;"></td>
					<td>
						<c:set var="startFile" value="${aoffn:substringLastAfter(row.itemResource.href, '/')}"/>
						<select name="hrefs" class="select" style="width:190px;" onmouseover="doGetStartFile(this)">
							<option value="<c:out value="${row.itemResource.href}"/>"><c:out value="${startFile}"/></option>
						</select>
					</td>
					<td>
						<select name="completionTypes" id="completionTypes<c:out value="${i.count}"/>" onchange="doChangeCompletionType(this,<c:out value="${i.count}"/>);" 
							<c:if test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_MOVIE or detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_FLASH}">style="display: none;"</c:if>
						 >
							<aof:code type="option" codeGroup="COMPLETION_TYPE" selected="${row.item.completionType}"/>
						</select>
						<c:choose>
							<c:when test="${row.item.completionType eq CD_COMPLETION_TYPE_PROGRESS}">
								<input type="text" name="completionThresholds" id="completionThresholds<c:out value="${i.count}"/>" value="<aof:number value="${row.item.completionThreshold * 100}" pattern="###"/>" class="align-c" style="width:50px;" onkeyup="doCompletionThresholdCheck(<c:out value="${i.count}"/>);"/>
							</c:when>
							<c:otherwise>
								<input type="text" name="completionThresholds" id="completionThresholds<c:out value="${i.count}"/>" value="<c:out value="${row.item.completionThreshold}"/>" class="align-c" style="width:50px;" onkeyup="doCompletionThresholdCheck(<c:out value="${i.count}"/>);"/>
							</c:otherwise>
						</c:choose>
						<span id="second_text_id<c:out value="${i.count}"/>"
							<c:if test="${row.item.completionType eq CD_COMPLETION_TYPE_PROGRESS}">
								style="display: none;"
							</c:if>
							>
							<spring:message code="글:콘텐츠:초"/>
						</span>
						<span id="second_text2_id<c:out value="${i.count}"/>"
							<c:if test="${row.item.completionType ne CD_COMPLETION_TYPE_PROGRESS}">
								style="display: none;"
							</c:if>
							>
							%
						</span>
					</td>
					<td>
						<a href="javascript:void(0)" 
					       onclick="doEditMetadata({'referenceSeq' : '${row.item.itemSeq}'});"
					       class="btn gray"><span class="small"><spring:message code="버튼:보기"/></span></a>
					</td>
					<td>
						<a href="javascript:void(0)" 
						   onclick="doItemDetail({'itemSeq' : '${row.item.itemSeq}'});" 
						   class="btn gray"><span class="small"><spring:message code="글:콘텐츠:리소스"/></span></a>
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doPreview({
						'organizationSeq' : '<c:out value="${detail.organization.organizationSeq}"/>'
						,'itemSeq' : '${row.item.itemSeq}'
						,'itemIdentifier' : '${row.item.identifier}'
						,'courseId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						,'applyId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						});" class="btn gray"><span class="small"><spring:message code="버튼:미리보기"/></span></a>
					</td>
				</c:otherwise>
			</c:choose>
		</tr>
	</c:forEach>
	<c:if test="${empty itemList}">
		<c:choose>
			<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
				<tr>
					<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</c:if>
	</tbody>
	</table>
	
	</form>

	<div class="lybox-btn">
		<c:choose>
			<c:when test="${detail.organization.contentsTypeCd eq CD_CONTENTS_TYPE_SCORM}">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and !empty itemList}">
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doUpdatelistItem()" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</div>
				</c:if>
			</c:when>
			<c:otherwise>
				<div class="lybox-btn-l" id="checkButton" style="display:none;">
					<c:if test="${!empty itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
						<a href="javascript:void(0)" onclick="doDeletelistItem()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
					</c:if>
					<c:if test="${aoffn:size(itemList) ge 2 and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
						<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid"><spring:message code="버튼:위로"/></span></a>
						<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid"><spring:message code="버튼:아래로"/></span></a>
					</c:if>
				</div>
				<c:if test="${!empty itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doUpdatelistItem()" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</div>
				</c:if>
			</c:otherwise>
		</c:choose>
	</div>
	
</body>
</html>