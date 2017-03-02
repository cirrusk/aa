<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        XSS (Cross-site-scripting) 처리
    </div>

    <div class="guide-desc">
        크로스 사이트 스크립팅 처리 방법 
    </div>
</div>

<div class="guide-code">
    <div class="desc">
        (1). 파라미터로 전달되는 내용중에 <span class="red">&lt;script></span> 가 포함되어 있으면 error를 발생시킨다.<br>
        (2). <span class="red">callback</span> 이라는 파라미터의 값은 <span class="red">do</span>로 시작해야하고, <span class="red">세미콜론(;)</span> 이 없어야 한다. <br><br> 
        만약 &lt;script> 를 허용해야 하는 경우에는 <span class="red">aofNote</span> 파라미터에 세션유저의 <span class="red">memberSeq</span>를 인코딩(<span class="blue">aoffn:encryptSecure</span>)을 하고,<br>
        UIRequestFilter.java에서 해당 URL을 <span class="blue">XSS_EXCEPT_URL</span>에 추가한다.
    </div>

    <div class="jsp">
&lt;input type="hidden" name="aofNote" value="&lt;c:out value="&#36;{aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
    </div>

    <div class="java">
public final List&lt;Pattern> XSS_PATERNS = Arrays.asList(Pattern.compile("&lt;script", REGEX_FLAG));
public final List&lt;String> XSS_EXCEPT_URL = Arrays.asList("/lcms/resource/insertversion.do", "/lcms/organization/unzipfile.do", "/lcms/organization/insert.do");
    </div>

</div>

</body>
</html>