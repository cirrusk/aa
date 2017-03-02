<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";
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
 * 정렬순의 값을 변경 했을 때 호출되는 함수
 */
doSearchOrder = function(orderby) {
	var form = UT.getById(forSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (orderby != null && form.elements["orderby"] != null) {  
		form.elements["orderby"].value = orderby;
	}
	forSearch.run();
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doList();
};

/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};
</script>
</head>
<body>

<div class="foreword">
	<p class="location">
		<aof:img src="common/location_home_ocw.gif" />
		<span class="next">›</span> <spring:message code="필드:OCW:OCW"/> 
		<span class="next">›</span> list
	</p>
	<h3><spring:message code="필드:OCW:OCW"/></h3>
</div>

<c:import url="srchOcwCourse.jsp"/>

<div class="con-order">
	<div class="left">
		<select name="perpage" onchange="doSearch(this.value)" class="select">
			<aof:code type="option" codeGroup="PERPAGE" selected="${condition.perPage}" removeCodePrefix="true"/>
		</select>
	</div>
	<div class="right item">
		<span><input type="radio" id="rec-order" name="lecture-order" onclick="doSearchOrder(-1);" <c:if test="${condition.orderby eq -1}">checked="checked"</c:if>/><label for="rec-order"> <spring:message code="필드:OCW:최근등록순"/></label></span>
		<span><input type="radio" id="star-order" name="lecture-order" onclick="doSearchOrder(-2);" <c:if test="${condition.orderby eq -2}">checked="checked"</c:if>/><label for="star-order"> <spring:message code="필드:OCW:별점순"/></label></span>
	</div>
</div>
<div class="lecture-themes next">
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<div class="section<c:if test="${i.count eq 1}"> first</c:if>" onclick="doDetail({'ocwCourseActiveSeq' : '${row.ocwCourse.ocwCourseActiveSeq}','courseActiveSeq' : '${row.courseActive.courseActiveSeq}'});" style="cursor: pointer;">
			<div class="lecture">
				<span class="group blue"><c:out value="${fn:replace(fn:replace(row.cate.categoryString,'OCW::',''),'::','>')}"/></span>
				<h4><c:out value="${row.courseActive.courseActiveTitle}"/></h4>
				<p class="lecturer"><spring:message code="필드:OCW:강사"/> : <c:out value="${row.ocwCourse.profMemberName}"/></p>
				
				<div class="rating">
					<c:import url="/WEB-INF/view/controller/univ/ocw/course/starOcwCourse.jsp">
						<c:param name="ocwAvgResult" value="${row.ocwCourse.scoreAvg}"/>
					</c:import>
				</div>
				<p class="account"><c:out value="${row.courseActive.introduction}"/></p>
				<p class="info">
					<span class="offer"><spring:message code="필드:OCW:제공자"/> : </span><c:out value="${row.ocwCourse.offerName}"/>
					<span><spring:message code="필드:OCW:출저"/> : </span><c:out value="${row.ocwCourse.source}"/>
					<span><spring:message code="필드:OCW:등록자"/> : </span><c:out value="${row.ocwCourse.regMemberName}"/>
				</p>
				<p class="date"><aof:date datetime="${row.courseActive.regDtime}"/></p>
			</div>
			
			<c:choose>
				<c:when test="${!empty row.ocwCourse.photo2}">
					<c:set var="ocwPhoto2" value ="${aoffn:config('upload.context.image')}${row.ocwCourse.photo2}.thumb.jpg"/>
				</c:when>
				<c:otherwise>
					<c:set var="ocwPhoto2"><aof:img type="print" src="common/lecture_thum_temp.gif"/></c:set>
				</c:otherwise>
			</c:choose>
			
			<p class="thum"><img src="<c:out value="${ocwPhoto2}"/>"/></p>
		</div>
	</c:forEach>
	
	<c:if test="${empty paginate.itemList}">
		<div class="section first" style="text-align: center;">
			<spring:message code="글:OCW:강의가없습니다"/> 
		</div>
	</c:if>
</div>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
</body>
</html>
