<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit = null;
var forDetail = null;
var forBrowseSurvey = null;
var forSubInsertlist = null;
var forSubUpdatelist = null;
var forSubDeletelist = null;
var forScript = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/surveypaper/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/surveypaper/edit.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/surveypaper/detail.do"/>";
		
	forBrowseSurvey = $.action("layer");
	forBrowseSurvey.config.formId         = "FormBrowseSurvey";
	forBrowseSurvey.config.url            = "<c:url value="/univ/survey/list/popup.do"/>";
	forBrowseSurvey.config.options.width  = 700;
	forBrowseSurvey.config.options.height = 500;
	forBrowseSurvey.config.options.title  = "<spring:message code="필드:설문:설문문제"/>";	
	
	forSubInsertlist = $.action("submit", {formId : "SubFormInsert"});
	forSubInsertlist.config.url             = "<c:url value="/univ/surveypaperelement/insertlist.do"/>";
	forSubInsertlist.config.target          = "hiddenframe";
	forSubInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubInsertlist.config.fn.complete     = doSubCompleteInsertlist;

	forSubUpdatelist = $.action("submit", {formId : "SubFormData"});
	forSubUpdatelist.config.url             = "<c:url value="/univ/surveypaperelement/updatelist.do"/>";
	forSubUpdatelist.config.target          = "hiddenframe";
	forSubUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forSubUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubUpdatelist.config.fn.complete     = function() {
		doRefresh();
	};

	forSubDeletelist = $.action("submit", {formId : "SubFormData"});
	forSubDeletelist.config.url             = "<c:url value="/univ/surveypaperelement/deletelist.do"/>";
	forSubDeletelist.config.target          = "hiddenframe";
	forSubDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forSubDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubDeletelist.config.fn.complete     = doSubCompleteDeletelist;
	forSubDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null","trim"]
	});
	
	forScript = $.action("script", {formId : "SubFormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScript.validator.set({
		title : "<spring:message code="필드:이동할데이터"/>",
		name : "checkkeys",
		data : ["!null","trim"]
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
	doDetail({'surveyPaperSeq' : '<c:out value="${detail.univSurveyPaper.surveyPaperSeq}"/>'});
};
/**
 * 설문문제찾기
 */
 doBrowseSurvey = function() {
	forBrowseSurvey.run();
};
/**
 * 문제추가
 */
doSubInsertlist = function(returnValue) {
	if (returnValue != null && returnValue.length) {
		var $form = jQuery("#" + forSubInsertlist.config.formId);
		var html = [];
		var sortOrder = jQuery("#SubFormData").find(":input[name='surveyCount']").val();
		sortOrder = parseInt(sortOrder, 10) + 1;
		for (var index in returnValue) {
			html.push("<input type='hidden' class='append' name='surveySeqs' value='" + returnValue[index].surveySeq + "'>");
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
		message : "<spring:message code="글:추가되었습니다"/>",
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
	jQuery("#" + forSubUpdatelist.config.formId + " :input[name=sortOrders]").each(function(index) {
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
 * 위로
 */
doUp = function() {
	var valid = forScript.validator.isValid();
	if (valid == false) {
		return;
	}
	jQuery("#" + forScript.config.formId + " tr").each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $prev = $this.prev("tr");
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
	jQuery("#" + forScript.config.formId + " tr").reverse().each(function(index) {
		var $this = jQuery(this);
		var $checkbox = $this.find(":input[name=checkkeys]").filter(":checked");
		if ($checkbox.length > 0) {
			var $next = $this.next("tr");
			if($next.length > 0) {
				if ($next.find(":input[name=checkkeys]").filter(":checked").length == 0) {
					$this.insertAfter($next);
				}
			}
		}
	});
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchUnivSurveyPaper.jsp"/>
	</div>
	
	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.univSurveyPaper.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.univSurveyPaper.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:설문:설문지제목" /></th>
			<td><c:out value="${detail.univSurveyPaper.surveyPaperTitle}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문지구분" /></th>
			<td><aof:code type="print" codeGroup="SURVEY_PAPER_TYPE" selected="${detail.univSurveyPaper.surveyPaperTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문지설명"/></td>
			<td><aof:text type="text" value="${detail.univSurveyPaper.description}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:사용여부"/></th>
			<td><aof:code type="print" name="useYn" codeGroup="YESNO" ref="2" selected="${detail.univSurveyPaper.useYn}" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${detail.univSurveyPaper.useCount gt 0}">
				<span class="comment"><spring:message code="글:설문:활용중인데이터는수정및삭제를할수없습니다"/></span>
			</c:if>	
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.univSurveyPaper.useCount eq 0}">
					<a href="#" onclick="doBrowseSurvey();"
						class="btn blue"><span class="mid"><spring:message code="버튼:설문:문제추가"/></span></a>
					<a href="#" onclick="doEdit({'surveyPaperSeq' : '<c:out value="${detail.univSurveyPaper.surveyPaperSeq}"/>'});"
						class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<form name="FormBrowseSurvey" id="FormBrowseSurvey" method="post" onsubmit="return false;">
		<input type="hidden" name="srchUseYn"               value="Y" />
		<input type="hidden" name="srchNotInSurveyPaperSeq" value="<c:out value="${detail.univSurveyPaper.surveyPaperSeq}" />"/>
		<input type="hidden" name="srchSurveyPaperTypeCd"        value="<c:out value="${detail.univSurveyPaper.surveyPaperTypeCd}" />" />
		<input type="hidden" name="callback" value="doSubInsertlist"/>
		<input type="hidden" name="select" value="multiple"/>
	</form>

	<form name="SubFormInsert" id="SubFormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="surveyPaperSeq" value="<c:out value="${detail.univSurveyPaper.surveyPaperSeq}"/>" />
	</form>
	
	<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
		<input type="hidden" name="surveyPaperSeq"    value="<c:out value="${detail.univSurveyPaper.surveyPaperSeq}"/>"/>
	</form>

	<div class="clear"><br></div>
	
	<div id="elementContainer">
		<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
	
		<table id="listTable" class="tbl-list">
		<colgroup>
			<c:if test="${detail.univSurveyPaper.useCount eq 0}">
				<col style="width: 40px" />
			</c:if>
			<col style="width: 40px" />
			<col style="width: auto" />
			<col style="width: 100px" />
			<col style="width: 70px" />
			<col style="width: 70px" />
		</colgroup>
		<thead>
			<tr>
				<c:if test="${detail.univSurveyPaper.useCount eq 0}">
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('SubFormData','checkkeys','checkButton');" /></th>
				</c:if>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:설문:설문제목" /></th>
				<th><spring:message code="필드:설문:설문유형" /></th>
				<th><spring:message code="필드:설문:설문지" /><br><spring:message code="필드:설문:활용수" /></th>
				<th><spring:message code="필드:설문:사용여부" /></th>
			</tr>
		</thead>
		<tbody>
		<c:set var="surveyCount" value="0"/>
		<c:forEach var="row" items="${listElement}" varStatus="i">
			<tr>
				<c:if test="${detail.univSurveyPaper.useCount eq 0}">
					<td>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="surveyPaperSeqs" value="<c:out value="${row.univSurveyPaperElement.surveyPaperSeq}" />">
						<input type="hidden" name="surveySeqs" value="<c:out value="${row.univSurveyPaperElement.surveySeq}" />">
						<input type="hidden" name="sortOrders" value="<c:out value="${row.univSurveyPaperElement.sortOrder}" />">
					</td>
				</c:if>
		        <td><c:out value="${i.count}"/></td>
				<td class="align-l"><c:out value="${row.univSurvey.surveyTitle}" /></td>
		        <td>
					<aof:code type="print" codeGroup="SURVEY_TYPE" selected="${row.univSurvey.surveyTypeCd}"/>
		        </td>
				<td><c:out value="${row.univSurvey.useCount}"/></td>
				<td><aof:code type="print" codeGroup="YESNO" ref="2" selected="${row.univSurvey.useYn}" removeCodePrefix="true"/></td>
			</tr>
			<c:set var="surveyCount" value="${surveyCount + 1}"/>
		</c:forEach>
		<c:if test="${empty listElement}">
			<tr>
				<c:choose>
					<c:when test="${detail.univSurveyPaper.useCount eq 0}">
						<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</c:when>
					<c:otherwise>
						<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:if>
		</tbody>
		</table>
		<input type="hidden" name="surveyCount" value="<c:out value="${surveyCount}"/>"/>
		</form>
		
		<div class="lybox-btn">
			<div id="checkButton" class="lybox-btn-l" style="display:none;">
				<c:if test="${!empty listElement and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') and detail.univSurveyPaper.useCount eq 0}">
					<a href="javascript:void(0)" onclick="doSubDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
				</c:if>
				<c:if test="${aoffn:size(listElement) ge 2 and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.univSurveyPaper.useCount eq 0}">
					<a href="javascript:void(0)" onclick="doUp()" class="btn blue"><span class="mid"><spring:message code="버튼:위로"/></span></a>
					<a href="javascript:void(0)" onclick="doDown()" class="btn blue"><span class="mid"><spring:message code="버튼:아래로"/></span></a>
					<a href="javascript:void(0)" onclick="doSubUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:설문:순서저장" /></span></a>
				</c:if>
			</div>
		</div>
			
	</div>
</body>
</html>