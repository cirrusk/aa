<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forCourseActivePopup = null;
var forInsert   = null;
var forDetailElement = null;
var forDetailElementPopup = null;
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
    forInsert.config.fn.complete     = function(data) {
    	var map = {shortcutCourseActiveSeq: $("input[name=targetCourseActiveSeqs]").val(),
    			   shortcutYearTerm : $("input[name=yearTerm]").val()};
    	$.alert({
            message : "<spring:message code="글:개설과목:복사되었습니다."/>",
            button1 : {
                callback : function() {
                	var par = $layer.dialog("option").parent;
                    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
                        par["<c:out value="${param['callback']}"/>"].call(this,map);
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

    forDetailElement = $.action("ajax");
    forDetailElement.config.formId      = "FormDetailElement";
    forDetailElement.config.type        = "html";
    forDetailElement.config.containerId = "elementArea";
    forDetailElement.config.url         = "<c:url value="/univ/courseactive/element/ajax.do"/>";
    forDetailElement.config.fn.complete = function() {};
    
    forCopyPopup = $.action("submit");
    forCopyPopup.config.formId = "FormCopyElement";
    forCopyPopup.config.url    = "<c:url value="/univ/courseactive/copy/popup.do"/>";
    
    
    forDetailElementPopup = $.action("layer");
    forDetailElementPopup.config.formId = "FormDetailElement";
    forDetailElementPopup.config.url    = "<c:url value="/univ/courseactive/element/popup.do"/>";
    forDetailElementPopup.config.options.width = 650;
    forDetailElementPopup.config.options.height = 450;
    forDetailElementPopup.config.options.title = "<spring:message code="필드:개설과목:구성정보"/>";
    
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
 * 개설과정 검색 팝업
 */
doCourseActivePopup = function(){
	forCourseActivePopup.run();
}

/**
 * 복사할 과정 변경
 */
doChangeCourseActive = function(mapPKs){
	var courseActiveSeq = $("input[name=courseActiveSeq]").val();
	
	if(mapPKs.courseActiveSeq == courseActiveSeq){
		 $.alert({message : "<spring:message code="글:개설과목:같은과목의구성정보를복사할수없습니다."/>"});
	} else {
		$("input[name=sourceCourseActiveSeq], input[name=sourceCourseActiveSeqs]").val(mapPKs.courseActiveSeq);
		
		forCopyPopup.run();
	}
};

/**
 * 복사할 구성정보 상세
 */
doDetailElement = function(mapPKs){
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailElement.config.formId);
    forDetailElement.run();
};

/**
 * 선택된 구성정보 상세
 */
doDetailElementPopup = function(mapPKs){
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailElementPopup.config.formId);
    forDetailElementPopup.run();
};
</script>
</head>

<body>
<form id="FormCopyElement" name="FormCopyElement" method="post" onsubmit="return false;">
    <input type="hidden" name="sourceCourseActiveSeq"/>
    <input type="hidden" name="courseActiveTitle" value="<c:out value="${targetCourseActive.courseActiveTitle}"/>"/>
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${targetCourseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${targetCourseActive.courseActiveSeq}"/>"/>
    <input type="hidden" name="yearTerm" value="<c:out value="${targetCourseActive.yearTerm}"/>"/>
    <input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${condition.srchCategoryTypeCd}"/>"/>
    <input type="hidden" name="callback" value="${param['callback']}"/>
</form>
<form name="FormDetailElement" id="FormDetailElement" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseElementType"/>
</form>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="reloadCallback" value="doChangeCourseActive">
    <input type="hidden" name="callback" value="${param['callback']}"/>
    <input type="hidden" name="yearTerm" value="<c:out value="${targetCourseActive.yearTerm}"/>"/>
    <input type="hidden" name="targetCourseActiveSeqs" value="<c:out value="${targetCourseActive.courseActiveSeq}"/>"/>
    <input type="hidden" name="sourceCourseActiveSeqs" value="<c:out value="${sourceCourseActive.courseActive.courseActiveSeq}"/>"/>
    <table class="tbl-layout"><!-- table-layout -->
        <colgroup>
            <col style="width:35%;">
            <col style="width:auto;"><!-- IE7 버그로 50% 으로 지정하면 우측 라인이 잘림, auto 로 설정 -->
        </colgroup>
        <tbody>
            <tr>
                <td class="first" style="height:300px;"><!-- height:300px -->
                    <div class="lybox-title"><!-- lybox-title -->
                        <h4 class="section-title"><spring:message code="필드:개설과목:선택정보"/></h4>
                    </div>
                    <table class="tbl-detail-row" style="height:80px;">
                        <colgroup>
                            <col style="width:35%;">
                            <col>
                        </colgroup>
                        <thead>
                            <tr>
                                <th><spring:message code="필드:개설과목:년도학기"/></th>
                                <th><spring:message code="필드:개설과목:과목명"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <c:out value="${targetCourseActive.year}"/><spring:message code="필드:개설과목:년도" />
                                    <aof:code type="print" codeGroup="TERM_TYPE" selected="${targetCourseActive.term}" removeCodePrefix="true"/>
                                </td>
                                <td><c:out value="${targetCourseActive.courseActiveTitle}"/></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="scroll-y mt10" style="height:390px;">
                        <table class="tbl-detail-row">
                            <colgroup>
                                <col style="width:45%;">
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th><spring:message code="필드:개설과목:구성정보"/></th>
                                    <th><spring:message code="필드:개설과목:정보"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="elementRow" items="${elements}" varStatus="i">
                                    <tr>
                                        <td><c:out value="${elementRow.codeName}"/></td>
                                        <td>
                                            <a href="javascript:void(0)" onclick="doDetailElementPopup({courseActiveSeq: '<c:out value="${targetCourseActive.courseActiveSeq}"/>', courseElementType: '<c:out value="${elementRow.code}"/>'})" class="btn black">
                                                <span class="mid"><spring:message code="버튼:개설과목:보기" /></span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </td>
                <td style="height:300px;"><!-- 컨텐츠 우 --><!-- height:300px -->
                    <div class="lybox-title"><!-- lybox-title -->
                        <h4 class="section-title"><spring:message code="필드:개설과목:복사정보"/></h4>
                    </div>
                    
                    <table class="tbl-detail-row" style="height:80px;"><!-- style="height:80px;" -->
                            <colgroup>
                                <col style="width:18%;">
                                <col style="width:35%;">
                                <col>
                            </colgroup>
                        
                        <thead>
                            <tr>
                                <th><spring:message code="필드:개설과목:년도학기"/></th>
                                <th><spring:message code="필드:개설과목:학부/학과"/></th>
                                <th><spring:message code="필드:개설과목:과목명"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <c:choose>
                                    <c:when test="${empty sourceCourseActive}">
                                        <td colspan="3">
                                            <spring:message code="글:개설과목:이전학기의과정이없습니다.복사할과정을선택하시기바랍니다." />
                                            <a href="#" onclick="doCourseActivePopup()" class="btn gray">
                                                <span class="mid"><spring:message code="버튼:선택"/></span>
                                            </a>
                                        </td>
                                    </c:when>
                                    <c:otherwise>
                                        <td id="sourceTdArea">
                                            <c:out value="${sourceCourseActive.courseActive.year}"/>
                                            <spring:message code="필드:개설과목:년도" />
                                            <aof:code type="print" codeGroup="TERM_TYPE" selected="${sourceCourseActive.courseActive.term}"/>
                                        </td>
                                        <td><c:out value="${sourceCourseActive.category.categoryString}"/></td>
                                        <td>
                                            <span>
                                                <c:out value="${sourceCourseActive.courseActive.courseActiveTitle}"/>
                                            </span>
                                            <a href="#" onclick="doCourseActivePopup()" class="btn gray">
                                                <span class="mid"><spring:message code="버튼:수정"/></span>
                                            </a>
                                        </td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                        </tbody>
                    </table>
                    <c:if test="${not empty sourceCourseActive}">
                    <table class="tbl-detail-row mt10"><!-- tbl-detail center -->
                        <colgroup>
                            <col style="width:17%;">
                            <col>
                            <col style="width:17%;">
                            <col>
                            <col style="width:17%;">
                            <col>
                            <col style="width:17%;">
                            <col>
                        </colgroup>
                        <tbody>
                            <c:set var="closeTr" value="0"/>
                            <c:forEach var="elementRow" items="${elements}" varStatus="i">
                                <c:if test="${i.first || i.index%4 == 0}">
                                <tr>
                                <c:set var="closeTr" value="${closeTr+1}"/>
                                </c:if>
                                    <td>
                                        <a href="javascript:void(0)" onclick="doDetailElement({courseActiveSeq: '<c:out value="${sourceCourseActive.courseActive.courseActiveSeq}"/>', courseElementType: '<c:out value="${elementRow.code}"/>'})">
                                            <c:out value="${elementRow.codeName}"/>
                                        </a>
                                    </td>
                                    <td><input type="checkbox" name="courseElementTypes" value="<c:out value="${elementRow.code}"/>"></td>
                                <c:if test="${i.index == ((closeTr*3)+closeTr)-1}">
                                </tr>
                                </c:if>
                            </c:forEach>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="elementArea" class="scroll-y mt10" style="height:210px;">
                        <!-- 구성정보 Ajax Page -->
                        <c:import url="include/commonCourseActivePlan.jsp"/>
                    </div>
                    </c:if>
                </td>
            </tr>
        </tbody>
    </table>

    <div class="lybox-btn"><!-- lybox-btn -->
        <div class="lybox-btn-r"><a href="javascript:void(0)" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:개설과목:복사"/></span></a></div>
    </div>
</form>
</body>
</html>