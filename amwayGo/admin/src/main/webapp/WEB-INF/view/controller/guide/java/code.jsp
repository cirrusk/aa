<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        공통코드 사용
    </div>

    <div class="guide-desc">
        java에서 공통코드 사용
    </div>
</div>

<div class="guide-code">
    <div class="desc">
        code.properties 에 등록되어 있는 공통코드를 사용한다.
    </div>

    <div class="java">
private Codes codes = Codes.getInstance(); // 공통코드 프로퍼티

final String CD_SMS_TYPE_SHORT = codes.get("CD.SMS_TYPE.SHORT"); // 공통코드를 final String 으로 읽는다.

if (CD_SMS_TYPE_SHORT.equals(messageSendVO.getSmsTypeCd())) { // 사용

}
    </div>

</div>

</body>
</html>