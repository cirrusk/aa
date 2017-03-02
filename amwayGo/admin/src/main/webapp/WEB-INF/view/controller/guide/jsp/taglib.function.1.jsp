<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        jsp에서 taglib function 사용 (1)
    </div>

    <div class="guide-desc">
        커스텀 function을 사용한다.
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        String aoffn:config(String) - config.???.xml에 설정된 환경변수 읽기 - 단일항목
    </div>

    <div class="xml">
<domain>
    <www>http://www.4csoft.co.kr</www>
    <web>http://web.4csoft.co.kr</web>
    ...
</domain>
    </div>

    <div class="jsp">
&lt;c:out value="&#36;{aoffn:config('domain.web')}"/>
    </div>

    <div class="jsp-run">
<c:out value="${aoffn:config('domain.web')}"/>
        </div>
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        List aoffn:configList(String) - config.???.xml에 설정된 환경변수 읽기 - 목록항목
    </div>

    <div class="xml">
<upload>
    <mimeTypes>
        <white>video/x-msvideo</white>
        <white>video/x-ms-wmv</white>
        <white>application/zip</white>
        ...
    </mimeTypes>
</upload>
    </div>

    <div class="jsp">
&lt;c:forEach var="row" items="&#36;{aoffn:configList('upload.mimeTypes.white')}" varStatus="i">
    <div>&lt;c:out value="&#36;{row}"/></div>
&lt;/c:forEach>
    </div>

    <div class="jsp-run">
<c:forEach var="row" items="${aoffn:configList('upload.mimeTypes.white')}" varStatus="i">
    <div><c:out value="${row}"/></div>
</c:forEach>
        </div>
    </div>
</div>


<div class="guide-code runnable">
    <div class="desc">
        String aoffn:code(String) - 코드값 읽기
    </div>

    <div class="jsp">
&lt;c:out value="&#36;{aoffn:code('CD.YESNO.Y')}"/>
&lt;c:out value="&#36;{aoffn:code('CD.ROLE.ADM')}"/>
    </div>

    <div class="jsp-run">
<c:out value="${aoffn:code('CD.YESNO.Y')}"/><br>
<c:out value="${aoffn:code('CD.ROLE.ADM')}"/>
    </div>
</div>

<div class="guide-code">
    <div class="desc">
        boolean aoffn:accessible(RolegroupMenuVO, String) - 접근권한검사 - 주어진 롤그룹메뉴에 해당 권한이 있는지 검사.
    </div>

    <div class="jsp">
&lt;c:if test="&#36;{aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
    <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
&lt;/c:if>
    </div>

</div>

</body>
</html>