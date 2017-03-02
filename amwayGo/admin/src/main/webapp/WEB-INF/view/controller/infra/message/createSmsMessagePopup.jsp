<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SMS_TYPE_SHORT"    value="${aoffn:code('CD.SMS_TYPE.SHORT')}"/>
<c:set var="CD_SMS_TYPE_LONG"     value="${aoffn:code('CD.SMS_TYPE.LONG')}"/>
<c:set var="CD_SMS_TYPE_MMS"      value="${aoffn:code('CD.SMS_TYPE.MMS')}"/>
<c:set var="CD_MESSAGE_TYPE_SMS"  value="${aoffn:code('CD.MESSAGE_TYPE.SMS')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SMS_TYPE_SHORT = "<c:out value="${CD_SMS_TYPE_SHORT}"/>";
var CD_SMS_TYPE_LONG = "<c:out value="${CD_SMS_TYPE_LONG}"/>";

var forInsert   = null;
var forTemplateData = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/message/send/insert.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:sms:발송하시겠습니까?"/>"; 
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsertlist;
    setValidate();

    forTemplateData = $.action("ajax");
    forTemplateData.config.type        = "json";
    forTemplateData.config.formId      = "FormInsert";
    forTemplateData.config.url         = "<c:url value="/message/sms/create/ajax.do"/>";
    forTemplateData.config.fn.complete = function(action, data) {

    	if(data.templateDetail != null){
    		var form = UT.getById(forInsert.config.formId);
    		form.elements["description"].value = '';
    		
    		var message;
    		message = data.templateDetail.template.templateContent1 + data.templateDetail.template.templateContent2 + data.templateDetail.template.templateContent3;
    		form.elements["description"].value = message;
    		
    		$("#shotByte").show();
    		$("#longByte").hide();
    		templateMessageByte(message);
    		
    		var smsTypeVal = null;
    		if(data.templateDetail.template.smsTypeCd == CD_SMS_TYPE_SHORT){
    			smsTypeVal = 0;
    		}else{
    			smsTypeVal = 1;
    		}
    		$("input[name=tempSmsTypeCd]").eq(smsTypeVal).attr("checked", true); 
    		form.elements["smsTypeCd"].value = data.templateDetail.template.smsTypeCd;
    		
    	}else{
    		var form = UT.getById(forInsert.config.formId);
    		form.elements["description"].value = '';
    		
    		$("#shotByte").hide();
    		$("#longByte").show();
    		
    		document.getElementById('byteInfo').innerText = 0;
    	}
    };
  
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
		title : "<spring:message code="필드:이메일:내용"/>",
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
 * 닫기
 */
doCancel = function(){
	$layer.dialog("close");
};

/**
 * 템플릿 호출 내용 byte계산
 */
var maxByte = 2000;
templateMessageByte = function(message){
	var str = message;
 	var str_len = str.length;
 	var rbyte = 0;
 	var rlen = 0;
 	var one_char = "";
 	var str2 = "";
 	
 	for(var i=0; i<str_len; i++){
 		one_char = str.charAt(i);
 		if(escape(one_char).length > 4){
 	 		rbyte += 3; //한글3Byte
 		}else{
 	 		rbyte++; //영문 등 나머지 1Byte
 		}
 		
 		if(rbyte <= maxByte){
 	 		rlen = i+1; //return할 문자열 갯수
 		}
 	}
 	$('#byteInfo1').html(rbyte);
}

/**
 * 내용 byte제한
 */
doFnChkByte = function(obj) {
	var form = UT.getById(forInsert.config.formId);
		
	var str = obj.value;
 	var str_len = str.length;

 	var rbyte = 0;
 	var rlen = 0;
 	var one_char = "";
 	var str2 = "";
	
 	
 	for(var i=0; i<str_len; i++){
 		one_char = str.charAt(i);
 		if(escape(one_char).length > 4){
 	 		rbyte += 3; //한글3Byte
 		}else{
 	 		rbyte++; //영문 등 나머지 1Byte
 		}
 		
 		if(rbyte <= maxByte){
 	 		rlen = i+1; //return할 문자열 갯수
 		}
 	}
 	
 	if(rbyte > 80){ 
 		form.elements["smsTypeCd"].value = CD_SMS_TYPE_LONG;
 		$("input[name=tempSmsTypeCd]").eq(1).attr("checked", true);
		$("#shotByte").show();
		$("#longByte").hide();
 	} 
 	if(rbyte < 81){
 		form.elements["smsTypeCd"].value = CD_SMS_TYPE_SHORT;
 		$("input[name=tempSmsTypeCd]").eq(0).attr("checked", true);
		$("#shotByte").hide();
		$("#longByte").show();
 	} 
 	
 	if(rbyte > maxByte){
 		//alert("한글 "+(maxByte/3)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.");
 		str2 = str.substr(0,rlen); //문자열 자르기
 		obj.value = str2;
 		doFnChkByte(obj, maxByte);
 	}else{
 		$('#byteInfo').html(rbyte);
 		$('#byteInfo1').html(rbyte);
 	} 	
};

/**
 * 받는사람찾기(주소록)
 */
doBrowseMember = function() {
	FN.doOpenMemoMemberPopup({url:"<c:url value="/member/memo/list/popup.do"/>", title: "<spring:message code="필드:멤버:주소록"/>", callback:"doAddReceiver", messageType:"sms"});
};

/**
 * 받는사람추가
 */
doAddReceiver = function(returnValue) {
	if (returnValue != null && returnValue.length) {
		var $receiver = jQuery("#receiver");
		var icon = '<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle" />';
		var iconGroup = '<aof:img src="icon/tree_parent_closed_icon.gif" align="absmiddle" alt="그룹"/>';
		var $form = jQuery("#" + forInsert.config.formId);
		var addressGroupSeqs = $form.find(":input[name='addressGroupSeqs']");	
		var memberSeqs = $form.find(":input[name='memberSeqs']");
		var categorySeqs = $form.find(":input[name='categorySeqs']");	
		var memberCount = 0;
		var groupCount = 0;
		var categoryCount = 0;
		
		for (var index in returnValue) {
			var html = [];
			var setCheck = true;
		
			if(returnValue[index].addressGroupSeq != null){ //주소록그룹	 			
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
					html.push("<li>");				
					html.push("<input type='hidden' name='addressGroupSeqs' value='" + returnValue[index].addressGroupSeq + "'>");
					html.push("<input type='hidden' name='groupNames' value='" + returnValue[index].name + "'>");
					html.push("<input type='text' class='sms-telnumber' readonly='readonly' value='" + returnValue[index].name + "'/>" + " " + icon);
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					groupCount++;
				}//if	
			}else if (returnValue[index].memberSeq != null){ //개별
				if(returnValue[index].phoneMobile != '' && returnValue[index].phoneMobile != null){
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
						html.push("<li>");
						html.push("<input type='hidden' name='memberSeqs' value='" + returnValue[index].memberSeq + "'/>");
						html.push("<input type='hidden' name='memberNames' value='" + returnValue[index].memberName + "'/>");
						html.push("<input type='hidden' name='phoneMobiles' value='" + returnValue[index].phoneMobile + "'/>");
						html.push("<input type='text' class='sms-telnumber' readonly='readonly' value='" + returnValue[index].memberName + "(" + returnValue[index].phoneMobile + ")" + "'/>" + " " + icon);
						html.push("</li>" );
						jQuery(html.join("")).appendTo($receiver);
						memberCount++;
					}
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
					html.push("<li>");				
					html.push("<input type='hidden' name='categorySeqs' value='" + returnValue[index].categorySeq + "'>");
					html.push("<input type='hidden' name='categoryNames' value='" + returnValue[index].categoryName + "'>");
					html.push("<input type='text' class='sms-telnumber' readonly='readonly' value='" + returnValue[index].categoryName + "'/>" + " " + icon);
					html.push("</li>");
					jQuery(html.join("")).appendTo($receiver);
					categoryCount++;
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

/**
 * 템플릿 적용 셀렛트박스 변경시
 */
onChange = function(element) {
	var form = UT.getById(forInsert.config.formId);
	form.elements["templateSeq"].value = element.value;
	forTemplateData.run();
};

/**
 * smsType변경
 */
doChangeSmsTypeCd = function(element) {
	var form = UT.getById(forInsert.config.formId);
	form.elements["smsTypeCd"].value = element.value;
};

/**
 * 발송완료후
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
</script>

</head>

<body>

	<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doAddReceiver"/>
	</form>

    <aof:session key="phoneMobile" var="phoneMobile"/>
    <aof:session key="memberSeq" var="memberSeq"/>
    
    <form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <input type="hidden" name="sendMemberSeq" value="${memberSeq}"/>
    <input type="hidden" name="messageTypeCd" value="<c:out value="${CD_MESSAGE_TYPE_SMS}"/>"/>
    <input type="hidden" name="messageTitle" value="SMS"/>
    <input type="hidden" name="sendCount" value="0"/>
    <input type="hidden" name="referenceSeq" value="0"/>
    <input type="hidden" name="smsTypeCd" value="<c:out value="${CD_SMS_TYPE_SHORT}"/>"/>


	<div class="sms-send"><!--sms-send--> 
     <div class="sms-header"></div>  
     <div class="sms-content"> <!--sms-content--> 
         <div class="send">  
             <h1><spring:message code="필드:sms:보내는사람"/></h1>  
             <p>
            	<input type="text" class="sms-myname" name="phoneMobile" value="<c:out value="${phoneMobile}"/>" disabled="disabled">
             </p>  
             <div>  
                 <p><spring:message code="글:sms:단문바이트"/><br/><spring:message code="글:sms:장문바이트"/></p>  
                 <textarea name="description" id="description" style="width:98%; height:100px" onkeydown="doFnChkByte(this)"></textarea> 
                 <div id="longByte"> 
					<p>
						<span id="content"><spring:message code="글:sms:단문"/><span id="byteInfo">0</span>/<span id="smsType" class="txtred">2000</span>Byte</span>
					</p>
                 </div>
                 <div style="display: none;" id="shotByte">
                 	<p>
                 		<span class="txtred">
	            			<aof:code type="radio" codeGroup="SMS_TYPE" name="tempSmsTypeCd" defaultSelected="${CD_SMS_TYPE_LONG}" onclick="doChangeSmsTypeCd(this)" except="${CD_SMS_TYPE_MMS}" />
	            		</span>
	            		<span id="byteInfo1">0</span>/<span id="smsType" class="txtred">2000</span>Byte
            		</p>
                 </div>
             </div>  
             <p>
				<select name="templateSeq" onchange="onChange(this)">
					<option value=""><spring:message code="글:sms:사용자정의"/></option>
					<c:forEach var="row" items="${templateList.itemList}" varStatus="i">
						<option value="<c:out value="${row.template.templateSeq}"/>" <c:if test="${row.template.templateSeq eq emailTemplate}">selected</c:if> ><c:out value="${row.template.templateTitle}"/></option>
					</c:forEach>
				</select>                
				<a href="javascript:void(0)" onclick="doBrowseMember()" class="sms-address-btn">
					<span><spring:message code="버튼:sms:주소록"/></span>
				</a> 
             </p>  
         </div>  
         <div class="receive"> 
             <h1><spring:message code="필드:sms:받는사람"/></h1>  
	         <ol class="receiver" id="receiver"> 
		         <c:forEach var="row" items="${AddList}" varStatus="i">
		          	<li>
						<input type="hidden" name="memberSeqs" value="${row.memberSeq}">
						<input type="hidden" name="memberNames" value="${row.memberName}">
						<input type="hidden" name="phoneMobiles" value="${row.phoneMobile}">
						<input type="text" class="sms-telnumber" value="${row.memberName} (${row.phoneMobile})" readonly="readonly"/>
						<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
		          	</li>
				 </c:forEach>               		
				 <c:forEach var="row" items="${GroupList}" varStatus="i">
					<li>
						<input type="hidden" name="addressGroupSeqs" value="${row.addressGroupSeq}">
						<input type="hidden" name="groupNames" value="${row.groupName}">
						<input type="text" class="sms-telnumber" value="${row.groupName}" readonly="readonly"/>
						<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
					</li>
				 </c:forEach>
				 <c:forEach var="row" items="${CategoryList}" varStatus="i">
					<li>
						<input type="hidden" name="categorySeqs" value="${row.categorySeq}">
						<input type="hidden" name="categoryNames" value="${row.categoryName}">
						<input type="text" class="sms-telnumber" value="${row.categoryName}" readonly="readonly"/>
						<aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
					</li>
				 </c:forEach>
             </ol>  
     	</div>

     <div class="sms-footer"> <!-- sms-footer --> 
         <a href="#" class="sms-send-btn" onclick="doInsert();"><span><spring:message code="버튼:sms:보내기"/></span></a>  
         <a href="#" class="sms-cancel-btn" onclick="doCancel();"><span><spring:message code="버튼:sms:취소"/></span></a>  
     </div><!-- //sms-foorer --> 
 </div><!--//sms-send--> 

</body>
</html>