<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<script type="text/javascript">
var forInsert   = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
			var form = UT.getById(forInsert.config.formId);
			form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
			forInsert.run("continue");
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

	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/cdms/studio/work/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doStartUpload;
	forInsert.config.fn.complete     = doCompleteInsert;

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:시간"/>",
		name : "time",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:촬영구분"/>",
		name : "shootingCd",
		data : ["!null"]
	});
	forInsert.validator.set(function() {
		var $form = jQuery("#" + forInsert.config.formId);
		var checked = [];
		$form.find(":input[name='time']").each(function(index) {
			if (this.checked) {
				checked.push(index);
			}
		});
		if (checked.length >= 2) {
			var continuation = true;
			for (var i = 0; i < checked.length - 1; i++) {
				if ((checked[i] + 1) != checked[i + 1]) {
					continuation = false;
				} 
			}
			if (continuation == false) {
				$.alert({
					message : "<spring:message code="글:CDMS:다중선택시연속된시간의선택만가능합니다"/>"
				});
				return false;
			}
			return true;
		} else {
			return true;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:메모"/>",
		name : "memo",
		check : {
			maxlength : 1000
		}
	});
	
};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 저장완료
 */
doCompleteInsert = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (parseInt(result.success, 10) >= 1) {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		doClose();

	} else if (parseInt(result.success, 10) == 0) {
		$.alert({
			message : "<spring:message code="글:CDMS:동일한시간에예약된정보가존재합니다"/>"
		});
	} else {
		$.alert({
			message : "<spring:message code="글:저장되지않았습니다"/>"
		});
	}
	
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
	var $form = jQuery("#" + forInsert.config.formId);
	var d = $form.find(":input[name='workDate']").val();
	var s = $form.find(":input[name='time']").filter(":checked").filter(":first").siblings(":input[name='tempStartTime']").val() + "00";
	var e = $form.find(":input[name='time']").filter(":checked").filter(":last").siblings(":input[name='tempEndTime']").val() + "00";
	$form.find(":input[name='startDtime']").val(d + s);
	$form.find(":input[name='endDtime']").val(d + e);
	
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
	}
};
/**
 * 과정선택
 */
doBrowseProject = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProject";
	//action.config.url = "/cdms/project/list/popup.do";
	action.config.url = "/cdms/project/group/list/popup.do";
	action.config.parameters = "popupType=Group";
	action.config.options.width = 800;
	action.config.options.height = 600;
	action.config.options.title = "<spring:message code="글:CDMS:개발그룹"/>";
	action.run();
};
/**
 * 과정 선택
 */
doSetProject = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forInsert.config.formId);	
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
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="studioSeq" value="<c:out value="${detailStudio.studio.studioSeq}"/>">
	<table class="tbl-detail">
	<colgroup>
		<col style="width:75px" />
		<col style="width:250px;"/>
		<col style="width:75px" />
		<col style="width:auto;"/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:과정명"/></th>
			<td colspan="3">
				<input type="hidden" name="projectSeq">
				<input type="text" name="projectName" style="width:345px;" readonly="readonly">
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
							<aof:code type="option" codeGroup="CDMS_SHOOTING"/>
						</select>
					</c:when>
					<c:otherwise>
						<select name="shootingCd">
							<aof:code type="option" codeGroup="CDMS_SHOOTING" except="holiday"/>
						</select>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:일자"/></th>
			<td>
				<c:set var="workDate" value="${param['workDate']}"/>
				<aof:date datetime="${workDate}"/>
			</td>
			<th>&nbsp;</th>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:시간"/></th>
			<td style="vertical-align:top; *position:relative;">
				<input type="hidden" name="workDate" value="<c:out value="${workDate}"/>">
				<input type="hidden" name="startDtime">
				<input type="hidden" name="endDtime">
				<ul class="scroll-y" style="height:115px; padding:5px; border:solid 1px #cdcdcd; ">
					<c:forEach var="row" items="${listStudioTime}" varStatus="i">
						<c:set var="startTime"><c:out value="${workDate}"/><c:out value="${row.studioTime.startTime}"/>00</c:set>
						<c:set var="endTime"><c:out value="${workDate}"/><c:out value="${row.studioTime.endTime}"/>00</c:set>

						<c:set var="disabledTime" value=""/>
						<c:forEach var="rowSub" items="${paginateStudioWorkReserved.itemList}" varStatus="iSub">
							<c:if test="${empty rowSub.studioWork.cancelDtime}">
								<c:if test="${rowSub.studioWork.startDtime ge startTime and rowSub.studioWork.startDtime le endTime}">
									<c:set var="disabledTime" value="disabled"/>
								</c:if>
								<c:if test="${rowSub.studioWork.endDtime ge startTime and rowSub.studioWork.endDtime le endTime}">
									<c:set var="disabledTime" value="disabled"/>
								</c:if>
							</c:if>
						</c:forEach>
						
						<c:set var="checkedTime" value=""/>
						<c:set var="workTime"><c:out value="${workDate}"/><c:out value="${param['workTime']}"/>00</c:set>
						<c:if test="${empty disabledTime and workTime ge startTime and workTime le endTime}">
							<c:set var="checkedTime" value="checked"/>
						</c:if>
						<li style="padding:2px 0;">
							<input type="hidden" name="tempStartTime" value="<aof:date datetime="${startTime}" pattern="HHmm"/>">
							<input type="hidden" name="tempEndTime" value="<aof:date datetime="${endTime}" pattern="HHmm"/>">
							<input type="checkbox" name="time" <c:out value="${disabledTime}"/> class="time-<c:out value="${disabledTime}"/>" <c:out value="${checkedTime}"/>>
							<label class="time-<c:out value="${disabledTime}"/>"><aof:date datetime="${startTime}" pattern="HH : mm"/> ~ <aof:date datetime="${endTime}" pattern="HH : mm"/></label>
						</li>
					</c:forEach>
				</ul>
				<div class="clear comment"><spring:message code="글:CDMS:다중선택시연속된시간의선택만가능합니다"/></div>
			</td>
			<th><spring:message code="필드:CDMS:메모"/></td>
			<td style="vertical-align:top">
				<textarea name="memo" style="width:232px; height:115px; padding:5px; overflow-y:auto;"></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:첨부파일"/></td>
			<td colspan="3">
				<input type="hidden" name="attachUploadInfo"/>
				<input type="hidden" name="attachType" value="input"> <%-- 촬영요청 첨부파일 --%>
				<div id="uploader" class="uploader"></div>
				<span class="vbom">10MB</span>
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
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>