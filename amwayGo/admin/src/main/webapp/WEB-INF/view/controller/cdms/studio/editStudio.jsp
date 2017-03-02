<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="cdmsHour" value=""/>
<c:forEach var="row" begin="0" end="23" varStatus="i">
	<c:if test="${!empty cdmsHour}">
		<c:set var="cdmsHour" value="${cdmsHour},"/>
	</c:if>
	<c:choose>
		<c:when test="${row lt 10}">
			<c:set var="cdmsHour"><c:out value="${cdmsHour}"/><c:out value="0${row}"/><c:out value="=0${row}"/><spring:message code="글:시"/></c:set>
		</c:when>
		<c:otherwise>
			<c:set var="cdmsHour"><c:out value="${cdmsHour}"/><c:out value="${row}"/><c:out value="=${row}"/><spring:message code="글:시"/></c:set>
		</c:otherwise>
	</c:choose>
</c:forEach>

<c:set var="cdmsMinute" value=""/>
<c:forEach var="row" begin="0" end="50" step="10" varStatus="i">
	<c:if test="${!empty cdmsMinute}">
		<c:set var="cdmsMinute" value="${cdmsMinute},"/>
	</c:if>
	<c:choose>
		<c:when test="${row lt 10}">
			<c:set var="cdmsMinute"><c:out value="${cdmsMinute}"/><c:out value="0${row}"/><c:out value="=0${row}"/><spring:message code="글:분"/></c:set>
		</c:when>
		<c:otherwise>
			<c:set var="cdmsMinute"><c:out value="${cdmsMinute}"/><c:out value="${row}"/><c:out value="=${row}"/><spring:message code="글:분"/></c:set>
		</c:otherwise>
	</c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forDelete   = null;
var forUpdate   = null;
var forUpdateTime = null;
var forEdit     = null;
var forBrowseMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doDisplayPlusDeleteIcon();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/studio/list.do"/>";

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/cdms/studio/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/studio/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before = function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		$form.find(":input[name='weekDay']").val(UT.getCheckedValue($form, "day", ","));
		return true;
	};
	forUpdate.config.fn.complete = doCompleteUpdate;

	forUpdateTime = $.action("submit", {formId : "FormUpdateTime"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdateTime.config.url             = "<c:url value="/cdms/studio/time/update.do"/>";
	forUpdateTime.config.target          = "hiddenframe";
	forUpdateTime.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdateTime.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateTime.config.fn.before = function() {
		var $form = jQuery("#" + forUpdateTime.config.formId);
		$form.find(":input[name='sortOrders']").each(function(index) {
			this.value = index + 1;
		});
		return true;
	};
	forUpdateTime.config.fn.complete = doCompleteUpdate;

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
	forUpdate.validator.set({
		title : "<spring:message code="필드:CDMS:스튜디오명"/>",
		name : "studioName",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set(function() {
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
	
	forUpdateTime.validator.set({
		title : "<spring:message code="필드:CDMS:시작시간"/>",
		name : "startHours",
		data : ["!null"]
	});
	forUpdateTime.validator.set({
		title : "<spring:message code="필드:CDMS:시작시간"/>",
		name : "startMinutes",
		data : ["!null"]
	});
	forUpdateTime.validator.set({
		title : "<spring:message code="필드:CDMS:종료시간"/>",
		name : "endHours",
		data : ["!null"]
	});
	forUpdateTime.validator.set({
		title : "<spring:message code="필드:CDMS:종료시간"/>",
		name : "endMinutes",
		data : ["!null"]
	});
	forUpdateTime.validator.set(function() {
		var $form = jQuery("#" + forUpdateTime.config.formId);
		
		var $invalidTime = null;
		var prevValue = null;
		jQuery(".time").each(function() {
			if (prevValue > this.value) {
				$invalidTime = jQuery(this).siblings(".time-element").filter(":first");
				return false; // each break;
			}
			prevValue = this.value;
		});
		if ($invalidTime != null && $invalidTime.length > 0) {
			$.alert({
				message : "<spring:message code="글:CDMS:이전시간보다이후의시간으로선택하십시오"/>",
				button1 : {
					callback : function() {
						$invalidTime.get(0).focus();
					}
				}
			});
			return false;
		}
		return true;
	});
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
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
 * 수정완료
 */
doCompleteUpdate = function(result) {
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
			message : "<spring:message code="글:CDMS:오류가발생하여적용되지않았습니다"/>"
		});
	}
};
/**
 * 저장
 */
doUpdateTime = function() { 
	forUpdateTime.run();
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
				html.push("<input type='hidden' name='oldMemberSeqs'/>");
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
	var $delete = jQuery(".delete-member");
	var $element = jQuery(element);
	
	var $deleteMember = $element.siblings(":input[name='memberSeqs']");
	$deleteMember.attr("name", "deleteMemberSeqs");
	$deleteMember.appendTo($delete);
	var $parent = $element.closest(".input-element");
	$parent.remove();
};
/**
 * 추가, 삭제 icon 보이기/감추기 
 */
doDisplayPlusDeleteIcon = function() {
	var $form = jQuery("#" + forUpdateTime.config.formId);
	var $time = $form.find(".cdms-time");
	if ($time.length > 1) {
		$time.each(function () {
			$time.find(".icon-delete").css("visibility", "visible");
			$time.find(".icon-plus").css("visibility", "hidden");
		});
		$time.filter(":last").find(".icon-plus").css("visibility", "visible");;
	} else {
		$time.find(".icon-delete").css("visibility", "hidden");;
		$time.find(".icon-plus").css("visibility", "visible");;
	}
	$form.find(".index").each(function(index) {
		jQuery(this).text(index + 1);
	});
};
/**
 * 시간 추가
 */
doPlusTime = function(element) {
	var $element = jQuery(element);
	var $time = $element.closest(".cdms-time");
	var $clone = $time.clone();
	$clone.find(":input").val("");
	$clone.insertAfter($time);
	doDisplayPlusDeleteIcon();
};
/**
 * 시간 삭제
 */
doDeleteTime = function(element) {
	var $delete = jQuery("#delete-times");
	var $time = jQuery(element).closest(".cdms-time");
	var $seq = $time.find(":input[name='studioTimeSeqs']");
	$seq.attr("name", "deleteStudioTimeSeqs");
	$delete.append($seq);
	$time.remove();
	doDisplayPlusDeleteIcon();
};
/**
 * 시간 변경 
 */
doChangeTime = function(element) {
	var $element = jQuery(element);
	var $timeSet = $element.closest(".time-set");
	var time = "";
	$timeSet.find(".time-element").each(function() {
		time += jQuery(this).val();
	});
	$timeSet.find(".time").val(time);
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchStudio.jsp"/>
		<form name="FormDelete" id="FormDelete" method="post" onsubmit="return false;">
			<input type="hidden" name="studioSeq" value="<c:out value="${detailStudio.studio.studioSeq}"/>"/>
		</form>
	</div>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailStudio.studio.studioName}"/></h4>
		<div class="right">
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<table class="tbl-layout">
	<colgroup>
		<col style="width:50%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<h4 class="section-title mt10"><spring:message code="글:CDMS:기본정보" /></h4>
				
				<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
				<input type="hidden" name="studioSeq" value="<c:out value="${detailStudio.studio.studioSeq}"/>"/>
				<table class="tbl-detail mt10">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:CDMS:스튜디오명"/><span class="star">*</span></th>
						<td><input type="text" name="studioName" style="width:90%;" value="<c:out value="${detailStudio.studio.studioName}"/>"></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:가용요일"/><span class="star">*</span></th>
						<td>
							<input type="hidden" name="weekDay" value="<c:out value="${detailStudio.studio.weekDay}"/>">
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
							<aof:code type="checkbox" name="day" codeGroup="${cdmsWeekDay}" selected="${detailStudio.studio.weekDay}"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:스튜디오담당자"/><span class="star">*</span></th>
						<td>
							<a href="javascript:void(0)" onclick="doBrowseMember(this)" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:담당자선택"/></span></a>
							<div class="vspace"></div>
							<ul class="input-member lybox-nobg name-box" style="width:90%;min-height:30px;">
								<c:forEach var="rowSub" items="${detailStudio.listStudioMember}" varStatus="iSub">
									<li class="input-element">
										<c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)
										<a href="javascript:void(0)" onclick="doRemoveMember(this)" title="<spring:message code="버튼:삭제"/>"></a>
										<input type="hidden" name="memberSeqs" value="<c:out value="${rowSub.member.memberSeq}"/>"/>
										<input type="hidden" name="oldMemberSeqs" value="<c:out value="${rowSub.member.memberSeq}"/>"/>
									</li>
								</c:forEach>
							</ul>
							<div class="delete-member" style="display:none;"></div>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:사용여부"/></th>
						<td><aof:code name="useYn" type="radio" codeGroup="YESNO" selected="${detailStudio.studio.useYn}" removeCodePrefix="true" ref="2"/></td>
					</tr>
				</tbody>
				</table>
				</form>

				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
							<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
						</c:if>
					</div>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</div>

			</td>
			<td>
				<h4 class="section-title mt10"><spring:message code="글:CDMS:스튜디오시간정보" /></h4>
			
				<form id="FormUpdateTime" name="FormUpdateTime" method="post" onsubmit="return false;">
				<input type="hidden" name="studioSeq" value="<c:out value="${detailStudio.studio.studioSeq}"/>"/>
				<table class="tbl-detail mt10">
				<colgroup>
					<col style="width:50px" />
					<col style="width:auto" />
					<col style="width:auto" />
					<col style="width:80px" />
				</colgroup>
				<thead>
					<tr>
						<th class="align-c"><spring:message code="필드:번호" /></th>
						<th class="align-c"><spring:message code="필드:CDMS:시작시간" /></th>
						<th class="align-c"><spring:message code="필드:CDMS:종료시간" /></th>
						<th class="align-c"><spring:message code="버튼:삭제" />|<spring:message code="버튼:추가" /></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${listStudioTime}" varStatus="i">
					<tr class="cdms-time">
				        <td class="align-c">
				        	<span class="index"><c:out value="${i.count}"/></span>
				        	<input type="hidden" name="studioTimeSeqs" value="<c:out value="${row.studioTime.studioTimeSeq}"/>"/>
				        	<input type="hidden" name="sortOrders" value="<c:out value="${i.count}"/>"/>
				        </td>
						<td class="align-c">
							<div class="time-set">
								<input type="hidden" name="startTimes" value="<c:out value="${row.studioTime.startTime}"/>" class="time"/>
								<c:set var="startHour" value="00"/>
								<c:set var="startMinute" value="00"/>
								<c:if test="${!empty row.studioTime.startTime and fn:length(row.studioTime.startTime) eq 4}">
									<c:set var="startHour" value="${fn:substring(row.studioTime.startTime, 0, 2)}"/>
									<c:set var="startMinute" value="${fn:substring(row.studioTime.startTime, 2, 4)}"/>
								</c:if>
								<select name="startHours" class="time-element" onchange="doChangeTime(this)">
									<option value=""></option>
									<aof:code type="option" codeGroup="${cdmsHour}" selected="${startHour}"/>
								</select>
								<select name="startMinutes" class="time-element" onchange="doChangeTime(this)">
									<option value=""></option>
									<aof:code type="option" codeGroup="${cdmsMinute}" selected="${startMinute}"/>
								</select>
							</div>
						</td>
						<td class="align-c">
							<div class="time-set">
								<input type="hidden" name="endTimes" value="<c:out value="${row.studioTime.endTime}"/>" class="time"/>
								<c:set var="endHour" value="00"/>
								<c:set var="endMinute" value="00"/>
								<c:if test="${!empty row.studioTime.endTime and fn:length(row.studioTime.endTime) eq 4}">
									<c:set var="endHour" value="${fn:substring(row.studioTime.endTime, 0, 2)}"/>
									<c:set var="endMinute" value="${fn:substring(row.studioTime.endTime, 2, 4)}"/>
								</c:if>
								<select name="endHours" class="time-element" onchange="doChangeTime(this)">
									<option value=""></option>
									<aof:code type="option" codeGroup="${cdmsHour}" selected="${endHour}"/>
								</select>
								<select name="endMinutes" class="time-element" onchange="doChangeTime(this)">
									<option value=""></option>
									<aof:code type="option" codeGroup="${cdmsMinute}" selected="${endMinute}"/>
								</select>
							</div>
						</td>
						<td class="align-c">
							<div class="icon-delete inline-block" onclick="doDeleteTime(this)" style="visibility:hidden;" title="<spring:message code="버튼:삭제"/>"></div>
							<div class="icon-plus inline-block" onclick="doPlusTime(this)" style="visibility:hidden;" title="<spring:message code="버튼:추가"/>"></div>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty listStudioTime}">
					<tr>
						<td colspan="4" class="align-c"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</table>
				
				<div id="delete-times"></div>
				
				</form>
				
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdateTime();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</div>
				</div>
							
			</td>
		</tr>
	</tbody>
	</table>

</body>
</html>