<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>최근 본 콘텐츠 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>
<script type="text/javascript">
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	$("#searchButton").on("click", function(){
		$("#myContentForm > input[name='totalCount']").val("");
		$("#myContentForm > input[name='page']").val("");
		$("#myContentForm > input[name='firstIndex']").val("");
		
		doSearch();
	});
	
	$("#searchcoursetype").on("change", function(){
		$("#myContentForm > input[name='totalCount']").val("");
		$("#myContentForm > input[name='page']").val("");
		$("#myContentForm > input[name='firstIndex']").val("");
		
		doSearch();
	});
	
	$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
	goPageMoreBtn();
});

// 더보기, top 버튼 컨트롤
function goPageMoreBtn() {
	var totalPageVal = $("#myContentForm > input[name='totalPage']").val();
	var pageVal = $("#myContentForm > input[name='page']").val();
	
	if(totalPageVal == 0 || totalPageVal == pageVal) {
		$("#moreBtn").hide();
		$("#topBtn").show();
	}
}

var goViewLink = function(sCode, sMsg, courseidVal, actionUrl) {
	$("#myContentForm > input[name='courseid']").val(courseidVal);
	
	$("#myContentForm").attr("action", actionUrl);
	$("#myContentForm").submit();
}
var doPage = function(page) {
	$("#myContentForm > input[name='page']").val(page);
	doSearch();
}
var doSearch = function() {
	$("#myContentForm").attr("action", "/mobile/lms/myAcademy/lmsMyContent.do");
	$("#myContentForm").submit();
}
function nextPage(){
	var page = $("#myContentForm > input[name='page']").val();
	var nextPage = Number(page) + 1;
	$("#myContentForm > input[name='page']").val(nextPage);
	var totalPage = $("#myContentForm > input[name='totalPage']").val();
	if(nextPage >= totalPage){
		$("#nextPage").hide();
	}
	
	$.ajaxCall({
   		url: "/mobile/lms/myAcademy/lmsMyContentMoreAjax.do"
   		, data: {page: nextPage}
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
   			$("#articleSection").append($(data).filter("#articleSection").html());
   			abnkorea_resize();
   			$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
   		}
   	});
	
	goPageMoreBtn();
}
</script>
</head>
<body class="uiGnbM3">
		
<!-- content ##iframe start## -->
<form id="myContentForm" name="myContentForm" method="post">
<input type="hidden" name="sortColumn" value="${data.sortColumn }" />
<input type="hidden" name="sortOrder" value="${data.sortOrder }" />
<input type="hidden" name="rowPerPage" value="${data.rowPerPage }" />
<input type="hidden" name="totalCount" value="${data.totalCount }" />
<input type="hidden" name="firstIndex" value="${data.firstIndex }" />
<input type="hidden" name="totalPage" value="${data.totalPage }" />
<input type="hidden" name="page" value="${data.page }" />
<input type="hidden" name="searchtype" value="M" />
<input type="hidden" name="courseid" value="" />
<input type="hidden" name="searchClickYn" value="Y" />
		
		<section id="pbContent" class="academyWrap">
			
			<div class="searchWrap">
				<fieldset>
					<legend>검색하기</legend>
					<div class="wrap">
						<span class="word">
							<input type="text" id="searchtext" name="searchtext" placeholder="검색어 입력" title="검색어 입력" value="${data.searchtext}" maxlength="50">
							<a href="#" id="searchButton" class="btnSearch">검색</a>
						</span>
					</div>
				</fieldset>
			</div>
			
			<div class="listHead">
				<div class="listSearch">
					총 ${data.totalCount } 개
					<select id="searchcoursetype" name="searchcoursetype" title="최근 본 콘텐츠 선택">
						<option value="" <c:if test="${ data.searchcoursetype eq ''}">selected</c:if>>모든 콘텐츠</option>
						<option value="O" <c:if test="${ data.searchcoursetype eq 'O'}">selected</c:if>>온라인강의</option>
						<option value="D" <c:if test="${ data.searchcoursetype eq 'D'}">selected</c:if>>교육자료</option>
					</select>
				</div>
			</div>
			
			<div class="acSubWrap">
				<c:if test="${dataList ne null and dataList.size() > 0}">
					<section id="articleSection" class="acItems">
						<c:forEach var="item" items="${dataList}" varStatus="status">
						<article class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>" <c:if test="${status.count > 20}">style="display:none;"</c:if>>
							<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
								<c:set var="coursename" value="${item.coursename }" />
								<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
								<strong class="tit">${coursename}</strong>
								<span class="category"><span class="cate">[${item.coursetypename}]</span> ${item.categoryname}</span>
								<span class="img">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
								</span>
							</a>
							<div class="snsZone">
								<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlable${item.courseid}','');"><span class="hide">좋아요</span></a>
								<em id="likecntlable${item.courseid}">${item.likecnt}</em>
								<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
								<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetypecheck eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
								<div class="detailSns">
									<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
									<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
									<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
									<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
									<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
								</div>
							</div>
						</article>
						</c:forEach>
					</section><!-- //.acItems -->
					
					<div id="moreBtn">
						<a href="#none" id="nextPage" class="listMore" onclick="nextPage();"><span>20개 더보기</span></a>
					</div>
					<div id="topBtn" style="display:none">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</div>
				</c:if>

				<c:if test="${dataList eq null or dataList.size() == 0}">
					<section class="acItems">
						<article class="item">
							<div class="nodata">
								<c:choose>
									<c:when test="${ data.searchClickYn eq 'Y' }">
										검색결과가 없습니다.
									</c:when>
									<c:otherwise>
										최근 본 콘텐츠가 없습니다.
									</c:otherwise>
								</c:choose>
							</div>
						</article>
					</section>	
				</c:if>
			</div>
				
		</section>
</form>
		<!-- content ##iframe end## -->
<!-- SNS layer popup -->
<div class="pbLayerPopup" id="uiLayerPop_URLCopy">
	<div class="alertContent">
		<h2 class="hide">URL 복사</h2>
		<em>복사하기 하여, <br>원하는 곳에 붙여넣기 해주세요</em>
		<input type="text" title="URL 주소" class="url" id="pbLayerPopupUrl" value=""><input type="hidden" id="snsCourseid" value="">
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>
<!-- //SNS layer popup -->	


<script type="text/javascript">
$(document).ready(function() {
	abnkorea_resize();
});
</script>	
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>