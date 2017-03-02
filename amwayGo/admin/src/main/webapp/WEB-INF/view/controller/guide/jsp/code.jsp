<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        공통코드 taglib
    </div>

    <div class="guide-desc">
        jsp에서 공통코드 커스텀 태그를 이용하여 사용한다 
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        radio 버튼을 생성한다.
    </div>

    <div class="jsp">
&lt;aof:code codeGroup="YESNO" type="radio" name="yesno" selected="YESNO::Y"/>
    </div>

    <div class="jsp-run">
        <aof:code codeGroup="YESNO" type="radio" name="yesno" selected="YESNO::Y"/>
    </div>

</div>

<div class="guide-code runnable">
    <div class="desc">
        checkbox 버튼을 생성한다.
    </div>

    <div class="jsp">
&lt;aof:code codeGroup="YESNO" type="checkbox" name="yesno" selected="YESNO::Y"/>
    </div>

    <div class="jsp-run">
        <aof:code codeGroup="YESNO" type="checkbox" name="yesno" selected="YESNO::Y"/>
    </div>

</div>

<div class="guide-code runnable">
    <div class="desc">
        combobox 를 생성한다.
    </div>

    <div class="jsp">
&lt;select name="yesno">
    &lt;aof:code codeGroup="YESNO" type="option" selected="YESNO::Y"/>
&lt;/select>
    </div>

    <div class="jsp-run">
        <select name="yesno">
            <aof:code codeGroup="YESNO" type="option" selected="YESNO::Y"/>
        </select>
    </div>

</div>

</body>
</html>