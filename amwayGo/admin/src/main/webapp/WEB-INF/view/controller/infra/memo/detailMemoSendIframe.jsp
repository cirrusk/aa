<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forDelete = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doParentResize();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/message/send/list/iframe.do"/>";
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/message/sendmessage/delete.do"/>";
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
 * parent의 iframe 리사이즈 
 */
doParentResize = function() {
	parent.onLoadIframe("frame-memo-send");
};

/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
</script>
</head>

<body>

	<div style="display:none;">
		<c:import url="srchMemoSend.jsp"/>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:쪽지:받은사람"/></th>
			<td><c:out value="${param['receiveMemberNames']}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:전송일시"/></th>
			<td><aof:date datetime="${detail.messageSend.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:쪽지내용"/></th>
			<td style="line-height:22px;">
				<aof:text type="text" value="${detail.messageSend.description}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:첨부파일"/></th>
			<td>
				<c:forEach var="row" items="${detail.messageSend.attachList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
			</td>
		</tr>		
	</tbody>
	</table>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="messageSendSeq" value="<c:out value="${detail.messageSend.messageSendSeq}"/>"/>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDelete()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>		
		</div>	
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

</body>
</html>