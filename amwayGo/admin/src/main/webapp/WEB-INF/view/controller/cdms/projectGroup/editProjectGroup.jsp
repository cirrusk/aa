<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_MEMBER_TYPE" var="cdmsMemberType"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var forDuplicate = null;
var companyType = {};
var memberType = {};
var $inputCompany = null;
var $inputMember = null;
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
	forListdata.config.url    = "<c:url value="/cdms/project/group/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/project/group/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
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
	}
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/cdms/project/group/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forDuplicate = $.action("ajax", {formId : "FormDuplicate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDuplicate.config.type        = "json";
	forDuplicate.config.url         = "<c:url value="/cdms/project/group/duplicate/json.do"/>";
	forDuplicate.config.fn.complete = function(action, data) {
		var form = UT.getById(forUpdate.config.formId);
		if (data.duplicated == true) {
			form.elements["duplicatedGroupName"].value = "Y";
			$.alert({
				message : "<spring:message code="글:CDMS:이미사용중인개발그룹명입니다"/>"
			});
		} else {
			form.elements["duplicatedGroupName"].value = "N";
			$.alert({
				message : "<spring:message code="글:CDMS:사용가능한개발그룹명입니다"/>" 
			});
		}
	};

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
		title : "<spring:message code="필드:CDMS:개발그룹명"/>",
		name : "groupName",
		data : ["!null"],
		check : {
			maxlength : 100
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
		message : "<spring:message code="글:CDMS:개발그룹명중복검사를실시하십시오"/>",
		name : "duplicatedGroupName",
		check : {
			eq : "N"
		}
	});
	forDuplicate.validator.set({
		title : "<spring:message code="필드:CDMS:개발그룹명"/>",
		name : "groupName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 개발그룹명 중복검사
 */
doCheckDuplicate = function() {
	var formUpdate = UT.getById(forUpdate.config.formId);	
	var formDuplicate = UT.getById(forDuplicate.config.formId);	
	formDuplicate.elements["groupName"].value = formUpdate.elements["groupName"].value;
	
	forDuplicate.run();	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
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
 * 그룹명 변경
 */
doChangeGroupName = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["duplicatedGroupName"].value = "Y";
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProjectGroup.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="projectGroupSeq" value="<c:out value="${detail.projectGroup.projectGroupSeq}"/>">
	<input type="hidden" name="duplicatedGroupName" value="N">
	<table class="tbl-detail">
	<colgroup>
		<col style="width:100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:개발그룹명"/><span class="star">*</span></th>
			<td>
				<input type="text" name="groupName" style="width:420px;" value="<c:out value="${detail.projectGroup.groupName}"/>" onchange="doChangeGroupName()">
				<a href="javascript:void(0)" onclick="doCheckDuplicate()" class="btn gray"><span class="small"><spring:message code="버튼:중복검사"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여업체"/><span class="star">*</span></th>
			<td>
				<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
					<c:set var="companySeqs" value=""/>
					<div>
						<div class="vspace"></div>
						<a href="javascript:void(0)" onclick="doBrowseCompany(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
						<div class="vspace"></div>
						<ul class="input-company lybox-nobg name-box" style="width:300px;min-height:30px;">
							<c:forEach var="rowSub" items="${detail.listCompany}" varStatus="iSub">
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
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여인력"/><span class="star">*</span></th>
			<td>
				<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
					<c:set var="memberSeqs" value=""/>
					<div>
						<div class="vspace"></div>
						<a href="javascript:void(0)" onclick="doBrowseMember(this)" class="btn gray"><span class="small"><c:out value="${row.codeName}"/>&nbsp;<spring:message code="버튼:선택"/></span></a>
						<div class="vspace"></div>
						<ul class="input-member lybox-nobg name-box" style="width:300px;min-height:30px;">
							<c:forEach var="rowSub" items="${detail.listMember}" varStatus="iSub">
								<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
									<li class="input-element" seq="<c:out value="${rowSub.member.memberSeq}"/>" company="<c:out value="${rowSub.companyMember.companySeq}"/>">
										<c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)
										<a href="javascript:void(0)" onclick="doRemoveMember(this)" title="<spring:message code="버튼:삭제"/>"></a>
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
			</td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="projectGroupSeq" value="<c:out value="${detail.projectGroup.projectGroupSeq}"/>">
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>