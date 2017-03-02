<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appTomarrow"><aof:date datetime="${today}" pattern="${aoffn:config('format.date')}" addDate="1"/></c:set>
<aof:code type="set" codeGroup="CDMS_PROJECT_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forEdit     = null;
var companyType = {};
var memberType = {};
var $inputCompany = null;
var $inputMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.datepicker(".datepicker", {minDate : UT.formatStringToDate("<c:out value="${appTomarrow}"/>", "<c:out value="${aoffn:config('format.date')}"/>")});
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/cdms/project/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsert;

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/project/edit.do"/>";
	
	setValidate();

	<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
		companyType["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
	</c:forEach>
	<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
		memberType["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
	</c:forEach>
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:과정명"/>",
		name : "projectName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발년도"/>",
		name : "year",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발구분"/>",
		name : "projectTypeCd",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:시작일"/>",
		name : "startDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		check : {
			gt : {name : "startDate", title : "<spring:message code="필드:CDMS:시작일"/>"}
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:차시수"/>",
		name : "moduleCount",
		data : ["!null", "number"],
		check : {
			maxlength : 2
		}
	});
	forInsert.validator.set(function() {
		var result = true;
		jQuery(".input-company").each(function() {
			var $this = jQuery(this);
			var $type = $this.find(":input[name='companyTypeCds']");
			var $seq = $this.find(":input[name='companySeqs']");
			if ($seq.val() == "") {
				result = false;
				$.alert({message : "<spring:message code="글:CDMS:X의Y를선택하십시오"/>".format({
						"0" : "<spring:message code="필드:CDMS:참여업체"/>", 
						"1" : companyType[$type.val()]
					})
				});
				return false; // each break;
			}
		});
		return result;
	});
	forInsert.validator.set(function() {
		var result = true;
		jQuery(".input-member").each(function() {
			var $this = jQuery(this);
			var $type = $this.find(":input[name='memberCdmsTypeCds']");
			var $seq = $this.find(":input[name='memberSeqs']");
			if ($seq.val() == "") {
				result = false;
				$.alert({message : "<spring:message code="글:CDMS:X의Y를선택하십시오"/>".format({
						"0" : "<spring:message code="필드:CDMS:참여인력"/>", 
						"1" : memberType[$type.val()]
					})
				});
				return false; // each break;
			}
		});
		return result;
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:개발그룹"/>",
		name : "projectGroupSeq",
		data : ["!null"]
	});

};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
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
 * 저장완료
 */
doCompleteInsert = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (parseInt(result.success, 10) >= 1) {
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doEdit({'projectSeq' : result.projectSeq});
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:저장되지않았습니다"/>"
		});
	}
};
/**
 * 참여업체 선택
 */
doBrowseCompany = function(element) {
	var $element = jQuery(element);
	$inputCompany = $element.siblings(".input-company");
	var $type = $inputCompany.find(":input[name='companyTypeCds']");
	
	FN.doOpenCompanyPopup({
		url : "<c:url value="/company/cdms/list/popup.do"/>", 
		title : "<spring:message code="필드:CDMS:참여업체"/> - " + companyType[$type.val()], 
		callback : "doSetCompany"
	});
};
/**
 * 참여업체 선택
 */
doSetCompany = function(returnValue) {
	if (returnValue != null) {
		var $seqs = $inputCompany.find(":input[name='companySeqs']");
		var seqs = $seqs.val().split(","); 
		if (jQuery.inArray(returnValue.companySeq, seqs) == -1) {
			var html = [];
			html.push("<li class='input-element' seq='" + returnValue.companySeq + "'>");
			html.push(returnValue.companyName);
			html.push("<a href='javascript:void(0)' onclick='doRemoveCompany(this)' title='<spring:message code="버튼:삭제"/>'></a>");
			html.push("</li>");
			$inputCompany.append(jQuery(html.join("")));
		} else {
			$.alert({message : "<spring:message code="글:CDMS:이미선택하였습니다"/>"});
		}
		var selected = [];
		$inputCompany.find(".input-element").each(function(){
			selected.push(jQuery(this).attr("seq"));
		});
		$seqs.val(selected.join(","));
	}
};
/**
 * 참여업체 삭제
 */
doRemoveCompany = function(element) {
	var $element = jQuery(element);
	var $inputBrowse = $element.closest(".input-company");
	var $seqs = $inputBrowse.find(":input[name='companySeqs']");
	var $parent = $element.closest(".input-element");
	var deleteSeq = $parent.attr("seq");
	$parent.remove();
	var selected = [];
	$inputBrowse.find(".input-element").each(function(){
		selected.push(jQuery(this).attr("seq"));
	});
	$seqs.val(selected.join(","));
	
	// 해당 참여인력 삭제
	jQuery(".input-member > .input-element").each(function(){
		var $this = jQuery(this);
		if (deleteSeq == $this.attr("company")) {
			$this.find("a").trigger("click");
		}
	});
};
/**
 * 참여인력 찾기
 */
doBrowseMember = function(element) {
	var $element = jQuery(element);
	$inputMember = $element.siblings(".input-member");
	var $type = $inputMember.find(":input[name='memberCdmsTypeCds']");
	
	var action = $.action("layer");
	action.config.formId = "FormParameters";
	action.config.url    = "<c:url value="/member/cdms/list/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 500;
	action.config.options.title  = "<spring:message code="필드:CDMS:참여인력"/> - " + memberType[$type.val()];

	var companies = [];
	jQuery(".input-company").each(function() {
		var $this = jQuery(this);
		var $seq = $this.find(":input[name='companySeqs']");
		companies = companies.concat($seq.val().split(","));
	});	
	companies = UT.uniqueArray(UT.removeEmptyArray(companies));
	if (companies.length == 0) {
		$.alert({message : "<spring:message code="글:CDMS:참여업체를선택하십시오"/>"});
		return;
	}

	var $form = jQuery("#" + action.config.formId);
	$form.find(":input").each(function() {
		jQuery(this).remove();
	});
	for (var index in companies) {
		$form.append(jQuery("<input type='hidden' name='srchInCompanySeqs' value='" + companies[index] +"'>"));
	}
	action.config.parameters = "callback=doSetMember&select=multiple";
	action.run();
};
/**
 * 참여인력 선택
 */
doSetMember = function(returnValue) {
	if (returnValue != null) {
		var $seqs = $inputMember.find(":input[name='memberSeqs']");
		var seqs = $seqs.val().split(","); 
		for (var index in returnValue) {
			if (jQuery.inArray(returnValue[index].memberSeq, seqs) == -1) {
				var html = [];
				html.push("<li class='input-element' seq='" + returnValue[index].memberSeq + "' company='" + returnValue[index].companySeq + "'>");
				html.push(returnValue[index].memberName + "(" + returnValue[index].memberId + ")");
				html.push("<a href='javascript:void(0)' onclick='doRemoveMember(this)'></a>");
				html.push("</li>");
				$inputMember.append(jQuery(html.join("")));
			}
		}
		var selected = [];
		$inputMember.find(".input-element").each(function(){
			selected.push(jQuery(this).attr("seq"));
		});
		$seqs.val(selected.join(","));
	}
};
/**
 * 참여인력 삭제
 */
doRemoveMember = function(element) {
	var $element = jQuery(element);
	var $inputBrowse = $element.closest(".input-member");
	var $seqs = $inputBrowse.find(":input[name='memberSeqs']");
	var $parent = $element.closest(".input-element");
	$parent.remove();
	var selected = [];
	$inputBrowse.find(".input-element").each(function(){
		selected.push(jQuery(this).attr("seq"));
	});
	$seqs.val(selected.join(","));
};
/**
 * 개발그룹 찾기
 */
doBrowseProjectGroup = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProjectGroup";
	action.config.url    = "<c:url value="/cdms/project/group/list/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 500;
	action.config.options.title  = "<spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/>";
	action.run();
};
/**
 * 개발그룹 선택
 */
doSetProjectGroup = function(returnValue) {
	if (returnValue != null) {
		doRemoveProjectGroup(); // 기존 등록된 것 삭제
		
		var $inputProjGroup = jQuery(".input-projectgroup");
		var html = [];
		html.push("<li class='input-element'>");
		html.push(returnValue.groupName);
		html.push("<a href='javascript:void(0)' onclick='doRemoveProjectGroup()'></a>");
		html.push("</li>");
		$inputProjGroup.append(jQuery(html.join("")));
		
		var $seq = $inputProjGroup.find(":input[name='projectGroupSeq']");
		$seq.val(returnValue.projectGroupSeq);
		
		jQuery("#buttonBrowseProjectGroup").hide();
	}
};
/**
 * 개발그룹삭제
 */
doRemoveProjectGroup = function() {
	var $inputProjGroup = jQuery(".input-projectgroup");
	$inputProjGroup.find(":input[name='projectGroupSeq']").val("");
	$inputProjGroup.find(".input-element").remove();
	jQuery("#buttonBrowseProjectGroup").show();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProject.jsp"/>
	</div>

	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="글:CDMS:기본정보설정"/></h4>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width:100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:과정명"/><span class="star">*</span></th>
			<td><input type="text" name="projectName" style="width:70%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발년도"/><span class="star">*</span></th>
			<td>
				<c:set var="startYear"><aof:date datetime="${today}" pattern="yyyy"/></c:set>
				<c:set var="iStartYear" value="${aoffn:toInt(startYear)}"/>
				<c:set var="yearList" value=""/>
				<c:forEach var="row" begin="${iStartYear - 1}" end="${iStartYear + 5}" step="1" varStatus="i">
					<c:if test="${i.first ne true}"><c:set var="yearList" value="${yearList},"/></c:if>
					<c:set var="yearList" value="${yearList}${row}=${row}"/>
				</c:forEach>
				<select name="year">
					<aof:code type="option" codeGroup="${yearList}" defaultSelected="${startYear}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발구분"/><span class="star">*</span></th>
			<td>
				<select name="projectTypeCd">
					<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발기간"/><span class="star">*</span></th>
			<td>
				<input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly"/>
				~
				<input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:차시수"/><span class="star">*</span></th>
			<td>
				<input type="text" name="moduleCount" style="width:40px;text-align:center;">
				<span style="margin-right:5px;"><spring:message code="글:CDMS:차시"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여업체"/><span class="star">*</span></th>
			<td>
				<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
					<div>
						<div class="vspace"></div>
						<a href="javascript:void(0)" onclick="doBrowseCompany(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>			
						<div class="vspace"></div>
						<ul class="input-company lybox-nobg name-box" style="width:300px;min-height:30px;">
							<input type="hidden" name="companyTypeCds" value="<c:out value="${row.code}"/>"/>
							<input type="hidden" name="companySeqs"/>
						</ul>
					</div>	
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여인력"/><span class="star">*</span></th>
			<td>
				<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
					<div>
						<div class="vspace"></div>
						<a href="javascript:void(0)" onclick="doBrowseMember(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
						<div class="vspace"></div>
						<ul class="input-member lybox-nobg name-box" style="width:300px;min-height:30px;">
							<input type="hidden" name="memberCdmsTypeCds" value="<c:out value="${row.code}"/>"/>
							<input type="hidden" name="memberSeqs"/>
						</ul>
					</div>	
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발그룹"/><span class="star">*</span></th>
			<td>
				<a href="javascript:void(0)" onclick="doBrowseProjectGroup()"
				   id="buttonBrowseProjectGroup"
				   class="btn gray"><span class="small"><spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
				<ul class="input-projectgroup name-box">
					<input type="hidden" name="projectGroupSeq">
				</ul>
			</td>
		</tr>
	</tbody>
	</table>
	
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>