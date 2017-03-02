<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdatePassword = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    if ("Y" == "<c:out value="${timeOver}"/>") {
        $.alert({
        	message : "<spring:message code="글:로그인:비밀번호변경가능한시간이지났습니다"/>",
            button1 : {
                callback : function() {
                    doClose();
                }
            }
        });
    }
    if ("Y" == "<c:out value="${invalid}"/>") {
        $.alert({
        	message : "<spring:message code="글:로그인:사용자가없거나정보가정확하지않습니다"/>",
            button1 : {
                callback : function() {
                    doClose();
                }
            }
        });
    }
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdatePassword = $.action("ajax", {formId : "FormUpdatePassword"});
	forUpdatePassword.config.type   = "json";
    forUpdatePassword.config.url             = "<c:url value="/member/password/update.do"/>";
    forUpdatePassword.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdatePassword.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdatePassword.config.fn.complete     = function(action, data) {
        if (data != null) {
            if (data.success == true) {
                $.alert({
                    message : "<spring:message code="글:저장되었습니다"/>",
                    button1 : {
                        callback : function() {
                            doClose();
                        }
                    }
                });
            } else {
                if (data.timeOver == "Y") {
                    $.alert({
                        message : "<spring:message code="글:로그인:비밀번호변경가능한시간이지났습니다"/>",
                        button1 : {
                            callback : function() {
                                doClose();
                            }
                        }
                    });
                } else if (data.invalid == "Y") {
                    $.alert({
                        message : "<spring:message code="글:로그인:사용자가없거나정보가정확하지않습니다"/>",
                        button1 : {
                            callback : function() {
                                doClose();
                            }
                        }
                    });
                } else {
                    $.alert({
                        message : "<spring:message code="글:로그인:저장되지않았습니다"/>",
                        button1 : {
                            callback : function() {
                                doClose();
                            }
                        }
                    });
                }
            }
        }
    };
    setValidate();  
};

setValidate = function() {
    forUpdatePassword.validator.set({
        title : "<spring:message code="필드:멤버:새비밀번호"/>",
        name : "password",
        data : ["!null", "!space"],
        check : {
            maxlength : 50,
            minlength : 6
        }
    });
    forUpdatePassword.validator.set({
        title : "<spring:message code="필드:멤버:비밀번호확인"/>",
        name : "verifyPassword",
        data : ["!null"]
    });
    forUpdatePassword.validator.set({
        message : "<spring:message code="글:멤버:비밀번호가일치하지않습니다"/>",
        name : "password",
        check : {
            eq : {name : "verifyPassword", title : ""}
        }
    });
};
/**
 * 새비밀번호 수정
 */
doUpdatePassword = function() {
    forUpdatePassword.run();
};
/**
 * 닫기
 */
doClose = function() {
    $layer.dialog("close");
};
</script>
</head>

<body>

<form id="FormUpdatePassword" name="FormUpdatePassword" method="post" onsubmit="return false;">
    <input type="hidden" name="memberId" value="<c:out value="${detail.memberId}"/>"/>
    <input type="hidden" name="memberSeq" value="<c:out value="${detail.memberSeq}"/>"/>
    <input type="hidden" name="signature" value="<c:out value="${param['signature']}"/>"/>
	
	<table class="tbl-detail">
		<colgroup>
			<col style="width:20%" />
			<col  />
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:멤버:비밀번호"/></th>
				<td>
					<input type="password" name="password" style="width:150px;">
					<span class="comment"><spring:message code="글:X자이상입력하십시오" arguments="6"/></span>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:멤버:비밀번호확인"/></th>
				<td>
					<input type="password" name="verifyPassword" style="width:150px;">
					<span class="comment"><spring:message code="글:멤버:비밀번호를다시한번입력하십시오" /></span>
				</td>
			</tr>
		</tbody>
	</table>
</form>
<div class="lybox-btn-r">
	<a href="javascript:void(0);" onclick="doUpdatePassword();" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
	<a href="javascript:void(0);" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소" /></span></a>
</div>
</body>
</html>