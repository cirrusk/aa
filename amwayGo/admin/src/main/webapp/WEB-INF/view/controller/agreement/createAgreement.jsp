<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.editor.create("agreementText");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/agreement/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/agreement/insert.do"/>";
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
		title : "약관 타입",
		name : "agreementType",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:제목"/>",
		name : "agreementTitle",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "필수 여부",
		name : "agreementChek",
		data : ["!null"],
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "agreementText",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doInsert = function() { 
	
	UI.editor.copyValue();
	forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

</script>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>
	
	<div style="display:none;">
		<c:import url="srchAgree.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
		
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th>약관 타입</th>
			<td>
				<!-- <input type="text" name="agreementType" style="width:350px;"> -->
				<select name="agreementType">
					<c:forEach var="row" items="${codes}" varStatus="i">
						<option value="${row.codes}">${row.codeNames}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>
				<input type="text" name="agreementTitle" style="width:500px;">
			</td>
		</tr>
		<tr>
			<th>필수 여부</th>
			<td>
				<input type="radio" name="agreementChek" value="1" checked/>필수 &nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="agreementChek" value="2" />선택
			</td>
		</tr>
		<tr>
			<th>약관내용</th>
			<td>
				<input type="hidden" name="htmlYn" value="Y">
				<input type="hidden" name="editorPhotoInfo">
				<textarea name="agreementText" id="agreementText" style="width:98%; height:300px"></textarea>
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
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>