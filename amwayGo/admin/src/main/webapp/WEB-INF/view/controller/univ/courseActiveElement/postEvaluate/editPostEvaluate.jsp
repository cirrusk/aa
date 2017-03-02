<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_JOIN" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.JOIN')}"/>
<c:set var="CD_BOARD_TYPE_NOTICE"        value="${aoffn:code('CD.BOARD_TYPE.NOTICE')}"/>
<c:set var="CD_BOARD_TYPE_RESOURCE"      value="${aoffn:code('CD.BOARD_TYPE.RESOURCE')}"/>
<c:set var="CD_BOARD_TYPE_APPEAL"        value="${aoffn:code('CD.BOARD_TYPE.APPEAL')}"/>
<c:set var="CD_BOARD_TYPE_ONE2ONE"       value="${aoffn:code('CD.BOARD_TYPE.ONE2ONE')}"/>

<c:set var="exceptEvaluateBoardType" value="${CD_BOARD_TYPE_NOTICE},${CD_BOARD_TYPE_RESOURCE},${CD_BOARD_TYPE_APPEAL},${CD_BOARD_TYPE_ONE2ONE}" scope="request"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forBoardPostEvaluate = null;
var forRefresh = null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
		
	forRefresh = $.action();
	forRefresh.config.formId = "FormData";
	forRefresh.config.url    = "<c:url value="/univ/course/active/join/edit.do"/>";
    
	forBoardPostEvaluate = $.action("submit", {formId : "FormData"});
	forBoardPostEvaluate.config.url             = "<c:url value="/univ/course/active/join/updatelist.do"/>";
	forBoardPostEvaluate.config.target          = "hiddenframe";
	forBoardPostEvaluate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>";
	forBoardPostEvaluate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forBoardPostEvaluate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forBoardPostEvaluate.config.fn.complete = function() {
		doRefresh();
	};
	
	forBoardPostEvaluate.validator.set({
		title : "<spring:message code="필드:과정:게시글수"/>",
		name : "fromCounts",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0
		}
	});
	forBoardPostEvaluate.validator.set({
		title : "<spring:message code="필드:과정:게시글수"/>",
		name : "toCounts",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0
		}
	});
	forBoardPostEvaluate.validator.set({
		title : "<spring:message code="필드:과정:배점"/>",
		name : "scores",
		data : ["!null", "number"],
		check : {
			maxlength : 3,
			ge : 0,
			le : 100
		}
	});
	forBoardPostEvaluate.validator.set(function() {
		var $form = jQuery("#" + forBoardPostEvaluate.config.formId);
		var fromCount = $form.find(":input[name='fromCounts']").eq(1).val();
		fromCount = fromCount == "" ? 0 : parseInt(fromCount, 10);
		var toCount = $form.find(":input[name='toCounts']").eq(1).val();
		toCount = toCount == "" ? 0 : parseInt(toCount, 10);
		if (fromCount > toCount) {
			$.alert({message : "<spring:message code="글:과정:게시글수설정이정확하지않습니다"/>"});
			return false;
		}
		var prevScore = 0;
		var error = false;
		$form.find(":input[name='scores']").each(function(index) {
			var thisValue = this.value == "" ? 0 : parseInt(this.value);
			if (index > 0 && thisValue > prevScore) {
				error = true;
				return false;
			}
			prevScore = thisValue;
		});
		if (error == true) {
			$.alert({message : "<spring:message code="글:과정:배점설정이정확하지않습니다"/>"});
			return false;
		}
		return true;
	});
    
};

/**
 * 게시글 평가기준 수정
 */
doChangeCount = function(element, code) {
	var $element = jQuery(element);
	var value = element.value == "" ? 0 : parseInt(element.value, 10);
	if (code == "from") {
		$element.closest("tr").next().find(":input[name='toCounts']").val(value - 1);
	} else if (code == "to") {
		$element.closest("tr").prev().find(":input[name='fromCounts']").val(value + 1);
	}
};

/**
 * 게시글 평가기준 저장
 */
doBoardPostEvaluate = function() {
	
	var form = UT.getById(forBoardPostEvaluate.config.formId);
 	//게시판 참여여부 설정 셋팅 
	if (typeof form.elements["checkkeys"] !== "undefined") {
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				form.elements["joinYns"][i].value = (form.elements["checkkeys"][i].checked == true ? "Y" : "N");
			}
		} else {
			form.elements["joinYns"].value = (form.elements["checkkeys"].checked == true ? "Y" : "N"); 		
		}
	}
	
	forBoardPostEvaluate.run();
};

//입력값 초기화
doReset = function() {
	var form = UT.getById(forBoardPostEvaluate.config.formId);
	
	if (typeof form.elements["fromCounts"] !== "undefined") {
		if (form.elements["fromCounts"].length) {
			for (var i = 0; i < form.elements["fromCounts"].length; i++) {
				form.elements["fromCounts"][i].value = form.elements["beforFromCounts"][i].value; 
			}
		}
		if (form.elements["toCounts"].length) {
			for (var i = 0; i < form.elements["toCounts"].length; i++) {
				form.elements["toCounts"][i].value = form.elements["beforToCounts"][i].value;
			}
		}
		if (form.elements["scores"].length) {
			for (var i = 0; i < form.elements["scores"].length; i++) {
				form.elements["scores"][i].value = form.elements["beforScores"][i].value;
			}
		} 
	}	
};

/**
 * 새로고침
 */
doRefresh = function() {
	forRefresh.run();
};

/**
 * 참여결과 페이지 이동
 */
forPostEvaluateResult = function(){
	alert("컨트롤러 필요");
}

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <!-- 년도학기 / 개설과목 Select Area Start -->
	        <c:import url="../../include/commonCourseActive.jsp"></c:import>
	        <!-- 년도학기 / 개설과목 Select Area End -->
	    </div>
	</div>
	
	<!-- 교과목 구성정보 Tab Area Start -->
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="courseActiveSeq" value="${postEvaluate.courseActiveSeq}"></c:param>
	    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_JOIN}"/>
	</c:import>
	<!-- 교과목 구성정보 Tab Area End -->

	<div id="tabContainer">
	    <!-- 평가기준 Start Area -->
	    <c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>
	    <!-- 평가기준 Start End -->
		
		<div class="vspace"></div>
		<div class="vspace"></div>

	    <div class="lybox-btn">
			<div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                <c:forEach var="row" items="${appMenuList}">
	                    <c:choose>
	                        <c:when test="${row.menu.cfString eq 'JOIN'}">
	                            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
	                        </c:when>
	                    </c:choose>
	                </c:forEach>
	                <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>',
	                                                                '<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>',
	                                                                '<c:out value="${menuActiveDetail.menu.dependent}"/>',
	                                                                '<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" >
	                                                                <span class="small"><spring:message code="버튼:과정:참여결과" /></span>
	                </a>
	            </c:if>
	        </div>
	    </div>

        <!-- 참여게시판 체크 -->
		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${postEvaluate.courseActiveSeq}" />
		<input type="hidden" name="postType" value="board"/>
		<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    	<input type="hidden" name="shortcutCategoryGroupSeq" value="<c:out value="${param['shortcutCategoryGroupSeq']}"/>"/>
    	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
			    
		<div class="lybox-title">
	        <h4 class="section-title"><spring:message code="글:과정:참여대상게시판" /></h4>
	    </div>  
		<table class="tbl-detail">
			<tr>
				<td>
					<!-- 기본게시판 -->
					<c:forEach var="row" items="${boardList}" varStatus="iSub">
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, row.board.boardTypeCd, ',') eq false}">
							<input type="hidden" name="boardSeqs" value="<c:out value="${row.board.boardSeq}"/>"/>
							<input type="hidden" name="boardTypeCd" value="<c:out value="${row.board.boardTypeCd}"/>"/>
							<input type="hidden" name="joinYns" value="<c:out value="${row.board.joinYn}"/>"/>
							<input type="hidden" name="deleteYns" value="N"/>
							<c:set var="checked" value=""/>
							<c:if test="${row.board.joinYn eq 'Y'}">
								<c:set var="checked" value="checked='checked'"/>
							</c:if>
							<input type="checkbox" name="checkkeys" value="<c:out value="${iSub.index}"/>" class="checkbox" <c:out value="${checked}"/>> <c:out value="${row.board.boardTitle}"/>
						</c:if>
					</c:forEach>
				</td>
			</tr>
		</table>

		<div class="vspace"></div>
		<div class="vspace"></div>
		
		<!-- 평가기준 등록 -->        
       	<div class="lybox-title">
	        <h4 class="section-title"><spring:message code="글:과정:평가기준" /></h4>
	    </div>
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 80px" />
			<col style="width: auto" />
			<col style="width: 80px" />
		</colgroup>
		<thead>
			<tr>
				<th class="align-c"><spring:message code="필드:과정:등급분류"/></th>
				<th class="align-c"><spring:message code="필드:과정:게시글수"/></th>
				<th class="align-c"><spring:message code="필드:과정:배점"/></th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${!empty listBoardPostEvaluate}">
				<c:forEach var="rowSub" items="${listBoardPostEvaluate}" varStatus="iSub">
					<tr>
						<c:choose>
							<c:when test="${iSub.count eq 1}">
								<th class="align-c"><spring:message code="글:과정:상"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="<c:out value="${rowSub.coursePostEvaluate.postEvaluateSeq}"/>"/>
									<input type="hidden" name="beforFromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>"/>
									<input type="hidden" name="beforToCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>"/>
									<input type="text" name="fromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
									<spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
									<input type="hidden" name="toCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>"/>
								</td>
								<td class="align-c">
									<input type="text" name="scores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/>"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${iSub.count}"/>"/>
								</td>
							</c:when>
							<c:when test="${iSub.count eq 2}">
								<th class="align-c"><spring:message code="글:과정:중"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="<c:out value="${rowSub.coursePostEvaluate.postEvaluateSeq}"/>"/>
									<input type="hidden" name="beforFromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>"/>
									<input type="hidden" name="beforToCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>"/>
									<input type="text" name="fromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'from')"/>
									<spring:message code="글:과정:부터"/>&nbsp;&nbsp;
									<input type="text" name="toCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'to')"/>
									<spring:message code="글:과정:까지"/>
								</td>
								<td class="align-c">
									<input type="text" name="scores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/>"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${iSub.count}"/>"/>
								</td>
							</c:when>
							<c:when test="${iSub.count eq 3}">
								<th class="align-c"><spring:message code="글:과정:하"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="<c:out value="${rowSub.coursePostEvaluate.postEvaluateSeq}"/>"/>
									<input type="hidden" name="beforFromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>"/>
									<input type="hidden" name="beforToCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>"/>
									<input type="hidden" name="fromCounts" value="<c:out value="${rowSub.coursePostEvaluate.fromCount}"/>"/>
									<input type="text" name="toCounts" value="<c:out value="${rowSub.coursePostEvaluate.toCount}"/>" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
									<spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
								</td>
								<td class="align-c">
									<input type="text" name="scores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="<fmt:formatNumber value="${rowSub.coursePostEvaluate.score}"/>"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${iSub.count}"/>"/>
								</td>
							</c:when>
						</c:choose>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty listBoardPostEvaluate}">
				<c:forEach var="rowSub" begin="1" end="3" varStatus="iSub">
					<tr>
						<c:choose>
							<c:when test="${rowSub eq 1}">
								<th class="align-c"><spring:message code="글:과정:상"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="0"/>
									<input type="hidden" name="beforFromCounts" value="0"/>
									<input type="hidden" name="beforToCounts" value="999"/>
									<input type="text" name="fromCounts" value="0" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
									<spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
									<input type="hidden" name="toCounts" value="999"/>
								</td>
								<td class="align-c">
									<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="0"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
								</td>
							</c:when>
							<c:when test="${rowSub eq 2}">
								<th class="align-c"><spring:message code="글:과정:중"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="0"/>
									<input type="hidden" name="beforFromCounts" value="0"/>
									<input type="hidden" name="beforToCounts" value="0"/>
									<input type="text" name="fromCounts" value="0" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'from')"/>
									<spring:message code="글:과정:부터"/>&nbsp;&nbsp;
									<input type="text" name="toCounts" value="0" style="width:40px;text-align:center;" onchange="doChangeCount(this, 'to')"/>
									<spring:message code="글:과정:까지"/>
								</td>
								<td class="align-c">									
									<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="0"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
								</td>
							</c:when>
							<c:when test="${rowSub eq 3}">
								<th class="align-c"><spring:message code="글:과정:하"/></th>
								<td style="padding-left:30px;">
									<input type="hidden" name="postEvaluateSeqs" value="0"/>
									<input type="hidden" name="beforFromCounts" value="0"/>
									<input type="hidden" name="beforToCounts" value="0"/>
									<input type="hidden" name="fromCounts" value="0"/>
									<input type="text" name="toCounts" value="0" class="notedit" style="width:40px;text-align:center;" readonly="readonly"/>
									<spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
								</td>
								<td class="align-c">
									<input type="text" name="scores" value="0" style="width:40px;text-align:center;"/>
									<input type="hidden" name="beforScores" value="0"/>
									<input type="hidden" name="sortOrders" value="<c:out value="${rowSub}"/>"/>
								</td>
							</c:when>
						</c:choose>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
		</table>
		</form>
     
        <div class="lybox-btn">
            <div class="lybox-btn-r">
                <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                	<a href="javascript:void(0)" onclick="doBoardPostEvaluate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
                </c:if>
                <a href="javascript:void(0)" onclick="doReset();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
            </div>
        </div>
    </div>

</body>
</html>