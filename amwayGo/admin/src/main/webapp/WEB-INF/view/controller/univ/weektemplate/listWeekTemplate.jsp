<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     		= null;
var forInsertList       = null;
var forCalculationList  = null;
var forUpdateAllList  = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/week/template/list.do"/>";
	
	forInsertList = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsertList.config.url             = "<c:url value="/univ/week/template/insertlist.do"/>";
    forInsertList.config.target          = "hiddenframe";
    forInsertList.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forInsertList.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forInsertList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsertList.config.fn.complete     = function() {
    	doSearch();
    };
    
    forCalculationList = $.action("normal", {formId : "FormSrch"});
    forCalculationList.config.url    = "<c:url value="/univ/week/template/calculationlist.do"/>";
    
    forUpdateAllList = $.action("submit", {formId : "FormData"});
    forUpdateAllList.config.url    = "<c:url value="/univ/week/template/active/all/update.do"/>";
    forUpdateAllList.config.target          = "hiddenframe"; 
    forUpdateAllList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateAllList.config.fn.complete     = doCompleteUpdateAllList;
    
    setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forInsertList.validator.set({
        title : "<spring:message code="필드:주차템플릿:시작일"/>",
        name : "startDtimes",
        data : ["!null"]
    });
	
	forInsertList.validator.set({
        title : "<spring:message code="필드:주차템플릿:종료일"/>",
        name : "endDtimes",
        data : ["!null"],
        check : {
			maxlength : 12
		}
    });
	
	forCalculationList.validator.set({
		title : "<spring:message code="필드:주차템플릿:일"/>",
		name : "dayCount",
		data : ["!null", "number"]
	});
	
	forCalculationList.validator.set({
		title : "<spring:message code="필드:주차템플릿:주차"/>",
		name : "weekCount",
		data : ["!null", "number"]
	});
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	forSearch.run();
};

/** 주차템플릿 등록*/
doInsertList = function() {
	forInsertList.run();
};

/** 개설과목 일괄적용 */
doUpdateAllList = function() {
	var week_seq = jQuery("#FormData").find(":input[name='checkkeys']").length;
	forUpdateAllList.config.message.confirm = "<spring:message code="글:주차템플릿:X주차인개설과목만일괄적용됩니다일괄적용하시겠습니까"/>".format({0:week_seq});
	forUpdateAllList.run();
};

/**
 * 목록삭제 완료
 */
doCompleteUpdateAllList = function(success) {
	var counts = success.split(",");
	
    $.alert({
        message : "<spring:message code="글:주차템플릿:총X건개설과목중X건개설과목에일괄적용되었습니다"/>".format({0:counts[0],1:counts[1]}),
        button1 : {
            callback : function() {
            	doSearch();
            }
        }
    });
};

/** 현재 주차 라인 구분 값으로 사용(주차 값은 아닙니다.)  */
var rowCount = (<c:out value="${paginate.totalCount}"/> - 1);

/** 주차 일괄생성 (계산)*/
doCalculationList = function() {
	jQuery("#FormSrch").find(":input[name='calculationYn']").val("Y");
	forCalculationList.run();
	jQuery("#FormSrch").find(":input[name='calculationYn']").val("N");
};

/** 주차 추가*/
doAppendWeek = function() {
	if(rowCount <= 0){
		jQuery("#listNoTr").remove();
	}
	
	rowCount = rowCount + 1;
	
	//추가시 주차값
	var week_seq = jQuery("#FormData").find(":input[name='checkkeys']").length + 1;
	
	var $table = jQuery("#listTable");
	var tagStr = "<tr id='listTr" + rowCount + "'>" +
					 "<td><input type='checkbox' name='checkkeys' value='" + rowCount + "' onclick=\"FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')\"></td>" +
					 "<td><span id='weekSeqId" + rowCount + "'>" + week_seq + "</td>" +
					 "<td><input type='text' name='startDtimes' id='startDtime" + rowCount + "' class='datepicker' readonly='readonly'></td>" +
					 "<td><input type='text' name='endDtimes'   id='endDtime"   + rowCount + "' class='datepicker' readonly='readonly'></td>" +
				 "</tr>";
	jQuery(tagStr).appendTo($table);
	
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
	
	jQuery("#warning").show();
};

/** 주차 삭제*/
doRemoveWeek = function() {
	var $list = jQuery("#FormData").find(":input[name='checkkeys']");
	var count = 1;
	
	$list.each(function() {
		if(this.checked){
			jQuery("#listTr" + this.value).remove();
		}else{
			jQuery("#weekSeqId" + this.value).html(count);
			count++;
		}
	});
	
	var week_seq = jQuery("#FormData").find(":input[name='checkkeys']").length;
	
	if(week_seq <= 0){
		var $table = jQuery("#listTable");
		var tagStr = "<tr id='listNoTr'>" +
						"<td colspan='4' align='center'><spring:message code="글:데이터가없습니다" /></td>" +
					 "</tr>";
		jQuery(tagStr).appendTo($table);
	}
	
	jQuery("#checkButton").hide();
	jQuery("#warning").show();
};

/** 변경이 한번이라도 일어나면 저장 옆에 경고 문구 띄운다.*/
changeShow = function() {
	jQuery("#warning").show();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

	<c:import url="srchWeekTemplate.jsp"/>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="yearTerm" value="${condition.srchYearTerm}"/>
	    
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 50px" />
			<col style="width: auto" />
			<col style="width: auto" />
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
				<th><spring:message code="필드:주차템플릿:주차"/></th>
				<th><spring:message code="필드:주차템플릿:시작일"/></th>
				<th><spring:message code="필드:주차템플릿:종료일"/></th>
			</tr>
		</thead>
		<tbody>
		
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr id="listTr<c:out value="${i.index}"/>">
				    <td><input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')"></td>
			        <td><span id="weekSeqId<c:out value="${i.index}"/>"><c:out value="${row.univWeekTemplate.weekSeq}"/></span></td>
			        <td><input type="text" name="startDtimes" id="startDtime<c:out value="${i.index}"/>" onchange="changeShow()" class="datepicker" value="<aof:date datetime="${row.univWeekTemplate.startDtime}"/>" readonly="readonly"></td>
			        <td><input type="text" name="endDtimes"   id="endDtime<c:out value="${i.index}"/>"   onchange="changeShow()" class="datepicker" value="<aof:date datetime="${row.univWeekTemplate.endDtime}"/>" readonly="readonly"></td>
		        </tr>
	        </c:forEach>
	        
	        <c:if test="${empty paginate.itemList}">
				<tr id="listNoTr">
					<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			
		</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButton" style="display: none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doRemoveWeek();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<c:choose>
					<c:when test="${condition.calculationYn eq 'Y'}">
						<span id="warning" style="color: red;"><spring:message code="글:주차템플릿:저장되지않은데이터가존재합니다" /></span>
					</c:when>
					<c:otherwise>
						<span id="warning" style="display: none; color: red;"><spring:message code="글:주차템플릿:저장되지않은데이터가존재합니다" /></span>
					</c:otherwise>
				</c:choose>
				<a href="javascript:void(0)" onclick="doUpdateAllList()" class="btn blue"><span class="mid"><spring:message code="버튼:주차템플릿:개설과목일괄적용" /></span></a>
				<a href="javascript:void(0)" onclick="doAppendWeek()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
				<a href="javascript:void(0)" onclick="doInsertList()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
		</div>
	</div>
	
</body>
</html>