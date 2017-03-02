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
<!-- page common -->
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- //page common -->
<!-- page unique -->
<meta name="Description" content="설명들어감">
<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>최근본콘텐츠 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>
<script src="/js/adjustIframe.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	fnAnchor2(); //TOP로 이동
	
	$("#searchButton").on("click", function(){
		$("#myContentForm > input[name='totalCount']").val("");
		$("#myContentForm > input[name='page']").val("");
		$("#myContentForm > input[name='firstIndex']").val("");
		
		doSearch();
	});
	
	$("#resetButton").on("click", function(){
		$("#myContentForm > input[name='totalCount']").val("");
		$("#myContentForm > input[name='page']").val("");
		$("#myContentForm > input[name='firstIndex']").val("");
		
		$("#searchcoursetype").val("");
		$("#searchtype").val("");
		$("#searchtext").val("");
		
		doSearch();
	});
	
	$("#searchcoursetype").on("change", function(){
		$("#myContentForm > input[name='totalCount']").val("");
		$("#myContentForm > input[name='page']").val("");
		$("#myContentForm > input[name='firstIndex']").val("");
		
		doSearch();
	});
	
});
var doPage = function(page) {
	$("#myContentForm > input[name='page']").val(page);
	doSearch();
}
var doSearch = function() {
	$("#myContentForm").attr("action", "/lms/myAcademy/lmsMyContent.do");
	$("#myContentForm").submit();
}
var goViewLink = function(sCode, sMsg, courseidVal, actionUrl) {
	$("#myContentForm > input[name='courseid']").val(courseidVal);
	
	$("#myContentForm").attr("action", actionUrl);
	$("#myContentForm").submit();
}
</script>
</head>
<body>
		<!-- content area | ### academy IFRAME Start ### -->
<form id="myContentForm" name="myContentForm" method="post">
<input type="hidden" name="sortColumn" value="${data.sortColumn }" />
<input type="hidden" name="sortOrder" value="${data.sortOrder }" />
<input type="hidden" name="rowPerPage" value="${data.rowPerPage }" />
<input type="hidden" name="totalCount" value="${data.totalCount }" />
<input type="hidden" name="firstIndex" value="${data.firstIndex }" />
<input type="hidden" name="totalPage" value="${data.totalPage }" />
<input type="hidden" name="page" value="${data.page }" />
<input type="hidden" name="courseid" value="" />
<input type="hidden" name="searchClickYn" value="Y" />
		
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100300.gif" alt="최근 본 콘텐츠"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100300.gif" alt="최근 3개월간 조회한 온라인강의, 교육자료를 확인 할 수 있습니다."></p>
			</div>
			
			<div class="topRange">
				<div class="rightWrap">
					<span>총 ${data.totalCount } 개</span>
					<select id="searchcoursetype" name="searchcoursetype">
						<option value="" <c:if test="${ data.searchcoursetype eq ''}">selected</c:if>>모든 콘텐츠</option>
						<option value="O" <c:if test="${ data.searchcoursetype eq 'O'}">selected</c:if>>온라인강의</option>
						<option value="D" <c:if test="${ data.searchcoursetype eq 'D'}">selected</c:if>>교육자료</option>
					</select>
				</div>
			</div>
			
			<!-- 간략목록 -->
			<div class="viewWrapper viewTypeSimple" id="viewTypeSimple">
				<div class="simpleViewList">
					<div class="acItems">
						<c:choose>
							<c:when test="${ null ne dataList and !empty dataList }">
								<c:forEach var="item" items="${dataList}" varStatus="status">
								<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
									<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
										<c:set var="coursename" value="${item.coursename}" />
											<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28)}..." /></c:if>
										<span class="tit">${coursename}</span>
									</a>
									<div>
										<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
										<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
										<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlab${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlab${item.courseid}">${item.likecnt}</em></a>
									</div>
								</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div class="noItems">
									<c:choose>
										<c:when test="${ data.searchClickYn eq 'Y' }">
											검색결과가 없습니다.
										</c:when>
										<c:otherwise>
											최근 본 콘텐츠가 없습니다.
										</c:otherwise>
									</c:choose>		
								</div>
							</c:otherwise>
						</c:choose>	
					</div>
				</div>
			</div>
			
			<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
				<jsp:param name="rowPerPage" value="${data.rowPerPage}"/>
				<jsp:param name="totalCount" value="${data.totalCount}"/>
				<jsp:param name="colNumIndex" value="10"/>
				<jsp:param name="thisIndex" value="${data.page}"/>
				<jsp:param name="totalPage" value="${data.totalPage}"/>
			</jsp:include>
			
			<div class="listSch">
				<fieldset>
					<legend>서식 검색</legend>
					<select id="searchtype" name="searchtype">
						<option value="t" <c:if test="${data.searchtype eq 't'}"> selected</c:if>>제목</option>
						<option value="c" <c:if test="${data.searchtype eq 'c'}"> selected</c:if>>내용</option>
						<option value="M" <c:if test="${data.searchtype eq 'M'}"> selected</c:if>>제목+내용</option>
					</select>
					<input type="text" id="searchtext" name="searchtext" title="검색어" value="${data.searchtext}" maxlength="50">
					<input type="button" id="searchButton" value="검색" class="btnBasicAcGS">
					<input type="button" id="resetButton" value="전체보기" class="btnBasicAcWS">
				</fieldset>
			</div>
			
			<div class="lineBox">
				<ul class="listDot">
					<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
					<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
				</ul>
			</div>
		</section>
</form>	
		<!-- //content area | ### academy IFRAME Start ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>