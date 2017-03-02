<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. datepicker
	UI.datepicker("#startDate");
	UI.datepicker("#endDate");
	
	doClickStatisticsType();
	
	if (typeof doCreateChart === "function") {
		doCreateChart();
	}
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action("normal", {formId : "FormSrch"});
	forSearch.config.url    = "<c:url value="/login/history/statistics/list.do"/>";
	forSearch.config.fn.before = function() {
		var $form = jQuery("#" + forSearch.config.formId);
		if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
			var startDate = jQuery(":input[name='startYear']").val() + "-" + jQuery(":input[name='startMonth']").val() + "-01";
			var endDate = UT.getLastDateOfMonth(jQuery(":input[name='endYear']").val(), jQuery(":input[name='endMonth']").val(), "<c:out value="${aoffn:config('format.date')}"/>");
			
			jQuery(":input[name='srchStartRegDate']").val(startDate);
			jQuery(":input[name='srchEndRegDate']").val(endDate);
		} else {
			jQuery(":input[name='srchStartRegDate']").val(jQuery(":input[name='startDate']").val());
			jQuery(":input[name='srchEndRegDate']").val(jQuery(":input[name='endDate']").val());
		}
		return true;
	};
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:분석방법"/>",
		name : "srchStatisticsType",
		data : ["!null"]
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작일"/>",
		name : "startDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${aoffn:config('format.date')}"/>"
		},
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return false;
			} else {
				return true;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:종료일"/>",
		name : "endDate",
		data : ["!null"],
		check : {
			date : "<c:out value="${aoffn:config('format.date')}"/>"
		},
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return false;
			} else {
				return true;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작일"/>",
		name : "startDate",
		check : {
			le : {name : "endDate", title : "<spring:message code="필드:로그인:종료일"/>"}
		},
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return false;
			} else {
				return true;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작년도"/>",
		name : "startYear",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return true;
			} else {
				return false;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작월"/>",
		name : "startMonth",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return true;
			} else {
				return false;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:종료년도"/>",
		name : "endYear",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return true;
			} else {
				return false;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:종료월"/>",
		name : "endMonth",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return true;
			} else {
				return false;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작년도"/>",
		name : "startYear",
		check : {
			le : {name : "endYear", title : "<spring:message code="필드:로그인:종료년도"/>"}
		},
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				return true;
			} else {
				return false;
			}
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:로그인:시작월"/>",
		name : "startMonth",
		check : {
			le : {name : "endMonth", title : "<spring:message code="필드:로그인:종료월"/>"}
		},
		when : function() {
			var $form = jQuery("#" + forSearch.config.formId);
			if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
				if (jQuery(":input[name='startYear']").val() == jQuery(":input[name='endYear']").val()) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	});
};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	var form = UT.getById(forSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearch.run();
};
/**
 * 검색조건 초기화
 */
doSearchReset = function() {
	FN.resetSearchForm(forSearch.config.formId);
	
	var $form = jQuery("#" + forSearch.config.formId);
	$form.find(":input[name='srchStatisticsType']").eq(0).trigger("click");
};
/**
 * 분석방법 변경
 */
doClickStatisticsType = function() {
	var $form = jQuery("#" + forSearch.config.formId);
	if (jQuery(":input[name='srchStatisticsType']").filter(":checked").val() == "month") {
		jQuery("#srchDay").hide();
		jQuery("#srchMonth").show();
	} else {
		jQuery("#srchDay").show();
		jQuery("#srchMonth").hide();
	}
	jQuery(":input[name='srchStartRegDate']").val("");
	jQuery(":input[name='srchEndRegDate']").val("");
};
</script>
<c:import url="/WEB-INF/view/include/chart.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>
	
	<c:set var="appToday" value="${aoffn:today()}"/>
	<c:set var="srchStatisticsType">day=<spring:message code="필드:로그인:일별"/>,month=<spring:message code="필드:로그인:월별"/>,hour=<spring:message code="필드:로그인:시간별"/></c:set>
	<c:set var="srchYear"><aof:date datetime="${appToday}" pattern="yyyy"/></c:set>
	<c:set var="iStartYear" value="${aoffn:toInt(srchYear)}"/>
	<c:set var="yearList" value=""/>
	<c:forEach var="row" begin="${iStartYear}" end="${iStartYear + 10}" step="1" varStatus="i">
		<c:if test="${i.first ne true}"><c:set var="yearList" value="${yearList},"/></c:if>
		<c:set var="yearList" value="${yearList}${2 * iStartYear - row}=${2 * iStartYear - row}"/>
	</c:forEach>
	<c:set var="monthList" value=""/>
	<c:forEach var="row" begin="1" end="12" step="1" varStatus="i">
		<c:if test="${i.first ne true}"><c:set var="monthList" value="${monthList},"/></c:if>
		<c:choose>
			<c:when test="${row lt 10}">
				<c:set var="monthList" value="${monthList}0${row}=${row}"/>
			</c:when>
			<c:otherwise>
				<c:set var="monthList" value="${monthList}${row}=${row}"/>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:set var="srchStartRegDateDefault"><aof:date datetime="${appToday}" addDate="-30" /></c:set>
	<c:set var="srchEndRegDateDefault"><aof:date datetime="${appToday}"/></c:set>

	<c:set var="startYearDefault"><aof:date datetime="${appToday}" pattern="yyyy" addDate="-30"/></c:set>
	<c:set var="startMonthDefault"><aof:date datetime="${appToday}" pattern="MM" addDate="-30" /></c:set>
	<c:set var="endYearDefault"><aof:date datetime="${appToday}" pattern="yyyy"/></c:set>
	<c:set var="endMonthDefault"><aof:date datetime="${appToday}" pattern="MM"/></c:set>

	<c:choose>
		<c:when test="${condition.srchYn eq 'Y'}">
			<c:set var="srchStartRegDate"><aof:date datetime="${condition.srchStartRegDate}"/></c:set>
			<c:set var="srchEndRegDate"><aof:date datetime="${condition.srchEndRegDate}"/></c:set>

			<c:set var="startYear"><aof:date datetime="${condition.srchStartRegDate}" pattern="yyyy"/></c:set>
			<c:set var="startMonth"><aof:date datetime="${condition.srchStartRegDate}" pattern="MM"/></c:set>
			<c:set var="endYear"><aof:date datetime="${condition.srchEndRegDate}" pattern="yyyy"/></c:set>
			<c:set var="endMonth"><aof:date datetime="${condition.srchEndRegDate}" pattern="MM"/></c:set>
		</c:when>
		<c:otherwise>
			<c:set var="srchStartRegDate" value="${srchStartRegDateDefault}"/>
			<c:set var="srchEndRegDate" value="${srchEndRegDateDefault}"/>

			<c:set var="startYear" value="${startYearDefault}"/>
			<c:set var="startMonth" value="${startMonthDefault}"/>
			<c:set var="endYear" value="${endYearDefault}"/>
			<c:set var="endMonth" value="${endMonthDefault}"/>
		</c:otherwise>
	</c:choose>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="srchYn" value="Y" default="Y"/>
				<strong><spring:message code="필드:로그인:분석방법"/></strong>
				<aof:code type="radio" name="srchStatisticsType" codeGroup="${srchStatisticsType}" selected="${condition.srchStatisticsType}" defaultSelected="day" onclick="doClickStatisticsType()"/><br>
				<input type="hidden" name="srchStartRegDate">
				<input type="hidden" name="srchEndRegDate">
				
				<strong><spring:message code="필드:로그인:기간"/></strong>
				<span id="srchDay" style="display:none;">
					<input type="text" name="startDate" value="${srchStartRegDate}" id="startDate" style="width:80px;text-align:center;" readonly="readonly" default="${srchStartRegDateDefault}"/>
					~
					<input type="text" name="endDate" value="${srchEndRegDate}" id="endDate" style="width:80px;text-align:center;" readonly="readonly" default="${srchEndRegDateDefault}"/>
				</span>
				<span id="srchMonth" style="display:none;">
					<select name="startYear" default="${startYearDefault}">
						<aof:code type="option" codeGroup="${yearList}" selected="${startYear}"/>
					</select>
					<spring:message code="글:년"/>
					&nbsp;
					<select name="startMonth" default="${startMonthDefault}">
						<aof:code type="option" codeGroup="${monthList}" selected="${startMonth}"/>
					</select>
					<spring:message code="글:월"/>
					~
					<select name="endYear" default="${endYearDefault}">
						<aof:code type="option" codeGroup="${yearList}" selected="${endYear}"/>
					</select>
					<spring:message code="글:년"/>
					&nbsp;
					<select name="endMonth" default="${endMonthDefault}">
						<aof:code type="option" codeGroup="${monthList}" selected="${endMonth}"/>
					</select>
					<spring:message code="글:월"/>
				</span>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
			</fieldset>
		</div>
	</form>

	<c:choose>
		<c:when test="${condition.srchYn eq 'Y'}">
			<c:set var="maxCount" value="100"/>
			<table id="statistics" class="tbl-detail">
			<tr>
				<td></td>
				<td><spring:message code="글:시스템:접속자수"/></td>
				<td><spring:message code="글:시스템:신규등록수"/></td>
			</tr>
			<c:choose>
				<c:when test="${condition.srchStatisticsType eq 'month'}">
					<spring:message code="글:월" var="domainName"/>
					<c:set var="barWidth" value="10"/>

					<c:forEach var="row" begin="1" end="12" step="1" varStatus="i">
						<c:set var="loginStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listLogin}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.loginHistory.statisticsDate) eq row}">
								<c:set var="loginStatisticsCount" value="${rowSub.loginHistory.statisticsCount}"/>
							</c:if>
						</c:forEach>
						<c:set var="memberStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listMember}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.member.statisticsDate) eq row}">
								<c:set var="memberStatisticsCount" value="${rowSub.member.statisticsCount}"/>
							</c:if>
						</c:forEach>

						<c:if test="${loginStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${loginStatisticsCount}"/>
						</c:if>
						<c:if test="${memberStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${memberStatisticsCount}"/>
						</c:if>
						<tr>
							<td><c:out value="${row}"/></td>
							<td><c:out value="${loginStatisticsCount}"/></td>
							<td><c:out value="${memberStatisticsCount}"/></td>
						</tr>
					</c:forEach>

				</c:when>
				<c:when test="${condition.srchStatisticsType eq 'hour'}">
					<spring:message code="글:시간" var="domainName"/>
					<c:set var="barWidth" value="8"/>

					<c:forEach var="row" begin="0" end="23" step="1" varStatus="i">
						<c:set var="loginStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listLogin}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.loginHistory.statisticsDate) eq row}">
								<c:set var="loginStatisticsCount" value="${rowSub.loginHistory.statisticsCount}"/>
							</c:if>
						</c:forEach>
						<c:set var="memberStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listMember}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.member.statisticsDate) eq row}">
								<c:set var="memberStatisticsCount" value="${rowSub.member.statisticsCount}"/>
							</c:if>
						</c:forEach>

						<c:if test="${loginStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${loginStatisticsCount}"/>
						</c:if>
						<c:if test="${memberStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${memberStatisticsCount}"/>
						</c:if>
						<tr>
							<td><c:out value="${row}"/></td>
							<td><c:out value="${loginStatisticsCount}"/></td>
							<td><c:out value="${memberStatisticsCount}"/></td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<spring:message code="글:일" var="domainName"/>
					<c:set var="barWidth" value="5"/>

					<c:forEach var="row" begin="1" end="31" step="1" varStatus="i">
						<c:set var="loginStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listLogin}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.loginHistory.statisticsDate) eq row}">
								<c:set var="loginStatisticsCount" value="${rowSub.loginHistory.statisticsCount}"/>
							</c:if>
						</c:forEach>
						<c:set var="memberStatisticsCount" value="0"/>
						<c:forEach var="rowSub" items="${listMember}" varStatus="iSub">
							<c:if test="${aoffn:toInt(rowSub.member.statisticsDate) eq row}">
								<c:set var="memberStatisticsCount" value="${rowSub.member.statisticsCount}"/>
							</c:if>
						</c:forEach>

						<c:if test="${loginStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${loginStatisticsCount}"/>
						</c:if>
						<c:if test="${memberStatisticsCount gt maxCount}">
							<c:set var="maxCount" value="${memberStatisticsCount}"/>
						</c:if>
						<tr>
							<td><c:out value="${row}"/></td>
							<td><c:out value="${loginStatisticsCount}"/></td>
							<td><c:out value="${memberStatisticsCount}"/></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
			</table>
			
			<div class="clear mt10"><br></div>
			<table class="tbl-detail">
			<tbody>
				<tr>
					<th class="align-c"></th>
					<th class="align-c"><spring:message code="글:시스템:접속자수"/></th>
					<th class="align-c"><spring:message code="글:시스템:신규등록수"/></th>
					<th class="align-c"></th>
					<th class="align-c"><spring:message code="글:시스템:접속자수"/></th>
					<th class="align-c"><spring:message code="글:시스템:신규등록수"/></th>
				</tr>
				<tr>
					<th class="align-c"><spring:message code="필드:전체"/></th>
					<td class="align-c"><aof:number value="${detailLogin.loginHistory.totalCount}"/></td>
					<td class="align-c"><aof:number value="${detailMember.member.totalCount}"/></td>
					<th class="align-c"><spring:message code="필드:로그인:오늘"/></th>
					<td class="align-c"><aof:number value="${detailLogin.loginHistory.todayCount}"/></td>
					<td class="align-c"><aof:number value="${detailMember.member.todayCount}"/></td>
				</tr>
				<tr>
					<th class="align-c"><spring:message code="필드:로그인:이번달"/></th>
					<td class="align-c"><aof:number value="${detailLogin.loginHistory.thisMonthCount}"/></td>
					<td class="align-c"><aof:number value="${detailMember.member.thisMonthCount}"/></td>
					<th class="align-c"><spring:message code="필드:로그인:어제"/></th>
					<td class="align-c"><aof:number value="${detailLogin.loginHistory.yesterdayCount}"/></td>
					<td class="align-c"><aof:number value="${detailMember.member.yesterdayCount}"/></td>
				</tr>
			</tbody>
			</table>			
			
			<c:set var="remain" value="${maxCount % 100}"/>
			<c:if test="${remain gt 0}">
				<c:set var="maxCount" value="${(aoffn:toInt(maxCount / 100) + 1) * 100}"/>
			</c:if>
			<script type="text/javascript">
			doCreateChart = function() {
				var options = {
					chartCss : {
						width : "100%",
						height : "300px"
					},
					legend : { // 범례
						style : "text-align:right;"
					},
					plot : { // 차트영역
						margin : {left : 50, right : 20, top : 20, bottom : 40}
					},
					domain : { // 기준축
						label : {
							name : "<c:out value="${domainName}"/>",
							position : "right"
						}
					},
					range : { // 값 축
						label : {
							name : "<spring:message code="글:시스템:인원수"/>",
							position : "top"
						},
						grid : {
							visibleStep : parseInt((parseInt("<c:out value="${maxCount}"/>", 10) / 10), 10)
						},
						tick : {
							visibleStep : parseInt((parseInt("<c:out value="${maxCount}"/>", 10) / 10), 10)
						},
						bound : {
							upper : parseFloat("<c:out value="${maxCount}"/>")
						}
					},
					data : { // 데이타
						barWidth : parseInt("<c:out value="${barWidth}"/>", 10),
						colors : ["#ff0000", "#0000ff"]
					}
				}
				jQuery.barchart("statistics", options);
			};
			</script>			
			
		</c:when>
		<c:otherwise>
			<div class="vspace"></div>
			<div class="lybox align-c">
				<spring:message code="글:검색조건을확인하신후검색버튼을클릭하십시오"/>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>