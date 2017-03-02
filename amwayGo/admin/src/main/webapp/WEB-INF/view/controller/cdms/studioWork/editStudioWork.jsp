<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_STUDIO_STATUS_TYPE_CANCEL" value="${aoffn:code('CD.STUDIO_STATUS_TYPE.CANCEL')}"/>
<c:set var="CD_STUDIO_STATUS_TYPE_WAIT"   value="${aoffn:code('CD.STUDIO_STATUS_TYPE.WAIT')}"/>
<c:set var="CD_STUDIO_STATUS_TYPE_EMPTY"  value="${aoffn:code('CD.STUDIO_STATUS_TYPE.EMPTY')}"/>

<html>
<head>
<title></title>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_STUDIO_STATUS_TYPE_CANCEL = "<c:out value="${CD_STUDIO_STATUS_TYPE_CANCEL}"/>";
var CD_STUDIO_STATUS_TYPE_WAIT = "<c:out value="${CD_STUDIO_STATUS_TYPE_WAIT}"/>";
var CD_STUDIO_STATUS_TYPE_EMPTY = "<c:out value="${CD_STUDIO_STATUS_TYPE_EMPTY}"/>";

var forUpdate = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
			var form = UT.getById(forUpdate.config.formId);
			form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
			forUpdate.run("continue");
		}, 
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				inputWidth : 345, // default : 22
				immediatelyUpload : false,
				successCallback : function(id, file) {}
			}
		}]
	);	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/studio/work/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>"; 
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doStartUpload;
	forUpdate.config.fn.complete     = function() {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		doClose();
	};
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:촬영구분"/>",
		name : "shootingCd",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:취소사유"/>",
		name : "cancelMemo",
		data : ["!null"],
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			if (form.elements["studioStatusTypeCd"].value == CD_STUDIO_STATUS_TYPE_CANCEL) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:취소사유"/>",
		name : "cancelMemo",
		check : {
			maxlength : 1000
		}
	});
};
/**
 * 저장
 */
doUpdate = function() {
	var form = UT.getById(forUpdate.config.formId);
	if (form.elements["studioStatusTypeCd"].value == CD_STUDIO_STATUS_TYPE_CANCEL) {
		forUpdate.config.url = "<c:url value="/cdms/studio/work/cancel/update.do"/>";
	} else {
		forUpdate.config.url = "<c:url value="/cdms/studio/work/update.do"/>";
	}
	forUpdate.run();
};
/**
 * 취소
 */
doClose = function() {
	$layer.dialog("close");
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	var form = UT.getById(forUpdate.config.formId);
	if (form.elements["studioStatusTypeCd"].value == CD_STUDIO_STATUS_TYPE_CANCEL && form.elements["chargeYn"].value == "Y") {
		form.elements["sendMemo"].value += form.elements["cancelMemo"].value; // 스튜디오 담당자 일때 취소 사유를 쪽지로 발송한다.
	}
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
	}
};
/**
 * 예약취소 클릭
 */
doClickCancelYn = function(element) {
	var $element = jQuery(element);
	if (element.value == CD_STUDIO_STATUS_TYPE_CANCEL) {
		$element.siblings(":input[name='cancelMemo']").attr("disabled", false).removeClass("disabled");
		$element.siblings(":input[name='studioCancelTypeCd']").attr("disabled", false).removeClass("disabled");
	} else {
		$element.siblings(":input[name='cancelMemo']").attr("disabled", true).addClass("disabled");
		$element.siblings(":input[name='studioCancelTypeCd']").attr("disabled", true).addClass("disabled");
	}
};
/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};
/**
 * 과정선택
 */
doBrowseProject = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProject";
	action.config.url = "/cdms/project/list/popup.do";
	action.config.options.width = 800;
	action.config.options.height = 600;
	action.config.options.title = "<spring:message code="글:CDMS:과정선택"/>";
	action.run();
};
/**
 * 과정 선택
 */
doSetProject = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);	
		form.elements["projectSeq"].value = returnValue.projectSeq;
		form.elements["projectName"].value = returnValue.projectName;
	}
};
</script>
</head>

<body>

	<c:set var="chargeYn" value="N"/>
	<c:forEach var="row" items="${detailStudio.listStudioMember}" varStatus="i">
		<c:if test="${ssMemberSeq eq row.member.memberSeq }">
			<c:set var="chargeYn" value="Y"/>
		</c:if>
	</c:forEach>
	
	<form id="FormBrowseProject" name="FormBrowseProject" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doSetProject">
	</form>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="workSeq" value="<c:out value="${detailStudioWork.studioWork.workSeq}"/>">
	<table class="tbl-detail">
	<colgroup>
		<col style="width:75px" />
		<col style="width:auto;"/>
		<col style="width:75px" />
		<col style="width:250px;"/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:과정명"/></th>
			<td colspan="3">
				<input type="hidden" name="projectSeq" value="<c:out value="${detailStudioWork.studioWork.projectSeq}"/>">
				<input type="text" name="projectName" value="<c:out value="${detailStudioWork.project.projectName}"/>" style="width:342px;" readonly="readonly">
				<a href="javascript:void(0)" onclick="doBrowseProject()" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:과정선택"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오"/></th>
			<td><c:out value="${detailStudio.studio.studioName}"/></td>
			<th><spring:message code="필드:CDMS:촬영구분"/></td>
			<td>
				<c:choose>
					<c:when test="${chargeYn eq 'Y'}">
						<select name="shootingCd">
							<aof:code type="option" codeGroup="CDMS_SHOOTING" selected="${detailStudioWork.studioWork.shootingCd}"/>
						</select>
					</c:when>
					<c:otherwise>
						<select name="shootingCd">
							<aof:code type="option" codeGroup="CDMS_SHOOTING" selected="${detailStudioWork.studioWork.shootingCd}" except="holiday"/>
						</select>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:일자"/></th>
			<td><aof:date datetime="${detailStudioWork.studioWork.startDtime}"/></td>
			<th><spring:message code="필드:CDMS:시간"/></th>
			<td>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.startDtime}" pattern="HH : mm"/></span>
				<span style="margin-right:5px;">~</span>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.endDtime}" pattern="HH : mm"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:첨부파일"/></td>
			<td colspan="3">
				<input type="hidden" name="attachUploadInfo"/>
				<input type="hidden" name="attachDeleteInfo">
				<input type="hidden" name="attachType" value="input"> <%-- 촬영요청 첨부파일 --%>
				<div id="uploader" class="uploader">
					<c:if test="${!empty detailStudioWork.studioWork.attachList}">
						<c:forEach var="row" items="${detailStudioWork.studioWork.attachList}" varStatus="i">
							<c:if test="${row.attachType eq 'input'}">
								<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
									<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
								</div>
							</c:if>
						</c:forEach>
					</c:if>
				</div>
				<span class="vbom">10MB</span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:메모"/></td>
			<td style="vertical-align:top">
				<textarea name="memo" style="width:250px; height:120px; overflow-y:auto;"><c:out value="${detailStudioWork.studioWork.memo}"/></textarea>
			</td>
			<th><spring:message code="필드:CDMS:취소사유"/></td>
			<td style="vertical-align:top">
				<div style="position:relative;">
					<input type="hidden" name="chargeYn" value="${chargeYn}"/>
					<textarea name="cancelMemo" style="width:220px; height:100px; overflow-y:auto;" disabled="disabled" class="disabled"></textarea>
					<div class="vspace"></div>
						<select name="studioStatusTypeCd" onchange="doClickCancelYn(this)">
							<aof:code type="option" codeGroup="STUDIO_STATUS_TYPE" except="${CD_STUDIO_STATUS_TYPE_WAIT},${CD_STUDIO_STATUS_TYPE_EMPTY}" selected="${detailStudioWork.studioWork.studioCancelTypeCd}" />
						</select>
					<c:choose>
						<c:when test="${chargeYn eq 'Y'}"> <%-- 스튜디오 담당자 --%>
							<select name="studioCancelTypeCd" disabled="disabled" class="disabled" style="position:absolute; right:0;">
								<aof:code type="option" codeGroup="CDMS_STUDIO_CANCEL_TYPE" selected="${detailStudioWork.studioWork.studioCancelTypeCd}"/>
							</select>
							<%-- 쪽지 자동 발송 정보 --%>
							<input type="hidden" name="memoReceiveMemberSeq" value="${detailStudioWork.studioWork.regMemberSeq}"/>
							<textarea name="sendMemo" style="display:none;">
								<spring:message code="글:CDMS:스튜디오예약이취소되었습니다"/>
								- <spring:message code="필드:CDMS:스튜디오"/> : <c:out value="${detailStudio.studio.studioName}"/>
								- <spring:message code="필드:CDMS:일자"/> : <aof:date datetime="${detailStudioWork.studioWork.startDtime}"/>
								- <spring:message code="필드:CDMS:시간"/> : <aof:date datetime="${detailStudioWork.studioWork.startDtime}" pattern="HH : mm"/> ~ <aof:date datetime="${detailStudioWork.studioWork.endDtime}" pattern="HH : mm"/>
								- <spring:message code="필드:CDMS:취소사유"/> : 
							</textarea>
						</c:when>
						<c:otherwise>
							<input type="hidden" name="studioCancelTypeCd" value="regist"/>
						</c:otherwise>
					</c:choose>
				</div>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and (ssMemberSeq eq detailStudioWork.studioWork.regMemberSeq or chargeYn eq 'Y')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>