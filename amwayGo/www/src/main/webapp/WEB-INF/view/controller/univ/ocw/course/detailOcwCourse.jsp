<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:choose>
	<c:when test="${!empty detail.ocwCourse.photo1}">
		<c:set var="ocwPhoto1" value ="${aoffn:config('upload.context.image')}${detail.ocwCourse.photo1}.thumb.jpg"/>
	</c:when>
	<c:otherwise>
		<c:set var="ocwPhoto1"><aof:img type="print" src="common/lecture_d_temp.gif"/></c:set>
	</c:otherwise>
</c:choose>

<html xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>

<!-- 메타로 facebook에서 공유할 내용의 기본값을 캐싱하도록 설정해 준다 -->
<meta property="og:title" content="<c:out value="${detail.courseActive.courseActiveTitle}"/>" />
<meta property="og:description" content="<c:out value="${detail.courseActive.introduction}"/>" />
<meta property="og:image" content="<c:out value="${ocwPhoto1}"/>" />
<meta property="og:url" content="<c:out value="${appSystemDomain}"/>" />
<meta property="og:type" content="website" />

<title></title>
<script type="text/javascript">
var forListdata   = null;
var forDetail     = null;
var forDetailContentsItem = null;
var forInsertEvaluate     = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	initPageComment();
	
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";
	
	forInsertEvaluate = $.action("submit");
	forInsertEvaluate.config.formId          = "FormInsertEvaluate"; 
	forInsertEvaluate.config.url             = "<c:url value="/univ/ocw/course/evaluate/insert.do"/>";
	forInsertEvaluate.config.target          = "hiddenframe";
	forInsertEvaluate.config.message.confirm = "<spring:message code="글:OCW:별점을등록하시겠습니까"/>"; 
	forInsertEvaluate.config.message.success = "<spring:message code="글:등록되었습니다"/>";
	forInsertEvaluate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertEvaluate.config.fn.complete     = function() {
		forDetail.run();
	};
	
	forDetailContentsItem = $.action();
	forDetailContentsItem.config.formId          = "FormContentsItem";
	forDetailContentsItem.config.url             = "<c:url value="/univ/ocw/course/contents/item/detail.do"/>";
};

/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};

/**
 * 키워드 검색이동
 */
doSearchKeyword = function(keyword) {
	var form = UT.getById(forListdata.config.formId);
	form.elements["srchKey"].value = "keyword";
	form.elements["srchWord"].value = keyword;
	forListdata.run();
};

/**
 * 별점주기 포커스 오버 액션
 */
doStarMouseOver = function(star){
	
	var star_full = "<aof:img type="print" src="icon/rating_star_full.png"/>";
	var star_empty = "<aof:img type="print" src="icon/rating_star_empty.png"/>";
	var count = 1;
	jQuery("#star").find("img").each(
			function() {
				if(star >= count){
					this.src = star_full;
				}else{
					this.src = star_empty;
				}
				count++;
			});
};

/**
 * 별점주기 박스 쇼
 */
doStarShow = function(){
	var $star = jQuery("#star");
	if($star.css("display") == 'none'){
		$star.css("display","block");
	}else{
		$star.css("display","none");
	}
};

/**
 * 평점 주기
 */
doInsertEvaluate = function(evalScore){
	var form = UT.getById(forInsertEvaluate.config.formId);
	form.elements["evalScore"].value = evalScore;
	forInsertEvaluate.run();
};

/**
 * 로그인 유도 alert
 */
doLoginAlert = function(){
	$.alert({
		message : "<spring:message code="글:로그인:로그인이필요합니다"/>"
	});
};

/**
 * 강의 상세보기 화면을 호출하는 함수
 */
doDetailContentsItem = function(mapPKs) {
	UT.getById(forDetailContentsItem.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetailContentsItem.config.formId);
	forDetailContentsItem.run();
};

/**
 * 페이스북 공유하기
 */
doFaceBookShare = function(){
	var url = encodeURIComponent('<c:out value="${appSystemDomain}"/>/<c:url value="${servletPath}"/>?<c:out value="${queryString}"/>');
	
	window.open(
			 "https://www.facebook.com/sharer/sharer.php?u=" + url + "&t=dis&display=popup"
			 , "_blank"	 
			 , "toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no"
			);
};

</script>
</head>
<body>

<div class="foreword">
	<p class="location">
		<aof:img src="common/location_home_ocw.gif" />
		<span class="next">›</span> <spring:message code="필드:OCW:OCW"/> 
		<span class="next">›</span> list
		<span class="next">›</span> detail
	</p>
	<h3><spring:message code="필드:OCW:OCW"/></h3>
</div>

<div style="display:none;">
	<c:import url="srchOcwCourse.jsp"/>
</div>

<form name="FormInsertEvaluate" id="FormInsertEvaluate" method="post" onsubmit="return false;">
	<input type="hidden" name="ocwCourseActiveSeq"  value="<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}"/>" />
	<input type="hidden" name="evalScore"  value="" />
</form>

<!-- 본문 내용 -->
<div class="lecture-top">
	<h3 class="tit"><c:out value="${detail.courseActive.courseActiveTitle}"/></h3>
	<p class="lecturer"><spring:message code="필드:OCW:강사"/> : <c:out value="${detail.ocwCourse.profMemberName}"/></p>
	<div class="rating">
		<c:import url="/WEB-INF/view/controller/univ/ocw/course/starOcwCourse.jsp">
			<c:param name="ocwAvgResult" value="${detail.ocwCourse.scoreAvg}"/>
		</c:import>
	</div>
	<p class="date"><aof:date datetime="${detail.courseActive.regDtime}"/></p>
</div>
<div class="lecture-detail">
	<div class="info">	
		<p class="thum"><img src="<c:out value="${ocwPhoto1}"/>"/></p>
		<ul class="info-list">
			<li class="offer"><span class="tit"><spring:message code="필드:OCW:제공자"/> : </span></span><c:out value="${detail.ocwCourse.offerName}"/></li>
			<li><span class="tit"><spring:message code="필드:OCW:출저"/> : </span><c:out value="${detail.ocwCourse.source}"/></li>
			<li><span class="tit"><spring:message code="필드:개설과목:보조자료"/> : </span>
				<c:forEach var="row" items="${detail.ocwCourse.attachFileList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
					[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
				<c:if test="${empty detail.ocwCourse.attachFileList}">
					<spring:message code="글:OCW:등록된보조자료가없습니다"/>
				</c:if>
			</li>
			<li class="refer"><span class="tit"><spring:message code="필드:개설과목:참고서적"/> : </span><c:out value="${detail.ocwCourse.referenceBook}"/></li>
			<li><span class="tit"><spring:message code="필드:개설과목:키워드"/> : </span>
				<c:set var="splitKeyword" value="${fn:split(detail.ocwCourse.keyword,',')}"/>
				<c:forEach var="row" items="${splitKeyword}" varStatus="i">
					<c:if test="${i.count ne 1}">,</c:if>
					<a href="javascript:void(0)" onclick="doSearchKeyword('<c:out value="${row}"/>');"><c:out value="${row}"/></a>
				</c:forEach>
			</li>
		</ul>
		<div class="sns-area">
			<!-- 트위터 -->
			<a class="socialite twitter-share" href="http://twitter.com/share" data-url="http://socialitejs.com"><span><aof:img src="icon/icon_lec_sns_twitter.png"/></span></a>
			<!-- 페이스북 -->
			<a href="javascript:void(0);" class="facebook" onclick="doFaceBookShare();"><span>facebook</span></a>
			<c:if test="${not empty ssMemberName}">
				<c:if test="${empty myEvaluate}">
					<a href="javascript:void(0);" class="rating" onclick="doStarShow();"><spring:message code="필드:OCW:별점주기"/></a>
					<div class="rating-star" id="star" style="display: none;">
						<a href="javascript:void(0);" onclick="doInsertEvaluate(1);"><aof:img src="icon/rating_star_empty.png" onmouseover="doStarMouseOver('1');"/></a>
						<a href="javascript:void(0);" onclick="doInsertEvaluate(2);"><aof:img src="icon/rating_star_empty.png" onmouseover="doStarMouseOver('2');"/></a>
						<a href="javascript:void(0);" onclick="doInsertEvaluate(3);"><aof:img src="icon/rating_star_empty.png" onmouseover="doStarMouseOver('3');"/></a>
						<a href="javascript:void(0);" onclick="doInsertEvaluate(4);"><aof:img src="icon/rating_star_empty.png" onmouseover="doStarMouseOver('4');"/></a>
						<a href="javascript:void(0);" onclick="doInsertEvaluate(5);"><aof:img src="icon/rating_star_empty.png" onmouseover="doStarMouseOver('5');"/></a>
						<%-- <a href="#"><aof:img src="icon/rating_star_full.png"/></a> --%>
						<span class="arrow"></span>
					</div>
				</c:if>
				<c:if test="${not empty myEvaluate}">
					<a href="javascript:void(0);" class="rating"><spring:message code="필드:OCW:별점"/></a>
					<div class="rating-star" id="star" style="left: 90px;">
						<c:import url="/WEB-INF/view/controller/univ/ocw/course/starOcwCourse.jsp">
							<c:param name="ocwAvgResult" value="${myEvaluate.ocwEvaluate.evalScore}"/>
							<c:param name="type" value="small"/>
						</c:import>
					</div>
				</c:if>
			</c:if>
			<c:if test="${empty ssMemberName}">
				<a href="javascript:void(0);" class="rating" onclick="doLoginAlert();"><spring:message code="필드:OCW:별점주기"/></a>
			</c:if>
		</div>
	</div>
	<div class="account">
		<p><aof:text type="text" value="${detail.courseActive.introduction}"/></p>
	</div>
</div>
<h4 class="sub-tit"><spring:message code="필드:OCW:강의목록"/></h4>
<div class="lecture-themes">
	<c:forEach var="row" items="${list}" varStatus="i">
		<div class="section<c:if test="${i.count eq 1}"> first</c:if>" style="height: 90px; cursor: pointer;" onclick="doDetailContentsItem({'ocwCourseActiveSeq' : '${detail.ocwCourse.ocwCourseActiveSeq}'
																												,'courseActiveSeq' : '${row.ocwContents.courseActiveSeq}'
																												,'activeElementSeq' : '${row.ocwContents.activeElementSeq}'
																												,'organizationSeq' : '${row.ocwContents.organizationSeq}'
																												,'itemSeq' : '${row.ocwContents.itemSeq}'});">
			<div class="lecture">
				<h4><c:out value="${row.element.activeElementTitle}"/></h4>
				<p class="lecturer"><spring:message code="필드:OCW:강사"/> : <c:out value="${row.ocwContents.lectureName}"/></p>
				<p class="account"><c:out value="${row.ocwContents.introduction}"/></p>
				<p class="info">
					<span class="offer"><spring:message code="필드:OCW:제공자"/> : </span><c:out value="${row.ocwContents.offerName}"/>
					<span><spring:message code="필드:OCW:출저"/> : </span><c:out value="${row.ocwContents.source}"/>
					<span><spring:message code="필드:OCW:등록자"/> : </span><c:out value="${row.ocwContents.regMemberName}"/>
				</p>
				<p class="date"><aof:date datetime="${row.ocwContents.regDtime}"/></p>
			</div>
			<c:choose>
				<c:when test="${!empty row.ocwContents.photo}">
					<c:set var="photo" value ="${aoffn:config('upload.context.image')}${row.ocwContents.photo}.thumb.jpg"/>
				</c:when>
				<c:otherwise>
					<c:set var="photo"><aof:img type="print" src="common/lecture_thum_temp.gif"/></c:set>
				</c:otherwise>
			</c:choose>
			
			<p class="thum"><img src="<c:out value="${photo}"/>" width="180px" height="94px"/></p>
		</div>
	</c:forEach>
</div>
<!-- //본문 내용 -->

<c:import url="/WEB-INF/view/controller/univ/ocw/course/comment/comment.jsp">
	<c:param name="srchCommentTypeCd" value="COURSE"/>
	<c:param name="srchCourseActiveSeq" value="${detail.courseActive.courseActiveSeq}"/>
	<c:param name="parentResizingYn" value="Y"/>
</c:import>

</body>
</html>
