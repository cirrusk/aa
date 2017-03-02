<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:choose>
	<c:when test="${!empty detailContents.ocwContents.photo}">
		<c:set var="photoContents" value ="${aoffn:config('upload.context.image')}${detailContents.ocwContents.photo}"/>
	</c:when>
	<c:otherwise>
		<c:set var="photoContents"><aof:img type="print" src="common/lecture_view_temp.gif"/></c:set>
	</c:otherwise>
</c:choose>
	
<html xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
	<!-- 메타로 facebook에서 공유할 내용의 기본값을 캐싱하도록 설정해 준다 -->
	<meta property="og:title" content="<c:out value="${detailContents.element.activeElementTitle}"/>" />
	<meta property="og:description" content="<c:out value="${detailContents.ocwContents.introduction}"/>" />
	<meta property="og:image" content="<c:out value="${photoContents}"/>" />
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
	
	jQuery(function($){
		/* tab */
		$.fn.tabContainer = function(){
			return this.each(function(){
				var tabAnchor = $(this).find('> li');
				tabAnchor.each(function(){
					var $menu = $(this);
					var $targetEl = $('#' + $menu.find('>a').attr('href').split('#')[1]);
					$targetEl.css('display', 'none');
					if ($menu.hasClass('on')) {
						$targetEl.css('display', 'block');
					};

					$menu.click(function(){
						if (!$(this).hasClass('on')) {
							tabAnchor.removeClass('on');
							tabAnchor.each(function(){
								$('#' + $(this).find('>a').attr('href').split('#')[1]).css('display', 'none');
							});
						$menu.addClass('on');
						$targetEl.css('display', 'block');
						};
						return false;
					});
				});
			});
		};
		$('.lecture-txt ul').tabContainer(); //main 공지사항
	});
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
	
	forDetailContentsItem = $.action();
	forDetailContentsItem.config.formId          = "FormContentsItem";
	forDetailContentsItem.config.url             = "<c:url value="/univ/ocw/course/contents/item/detail.do"/>";
	
	forOcwLearning = $.action("layer");
	forOcwLearning.config.formId = "FormOcwLearning";
	forOcwLearning.config.url    = "<c:url value="/learning/simple/ocw/popup.do"/>";
	forOcwLearning.config.options.width = 1006;
	forOcwLearning.config.options.height = 860;
	forOcwLearning.config.options.draggable = false;
	forOcwLearning.config.options.titlebarHide = true;
	forOcwLearning.config.options.backgroundOpacity = 0.9;
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
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
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
 * 오픈학습
 */
doOcwLearning = function(mapPKs) {
 	// 학습하기화면 form을 reset한다.
 	UT.getById(forOcwLearning.config.formId).reset();
 	// 학습하기화면 form에 키값을 셋팅한다.
 	UT.copyValueMapToForm(mapPKs, forOcwLearning.config.formId);
 	// 학습하기화면 실행
 	if(forOcwLearning.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
 		forOcwLearning.config.popupWindow.close();
 		forOcwLearning.config.popupWindow = null;
 		setTimeout("forOcwLearning.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
 	} else {
 		forOcwLearning.run();
 	}
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

<form name="FormOcwLearning" id="FormOcwLearning" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
	<input type="hidden" name="itemIdentifier" />
	<input type="hidden" name="courseId" />
	<input type="hidden" name="completionStatus"/>
</form>

<!-- 본문 내용 -->
<div class="lecture-top">
	<h3 class="tit"><c:out value="${detailContents.element.activeElementTitle}"/></h3>
	<p class="lecturer"><spring:message code="필드:OCW:강사"/> : <c:out value="${detailContents.ocwContents.lectureName}"/></p>
	<p class="date"><aof:date datetime="${detailContents.ocwContents.regDtime}"/></p>
</div>
<div class="lecture-play">

	<img src="<c:out value="${photoContents}"/>" width="832px" height="459px"/>
	<a href="javascript:void(0);" class="btn-play" onclick="doOcwLearning({
																			'organizationSeq' : '<c:out value="${detailContents.ocwContents.organizationSeq}"/>',
																			'itemSeq' : '<c:out value="${detailContents.ocwContents.itemSeq}"/>',
																			'itemIdentifier' : '<c:out value="${detailContents.item.identifier}"/>',
																			'height' : '<c:out value="${detailContents.organization.height}"/>',
																			'width' : '<c:out value="${detailContents.organization.width}"/>'
																		});"><aof:img src="btn/btn_lec_play.png"/></a>
</div>
<div class="sub-head">
	<h4 class="sub-tit"><spring:message code="필드:OCW:강의소개"/></h4>
	<div class="sns-area">
		<!-- 트위터 -->
		<a class="socialite twitter-share" href="http://twitter.com/share" data-url="http://socialitejs.com" target="_blank"><span><aof:img src="icon/icon_lec_sns_twitter.png"/></span></a>
		<!-- 페이스북 -->
		<a href="javascript:void(0);" class="facebook" onclick="doFaceBookShare();"><span>facebook</span></a>
	</div>
</div>
<div class="lecture-intro">
	<ul class="info-list">
		<li class="offer"><span class="tit"><spring:message code="필드:OCW:제공자"/> : </span><c:out value="${detailContents.ocwContents.offerName}"/></li>
		<li><span class="tit"><spring:message code="필드:OCW:출저"/> : </span><c:out value="${detailContents.ocwContents.source}"/></li>
		<li><span class="tit"><spring:message code="필드:개설과목:보조자료"/> : </span>
			<c:forEach var="row" items="${detailContents.activeItem.attachList}" varStatus="i">
				<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
				[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
			</c:forEach>
			<c:if test="${empty detailContents.activeItem.attachList}">
				<spring:message code="글:OCW:등록된보조자료가없습니다"/>
			</c:if>
		</li>
		<li class="refer"><span class="tit"><spring:message code="필드:개설과목:참고서적"/> : </span><c:out value="${detailContents.ocwContents.referenceBook}"/></li>
		<li><span class="tit"><spring:message code="필드:개설과목:키워드"/> : </span>
			<c:set var="splitKeyword" value="${fn:split(detailContents.ocwContents.keyword,',')}"/>
			<c:forEach var="row" items="${splitKeyword}" varStatus="i">
				<c:if test="${i.count ne 1}">,</c:if>
				<a href="javascript:void(0)" onclick="doSearchKeyword('<c:out value="${row}"/>');"><c:out value="${row}"/></a>
			</c:forEach>
		</li>
	</ul>
	<p class="desc"><aof:text type="text" value="${detailContents.ocwContents.introduction}"/></p>
</div>
<div class="lecture-txt">
	<ul>
		<li class="on"><a href="#ko"><spring:message code="필드:주차:한글스크립트"/></a></li>
		<li><a href="#origin"><spring:message code="필드:주차:원문스크립트"/></a></li>
	</ul>
	<div class="txt">
		<div id="ko">
			<aof:text type="text" value="${detailContents.ocwContents.krScript}"/>
		</div>
		<div id="origin">
			<aof:text type="text" value="${detailContents.ocwContents.originScript}"/>
		</div>
	</div>
</div>
<h4 class="sub-tit">총 15강</h4>
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
<p class="lecture-key">
	<span><spring:message code="필드:개설과목:키워드"/></span>
	<c:set var="splitKeyword" value="${fn:split(detail.ocwCourse.keyword,',')}"/>
	<c:forEach var="row" items="${splitKeyword}" varStatus="i">
		<c:if test="${i.count ne 1}">,</c:if>
		<a href="javascript:void(0)" onclick="doSearchKeyword('<c:out value="${row}"/>');"><c:out value="${row}"/></a>
	</c:forEach>
</p>

	
	<c:import url="/WEB-INF/view/controller/univ/ocw/course/comment/comment.jsp">
		<c:param name="srchCommentTypeCd" value="ORGANIZATION"/>
		<c:param name="srchCourseActiveSeq" value="${detail.courseActive.courseActiveSeq}"/>
		<c:param name="srchItemSeq" value="${detailContents.ocwContents.itemSeq}"/>
		<c:param name="parentResizingYn" value="Y"/>
	</c:import>

</body>
</html>
