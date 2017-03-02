<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SMS_TYPE_SHORT"               value="${aoffn:code('CD.SMS_TYPE.SHORT')}"/>
<c:set var="CD_SMS_TYPE_LONG"                value="${aoffn:code('CD.SMS_TYPE.LONG')}"/>
<c:set var="CD_SMS_TYPE_MMS"                 value="${aoffn:code('CD.SMS_TYPE.MMS')}"/>
<c:set var="CD_MESSAGE_TYPE_SMS"             value="${aoffn:code('CD.MESSAGE_TYPE.SMS')}"/>
<c:set var="CD_MESSAGE_TEMPLATE_TYPE_NORMAL" value="${aoffn:code('CD.MESSAGE_TEMPLATE_TYPE.NORMAL')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SMS_TYPE_SHORT = "<c:out value="${CD_SMS_TYPE_SHORT}"/>";
var CD_SMS_TYPE_LONG = "<c:out value="${CD_SMS_TYPE_LONG}"/>";
var CD_MESSAGE_TEMPLATE_TYPE_NORMAL = "<c:out value="${CD_MESSAGE_TEMPLATE_TYPE_NORMAL}"/>";

var forListdata = null;
var forInsert   = null;
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
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/template/insert.do"/>";
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
		title : "<spring:message code="필드:템플릿:제목"/>",
		name : "templateTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:템플릿:구분"/>",
		name : "smsTypeCd",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:템플릿:내용"/>",
		name : "templateContent1",
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
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

var maxByte = "80";
var minByte = "0";
doSmsTypeSelect = function(value){
	if(CD_SMS_TYPE_SHORT == value){
		
		jQuery('#textContent1').val('');
		document.getElementById('byteInfo1').innerText = minByte;
		
		jQuery('#templateContent2').show();
		jQuery('#content2').show();
		jQuery('#templateContent3').show();
		jQuery('#content3').show();
		
		maxByte = "80";
		document.getElementById('smsType').innerText = maxByte;
	}else if(CD_SMS_TYPE_LONG == value){
				
		jQuery('#textContent1').val('');
		jQuery('#textContent2').val('');
		jQuery('#textContent3').val('');
		document.getElementById('byteInfo1').innerText = minByte;
		document.getElementById('byteInfo2').innerText = minByte;
		document.getElementById('byteInfo3').innerText = minByte;
		
		jQuery('#templateContent2').hide();
		jQuery('#content2').hide();
		jQuery('#templateContent3').hide();
		jQuery('#content3').hide();
		
		maxByte = "2000";
		document.getElementById('smsType').innerText = maxByte;
	}
};


/**
 * 내용byte제한
 */
doFnChkByte = function(obj) {
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

	if(rbyte > maxByte){
		//alert("한글 "+(maxByte/3)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.");
		str2 = str.substr(0,rlen); //문자열 자르기
		obj.value = str2;
		doFnChkByte(obj, maxByte);
	}else{
		document.getElementById('byteInfo'+obj.name.substring(15)).innerText = rbyte;
	}
	
	
};

/**
 * 템플릿 타입변경시
 */
doSelectTemplateType = function(element) {
	var TemplateType = element.value;

	if(TemplateType == CD_MESSAGE_TEMPLATE_TYPE_NORMAL){
				
		$("#basicUseYn").val('N');
		$("#basicUseYn").val('N').attr("checked",false);
		$("#check").hide();
		
		$("#smsShot").hide();
		$("#smsSelete").show();

	}else {
		
		$("#basicUseYn").val('Y');
		$("#basicUseYn").val('Y').attr("checked",false);
		$("#check").show();
		
		$("input[name=smsTypeCd]:eq(0)").attr("checked",true);
		$("#smsSelete").hide();		
		$("#smsShot").show();		
	}
		
	jQuery('#textContent1').val('');
	jQuery('#textContent2').val('');
	jQuery('#textContent3').val('');
	document.getElementById('byteInfo1').innerText = minByte;
	document.getElementById('byteInfo2').innerText = minByte;
	document.getElementById('byteInfo3').innerText = minByte;
	
	jQuery('#templateContent2').show();
	jQuery('#content2').show();
	jQuery('#templateContent3').show();
	jQuery('#content3').show();
	
	maxByte = "80";
	document.getElementById('smsType').innerText = maxByte;

};

</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp" />
			
	<div style="display:none;">
		<c:import url="srchTemplate.jsp"/>
	</div>
			
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="messageTypeCd" value="<c:out value="${CD_MESSAGE_TYPE_SMS}"/>"/>

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
				<select id="templateTypeCd" name="templateTypeCd" class="select" onchange="doSelectTemplateType(this)";>
					<aof:code type="option" codeGroup="MESSAGE_TEMPLATE_TYPE"/>
				</select>
				<span id="check" style="display:none"; >
					<input type="checkbox" id="basicUseYn" name="basicUseYn" value="N" /><spring:message code="필드:템플릿:기본템플릿적용"/>
					<div>
						<spring:message code="글:템플릿:기본템플릿적용체크시이전에사용하셨던템플릿의적용여부는미사용으로변경됩니다"/>
					</div>
				</span>			
			</td>
		</tr>	
		<tr>
			<th><spring:message code="필드:템플릿:제목"/><span class="star">*</span></th>
			<td>
				<input type="text" name="templateTitle" style="width:350px;">
			</td>
		</tr>
			<tr>
				<th><spring:message code="필드:템플릿:구분"/><span class="star">*</span></th>
				<td>
					<span id="smsSelete">
						<aof:code type="radio" codeGroup="SMS_TYPE" name="smsTypeCd" except="${CD_SMS_TYPE_MMS}" defaultSelected="${CD_SMS_TYPE_SHORT}" onclick="doSmsTypeSelect(this.value)" />
					</span>
					<span id="smsShot" style="display: none">
						<aof:code type="print" codeGroup="SMS_TYPE" except="${CD_SMS_TYPE_MMS}" defaultSelected="${CD_SMS_TYPE_SHORT}"/>
					</span>
				</td>
			</tr>
		<tr>
			<th><spring:message code="필드:템플릿:SMS내용"/><span class="star">*</span></th>
			<td>
				<ul class="sms-area">
					<li>
						<textarea class="sms-textarea" name="templateContent1" id="textContent1" onKeyUp="javascript:doFnChkByte(this)"></textarea>
						<p id="content1"><span id="byteInfo1">0</span>/<span id="smsType">80</span>Byte</p>
					</li>
					<li id="templateContent2">
						<textarea class="sms-textarea" name="templateContent2" id="textContent2" onKeyUp="javascript:doFnChkByte(this)"></textarea>
						<p id="content2"><span id="byteInfo2">0</span>/<span id="smsType">80</span>Byte</p>
					</li>
					<li id="templateContent3">
						<textarea class="sms-textarea" name="templateContent3" id="textContent3" onKeyUp="javascript:doFnChkByte(this)"></textarea>
						<p id="content3"><span id="byteInfo3">0</span>/<span id="smsType">80</span>Byte</p>
					</li>
				</ul>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/></th>
			<td>
				<aof:code type="radio" codeGroup="YESNO" name="useYn" removeCodePrefix="true" defaultSelected="N" ref="2" />
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