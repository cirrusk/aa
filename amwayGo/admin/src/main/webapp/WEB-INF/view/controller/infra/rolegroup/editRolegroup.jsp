<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ROLE_ADM" value="${aoffn:code('CD.ROLE.ADM')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ROLE_ADM = "<c:out value="${CD_ROLE_ADM}"/>";

var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doClickRoleCd();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/rolegroup/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/rolegroup/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete";
	forDelete.config.url             = "<c:url value="/rolegroup/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:권한그룹:권한그룹명"/>",
		name : "rolegroupName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:권한그룹:권한구분"/>",
		name : "roleCd",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 롤구분 선택 
 */
doClickRoleCd = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	if ($form.find(":input[name='roleCd']").filter(":checked").val() == CD_ROLE_ADM) {
		jQuery("#accessFtpDirsTr").show();
	} else {
		jQuery("#accessFtpDirsTr").hide();
		$form.find(":input[name='accessFtpDir']").each(function() {
			this.checked = false;
		});
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchRolegroup.jsp"/>
	</div>

	<%-- 롤그룹 시퀀스 10 이하는 무조건 변경 삭제 제한 (config.xxx.xml에 member.fixedRolegroupSeqs 설정값에 해당함)--%>
	<c:set var="fixedRolegroupSeq" value="${aoffn:config('member.fixedRolegroupSeq')}"/>
	<c:set var="rolegroupSeq"><c:out value="${detail.rolegroup.rolegroupSeq}"/></c:set><%-- toString --%>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="rolegroupSeq" value="<c:out value="${detail.rolegroup.rolegroupSeq}"/>"/>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:권한그룹:권한그룹명"/></th>
			<td>
				<c:choose>
					<c:when test="${fixedRolegroupSeq < rolegroupSeq}">
						<input type="text" name="rolegroupName" value="<c:out value="${detail.rolegroup.rolegroupName}"/>" style="width:90%;">
					</c:when>
					<c:otherwise>
						<input type="hidden" name="rolegroupName" value="<c:out value="${detail.rolegroup.rolegroupName}"/>">
						<c:out value="${detail.rolegroup.rolegroupName}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:권한그룹:상위권한그룹"/></th>
			<td>
				<c:choose>
					<c:when test="${empty detail.rolegroup.parentRolegroupName}">
						-
					</c:when>
					<c:otherwise>
						<c:out value="${detail.rolegroup.parentRolegroupName}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:권한그룹:권한구분"/></td>
			<td>
				<c:choose>
					<c:when test="${fixedRolegroupSeq < rolegroupSeq}">
						<aof:code type="radio" codeGroup="ROLE" name="roleCd" selected="${detail.rolegroup.roleCd}"  onclick="doClickRoleCd()"/>
					</c:when>
					<c:otherwise>
						<aof:code type="radio" codeGroup="ROLE" name="roleCd" selected="${detail.rolegroup.roleCd}" style="display:none" labelStyle="display:none"/>
						<aof:code type="print" codeGroup="ROLE" selected="${detail.rolegroup.roleCd}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${!empty accessFtpDirs}">
			<tr id="accessFtpDirsTr" style="display:none;">
				<th><spring:message code="필드:권한그룹:FTP디렉토리"/></td>
				<td>
					<div class="comment"><spring:message code="글:권한그룹:FTP디렉토리는콘텐츠관리에서이용됩니다"/></div>
					<c:forEach var="row" items="${accessFtpDirs}">
						<input type="checkbox" name="accessFtpDir" value="<c:out value="${row}"/>"
							<c:if test="${aoffn:contains(detail.rolegroup.accessFtpDir, row, ',')}">
								checked="checked"
							</c:if>
						/> <c:out value="${row}"/><br>
					</c:forEach>
				</td>
			</tr>
		</c:if>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="rolegroupSeq" value="<c:out value="${detail.rolegroup.rolegroupSeq}"/>"/>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${(fixedRolegroupSeq < detail.rolegroup.rolegroupSeq && detail.rolegroup.sonCount == 0) and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>