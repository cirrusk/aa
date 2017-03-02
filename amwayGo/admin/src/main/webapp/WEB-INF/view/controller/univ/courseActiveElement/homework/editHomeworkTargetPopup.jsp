<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>

<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>
<script type="text/javascript">
var forSearch     = null;
var forInsertlist = null;
var forDeletelist = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
 	// [2] sorting 설정
	doSubSortList('nonTargetTable', '<c:out value="${condition.orderbyNonTarget}" />', 'FormSrch', doSearch);
	doSubSortList('targetTable', '<c:out value="${condition.orderbyTarget}" />', 'FormSrch', doSearch);
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/active/homework/target/popup.do"/>";
	
	forInsertlist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsertlist.config.url             = "<c:url value="/univ/course/active/homework/target/insertlist.do"/>";
	forInsertlist.config.target          = "hiddenframe";
	forInsertlist.config.message.confirm = "<spring:message code="글:과제:대상자를지정하시겠습니까"/>"; 
	forInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertlist.config.fn.complete     = doCompleteInsertlist;
	forInsertlist.validator.set({
		title : "<spring:message code="글:과제:지정할대상자"/>",
		name : "nonTargetApplyCheckkeys",
		data : ["!null"]
	});
	
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/univ/course/active/homework/target/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:과제:대상자를제외하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="글:과제:제외할대상자"/>",
		name : "targetApplyCheckkeys",
		data : ["!null"]
	});
	
};

/**
 * 제외 완료
 */
doCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:과제:X건의대상자가제외되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSearch();
			}
		}
	});
};

/**
 * 지정 완료
 */
 doCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:과제:X건의대상자가지정되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSearch();
			}
		}
	});
 };

/**
 * 지정
 */
doInsertlist = function(){
	forInsertlist.run();
};

/**
 * 제외
 */
doDeletelist = function(){
	forDeletelist.run();
};


doSearch = function(){
	forSearch.run();
};

/**
 * 닫기
 */
doClose = function(){
    $layer.dialog("close");
};

/**
 * sort
 */
doSubSortList = function(elementId, orderbyValue, formId, callback) {
	jQuery(".sort", jQuery("#" + elementId)).each(
			function() {
				orderbyValue = parseInt(orderbyValue, 10);
				if (Math.abs(orderbyValue) == parseInt(jQuery(this).attr(
						"sortid"), 10)) {
					jQuery(this).attr("sortid", orderbyValue);
					if (orderbyValue > 0) {
						jQuery(this).addClass("sort_asc");
					} else {
						jQuery(this).addClass("sort_desc");
					}
				}
				var span = this;
				var parent = jQuery(this).parent();
				jQuery(parent).css("cursor", "pointer");
				jQuery(parent).click(
						function() {
							var form = UT.getById(formId);
								if(elementId == "nonTargetTable"){
									form.elements["orderbyNonTarget"].value = parseInt(
										jQuery(span).attr("sortid"), 10)
										* (-1);
								}else{
									form.elements["orderbyTarget"].value = parseInt(
											jQuery(span).attr("sortid"), 10)
											* (-1);
								}
							if (typeof callback === "function") {
								callback.call(this);
							}
						});
			});
};

/**
 * 전체 체크/해제
 */
doChkAll = function(obj,id){
	if($(obj).is(":checked")){
		$("#"+ id+" :checkbox").attr("checked", true);	
	} else {
		$("#"+ id+" :checkbox").attr("checked", false);
	}
};

</script>
</head>

<body>
<form id="FormSrch" name="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" value="<c:out value='${condition.homeworkSeq}'/>">
	<input type="hidden" name="referenceSeq" value="<c:out value='${condition.referenceSeq}'/>">
	<input type="hidden" name="referenceType" value="<c:out value='${condition.referenceType}'/>">
	<input type="hidden" name="editYn" value="<c:out value='${condition.editYn}'/>">
	<input type="hidden" name="answerSubmitCount" value="<c:out value="${param['answerSubmitCount']}"/>">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${condition.courseActiveSeq}" />">
	<input type="hidden" name="limitScore" value="<c:out value="${condition.limitScore}" />">
	<input type="hidden" name="orderbyNonTarget"     value="<c:out value="${condition.orderbyNonTarget}" />" />
	<input type="hidden" name="orderbyTarget"     value="<c:out value="${condition.orderbyTarget}" />" />
	<!-- 타이틀 박스 -->
	<table class=""><!-- tbl-2column 테이블 상단에 오는 제목 테이블, 별도 클래스는 필요없음-->
	    <colgroup>
	        <col style="width:48%;" />
	        <col style="width:1%;" /><!-- blank 칼럼(좌우 구분 빈셀) -->
	        <col style="width:51%;" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th>
	                <div class="lybox-title">
	                    <h4 class="section-title"><spring:message code="필드:과제:비대상자목록"/></h4>
	                </div>
	            </th>
	            <th></th>
	            <th>
	                <div class="lybox-title">
	                    <h4 class="section-title"><spring:message code="필드:과제:대상자목록"/></h4>
	                </div>
	            </th>
	        </tr>
	        <tr>
	            <td><!-- 비 대상자 목록 검색바 -->
	                <select name="srchNonTargetKey">
	                	<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchNonTargetKey}"/>
					</select>
					<input type="text" name="srchNonTargetWord" value="<c:out value="${condition.srchNonTargetWord}"/>" style="width:120px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	            	<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
	            </td>
	            <th></th>
	            <td><!-- 대상자 목록 검색바 -->
	                <select name="srchTargetKey">
						<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchTargetKey}"/>
					</select>
					<input type="text" name="srchTargetWord" value="<c:out value="${condition.srchTargetWord}"/>" style="width:120px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	            	<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
	            </td>
	        </tr>
	        
	        <tr>
	        	<td class="align-r">
					<select name="srchLimitScore" onchange="doSearch()">
						<option value="">-</option>
						<aof:code type="option" codeGroup="SCORE_FILTER" removeCodePrefix="true" selected="${condition.srchLimitScore}" />
					</select>
					<spring:message code="필드:과제:점이하"/>
					<div class="vspace"></div>
	        	</td>
	        	<td colspan="2"></td>	
	        </tr>
	    </thead>
	</table>
</form>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="homeworkSeq" value="<c:out value='${condition.homeworkSeq}'/>">
<input type="hidden" name="referenceSeq" value="<c:out value='${condition.referenceSeq}'/>">
<input type="hidden" name="editYn" value="<c:out value='${condition.editYn}'/>">
<input type="hidden" name="answerSubmitCount" value="<c:out value="${param['answerSubmitCount']}"/>">
<input type="hidden" name="courseActiveSeq" value="<c:out value="${condition.courseActiveSeq}" />">
<!-- //타이틀 박스 -->
<table class="tbl-layout"><!-- table-layout -->
    <colgroup>
        <col style="width:49%;">
        <col style="width:auto;">
    </colgroup>
    <tbody>
        <tr>
            <td class="first"><!-- first -->
                <!-- 대기자 목록 Start -->
                <div class="scroll-y" style="height:360px;">
                    <table class="tbl-list" id="nonTargetTable"><!-- tbl-list -->
                        <colgroup>
                        	<c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
                            	<col style="width: 30px;">
                            </c:if>
	                            <col/>
	                            <col style="width: 130px;">
	                            <col style="width: 60px">
	                            <col style="width: 60px">
                        </colgroup>
                        <thead>
                            <tr>
                            	<c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
                                	<th><input type="checkbox" name="checkall" onclick="doChkAll(this,'nonTargetMemberArea')" /></th>
                                </c:if>
	                                <th><span class="sort" sortid="1" onclick="doSubSortList('nonTargetTable', '1', 'FormSrch', doSearch)"><spring:message code="필드:과제:이름"/></span></th>
	                                <th><span class="sort" sortid="2" onclick="doSubSortList('nonTargetTable', '2', 'FormSrch', doSearch)"><spring:message code="필드:과제:아이디" /></span></th>
	                                <th><span class="sort" sortid="3" onclick="doSubSortList('nonTargetTable', '3', 'FormSrch', doSearch)"><spring:message code="필드:과제:학년" /></span></th>
	                                <th><span class="sort" sortid="4" onclick="doSubSortList('nonTargetTable', '4', 'FormSrch', doSearch)"><spring:message code="필드:과제:점수" /></span></th>
                            </tr>
                        </thead>
                        <tbody id="nonTargetMemberArea">
                            <c:forEach var="row" items="${listNonTarget}" varStatus="i">
                            <tr>
	                            <c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
	                                <td>
	                                    <input type="checkbox" name="nonTargetApplyCheckkeys" value="<c:out value="${row.target.courseApplySeq}"/>" onclick="FN.onClickCheckbox(this)">
	                                </td>
	                            </c:if>
                                <td>
                                    <c:out value="${row.member.memberName}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberId}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.studentYear}"/>
                                    <spring:message code="필드:팀프로젝트:학년" />
                                </td>
                                <td>
                                    <c:out value="${row.target.homeworkScore}"/>
                                </td>
                            </tr>
                            </c:forEach>
                            <tr id="UnassignNoDataArea" <c:if test="${not empty listNonTarget}">style="display: none;"</c:if>>
                                <c:choose>
	                                <c:when test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
	                                	<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
	                                </c:when>
	                                <c:otherwise>
	                                	<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
	                                </c:otherwise>
                                </c:choose>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 대기자 목록 End -->
            </td>

            <td>
                <!--  팀원 목록 Start -->
                <div class="scroll-y" style="height:360px;">
                    <table class="tbl-list" id="targetTable">
                        <colgroup>
                        <c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
                            <col style="width: 30px;">
                        </c:if>
                            <col>
                            <col style="width: 130px;">
                            <col style="width: 70px">
                            <col style="width: 70px">
                        </colgroup>
                        <thead>
                             <tr>
                             <c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
                                <th><input type="checkbox" name="checkall" onclick="doChkAll(this,'targetMemberArea')" /></th>
                             </c:if>
                                <th><span class="sort" sortid="1" onclick="doSubSortList('targetTable', '1', 'FormSrch', doSearch)"><spring:message code="필드:팀프로젝트:이름"/></span></th>
                                <th><span class="sort" sortid="2" onclick="doSubSortList('targetTable', '2', 'FormSrch', doSearch)"><spring:message code="필드:팀프로젝트:아이디" /></span></th>
                                <th><span class="sort" sortid="3" onclick="doSubSortList('targetTable', '3', 'FormSrch', doSearch)"><spring:message code="필드:팀프로젝트:학년" /></span></th>
                                <th><span class="sort" sortid="4" onclick="doSubSortList('targetTable', '4', 'FormSrch', doSearch)"><spring:message code="필드:과제:점수" /></span></th>
                            </tr>
                        </thead>
                        <tbody id="targetMemberArea">
                           <c:forEach var="row" items="${listTarget}" varStatus="i">
                            <tr>
                            <c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
                                <td>
                                    <input type="checkbox" name="targetApplyCheckkeys" value="<c:out value="${row.target.courseApplySeq}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
                                </td>
                            </c:if>
                                <td>
                                    <c:out value="${row.member.memberName}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.memberId}"/>
                                </td>
                                <td>
                                    <c:out value="${row.member.studentYear}"/>
                                    <spring:message code="필드:팀프로젝트:학년" />
                                </td>
                                <td>
                                    <c:out value="${row.target.homeworkScore}"/>
                                </td>
                            </tr>
                            </c:forEach>
                            <tr id="AssignNoDataArea" <c:if test="${not empty listTarget}">style="display: none;"</c:if>>
                                <c:choose>
	                                <c:when test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
	                                	<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
	                                </c:when>
	                                <c:otherwise>
	                                	<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
	                                </c:otherwise>
                                </c:choose>
                            </tr>
                        </tbody>
                    </table>
                </div><!-- //scroll-y -->
                <!--  목록 Start -->
            </td>
        </tr>
        <tr>
        	<td>
        		<div class="lybox-btn-l">
			        <div class="lybox-title">
			            <h4 class="section-title"><spring:message code="필드:과제:총"/> : 
			                <span class="count"><c:out value="${fn:length(listNonTarget)}"/><spring:message code="필드:과제:명"/></span>
			            </h4>
			        </div>
			    </div>
			    <c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
				    <div class="lybox-btn-r">
					    <a href="javascript:void(0)" onclick="doInsertlist()" class="btn gray"><span class="small"><spring:message code="버튼:과제:지정"/> ></span></a>
					</div>
				</c:if>
        	</td>
        	<td>
        		<c:if test="${(condition.editYn eq 'Y') and param['answerSubmitCount'] eq 0}">
	        		<div class="lybox-btn-l">
				        <a href="javascript:void(0)" onclick="doDeletelist()" class="btn gray"><span class="small">< <spring:message code="버튼:과제:제외"/></span></a>
				    </div>
			    </c:if>
        		<div class="lybox-btn-r">
			        <div class="lybox-title">
			            <h4 class="section-title"><spring:message code="필드:과제:총"/> : 
			                <span class="count"><c:out value="${fn:length(listTarget)}"/><spring:message code="필드:과제:명"/></span>
			            </h4>
			        </div>
			    </div>
        	</td>
        </tr>
    </tbody>
</table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-r">
       <a href="javascript:void(0)" onclick="doClose()" class="btn blue"><span class="mid"><spring:message code="버튼:닫기"/></span></a>
    </div>
</div>
</body>
</html>