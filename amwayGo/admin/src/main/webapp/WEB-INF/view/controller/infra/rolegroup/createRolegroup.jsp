<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ROLE_ADM" value="${aoffn:code('CD.ROLE.ADM')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ROLE_ADM = "<c:out value="${CD_ROLE_ADM}"/>";

var forListdata = null;
var forInsert   = null;
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
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/rolegroup/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:롤그룹:롤그룹명"/>",
		name : "rolegroupName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:권한그룹:상위권한그룹"/>",
		name : "parentId",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:권한그룹:권한구분"/>",
		name : "roleCd",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doInsert = function() { 
	var $form = jQuery("#" + forInsert.config.formId);
	var dirs = [];
	$form.find(":input[name='accessFtpDirs']").filter(":checked").each(function() {
		dirs.push(this.value);
	});
	$form.find(":input[name='accessFtpDir']").val(dirs.join(","));
	forInsert.run();
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
	var $form = jQuery("#" + forInsert.config.formId);
	if ($form.find(":input[name='roleCd']").filter(":checked").val() == CD_ROLE_ADM) {
		jQuery("#accessFtpDirsTr").show();
	} else {
		jQuery("#accessFtpDirsTr").hide();
		$form.find(":input[name='accessFtpDirs']").each(function() {
			this.checked = false;
		});
	}
		
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchRolegroup.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="accessFtpDir">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:권한그룹:권한그룹명"/></th>
			<td><input type="text" name="rolegroupName" style="width:90%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:권한그룹:상위권한그룹"/></th>
			<td>
				<select name="groupOrderToken">
					<c:forEach var="row" items="${subRolegroupList}" varStatus="i">
						<option value="<c:out value="${row.rolegroup.rolegroupSeq}"/>::<c:out value="${row.rolegroup.groupOrder}"/>::">
							<c:out value="${row.rolegroup.rolegroupName}"/>
						</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:권한그룹:권한구분"/></td>
			<td><aof:code type="radio" codeGroup="ROLE" name="roleCd" defaultSelected="${CD_ROLE_ADM}" onclick="doClickRoleCd()"/></td>
		</tr>
		<c:if test="${!empty accessFtpDirs}">
			<tr id="accessFtpDirsTr">
				<th><spring:message code="필드:권한그룹:FTP디렉토리"/></td>
				<td>
					<div class="comment"><spring:message code="글:권한그룹:FTP디렉토리는콘텐츠관리에서이용됩니다"/></div>
					<c:forEach var="row" items="${accessFtpDirs}">
						<input type="checkbox" name="accessFtpDirs" value="<c:out value="${row}"/>"/> <c:out value="${row}"/><br>
					</c:forEach>
				</td>
			</tr>
		</c:if>
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