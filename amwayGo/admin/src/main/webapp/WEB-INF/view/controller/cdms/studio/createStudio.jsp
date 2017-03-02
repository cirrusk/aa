<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forEdit     = null;
var forBrowseMember = null;
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
	forListdata.config.url    = "<c:url value="/cdms/studio/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/cdms/studio/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before = function() {
		var $form = jQuery("#" + forInsert.config.formId);
		$form.find(":input[name='weekDay']").val(UT.getCheckedValue($form, "day", ","));
		return true;
	};
	forInsert.config.fn.complete = doCompleteInsert;

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/studio/edit.do"/>";
	
	forBrowseMember = $.action("layer");
	forBrowseMember.config.formId         = "FormBrowseMember";
	forBrowseMember.config.url            = "<c:url value="/member/cdms/list/popup.do"/>";
	forBrowseMember.config.options.width  = 700;
	forBrowseMember.config.options.height = 500;
	forBrowseMember.config.options.title  = "<spring:message code="필드:CDMS:스튜디오담당자"/>";
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:스튜디오명"/>",
		name : "studioName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:CDMS:가용요일"/>",
		name : "day",
		data : ["!null"]
	});
	forInsert.validator.set(function() {
		var result = true;
		jQuery(".input-member").each(function() {
			var $this = jQuery(this);
			var $seq = $this.find(":input[name='memberSeqs']");
			if ($seq.length == 0) {
				result = false;
				$.alert({message : "<spring:message code="글:CDMS:스튜디오담당자를선택하십시오"/>"});
				return false; // each break;
			}
		});
		return result;
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
 * 저장완료
 */
doCompleteInsert = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (parseInt(result.success, 10) >= 1) {
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doEdit({'studioSeq' : result.studioSeq});
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:저장되지않았습니다"/>"
		});
	}
};
/**
 * 담당자 찾기
 */
doBrowseMember = function() {
	forBrowseMember.run();
};
/**
 * 담당자 선택
 */
doSetMember = function(returnValue) {
	var $inputMember = jQuery(".input-member");
	if (returnValue != null) {
		var $seqs = $inputMember.find(":input[name='memberSeqs']");
		for (var index in returnValue) {
			var member = returnValue[index];
			
			var exists = false;
			$seqs.each(function() {
				if (this.value == member.memberSeq) {
					exists = true;
				}
			});
			if (exists == false) {
				var html = [];
				html.push("<li class='input-element'>");
				html.push(member.memberName + "(" + member.memberId + ")");
				html.push("<a href='javascript:void(0)' onclick='doRemoveMember(this)' title='<spring:message code="버튼:삭제"/>'></a>");
				html.push("<input type='hidden' name='memberSeqs' value='" + member.memberSeq + "'/>");
				html.push("</li>");
				$inputMember.append(jQuery(html.join("")));
			}
		}
	}
};
/**
 * 담당자 삭제
 */
doRemoveMember = function(element) {
	var $parent = jQuery(element).closest(".input-element");
	$parent.remove();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchStudio.jsp"/>
	</div>

	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="글:CDMS:기본정보설정"/></h4>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width:120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오명"/><span class="star">*</span></th>
			<td><input type="text" name="studioName" style="width:90%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:가용요일"/><span class="star">*</span></th>
			<td>
				<input type="hidden" name="weekDay">
				<c:set var="cdmsWeekDay" value=""/>
				<c:forEach var="row" begin="0" end="6" step="1" varStatus="i">
					<c:if test="${!empty cdmsWeekDay}">
						<c:set var="cdmsWeekDay" value="${cdmsWeekDay},"/>
					</c:if>
					<c:choose>
						<c:when test="${row eq 0}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:일" /></c:set></c:when>
						<c:when test="${row eq 1}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:월" /></c:set></c:when>
						<c:when test="${row eq 2}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:화" /></c:set></c:when>
						<c:when test="${row eq 3}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:수" /></c:set></c:when>
						<c:when test="${row eq 4}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:목" /></c:set></c:when>
						<c:when test="${row eq 5}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:금" /></c:set></c:when>
						<c:when test="${row eq 6}"><c:set var="cdmsWeekDay"><c:out value="${cdmsWeekDay}"/><c:out value="${row}"/>=<spring:message code="글:CDMS:토" /></c:set></c:when>
					</c:choose>
				</c:forEach>
				<aof:code type="checkbox" name="day" codeGroup="${cdmsWeekDay}" selected="1,2,3,4,5"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오담당자"/><span class="star">*</span></th>
			<td>
				<a href="javascript:void(0)" onclick="doBrowseMember()" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:담당자선택"/></span></a>
				<div class="vspace"></div>
				<ul class="input-member lybox-nobg name-box" style="width:90%;min-height:30px;"></ul>
			</td>
		</tr>
	</tbody>
	</table>
	
	<div style="display:none;">
		<c:forEach var="row" items="${listDefaultTime}" varStatus="i">
			<input type="hidden" name="sortOrders" value="<c:out value="${row.studioTime.sortOrder}"/>"/><br>
			<input type="hidden" name="startTimes" value="<c:out value="${row.studioTime.startTime}"/>"/>
			<input type="hidden" name="endTimes" value="<c:out value="${row.studioTime.endTime}"/>"/>
		</c:forEach>
	</div>
	
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