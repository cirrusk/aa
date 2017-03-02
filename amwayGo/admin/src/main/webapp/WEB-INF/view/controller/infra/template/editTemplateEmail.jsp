<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_MESSAGE_TYPE_EMAIL"           value="${aoffn:code('CD.MESSAGE_TYPE.EMAIL')}"/>
<c:set var="CD_MESSAGE_TEMPLATE_TYPE_NORMAL" value="${aoffn:code('CD.MESSAGE_TEMPLATE_TYPE.NORMAL')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// editor
	UI.editor.create("description");
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/template/email/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/template/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/template/delete.do"/>";
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
		title : "<spring:message code="필드:템플릿:제목"/>",
		name : "templateTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:템플릿:설명"/>",
		name : "templateDescription",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:템플릿:내용"/>",
		name : "templateContent1",
		data : ["!null"]
	});

};

/**
 * 저장
 */
doUpdate = function() { 
	// editor 값 복사
	UI.editor.copyValue();
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

</script>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp" />

	<div style="display:none;">
		<c:import url="srchTemplate.jsp"/>
	</div>
			
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="templateSeq" value="<c:out value="${detail.template.templateSeq}"/>"/>
	<input type="hidden" name="templateTypeCd" value="<c:out value="${detail.template.templateTypeCd}"/>"/>
	<input type="hidden" name="messageTypeCd" value="<c:out value="${CD_MESSAGE_TYPE_EMAIL}"/>"/>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th>
				<spring:message code="필드:템플릿:템플릿타입"/><span class="star">*</span>
			</th>
			<td>
				<aof:code type="print" codeGroup="MESSAGE_TEMPLATE_TYPE" selected="${detail.template.templateTypeCd}" />
				<c:if test="${detail.template.templateTypeCd ne CD_MESSAGE_TEMPLATE_TYPE_NORMAL}">
					<span>
						<input type="checkbox" id="basicUseYn" name="basicUseYn" value="Y" <c:out value="${detail.template.basicUseYn eq 'Y' ? 'checked' : ''}"/> /><spring:message code="필드:템플릿:기본템플릿적용"/>
						<div>
							<spring:message code="글:템플릿:기본템플릿적용체크시이전에사용하셨던템플릿의적용여부는미사용으로변경됩니다"/>
						</div>
					</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:제목"/><span class="star">*</span></th>
			<td>
				<input type="text" name="templateTitle" style="width:350px;" value="<c:out value="${detail.template.templateTitle}"/>" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:설명"/><span class="star">*</span></th>
			<td>
				<input type="text" name="templateDescription" style="width:550px;" value="<c:out value="${detail.template.templateDescription}"/>" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/></th>
			<td>
				<aof:code type="radio" codeGroup="YESNO" name="useYn" removeCodePrefix="true" selected="${detail.template.useYn}" ref="2" />
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code="필드:템플릿:내용"/><span class="star">*</span>
			</th>
			<td>
				<textarea name="templateContent1" id="description" style="width:100%; height:300px"><c:out value="${detail.template.templateContent1}"/></textarea>
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
	</form>
			
	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="templateSeq" value="<c:out value="${detail.template.templateSeq}"/>"/>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
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