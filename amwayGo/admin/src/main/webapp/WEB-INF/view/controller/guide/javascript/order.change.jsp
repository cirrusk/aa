<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        테이블 목록에서 항목의 순서 변경
    </div>

    <div class="guide-desc">
        테이블 목록 데이터에서 항목의 순서를 위로 아래로 순서를 변경한다
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        table의 tr의 순서변경
    </div>

    <div class="html">
<form id="Form1">
<table class="tbl-list">
<colgroup>
    <col style="width: 40px" />
    <col style="width: auto" />
</colgroup>
<thead>
    <tr>
        <th></th>
        <th>제목</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td><input type="checkbox" name="checkkeys"></td>
        <td>1. 첫번째 줄</td>
    </tr>
    <tr>
        <td><input type="checkbox" name="checkkeys"></td>
        <td>2. 두번째 줄</td>
    </tr>
    <tr>
        <td><input type="checkbox" name="checkkeys"></td>
        <td>3. 세번째 줄</td>
    </tr>
</tbody>
</table>
</form>
<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid">위로</span></a>
<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid">아래로</span></a>
    </div>

    <div class="javascript">
doUp = function() {
    var selects = [];
    jQuery("#Form1 :input[name=checkkeys]").filter(":checked").each(function() {
        selects.push(jQuery(this).closest("tr").get(0));
    });
    var firstRow = null;
    var table = null;
    jQuery(selects).each(function() {
        table = jQuery(this).closest("table").get(0);
        if (this.rowIndex == 1) {
            firstRow = this;
            return;
        } 
        UT.moveTableRow(table, this.rowIndex, this.rowIndex - 1);
    });
    if (firstRow != null) {
        UT.moveTableRow(table, firstRow.rowIndex, 1);
    }
};
doDown = function() {
    var selects = [];
    jQuery("#Form1 :input[name=checkkeys]").filter(":checked").each(function() {
        selects.push(jQuery(this).closest("tr").get(0));
    });
    var lastRow = null;
    var table = null;
    jQuery(selects.reverse()).each(function() {
        table = jQuery(this).closest("table").get(0);
        if (this.rowIndex == table.rows.length - 1) {
            lastRow = this;
            return;
        }
        UT.moveTableRow(table, this.rowIndex, this.rowIndex + 1);
    });
    if (lastRow != null) {
        UT.moveTableRow(table, lastRow.rowIndex, table.rows.length - 1);
    }
};
    </div>

</div>

</body>
</html>