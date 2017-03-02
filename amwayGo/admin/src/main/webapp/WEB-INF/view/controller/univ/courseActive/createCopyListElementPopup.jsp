<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forCourseActivePopup = null;
var forInsert   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forInsert = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/univ/courseactive/copy/save.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:개설과목:복사하시겠습니까?"/>"; 
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsert.config.fn.complete     = function() {
    	$.alert({
            message : "<spring:message code="글:개설과목:복사되었습니다."/>",
            button1 : {
                callback : function() {
                	var par = $layer.dialog("option").parent;
                    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
                        par["<c:out value="${param['callback']}"/>"].call(this);
                    }
                    $layer.dialog("close");
                }
            }
        });
    };
    
    forCourseActivePopup = $.action("layer");
    forCourseActivePopup.config.formId = "FormData";
    forCourseActivePopup.config.url    = "<c:url value="/univ/courseactive/list/popup.do"/>";
    forCourseActivePopup.config.options.width = 650;
    forCourseActivePopup.config.options.height = 450;
    forCourseActivePopup.config.options.title = "<spring:message code="필드:개설과목:개설과목"/>";

    setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:구성정보"/>",
        name : "courseElementTypes",
        data : ["!null"]
    });

};
/**
 * 개설과목 구성정보 복사
 */
doInsert = function() {
    forInsert.run();
};

doClose = function(){
    $layer.dialog("close");
};

/**
 * 삭제
 */
doDelete = function(){
	if($("input[name=checkkeys]:checked").length < 1) {
		$.alert({
            message : "<spring:message code="글:개설과목:삭제할과목을선택하십시오."/>",
            button1 : {
                callback : function() {
                	$("input[name=checkkeys]").eq(0).focus();
                }
            }
        });
	} else {
		$("input[name=checkkeys]:checked").each(function(){
	        var checkVal = $(this).val();
	        $("#"+checkVal).remove();
	    });
	    
	    var copyCount = $("input[name=checkkeys]").length;
	    $("#copyCount").html(copyCount);
	    
	    if(copyCount < 1){
	        $("#buttonArea").hide();
	    }
	}
};

/**
 * 개설과정 검색 팝업
 */
doCourseActivePopup = function(index){
	$("input[name=rowIdx]").val(index);
	forCourseActivePopup.run();
}

doChangeCourseActive = function(mapPKs){
	$("#source_"+mapPKs.rowIdx).val(mapPKs.courseActiveSeq);
	$("#td_"+mapPKs.rowIdx).text(mapPKs.yearTermName);
	$("#td_"+mapPKs.rowIdx).next().text(mapPKs.categoryString);
	$("#td_"+mapPKs.rowIdx).next().next().find("span").eq(0).text(mapPKs.courseActiveTitle);
	
};
</script>
</head>

<body>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="reloadCallback" value="doChangeCourseActive">
<input type="hidden" name="rowIdx">
<div class="lybox-title">
    <h4 class="section-title"><spring:message code="필드:개설과목:구성정보선택"/></h4>
</div>
<table class="tbl-detail-row"><!-- tbl-detail-row -->
    <colgroup>
        <col style="width:20%;">
        <col style="width:auto;">
    </colgroup>
    <tbody>
        <c:set var="closeTr" value="0"/>
        <c:forEach var="elementRow" items="${elements}" varStatus="i">
            <c:if test="${i.first || i.index%4 == 0}">
            <tr>
            <c:set var="closeTr" value="${closeTr+1}"/>
            </c:if>
                <th><c:out value="${elementRow.codeName}"/></th>
                <td><input type="checkbox" name="courseElementTypes" value="<c:out value="${elementRow.code}"/>"></td>
            <c:if test="${i.index == ((closeTr*3)+closeTr)-1}">
            </tr>
            </c:if>
        </c:forEach>
        <th>
        </th>
        <td>
        </td>
        <th>
        </th>
        <td>
        </td>
        </tr>
    </tbody>
</table>
<!-- //타이틀 박스 -->

<div class="lybox-title mt10">
    <h4 class="section-title"><spring:message code="필드:개설과목:선택정보"/></h4>
    
    <h4 class="section-title" style="margin-left:  346px"><spring:message code="필드:개설과목:복사정보"/></h4>
</div>
<div class="scroll-y" style="height:150px;"><!-- scroll-y -->
    <table class="tbl-2column"><!-- tbl-2column -->
        <colgroup>
            <col style="width:5%;">
            <col style="width:12%;">
            <col style="width:25%;">
            <col style="width:1%;">
            <col style="width:12%;">
            <col style="width:20%;">
            <col style="width:25%;">
        </colgroup>
        <thead>
            <tr>
                <th></th>
                <th><spring:message code="필드:개설과목:년도학기"/></th>
                <th><spring:message code="필드:개설과목:과목명"/></th>
                <th class="blank"></th><!-- blank -->
                <th><spring:message code="필드:개설과목:년도학기"/></th>
                <th><spring:message code="필드:개설과목:학부/학과"/></th>
                <th><spring:message code="필드:개설과목:과목명"/></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="row" items="${itemList}" varStatus="i">
                <tr id="Copy_<c:out value="${row.courseActiveSeq}"/>">
                    <td>
                        <input type="checkbox" name="checkkeys" value="Copy_<c:out value="${row.courseActiveSeq}"/>">
                    </td>
                    <td>
                        <c:out value="${row.year}"/><spring:message code="필드:개설과목:년도" />
                        <aof:code type="print" codeGroup="TERM_TYPE" selected="${row.term}" removeCodePrefix="true"/>
                    </td>
                    <td><c:out value="${row.courseActiveTitle}"/></td>
                    <td class="blank">
                            <input type="hidden" name="targetCourseActiveSeqs" value="<c:out value="${row.courseActiveSeq}"/>"/>
                            <input type="hidden" name="sourceCourseActiveSeqs" id="source_<c:out value="${i.index}"/>" value="<c:out value="${row.courseActiveRS.courseActive.courseActiveSeq}"/>"/>
                    </td><!-- blank -->
                    <c:choose>
                        <c:when test="${empty row.courseActiveRS}">
                            <td id="td_<c:out value="${i.index}"/>">
                            </td>
                            <td>
                            </td>
                            <td>
                                <span>
                                </span>
                                <a href="#" onclick="doCourseActivePopup(<c:out value="${i.index}"/>)" class="btn gray">
                                    <span class="mid"><spring:message code="버튼:수정"/></span>
                                </a>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td id="td_<c:out value="${i.index}"/>">
                                <!-- 년도학기 -->
                                <c:out value="${row.courseActiveRS.courseActive.year}"/>
                                <spring:message code="필드:개설과목:년도" />
                                <aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActiveRS.courseActive.term}"/>
                            </td>
                            <td>
                               <c:out value="${row.courseActiveRS.category.categoryString}"/>
                            </td>
                            <td>
                                <span>
                                    <c:out value="${row.courseActiveRS.courseActive.courseActiveTitle}"/>
                                </span>
                                <a href="#" onclick="doCourseActivePopup(<c:out value="${i.index}"/>)" class="btn gray">
                                    <span class="mid"><spring:message code="버튼:수정"/></span>
                                </a>
                            </td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<div class="section-stats"><!-- section-stats -->
    <span><spring:message code="필드:개설과목:총" /></span>
    <span class="count" id="copyCount">
        <c:out value="${fn:length(itemList)}"/>
    </span><spring:message code="필드:개설과목:과목" />
</div>

<div class="lybox-btn" id="buttonArea"><!-- lybox-btn -->
    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
        <div class="lybox-btn-l">
            <a href="javascript:void(0)" onclick="doDelete()" class="btn blue">
                <span class="mid"><spring:message code="버튼:삭제"/></span>
            </a>
        </div>
    </c:if>
    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
        <div class="lybox-btn-r">
            <a href="javascript:void(0)" onclick="doInsert()" class="btn blue">
                <span class="mid"><spring:message code="버튼:개설과목:복사"/></span>
            </a>
        </div>
    </c:if>
</div>
</form>
</body>
</html>