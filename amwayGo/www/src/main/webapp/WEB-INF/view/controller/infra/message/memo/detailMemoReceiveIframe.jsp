<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forMemoCreate = null; 
var forDetail = null;
var forMemoCreate = null;

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
	forListdata.config.url    = "<c:url value="/usr/memo/receive/list/iframe.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/usr/memo/receive/detail/iframe.do"/>";
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormData"; 
	forDelete.config.url             = "<c:url value="/usr/memo/receive/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
		
	forMemoCreate = $.action("layer", {formId : "FormMemoCreate"});
	forMemoCreate.config.url = "<c:url value="/usr/message/group/send/popup.do"/>";
	forMemoCreate.config.options.width  = 600;
	forMemoCreate.config.options.height = 400;
	forMemoCreate.config.options.position = "middle";
	forMemoCreate.config.options.title  = "<spring:message code="글:쪽지:쪽지쓰기"/>";
	
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
	parent.onLoadIframe("frame-memo-receive");
};

/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 보낸사람에게 쪽지쓰기(답장하기)
 */
doMemoCreateReply = function(mapPKs) {
	forMemoCreate.run();
};
</script>
</head>

<body>

	<form id="FormMemoCreate" name="FormMemoCreate" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doCreateMemoComplete"/>
		<input type="hidden" name="memberSeq" value="<c:out value="${detail.messageSend.sendMemberSeq}" />">
		<input type="hidden" name="memberName" value="<c:out value="${detail.sendMember.memberName}" />">
		<input type="hidden" name="description" value="<c:out value="${detail.messageSend.description}" />">
		<input type="hidden" name="replyYn" value="Y" />
	</form>	

	<div style="display:none;">
		<c:import url="srchMemoReceive.jsp"/>
	</div>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="messageReceiveSeq" value="<c:out value="${detail.messageReceive.messageReceiveSeq}"/>"/>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:쪽지:보낸사람"/></th>
			<td><c:out value="${detail.sendMember.memberName}"/></td>
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
	</form>
		
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<a href="javascript:void(0)" onclick="doDelete()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
		</div>	
		<div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doMemoCreateReply()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:답장하기" /></span></a>
			<a href="javascript:void(0)" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
		 		
</body>
</html>