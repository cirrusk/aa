<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_MESSAGE_TYPE_MEMO"  value="${aoffn:code('CD.MESSAGE_TYPE.MEMO')}"/>

<html>
<c:set var="attachSize" value="10"/>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "<c:out value='${attachSize}'/>MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);	
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/message/send/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:쪽지:쪽지를보내시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = doCompleteInsertlist;
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set(function() {
		var sumResult = 0;
		var $form = jQuery("#" + forInsert.config.formId);
		sumResult = $form.find(":input[name='addressGroupSeqs']").length + $form.find(":input[name='memberSeqs']").length
					+ $form.find(":input[name='messageSendSeqs']").length + $form.find(":input[name='categorySeqs']").length;

		if (sumResult< 1) {
			$.alert({message : "<spring:message code="글:쪽지:받는사람을선택하십시오"/>"});
			return false;
		}
		return true;
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:쪽지:쪽지내용"/>",
		name : "description",
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
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	return true;
};

/**
 * 목록삭제 완료
 */
doCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:쪽지:발송되었습니다"/>",
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
	FN.doOpenMemoMemberPopup({url:"<c:url value="/member/memo/list/popup.do"/>", title: "<spring:message code="필드:멤버:주소록"/>", callback:"doAddReceiver"});
};
/**
 * 받는사람추가
 */
doAddReceiver = function(returnValue) {
	if (returnValue != null && returnValue.length) {
		var $receiver = jQuery("#receiver");
		var icon = '<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>';
		var iconGroup = '<aof:img src="icon/tree_parent_closed_icon.gif" align="absmiddle" alt="그룹"/>';
		var $form = jQuery("#" + forInsert.config.formId);
		var addressGroupSeqs = $form.find(":input[name='addressGroupSeqs']");	
		var memberSeqs = $form.find(":input[name='memberSeqs']");
		var messageSendSeqs = $form.find(":input[name='messageSendSeqs']");
		var categorySeqs = $form.find(":input[name='categorySeqs']");	
		var memberCount =0;
		var groupCount =0;
		var messageSendCount =0;
		var categoryCount = 0;
		
		for (var index in returnValue) {
			var html = [];
			var setCheck = true;			
			if(returnValue[index].addressGroupSeq != null){				
				if(addressGroupSeqs.length>0){
					addressGroupSeqs.each(function(){
						var $this = jQuery(this);
						if($this.val() == returnValue[index].addressGroupSeq){
							setCheck = false;
							return false;
						}
					});
				}//if		
				if(setCheck){
					html.push("<li>" + icon + iconGroup + returnValue[index].name  );				
					html.push("<input type='hidden' name='addressGroupSeqs' value='" + returnValue[index].addressGroupSeq + "'>");
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					groupCount++;
				}//if	
			}else if (returnValue[index].memberSeq != null){
				if(memberSeqs.length>0){
					memberSeqs.each(function(){
						var $this = jQuery(this);
						if($this.val() == returnValue[index].memberSeq){
							setCheck = false;
							return false;
						}
					});
				}//if
				if(setCheck){
					html.push("<li>" + icon + returnValue[index].memberName);				
					html.push("<input type='hidden' name='memberSeqs' value='" + returnValue[index].memberSeq + "'>");
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					memberCount++;
				}
			}else if(returnValue[index].categorySeq != null){  //단체발송
				if(categorySeqs.length>0){
					categorySeqs.each(function(){
						var $this = jQuery(this);
						if($this.val() == returnValue[index].categorySeq){
							setCheck = false;
							return false;
						}
					});
				}//if
				if(setCheck){
					html.push("<li>" + icon + iconGroup + returnValue[index].categoryName);				
					html.push("<input type='hidden' name='categorySeqs' value='" + returnValue[index].categorySeq + "'>");
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					categoryCount++;
				}	
			}else {
				if(messageSendSeqs.length>0){
					messageSendSeqs.each(function(){
						var $this = jQuery(this);
						if($this.val() == returnValue[index].messageSendSeq){
							setCheck = false;
							return false;
						}
					});
				}//if
				if(setCheck){
					html.push("<li>" + icon + returnValue[index].memberName);				
					html.push("<input type='hidden' name='messageSendSeqs' value='" + returnValue[index].messageSendSeq + "'>");
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					messageSendCount++;
				}
			}
		}
		
		if(groupCount >0){
			$.alert({
				message : "<spring:message code="글:쪽지:건의그룹이추가되었습니다"/>".format({0:groupCount}),
				button1 : {
					callback : function() {
					
					}
				}
			});
		}else if(memberCount > 0){
			$.alert({
				message : "<spring:message code="글:쪽지:명이추가되었습니다"/>".format({0:memberCount}),
				button1 : {
					callback : function() {
					
					}
				}
			});
		}else if(categoryCount > 0){
			$.alert({
				message : "<spring:message code="글:쪽지:건의단체발송이추가되었습니다"/>".format({0:categoryCount}),
				button1 : {
					callback : function() {
					
					}
				}
			});
		}else if(messageSendCount > 0){
			$.alert({
				message : "<spring:message code="글:쪽지:건의단체발송이추가되었습니다"/>".format({0:messageSendCount}),
				button1 : {
					callback : function() {
					
					}
				}
			});
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

<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>
<body>
	
	<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doAddReceiver"/>
	</form>
			
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="messageTypeCd" value="<c:out value="${CD_MESSAGE_TYPE_MEMO}"/>">
	<input type="hidden" name="messageTitle" value="<spring:message code="글:쪽지:타이틀"/>">
	<table class="tbl-detail" >
	<colgroup>
		<col style="width: 100px" />
		<col style="width: auto" />
		<col style="width: 110px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:쪽지:받는사람"/></th>
			<td><ul id="receiver" class="receiver">
					<c:forEach var="row" items="${GroupList}" varStatus="i">
						<li>
							<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
							<aof:img src="icon/tree_parent_closed_icon.gif" align="absmiddle" alt="그룹"/>
							<input type="hidden" name="addressGroupSeqs" value="${row.addressGroupSeq}">
							<c:out value="${row.groupName}"/>
						</li>
					</c:forEach>
					<c:forEach var="row" items="${AddList}" varStatus="i">
						<li>
							<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
							<input type="hidden" name="memberSeqs" value="${row.memberSeq}">
							<c:out value="${row.memberName}"/>
						</li>
					</c:forEach>
					<c:forEach var="row" items="${ReceiveGroupList}" varStatus="i">
						<li>
							<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
							<input type="hidden" name="messageSendSeqs" value="${row.messageSendSeq}">
							<c:out value="${row.memberName}"/>
						</li>
					</c:forEach>
				</ul>
			</td>
			<c:choose>
				<c:when test="${param['replyYn'] eq 'Y'}">
					<td style="border-left-style: hidden; vertical-align: top;"></td>
				</c:when>
				<c:otherwise>
					<td style="border-left-style: hidden; vertical-align: top;"><a href="javascript:void(0)" onclick="doBrowseMember()" class="btn gray"><span class="small"><spring:message code="버튼:쪽지:주소록"/></span></a></td>
				</c:otherwise>
			</c:choose>			
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:쪽지내용"/></th>
			<td colspan="2"><textarea name="description" id="description" style="width:95%; height:100px"></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:쪽지:첨부파일"/></th>
			<td colspan="2">
				<input type="hidden" name="attachUploadInfo"/>
				<div id="uploader" class="uploader"></div>
				<span class="vbom"><c:out value="${attachSize}"/>MB</span>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

   <div class="lybox-btn">
	 <div class="lybox-btn-r">
		<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지보내기"/></span></a>
	 </div>		
   </div>
   
</body>
</html>