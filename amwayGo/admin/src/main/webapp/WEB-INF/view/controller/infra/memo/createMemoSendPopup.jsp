<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;
var forBrowseMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	var receiver = [
<c:forEach var="row" items="${memoSends}" varStatus="i">
<c:if test="${!i.first}">,</c:if>
<c:if test="${!empty row.receiveMemberSeq}">
		{memberSeq : "<c:out value="${row.receiveMemberSeq}"/>",
		memberName : "<c:out value="${row.receiveMemberName}"/>",
		memberId : "<c:out value="${row.receiveMemberId}"/>"}
</c:if>
</c:forEach>
<c:if test="${empty memoSends}">
	{memberSeq : "<c:out value="${param['receiveMemberSeq']}"/>",
		memberName : "<c:out value="${param['receiveMemberName']}"/>",
		memberId : "<c:out value="${param['receiveMemberId']}"/>"}
</c:if>
	];
	
	if (receiver.length && receiver[0].memberSeq != "" && receiver[0].memberName != "") {
		doAddReceiver(receiver);
	}
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/memo/send/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:쪽지:쪽지를보내시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsertlist;

	forBrowseMember = $.action("layer");
	forBrowseMember.config.formId         = "FormBrowseMember";
	forBrowseMember.config.url            = "<c:url value="/memo/member/list/popup.do"/>";
	forBrowseMember.config.options.width  = 700;
	forBrowseMember.config.options.height = 500;
	forBrowseMember.config.options.title  = "<spring:message code="필드:쪽지:받는사람"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set(function() {
		var $form = jQuery("#" + forInsert.config.formId);
		if ($form.find(":input[name='receiveMemberSeqs']").length < 1) {
			$.alert({message : "<spring:message code="글:쪽지:받는사람을선택하십시오"/>"});
			return false;
		}
		return true;
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:쪽지:쪽지내용"/>",
		name : "memo",
		data : ["!null"]
	});

};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 목록삭제 완료
 */
doCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:쪽지:건의쪽지가발송되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				var par = $layer.dialog("option").parent;
				if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
					par["<c:out value="${param['callback']}"/>"].call(this);
				}
				$layer.dialog("close");
			}
		}
	});
};
/**
 * 받는사람찾기
 */
doBrowseMember = function() {
	forBrowseMember.run();
};
/**
 * 받는사람추가
 */
doAddReceiver = function(returnValue) {
	if (returnValue != null && returnValue.length) {
		var $receiver = jQuery("#receiver");
		var icon = '<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>';
		var $form = jQuery("#" + forInsert.config.formId);
		var receiveMemberSeqs = $form.find(":input[name='receiveMemberSeqs']");
		for (var index in returnValue) {
			var html = [];
			var setCheck = true;
			if(receiveMemberSeqs.length>0){
				receiveMemberSeqs.each(function(){
					var $this = jQuery(this);
					if($this.val() == returnValue[index].memberSeq){
						setCheck = false;
						return false;
					}
				});
			}
			if(setCheck){
				html.push("<li>" + icon + returnValue[index].memberName);
				html.push("(" + returnValue[index].memberId + ")");
				html.push("<input type='hidden' name='receiveMemberSeqs' value='" + returnValue[index].memberSeq + "'>");
				html.push("</li>");
				jQuery(html.join("")).appendTo($receiver);
			}
		}
	}
};
/**
 * 받는사람삭제
 */
doRemoveReceiver = function(icon) {
	var $icon = jQuery(icon);
	$icon.closest("li").remove();
};
</script>
<style type="text/css">
.receiver {}
.receiver img {line-height:22px; margin-right:3px; margin-bottom:3px;}
.receiver li {line-height:18px; margin-right:10px; float:left; }
</style>
</head>
<body>

	<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doAddReceiver"/>
		<input type="hidden" name="select" value="multiple"/>
	</form>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><a href="javascript:void(0)" onclick="doBrowseMember()" class="btn gray"><span class="small"><spring:message code="필드:쪽지:받는사람"/></span></a></th>
			<td><ul id="receiver" class="receiver"></ul></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:쪽지내용"/></th>
			<td><textarea name="memo" id="memo" style="width:95%; height:300px"></textarea></td>
		</tr>
	</tbody>
	</table>
	</form>

	<ul class="buttons">
		<li class="right">
			<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지보내기"/></span></a>
		</li>
	</ul>

	
</body>
</html>