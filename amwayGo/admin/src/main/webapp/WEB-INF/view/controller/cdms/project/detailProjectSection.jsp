<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CDMS_OUTPUT_STATUS_REQUEST"        value="${aoffn:code('CD.CDMS_OUTPUT_STATUS.REQUEST')}"/>
<c:set var="CD_CDMS_OUTPUT_STATUS_REJECT"         value="${aoffn:code('CD.CDMS_OUTPUT_STATUS.REJECT')}"/>
<c:set var="CD_CDMS_OUTPUT_STATUS_ACCEPT"         value="${aoffn:code('CD.CDMS_OUTPUT_STATUS.ACCEPT')}"/>
<c:set var="CD_CDMS_PROJECT_COMPANY_TYPE"         value="${aoffn:code('CD.CDMS_PROJECT_COMPANY_TYPE')}"/>
<c:set var="CD_CDMS_PROJECT_COMPANY_TYPE_ADDSEP"  value="${CD_CDMS_PROJECT_COMPANY_TYPE}::"/>
<c:set var="CD_CDMS_PROJECT_COMPANY_TYPE_ORDER"   value="${aoffn:code('CD.CDMS_PROJECT_COMPANY_TYPE.ORDER')}"/>
<c:set var="CD_CDMS_PROJECT_COMPANY_TYPE_DEVELOP" value="${aoffn:code('CD.CDMS_PROJECT_COMPANY_TYPE.DEVELOP')}"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_DEVELOP"  value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.DEVELOP')}"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_CONFIRM"  value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.CONFIRM')}"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_PM"       value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.PM')}"/>
<c:set var="CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM" value="${aoffn:code('CD.CDMS_PROJECT_GROUP_MEMBER_TYPE.PM')}"/>

<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>
<aof:code type="set" codeGroup="CDMS_OUTPUT_STATUS" var="cdmsStatus"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CDMS_OUTPUT_STATUS_REQUEST = "<c:out value="${CD_CDMS_OUTPUT_STATUS_REQUEST}"/>";
var CD_CDMS_OUTPUT_STATUS_REJECT = "<c:out value="${CD_CDMS_OUTPUT_STATUS_REJECT}"/>";
var CD_CDMS_OUTPUT_STATUS_ACCEPT = "<c:out value="${CD_CDMS_OUTPUT_STATUS_ACCEPT}"/>";

var forListdata = null;
var forDetail = null;
var forDetailSection = null;
var forListComment = null;
var forInsertComment = null;
var forDeleteComment = null;
var forUpdateOutputStatus = null;
var forUpdateModuleStatus = null;
var cdmsStatus = {};
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doListComment();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/list.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/project/detail.do"/>";

	forDetailSection = $.action();
	forDetailSection.config.formId = "FormDetailSection";
	forDetailSection.config.url    = "<c:url value="/cdms/project/section/detail.do"/>";

	forUpdateOutputStatus = $.action("submit", {formId : "FormUpdateOutputStatus"});
	forUpdateOutputStatus.config.url             = "<c:url value="/cdms/output/status/update.do"/>";
	forUpdateOutputStatus.config.target          = "hiddenframe";
	forUpdateOutputStatus.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateOutputStatus.config.fn.complete     = function() {
		doDetailSection();
	};
	
	forUpdateModuleStatus = $.action("submit", {formId : "FormUpdateModuleStatus"});
	forUpdateModuleStatus.config.url             = "<c:url value="/cdms/module/status/update.do"/>";
	forUpdateModuleStatus.config.target          = "hiddenframe";
	forUpdateModuleStatus.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateModuleStatus.config.fn.complete     = function() {
		doDetailSection();
	};
	
	forListComment = $.action("ajax");
	forListComment.config.formId = "FormSrchComment";
	forListComment.config.url    = "<c:url value="/cdms/comment/list.do"/>";
	forListComment.config.type   = "html";
	forListComment.config.containerId = "containerComment"; 
	forListComment.config.fn.complete = function(action, data) {
		doInitializeComment();
	};
	
	<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
	cdmsStatus["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
	</c:forEach>
};
/**
 * 목록보기
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
 * 상세보기 화면을 호출하는 함수
 */
doDetailSection = function(mapPKs) {
	if (typeof mapPKs === "object") {
		// 상세화면 form을 reset한다.
		UT.getById(forDetailSection.config.formId).reset();
		// 상세화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forDetailSection.config.formId);
	}
	// 상세화면 실행
	forDetailSection.run();
};
/**
 * 산출물 선택 변경
 */
doChangeOutput = function(element) {
	var form = UT.getById(forDetailSection.config.formId);
	form.elements["outputIndex"].value = element.value;
	
	doDetailSection();
};
/**
 * 산출물 상태 변경
 */
doUpdateOutputStatus = function(outputStatusCd) {
	var status = cdmsStatus[outputStatusCd];
	forUpdateOutputStatus.config.message.confirm = "<spring:message code="글:CDMS:X하시겠습니까"/>".format({0 : status});

	var form = UT.getById(forUpdateOutputStatus.config.formId);
	form.elements["autoDescription"].value = form.elements["message"].value.format({0 : status});
	form.elements["outputStatusCd"].value = outputStatusCd;
	forUpdateOutputStatus.run();
};
/**
 * 모듈 상태 변경
 */
doUpdateModuleStatus = function(outputStatusCd) {
	var status = cdmsStatus[outputStatusCd];
	forUpdateModuleStatus.config.message.confirm = "<spring:message code="글:CDMS:X하시겠습니까"/>".format({0 : status});
	forUpdateModuleStatus.validator = new jQuery.validator(forUpdateModuleStatus.config.formId);
	forUpdateModuleStatus.validator.set(function() {
		var $form = jQuery("#" + forUpdateModuleStatus.config.formId);
		$form.find(":input[name='outputStatusCd']").val(outputStatusCd);
		var $message = $form.find(":input[name='message']");
		var $check = $form.find(":input[name='checkkeys']");
		$check.each(function(index) {
			var $this = jQuery(this);
			$this.val(index);
			$this.siblings(":input[name='autoDescriptions']").val(
				$message.val().format({
					0: $this.siblings(":input[name='moduleIndexs']").val(), 
					1: status
				})
			);
			if (outputStatusCd == CD_CDMS_OUTPUT_STATUS_REQUEST) {
				if ($this.hasClass("cdms-confirm")) {
					this.checked = false;
				}
			} else if (outputStatusCd == CD_CDMS_OUTPUT_STATUS_REJECT || outputStatusCd == CD_CDMS_OUTPUT_STATUS_ACCEPT) {
				if ($this.hasClass("cdms-develop")) {
					this.checked = false;
				}
			}
		});
		if ($check.filter(":checked").length == 0) {
			$.alert({message : "<spring:message code="글:CDMS:X처리할데이터를선택하십시오"/>".format({0 : status})});			
			return false;
		}
		return true;
	});
	forUpdateModuleStatus.run();
};
/**
 * 댓글 초기화
 */
doInitializeComment = function() {
	forInsertComment = $.action("submit", {formId : "FormInsertComment"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsertComment.config.url             = "<c:url value="/cdms/comment/insert.do"/>";
	forInsertComment.config.target          = "hiddenframe";
	forInsertComment.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsertComment.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsertComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertComment.config.fn.complete     = function() {
		doListComment();
	};
	forInsertComment.validator.set({
		title : "<spring:message code="필드:CDMS:내용"/>",
		name : "description",
		data : ["!null"],
		check : {
			maxlength : 1000
		}
	});
	
	forDeleteComment = $.action("ajax");
	forDeleteComment.config.formId = "FormDeleteComment";
	forDeleteComment.config.url    = "<c:url value="/cdms/comment/delete.do"/>";
	forDeleteComment.config.type   = "json";
	forDeleteComment.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeleteComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeleteComment.config.fn.complete = function(action, data) {
		if (data.success === true) {
			doListComment();
		} else {
			$.alert({message : "<spring:message code="글:오류가발생하였습니다"/>"});
			return;
		}
	};
	
};
/**
 * 댓글 목록 가져오기
 */
doListComment = function() {
	forListComment.run();
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPageComment = function(pageno) {
	var form = UT.getById(forListComment.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doListComment();
};
/**
 * 저장
 */
doInsertComment = function() {
	forInsertComment.run();
};
/**
 * 삭제
 */
doDeleteComment = function(mapPKs) {
	UT.getById(forDeleteComment.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDeleteComment.config.formId);
	forDeleteComment.run();
};
/**
 * 파일 상세 화면
 */
doDetailFileOutput = function(moduleIndex) {
	var action = $.action("layer");
	action.config.formId = "FormOutputFile";
	action.config.url    = "<c:url value="/cdms/output/file/detail/popup.do"/>";
	action.config.options.width  = 600;
	action.config.options.height = 600;
	action.config.options.title  = "<spring:message code="필드:CDMS:파일"/>";
	
	var form = UT.getById(action.config.formId);
	if (typeof moduleIndex === "string") {
		form.elements["moduleIndex"].value = moduleIndex;	
	} else {
		form.elements["moduleIndex"].value = "";
	}

	action.run();
};
/**
 * 파일 등록/수정/삭제 화면
 */
doEditFileOutput = function(moduleIndex) {
	var action = $.action("layer");
	action.config.formId = "FormOutputFile";
	action.config.url    = "<c:url value="/cdms/output/file/edit/popup.do"/>";
	action.config.options.width  = 600;
	action.config.options.height = 600;
	action.config.options.title  = "<spring:message code="필드:CDMS:파일"/>";
	
	var form = UT.getById(action.config.formId);
	if (typeof moduleIndex === "string") {
		form.elements["moduleIndex"].value = moduleIndex;	
	} else {
		form.elements["moduleIndex"].value = "";
	}
	
	action.run();
};
/*
 * 메시지작성 팝업
 */
doCreateMemo = function(memberSeq, memberName){
	var formId = "FormCreateMemo";
	var form = UT.getById(formId);
	form.elements["memberSeq"].value = memberSeq;	
	form.elements["memberName"].value = memberName;	
	
	FN.doMemoCreate(formId);
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProject.jsp"/>
		
		<form name="FormOutputFile" id="FormOutputFile" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
			<input type="hidden" name="sectionIndex" value="<c:out value="${currentSectionIndex}"/>"/>
			<input type="hidden" name="outputIndex" value="<c:out value="${currentOutputIndex}"/>"/>
			<input type="hidden" name="moduleIndex"/>
		</form>
		<form name="FormSrchComment" id="FormSrchComment" method="post" onsubmit="return false;">
			<input type="hidden" name="currentPage"   value="1" />
			<input type="hidden" name="perPage"       value="10" />
			<input type="hidden" name="srchProjectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
			<input type="hidden" name="srchSectionIndex" value="<c:out value="${currentSectionIndex}"/>"/>
			<input type="hidden" name="srchOutputIndex" value="<c:out value="${currentOutputIndex}"/>"/>
		</form>
		<form name="FormDeleteComment" id="FormDeleteComment" method="post" onsubmit="return false;">
			<input type="hidden" name="commentSeq" />
		</form>
		<form name="FormCreateMemo" id="FormCreateMemo" method="post" onsubmit="return false;">
			<input type="hidden" name="memberSeq" />
			<input type="hidden" name="memberName" />
		</form>
	</div>

	<c:set var="orderPmYn" value="N"/> <%-- 발주사 PM --%>
	<c:set var="developPmYn" value="N"/> <%-- 개발사 PM --%>
	<c:forEach var="row" items="${listProjectMember}" varStatus="i">
		<c:if test="${ssMemberSeq eq row.member.memberSeq and !empty mapProjectCompany[row.companyMember.companySeq]}">
			<c:choose>
				<c:when test="${mapProjectCompany[row.companyMember.companySeq].projectCompany.companyTypeCd eq CD_CDMS_PROJECT_COMPANY_TYPE_ORDER}">
					<c:set var="orderPmYn" value="Y"/>
				</c:when>
				<c:when test="${mapProjectCompany[row.companyMember.companySeq].projectCompany.companyTypeCd eq CD_CDMS_PROJECT_COMPANY_TYPE_DEVELOP}">
					<c:set var="developPmYn" value="Y"/>
				</c:when>
			</c:choose>
		</c:if>	
	</c:forEach>
	
	<c:set var="generalPmYn" value="N"/> <%-- 총괄 PM --%>
	<c:forEach var="row" items="${listProjectGroupMember}" varStatus="i">
		<c:if test="${ssMemberSeq eq rowSub.member.memberSeq and row.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_PM}">
			<c:set var="generalPmYn" value="N"/>
		</c:if>
	</c:forEach>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailProject.project.projectName}"/></h4>
		<div class="right">
			<a href="#" onclick="doDetail({'projectSeq' : '<c:out value="${detailProject.project.projectSeq}"/>'});"
			   class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:과정정보"/></span></a>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<c:choose>
		<c:when test="${empty listSection}">
			<div class="lybox mt10">
				<spring:message code="글:데이터가없습니다" />		
			</div>
		</c:when>
		<c:otherwise>
			<ul class="cdms-section-list detail">
				<c:forEach var="row" items="${listSection}" varStatus="i">
					<li class="section <c:out value="${row.section.sectionIndex eq currentSectionIndex ? 'selected' : ''}"/>" onclick="doDetailSection({
				       'projectSeq' : '${row.section.projectSeq}',
				       'sectionIndex' : '${row.section.sectionIndex}',
				       'outputIndex' : ''})"><c:out value="${row.section.sectionName}"/>
				       <c:if test="${row.section.sectionCompleteYn eq 'Y'}">
				       		<div class="complete"></div>
				       </c:if>
				       </li>
					<c:if test="${i.last eq false}">
						<li class="connect">---</li>
					</c:if>
				</c:forEach>
			</ul>
		</c:otherwise>
	</c:choose>

	<c:set var="currentOutput" value=""/>
	<div class="lybox-title mt10">
		<h4 class="section-title">
			<spring:message code="필드:CDMS:산출물" />
			<select name="outputIndex" onchange="doChangeOutput(this)" style="margin-left:10px; width:147px;">
				<c:forEach var="row" items="${listOutput}" varStatus="i">
					<c:choose>
						<c:when test="${row.output.outputIndex eq currentOutputIndex}">
							<c:set var="currentOutput" value="${row.output}"/>
							<option value="<c:out value="${row.output.outputIndex}"/>" selected="selected"><c:out value="${row.output.outputName}"/></option>
						</c:when>
						<c:otherwise>
							<option value="<c:out value="${row.output.outputIndex}"/>"><c:out value="${row.output.outputName}"/></option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
		</h4>
	</div>
	
	<table class="tbl-layout mt10">
	<colgroup>
		<col style="width:45%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<div class="scroll-y" style="height:550px; vertical-align:top;">
					<c:choose>
						<c:when test="${currentOutput.moduleYn eq 'Y'}">
							<form name="FormUpdateModuleStatus" id="FormUpdateModuleStatus" method="post" onsubmit="return false;">
							<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
							<input type="hidden" name="sectionIndex" value="<c:out value="${currentSectionIndex}"/>"/>
							<input type="hidden" name="outputIndex" value="<c:out value="${currentOutputIndex}"/>"/>
							<input type="hidden" name="nextSectionIndex" value="<c:out value="${!empty nextOutput ? nextOutput.output.sectionIndex : ''}"/>"/>
							<input type="hidden" name="nextOutputIndex" value="<c:out value="${!empty nextOutput ? nextOutput.output.outputIndex : ''}"/>"/>
							<input type="hidden" name="outputStatusCd"/>
							<input type="hidden" name="message" value="[<c:out value="${currentOutput.outputName}"/>] <spring:message code="글:CDMS:X차시Y하였습니다" />"/>
						
							<c:set var="moduleCount" value="${detailProject.project.moduleCount}"/>
							
							<table class="tbl-detail">
							<colgroup>
								<col style="width:30px" />
								<col style="width:60px" />
								<col style="width:auto" />
								<col style="width:auto" />
								<col style="width:40px" />
								<col style="width:70px" />
							</colgroup>
							<thead>
								<tr>
									<th>&nbsp;</th>
									<th><spring:message code="필드:CDMS:차시" /></th>
									<th><spring:message code="필드:CDMS:공정자" /></th>
									<th><spring:message code="필드:CDMS:검수자" /></th>
									<th><spring:message code="필드:CDMS:파일" /></th>
									<th><spring:message code="필드:CDMS:상태" /></th>
								</tr>
							</thead>
							<tbody>

							<%-- count 초기화 --%>
							<c:set target="${countMapStatusCds}" property="ALL" value="${moduleCount}"/>
							<c:set target="${countMapStatusCds}" property="UNREGIST" value="0"/>
							<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
								<c:set target="${countMapStatusCds}" property="${row.code}" value="0"/>
							</c:forEach>

							<c:set var="countDevelop" value="0"/>							
							<c:set var="countConfirm" value="0"/>
							
							<c:if test="${developPmYn eq 'Y'}"> <%-- 개발사 PM --%>
								<c:set var="countDevelop" value="${countDevelop + 1}"/>
							</c:if>
							<c:if test="${orderPmYn eq 'Y'}"> <%-- 발주사 PM --%>
								<c:set var="countConfirm" value="${countConfirm + 1}"/>
							</c:if>
							<c:if test="${generalPmYn eq 'Y'}"> <%-- 총괄 PM --%>
								<c:set var="countConfirm" value="${countConfirm + 1}"/>
							</c:if>
							
							<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">

								<c:set var="developMemberYn" value="N"/>
								<c:set var="confirmMemberYn" value="N"/>
								<c:set var="moduleDevelopMember" value=""/>
								<c:set var="moduleConfirmMember" value=""/>
								
								<c:forEach var="rowSub" items="${listCharge}" varStatus="iSub">
									<c:if test="${rowSub.charge.moduleIndex eq rowModule and rowSub.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_DEVELOP}">
										<c:set var="moduleDevelopMember" value="${rowSub.member}"/>
									</c:if>
									<c:if test="${rowSub.charge.moduleIndex eq rowModule and rowSub.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_CONFIRM}">
										<c:set var="moduleConfirmMember" value="${rowSub.member}"/>
									</c:if>
								</c:forEach>
								
								<c:if test="${empty moduleDevelopMember}">
									<c:forEach var="rowSub" items="${listCharge}" varStatus="iSub">
										<c:if test="${rowSub.charge.moduleIndex eq 0 and rowSub.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_DEVELOP}"> <%-- 산출물전체담당자로 세팅 --%>
											<c:set var="moduleDevelopMember" value="${rowSub.member}"/>
										</c:if>
									</c:forEach>
								</c:if>
								<c:if test="${empty moduleConfirmMember}">
									<c:forEach var="rowSub" items="${listCharge}" varStatus="iSub">
										<c:if test="${rowSub.charge.moduleIndex eq 0 and rowSub.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_CONFIRM}"> <%-- 산출물전체담당자로 세팅 --%>
											<c:set var="moduleConfirmMember" value="${rowSub.member}"/>
										</c:if>
									</c:forEach>
								</c:if>
								
								<c:if test="${!empty moduleDevelopMember and moduleDevelopMember.memberSeq eq ssMemberSeq}">
									<c:set var="developMemberYn" value="Y"/>
									<c:set var="countDevelop" value="${countDevelop + 1}"/>
								</c:if>
								<c:if test="${!empty moduleConfirmMember and moduleConfirmMember.memberSeq eq ssMemberSeq}">
									<c:set var="confirmMemberYn" value="Y"/>
									<c:set var="countConfirm" value="${countConfirm + 1}"/>
								</c:if>
								
								<c:if test="${developPmYn eq 'Y'}"> <%-- 개발사 PM --%>
									<c:set var="developMemberYn" value="Y"/>
								</c:if>
								<c:if test="${orderPmYn eq 'Y'}"> <%-- 발주사 PM --%>
									<c:set var="confirmMemberYn" value="Y"/>
								</c:if>
								<c:if test="${generalPmYn eq 'Y'}"> <%-- 총괄 PM --%>
									<c:set var="confirmMemberYn" value="Y"/>
								</c:if>
								
								<c:set var="matchedModule" value=""/>
								<c:forEach var="rowSub" items="${listModule}" varStatus="iSub">
									<c:if test="${rowSub.module.moduleIndex eq rowModule}">
										<c:set var="matchedModule" value="${rowSub.module}"/>
									</c:if>
								</c:forEach>
								
								<tr>
									<td class="align-c">
										<c:choose>
											<c:when test="${developMemberYn eq 'Y' and (empty matchedModule or empty matchedModule.outputStatusCd or matchedModule.outputStatusCd eq CD_CDMS_OUTPUT_STATUS_REJECT)}">
												<input type="checkbox" name="checkkeys" class="checkbox cdms-develop">
												<input type="hidden" name="moduleIndexs" value="<c:out value="${rowModule}"/>"/>
												<input type="hidden" name="autoDescriptions"/>
											</c:when>
											<c:when test="${confirmMemberYn eq 'Y' and !empty matchedModule and matchedModule.outputStatusCd eq CD_CDMS_OUTPUT_STATUS_REQUEST}">
												<input type="checkbox" name="checkkeys" class="checkbox cdms-confirm">
												<input type="hidden" name="moduleIndexs" value="<c:out value="${rowModule}"/>"/>
												<input type="hidden" name="autoDescriptions"/>
											</c:when>
										</c:choose>
										<input type="hidden" name="moduleIndexs" value="<c:out value="${rowModule}"/>"/>
										<input type="hidden" name="autoDescriptions"/>
									</td>
									<td class="align-c"><c:out value="${rowModule}"/><spring:message code="필드:CDMS:차시"/></td>
									<td class="align-c">
										<c:choose>
											<c:when test="${!empty moduleDevelopMember}">
												<c:out value="${moduleDevelopMember.memberName}"/>(<c:out value="${moduleDevelopMember.memberId}"/>)
											</c:when>
											<c:otherwise>
												<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="align-c">
										<c:choose>
											<c:when test="${!empty moduleConfirmMember}">
												<c:out value="${moduleConfirmMember.memberName}"/>(<c:out value="${moduleConfirmMember.memberId}"/>)
											</c:when>
											<c:otherwise>
												<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
											</c:otherwise>
										</c:choose>
									</td>
									
									<td class="align-c">
										<c:choose>
											<%-- 프로젝트가 종료상태가 아니고, 공정자이고, 산출물이 승인 상태가 아니면 - 파일업로드 --%>
											<c:when test="${detailProject.project.completeYn ne 'Y' and developMemberYn eq 'Y' and (empty matchedModule or CD_CDMS_OUTPUT_STATUS_ACCEPT ne matchedModule.outputStatusCd)}">
												<div class="icon-file-upload" onclick="doEditFileOutput('<c:out value="${rowModule}"/>')" title="<spring:message code="필드:CDMS:파일"/><spring:message code="글:CDMS:업로드"/>"></div>
											</c:when>
											<c:otherwise>
												<div class="icon-file-download" onclick="doDetailFileOutput('<c:out value="${rowModule}"/>')" title="<spring:message code="필드:CDMS:파일"/><spring:message code="글:CDMS:다운로드"/>"></div>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="align-c">
										<c:choose>
											<c:when test="${empty matchedModule or empty matchedModule.outputStatusCd}">
												<spring:message code="글:CDMS:미등록" />
												<c:set target="${countMapStatusCds}" property="UNREGIST" value="${countMapStatusCds['UNREGIST'] + 1}"/>
											</c:when>
											<c:otherwise>
												<aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${matchedModule.outputStatusCd}"/>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
									<c:if test="${!empty matchedModule and matchedModule.outputStatusCd eq row.code}">
										<c:set target="${countMapStatusCds}" property="${row.code}" value="${countMapStatusCds[row.code] + 1}"/>
									</c:if>
								</c:forEach>
								
							</c:forEach>
							</tbody>
							</table>
							
							</form>
						
							<div class="section-stats">
								<span><spring:message code="글:CDMS:전체" /> : </span><span class="count"><c:out value="${countMapStatusCds['ALL']}"/></span>
								<c:if test="${!empty countMapStatusCds['UNREGIST']}">
									<span><spring:message code="글:CDMS:미등록" /> : </span><span class="count"><c:out value="${countMapStatusCds['UNREGIST']}"/></span>
								</c:if>
								<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
									<span><c:out value="${row.codeName}"/> : </span><span class="count"><c:out value="${countMapStatusCds[row.code]}"/></span>
								</c:forEach>
							</div>
						
							<c:if test="${detailProject.project.completeYn ne 'Y' and currentOutput.outputWorkYn eq 'Y'}">
								<div class="lybox-btn-r">
									<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
										<%-- 공정자이면 - 검수요청 --%>
										<c:if test="${countDevelop gt 0 and row.code eq CD_CDMS_OUTPUT_STATUS_REQUEST}">
											<a href="#" onclick="doUpdateModuleStatus('<c:out value="${row.code}"/>')" class="btn blue"><span class="mid"><c:out value="${row.codeName}"/></span></a>
										</c:if>
										
										<%-- 검수자이면 - 반려/승인 --%>
										<c:if test="${countConfirm gt 0 and row.code ne CD_CDMS_OUTPUT_STATUS_REQUEST}">
											<a href="#" onclick="doUpdateModuleStatus('<c:out value="${row.code}"/>')" class="btn blue"><span class="mid"><c:out value="${row.codeName}"/></span></a>
										</c:if>
									</c:forEach>
								</div>
							</c:if>
						
						</c:when>
						<c:otherwise>
						
							<c:set var="developMemberYn" value="N"/>
							<c:set var="confirmMemberYn" value="N"/>
							<c:set var="developMember" value=""/>
							<c:set var="confirmMember" value=""/>
							<c:forEach var="row" items="${listCharge}" varStatus="i">
								<c:if test="${row.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_DEVELOP}">
									<c:set var="developMember" value="${row.member}"/>
									<c:if test="${row.charge.memberSeq eq ssMemberSeq}">
										<c:set var="developMemberYn" value="Y"/>
									</c:if>
								</c:if>
								<c:if test="${row.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_CONFIRM}">
									<c:set var="confirmMember" value="${row.member}"/>
									<c:if test="${row.charge.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_CONFIRM and row.charge.memberSeq eq ssMemberSeq}">
										<c:set var="confirmMemberYn" value="Y"/>
									</c:if>
								</c:if>
							</c:forEach>
							
							<c:if test="${developPmYn eq 'Y'}"> <%-- 개발사 PM --%>
								<c:set var="developMemberYn" value="Y"/>
							</c:if>
							<c:if test="${orderPmYn eq 'Y'}"> <%-- 발주사 PM --%>
								<c:set var="confirmMemberYn" value="Y"/>
							</c:if>
							<c:if test="${generalPmYn eq 'Y'}"> <%-- 총괄 PM --%>
								<c:set var="confirmMemberYn" value="Y"/>
							</c:if>

							<form name="FormUpdateOutputStatus" id="FormUpdateOutputStatus" method="post" onsubmit="return false;">
							<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
							<input type="hidden" name="sectionIndex" value="<c:out value="${currentSectionIndex}"/>"/>
							<input type="hidden" name="outputIndex" value="<c:out value="${currentOutputIndex}"/>"/>
							<input type="hidden" name="nextSectionIndex" value="<c:out value="${!empty nextOutput ? nextOutput.output.sectionIndex : ''}"/>"/>
							<input type="hidden" name="nextOutputIndex" value="<c:out value="${!empty nextOutput ? nextOutput.output.outputIndex : ''}"/>"/>
							<input type="hidden" name="message" value="[<c:out value="${currentOutput.outputName}"/>] <spring:message code="글:CDMS:X하였습니다" />"/>
							<input type="hidden" name="autoDescription"/>
							<input type="hidden" name="outputStatusCd"/>

							<%-- count 초기화 --%>
							<c:set target="${countMapStatusCds}" property="ALL" value="1"/>
							<c:set target="${countMapStatusCds}" property="UNREGIST" value="0"/>
							<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
								<c:set target="${countMapStatusCds}" property="${row.code}" value="0"/>
							</c:forEach>
							
							<table class="tbl-detail">
							<colgroup>
								<col style="width:auto" />
								<col style="width:auto" />
								<col style="width:50px" />
								<col style="width:70px" />
							</colgroup>
							<thead>
								<tr>
									<th class="align-c"><spring:message code="필드:CDMS:공정자" /></th>
									<th class="align-c"><spring:message code="필드:CDMS:검수자" /></th>
									<th class="align-c"><spring:message code="필드:CDMS:파일" /></th>
									<th class="align-c"><spring:message code="필드:CDMS:상태" /></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="align-c">
										<c:choose>
											<c:when test="${!empty developMember}">
												<c:out value="${developMember.memberName}"/>(<c:out value="${developMember.memberId}"/>)
											</c:when>
											<c:otherwise>
												<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="align-c">
										<c:choose>
											<c:when test="${!empty confirmMember}">
												<c:out value="${confirmMember.memberName}"/>(<c:out value="${confirmMember.memberId}"/>)
											</c:when>
											<c:otherwise>
												<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="align-c">
										<c:choose>
											<%-- 프로젝트가 종료상태가 아니고, 공정자이고, 산출물이 승인 상태가 아니면 - 파일업로드 --%>
											<c:when test="${detailProject.project.completeYn ne 'Y' and developMemberYn eq 'Y' and CD_CDMS_OUTPUT_STATUS_ACCEPT ne currentOutput.outputStatusCd}">
												<div class="icon-file-upload" onclick="doEditFileOutput()" title="<spring:message code="필드:CDMS:파일"/><spring:message code="글:CDMS:업로드"/>"></div>
											</c:when>
											<c:otherwise>
												<div class="icon-file-download" onclick="doDetailFileOutput()" title="<spring:message code="필드:CDMS:파일"/><spring:message code="글:CDMS:다운로드"/>"></div>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="align-c">
										<c:choose>
											<c:when test="${empty currentOutput.outputStatusCd}">
												<spring:message code="글:CDMS:미등록" />
												<c:set target="${countMapStatusCds}" property="UNREGIST" value="${countMapStatusCds['UNREGIST'] + 1}"/>
											</c:when>
											<c:otherwise>
												<aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${currentOutput.outputStatusCd}"/>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</tbody>
							</table>
		
							</form>
							
							<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
								<c:if test="${!empty currentOutput.outputStatusCd and currentOutput.outputStatusCd eq row.code}">
									<c:set target="${countMapStatusCds}" property="${row.code}" value="${countMapStatusCds[row.code] + 1}"/>
								</c:if>
							</c:forEach>
							
							<div class="section-stats">
								<span><spring:message code="글:CDMS:전체" /> : </span><span class="count"><c:out value="${countMapStatusCds['ALL']}"/></span>
								<c:if test="${!empty countMapStatusCds['UNREGIST']}">
									<span><spring:message code="글:CDMS:미등록" /> : </span><span class="count"><c:out value="${countMapStatusCds['UNREGIST']}"/></span>
								</c:if>
								<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
									<span><c:out value="${row.codeName}"/> : </span><span class="count"><c:out value="${countMapStatusCds[row.code]}"/></span>
								</c:forEach>
							</div>
							
							<c:if test="${detailProject.project.completeYn ne 'Y' and currentOutput.outputWorkYn eq 'Y'}">
								<div class="lybox-btn-r">
									<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
									
										<%-- 미등록 이거나 반려 일때 --%>
										<c:if test="${empty currentOutput.outputStatusCd or currentOutput.outputStatusCd eq CD_CDMS_OUTPUT_STATUS_REJECT}">
											<%-- 공정자이면 - 검수요청 --%>
											<c:if test="${developMemberYn eq 'Y' and row.code eq CD_CDMS_OUTPUT_STATUS_REQUEST}">
												<a href="#" onclick="doUpdateOutputStatus('<c:out value="${row.code}"/>')" 
												   class="btn blue"><span class="mid"><c:out value="${row.codeName}"/></span></a>
											</c:if>
										</c:if>
										
										<%-- 검수요청 일때 --%>
										<c:if test="${currentOutput.outputStatusCd eq CD_CDMS_OUTPUT_STATUS_REQUEST}">
											<%-- 검수자이면 - 반려/승인 --%>
											<c:if test="${confirmMemberYn eq 'Y' and row.code ne CD_CDMS_OUTPUT_STATUS_REQUEST}">
												<a href="#" onclick="doUpdateOutputStatus('<c:out value="${row.code}"/>')" 
												   class="btn blue"><span class="mid"><c:out value="${row.codeName}"/></span></a>
											</c:if>
										</c:if>
									</c:forEach>
								</div>
							</c:if>
						</c:otherwise>
					</c:choose>
					
				</div>
			</td>
			<td>
				<div style="vertical-align:top; margin-left:10px;">
					<table class="tbl-detail">
					<colgroup>
						<col style="width: 120px" />
						<col style="width: auto" />
					</colgroup>
					<tbody>
						<tr>
							<th><spring:message code="필드:CDMS:산출물일정" /></th>
							<td>
								<c:choose>
									<c:when test="${!empty currentOutput.startDate}">
										<aof:date datetime="${currentOutput.startDate}"/>
									</c:when>
									<c:otherwise>
										<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
									</c:otherwise>
								</c:choose>
								~
								<c:choose>
									<c:when test="${!empty currentOutput.endDate}">
										<aof:date datetime="${currentOutput.endDate}"/>
									</c:when>
									<c:otherwise>
										<span class="cdms-warning-text"><spring:message code="글:CDMS:미설정" /></span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th><spring:message code="필드:CDMS:완료목표산출물" /></th>
							<td>
								<c:out value="${countMapStatusCds[CD_CDMS_OUTPUT_STATUS_ACCEPT]}"/> / <c:out value="${countMapStatusCds['ALL']}"/>
							</td>
						</tr>
						<%-- 총괄PM --%>
						<c:if test="${!empty listProjectGroupMember}">
							<tr>
								<th><aof:code type="print" codeGroup="CDMS_PROJECT_GROUP_MEMBER_TYPE" selected="${CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM}"/></th>
								<td>
									<c:forEach var="row" items="${listProjectGroupMember}" varStatus="i">
										<c:if test="${row.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM}">
											<c:set var="chargeMemberPhoto" scope="request"><aof:img type="print" src="common/blank.gif"/></c:set>
											<c:if test="${!empty row.member.photo}">
												<c:set var="chargeMemberPhoto" value ="${aoffn:config('upload.context.image')}${row.member.photo}.thumb.jpg" scope="request"/>
											</c:if>
											<div class="photo photo-40">
												<img src="${chargeMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
											</div>
											<span>
												<a href="javascript:void(0)"
													onclick="doCreateMemo('<c:out value="${row.member.memberSeq}"/>', '<c:out value="${row.member.memberName}"/>')"><c:out value="${row.member.memberName}"/>(<c:out value="${row.member.memberId}"/>)</a>
												<c:if test="${!empty mapProjectCompany[row.companyMember.companySeq]}">
													<div class="icon-company-<c:out value="${fn:toLowerCase(fn:substringAfter(mapProjectCompany[row.companyMember.companySeq].projectCompany.companyTypeCd, CD_CDMS_PROJECT_COMPANY_TYPE_ADDSEP))}"/>"
														title="<aof:code type="print" codeGroup="CDMS_PROJECT_COMPANY_TYPE" selected="${mapProjectCompany[row.companyMember.companySeq].projectCompany.companyTypeCd}"/>"
													></div>
												</c:if>
											</span>
										</c:if>
									</c:forEach>
								</td>
						</c:if>
											
						<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
							<tr>
								<th><c:out value="${row.codeName}"/></th>
								<td>
									<c:choose>
										<c:when test="${row.code eq CD_CDMS_PROJECT_MEMBER_TYPE_PM}">
											<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
												<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
													<c:set var="chargeMemberPhoto" scope="request"><aof:img type="print" src="common/blank.gif"/></c:set>
													<c:if test="${!empty rowSub.member.photo}">
														<c:set var="chargeMemberPhoto" value ="${aoffn:config('upload.context.image')}${rowSub.member.photo}.thumb.jpg" scope="request"/>
													</c:if>
													<div class="photo photo-40">
														<img src="${chargeMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
													</div>
													<span>
														<a href="javascript:void(0)"
															onclick="doCreateMemo('<c:out value="${rowSub.member.memberSeq}"/>', '<c:out value="${rowSub.member.memberName}"/>')"><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</a>
														<c:if test="${!empty mapProjectCompany[rowSub.companyMember.companySeq]}">
															<div class="icon-company-<c:out value="${fn:toLowerCase(fn:substringAfter(mapProjectCompany[rowSub.companyMember.companySeq].projectCompany.companyTypeCd, CD_CDMS_PROJECT_COMPANY_TYPE_ADDSEP))}"/>"
																title="<aof:code type="print" codeGroup="CDMS_PROJECT_COMPANY_TYPE" selected="${mapProjectCompany[rowSub.companyMember.companySeq].projectCompany.companyTypeCd}"/>"
															></div>
														</c:if>
													</span>
												</c:if>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<c:forEach var="rowSub" items="${listCharge}" varStatus="iSub">
												<c:if test="${row.code eq rowSub.charge.memberCdmsTypeCd}">
													<c:set var="chargeMemberPhoto" scope="request"><aof:img type="print" src="common/blank.gif"/></c:set>
													<c:if test="${!empty rowSub.member.photo}">
														<c:set var="chargeMemberPhoto" value ="${aoffn:config('upload.context.image')}${rowSub.member.photo}.thumb.jpg" scope="request"/>
													</c:if>
													<div class="photo photo-40">
														<img src="${chargeMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
													</div>
													<span>
														<a href="javascript:void(0)"
															onclick="doCreateMemo('<c:out value="${rowSub.member.memberSeq}"/>', '<c:out value="${rowSub.member.memberName}"/>')"><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</a>
														<c:if test="${!empty mapProjectCompany[rowSub.companyMember.companySeq]}">
															<div class="icon-company-<c:out value="${fn:toLowerCase(fn:substringAfter(mapProjectCompany[rowSub.companyMember.companySeq].projectCompany.companyTypeCd, CD_CDMS_PROJECT_COMPANY_TYPE_ADDSEP))}"/>"
																title="<aof:code type="print" codeGroup="CDMS_PROJECT_COMPANY_TYPE" selected="${mapProjectCompany[rowSub.companyMember.companySeq].projectCompany.companyTypeCd}"/>"
															></div>
														</c:if>
													</span>
												</c:if>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
					</table>

					<div id="containerComment" class="mt10"></div>
					
				</div>
			</td>
		</tr>
		</table>
				
	</div>
	
</body>
</html>