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
	forListdata.config.url    = "<c:url value="/template/email/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/template/email/edit.do"/>";
	
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
			<th><spring:message code="필드:템플릿:제목"/><span class="star">*</span></th>
			<td>
				<c:out value="${detail.template.templateTitle}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:설명"/><span class="star">*</span></th>
			<td>
				<c:out value="${detail.template.templateDescription}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/></th>
			<td>
				<aof:code type="print" codeGroup="YESNO" removeCodePrefix="true" ref="2" selected="${detail.template.useYn}" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:내용"/><span class="star">*</span></th>
			<td>
				<aof:text type="whiteTag" value="${detail.template.templateContent1}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:코드안내"/></th>
			<td>
				<ul class="code-info">
					<li><span class="section-btn blue02"><spring:message code="필드:템플릿:코드이름"/></span> <spring:message code="필드:템플릿:코드이름내용"/></li>
					<li><span class="section-btn green"><spring:message code="필드:템플릿:코드학과"/></span> <spring:message code="필드:템플릿:코드학과내용"/></li>
					<li><span class="section-btn red"><spring:message code="필드:템플릿:코드아이디"/></span> <spring:message code="필드:템플릿:코드아이디내용"/></li>
				</ul> 
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