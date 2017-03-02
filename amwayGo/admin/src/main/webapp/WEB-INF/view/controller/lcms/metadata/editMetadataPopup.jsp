<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdatelist = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/lcms/metadata/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:변경하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	forUpdatelist.validator.set({
		title : "<spring:message code="필드:변경할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

};
/**
 * 목록에서 수정할 때 호출되는 함수
 */
doUpdatelist = function() { 
	forUpdatelist.run();
};
/**
 * 목록변경 완료
 */
doCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가변경되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doClose();
			}
		}
	});
};
/**
 * 취소
 */
doClose = function() {
	$layer.dialog("close");
};
</script> 
</head>

<body>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="referenceSeq" value="<c:out value="${referenceSeq}"/>">
		<input type="hidden" name="referenceType" value="<c:out value="${referenceType}"/>">
		
		<table class="tbl-detail">
		<colgroup>
			<col style="width:50px" />
			<col style="width:150px" />
			<col/>
		</colgroup>
		<thead>
			<tr>
				<th class="align-c"><spring:message code="필드:번호"/></th>
				<th class="align-c"><spring:message code="필드:콘텐츠:데이터주제"/></th>
				<th class="align-c"><spring:message code="필드:콘텐츠:데이터값"/></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="row" items="${listMetadata}" varStatus="i">
				<tr>
					<td class="align-c"><c:out value="${i.count}"/></td>
					<td class="align-c"><c:out value="${row.metadataElement.metadataName}"/></td>
					<td class="align-c">
						<input type="hidden" name="metadataElementSeqs" value="<c:out value="${row.metadataElement.metadataElementSeq}"/>">
						<input type="hidden" name="metadataSeqs" value="<c:out value="${row.metadata.metadataSeq}"/>">
						<input type="text" name="metadataValues"  value="<c:out value="${row.metadata.metadataValue}"/>" style="width:90%">
					</td>
				</tr>
			</c:forEach>
		</tbody>
		</table>
	
	</form>	
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdatelist();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>