<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="cdmsStudioComplete">Y=<spring:message code="글:CDMS:완료"/>,N=<spring:message code="글:CDMS:미완료"/></c:set>

<html decorator="popup">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<script type="text/javascript">
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
	forUpdate.config.url             = "<c:url value="/cdms/studio/work/result/update.do"/>";
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
		title : "<spring:message code="필드:CDMS:촬영결과"/><spring:message code="필드:CDMS:메모"/>",
		name : "resultMemo",
		check : {
			maxlength : 1000
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
 * 취소
 */
doClose = function() {
	$layer.dialog("close");
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
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
</script>
</head>

<body>

	<c:set var="chargeYn" value="N"/>
	<c:forEach var="row" items="${detailStudio.listStudioMember}" varStatus="i">
		<c:if test="${ssMemberSeq eq row.member.memberSeq }">
			<c:set var="chargeYn" value="Y"/>
		</c:if>
	</c:forEach>
	
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
				<c:out value="${detailStudioWork.project.projectName}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오"/></th>
			<td><c:out value="${detailStudio.studio.studioName}"/></td>
			<th><spring:message code="필드:CDMS:촬영구분"/></td>
			<td><aof:code type="print" codeGroup="CDMS_SHOOTING" selected="${detailStudioWork.studioWork.shootingCd}"/></td>
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
			<th><spring:message code="필드:CDMS:촬영결과"/><br><spring:message code="필드:CDMS:파일"/></td>
			<td colspan="3">
				<input type="hidden" name="attachUploadInfo"/>
				<input type="hidden" name="attachDeleteInfo">
				<input type="hidden" name="attachType" value="output"> <%-- 촬영요청 첨부파일 --%>
				<div id="uploader" class="uploader">
					<c:if test="${!empty detailStudioWork.studioWork.attachList}">
						<c:forEach var="row" items="${detailStudioWork.studioWork.attachList}" varStatus="i">
							<c:if test="${row.attachType eq 'output'}">
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
			<th><spring:message code="필드:CDMS:촬영결과"/><br><spring:message code="필드:CDMS:메모"/></td>
			<td style="vertical-align:top">
				<textarea name="resultMemo" style="width:250px; height:120px; overflow-y:auto;"><c:out value="${detailStudioWork.studioWork.resultMemo}"/></textarea>
			</td>
			<th><spring:message code="필드:CDMS:완료여부"/></td>
			<td>
				<aof:code type="radio" name="completeYn" codeGroup="${cdmsStudioComplete}" selected="${detailStudioWork.studioWork.completeYn}"/>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and chargeYn eq 'Y'}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>