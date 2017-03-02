<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        <!-- TODO: 가이드의 제목을 기술합니다 -->
    </div>

    <div class="guide-desc">
        <!-- TODO: 가이드의 설명 기술합니다 -->
    </div>
</div>

<!-- TODO: 코드 항목(반복가능합니다)  -->
<!-- runnable 옵션 : 실행가능 한 코드에 대해서만 지정합니다 -->
<div class="guide-code runnable">
    <div class="desc">
<!-- TODO: 코드의 제목 또는 설명을 기술합니다 -->
    </div>

    <div class="java">
<!-- TODO: 코드 중 java 파트를 기술합니다 -->
    </div>
    
    <div class="javascript">
<!-- TODO: 코드 중 javascript 파트를 기술합니다: run 모드에서 eval() 로 실행 됩니다  -->
    </div>

    <div class="html">
<!-- 코드 중 html 파트를 기술합니다 -->
    </div>

    <div class="css">
<!-- TODO: 코드 중 css 파트를 기술합니다 -->
    </div>

    <div class="jsp">
<!-- 코드 중 jsp 파트를 기술합니다 -->
    </div>

    <div class="jsp-run">
<!-- 코드 중 jsp-run 파트를 기술합니다 : jsp 실행 결과, 실행화면에서 나타납니다. -->
        </div>
    </div>

    <div class="xml">
<!-- TODO: 코드 중 xml 파트를 기술합니다 -->
    </div>
    
    <div class="sql">
<!-- TODO: 코드 중 sql 파트를 기술합니다 -->
    </div>
    
</div>

</body>
</html>