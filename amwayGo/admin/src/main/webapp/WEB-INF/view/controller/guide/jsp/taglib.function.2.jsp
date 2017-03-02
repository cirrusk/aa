<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        jsp에서 taglib function 사용 (2)
    </div>

    <div class="guide-desc">
        커스텀 function을 사용한다.
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        aoffn:toInt(Object) - 숫자형 데이터를 Integer 형식으로 변환한다
    </div>

    <div class="jsp">
&lt;c:out value="&#36;{aoffn:toInt('10000') + 100}"/> // 10100
    </div>

    <div class="jsp-run">
<c:out value="${aoffn:toInt('10000') + 100}"/>
        </div>
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        aoffn:toDouble(Object) - 숫자형 데이터를 double 형식으로 변환한다
    </div>

    <div class="jsp">
&lt;c:out value="&#36;{aoffn:toDouble('12345')}"/>
&lt;c:out value="&#36;{aoffn:toDouble(12345)}"/>
    </div>

    <div class="jsp-run">
<c:out value="${aoffn:toDouble('12345')}"/><br>
<c:out value="${aoffn:toDouble(12345)}"/>
        </div>
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        aoffn:trimDouble(Object) - 숫자형 데이터를 double 형식으로 변환 후, 소수점 이하가 0이면 소수점 이하를 생략한다.
    </div>

    <div class="jsp">
&lt;c:out value="&#36;{aoffn:trimDouble('12345.0')}"/> // 12345
    </div>

    <div class="jsp-run">
<c:out value="${aoffn:trimDouble('12345.0')}"/>
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        aoffn:toMMSS(long) - 1000분의 1초 단위의 값을 MM : ss로 리턴한다.
    </div>

    <div class="jsp">
&lt;c:set var="mmss" value="&#36;{aoffn:toMMSS(400000)}"/>
&lt;c:out value="&#36;{mmss.MM}"/>분 &lt;c:out value="&#36;{mmss.SS}"/>초 // 6분 40초
    </div>

    <div class="jsp-run">
<c:set var="mmss" value="${aoffn:toMMSS(400000)}"/>
<c:out value="${mmss.MM}"/>분 <c:out value="${mmss.SS}"/>초 
    </div>
</div>

</body>
</html>