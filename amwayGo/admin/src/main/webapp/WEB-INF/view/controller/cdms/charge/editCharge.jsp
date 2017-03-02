<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE"         value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE')}"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP"  value="${CD_CDMS_PROJECT_MEMBER_TYPE}::"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_PM"      value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.PM')}"/>

<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType" except="${CD_CDMS_PROJECT_MEMBER_TYPE_PM}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	jQuery.aosButtonScroller("cdms-tabs"); 
	
	doDisplayCheckbox();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdate = $.action("submit", {formId : "FormUpdateCharge"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/charge/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		jQuery(".selected").removeClass("selected");
		var $form = jQuery("#" + forUpdate.config.formId);
		$form.find(":input[name='checkkeys']").attr("checked", false);
	};
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {

};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 담당자 선택
 */
doSelectMember = function(element) {
	jQuery(".selected").removeClass("selected");
	var $element = jQuery(element);
	$element.addClass("selected");
};
/**
 * 담당자 지정
 */
doApplyMember = function() {
	var $selected = jQuery(".selected");
	if($selected.length == 0) {
		$.alert({message : "<spring:message code="글:CDMS:담당자를선택하십시오"/>"});
		return;
	}
	var html = [];
	html.push($selected.text());
	var type = $selected.attr("type");
	var seq = $selected.attr("seq");
	var $form = jQuery("#" + forUpdate.config.formId);
	var $checked = $form.find(":input[name='checkkeys']").filter(":checked");
	if($checked.length == 0) {
		$.alert({message : "<spring:message code="글:CDMS:산출물을선택하십시오"/>"});
		return;
	}
	$checked.each(function() {
		var $columns =	jQuery(this).closest(".columns");
		$columns.find(".cdms-" + type).each(function() {
			var $this = jQuery(this);
			$this.find(".input-text").html(html.join(""));
			$this.find(".input-hidden > :input[name='memberSeqs']").val(seq);
		});
	});
};
/**
 * 담당자 제외
 */
doRemoveMember = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var $checked = $form.find(":input[name='checkkeys']").filter(":checked");
	if($checked.length == 0) {
		$.alert({message : "<spring:message code="글:CDMS:산출물을선택하십시오"/>"});
		return;
	}
	$checked.each(function() {
		var $columns =	jQuery(this).closest(".columns");
		$columns.find(".column-code").each(function() {
			var $this = jQuery(this);
			$this.find(".input-text").html("-");
			$this.find(".input-hidden > :input[name='memberSeqs']").val("");
		});
	});
};
/**
 * 탭선택
 */
doSelectTab = function(element) {
	var $element = jQuery(element);
	$element.addClass("tab-on");
	$element.siblings().removeClass("tab-on");
	
	var index = $element.attr("index");
	var $module = jQuery(".cdms-module-" + index); 

	$module.removeClass("disabled").show();
	$module.find(":input[name='checkkeys']").attr("disabled", false);
	
	var $siblings = $module.siblings().not(".cdms-module-" + index); 
	$siblings.addClass("disabled").hide();
	$siblings.find(":input[name='checkkeys']").attr("disabled", true);
	if (parseInt(index, 10) > 0) {
		jQuery(".cdms-module-N").addClass("disabled").find(":input[name='checkkeys']").attr("disabled", true);
	} else {
		jQuery(".cdms-module-N").removeClass("disabled").find(":input[name='checkkeys']").attr("disabled", false);
	}
	var $form = jQuery("#" + forUpdate.config.formId);
	doCheckAll($form.find(":input[name='checkall']").get(0));
};
/**
 * 산출물 전체 선택
 */
doCheckAll = function(element) {
	var $form = jQuery("#" + forUpdate.config.formId);
	$form.find(":input[name='checkkeys']").each(function() {
		var $this = jQuery(this);
		if ($this.attr("disabled") == "disabled") {
			this.checked = false;
		} else {
			this.checked = element.checked;
		}
	});
};
/**
 * 수정 불가능한 항목 체크박스 없애기
 */
doDisplayCheckbox = function() {
	jQuery(".columns").each(function() {
		var $this = jQuery(this);
		var count = 0;
		$this.find(":input[name='chargeEditableYns']").each(function() {
			if ("Y" == this.value) {
				count++;
			}
		});
		if (count == 0) {
			$this.find(":input[name='checkkeys']").remove();
		}
	});
};
</script>
<style type="text/css">
.selected {border:1px solid #777;}
.cdms-tabs {position:relative; height:40px; line-height:35px; white-space:nowrap; }
.cdms-tabs .tab {display:inline-block;*display:inline;*zoom:1; width:auto; *display:inline; *width:40px; text-align:center; padding:0 10px; cursor:pointer; text-decoration:none; border:1px solid #ccc; background:#F5F5F5;border-radius:0; color:#727272; }
.cdms-tabs .tab-on {border:1px solid #000;background:#fff; text-decoration:none; font-weight:bold; }
</style>
</head>

<body>

	<c:set var="moduleYn" value="N"/>
	<c:forEach var="row" items="${listOutput}" varStatus="i">
		<c:if test="${row.output.moduleYn eq 'Y'}">
			<c:set var="moduleYn" value="Y"/>	
		</c:if>
	</c:forEach>

	<c:set var="sizeCdmsMemberType" value="${fn:length(cdmsMemberType)}"/>
	<c:set var="widthColumn" value="140"/> <%-- 공정자/검수자 컬럼 가로 크기 --%>
	<c:set var="moduleCount" value="${detailProject.project.moduleCount}"/>
	
	<div id="cdms-tabs" class="cdms-tabs">
		<a href="javascript:void(0)" class="btn gray scroll-left" style="position:absolute;left:0;top:0;"><span class="mid">&lt;</span></a>	
		<a href="javascript:void(0)" class="btn gray scroll-right" style="position:absolute;right:0;top:0;"><span class="mid">&gt;</span></a>	
		<ul class="scroll-content">
			<li class="tab tab-on" onclick="doSelectTab(this)" index="0"><spring:message code="필드:전체"/></li>
			<c:if test="${moduleYn eq 'Y'}">
				<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">
					<li class="tab" onclick="doSelectTab(this)" index="<c:out value="${rowModule}"/>"><c:out value="${rowModule}"/><spring:message code="필드:CDMS:차시"/></li>
				</c:forEach>
			</c:if>
		</ul>
	</div>
	
	<table class="tbl-layout">
	<colgroup>
		<col style="width:25%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<div class="lybox-nobg scroll-y" style="height:500px;">
					<div class="group">
						<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
							<div class="strong"><c:out value="${row.codeName}"/></div>
							<ul class="list-bullet">
							<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
								<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
									<li class="block cursor-pointer" seq="<c:out value="${rowSub.member.memberSeq}"/>" type="<c:out value="${fn:substringAfter(row.code, CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP)}"/>" onclick="doSelectMember(this)" style="padding-left:20px;">
										<c:out value="${rowSub.member.memberName}"/>&nbsp;(<c:out value="${rowSub.member.memberId}"/>)
									</li>
								</c:if>
							</c:forEach>
							</ul>
						</c:forEach>
					</div>
				</div>
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doApplyMember();" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:지정"/> &gt;</span></a>
						</c:if>
					</div>
				</div>
			</td>
			<td>
				<div class="lybox-nobg scroll-y" style="height:500px;">
					<form id="FormUpdateCharge" name="FormUpdateCharge" method="post" onsubmit="return false;">
					<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
					
					<table class="tbl-detail">
					<colgroup>
						<col style="width:auto;"/>
						<col style="width:200px;"/>
						<c:forEach var="row" begin="1" end="${sizeCdmsMemberType}" varStatus="i">
							<col style="width:<c:out value="${widthColumn}"/>px;"/>
						</c:forEach>
					</colgroup>
					<thead>
					<tr>
						<th class="align-c"><spring:message code="필드:CDMS:개발단계"/></th>
						<th class="align-c"><input type="checkbox" name="checkall" onclick="doCheckAll(this);" /> <label><spring:message code="필드:CDMS:산출물"/></label></th>
						<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
							<th class="align-c"><c:out value="${row.codeName}"/></th>
						</c:forEach>
					</tr>
					</thead>
					<c:if test="${empty listSection}">
						<tbody>
						<tr>
							<td class="align-c" colspan="${sizeCdmsMemberType + 2}"><spring:message code="글:데이터가없습니다" /></td>
						</tr>
						</tbody>
					</c:if>
					</table>
					
					<table class="tbl-detail" style="border-top:none;">
					<colgroup>
						<col style="width:auto;"/>
						<col style="width:${sizeCdmsMemberType * widthColumn + 200}px;"/>
					</colgroup>
					<tbody>
					<c:forEach var="row" items="${listSection}" varStatus="i">
						<tr>
							<th>
								<c:choose>
									<c:when test="${!empty row.section.sectionName}"><c:out value="${row.section.sectionName}"/></c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</th>
							<td style="padding:0;">
								<c:forEach var="rowSub" items="${listOutput}" varStatus="iSub">
									<c:if test="${row.section.sectionIndex eq rowSub.output.sectionIndex}">
										<table>
										<colgroup>
											<col style="width:200px;"/>
											<c:forEach var="row" begin="1" end="${sizeCdmsMemberType}" varStatus="i">
												<col style="width:<c:out value="${widthColumn}"/>px;"/>
											</c:forEach>
										</colgroup>
										<tbody>
											<tr class="columns cdms-module-0 cdms-module-${rowSub.output.moduleYn}">
												<td class="align-l" style="border:none;">
													<input type="checkbox" name="checkkeys">
													<label>
														<c:choose>
															<c:when test="${!empty rowSub.output.outputCd}"><c:out value="${rowSub.output.outputName}"/></c:when>
															<c:otherwise>-</c:otherwise>
														</c:choose>
													</label>
												</td>
												<c:forEach var="rowSubSub" items="${cdmsMemberType}" varStatus="iSubSub">
													<td class="align-c column-code cdms-<c:out value="${fn:substringAfter(rowSubSub.code, CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP)}"/>" style="border:none;">
														<c:set var="matchedCharge" value=""/> 
														<c:forEach var="rowSubSubSub" items="${listCharge}" varStatus="iSubSubSub">
															<c:if test="${rowSub.output.sectionIndex eq rowSubSubSub.charge.sectionIndex 
															and rowSub.output.outputIndex eq rowSubSubSub.charge.outputIndex
															and 0 eq rowSubSubSub.charge.moduleIndex
															and rowSubSub.code eq rowSubSubSub.charge.memberCdmsTypeCd}">
																<c:set var="matchedCharge" value="${rowSubSubSub}"/>
															</c:if>
														</c:forEach>
														<div class="input-hidden" style="display:none;">
															<input type="hidden" name="sectionIndexs" value="<c:out value="${rowSub.output.sectionIndex}"/>"/>
															<input type="hidden" name="outputIndexs" value="<c:out value="${rowSub.output.outputIndex}"/>"/>
															<input type="hidden" name="moduleIndexs" value="0"/>
															<input type="hidden" name="memberCdmsTypeCds" value="<c:out value="${rowSubSub.code}"/>"/>
															<input type="hidden" name="memberSeqs" value="<c:out value="${!empty matchedCharge ? matchedCharge.member.memberSeq : ''}"/>"/>
		
															<%-- 수정불가 일때 산출물의 담당자가 지정되지 않았을 때는 수정을 할 수 있어야 한다. --%>
															<input type="hidden" name="chargeEditableYns" 
																value="<c:out value="${rowSub.output.outputEditableYn eq 'Y' 
																or (rowSub.output.outputEditableYn eq 'N' and (empty matchedCharge or empty matchedCharge.member.memberSeq)) ? 'Y' : 'N'}"/>"/>
														</div>
														<c:choose>
															<c:when test="${!empty matchedCharge}">
																<div class="input-text"><c:out value="${matchedCharge.member.memberName}"/>&nbsp;(<c:out value="${matchedCharge.member.memberId}"/>)</div>
															</c:when>
															<c:otherwise>
																<div class="input-text">-</div>
															</c:otherwise>
														</c:choose>
													</td>
												</c:forEach>
											</tr>
											<c:if test="${rowSub.output.moduleYn eq 'Y'}">
												<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">
													<tr class="columns cdms-module-<c:out value="${rowModule}"/>" style="display:none;">
														<td class="align-l" style="border:none;">
															<input type="checkbox" name="checkkeys" disabled="disabled">
															<label>
																<c:choose>
																	<c:when test="${!empty rowSub.output.outputCd}"><c:out value="${rowSub.output.outputName}"/></c:when>
																	<c:otherwise>-</c:otherwise>
																</c:choose>
															</label>
														</td>
														<c:forEach var="rowSubSub" items="${cdmsMemberType}" varStatus="iSubSub">
															<td class="align-c column-code cdms-<c:out value="${fn:substringAfter(rowSubSub.code, CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP)}"/>" style="border:none;">
																<c:set var="matchedModuleCharge" value=""/> 
																<c:forEach var="rowSubSubSub" items="${listCharge}" varStatus="iSubSubSub">
																	<c:if test="${rowSub.output.sectionIndex eq rowSubSubSub.charge.sectionIndex 
																	and rowSub.output.outputIndex eq rowSubSubSub.charge.outputIndex
																	and rowModule eq rowSubSubSub.charge.moduleIndex
																	and rowSubSub.code eq rowSubSubSub.charge.memberCdmsTypeCd}">
																		<c:set var="matchedModuleCharge" value="${rowSubSubSub}"/>
																	</c:if>
																</c:forEach>
																<div class="input-hidden" style="display:;">
																	<input type="hidden" name="sectionIndexs" value="<c:out value="${rowSub.output.sectionIndex}"/>"/>
																	<input type="hidden" name="outputIndexs" value="<c:out value="${rowSub.output.outputIndex}"/>"/>
																	<input type="hidden" name="moduleIndexs" value="<c:out value="${rowModule}"/>"/>
																	<input type="hidden" name="memberCdmsTypeCds" value="<c:out value="${rowSubSub.code}"/>"/>
																	<input type="hidden" name="memberSeqs" value="<c:out value="${!empty matchedModuleCharge ? matchedModuleCharge.member.memberSeq : ''}"/>"/>
																	
																	<%-- 수정불가 일때 산출물의 담당자가 지정되지 않았을 때는 수정을 할 수 있어야 한다. --%>
																	<input type="hidden" name="chargeEditableYns" 
																		value="<c:out value="${rowSub.output.outputEditableYn eq 'Y' 
																		or (rowSub.output.outputEditableYn eq 'N' and (empty matchedCharge or empty matchedCharge.member.memberSeq)) ? 'Y' : 'N'}"/>"/>
																</div>
																<c:choose>
																	<c:when test="${!empty matchedModuleCharge}">
																		<div class="input-text"><c:out value="${matchedModuleCharge.member.memberName}"/>&nbsp;(<c:out value="${matchedModuleCharge.member.memberId}"/>)</div>
																	</c:when>
																	<c:otherwise>
																		<div class="input-text">-</div>
																	</c:otherwise>
																</c:choose>
															</td>
														</c:forEach>
													</tr>
												</c:forEach>
											</c:if>
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
				</div>
				
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doRemoveMember();" class="btn blue"><span class="mid">&lt; <spring:message code="버튼:CDMS:제외"/></span></a>
						</c:if>
					</div>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</div>
			</td>
		</tr>
	</tbody>
	</table>

</body>
</html>