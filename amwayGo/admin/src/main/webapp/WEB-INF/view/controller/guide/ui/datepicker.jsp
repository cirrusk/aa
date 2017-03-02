<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">Datepicker</div>

    <div class="guide-desc">
        - 입력 화면에서 달력으로 날짜를 선택한다
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        단일
    </div>

    <div class="html">
<input type="text" name="startDate" id="startDate" value="2014-09-01" class="datepicker" readonly="readonly"/>
    </div>
    
    <div class="javascript">
UI.datepicker("#startDate");
    </div>

</div>

<div class="guide-code runnable">
    <div class="desc">
        from ~ to : 시작일과 종료일을 선택할 때, 서로의 범위를 초과하지 않도록 설정하려고 할 때
    </div>

    <div class="html">
<input type="text" name="srchStartDate" id="srchStartDate" value="2014-09-10" class="datepicker" readonly="readonly"/>
<input type="text" name="srchEndDate" id="srchEndDate" value="2014-09-20" class="datepicker" readonly="readonly"/>
    </div>
    
    <div class="javascript">
UI.datepicker("#srchStartDate, #srchEndDate");
    </div>

</div>

</body>
</html>