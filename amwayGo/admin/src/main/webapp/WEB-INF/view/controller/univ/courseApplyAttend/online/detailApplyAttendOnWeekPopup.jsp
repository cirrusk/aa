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

<c:set var="sortOrder" value="${empty param['sortOrder'] ? 0:param['sortOrder']}"></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">
var forList             = null;
var forSortOrderDetail  = null;
var forUpdatelist       = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.tabs("#tabs");
	
	var cnt = 0;
	jQuery(".ui-state-default", jQuery("#tabs")).each(
			function() {
				if(cnt != <c:out value="${sortOrder}"/>){
					jQuery(this).attr("class","ui-state-default ui-corner-top");
				}else{
					jQuery(this).attr("class","ui-state-default ui-corner-top ui-tabs-selected ui-state-active");
				}
			cnt++;
	});
};
	
doInitializeLocal = function() {
	
	forList = $.action();
	forList.config.formId         = "FormData";
	forList.config.url            = "<c:url value="/univ/course/online/attend/result/week/detail/popup.do"/>";

	forSortOrderDetail = $.action();
	forSortOrderDetail.config.formId         = "FormData";
	forSortOrderDetail.config.url            = "<c:url value="/univ/course/online/attend/result/week/detail/popup.do"/>";
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/online/attend/result/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	
	setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdatelist.validator.set({
	    title : "<spring:message code="필드:출석결과:진도율"/>",
	    name : "progressMeasure",
	    data : ["!null", "decimalnumber"],
	    check : {
	    	le : 100
	    }
	});
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
  * 강 이동
  */
 doSortOrderDetail = function(sortOrder, itemSeq){
	 jQuery("#sortOrder").val(sortOrder);
	 jQuery("#itemSeq").val(itemSeq);
	 forSortOrderDetail.run();
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
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${activeElement.courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${activeElement.courseApplySeq}"/>"/>
	<input type="hidden" name="referenceSeq" value="<c:out value="${activeElement.referenceSeq}"/>"/>
	<input type="hidden" name="courseTypeCd" value="<c:out value="${activeElement.courseTypeCd}"/>"/>
	<input type="hidden" name="learnerId" value="<c:out value="${param['memberSeq']}"/>"/>
	<input type="hidden" name="memberSeq" value="<c:out value="${param['memberSeq']}"/>"/>
	<input type="hidden" name="memberName" value="<c:out value="${param['memberName']}"/>"/>
	<input type="hidden" id="sortOrder" name="sortOrder" value="<c:out value="${param['sortOrder']}"/>"/>
	<input type="hidden" id="organizationSeq" name="organizationSeq" value="<c:out value="${param['organizationSeq']}"/>"/>
	<input type="hidden" id="itemSeq" name="itemSeq" value="<c:out value="${param['itemSeq']}"/>"/>
	
	<spring:message code="필드:출석결과:학습자" /> : <c:out value="${param['memberName']}"/>
	<div class="vspace"></div>
		
		<div id="tabs"> 
			<ul class="ui-widget-header-tab-custom">
				<c:forEach var="row" items="${itemList[0].itemResultList}" varStatus="i">
					<li><a href="javascript:void(0)" 
						onclick="doSortOrderDetail('<c:out value="${row.item.sortOrder}"/>','<c:out value="${row.item.itemSeq}"/>');"><c:out value="${row.item.sortOrder+1}"/><spring:message code="필드:출석결과:교시강"/></a>
					</li>
				</c:forEach>
				<div id="container" style="padding:0px;"></div>
			</ul>
		</div>
		
		<div class="vspace"></div>
		<!-- 상세 -->
		<table class="tbl-detail">
		    <colgroup>
		        <col/>
		        <col/>
		        <col/>
		    </colgroup>
		    <tbody>
		        <tr>
		            <th class="align-c"><spring:message code="필드:출석결과:교시강"/></th>
		            <th class="align-c"><spring:message code="필드:출석결과:교시강제목"/></th>
		            <th class="align-c"><spring:message code="필드:출석결과:결과"/> </th>
		        </tr>
		        <tr>
		            <td class="align-c"><c:out value="${itemList[0].itemResultList[sortOrder].item.sortOrder+1}"/><spring:message code="글:출석결과:강"/></td>
		            <td class="align-c"><c:out value="${itemList[0].itemResultList[sortOrder].item.title}"/></td>
		            <td class="align-c">
						<input type="hidden" name="oldAttendTypeCds" value="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd}"/>
						<c:if test="${appToday > itemList[0].element.endDtime}"> 
							<span class="profressPrint">
								<c:choose>
									<c:when test="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<spring:message code="필드:출석결과:출석" />
									</c:when>
									<c:when test="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<spring:message code="필드:출석결과:결석" />
									</c:when>
									<c:otherwise>
										<spring:message code="필드:출석결과:지각" />
									</c:otherwise>
								</c:choose>
							</span>
							<span class="profressText" style="display: none;">
								<select name="attendTypeCds" class="select">
									<aof:code type="option" codeGroup="${srchKeyBefore}" selected="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd}"/>
								</select>
							</span>
						</c:if>
						<c:if test="${appToday <= itemList[0].element.endDtime}">
							<span class="profressPrint">
								<c:choose>
									<c:when test="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd eq CD_ATTEND_TYPE_001}">
										<spring:message code="필드:출석결과:출석" />
									</c:when>
									<c:when test="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd eq CD_ATTEND_TYPE_002}">
										<spring:message code="글:과정:수강전"/>
									</c:when>
									<c:otherwise>
										<spring:message code="글:과정:수강중"/>
									</c:otherwise>
								</c:choose>
							</span>
							<span class="profressText" style="display: none;">
								<select name="attendTypeCds" class="select">
									<aof:code type="option" codeGroup="${srchKeyAfter}" selected="${itemList[0].itemResultList[sortOrder].attend.attendTypeCd}"/>
								</select>
							</span>
						</c:if>
		            </td>
		        </tr>
		        <tr>
		            <th class="align-c"><spring:message code="필드:출석결과:총학습횟수"/></th>
		            <th class="align-c"><spring:message code="필드:출석결과:총학습시간"/></th>
		            <th class="align-c"><spring:message code="필드:출석결과:진도율"/> </th>
		        </tr>
		        <tr>
		            <td class="align-c"><c:out value="${itemList[0].itemResultList[sortOrder].learnerDatamodel.attempt}"/> <spring:message code="필드:출석결과:회"/></td>
		            <td class="align-c">
		            	<c:choose>
							<c:when test="${0 < itemList[0].itemResultList[sortOrder].learnerDatamodel.sessionTime}">
								<c:set var="hh" value="${aoffn:toInt(itemList[0].itemResultList[sortOrder].learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
								<c:set var="mm" value="${aoffn:toInt(itemList[0].itemResultList[sortOrder].learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
								<c:set var="ss" value="${aoffn:toInt(itemList[0].itemResultList[sortOrder].learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
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
		            <td class="align-c">
						<span class="profressPrint">
							<aof:number value="${itemList[0].itemResultList[sortOrder].learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>%
						</span>
						<span class="profressText" style="display: none;">
							<input type="text" name="progressMeasures" value="<aof:number value="${itemList[0].itemResultList[sortOrder].learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>" size="5" class="align-r">%
						</span>
						<input type="hidden" name="oldProgressMeasures" value="<aof:number value="${itemList[0].itemResultList[sortOrder].learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>">
						<input type="hidden" name="organizationSeqs" 	value="${itemList[0].itemResultList[sortOrder].item.organizationSeq}" />
						<input type="hidden" name="itemSeqs" 			value="${itemList[0].itemResultList[sortOrder].item.itemSeq}" />
						<input type="hidden" name="activeElementSeqs" 	value="${itemList[0].element.activeElementSeq}" />
		            </td>
		        </tr>
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
	
	<c:if test="${!empty dailyProgressList}">
		<div class="vspace"></div>
		<div class="lybox-title">
			<h4 class="section-title"><spring:message code="글:콘텐츠:일일진도율"/></h4>
		</div>
		
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 50px" />
			<col style="width: auto" />
			<col style="width: auto" />
			<col style="width: auto" />
			<col style="width: auto" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:콘텐츠:학습일" /></th>
				<th><spring:message code="필드:콘텐츠:진도율" /></th>
				<th><spring:message code="필드:콘텐츠:학습횟수" /></th>
				<th><spring:message code="필드:콘텐츠:학습시간" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${dailyProgressList}" varStatus="i">
			<tr>
				<td><c:out value="${i.count}"/></td>
				<td><aof:date datetime="${row.dailyProgress.studyDate}"/></td>
				<td><c:out value="${row.dailyProgress.progressMeasure * 100}"/> %</td>
				<td><c:out value="${row.dailyProgress.attempt}"/> <spring:message code="글:콘텐츠:회"/></td>
				<td><c:out value="${aoffn:toInt(row.dailyProgress.sessionTime / 60 / 1000) + 1}"/> <spring:message code="글:콘텐츠:분"/></td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
	</c:if>
</body>
</html>