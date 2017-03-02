<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="popupAsk">
<head>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/common_exam.css" type="text/css"/>
<title></title>
<script type="text/javascript">
var patten = -1;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	// [2] 10초마다 게시글 정보를 가져온다.
	var timer = null;
	clearInterval(timer);
	timer = setInterval(function() {
		doAjax();
	}, 3000);
	
	var scroll_hg = $('.wrapper').height() - ($('#header').height() + $('#footer').height());
	$('#container').css('height',scroll_hg+'px');
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forCreate = $.action();
	forCreate.config.formId = "FormData";
	forCreate.config.url    = "<c:url value="/univ/course/bbs/${boardType}/create.do"/>";
	
	forList = $.action();
	forList.config.formId = "FormList";
	forList.config.url    = "<c:url value="/univ/course/active/quiz/answer/session/list.do"/>";
	
};

/**
 * 등록화면을 호출하는 함수
 */
doCreate = function() {
	UT.getById(forCreate.config.formId).reset();
	//UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	forCreate.run();
	
};
doAjax = function(){
	
	var action = $.action("ajax");
	action.config.type        = "json";
	action.config.formId	  = "FormDetail";
	action.config.url         = "<c:url value="/univ/course/active/quiz/answer/detail/ajax2.do" />";
	action.config.fn.complete = function(action, data) {
		var totalAnswerCnt = 0;
		for(var index in data.itemList){
			totalAnswerCnt = totalAnswerCnt + data.itemList[index].courseQuizAnswer.answerCount
		}
		if(data.detail.courseExamItem.examItemTypeCd == 'EXAM_ITEM_TYPE::003'){
			for(var index in data.itemList){
				if(index == 0){
					$(".p_num:eq(0)").text(data.itemList[index].courseQuizAnswer.answerCount);
				}else{
					$(".p_num:eq(1)").text(data.itemList[index].courseQuizAnswer.answerCount);
				}
			}
		}else if(data.detail.courseExamItem.examItemTypeCd == 'EXAM_ITEM_TYPE::004'){
			var innerHtml = "";
			var cls = "deco_g";
			var color = "gray";
			var liCnt = $("li").length;
			if(data.itemList.length%2 ==0 && data.itemList.length > 0){
				patten = patten * -1;
			}
			for(var index in data.itemList){
				if(index == 0){
					$("#courseQuizAnswerSeq").val(data.itemList[index].courseQuizAnswer.courseQuizAnswerSeq)
				}
				if(patten == -1){
					cls = "deco_g";
					color = "gray";
				}else{
					cls = "deco_p";
					color = "pink";
				}
				
				var imageBlank = "<aof:img type='print' src='common/" + cls +".png' />";
				
				innerHtml += "<div class='shortWrap'>"
				    + " <div class=\'shot_answer "+color+"\'>" + data.itemList[index].courseQuizAnswer.shortAnswer + ""
				    + " <img src='"+imageBlank+"' class='"+cls+"' /></div>"
				    + " </div>"
				    
				    patten = patten * -1;  
				
			}
			if(data.itemList.length%2 ==0 && data.itemList.length > 0){
				patten = patten * -1;
			}
			$("#content").prepend(innerHtml);
		}
		else{
			for(var index in data.itemList){
				var answerCount = data.itemList[index].courseQuizAnswer.answerCount;
				var total = parseFloat(((answerCount)*100)/totalAnswerCnt).toFixed(0);
				$(".count:eq(" + index +")").text(answerCount + "명(" +total+"%)")
				$(".bar:eq(" + index +")").css('width',total+'%')
			}
		}
	};
	action.run();

};

doList = function(){
	forList.run();
}
</script>
</head>

<body>
<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	
    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	<input type="hidden" name="srchClassificationCode"  value="<c:out value="${param['srchClassificationCode']}"/>" />
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>
<c:set var="totalAnswerCnt" value="0"/>
<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="examItemSeq" value="${vo.examItemSeq}"/>
	<input type="hidden" name="courseActiveSeq" value="${vo.courseActiveSeq}"/>
	<input type="hidden" name="courseActiveProfSeq" value="${vo.courseActiveProfSeq}"/>
	<input type="hidden" name="quizDtime" value="${vo.quizDtime}"/>
<%-- 	<table class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 200px;" />
			<col style="width: 40px" />
			<col style="width: 40px" />
		</colgroup>
		<thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:퀴즈:제목" /></th>
	            <th><spring:message code="필드:퀴즈:답변수" /></th>
	            <th><spring:message code="필드:퀴즈:비율" /></th>
	        </tr>
	    </thead>
		<tbody>
			<c:forEach var="row" items="${itemList}" varStatus="i">
				<tr>
					<tr>
		    			<td>
		    				<c:out value="${i.count}"/>
	    				</td>
		                <td class="align-l">
		                	<c:out value="${row.courseExamExample.examItemExampleTitle}"/>
		                </td>
		                <td>
		                	<c:out value="${row.courseQuizAnswer.answerCount}"/>
		                </td>
		                <td>
		                	<aof:number value="${(row.courseQuizAnswer.answerCount*100)/row.courseQuizAnswer.memberCount}" pattern="###.##"/>%
		                </td>
		    		</tr>
				</tr>
			</c:forEach>
		</tbody>
	</table> --%>
	<div class="bg">
	<div class="wrapper">
	<!-- header -->
	<div id="header">
		<c:choose>
			<c:when test="${detail.courseExamItem.examItemTypeCd eq 'EXAM_ITEM_TYPE::003'}">
			
			</c:when>
			<c:when test="${detail.courseExamItem.examItemTypeCd eq 'EXAM_ITEM_TYPE::004'}">
				<h2 class="tit">주관식</h2>
			</c:when>
			<c:otherwise>
			
			</c:otherwise>
		</c:choose>
	</div>
	<!-- //header -->
	<!-- container -->
	<div id="container" class="five_q" style="position:relative;">
		<h3><span>문제<c:out value="${param['count']}"/></span><c:out value="${detail.courseExamItem.examItemTitle}"/></h3>
		<div id="content">
			<c:choose>
				<c:when test="${detail.courseExamItem.examItemTypeCd eq 'EXAM_ITEM_TYPE::003'}">
					<div class="ox">
						<ul>
							<c:set var="ox" value="o"/>
							<c:forEach var="row" items="${itemList}" varStatus="i">
							<c:if test="${i.index ne 0}"><c:set var="ox" value="x"/></c:if>
							<li class="${ox}"><aof:img src="common/${ox}.png" alt="O" /><p><span class="p_num"><c:out value="${row.courseQuizAnswer.answerCount}"/></span><span class="myung">명</span></p></li>
							</c:forEach>
						</ul>
					</div>
				</c:when>
				<c:when test="${detail.courseExamItem.examItemTypeCd eq 'EXAM_ITEM_TYPE::004'}">
					
						<c:forEach var="row" items="${itemList}" varStatus="i">
							<div class="shortWrap">
								<c:choose>
									<c:when test="${i.index % 2 eq 0}">
										<c:set var="cls" value="deco_p"/>
										<c:set var="color" value="pink"/>
									</c:when>
									<c:otherwise>
										<c:set var="cls" value="deco_g"/>
										<c:set var="color" value="gray"/>
									</c:otherwise>
								</c:choose>
								<div class="shot_answer ${color}">
									<c:out value="${row.courseQuizAnswer.shortAnswer}"/>
									<aof:img src="common/${cls}.png" styleClass="${cls}" />
								</div>
								
								<c:if test="${i.index eq 0}">
									<input type="hidden" name="courseQuizAnswerSeq" id="courseQuizAnswerSeq"  value="<c:out value="${row.courseQuizAnswer.courseQuizAnswerSeq}"/>" />
								</c:if>
							</div>
						</c:forEach>
				</c:when>
				<c:otherwise>
					<ul class="ex">
						<c:forEach var="row" items="${itemList}" varStatus="i">
							<c:set var="totalAnswerCnt" value="${totalAnswerCnt + row.courseQuizAnswer.answerCount}"/>
							<li>
								<aof:img styleClass="num" src="common/ex_0${i.index+1}.png" />
								<c:out value="${row.courseExamExample.examItemExampleTitle}"/>
							</li>
						</c:forEach>
					</ul>
					<div class="graph">
						<ul>
							<c:forEach var="row" items="${itemList}" varStatus="i">
							<li class="n-0${i.index+1}">
								<span class="num">${i.index+1}번</span>
								<div class="progress">
									<span style="width:<aof:number value="${(row.courseQuizAnswer.answerCount*100)/totalAnswerCnt}" pattern="###.##"/>%;" class="bar"><span class="deco"></span></span>
								</div>
								<div class="bub" style="left: 590px;">
									<span class="count"><c:out value="${row.courseQuizAnswer.answerCount}"/>명(<aof:number value="${(row.courseQuizAnswer.answerCount*100)/totalAnswerCnt}" pattern="###.##"/>%)</span>
									<span class="deco"></span>
								</div>
							</li>
							</c:forEach>
						</ul>
					</div>
				</c:otherwise>
			</c:choose>
			
			<!-- //본문 컨텐츠 -->
		</div>
	</div>
	<!-- //container -->
	</div>
</div>
</form>
</body>
</html>