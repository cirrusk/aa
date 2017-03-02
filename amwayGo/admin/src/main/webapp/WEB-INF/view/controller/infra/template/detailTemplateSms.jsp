<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_MESSAGE_TEMPLATE_TYPE_NORMAL" value="${aoffn:code('CD.MESSAGE_TEMPLATE_TYPE.NORMAL')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forEdit        = null;
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
	forListdata.config.url    = "<c:url value="/template/sms/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/template/sms/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp" />

	<div style="display:none;">
		<c:import url="srchTemplate.jsp"/>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:템플릿:템플릿타입"/><span class="star">*</span></th>
			<td>
				<aof:code type="print" codeGroup="MESSAGE_TEMPLATE_TYPE" selected="${detail.template.templateTypeCd}" />
				<c:if test="${detail.template.templateTypeCd ne CD_MESSAGE_TEMPLATE_TYPE_NORMAL}">
					<span>
						<input type="checkbox" name="basicUseYn" value="Y" <c:out value="${detail.template.basicUseYn eq 'Y' ? 'checked' : ''}"/> disabled="disabled"/><spring:message code="필드:템플릿:기본템플릿적용"/>
					</span>
				</c:if>
			</td>
		</tr>	
		<tr>
			<th><spring:message code="필드:템플릿:제목"/></th>
			<td>
				<c:out value="${detail.template.templateTitle}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:구분"/></th>
			<td>
				<aof:code type="print" codeGroup="SMS_TYPE" selected="${detail.template.smsTypeCd}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:SMS내용"/></th>
			<td>
				<c:out value="${detail.template.templateContent1}"/>
				<c:if test="${!empty detail.template.templateContent2}">
					<c:out value="${detail.template.templateContent2}"/>
				</c:if>
				<c:if test="${!empty detail.template.templateContent3}">
					<c:out value="${detail.template.templateContent3}"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/></th>
			<td>
				<aof:code type="print" codeGroup="YESNO" removeCodePrefix="true" ref="2" selected="${detail.template.useYn}" />
			</td>
		</tr>
	</tbody>
	</table>
			
	<div class="lybox-btn">	
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'templateSeq' : '<c:out value="${detail.template.templateSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

</body>
</html>