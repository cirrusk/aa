<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forDelete    = null;

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
	forListdata.config.url    = "<c:url value="/univ/course/discuss/template/list/popup.do"/>";
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/course/discuss/template/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
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
 * 
 */
doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormInsert"); 
	returnValue = {
		templateSeq : form.elements["templateSeq"].value,
		templateTitle : form.elements["templateTitle"].value, 	
		templateDescription : form.elements["templateDescription"].value
	};
	
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
	}
	$layer.dialog("close");
}
</script>
</head>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>
<aof:session key="memberSeq" var="memberSeq"/>

<body>
	<br/>
	
	<div style="display:none;">
		<c:import url="srchCourseDiscussTemplatePopup.jsp"/>
	</div>
	
	<!-- 삭제폼 -->
	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="templateSeq" value="<c:out value="${detail.discussTemplate.templateSeq}"/>"/>
	</form>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="templateSeq" value="<c:out value="${detail.discussTemplate.templateSeq}"/>">
	<input type="hidden" name="templateTitle" value="<c:out value="${detail.discussTemplate.templateTitle}"/>">
	<input type="hidden" name="templateDescription" value="<c:out value="${detail.discussTemplate.templateDescription}"/>">
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트제목"/></th>
			<td><c:out value="${detail.discussTemplate.templateTitle}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트내용"/></th>
			<td><aof:text type="whiteTag" value="${detail.discussTemplate.templateDescription}"/></td>
		</tr>
	<c:if test="${!empty detail.discussTemplate.attachList}">
		<tr>
			<th><spring:message code="필드:게시판:첨부파일"/></th>
			<td>
				<c:forEach var="row" items="${detail.discussTemplate.attachList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
					[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
			</td>
		</tr>
	</c:if>
		<tr>
			<th><spring:message code="필드:템플릿:공개여부"/></th>
			<td><aof:code type="print" codeGroup="OPEN_YN" removeCodePrefix="true" selected="${detail.discussTemplate.openYn}"></aof:code></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:교수명"/></th>
			<td><c:out value="${detail.member.memberName}"/></td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">	
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<c:choose>
					<c:when test="${currentRoleCfString eq 'ADM'}">
						<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
					</c:when>
					<c:otherwise>
						<c:if test="${(condition.srchProfMemberSeq eq detail.discussTemplate.profMemberSeq) or (memberSeq eq detail.discussTemplate.regMemberSeq)}">
							<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
					<a href="#" onclick="doSelect();"
						class="btn blue"><span class="mid"><spring:message code="버튼:등록"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
</body>
</html>