<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert = null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/message/push/insert.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:push:메시지를보내시겠습니까"/>"; 
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsert.config.fn.complete     = doCompleteInsertlist;
    
    setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    forInsert.validator.set({
        title : "<spring:message code="필드:push:내용"/>",
        name : "pushMessage",
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
 * 받는사람삭제
 */
doRemoveReceiver = function(icon) {
    var $icon = jQuery(icon);
    
    if($("#receiver").find("span").length > 1){
    	$icon.closest("span").remove();	
    } else {
    	$.alert({message : "<spring:message code="글:push:더이상지울수없습니다"/>"});
    }
};

/**
 * 내용 byte제한
 */
doFnChkByte = function(obj) {
    var str = obj.value;
    var str_len = str.length;

    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";
    var maxByte = 1000;
    
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
        str2 = str.substr(0,rlen); //문자열 자르기
        obj.value = str2;
        doFnChkByte(obj, maxByte);
    } else {
        $('#byteInfo').html(rbyte);
    }   
};

/**
 * 발송완료후
 */
doCompleteInsertlist = function(success) {
    $.alert({
        message : "<spring:message code="글:push:발송되었습니다"/>",
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
            
    <form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <table class="tbl-detail" >
    <colgroup>
        <col style="width: 100px" />
        <col style="width: auto" />
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:쪽지:받는사람"/></th>
            <td>
                <ul id="receiver" class="receiver">
                    <c:forEach var="row" items="${pushMessages}" varStatus="i">
                        <span>
                           <input type="hidden" name="memberSeqs" value="${row.memberSeq}">
                           <c:out value="${row.memberName}"/>
                           <aof:img src="common/x_01.gif" onclick="doRemoveReceiver(this)" align="absmiddle"/>
                           <c:if test="${!i.last}">,</c:if>
                        </span>
                    </c:forEach>
                </ul>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:push:내용"/></th>
            <td>
                <textarea name="pushMessage" id="pushMessage" style="width:95%; height:100px" onkeydown="doFnChkByte(this)"></textarea>
                <div id="longByte"> 
                    <p>
                        <span id="content"><span id="byteInfo">0</span>/<span id="smsType" class="txtred">800</span>Byte</span>
                    </p>
                 </div>    
            </td>
        </tr>
    </tbody>
    </table>
    </form>

   <div class="lybox-btn">
     <div class="lybox-btn-r">
        <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:push:PUSH보내기"/></span></a>
     </div>     
   </div>
</body>
</html>