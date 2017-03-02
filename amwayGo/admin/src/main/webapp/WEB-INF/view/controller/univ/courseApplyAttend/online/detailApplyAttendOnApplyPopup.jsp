<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_001" value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003" value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>

<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="srchKeyBefore"><c:out value="${CD_ATTEND_TYPE_001}"/>=<spring:message code="필드:출석결과:출석"/>,<c:out value="${CD_ATTEND_TYPE_003}"/>=<spring:message code="필드:출석결과:지각"/>,<c:out value="${CD_ATTEND_TYPE_002}"/>=<spring:message code="필드:출석결과:결석"/></c:set>
<c:set var="srchKeyAfter"><c:out value="${CD_ATTEND_TYPE_001}"/>=<spring:message code="필드:출석결과:출석"/>,<c:out value="${CD_ATTEND_TYPE_003}"/>=<spring:message code="글:과정:수강중"/>,<c:out value="${CD_ATTEND_TYPE_002}"/>=<spring:message code="글:과정:수강전"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">
var forList            = null;
var forUpdatelist       = null;
var forSortOrderDetail  = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
	
doInitializeLocal = function() {
	
	forList = $.action();
	forList.config.formId         = "FormData";
	forList.config.url            = "<c:url value="/univ/course/online/attend/result/apply/detail/popup.do"/>";
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/online/attend/result/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	
	forSortOrderDetail = $.action();
	forSortOrderDetail.config.formId         = "FormDetailWeek";
	forSortOrderDetail.config.url            = "<c:url value="/univ/course/online/attend/result/week/detail/popup.do"/>";
	
	setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdatelist.validator.set({
	    title : "<spring:message code="필드:출석결과:진도율"/>",
	    name : "progressMeasures",
	    data : ["!null", "decimalnumber"],
	    check : {
	    	le : 100
	    }
	});
};

/**
 * 진도율 수정하기
 */
doUpdatelist = function() {
	forUpdatelist.run();
};
 
 /**
  * 목록보기 가져오기 실행.
  */
doList = function() {
	 forList.run();
};

/**
 * 주차별 팝업으로 이동
 */
doDetailWeek = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forSortOrderDetail.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forSortOrderDetail.config.formId);
    // 상세화면 실행
    forSortOrderDetail.run();
};
 /**
  * 목록수정 완료
  */
doCompleteUpdatelist = function() {
 	$.alert({
 		message : "<spring:message code="글:수정되었습니다"/>",
 		button1 : {
 			callback : function() {
 				doList();
 			}
 		}
 	});
 };
 
/**
 * 진도율 수정 text 출력
 */
doEditShow = function(){
	jQuery(".profressText", jQuery("#FormData")).each(
			function() {
				jQuery(this).show();
	});
	jQuery(".profressPrint", jQuery("#FormData")).each(
			function() {
				jQuery(this).hide();
	});
	
	jQuery("#update_af").show();
	jQuery("#cancle_a").show();
	jQuery("#update_a").hide();
};

/**
 * 진도율 수정 text 출력 제거
 */
doEditHide = function(){
	jQuery(".profressText", jQuery("#FormData")).each(
			function() {
				jQuery(this).hide();
	});
	jQuery(".profressPrint", jQuery("#FormData")).each(
			function() {
				jQuery(this).show();
	});
	
	jQuery("#update_af").hide();
	jQuery("#cancle_a").hide();
	jQuery("#update_a").show();
};

</script>
</head>

<body>
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	
	<form id="FormDetailWeek" name="FormDetailWeek" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${activeElement.courseActiveSeq}"/>"/>
		<input type="hidden" name="courseApplySeq" value="<c:out value="${activeElement.courseApplySeq}"/>"/>
		<input type="hidden" name="courseTypeCd" value="<c:out value="${activeElement.courseTypeCd}"/>"/>
		<input type="hidden" name="learnerId" value="<c:out value="${param['memberSeq']}"/>"/>
		<input type="hidden" name="memberSeq" value="<c:out value="${param['memberSeq']}"/>"/>
		<input type="hidden" name="memberName" value="<c:out value="${param['memberName']}"/>"/>
		<input type="hidden" name="referenceSeq" value=""/>
		<input type="hidden" name="organizationSeq" value=""/>
		<input type="hidden" name="itemSeq" value=""/>
		<input type="hidden" name="sortOrder"    value=""/>
	</form>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${activeElement.courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${activeElement.courseApplySeq}"/>"/>
	<input type="hidden" name="courseTypeCd" value="<c:out value="${activeElement.courseTypeCd}"/>"/>
	<input type="hidden" name="learnerId" value="<c:out value="${param['memberSeq']}"/>"/>
	<input type="hidden" name="memberSeq" value="<c:out value="${param['memberSeq']}"/>"/>
	<input type="hidden" name="memberName" value="<c:out value="${param['memberName']}"/>"/>
	
	<spring:message code="필드:출석결과:학습자" /> : <c:out value="${param['memberName']}"/>
	<div class="vspace"></div>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 70px;" />
		<col style="width: auto;" />
		<col style="width: 70px;" />
		<col style="width: auto;" />
		<col style="width: 70px;" />
		<col style="width: 120px;" />
		<col style="width: 70px;" />
		<col style="width: 80px;" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:출석결과:주차" /></th>
			<th><spring:message code="필드:출석결과:주차제목" /></th>
			<th><spring:message code="필드:출석결과:교시강" /></th>
			<th><spring:message code="필드:출석결과:강제목" /></th>
			<th><spring:message code="필드:출석결과:학습횟수" /></th>
			<th><spring:message code="필드:출석결과:학습시간" /></th>
			<th><spring:message code="필드:출석결과:진도율" /></th>
			<th><spring:message code="필드:출석결과:출결" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${itemList}" varStatus="i">
		<tr>
			<td rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
				<c:out value="${row.element.sortOrder}"/> <spring:message code="필드:출석결과:주차" />
			</td>
			<td class="align-l" rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
				<c:out value="${row.element.activeElementTitle}"/>
			</td>
			<c:if test="${fn:length(row.itemResultList) eq 0}">
				<td colspan="6">-</td>
			</c:if>
			<c:forEach var="rowSub" items="${row.itemResultList}" varStatus="j"><!-- 강 리스트 -->
				<c:if test="${j.count ne 1}">
				<tr>
				</c:if>				
					<td><c:out value="${rowSub.item.sortOrder+1}"/></td>
					<td class="align-l">
						<a href="javascript:doDetailWeek({'referenceSeq' : '<c:out value="${row.element.referenceSeq}" />','sortOrder' : '<c:out value="${rowSub.item.sortOrder}"/>','organizationSeq' : '<c:out value="${rowSub.item.organizationSeq}"/>','itemSeq' : '<c:out value="${rowSub.item.itemSeq}"/>'});"><c:out value="${rowSub.item.title}"/></a>
					</td>
					<td><c:out value="${rowSub.learnerDatamodel.attempt}"/></td>
					<td>
						<c:choose>
							<c:when test="${0 < rowSub.learnerDatamodel.sessionTime}">
								<c:set var="hh" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
								<c:set var="mm" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
								<c:set var="ss" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
								<c:choose>
									<c:when test="${10 <= hh}">
										<c:out value="${hh}"/>:
									</c:when>
									<c:otherwise>
										0<c:out value="${hh}"/>:
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${10 <= mm}">
										<c:out value="${mm}"/>:
									</c:when>
									<c:otherwise>
										0<c:out value="${mm}"/>:
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${10 <= ss}">
										<c:out value="${ss}"/>
									</c:when>
									<c:otherwise>
										0<c:out value="${ss}"/>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								00:00:00
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<span class="profressPrint">
							<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>%
						</span>
						<span class="profressText" style="display: none;">
							<input type="text" name="progressMeasures" value="<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>" size="5" class="align-r">%
						</span>
						<input type="hidden" name="oldProgressMeasures" value="<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>">
						<input type="hidden" name="organizationSeqs" 	value="${rowSub.item.organizationSeq}" />
						<input type="hidden" name="itemSeqs" 			value="${rowSub.item.itemSeq}" />
						<input type="hidden" name="activeElementSeqs" 	value="${row.element.activeElementSeq}" />
					</td>
					<td>
						<input type="hidden" name="oldAttendTypeCds" value="${rowSub.attend.attendTypeCd}"/>
						<c:if test="${appToday > row.element.endDtime}"> 
							<span class="profressPrint">
								<c:choose>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<spring:message code="필드:출석결과:출석" />
									</c:when>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<spring:message code="필드:출석결과:결석" />
									</c:when>
									<c:otherwise>
										<spring:message code="필드:출석결과:지각" />
									</c:otherwise>
								</c:choose>
							</span>
							<span class="profressText" style="display: none;">
								<select name="attendTypeCds" class="select">
									<aof:code type="option" codeGroup="${srchKeyBefore}" selected="${rowSub.attend.attendTypeCd}"/>
								</select>
							</span>
						</c:if>
						<c:if test="${appToday <= row.element.endDtime}">
							<span class="profressPrint">
								<c:choose>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<spring:message code="필드:출석결과:출석" />
									</c:when>
									<c:when test="${rowSub.attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<spring:message code="글:과정:수강전"/>
									</c:when>
									<c:otherwise>
										<spring:message code="글:과정:수강중"/>
									</c:otherwise>
								</c:choose>
							</span>
							<span class="profressText" style="display: none;">
								<select name="attendTypeCds" class="select">
									<aof:code type="option" codeGroup="${srchKeyAfter}" selected="${rowSub.attend.attendTypeCd}"/>
								</select>
							</span>
						</c:if>
					</td>
				</tr>
			</c:forEach>
	</c:forEach>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdatelist()" class="btn blue" id="update_af" style="display: none;"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doEditShow()" class="btn blue" id="update_a"><span class="mid"><spring:message code="버튼:수정" /></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doEditHide()" class="btn blue" id="cancle_a" style="display: none;"><span class="mid"><spring:message code="버튼:취소" /></span></a>
		</div>
	</div>
</body>
</html>