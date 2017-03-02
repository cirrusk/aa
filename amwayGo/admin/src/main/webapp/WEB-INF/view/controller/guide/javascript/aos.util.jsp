<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <!--  제목 -->
    <div class="guide-title">jquery.aos.util.js</div>

    <!--  설명 -->
    <div class="guide-desc">
        - aos의 util 함수
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.getById(id) - id로 html element를 가져온다.
    </div>

    <div class="html">
<div id="sample">샘플의 제목입니다</div>
<a href="javascript:void(0);" onclick="doTest()">찾기 클릭</a>
    </div>
    
    <div class="javascript">
doTest = function() {
    var sample = UT.getById("sample"); 
    alert(sample.innerHTML); // 샘플의 제목입니다
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.getRandomString(length) - length 만큼 랜덤 문자를 만든다
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest()">랜덤문자만들기 클릭</a>
    </div>
    
    <div class="javascript">
doTest = function() {
    var result = UT.getRandomString(10);
    alert(result); // 
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.getFilesize(size) - 파일 사이즈 표현
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest()">파일사이즈표현 클릭</a>
    </div>
    
    <div class="javascript">
doTest = function() {
    var result = UT.getFilesize(1234567);
    alert(result); // 1.1 MB
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.startsWithHangul(str) - 시작글자가 한글인지 검사
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest()">한글인지 클릭</a>
    </div>
    
    <div class="javascript">
doTest = function() {
    var result = UT.startsWithHangul('가abc');
    alert(result); // true
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.leftPad(str, size, padStr) - 주어진 문자열 왼쪽에 문자 채우기<br>
        UT.righttPad(str, size, padStr) - 주어진 문자열 오른쪽에 문자 채우기
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest1()">Left Pad 클릭</a>
<a href="javascript:void(0);" onclick="doTest2()">Right Pad 클릭</a>
    </div>
    
    <div class="javascript">
doTest1 = function() {
    var result = UT.leftPad('1', 5, '0');
    alert(result); // 00001
}
doTest2 = function() {
    var result = UT.rightPad('1', 5, '0');
    alert(result); // 10000
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.removeArray(array, item) - array의 item을 제거<br>
        UT.uniqueArray(array) - array의 item을 unique 하게 - 중복 요소 제거<br>
        UT.removeEmptyArray(array) - array의 empty 요소 제거 - (undefined 이거나 "")
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest1()">item을 제거 클릭</a>
<a href="javascript:void(0);" onclick="doTest2()">item을 unique 하게 클릭</a>
<a href="javascript:void(0);" onclick="doTest3()">empty 요소 제거 클릭</a>
    </div>
    
    <div class="javascript">
doTest1 = function() {
    var array = [1, 2, 3, 4, 5];
    var result = UT.removeArray(array, 3);
    alert(result); // 1,2,4,5
}
doTest2 = function() {
    var array = [1, 1, 2, 3, 3, 4, 1, 5, 4, 4];
    var result = UT.uniqueArray(array);
    alert(result); // 1,2,3,4,5
}
doTest3 = function() {
    var array = [1, , 3, 4, "", 5];
    var result = UT.removeEmptyArray(array);
    alert(result); // 1,3,4,5
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.getCheckedValue(formId, name, seperator) - 체크된 checkbox(radio)의 값을 리턴하는 함수<br>
        UT.getSelectedText(formId, name, seperator) - select 된 요소의 text 를 리턴하는 함수<br>
        UT.getSelectedValue(formId, name, seperator) - select 된 요소의 value 를 리턴하는 함수
    </div>

    <div class="html">
<form id="Form7">
    <div>
        <input type="checkbox" name="checkbox1" value="1">1
        <input type="checkbox" name="checkbox1" value="2">2
        <input type="checkbox" name="checkbox1" value="3">3
        <a href="javascript:void(0);" onclick="doTest1()">checkbox 클릭</a>
    </div>
    <div>
        <input type="radio" name="radio1" value="1">1
        <input type="radio" name="radio1" value="2">2
        <input type="radio" name="radio1" value="3">3
        <a href="javascript:void(0);" onclick="doTest2()">radio 클릭</a>
    </div>
    <div>
        <select name="select1">
            <option value="value1">text1</option>
            <option value="value2">text2</option>
            <option value="value3">text3</option>
        </select>
        <a href="javascript:void(0);" onclick="doTest3()">select text 클릭</a>
        <a href="javascript:void(0);" onclick="doTest4()">select value 클릭</a>
    </div>
    <div>
        <select name="select2" multiple="multiple" style="height:50px;">
            <option value="value1">text1</option>
            <option value="value2">text2</option>
            <option value="value3">text3</option>
        </select>
        <a href="javascript:void(0);" onclick="doTest5()">multiple select text 클릭</a>
        <a href="javascript:void(0);" onclick="doTest6()">multiple select value 클릭</a>
    </div>
</form>
    </div>
    
    <div class="javascript">
doTest1 = function() {
    var result = UT.getCheckedValue("Form7", "checkbox1", ",");
    alert(result); // checked values
}
doTest2 = function() {
    var result = UT.getCheckedValue("Form7", "radio1"); // radio 에서는 seperator 가 필요없다
    alert(result); // checked values
}
doTest3 = function() {
    var result = UT.getSelectedText("Form7", "select1"); // 단일 선택 selectbox에서는 seperator 가 필요없다
    alert(result); // selected values
}
doTest4 = function() {
    var result = UT.getSelectedValue("Form7", "select1"); // 단일 선택 selectbox에서는 seperator 가 필요없다
    alert(result); // selected values
}
doTest5 = function() {
    var result = UT.getSelectedText("Form7", "select2", ","); 
    alert(result); // selected values
}
doTest6 = function() {
    var result = UT.getSelectedValue("Form7", "select2", ","); 
    alert(result); // selected values
}
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        UT.formatDateToString(date, format) - Date를 format String 으로 리턴한다<br>
        UT.formatStringToDate(date) - 날짜 형식의 String 을 Date로 리턴한다
    </div>

    <div class="html">
<a href="javascript:void(0);" onclick="doTest1()">UT.formatDateToString 클릭</a>
<a href="javascript:void(0);" onclick="doTest2()">UT.formatStringToDate 클릭</a>
    </div>
    
    <div class="javascript">
doTest1 = function() {
    var date = new Date();
    var result = UT.formatDateToString(date, "yyyy-MM-dd HH:mm:ss"); 
    alert(result); // 2014-09-03 13:47:16 (현재시각)
}
doTest2 = function() {
    var strDate = "2014-09-03  00:47:16";
    var result = UT.formatStringToDate(strDate); 
    alert(result); // 
}
    </div>
</div>

</body>
</html>