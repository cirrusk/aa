<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SETTING_TYPE_BANNEDWORD"  value="${aoffn:code('CD.SETTING_TYPE.BANNEDWORD')}"/>
<c:set var="CD_SETTING_TYPE_WHITETAG"    value="${aoffn:code('CD.SETTING_TYPE.WHITETAG')}"/>
<c:set var="CD_SETTING_TYPE_WHITEURL"    value="${aoffn:code('CD.SETTING_TYPE.WHITEURL')}"/>
<c:set var="CD_SETTING_TYPE_BLACKTAG"    value="${aoffn:code('CD.SETTING_TYPE.BLACKTAG')}"/>
<c:set var="CD_SETTING_TYPE_BLACKURL"    value="${aoffn:code('CD.SETTING_TYPE.BLACKURL')}"/>
<c:set var="CD_SETTING_TYPE_JOBSCHEDULE" value="${aoffn:code('CD.SETTING_TYPE.JOBSCHEDULE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSubUpdate = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();
};
/**
 * 설정
 */
doSubInitializeLocal = function() {

	forSubUpdate = $.action("submit", {formId : "SubFormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSubUpdate.config.url             = "<c:url value="/setting/save.do"/>";
	forSubUpdate.config.target          = "hiddenframe";
	forSubUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forSubUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdate.config.fn.complete     = function() {
		doRefresh();
	};
};
/**
 * 저장
 */
doSubUpdate = function() { 
	var settingCode = "<c:out value="${aoffn:config('migration.code')}"/>";
	
	if(settingCode == $("#SubFormUpdate input[name=settingTypeCd]").val()){
		var setting = $("#migJobSettingValue").val()  + "\n" + doSettingValueMigrationDelete();
		$("#SubFormUpdate textarea[name=settingValue]").val(setting);
	}	
	forSubUpdate.run();
};
/**
 * 스케줄 입력 데이터 마이그레이션 설정 제거
 */
doSettingValueMigrationDelete = function() {
	var midjob = "<c:out value="${aoffn:config('migration.job')}"/>";
	var value = $("#SubFormUpdate textarea[name=settingValue]").val();
	var valueList = value.split("\n");
	var returnValue = "";
	
	if(valueList != null){
		for(var i = 0; i < valueList.length; i++){
			if(!valueList[i].match(midjob)){
				returnValue += valueList[i] + "\n";
			};
		};
	}
	
	return returnValue;
};
</script>
<style type="text/css">
.comment h4 {color:#ffffff;background-color:#cdcdcd;padding-left:10px;line-height:22px;}
.comment ul {padding-left:15px;margin-top:5px;}
.comment ul li {list-style: disc;line-height:15px;}
.comment table tr {}
.comment table th, .comment table td {font-size:11px; color:#b7b7b7; font-weight:normal; line-height:17px;}
</style>
</head>

<body>

	<form id="SubFormUpdate" name="SubFormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="settingTypeCd" value="<c:out value="${settingTypeCd}"/>"/>
	
	<div class="comment" style="text-align:left;">
		<spring:message code="글:설정:라인의첫문자가#으로시작하면적용되지않습니다"/>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width:50%;"/>
		<col style="width:50%;"/>
	</colgroup>
	<tbody>
		<tr>
			<td class="align-c" style="vertical-align:top;">
				
				<c:if test="${settingTypeCd eq aoffn:config('migration.code')}">
				<textarea id="migJobSettingValue" style="width:95%;height:20px;" disabled="disabled"><c:out value="${migJob}"/></textarea>
				</c:if>
				
				<textarea name="settingValue" style="width:95%;height:400px;"><c:out value="${detail.setting.settingValue}"/></textarea>

				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doSubUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</div>
	
			</td>
			<td style="vertical-align:top;">
				<div class="comment">
				<c:choose>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_BANNEDWORD}">
						<spring:message code="글:설정:금칙어도움말"/>
					</c:when>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_WHITETAG}">
						<spring:message code="글:설정:허용태그도움말"/>
					</c:when>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_WHITEURL}">
						<spring:message code="글:설정:허용URL도움말"/>
					</c:when>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_BLACKTAG}">
						<spring:message code="글:설정:비허용태그도움말"/>
					</c:when>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_BLACKURL}">
						<spring:message code="글:설정:비허용URL도움말"/>
					</c:when>
					<c:when test="${settingTypeCd eq CD_SETTING_TYPE_JOBSCHEDULE}">
						<spring:message code="글:설정:스케줄러도움말"/>
					</c:when>
				</c:choose>
				</div>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<script type="text/javascript">
	initSubPage();
	</script>

</body>
</html>