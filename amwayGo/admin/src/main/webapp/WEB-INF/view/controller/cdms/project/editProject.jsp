<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_PM"       value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.PM')}"/>
<c:set var="CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM" value="${aoffn:code('CD.CDMS_PROJECT_GROUP_MEMBER_TYPE.PM')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>
<aof:code type="set" codeGroup="CDMS_OUTPUT" var="cdmsOutput"/>

<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<c:set var="projectStartedYn" value="N"/>
<c:if test="${appToday ge detailProject.project.startDate}"> <%-- 프로젝트 시작 후에는 수정할 수 없다. --%>
	<c:set var="projectStartedYn" value="Y"/>
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forDelete   = null;
var forUpdate   = null;
var forEdit     = null;
var forUpdateSection = null;
var companyType = {};
var memberType = {};
var $inputCompany = null;
var $inputMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.datepicker(".datepicker");
	
	doDisplayPlusDeleteIcon();

	doDisplaySaveButton();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/list.do"/>";
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/cdms/project/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forUpdate = $.action("submit", {formId : "FormUpdateProject"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/project/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:CDMS:적용하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before = function(result) {
		// 새로 추가된 참여업체 목록 만들기
		var $form = jQuery("#" + forUpdate.config.formId);
		$form.find(".input-company").each(function() {
			var $this = jQuery(this);
			var $companySeqs = $this.find(":input[name='companySeqs']");
			var $oldCompanySeqs = $this.find(":input[name='oldCompanySeqs']");
			if ($companySeqs.length > 0 && $oldCompanySeqs.length > 0) {
				var companySeqs = $companySeqs.val().split(",");
				var oldCompanySeqs = $oldCompanySeqs.val().split(",");
				for (var i in oldCompanySeqs) {
					companySeqs = UT.removeArray(companySeqs, oldCompanySeqs[i]);
				}
				companySeqs = UT.uniqueArray(UT.removeEmptyArray(companySeqs));
				$companySeqs.val(companySeqs.join(","));
			}
		});
		// 새로 추가된 참여인력 목록 만들기
		$form.find(".input-member").each(function() {
			var $this = jQuery(this);
			var $memberSeqs = $this.find(":input[name='memberSeqs']");
			var $oldMemberSeqs = $this.find(":input[name='oldMemberSeqs']");
			if ($memberSeqs.length > 0 && $oldMemberSeqs.length > 0) {
				var memberSeqs = $memberSeqs.val().split(",");
				var oldMemberSeqs = $oldMemberSeqs.val().split(",");
				for (var i in oldMemberSeqs) {
					memberSeqs = UT.removeArray(memberSeqs, oldMemberSeqs[i]);
				}
				memberSeqs = UT.uniqueArray(UT.removeEmptyArray(memberSeqs));
				$memberSeqs.val(memberSeqs.join(","));
			}
		});
		return true;
	};
	forUpdate.config.fn.complete = doCompleteUpdate;

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/project/edit.do"/>";
	
	forUpdateSection = $.action("submit", {formId : "FormUpdateSection"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdateSection.config.url             = "<c:url value="/cdms/section/update.do"/>";
	forUpdateSection.config.target          = "hiddenframe";
	forUpdateSection.config.message.confirm = "<spring:message code="글:CDMS:적용하시겠습니까"/>"; 
	forUpdateSection.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateSection.config.fn.before = function() {
		var $form = jQuery("#" + forUpdateSection.config.formId);
		$form.find("select[name='outputCds']").each(function() {
			var $this = jQuery(this);
			$this.siblings(":input[name='outputNames']").val(this.options[this.options.selectedIndex].text);
		});
		return true;
	};
	forUpdateSection.config.fn.complete = doCompleteUpdate;
	
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
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:과정명"/>",
		name : "projectName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발년도"/>",
		name : "year",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발구분"/>",
		name : "projectTypeCd",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:시작일"/>",
		name : "startDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발기간"/> <spring:message code="필드:CDMS:종료일"/>",
		name : "endDate",
		check : {
			gt : {name : "startDate", title : "<spring:message code="필드:CDMS:시작일"/>"}
		}
	});
	forUpdate.validator.set(function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		var $projectStartedYn = $form.find(":input[name='projectStartedYn']");
		var $oldEndDate = $form.find(":input[name='oldEndDate']");
		var $endDate = $form.find(":input[name='endDate']");
		if ($projectStartedYn.val() == "Y" && $oldEndDate.val() > $endDate.val()) {
			$.alert({message : "<spring:message code="글:CDMS:개발기간종료일의연장만가능합니다"/>"});
			return false;
		}
		return true;
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:차시수"/>",
		name : "moduleCount",
		data : ["!null", "number"],
		check : {
			maxlength : 2,
			ge : 1
		}
	});
	forUpdate.validator.set(function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		var result = true;
		$form.find(".input-company").each(function() {
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
	forUpdate.validator.set(function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		var result = true;
		$form.find(".input-member").each(function() {
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
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:개발그룹"/>",
		name : "projectGroupSeq",
		data : ["!null"]
	});

	forUpdateSection.validator.set({
		title : "<spring:message code="필드:CDMS:개발단계"/>",
		name : "sectionNames",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdateSection.validator.set({
		title : "<spring:message code="필드:CDMS:산출물"/>",
		name : "outputCds",
		data : ["!null"]
	});
	forUpdateSection.validator.set({
		title : "<spring:message code="필드:CDMS:마감일"/>",
		name : "endDates",
		data : ["!null"],
		check : {
			date : "<c:out value="${dateformat}"/>"
		}
	});
	forUpdateSection.validator.set(function() {
		var $form = jQuery("#" + forUpdateSection.config.formId);
		var projectStartDate = $form.find(":input[name='projectStartDate']").val();
		var projectEndDate = $form.find(":input[name='projectEndDate']").val();
		
		var invalidElement = null;
		$form.find(":input[name='endDates']").each(function() {
			if (projectStartDate > this.value || projectEndDate < this.value) {
				invalidElement = this;
				return false; // each break;
			}
		});
		if (invalidElement != null) {
			$.alert({
				message : "<spring:message code="글:CDMS:개발기간범위내에서선택하십시오"/>",
				button1 : {
					callback : function() {
						invalidElement.focus();
					}
				}
			});
			return false;
		}
		
		var prevDate = "";
		invalidElement = null;
		$form.find(":input[name='endDates']").each(function() {
			if (prevDate >= this.value) {
				invalidElement = this;
				return false; // each break;
			}
			prevDate = this.value;
		});
		if (invalidElement != null) {
			$.alert({
				message : "<spring:message code="글:CDMS:이전산출물의마감일이후로선택하십시오"/>",
				button1 : {
					callback : function() {
						invalidElement.focus();
					}
				}
			});
			return false;
		}
		return true;
	});

};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
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
 * 수정완료
 */
doCompleteUpdate = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (parseInt(result.success, 10) >= 1) {
		$.alert({
			message : "<spring:message code="글:CDMS:적용되었습니다"/>",
			button1 : {
				callback : function() {
					doEdit({'projectSeq' : result.projectSeq});
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:CDMS:오류가발생하여적용되지않았습니다"/>"
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
		
		// 삭제목록 정리.
		var $deleteSeqs = $inputCompany.find(":input[name='deleteCompanySeqs']");
		var deleted = $deleteSeqs.val().split(",");
		for (var i in selected) {
			deleted = UT.removeArray(deleted, selected[i]);
		}
		deleted = UT.uniqueArray(UT.removeEmptyArray(deleted));
		$deleteSeqs.val(deleted.join(","));
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
	var $deleteSeqs = $inputBrowse.find(":input[name='deleteCompanySeqs']");
	var deleteSeq = $parent.attr("seq");
	$parent.remove();
	var deleted = $deleteSeqs.val().split(",");
	deleted.push(deleteSeq);
	deleted = UT.uniqueArray(UT.removeEmptyArray(deleted));
	$deleteSeqs.val(deleted.join(","));
	var selected = [];
	$inputBrowse.find(".input-element").each(function(){
		selected.push(jQuery(this).attr("seq"));
	});
	$seqs.val(selected.join(","));
	
	// 참여업체에 포함되어 있지 않은 참여인력 삭제.
	var $form = jQuery("#" + forUpdate.config.formId);
	var companies = [];
	$form.find(".input-company > .input-element").each(function(){
		companies.push(jQuery(this).attr("seq"));
	});
	if (jQuery.inArray(deleteSeq, companies) == -1) {
		// 해당 참여인력 삭제
		$form.find(".input-member > .input-element").each(function(){
			var $this = jQuery(this);
			if (deleteSeq == $this.attr("company")) {
				$this.find("a").trigger("click");
			}
		});
	}
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

	var $form = jQuery("#" + forUpdate.config.formId);
	var companies = [];
	$form.find(".input-company").each(function() {
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

		// 삭제목록 정리.
		var $deleteSeqs = $inputMember.find(":input[name='deleteMemberSeqs']");
		var deleted = $deleteSeqs.val().split(",");
		for (var i in selected) {
			deleted = UT.removeArray(deleted, selected[i]);
		}
		deleted = UT.uniqueArray(UT.removeEmptyArray(deleted));
		$deleteSeqs.val(deleted.join(","));
	}
};
/**
 * 참여인력 삭제
 */
doRemoveMember = function(element) {
	var $element = jQuery(element);
	var $inputBrowse = $element.closest(".input-member");
	var $deleteSeqs = $inputBrowse.find(":input[name='deleteMemberSeqs']");
	var $seqs = $inputBrowse.find(":input[name='memberSeqs']");
	var $parent = $element.closest(".input-element");
	var deleteSeq = $parent.attr("seq");
	$parent.remove();
	var deleted = $deleteSeqs.val().split(",");
	deleted.push(deleteSeq);
	deleted = UT.uniqueArray(UT.removeEmptyArray(deleted));
	$deleteSeqs.val(deleted.join(","));
	
	var selected = [];
	$inputBrowse.find(".input-element").each(function(){
		selected.push(jQuery(this).attr("seq"));
	});
	$seqs.val(selected.join(","));
};
/**
 * 저장
 */
doUpdateSection = function() { 
	forUpdateSection.run();
};
/**
 * 추가, 삭제 icon 보이기/감추기 
 */
doDisplayPlusDeleteIcon = function() {
	var hide = {visibility : "hidden"};
	var show = {visibility : "visible"};
	var $form = jQuery("#" + forUpdateSection.config.formId);
	var $section = $form.find(".cdms-section");
	var $sectionIconDelete = $section.find(".icon-delete");
	var $sectionIconPlus = $section.find(".icon-plus");
	$sectionIconDelete.css(hide);
	$sectionIconPlus.css(hide);
	if ($section.length > 1) {
		$sectionIconDelete.filter(":last").css(show);
	}
	$sectionIconPlus.filter(":last").css(show);
	
	var $outputs = $form.find(".cdms-outputs");
	$outputs.each(function() {
		var $this = jQuery(this);
		var $output = $this.find(".cdms-output");
		var $outputIconDelete = $output.find(".icon-delete");
		var $outputIconPlus = $output.find(".icon-plus");
		$outputIconDelete.css(hide);
		$outputIconPlus.css(hide);
		if ($output.length > 1) {
			$outputIconDelete.filter(":last").css(show);
		}
		$outputIconPlus.filter(":last").css(show);
	});
};
/**
 * 개발단계/산출물 정보 적용 버튼 보이기/감추기 - 수정 가능한 항목이 있으면 보기기
 */
doDisplaySaveButton = function() {
	var count = 0;
	jQuery("#" + forUpdateSection.config.formId).find(":input[name='sectionEditableYns'], :input[name='outputEditableYns']").each(function() {
		if (this.value == "Y") {
			count++;
		}
	});
	if (count > 0) {
		jQuery("#buttonSectionSave").show();
	} else {
		jQuery("#buttonSectionSave").hide();
	}
};
/**
 * 개발단계 추가
 */
doPlusSection = function(element) {
	var $form = jQuery("#" + forUpdateSection.config.formId);
	var $sectionList = jQuery("#section-list");
	var action = $.action("ajax");
	action.config.type = "json";
	action.config.url  = "<c:url value="/cdms/section/insert.do"/>";
	action.config.asynchronous = false;
	action.config.parameters = "projectSeq=" + $form.find(":input[name='projectSeq']").val();
	action.config.fn.complete = function(action, data) {
		if (data != null) {
			var html = UT.formatString(doGetSectionTemplate(), {
				"sectionIndex" : data.detailSection.section.sectionIndex,
				"outputSectionIndex" : data.detailOutput.output.sectionIndex,
				"outputIndex" : data.detailOutput.output.outputIndex
			});
			$sectionList.append(jQuery(html));
			UI.datepicker(".datepicker");
			doDisplayPlusDeleteIcon();
		} else {
			$.alert({message : "<spring:message code="글:오류가발생하였습니다"/>"});
		}
	};
	action.run();
	
};
/**
 * 개발단계 삭제
 */
doDeleteSection = function(element) {
	var $form = jQuery("#" + forUpdateSection.config.formId);
	
	var $element = jQuery(element);
	var action = $.action("ajax");
	action.config.type = "json";
	action.config.url  = "<c:url value="/cdms/section/delete.do"/>";
	action.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>";
	action.config.asynchronous = false;
	
	var param = [];
	param.push("projectSeq=" + $form.find(":input[name='projectSeq']").val());
	param.push("sectionIndex=" + $element.siblings(":input[name='sectionIndexs']").val());
	action.config.parameters = param.join("&");
	action.config.fn.complete = function(action, data) {
		if (data != null && data.success >= 1) {
			$element.closest(".cdms-row").remove();
			doDisplayPlusDeleteIcon();
		} else {
			$.alert({message : "<spring:message code="글:오류가발생하였습니다"/>"});
		}
	};
	action.run();
};
/**
 * 개발단계 템플릿
 */
doGetSectionTemplate = function() {
	var html = [];
	html.push("<tr class='cdms-row'>");
	html.push("  <th class='cdms-section'>");
	html.push("    <input type='hidden' name='sectionIndexs' value='{sectionIndex}'/>");
	html.push("    <input type='hidden' name='sectionEditableYns' value='Y'/>");
	html.push("    <input type='text' name='sectionNames' class='input' style='width:80%;'/>");
	html.push("    <div class='icon-plus' onclick='doPlusSection(this)' style='visibility:hidden;' title='<spring:message code="버튼:추가"/>'></div>");
	html.push("    <div class='icon-delete' onclick='doDeleteSection(this)' style='visibility:hidden;' title='<spring:message code="버튼:삭제"/>'></div>");
	html.push("  </th>");
	html.push("  <td class='cdms-outputs' style='padding:0;'>");
	html.push(doGetOutputTemplate());
	html.push("  </td>");
	html.push("</tr>");
	return html.join("");
};
/**
 * 산출물 템플릿
 */
doGetOutputTemplate = function() {
	var html = [];
	html.push("<table>");
	html.push("<colgroup>");
	html.push("  <col style='width:200px;''/>");
	html.push("  <col style='width:100px;''/>");
	html.push("  <col style='width:50px;''/>");
	html.push("</colgroup>");
	html.push("<tbody>");
	html.push("<tr class='cdms-output'>");
	html.push("  <td class='align-c' style='border:none;'>");
	html.push("    <input type='hidden' name='outputSectionIndexs' value='{outputSectionIndex}'/>");
	html.push("    <input type='hidden' name='outputIndexs' value='{outputIndex}'/>");
	html.push("    <input type='hidden' name='outputEditableYns' value='Y'/>");
	html.push("    <select name='outputCds' class='select'>");
	html.push("      <option value=''></option>");
	html.push("      <aof:code type='option' codeGroup='CDMS_OUTPUT'/>");
	html.push("    </select>");
	html.push("    <input type='hidden' name='outputNames' value=''/>");
	html.push("    <div class='icon-plus' onclick='doPlusOutput(this)' style='visibility:hidden;' title='<spring:message code="버튼:추가"/>'></div>");
	html.push("    <div class='icon-delete' onclick='doDeleteOutput(this)' style='visibility:hidden;' title='<spring:message code="버튼:삭제"/>'></div>");
	html.push("  </td>");
	html.push("  <td class='align-c' style='border:none;'>");
	html.push("    <input type='text' name='endDates' class='datepicker' readonly='readonly'/>");
	html.push("  </td>");
	html.push("  <td class='align-c' style='border:none;'>");
	html.push("    <input type='hidden' name='moduleYns' value='N'/>");
	html.push("    <input type='checkbox' name='checks' value='Y' onclick='doClickModuleYn(this)'/>");
	html.push("  </td>");
	html.push("</tr>");
	html.push("</tbody>");
	html.push("</table>");
	return html.join("");
};
/**
 * 산출물 추가
 */
doPlusOutput = function(element) {
	var $element = jQuery(element);
	var $outputs = $element.closest(".cdms-outputs");
	var $form = jQuery("#" + forUpdateSection.config.formId);
	
	var action = $.action("ajax");
	action.config.type = "json";
	action.config.url  = "<c:url value="/cdms/output/insert/json.do"/>";
	action.config.asynchronous = false;
	var param = [];
	param.push("projectSeq=" + $form.find(":input[name='projectSeq']").val());
	param.push("sectionIndex=" + $element.siblings(":input[name='outputSectionIndexs']").val());
	action.config.parameters = param.join("&");
	action.config.fn.complete = function(action, data) {
		if (data != null) {
			var html = UT.formatString(doGetOutputTemplate(), {
				"outputSectionIndex" : data.detailOutput.output.sectionIndex,
				"outputIndex" : data.detailOutput.output.outputIndex
			});
			$outputs.append(jQuery(html));
			UI.datepicker(".datepicker");
			doDisplayPlusDeleteIcon();
		} else {
			$.alert({message : "<spring:message code="글:오류가발생하였습니다"/>"});
		}
	};
	action.run();
};
/**
 * 산출물 삭제
 */
doDeleteOutput = function(element) {
	var $form = jQuery("#" + forUpdateSection.config.formId);
	
	var $element = jQuery(element);
	var action = $.action("ajax");
	action.config.type = "json";
	action.config.url  = "<c:url value="/cdms/output/delete/json.do"/>";
	action.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>";
	action.config.asynchronous = false;

	var param = [];
	param.push("projectSeq=" + $form.find(":input[name='projectSeq']").val());
	param.push("sectionIndex=" + $element.siblings(":input[name='outputSectionIndexs']").val());
	param.push("outputIndex=" + $element.siblings(":input[name='outputIndexs']").val());
	action.config.parameters = param.join("&");
	action.config.fn.complete = function(action, data) {
		if (data != null && data.success >= 1) {
			$element.closest(".cdms-output").remove();
			doDisplayPlusDeleteIcon();
		} else {
			$.alert({message : "<spring:message code="글:오류가발생하였습니다"/>"});
		}
	};
	action.run();
};
/**
 * 담당자조회
 */
doEditCharge = function() {
	var action = $.action("layer");
	action.config.formId = "FormCharge";
	action.config.url    = "<c:url value="/cdms/charge/edit/popup.do"/>";
	action.config.options.width  = 900;
	action.config.options.height = 650;
	action.config.options.title  = "<spring:message code="글:CDMS:담당자상세설정"/>";
	action.run();
};
/**
 * 차시적용여부 
 */
doClickModuleYn = function(element) {
	var $element = jQuery(element);
	$element.siblings(":input[name='moduleYns']").val(element.checked ? "Y" : "N");
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
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProject.jsp"/>
		<form name="FormCharge" id="FormCharge" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
		</form>
		<form name="FormDelete" id="FormDelete" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
		</form>
	</div>

	<c:set var="pmYn" value="N"/>
	<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
		<c:if test="${ssMemberSeq eq rowSub.member.memberSeq and rowSub.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_PM}">
			<c:set var="pmYn" value="Y"/>
		</c:if>	
	</c:forEach>
	<%-- 총괄PM --%>
	<c:forEach var="rowSub" items="${listProjectGroupMember}" varStatus="iSub">
		<c:if test="${ssMemberSeq eq rowSub.member.memberSeq and rowSub.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM}">
			<c:set var="pmYn" value="Y"/>
		</c:if>	
	</c:forEach>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailProject.project.projectName}"/></h4>
		<div class="right">
			<%-- 프로젝트가 종료상태가 아닐때, pm 이거나 생성자이면 수정가능 --%>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')
				and detailProject.project.completeYn ne 'Y' and (ssMemberSeq eq detailProject.project.regMemberSeq or pmYn eq 'Y')}">
				<a href="javascript:void(0)" onclick="doEditCharge();" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:담당자설정"/></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<table class="tbl-layout">
	<colgroup>
		<col style="width:45%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<div class="lybox-title mt10">
					<h4 class="section-title"><spring:message code="글:CDMS:기본정보"/></h4>
				</div>
			
				<form id="FormUpdateProject" name="FormUpdateProject" method="post" onsubmit="return false;">
				<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
				<input type="hidden" name="projectStartedYn" value="<c:out value="${projectStartedYn}"/>"/>
				<table class="tbl-detail">
				<colgroup>
					<col style="width:100px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:CDMS:과정명"/></th>
						<td><input type="text" name="projectName" style="width:90%;" value="<c:out value="${detailProject.project.projectName}"/>"></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발년도"/></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N'}">
									<c:set var="startYear"><aof:date datetime="${today}" pattern="yyyy"/></c:set>
									<c:set var="iStartYear" value="${aoffn:toInt(startYear)}"/>
									<c:set var="yearList" value=""/>
									<c:forEach var="row" begin="${iStartYear - 1}" end="${iStartYear + 5}" step="1" varStatus="i">
										<c:if test="${i.first ne true}"><c:set var="yearList" value="${yearList},"/></c:if>
										<c:set var="yearList" value="${yearList}${row}=${row}"/>
									</c:forEach>
									<select name="year">
										<aof:code type="option" codeGroup="${yearList}" selected="${detailProject.project.year}"/>
									</select>
								</c:when>
								<c:otherwise>
									<c:out value="${detailProject.project.year}"/>&nbsp;<spring:message code="글:년"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발구분"/></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N'}">
									<select name="projectTypeCd">
										<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE" selected="${detailProject.project.projectTypeCd}"/>
									</select>
								</c:when>
								<c:otherwise>
									<aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${detailProject.project.projectTypeCd}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발기간"/></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N'}">
									<input type="text" name="startDate" value="<aof:date datetime="${detailProject.project.startDate}"/>" class="datepicker" readonly="readonly"/>
									~
									<input type="text" name="endDate" value="<aof:date datetime="${detailProject.project.endDate}"/>" class="datepicker" readonly="readonly"/>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${detailProject.project.completeYn ne 'Y'}">
											<input type="text" name="startDate" value="<aof:date datetime="${detailProject.project.startDate}"/>" style="width:70px; text-align:center; padding:0px;" readonly="readonly"/>
											~
											<input type="text" name="endDate" value="<aof:date datetime="${detailProject.project.endDate}"/>" class="datepicker" readonly="readonly"/>
											<span class="comment"><spring:message code="글:CDMS:개발기간종료일의연장만가능합니다"/></span>
											<input type="hidden" name="oldEndDate" value="<aof:date datetime="${detailProject.project.endDate}"/>"/>
										</c:when>
										<c:otherwise>
											<aof:date datetime="${detailProject.project.startDate}"/> ~ <aof:date datetime="${detailProject.project.endDate}"/>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:차시수"/></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N'}">
									<input type="hidden" name="oldModuleCount" value="<c:out value="${detailProject.project.moduleCount}"/>">
									<input type="text" name="moduleCount" value="<c:out value="${detailProject.project.moduleCount}"/>" style="width:40px;text-align:center;">
									<span style="margin-right:5px;"><spring:message code="글:CDMS:차시"/></span>
									<div class="vspace"></div>
									<div class="comment"><spring:message code="글:CDMS:차시수를수정하면산출물의차시정보가초기화됩니다"/></div>
								</c:when>
								<c:otherwise>
									<c:out value="${detailProject.project.moduleCount}"/><span style="margin:0 5px;"><spring:message code="글:CDMS:차시"/></span>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:참여업체"/><span class="star">*</span></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N'}">
									<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
										<c:set var="companySeqs" value=""/>
										<div>
											<div class="vspace"></div>
											<a href="javascript:void(0)" onclick="doBrowseCompany(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
											<div class="vspace"></div>
											<ul class="input-company lybox-nobg name-box" style="width:300px;min-height:30px;">
												<c:forEach var="rowSub" items="${listProjectCompany}" varStatus="iSub">
													<c:if test="${row.code eq rowSub.projectCompany.companyTypeCd}">
														<li class="input-element" seq="<c:out value="${rowSub.company.companySeq}"/>">
															<c:out value="${rowSub.company.companyName}"/>
															<a href="javascript:void(0)" onclick="doRemoveCompany(this)" title="<spring:message code="버튼:삭제"/>"></a>
														</li>
														<c:if test="${!empty companySeqs}">
															<c:set var="companySeqs" value="${companySeqs},"/>
														</c:if>
														<c:set var="companySeqs" value="${companySeqs}${rowSub.company.companySeq}"/>
													</c:if>
												</c:forEach>
												<input type="hidden" name="companyTypeCds" value="<c:out value="${row.code}"/>"/>
												<input type="hidden" name="companySeqs" value="<c:out value="${companySeqs}"/>"/>
												<input type="hidden" name="oldCompanySeqs" value="<c:out value="${companySeqs}"/>"/>
												<input type="hidden" name="deleteCompanySeqs"/>
											</ul>
										</div>	
									</c:forEach>
									<div class="vspace"></div>
									<div class="clear comment"><spring:message code="글:CDMS:참여업체를삭제하면해당업체의참여인력도삭제됩니다"/></div>
								</c:when>
								<c:otherwise>
									<c:set var="companySeqs" value=""/>
									<c:forEach var="rowSub" items="${listProjectCompany}" varStatus="iSub">
										<c:if test="${!empty companySeqs}">
											<c:set var="companySeqs" value="${companySeqs},"/>
										</c:if>
										<c:set var="companySeqs" value="${companySeqs}${rowSub.company.companySeq}"/>
									</c:forEach>
									<div class="input-company" style="display:none;">
										<input type="hidden" name="companySeqs" value="<c:out value="${companySeqs}"/>"/>
									</div>
									
									<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
										<div class="clear strong"><c:out value="${row.codeName}"/> : </div>
										<ul class="list-bullet">
											<c:forEach var="rowSub" items="${listProjectCompany}" varStatus="iSub">
												<c:if test="${row.code eq rowSub.projectCompany.companyTypeCd}">
													<li><c:out value="${rowSub.company.companyName}"/></li>
												</c:if>
											</c:forEach>
										</ul>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:참여인력"/><span class="star">*</span></th>
						<td>
							<c:choose>
								<c:when test="${projectStartedYn eq 'N' or detailProject.project.completeYn ne 'Y'}">
									<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
										<c:set var="memberSeqs" value=""/>
										<div>
											<div class="vspace"></div>
											<a href="javascript:void(0)" onclick="doBrowseMember(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
											<div class="vspace"></div>
											<ul class="input-member lybox-nobg name-box" style="width:300px;min-height:30px;">
												<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
													<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
														<li class="input-element" seq="<c:out value="${rowSub.member.memberSeq}"/>" company="<c:out value="${rowSub.companyMember.companySeq}"/>">
															<c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)
															<c:if test="${projectStartedYn eq 'N'}">
																<a href="javascript:void(0)" onclick="doRemoveMember(this)" title="<spring:message code="버튼:삭제"/>"></a>
															</c:if>
														</li>
														<c:if test="${!empty memberSeqs}">
															<c:set var="memberSeqs" value="${memberSeqs},"/>
														</c:if>
														<c:set var="memberSeqs" value="${memberSeqs}${rowSub.member.memberSeq}"/>
													</c:if>
												</c:forEach>
												<input type="hidden" name="memberCdmsTypeCds" value="<c:out value="${row.code}"/>"/>
												<input type="hidden" name="memberSeqs" value="<c:out value="${memberSeqs}"/>"/>
												<input type="hidden" name="oldMemberSeqs" value="<c:out value="${memberSeqs}"/>"/>
												<input type="hidden" name="deleteMemberSeqs" value=""/>
											</ul>
										</div>	
									</c:forEach>
									<c:if test="${projectStartedYn eq 'N'}">
										<div class="vspace"></div>
										<div class="clear comment"><spring:message code="글:CDMS:참여인력을삭제하면산출물의담당자정보에서도삭제됩니다"/></div>
									</c:if>
								</c:when>
								<c:otherwise>
									<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
										<div class="clear strong"><c:out value="${row.codeName}"/> : </div>
										<ul class="list-bullet">
											<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
												<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
													<li><c:out value="${rowSub.member.memberName}"/></li>
												</c:if>
											</c:forEach>
										</ul>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발그룹"/><span class="star">*</span></th>
						<td>
							<a href="javascript:void(0)" onclick="doBrowseProjectGroup()"
							   id="buttonBrowseProjectGroup"
							   <c:if test="${!empty detailProject.project.projectGroupSeq}">style="display:none;"</c:if>
							   class="btn gray"><span class="small"><spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
							<ul class="input-projectgroup name-box">
								<input type="hidden" name="projectGroupSeq" value="<c:out value="${detailProject.project.projectGroupSeq}"/>">
								<c:if test="${!empty detailProject.project.projectGroupSeq}">
									<li class="input-element"><c:out value="${detailProject.projectGroup.groupName}"/><a href="javascript:void(0)" onclick="doRemoveProjectGroup()"></a></li>
								</c:if>
							</ul>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:종료여부"/></th>
						<td><aof:code name="completeYn" type="radio" codeGroup="YESNO" selected="${detailProject.project.completeYn}" removeCodePrefix="true"/></td>
					</tr>
				</tbody>
				</table>
				</form>
				
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<%-- pm 이거나 생성자이면 삭제가능, 프로젝트가 시작되기전.--%>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and projectStartedYn eq 'N' and (ssMemberSeq eq detailProject.project.regMemberSeq or pmYn eq 'Y')}">
							<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
						</c:if>
					</div>
					<div class="lybox-btn-r">
						<%-- pm 이거나 생성자이면 수정가능 --%>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and (ssMemberSeq eq detailProject.project.regMemberSeq or pmYn eq 'Y')}">
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:적용"/></span></a>
						</c:if>
					</div>
				</div>
				
			</td>
			<td>
				<div class="lybox-title mt10">
					<h4 class="section-title"><spring:message code="글:CDMS:개발단계및산출물정보"/></h4>
				</div>
			
				<form id="FormUpdateSection" name="FormUpdateSection" method="post" onsubmit="return false;">
				<input type="hidden" name="projectSeq"       value="<c:out value="${detailProject.project.projectSeq}"/>"/>
				<input type="hidden" name="projectStartDate" value="<aof:date datetime="${detailProject.project.startDate}"/>"/>
				<input type="hidden" name="projectEndDate"   value="<aof:date datetime="${detailProject.project.endDate}"/>"/>
				
				<table class="tbl-detail">
				<colgroup>
					<col style="width:auto;"/>
					<col style="width:200px;"/>
					<col style="width:100px;"/>
					<col style="width:50px;"/>
				</colgroup>
				<thead>
				<tr>
					<th class="align-c"><spring:message code="필드:CDMS:개발단계"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:산출물"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:마감일"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:차시"/></th>
				</tr>
				</thead>
				<c:if test="${empty listSection}">
					<tbody>
					<tr>
						<td class="align-c" colspan="4"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
					</tbody>
				</c:if>
				</table>
				
				<table id="section-list" class="tbl-detail" style="border-top:none;">
				<colgroup>
					<col style="width:auto;"/>
					<col style="width:350px;"/>
				</colgroup>
				<tbody>
				<c:forEach var="row" items="${listSection}" varStatus="i">
					<tr class="cdms-row">
						<th class="cdms-section vtop">
							<div>
								<input type="hidden" name="sectionIndexs" value="<c:out value="${row.section.sectionIndex}"/>"/>
								<input type="hidden" name="sectionEditableYns" value="<c:out value="${row.section.sectionEditableYn}"/>"/>
								
								<c:choose>
									<c:when test="${detailProject.project.completeYn ne 'Y' and row.section.sectionEditableYn eq 'Y'}">
										<input type="text" name="sectionNames" value="<c:out value="${row.section.sectionName}"/>" style="width:80%;"/>
										<div class="icon-plus" onclick="doPlusSection(this)" style="visibility:hidden;" title="<spring:message code="버튼:추가"/>"></div>
										<div class="icon-delete" onclick="doDeleteSection(this)" style="visibility:hidden;" title="<spring:message code="버튼:삭제"/>"></div>
									</c:when>
									<c:otherwise>
										<input type="hidden" name="sectionNames" value="<c:out value="${row.section.sectionName}"/>"/>
										<c:out value="${row.section.sectionName}"/>
									</c:otherwise>
								</c:choose>
							</div>
						</th>
						<td class="cdms-outputs" style="padding:0;">
						<c:forEach var="rowSub" items="${listOutput}" varStatus="iSub">
							<c:if test="${row.section.sectionIndex eq rowSub.output.sectionIndex}">
								<table>
								<colgroup>
									<col style="width:200px;"/>
									<col style="width:100px;"/>
									<col style="width:50px;"/>
								</colgroup>
								<tbody>
								<tr class="cdms-output">
								<c:choose>
									<c:when test="${detailProject.project.completeYn ne 'Y' and rowSub.output.outputEditableYn eq 'Y'}">
										<td class="align-c" style="border:none;">
											<input type="hidden" name="outputSectionIndexs" value="<c:out value="${rowSub.output.sectionIndex}"/>"/>
											<input type="hidden" name="outputIndexs" value="<c:out value="${rowSub.output.outputIndex}"/>"/>
											<input type="hidden" name="outputEditableYns" value="<c:out value="${rowSub.output.outputEditableYn}"/>"/>
											<select name="outputCds" class="select">
												<option value=""></option>
												<aof:code type="option" codeGroup="CDMS_OUTPUT" selected="${rowSub.output.outputCd}"/>
											</select>
											<input type="hidden" name="outputNames" value="<c:out value="${rowSub.output.outputName}"/>"/>
											<div class="icon-plus" onclick="doPlusOutput(this)" style="visibility:hidden;" title="<spring:message code="버튼:추가"/>"></div>
											<div class="icon-delete" onclick="doDeleteOutput(this)" style="visibility:hidden;" title="<spring:message code="버튼:삭제"/>"></div>
										</td>
										<td class="align-c" style="border:none;">
											<input type="text" name="endDates" value="<aof:date datetime="${rowSub.output.endDate}"/>" class="datepicker" readonly="readonly"/>
										</td>
										<td class="align-c" style="border:none;">
											<input type="hidden" name="moduleYns" value="<c:out value="${rowSub.output.moduleYn}"/>"/>
											<input type="checkbox" name="checks" value="Y" <c:out value="${rowSub.output.moduleYn eq 'Y' ? 'checked' : ''}"/> onclick="doClickModuleYn(this)"/>
										</td>
									</c:when>
									<c:otherwise>
										<td class="align-c" style="border:none;">
											<input type="hidden" name="outputSectionIndexs" value="<c:out value="${rowSub.output.sectionIndex}"/>"/>
											<input type="hidden" name="outputIndexs" value="<c:out value="${rowSub.output.outputIndex}"/>"/>
											<input type="hidden" name="outputEditableYns" value="<c:out value="${rowSub.output.outputEditableYn}"/>"/>
											<input type="hidden" name="outputCds" value="<c:out value="${rowSub.output.outputCd}"/>"/>
											<input type="hidden" name="outputNames" value="<c:out value="${rowSub.output.outputName}"/>"/>
											<c:out value="${rowSub.output.outputName}"/>
										</td>
										<td class="align-c" style="border:none;">
											<input type="hidden" name="endDates" value="<aof:date datetime="${rowSub.output.endDate}"/>"/>
											<aof:date datetime="${rowSub.output.endDate}"/>
										</td>
										<td class="align-c" style="border:none;">
											<input type="hidden" name="moduleYns" value="<c:out value="${rowSub.output.moduleYn}"/>"/>
											<input type="checkbox" name="checks" value="Y" style="display:none;"/>
											<c:if test="${rowSub.output.moduleYn eq 'Y'}">
												<div class="icon-check" title="<spring:message code="필드:CDMS:차시"/>"></div>		
											</c:if>
										</td>
									</c:otherwise>
								</c:choose>
								</tr>
								</tbody>
								</table>
							</c:if>
						</c:forEach>
						</td>
					</tr>
				</c:forEach>
				</tbody>
				</table>

				</form>
	
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<%-- 프로젝트가 종료상태가 아닐때, pm 이거나 생성자이면 수정가능 --%>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')
							and detailProject.project.completeYn ne 'Y' and (ssMemberSeq eq detailProject.project.regMemberSeq or pmYn eq 'Y')}">
							<a href="javascript:void(0)" onclick="doUpdateSection();" class="btn blue" id="buttonSectionSave" style="display:none"><span class="mid"><spring:message code="버튼:CDMS:적용"/></span></a>
						</c:if>
					</div>
				</div>
	
			</td>
		</tr>
		</table>
	</div>
</body>
</html>