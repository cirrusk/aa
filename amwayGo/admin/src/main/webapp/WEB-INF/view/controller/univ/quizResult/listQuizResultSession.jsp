<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html decorator="popupAsk">
<head>
<title></title>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/common_exam.css" type="text/css"/>
<script type="text/javascript">
var forDetail 		= null;
var count = 0;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    var scroll_hg = $('.wrapper').height() - ($('#header').height() + $('#footer').height());
	$('#container').css('height',scroll_hg+'px');
	
	var timer = null;
	clearInterval(timer);
	timer = setInterval(function() {
		doAjax();
	}, 5000);
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
    
    forDetail = $.action("ajax");
    forDetail.config.formId      = "FormDetail";
    forDetail.config.type        = "html";
    forDetail.config.url         = "<c:url value="/univ/course/active/quiz/answer/detail/ajax.do"/>";
	forDetail.config.fn.complete = function() {
		
	};
	
	forDetailPopup = $.action();
	forDetailPopup.config.formId         = "FormDetail";
	forDetailPopup.config.url            = "<c:url value="/univ/course/active/quiz/answer/detail/popup.do"/>";
	
	forMain = $.action();
	forMain.config.formId = "FormList";
	forMain.config.url    = "<c:url value="/univ/course/active/session/detail.do"/>";
};

/**
 * 상세보기 화면을 호출하는 함수 
 */
var timeout = null;

doDetail = function(mapPKs) {
	clearTimeout(timeout);
	
    forDetail.config.containerId = "container-"+ mapPKs.examItemSeq;
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
    
    $(".containerExample, .loading").hide();
    $("#loading-"+mapPKs.examItemSeq).show();
    $("#"+mapPKs.examItemSeq).show();
    
    timeout = setInterval('doClearTrigger()', 5000);
    
};


doDetailPopup = function(mapPKs) {
	
	UT.getById(forDetailPopup.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetailPopup.config.formId);
	forDetailPopup.run();
};

/**
 * 퀴즈 결과 상세 트리거
 */
doClearTrigger = function() {
	
    // 상세화면 실행
    forDetail.run();
};

/**
 * 메뉴목록
 */
doMain = function() {
	forMain.run();
};

doAjax = function(){
	var action = $.action("ajax");
	action.config.type        = "json";
	action.config.formId	  = "FormData";
	action.config.url         = "<c:url value="/univ/course/active/quiz/answer/session/ajax.do" />";
	action.config.fn.complete = function(action, data) {
		var innerHtml = "";
		if(data.paginate != null){
			count = $("#srchCount").val();
			for(var index in data.paginate.itemList){
				var quizDtime = data.paginate.itemList[index].courseQuizAnswer.quizDtime;
				var courseActiveSeq = data.paginate.itemList[index].courseQuizAnswer.courseActiveSeq;
				var examItemSeq = data.paginate.itemList[index].courseQuizAnswer.examItemSeq;
				var courseActiveProfSeq = data.paginate.itemList[index].courseQuizAnswer.courseActiveProfSeq;
				var examItemTitle = data.paginate.itemList[index].courseExamItem.examItemTitle;
				
				if(index == 0){
					$("#srchCount").val(count*1+data.paginate.itemList.length*1);
					$("#srchQuizDtime").val(quizDtime);
					count = count*1 + data.paginate.itemList.length*1;
				}
				
				innerHtml += "<div>"
			    + "<p>"
			    + examItemTitle
			    + "</p>"
			    + " <a href='javascript:doDetailPopup({\"courseActiveSeq\":"+courseActiveSeq+",\"examItemSeq\":"+examItemSeq+",\"courseActiveProfSeq\":"+courseActiveProfSeq+",\"quizDtime\":"+quizDtime+",\"count\":"+count+"});'>"
			    + "결과보기</a>"
			    + " </div>"
			    
			    count = count - 1 ;
			    
			}	
			$(".quiz_result").prepend(innerHtml);
		}
	}
	action.run();
	
};

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
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="examItemSeq"/>
		<input type="hidden" name="courseActiveSeq"/>
		<input type="hidden" name="courseActiveProfSeq"/>
		<input type="hidden" name="quizDtime"/>
		<input type="hidden" name="count"/>
		<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
		<input type="hidden" name="srchClassificationCode"  value="<c:out value="${param['srchClassificationCode']}"/>" />
	</form>
	
	    <div class="wrapper">	
			<div id="header">
				<h1 class="logo"><a href="#" onclick="doMain();"><aof:img src="common/logo_t.png"/></a></h1>
				<br/>
				<h2 class="tit">퀴즈 결과 리스트</h2>
			</div>
			<div id="container" style="position:relative;">
				<div id="content">
					<form id="FormData" name="FormData" method="post" onsubmit="return false;">
						<input type="hidden" name="srchClassificationCode"  value="<c:out value="${param['srchClassificationCode']}"/>" />
						<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
			 			<div class="quiz_result">
			 				<c:choose>
								<c:when test="${!empty paginate.itemList}">
								 	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
								 		<c:if test="${i.index eq 0}">
											<!-- <input type="hidden" name="srchQuizDtime" id="srchQuizDtime"  value="0" /> -->
											<input type="hidden" name="srchCount" id="srchCount"  value="<c:out value="${paginate.descIndex - i.index}"/>" />
											<input type="hidden" name="srchQuizDtime" id="srchQuizDtime"  value="<c:out value="${row.courseQuizAnswer.quizDtime}"/>" />
										</c:if>
								 		<div>
								 			<p><c:out value="${row.courseExamItem.examItemTitle}"/></p>
									 		<a href="javascript:doDetailPopup({'courseActiveSeq':'<c:out value="${row.courseQuizAnswer.courseActiveSeq}"/>','examItemSeq' : '<c:out value="${row.courseQuizAnswer.examItemSeq}"/>','courseActiveProfSeq':'<c:out value="${row.courseQuizAnswer.courseActiveProfSeq}"/>','quizDtime':'<c:out value="${row.courseQuizAnswer.quizDtime}"/>','count':'<c:out value="${paginate.descIndex - i.index}"/>'});">
									       		결과보기
									       	</a>
								       	</div>
								   	</c:forEach>
							   	</c:when>
							   	<c:otherwise>
							   		<input type="hidden" name="srchCount" id="srchCount"  value="0" />
									<input type="hidden" name="srchQuizDtime" id="srchQuizDtime"  value="0" />
							   	</c:otherwise>
						   	</c:choose>
					   	</div>
				   	</form>
		   		</div>
		   	
		   	</div>
		</div>
	</form>
</body>
</html>