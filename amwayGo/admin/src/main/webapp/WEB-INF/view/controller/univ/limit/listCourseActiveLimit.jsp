<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forUpdatelist       = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    // [2]CheckAll을 선택하면 모든 Y/N 값 변경
    onChangeCheckAll();
};

/**
 * 설정
 */
doInitializeLocal = function() {

    forSearch = $.action("submit", {formId : "FormSrch"}); 
    forSearch.config.url    = "<c:url value="/univ/courseactive/limit/list.do"/>";
    
    forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdatelist.config.url             = "<c:url value="/univ/courseactive/limit/updatelist.do"/>";
    forUpdatelist.config.target          = "hiddenframe";
    forUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdatelist.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdatelist.config.fn.complete     = function() {
        doSearch();
    };

    setValidate();
};


/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    
	forSearch.validator.set({
        title : "<spring:message code="필드:년도학기:시작년도"/>",
        name : "srchStartYearTerm",
        check : {
            le : {name : "srchEndYearTerm", title : "<spring:message code="필드:년도학기:종료년도"/>"}
        }
    });
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
    var form = UT.getById(forSearch.config.formId);
    
    // 목록갯수 셀렉트박스의 값을 변경 했을 때
    if (rows != null && form.elements["perPage"] != null) {  
        form.elements["perPage"].value = rows;
    }
    forSearch.run();
};

/** 학습일자 중복검사 후 저장*/
doCreate = function() {
	forUpdatelist.run();
};


/** 체크박스 클릭시 Y/N 값 변경*/
onChangeReviewOpenYn = function(obj,idx){
	
	// 입장불가 Y/N값 변경
	if($(obj).attr('checked')){
		$('input[name=reviewOpenYns]').eq(idx).val("Y");
    } else {
    	$('input[name=reviewOpenYns]').eq(idx).val("N");
    }
	
	// 전체선택 체크박스 상태 변경
	var allCnt = $('input[name=checkkeys]:checkbox').length;
    var chekcedCnt = $('input[name=checkkeys]:checkbox:checked').length;
    if(allCnt == chekcedCnt){
        $('input[name=checkall]').attr('checked',true);
    } else {
        $('input[name=checkall]').attr('checked',false);
    }
};

/** CheckAll을 선택하면 모든 Y/N 값 변경*/
onChangeCheckAll = function(){
	$('input[name=checkall]:checkbox').change(function(){
		var isCheck = false;
		if($(this).attr('checked')){
			isCheck = true;
        } 
		
        $('input[name=reviewOpenYns]').each(function(){
        	if(isCheck){
        		$(this).val("Y");	
        	} else {
        		$(this).val("N");
        	}
        });
        
        $('input[name=checkkeys]:checkbox').attr('checked',isCheck);
    });
};

</script>
</head>

<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>

    <c:import url="srchCourseActiveLimit.jsp"/>

    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 200px" />
        <col style="width: 200px" />
        <col style="width: auto" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:년도학기:년도학기"/></th>
            <th><spring:message code="필드:년도학기:개설과목수"/></th>
            <th>
                <spring:message code="필드:년도학기:입장불가"/>
                <input type="checkbox" name="checkall"/>
            </th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${itemList}" varStatus="i">
	        <tr>
	            <td>
	               <c:out value="${row.univYearTerm.yearTermName}"/>
                </td>
	            <td>
	               <c:out value="${row.univYearTerm.useCount}"/>
	            </td>
	            <td>
	               <input type="checkbox" name="checkkeys" onchange="onChangeReviewOpenYn(this,${i.index})" <c:if test="${row.univYearTerm.reviewOpenYn eq 'Y'}">checked="checked"</c:if>/>
	               <input type="hidden" name="reviewOpenYns" value="<c:out value="${row.univYearTerm.reviewOpenYn}"/>"/>
	               <input type="hidden" name="yearTerms" value="<c:out value="${row.univYearTerm.yearTerm}"/>"/>
	            </td>
	        </tr>
        </c:forEach>
        <c:if test="${empty itemList}">
	        <tr>
	            <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
	        </tr>
	    </c:if>
    </tbody>
    </table>
    </form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
        </div>
    </div>
</body>
</html>