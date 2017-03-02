<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL"                 value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>
<c:set var="CD_SURVEY_TYPE_COURSESATISFY"           value="${aoffn:code('CD.SURVEY_TYPE.COURSESATISFY')}"/>
<c:set var="CD_SURVEY_TYPE_PROFSATISFY"             value="${aoffn:code('CD.SURVEY_TYPE.PROFSATISFY')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_3POINT"          value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.3POINT')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_4POINT"          value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.4POINT')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_5POINT"          value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.5POINT')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_7POINT"          value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.7POINT')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER"    value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.ESSAY_ANSWER')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ONE_CHOICE"      value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ONE_CHOICE')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE" value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.MULTIPLE_CHOICE')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER"    value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ESSAY_ANSWER')}"/>

<aof:code type="set" var="code3Point" codeGroup="SURVEY_SATISFY_3POINT"/>
<aof:code type="set" var="code4Point" codeGroup="SURVEY_SATISFY_4POINT"/>
<aof:code type="set" var="code5Point" codeGroup="SURVEY_SATISFY_5POINT"/>
<aof:code type="set" var="code7Point" codeGroup="SURVEY_SATISFY_7POINT"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SURVEY_TYPE_GENERAL = "<c:out value="${CD_SURVEY_TYPE_GENERAL}"/>";
var CD_SURVEY_TYPE_COURSESATISFY = "<c:out value="${CD_SURVEY_TYPE_COURSESATISFY}"/>";
var CD_SURVEY_TYPE_PROFSATISFY = "<c:out value="${CD_SURVEY_TYPE_PROFSATISFY}"/>";
var CD_SURVEY_SATISFY_TYPE_3POINT = "<c:out value="${CD_SURVEY_SATISFY_TYPE_3POINT}"/>";
var CD_SURVEY_SATISFY_TYPE_4POINT = "<c:out value="${CD_SURVEY_SATISFY_TYPE_4POINT}"/>";
var CD_SURVEY_SATISFY_TYPE_5POINT = "<c:out value="${CD_SURVEY_SATISFY_TYPE_5POINT}"/>";
var CD_SURVEY_SATISFY_TYPE_7POINT = "<c:out value="${CD_SURVEY_SATISFY_TYPE_7POINT}"/>";
var CD_SURVEY_GENERAL_TYPE_ONE_CHOICE = "<c:out value="${CD_SURVEY_GENERAL_TYPE_ONE_CHOICE}"/>";
var CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE = "<c:out value="${CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE}"/>";
var CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER = "<c:out value="${CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}"/>";

var forListdata = null;
var forInsert   = null;
var code3Point = [];
var code4Point = [];
var code5Point = [];
var code7Point = [];

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doChangeType();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/survey/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/survey/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before = function() {
		jQuery("#" + forInsert.config.formId + " :input[name='surveyExampleTitles']").filter(":disabled").val("");
		return true;
	};
	forInsert.config.fn.complete = function() {
		doList();
	};

	setValidate();
	
	<c:forEach var="row" items="${code3Point}" varStatus="i">
	code3Point.push('<c:out value="${row.codeName}"/>');
	</c:forEach>
	<c:forEach var="row" items="${code4Point}" varStatus="i">
	code4Point.push('<c:out value="${row.codeName}"/>');
	</c:forEach>
	<c:forEach var="row" items="${code5Point}" varStatus="i">
	code5Point.push('<c:out value="${row.codeName}"/>');
	</c:forEach>
	<c:forEach var="row" items="${code7Point}" varStatus="i">
	code7Point.push('<c:out value="${row.codeName}"/>');
	</c:forEach>
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:설문:설문제목"/>",
		name : "surveyTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:설문:설문문항유형"/>",
		name : "surveyItemTypeCd",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:설문:보기"/>",
		name : "surveyExampleTitles",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 설문유형변경
 */
doChangeType = function() {
	var $form = jQuery("#" + forInsert.config.formId);
	var surveyType = $form.find(":input[name='surveyTypeCd']").val();
	
	if (surveyType == CD_SURVEY_TYPE_GENERAL) {
		$form.find(":input[name='surveyGeneralType']").show();
		$form.find(":input[name='surveySatisfyType']").hide();
	} else if (surveyType == CD_SURVEY_TYPE_COURSESATISFY || surveyType == CD_SURVEY_TYPE_PROFSATISFY) {
		$form.find(":input[name='surveyGeneralType']").hide();
		$form.find(":input[name='surveySatisfyType']").show();
	}
	$form.find(":input[name='surveyExampleTitles']").each(function(index){
		this.value = "";
	});
	doChangeItemType();
};
/**
 * 문항유형 변경
 */
doChangeItemType = function() {
	
	var $form = jQuery("#" + forInsert.config.formId);
	var surveyType = $form.find(":input[name='surveyTypeCd']").val();
	var $itemType = null;
	if (surveyType == CD_SURVEY_TYPE_GENERAL) {
		var $generalType = $form.find(":input[name='surveyGeneralType']");
		$itemType = $form.find(":input[name='surveyItemTypeCd']");
		$itemType.val($generalType.val());
	} else if (surveyType == CD_SURVEY_TYPE_COURSESATISFY || surveyType == CD_SURVEY_TYPE_PROFSATISFY) {
		var $satisfyType = $form.find(":input[name='surveySatisfyType']");
		$itemType = $form.find(":input[name='surveyItemTypeCd']");
		$itemType.val($satisfyType.val());
	}

	if ($itemType.length > 0) {
		var $selectCount = jQuery("#selectCount");
		var $examples = jQuery("#examples");
		switch($itemType.val()) {
		case CD_SURVEY_SATISFY_TYPE_3POINT:
			//오름차순 주석처리
// 			jQuery("#selectSort").show();
			$selectCount.hide();
			$selectCount.find(":input[name='exampleCount']").val("3");
			$examples.find(":input").attr("disabled", false);
			$examples.show();
			doSetSatisfyScore();
			break;
		case CD_SURVEY_SATISFY_TYPE_4POINT:
			//오름차순 주석처리
// 			jQuery("#selectSort").show();
			$selectCount.hide();
			$selectCount.find(":input[name='exampleCount']").val("4");
			$examples.find(":input").attr("disabled", false);
			$examples.show();
			doSetSatisfyScore();
			break;
		case CD_SURVEY_SATISFY_TYPE_5POINT:
			//오름차순 주석처리
// 			jQuery("#selectSort").show();
			$selectCount.hide();
			$selectCount.find(":input[name='exampleCount']").val("5");
			$examples.find(":input").attr("disabled", false);
			$examples.show();
			doSetSatisfyScore();
			break;
		case CD_SURVEY_SATISFY_TYPE_7POINT:
			//오름차순 주석처리
// 			jQuery("#selectSort").show();
			$selectCount.hide();
			$selectCount.find(":input[name='exampleCount']").val("7");
			$examples.find(":input").attr("disabled", false);
			$examples.show();
			doSetSatisfyScore();
			break;
		case CD_SURVEY_GENERAL_TYPE_ONE_CHOICE:
		case CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE:
			jQuery("#selectSort").hide();
			$selectCount.show();
			$selectCount.find(":input[name='exampleCount']").val("5");
			$examples.find(":input").attr("disabled", false);
			$examples.show();
			doChangeExampleCount();
			jQuery(".satisfy_score").hide();
			jQuery(":input[name='measureScores']").val("1");
			break;
		case CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER:
			jQuery("#selectSort").hide();
			$examples.find(":input").attr("disabled", true);
			$examples.hide();
			jQuery(".satisfy_score").hide();
			jQuery(":input[name='measureScores']").val("1");
			break;
		}
	}
};
/**
 * 보기점수세팅
 */
doSetSatisfyScore = function() {
	doChangeExampleCount();

	jQuery(".satisfy_score").show();
	var $examples = jQuery("#examples");
	var sort = $examples.find(":input[name='scoreSort']").filter(":checked").val();
	var $measureScores = jQuery(":input[name='measureScores']").not(":disabled");
	if (sort == "asc") {
		$measureScores.each(function(index) {
			this.value = index + 1;
		});
	} else {
		$measureScores.each(function(index) {
			this.value = $measureScores.length - index;
		});
	}
};
/**
 * 보기수 변경
 */
doChangeExampleCount = function(element) {
	
	var $examples = jQuery("#examples");
	var count = 0;
	if (typeof element === "object") {
		$examples.find(":input[name='exampleCount']").val(jQuery(element).val());
		count = $examples.find(":input[name='exampleCount']").val();
	} else {
		count = $examples.find(":input[name='exampleCount']").val();
	}
	count = parseInt(count, 10);
	$examples.find(".example").each(function(index){
		if (index < count) {
			jQuery(this).show().find(":input").attr("disabled", false);
		} else {
			jQuery(this).hide().find(":input").attr("disabled", true);
		}
	});
	var $form = jQuery("#" + forInsert.config.formId);
	var surveyType = $form.find(":input[name='surveyTypeCd']").val();
	if (surveyType == CD_SURVEY_TYPE_COURSESATISFY || surveyType == CD_SURVEY_TYPE_PROFSATISFY) {
		var $itemType = $form.find(":input[name='surveyItemTypeCd']");
		var sort = $examples.find(":input[name='scoreSort']").filter(":checked").val();
		var codePoint = [];
		
		switch($itemType.val()) {
		case CD_SURVEY_SATISFY_TYPE_3POINT:
			for (var i = 0; i < code3Point.length; i++) {
				codePoint.push(code3Point[i]);
			}
			break;
		case CD_SURVEY_SATISFY_TYPE_4POINT:
			for (var i = 0; i < code4Point.length; i++) {
				codePoint.push(code4Point[i]);
			}
			break;
		case CD_SURVEY_SATISFY_TYPE_5POINT:
			for (var i = 0; i < code5Point.length; i++) {
				codePoint.push(code5Point[i]);
			}
			break;
		case CD_SURVEY_SATISFY_TYPE_7POINT:
			for (var i = 0; i < code7Point.length; i++) {
				codePoint.push(code7Point[i]);
			}
			break;
		}
		if (sort == "desc") {
			codePoint.reverse();
		}
		$form.find(":input[name='surveyExampleTitles']").each(function(index){
			if (codePoint.length > index) {
				this.value = codePoint[index];
			}
		});
	}
	
};
</script>
</head>

<body>

<c:set var="upDown">asc=<spring:message  code="글:설문:오름차순"/>,desc=<spring:message  code="글:설문:내림차순"/></c:set>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchUnivSurvey.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:설문:설문유형"/></th>
			<td>
				<select name="surveyTypeCd" onchange="doChangeType()">
					<aof:code type="option" codeGroup="SURVEY_TYPE" defaultSelected="${CD_SURVEY_TYPE_GENERAL}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문제목"/></th>
			<td>
				<textarea name="surveyTitle" style="width:65%;height:15px;"></textarea>
			</td>
		</tr>
		<tr id="surveyType">
			<th><spring:message code="필드:설문:설문문항유형"/></th>
			<td>
				<input type="hidden" name="surveyItemTypeCd"/>
				<select name="surveyGeneralType" onchange="doChangeItemType()">
					<aof:code type="option" codeGroup="SURVEY_GENERAL_TYPE" defaultSelected="${CD_SURVEY_GENERAL_TYPE_ONE_CHOICE}" />
				</select>
				<select name="surveySatisfyType" onchange="doChangeItemType()">
					<aof:code type="option" codeGroup="SURVEY_SATISFY_TYPE" defaultSelected="${CD_SURVEY_SATISFY_TYPE_7POINT}" except="${CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER}"/>
				</select>
			</td>
		</tr>
		<tr id="examples">
			<td colspan="2">
				<ul>
					<li id="selectCount" style="line-height:25px;">
						<spring:message code="필드:설문:보기수"/>&nbsp;&nbsp;
						<input type="hidden" name="exampleCount" value="5">
						<select name="generalExampleCount" onchange="doChangeExampleCount(this)" style="width:50px;">
							<aof:code type="option" codeGroup="2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10,11=11,12=12,13=13,14=14,15=15,16=16,17=17,18=18,19=19,20=20" defaultSelected="5"/>
						</select>
					</li>
					<li id="selectSort" style="display:none;line-height:25px;">
						<span style="margin-right: 5px;"><spring:message code="필드:설문:점수"/></span>
						<aof:code type="radio" name="scoreSort" codeGroup="${upDown}" defaultSelected="desc" onclick="doSetSatisfyScore()"/>
					</li>
					<c:forEach var="row" begin="1" end="20" step="1" varStatus="i">
						<li style="line-height:25px;" class="example">
							<spring:message code="글:설문:${row}"/>
							<input type="hidden" name="surveyExampleSeqs">
							<input type="hidden" name="sortOrders" value="<c:out value="${row}"/>">
							<input type="text" name="surveyExampleTitles" style="width:480px;">
							<span class="satisfy_score">
								<spring:message code="필드:설문:점수"/>
								<input type="text" name="measureScores" value="1" style="width:30px;text-align:center;">
							</span>
						</li>
					</c:forEach>
				</ul>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>