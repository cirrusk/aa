<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON"   value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_SCORE_TYPE_001"  value="${aoffn:code('CD.SCORE_TYPE.001')}"/>
<c:set var="CD_SCORE_TYPE_002"  value="${aoffn:code('CD.SCORE_TYPE.002')}"/>
<c:set var="CD_SCORE_TYPE_003"  value="${aoffn:code('CD.SCORE_TYPE.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SCORE_TYPE_001 = "<c:out value="${CD_SCORE_TYPE_001}"/>";
var CD_SCORE_TYPE_002 = "<c:out value="${CD_SCORE_TYPE_002}"/>";
var CD_SCORE_TYPE_003 = "<c:out value="${CD_SCORE_TYPE_003}"/>";

var forListdata = null;
var forEdit = null;
var forDetail = null;
var forBrowseExam = null;
var forSubInsertlist = null;
var forSubUpdatelist = null;
var forSubDeletelist = null;
var forSubUpdate = null;
var forScript = null;
var forPreview = null;
var forExcel = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	<c:if test="${detail.courseExamPaper.randomYn eq 'Y'}">
	doSetItemCount();
	doSetRandomOption();
	doCheckPreviewRandomPaper();
	</c:if>
	<c:if test="${detail.courseExamPaper.randomYn eq 'N'}">
	doSetPaperNumber();
	doCheckPreviewPaper();
	</c:if>

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exampaper/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/exampaper/edit.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/exampaper/detail.do"/>";
	
	forBrowseExam = $.action("layer");
	forBrowseExam.config.formId = "FormBrowseExam";
	forBrowseExam.config.url = "<c:url value="/univ/exam/list/popup.do"/>";
	forBrowseExam.config.options.width  = 700;
	forBrowseExam.config.options.height = 500;
	forBrowseExam.config.options.title  = "<spring:message code="글:시험:문제추가"/>";

	forSubInsertlist = $.action("submit", {formId : "SubFormInsert"});
	forSubInsertlist.config.url             = "<c:url value="/univ/exampaper/element/insertlist.do"/>";
	forSubInsertlist.config.target          = "hiddenframe";
	forSubInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubInsertlist.config.fn.complete     = doSubCompleteInsertlist;
	
	forSubUpdatelist = $.action("submit", {formId : "SubFormData"});
	forSubUpdatelist.config.url             = "<c:url value="/univ/exampaper/element/updatelist.do"/>";
	forSubUpdatelist.config.target          = "hiddenframe";
	forSubUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdatelist.config.fn.complete     = function() {
		doRefresh();
	};

	forSubUpdate = $.action("submit", {formId : "SubFormEdit"});
	forSubUpdate.config.url             = "<c:url value="/univ/exampaper/option/update.do"/>";
	forSubUpdate.config.target          = "hiddenframe";
	forSubUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdate.config.fn.complete     = function() {
		doRefresh();
	};

	forSubDeletelist = $.action("submit", {formId : "SubFormData"});
	forSubDeletelist.config.url             = "<c:url value="/univ/exampaper/element/deletelist.do"/>";
	forSubDeletelist.config.target          = "hiddenframe";
	forSubDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forSubDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubDeletelist.config.fn.complete     = doSubCompleteDeletelist;
	
	forScript = $.action("script", {formId : "SubFormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	
	forPreview = $.action("layer");
	forPreview.config.formId = "FormPreview";
	forPreview.config.url = "<c:url value="/univ/exampaper/preview/popup.do"/>";
	forPreview.config.options.width  = 750;
	forPreview.config.options.height = 600;
	forPreview.config.options.title  = "<spring:message code="글:시험:미리보기"/>";
	
	forExcel = $.action("layer");
	forExcel.config.formId         = "FormExcel";
	forExcel.config.url            = "<c:url value="/univ/exampaper/excel/popup.do"/>";
	forExcel.config.options.width  = 550;
	forExcel.config.options.height = 550;
	forExcel.config.options.title  = "<spring:message code="필드:시험:Excel문제등록"/>";
	forExcel.config.options.scrolling  = "yes";
	
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forScript.validator.set({
		title : "<spring:message code="필드:이동할데이터"/>",
		name : "checkkeys",
		data : ["!null","trim"]
	});

	forSubDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null","trim"]
	});
	
	forSubUpdate.validator.set({
		title : "<spring:message code="필드:시험:출제수"/>",
		name : "question",
		data : ["!null","trim", "number"],
		check : {
			maxlength : 3
		}
	});
	forSubUpdate.validator.set(function() {
		var $form = jQuery("#" + forSubUpdate.config.formId);
		var result = true;
		$form.find(":input[name='question']").each(function() {
			var $this = jQuery(this);
			var $sibling = $this.siblings(":input[name^='total-']");
			var thisValue = parseInt($this.val(), 10);
			var siblingValue = parseInt($sibling.val(), 10);
			
			if (thisValue > siblingValue) {
				$.alert({
					message : "<spring:message code="글:시험:문제수보다출제수가더클수없습니다"/>",
					button1 : {
						callback : function() {
							$this.focus();
						}
					}
				});
				result = false;
				return false;
			}
		});
		return result;
	});
	forSubUpdate.validator.set(function() {
		var result = true;
		
		var examInfo = doGetExamInfoForUpdate();
		if (examInfo.count == 0) {
			$.alert({message : "<spring:message code="글:시험:출제수를입력하십시오"/>"});
			result = false;
			return result;
		}
		if (examInfo.totalScore % examInfo.itemScore != 0) {
			$.alert({message : "<spring:message code="글:시험:문항당점수가유효한점수가아닙니다"/><br><spring:message code="글:시험:출제문제수를수정하십시오"/>"});
			result = false;
			return result;
		}
		return result;
	});
	forSubUpdatelist.validator.set(function() {
		var result = true;
		
		var examInfo = doGetExamInfoForUpdatelist();
		for (var index = 0; index < examInfo.length; index++) {
			if (examInfo[index].count == 0) {
				$.alert({message : "<spring:message code="글:시험:문제지의문제를선택하십시오"/>"});
				result = false;
				return result;
			}
			if (examInfo[index].totalScore % examInfo[index].itemScore != 0) {
				var $form = jQuery("#" + forSubUpdatelist.config.formId);
				var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
				if (scoreTypeCd == CD_SCORE_TYPE_002){
					result = true;
				} else {
					$.alert({message : "<spring:message code="글:시험:문항당점수가유효한점수가아닙니다"/><br><spring:message code="글:시험:출제문제수를수정하십시오"/>"});
					result = false;
				}
				return result;
			}
		}
		if (examInfo.length > 1) {
			for (var index = 1; index < examInfo.length; index++) {
				if (examInfo[index].count != examInfo[0].count) {
					$.alert({message : "<spring:message code="글:시험:문제지별문항수가일치하지않습니다"/><br><spring:message code="글:시험:출제문제수를수정하십시오"/>"});
					result = false;
					return result;
				}
			}
		}
		return result;
	});
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};
/**
 * 새로고침
 */
doRefresh = function() {
	doDetail({'examPaperSeq' : '<c:out value="${detail.courseExamPaper.examPaperSeq}"/>'});
};
/**
 * 문제추가화면을 호출하는 함수
 */
doBrowseExam = function() {
	forBrowseExam.run();
};
/**
 * 랜덤옵션 저장
 */
doSubUpdate = function() {
	var $form = jQuery("#" + forSubUpdate.config.formId);
	var values = "";
	$form.find(":input[name='question']").each(function(index) {
		
		if (this.value != "" && this.value != "0") {
			if (values.length > 0) {
				values += ",";
			}
			var name = this.className.replaceAll("question-", "").split(" ");
			values += (name.join("-") + "=" + this.value);
		}
	});
	$form.find(":input[name='randomOption']").val(values);
	forSubUpdate.run();
};
/**
 * 문제추가
 */
doSubInsertlist = function(returnValue) {
	var $form = jQuery("#" + forSubInsertlist.config.formId);
	
	if (returnValue != null && returnValue.length) {
		var html = [];
		var totalPaperNumber = jQuery("#SubFormData").find(":input[name='totalPaperNumber']").val();
		if (totalPaperNumber == "") {
			totalPaperNumber = 1;
		}
		totalPaperNumber = parseInt(totalPaperNumber, 10);
		var paperNumber = 1;
		for (var i = 1; i < totalPaperNumber; i++) {
			paperNumber += Math.pow(2, i);
		}
		var sortOrder = jQuery("#SubFormData").find(":input[name='examCount']").val();
		sortOrder = parseInt(sortOrder, 10) + 1;
		for (var index in returnValue) {
			html.push("<input type='hidden' class='append' name='examSeqs' value='" + returnValue[index].examSeq + "'>");
			html.push("<input type='hidden' class='append' name='paperNumbers' value='" + paperNumber + "'>");
			html.push("<input type='hidden' class='append' name='sortOrders' value='" + (sortOrder++) + "'>");
		}
		jQuery(html.join("")).appendTo($form);
		forSubInsertlist.run();
	}
	
	$form.find(".append").remove();
};
/**
 * 문제추가 완료
 */
doSubCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가추가되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doRefresh();
			}
		}
	});
};
/**
 * 목록에서 저장할 때 호출되는 함수
 */
doSubUpdatelist = function() {
	var $form = jQuery("#" + forSubUpdatelist.config.formId); 
	 $form.find(":input[name=sortOrders]").each(function(index) {
		this.value = index + 1;
	});
	 
	forSubUpdatelist.run();
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doSubDeletelist = function() {
	forSubDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doSubCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doRefresh();
			}
		}
	});
};
/**
 * 문제지에 대한 checkbox 만들기.
 */
doSetPaperNumber = function() {
	var $form = jQuery("#" + forSubUpdatelist.config.formId);
	var totalPaperNumber = $form.find(":input[name='totalPaperNumber']").val();
	if (totalPaperNumber == "") {
		totalPaperNumber = 1;
	}
	totalPaperNumber = parseInt(totalPaperNumber, 10);

	jQuery(".paperNumber").each(function(index) {
		var $this = jQuery(this);
		var binary = Number($this.val()).toString(2).split('');
		binary.reverse();
		var id = $this.attr("id");
		for(var i = 0; i < totalPaperNumber; i++) {
			var html = [];
			html.push("<li class='paperNumberLi'>");
			html.push("<input type='checkbox' class='paperCheck' name='" + id + "-" + index + "' onclick='doComputePaperNumber(this)'");
			if (binary.length > i && binary[i] == "1") {
				html.push(" checked='checked' ");
			}
			html.push("></li>");
			var $checkbox = jQuery(html.join(" "));
			$checkbox.insertBefore($this);
		}
	});
	
	jQuery(".paperNumberUl").each(function() {
		var $this = jQuery(this);
		var width = 0;
		$this.find("li").each(function(){
			width += parseInt(jQuery(this).css("width"), 10) + 2;
		}); 
		$this.css("width", width + "px");
		var tdWidth = (width + 10) < 60 ? 60 : (width + 10);
		jQuery("#column").css("width", tdWidth + "px");		
	});

	doCountItem();
};
/**
 * 문제수 계산. randomYn = N 일때.
 */
doCountItem = function() {
	var $form = jQuery("#" + forSubUpdatelist.config.formId);
	$form.find(".scorePerItem").closest("div").removeClass("warning");
	
	var examInfo = doGetExamInfoForUpdatelist();
	
	// 문제수
	$form.find(".paper").each(function(index){
		jQuery(this).html(examInfo[index].count);
	});
	// 문제당점수
	$form.find(".scorePerItem").each(function(index){
		var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
		if (scoreTypeCd == CD_SCORE_TYPE_002){
			$form.find(".scorePerExam").each(function(index){
				jQuery(this).hide();
			});
		} else {
			jQuery(this).html(examInfo[index].itemScore);
		}
	});
	// 총점
	$form.find(".totalScore").each(function(index){
		jQuery(this).html(examInfo[index].totalScore);
	});
	
	var invalidItemCount = false; 
	for (var index = 0; index < examInfo.length; index++) {
		if (examInfo[index].count == 0 || examInfo[index].totalScore % examInfo[index].itemScore != 0) {
			$form.find(".scorePerItem").eq(index).closest("div").addClass("warning");
		}
		if (examInfo[index].count != examInfo[0].count) {
			invalidItemCount = true;	
		}
	}
	if (invalidItemCount == true) {
		jQuery("#examItemCountWarning").show();
	} else {
		jQuery("#examItemCountWarning").hide();
	}
};
/**
 * 문항당점수 계산. randomYn = Y 일때.
 */
doItemScore = function() {
	var $form = jQuery("#" + forSubUpdate.config.formId);
	$form.find(".scorePerItem").closest("div").removeClass("warning");
	
	var examInfo = {count : 0, itemScore : 0, totalScore : 0};
	var itemCount = $form.find(":input[name='sum-question']").val();
	itemCount = itemCount == "" ? 0 : parseInt(itemCount, 10);
	examInfo.count = itemCount;
	
	var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
	
	if (scoreTypeCd == CD_SCORE_TYPE_003) {
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.totalScore = score;
		examInfo.itemScore = examInfo.count == 0 ? 0 : examInfo.totalScore / examInfo.count;
	} else if (scoreTypeCd == CD_SCORE_TYPE_001){
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.itemScore = score;
		examInfo.totalScore = examInfo.itemScore * examInfo.count;
	} else {
	}
	// 문제당점수
	$form.find(".scorePerItem").each(function(){
		jQuery(this).html(examInfo.itemScore);
	});
	// 총점
	$form.find(".totalScore").each(function(){
		jQuery(this).html(examInfo.totalScore);
	});
	if (examInfo.count == 0 || examInfo.totalScore % examInfo.itemScore != 0) {
		$form.find(".scorePerItem").closest("div").addClass("warning");
	}
	$form.find(":input[name='question']").each(function() {
		var $this = jQuery(this);
		var $sibling = $this.siblings(":input[name^='total-']");
		var thisValue = parseInt($this.val(), 10);
		var siblingValue = parseInt($sibling.val(), 10);
		if (thisValue > siblingValue) {
			$this.addClass("warning2");
		} else {
			$this.removeClass("warning2");
		}
	});
};
/**
 * db에 저장할 paper 번호 만들기(2진수 -> 10진수)
 */
doComputePaperNumber = function(element) {
	var $element = jQuery(element);
	var $parent = $element.parents("ul");
	var $input = $parent.find(":input[name='paperNumbers']");
	var value = 0;
	$parent.find(":input[type='checkbox']").each(function(index) {
		if (this.checked == true) {
			value += Math.pow(2, index);
		}
	});
	$input.val(value);
	doCountItem();
};
/**
 * 문제지 전체선택
 */
doCheckAllPaper = function(paperNumber) {
	jQuery(".paperNumberUl").each(function() {
		var $this = jQuery(this);
		$this.find(":input[type='checkbox']").each(function(index){
			if (paperNumber == index) {
				this.checked = true;
				doComputePaperNumber(this);
			}
		});
	});
};
/**
 * 위로
 */
doUp = function() {
	var valid = forScript.validator.isValid();
	if (valid == false) {
		return;
	}
	jQuery("#" + forScript.config.formId + " tbody").each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $prev = $this.prev("tbody");
			if($prev.length > 0) {
				if ($prev.find(":input[name=checkkeys]").filter(":checked").length == 0) {
					$this.insertBefore($prev);
				}
			}
		}
	});
};
/**
 * 아래로
 */
doDown = function() {
	var valid = forScript.validator.isValid();
	if (valid == false) {
		return;
	}
	jQuery("#" + forScript.config.formId + " tbody").reverse().each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $next = $this.next("tbody");
			if($next.length > 0) {
				if ($next.find(":input[name=checkkeys]").filter(":checked").length == 0) {
					$this.insertAfter($next);
				}
			}
		}
	});
};
/**
 * 문제수 randomYn = Y 일때.
 */
doSetItemCount = function() {
	var $form2 = jQuery("#SubFormData");
	var $form1 = jQuery("#SubFormEdit");
	
	$form1.find(":input[name^='total-']").each(function(){
		var $this = jQuery(this);
		var clazz = this.className.split(" ");
		$this.val($form2.find(":input[name='examSeqs']").filter("." + clazz[0]).length);
	});
};
/**
 * 랜덤옵션 문제수 및 합계 계산 하기
 */
doSetRandomOption = function() {
	var $table = jQuery("#detailTable");
	$table.find(":input[name='col-sum-total']").each(function(){
		var $this = jQuery(this);
		var sum = 0;
		$this.closest("tr").find(":input[name^='total-']").each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	$table.find(":input[name='col-sum-question']").each(function(){
		var $this = jQuery(this);
		var sum = 0;
		$this.closest("tr").find(":input[name='question']").each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	$table.find(":input[name='row-sum-total']").each(function(){
		var $this = jQuery(this);
		var clazz = this.className;
		var sum = 0;
		$table.find(":input[name^='total-']").filter("." + clazz).each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	$table.find(":input[name='row-sum-question']").each(function(){
		var $this = jQuery(this);
		var clazz = this.className;
		var sum = 0;
		$table.find(":input[name='question']").filter("." + clazz).each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	$table.find(":input[name='sum-total']").each(function(){
		var $this = jQuery(this);
		var sum = 0;
		$table.find(":input[name='row-sum-total']").each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	$table.find(":input[name='sum-question']").each(function(){
		var $this = jQuery(this);
		var sum = 0;
		$table.find(":input[name='row-sum-question']").each(function(){
			sum += this.value == "" ? 0 : parseInt(this.value, 10);
		});
		$this.val(sum);
	});
	doItemScore();
};
/**
 * examInfo (문항수, 문항당점수, 총점) 구하기
 */
doGetExamInfoForUpdatelist = function() {
	var $form = jQuery("#" + forSubUpdatelist.config.formId);
	var totalPaperNumber = $form.find(":input[name='totalPaperNumber']").val();
	if (totalPaperNumber == "") {
		totalPaperNumber = 1;
	}
	totalPaperNumber = parseInt(totalPaperNumber, 10);
	var examInfo = [];
	for(var i = 0; i < totalPaperNumber; i++) {
		examInfo.push({count : 0, itemScore : 0, totalScore : 0});
	}

	$form.find(".paperNumberUl").each(function() {
		var $this = jQuery(this);
		$this.find(":input[type='checkbox']").each(function(index){
			if (this.checked == true) {
				var $tbody = jQuery(this).closest("tbody");
				var size = $tbody.find("tr").length;
				examInfo[index].count += size > 1 ? size - 1 : 1;
			}
		});
	});
	var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
	if (scoreTypeCd == CD_SCORE_TYPE_003) {
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		for (var index = 0; index < examInfo.length; index++) {
			examInfo[index].totalScore = score;
			examInfo[index].itemScore = examInfo[index].count == 0 ? 0 : examInfo[index].totalScore / examInfo[index].count;
		}
	} else if(scoreTypeCd == CD_SCORE_TYPE_001) {
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		for (var index = 0; index < examInfo.length; index++) {
			examInfo[index].itemScore = score;
			examInfo[index].totalScore = examInfo[index].itemScore * examInfo[index].count;
		}
	} else if(scoreTypeCd == CD_SCORE_TYPE_002){
		var score = $form.find(":input[name='examScores']").val();
		for (var index = 0; index < examInfo.length; index++) {
			examInfo[index].totalScore = Number(score);
		}
	}
	return examInfo;
};
/**
 * examInfo (문항수, 문항당점수, 총점) 구하기
 */
doGetExamInfoForUpdate = function() {
	var $form = jQuery("#" + forSubUpdate.config.formId);
	
	var examInfo = {count : 0, itemScore : 0, totalScore : 0};
	var itemCount = $form.find(":input[name='sum-question']").val();
	itemCount = itemCount == "" ? 0 : parseInt(itemCount, 10);
	examInfo.count = itemCount;
	
	var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
	
	if (scoreTypeCd == CD_SCORE_TYPE_003) {
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.totalScore = score;
		examInfo.itemScore = examInfo.count == 0 ? 0 : examInfo.totalScore / examInfo.count;
	} else if(scoreTypeCd == CD_SCORE_TYPE_001) {
		var score = $form.find(":input[name='examPaperScore']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.itemScore = score;
		examInfo.totalScore = examInfo.itemScore * examInfo.count;
	} else {
		
	}
	return examInfo;
};
/**
 * 미리보기
 */
doPreview = function(mapPKs) {
	UT.getById(forPreview.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forPreview.config.formId);
	forPreview.run();
};
/**
 * 미리보기 가능여부 검사 randomYn = 'Y' 일때
 */
doCheckPreviewRandomPaper = function() {
	var $form = jQuery("#" + forSubUpdate.config.formId);
	
	var examInfo = {count : 0, itemScore : 0, totalScore : 0};
	var itemCount = $form.find(":input[name='sum-question']").val();
	itemCount = itemCount == "" ? 0 : parseInt(itemCount, 10);
	examInfo.count = itemCount;
	
	var scoreTypeCd = $form.find(":input[name='scoreTypeCd']").val();
	
	if (scoreTypeCd == CD_SCORE_TYPE_003) {
		var score = $form.find(":input[name='score']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.totalScore = score;
		examInfo.itemScore = examInfo.count == 0 ? 0 : examInfo.totalScore / examInfo.count;
	} else if (scoreTypeCd == CD_SCORE_TYPE_001) {
		var score = $form.find(":input[name='score']").val();
		score = score == "" ? 0 : parseFloat(score);
		examInfo.itemScore = score;
		examInfo.totalScore = examInfo.itemScore * examInfo.count;
	} else {
		
	}
	if (examInfo.count == 0 || examInfo.totalScore % examInfo.itemScore != 0) {
		$form.find(".scorePerItem").closest("div").find(".preview").hide();
	}
};
/**
 * 미리보기 가능여부 검사 randomYn = 'N' 일때
 */
doCheckPreviewPaper = function() {
	var $form = jQuery("#" + forSubUpdatelist.config.formId);
	
	var examInfo = doGetExamInfoForUpdatelist();
	for (var index = 0; index < examInfo.length; index++) {
		if (examInfo[index].count == 0 || examInfo[index].totalScore % examInfo[index].itemScore != 0) {
			$form.find(".scorePerItem").eq(index).closest("div").find(".preview").hide();
		}
	}
};
/*
 * 엑셀 등록 및 문제 추가
 */
 doExcel = function(){
	forExcel.run();
};
/*
 * 엑셀 등록 팝업에서 문제 추가 된후 문제 등록
 */
 doExcalExamPaperInsert = function(returnValue){
	 if (returnValue != null && returnValue.length) {
		 doSubInsertlist(returnValue);	 
	 }
	 
};
</script>
<style type="text/css">
.paperNumberUl {text-align:center;margin:auto;}
.paperNumberLi {width:25px;float:left;border:1px solid #ffffff;}
.minibutton {width:25px;float:left;border:1px solid #000000;background-color:#ffffff;cursor:pointer;}
.warning {color : #ff0000;}
.warning2 {background-color:#ff0000; color:#ffffff;}
</style>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseExamPaper.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.courseExamPaper.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.courseExamPaper.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:시험지구분" /></th>
			<td><aof:code type="print" codeGroup="EXAM_PAPER_TYPE" selected="${detail.courseExamPaper.examPaperTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:교과목선택"/></td>
			<td>
				<c:out value="${detail.courseMaster.courseTitle}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:담당교수"/></td>
			<td>
				<c:out value="${detail.courseExamPaper.profMemberName}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지제목" /></th>
			<td><c:out value="${detail.courseExamPaper.examPaperTitle}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지형태"/></th>
			<td>
                <%/** TODO : 코드*/ %>
                <aof:code type="print" codeGroup="ONOFF_TYPE" name="onOffCd" selected="${detail.courseExamPaper.onOffCd}"/>
            </td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지설명"/></td>
			<td><aof:text type="text" value="${detail.courseExamPaper.description}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:점수구분" /></th>
			<td><aof:code type="print" codeGroup="SCORE_TYPE" selected="${detail.courseExamPaper.scoreTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:점수" /></th>
			<td><c:out value="${aoffn:trimDouble(detail.courseExamPaper.examPaperScore)}"/><spring:message code="글:시험:점"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문제랜덤여부"/></th>
			<td><aof:code type="print" codeGroup="YESNO" selected="${detail.courseExamPaper.randomYn}" removeCodePrefix="true"/></td>
		</tr>
		<c:if test="${detail.courseExamPaper.randomYn eq 'Y'}">
			<tr>
				<th><spring:message code="필드:시험:출제그룹"/></th>
				<td><c:out value="${detail.courseExamPaper.groupKey}"/></td>
			</tr>
		</c:if>
		<c:if test="${detail.courseExamPaper.randomYn eq 'N'}">
			<tr>
				<th><spring:message code="필드:시험:문제지수"/></th>
				<td><c:out value="${detail.courseExamPaper.paperCount}"/></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:시험:사용여부"/></th>
			<td><aof:code type="print" codeGroup="YESNO" ref="2" selected="${detail.courseExamPaper.useYn}" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${detail.courseExamPaper.useCount gt 0}">
				<span class="comment"><spring:message code="글:시험:활용중인데이터는수정및삭제를할수없습니다"/></span>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') and detail.courseExamPaper.randomYn ne 'Y' and detail.courseExamPaper.useCount eq 0 and detail.courseExamPaper.onOffCd eq CD_ONOFF_TYPE_ON}">
	<%-- 			<a href="javascript:void(0)" onclick="doExcel()" class="btn blue"><span class="mid"><spring:message code="버튼:시험:문제간편등록" /></span></a> --%>
				<a href="javascript:void(0)" onclick="doBrowseExam()" class="btn blue"><span class="mid"><spring:message code="버튼:시험:문제추가" /></span></a>
			</c:if>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExamPaper.useCount eq 0 }">
				<a href="#" onclick="doEdit({'examPaperSeq' : '<c:out value="${detail.courseExamPaper.examPaperSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<c:if test="${detail.courseExamPaper.onOffCd eq CD_ONOFF_TYPE_ON}">
		<form name="SubFormInsert" id="SubFormInsert" method="post" onsubmit="return false;">
			<input type="hidden" name="examPaperSeq" value="<c:out value="${detail.courseExamPaper.examPaperSeq}"/>" />
		</form>
		
		<form name="FormExcel" id="FormExcel" method="post" onsubmit="return false;">
			<input type="hidden" name="courseMasterSeq"   value="<c:out value="${detail.courseExamPaper.courseMasterSeq}"/>" />
			<input type="hidden" name="scoreTypeCd"        value="<c:out value="${detail.courseExamPaper.scoreTypeCd}"/>" />
			<input type="hidden" name="totalScore"        value="<c:out value="${aoffn:trimDouble(detail.courseExamPaper.examPaperScore)}"/>" />
			<input type="hidden" name="isExamItemCount"        value="<c:out value="${aoffn:size(listElement)}"/>" />
			<input type="hidden" name="callback" value="doExcalExamPaperInsert"/>
		</form>
	
		<form name="FormBrowseExam" id="FormBrowseExam" method="post" onsubmit="return false;">
			<input type="hidden" name="srchNotInExamPaperSeq" value="<c:out value="${detail.courseExamPaper.examPaperSeq}"/>" />
			<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${detail.courseExamPaper.courseMasterSeq}"/>" />
			<input type="hidden" name="srchProfMemberSeq"   value="<c:out value="${detail.courseExamPaper.profMemberSeq}"/>" />
			<input type="hidden" name="srchUseYn" value="Y" />
			<input type="hidden" name="callback" value="doSubInsertlist"/>
			<input type="hidden" name="select" value="multiple"/>
			
			<input type="hidden" name="scoreTypeCd"        value="<c:out value="${detail.courseExamPaper.scoreTypeCd}"/>" />
			<input type="hidden" name="totalScore"        value="<c:out value="${aoffn:trimDouble(detail.courseExamPaper.examPaperScore)}"/>" />
			<input type="hidden" name="isExamItemCount"        value="<c:out value="${aoffn:size(listElement)}"/>" />
		</form>
		
		<c:if test="${detail.courseExamPaper.randomYn eq 'Y'}">
			<aof:code type="set" var="examItemTypeCode" codeGroup="EXAM_ITEM_TYPE" removeCodePrefix="true"/>
			<aof:code type="set" var="examDifficultyCode" codeGroup="EXAM_ITEM_DIFFICULTY" removeCodePrefix="true"/>
		
			<form id="SubFormEdit" name="SubFormEdit" method="post" onsubmit="return false;">
			<input type="hidden" name="examPaperSeq" value="<c:out value="${detail.courseExamPaper.examPaperSeq}" />">
			<input type="hidden" name="randomOption" value="">
			
			<input type="hidden" name="scoreTypeCd" value="<c:out value="${detail.courseExamPaper.scoreTypeCd}"/>"/>		
			<input type="hidden" name="examPaperScore" value="<c:out value="${detail.courseExamPaper.examPaperScore}"/>"/>
		
			<div class="comment align-l" style="margin-bottom:5px;">
				<span style="margin-left:10px;"><spring:message code="필드:시험:문항당점수" /></span>
				<strong class="scorePerItem">0</strong><spring:message code="글:시험:점" />
				<span style="margin-left:10px;"><spring:message code="필드:시험:총점" /></span>
				<strong class="totalScore">0</strong><spring:message code="글:시험:점" />
				<span class="preview" style="margin-left:10px;">
					<a href="javascript:void(0)" class="btn gray" 
						onclick="doPreview({'examPaperSeq':'<c:out value="${detail.courseExamPaper.examPaperSeq}"/>'})" 
						><span class="small"><spring:message code="버튼:미리보기" /></span></a>
				</span>
			</div>
			
			<table class="tbl-detail" id="detailTable">
			<thead>
				<tr>
					<th style="width:120px;">&nbsp;</th>
					<c:forEach var="rowSub" items="${examDifficultyCode}" varStatus="iSub">
						<th class="textCenter">
							<span style="line-height:22px;"><c:out value="${rowSub.codeName}"/></span><br>
							<span style="font-weight:normal;line-height:22px;"><spring:message code="필드:시험:문제수" />&nbsp;&nbsp;&nbsp;<spring:message code="필드:시험:출제수" /></span>
						</th>	
					</c:forEach>
					<th class="textCenter">
						<span style="line-height:22px;"><spring:message code="필드:시험:합계"/></span><br>
						<span style="font-weight:normal;line-height:22px;"><spring:message code="필드:시험:문제수" />&nbsp;&nbsp;&nbsp;<spring:message code="필드:시험:출제수" /></span>
					</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="row" items="${examItemTypeCode}" varStatus="i">
				<tr>
					<th>${row.codeName}</th>
					<c:forEach var="rowSub" items="${examDifficultyCode}" varStatus="iSub">
						<td class="textCenter">
							<input type="text" name="total-<c:out value="T${row.code}"/>-<c:out value="D${rowSub.code}"/>" value="0" 
								class="<c:out value="T${row.code}"/>-<c:out value="D${rowSub.code}"/> total-<c:out value="T${row.code}"/> total-<c:out value="D${rowSub.code}"/>" 
								style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
							<c:set var="countValue" value="0"/>
							<c:set var="key" value="T${row.code}-D${rowSub.code}"/>
							<c:if test="${!empty randomOption[key]}">
								<c:set var="countValue" value="${randomOption[key]}"/>
							</c:if>
							<input type="text" name="question" value="<c:out value="${countValue}"/>" 
								class="question-<c:out value="T${row.code}"/> question-<c:out value="D${rowSub.code}"/>" 
								style="width:40px;text-align:center;"
								onchange="doSetRandomOption()"
								>
						</td>	
					</c:forEach>
					<th class="textCenter" style="padding:0px;">
						<input type="text" name="col-sum-total" value="0"  
							style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
						<input type="text" name="col-sum-question" value="0" 
							style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
					</th>
				</tr>
				</c:forEach>
				<tr>
					<th><spring:message code="필드:시험:합계"/></th>
					<c:forEach var="rowSub" items="${examDifficultyCode}" varStatus="iSub">
						<th class="textCenter" style="padding:0px;">
							<input type="text" name="row-sum-total" value="0" class="total-<c:out value="D${rowSub.code}"/>"
								style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
							<input type="text" name="row-sum-question" value="0" class="question-<c:out value="D${rowSub.code}"/>" 
								style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
						</th>	
					</c:forEach>
					<th class="textCenter" style="padding:0px;">
						<input type="text" name="sum-total" value="0"  
							style="width:40px;text-align:center;background-color:#d1d1d1;border:1px #d1d1d1 solid;" readonly="readonly">
						<input type="text" name="sum-question" value="0" 
							style="width:40px;text-align:center;background-color:yellow;border:1px #d1d1d1 solid;" readonly="readonly">
					</th>
				</tr>
			</tbody>
			</table>
			</form>
			
			<div class="vspace"></div>
		
			<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
			<c:forEach var="row" items="${listExamItem}" varStatus="i">
				<c:if test="${aoffn:contains(detail.courseExamPaper.groupKey, row.groupKey, ',')}">
					<input type="hidden" name="examSeqs" value="<c:out value="${row.examSeq}"/>" 
						class="<c:out value="T${aoffn:substringLastAfter(row.examItemTypeCd, '::')}"/>-<c:out value="D${aoffn:substringLastAfter(row.examItemDifficultyCd, '::')}"/>"
					>
				</c:if>
			</c:forEach>
			<input type="hidden" name="examPaperScore" value="<c:out value="${detail.courseExamPaper.examPaperScore}"/>"/>
			</form>
			
		<div class="lybox-btn">
			<div class="lybox-btn-l">
			</div>
			<div class="lybox-btn-r">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExamPaper.useCount eq 0}">
					<a href="javascript:void(0)" onclick="doSubUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
				</c:if>
			</div>
		</div>		
		
		</c:if>
		<c:if test="${detail.courseExamPaper.randomYn eq 'N'}">
			<div id="elementContainer">
	
				<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
				<input type="hidden" name="totalPaperNumber" value="<c:out value="${detail.courseExamPaper.paperCount}"/>">
	
				<input type="hidden" name="scoreTypeCd" value="<c:out value="${detail.courseExamPaper.scoreTypeCd}"/>"/>		
				<input type="hidden" name="examPaperScore" value="<c:out value="${detail.courseExamPaper.examPaperScore}"/>"/>
			
				<div style="position:relative;">
				<c:forEach var="row" begin="1" end="${detail.courseExamPaper.paperCount}" step="1" varStatus="i">
					<div class="comment align-l" style="margin-bottom:5px;">
						<strong><span style="margin-left:15px;"><spring:message code="필드:시험:문제지" />${row}</span></strong> 
						: <strong class="paper">0</strong><spring:message code="필드:시험:문제" />
						<span class="scorePerExam"><span style="margin-left:10px;"><spring:message code="필드:시험:문항당점수" /></span>
						<strong class="scorePerItem">0</strong><spring:message code="글:시험:점" /></span>
						<span style="margin-left:10px;"><spring:message code="필드:시험:총점" /></span>
						<strong class="totalScore">0</strong><spring:message code="글:시험:점" />
						<span class="preview" style="margin-left:10px;">
							<a href="javascript:void(0)" class="btn gray" 
								onclick="doPreview({'examPaperSeq':'<c:out value="${detail.courseExamPaper.examPaperSeq}"/>','paperNumber':'${row}'})" 
								><span class="small"><spring:message code="버튼:미리보기" /></span></a>
						</span>
					</div>
					<c:if test="${row eq 1}">
						<div id="examItemCountWarning" class="comment align-l warning" style="position:absolute;right:0px;bottom:3px; display:none;">
							<span style="margin-left:15px;"><spring:message code="글:시험:문제지별문항수가일치하지않습니다"/></span>
						</div>
					</c:if>
				</c:forEach>
				</div>
				
				<table id="listTable" class="tbl-list">
				<colgroup>
					<c:if test="${detail.courseExamPaper.useCount eq 0}">
						<col style="width: 35px" />
					</c:if>
					<col style="width: 40px" />
					<col style="width: 100px" />
					<col style="width: auto" />
					<col style="width: 60px" />
					<col style="width: 130px" id="column"/>
				</colgroup>
				<thead>
					<tr>
						<c:if test="${detail.courseExamPaper.useCount eq 0}">
							<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('SubFormData','checkkeys', 'checkButton');" /></th>
						</c:if>
						<th><spring:message code="필드:번호" /></th>
						<th><spring:message code="필드:시험:문제문항유형" /></th>
						<th><spring:message code="필드:시험:문제제목" /></th>
						<th><spring:message code="필드:시험:시험지활용수" /></th>
						<th>
							<spring:message code="필드:시험:문제지" /><br>
							<ul class="paperNumberUl">
							<c:forEach var="row" begin="1" end="${detail.courseExamPaper.paperCount}" step="1" varStatus="i">
								<li class="minibutton" title="<spring:message code="필드:전체" /><spring:message code="글:선택" />"
									onclick="doCheckAllPaper(${row - 1})"><c:out value="${row}"/></li>
							</c:forEach>
							</ul>
						</th>
					</tr>
				</thead>
				<c:set var="setExamSeq" value=""/>
				<c:set var="examCount" value="0"/>
				<c:set var="examScores" value="0"/>
				<c:set var="tbody" value="0"/>
				<c:forEach var="row" items="${listElement}" varStatus="i">
					<c:if test="${row.courseExam.examCount gt 1 and setExamSeq ne row.courseExam.examSeq}">
						<tbody>
						<c:set var="tbody" value="1"/>
						<tr>
							<c:if test="${detail.courseExamPaper.useCount eq 0}">
								<td class="sub">
									<input type="checkbox" name="checkkeys" value="<c:out value="${examCount}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
									<input type="hidden" name="examPaperSeqs" value="<c:out value="${row.courseExamPaperElement.examPaperSeq}" />">
									<input type="hidden" name="examSeqs" value="<c:out value="${row.courseExamPaperElement.examSeq}" />">
									<input type="hidden" name="sortOrders" value="<c:out value="${row.courseExamPaperElement.sortOrder}" />">
								</td>
							</c:if>
							<td class="sub">※</td>
							<td class="sub"><spring:message code="필드:시험:세트문제"/>(<c:out value="${row.courseExam.examCount}"/>)</td>
							<td class="align-l sub"><c:out value="${row.courseExam.title}" /></td>
							<td class="sub"><c:out value="${row.courseExam.useCount}"/></td>
							<td class="sub">
								<ul class="paperNumberUl">
									<input type="hidden" name="paperNumbers" value="<c:out value="${row.courseExamPaperElement.paperNumber}"/>"
										class="paperNumber" id="<c:out value="${row.courseExamPaperElement.examSeq}"/>"
									>
								</ul>
							</td>
							<c:set var="setExamSeq" value="${row.courseExam.examSeq}"/>
							<c:set var="examCount" value="${examCount + 1}"/>
						</tr>
					</c:if>
					<c:choose>
						<c:when test="${row.courseExam.examCount gt 1 and setExamSeq eq row.courseExam.examSeq}">
							<tr>
								<td class="sub">&nbsp;</td>
								<td class="sub"><c:out value="${i.count}"/></td>
								<td class="sub"><aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${row.courseExamItem.examItemTypeCd}"/></td>
								<td colspan="3" class="align-l sub"><c:out value="${row.courseExamItem.examItemTitle}" /></td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:if test="${tbody eq 1}">
								</tbody>
								<c:set var="tbody" value="0"/>
							</c:if>
							<tbody>
							<tr>
								<c:if test="${detail.courseExamPaper.useCount eq 0}">
									<td>
										<input type="checkbox" name="checkkeys" value="<c:out value="${examCount}" />" onclick="FN.onClickCheckbox(this, 'checkButton')">
										<input type="hidden" name="examPaperSeqs" value="<c:out value="${row.courseExamPaperElement.examPaperSeq}" />">
										<input type="hidden" name="examSeqs" value="<c:out value="${row.courseExamPaperElement.examSeq}" />">
										<input type="hidden" name="sortOrders" value="<c:out value="${row.courseExamPaperElement.sortOrder}" />">
									</td>
								</c:if>
								<td><c:out value="${i.count}"/></td>
								<td><aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${row.courseExamItem.examItemTypeCd}"/></td>
								<td class="align-l"><c:out value="${row.courseExamItem.examItemTitle}" /></td>
								<td><c:out value="${row.courseExam.useCount}"/></td>
								<td>
									<ul class="paperNumberUl">
										<input type="hidden" name="paperNumbers" value="<c:out value="${row.courseExamPaperElement.paperNumber}"/>"
											class="paperNumber" id="<c:out value="${row.courseExamPaperElement.examSeq}"/>"
										>
									</ul>
								</td>
							</tr>
							</tbody>
							<c:set var="examCount" value="${examCount + 1}"/>
							<c:set var="examScores" value="${examScores + row.courseExamItem.examItemScore}"/>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${empty listElement}">
					<tbody>
					<tr>
						<c:choose>
							<c:when test="${detail.courseExamPaper.useCount eq 0}">
								<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
							</c:when>
							<c:otherwise>
								<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
							</c:otherwise>
						</c:choose>
					</tr>
					</tbody>
				</c:if>
				</table>
				<input type="hidden" name="examCount" value="<c:out value="${examCount}"/>"/>
				<input type="hidden" name="examScores" value="<c:out value="${examScores}"/>"/>
				</form>
				
				<div class="lybox-btn">
					<div id="checkButton" class="lybox-btn-l" style="display:none;">
						<c:if test="${!empty listElement and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and detail.courseExamPaper.useCount eq 0}">
							<a href="javascript:void(0)" onclick="doSubDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
						</c:if>
						<c:if test="${aoffn:size(listElement) ge 2 and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExamPaper.useCount eq 0}">
							<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid"><spring:message code="버튼:위로"/></span></a>
							<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid"><spring:message code="버튼:아래로"/></span></a>
						</c:if>
					</div>
					<div class="lybox-btn-r">
						<c:if test="${!empty listElement and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.courseExamPaper.useCount eq 0}">
							<a href="javascript:void(0)" onclick="doSubUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
						</c:if>
					</div>
				</div>
				
			</div>
		</c:if>
	</c:if>
</body>
</html>