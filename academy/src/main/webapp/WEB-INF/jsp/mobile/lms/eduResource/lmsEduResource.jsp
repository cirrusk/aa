<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>교육자료 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>


	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<script src="/_ui/mobile/common/js/apps/kakao.link.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.min.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>
<script type="text/javascript">

	$(document.body).ready(function() {
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		$("#searchText").on("keypress", function(e){
			if( e.which == 13 ) {
				$("#btnSearch").trigger("click");
			}
		});
		
		// 모든강의 콤보박스
		$("#cbodatatype").on("change", function(){
			$("#lmsEdudataForm > input[name='totalCount']").val("");
			$("#lmsEdudataForm > input[name='page']").val("");
			$("#lmsEdudataForm > input[name='firstIndex']").val("");
			
			$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
			$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsEdudataForm > input[name='searchType']").val("M");
			$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		// 신규순 콤보박스
		$("#cboordertype").on("change", function(){
			$("#lmsEdudataForm > input[name='page']").val("1");  // 소트에는 전체페이지에 영향을 받지 않는다. 페이지만 첫페이지로 변경
			
			$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
			$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsEdudataForm > input[name='searchType']").val("M");
			$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		
		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			$("#lmsEdudataForm > input[name='totalCount']").val("");
			$("#lmsEdudataForm > input[name='page']").val("");
			$("#lmsEdudataForm > input[name='firstIndex']").val("");
			
			$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
			$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsEdudataForm > input[name='searchType']").val("M");
			$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		
		$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
		fnAnchor2(); //TOP로 이동
		
		goPageMoreBtn();
	});

	// 더보기, top 버튼 컨트롤
	function goPageMoreBtn() {
		var totalPageVal = $("#lmsEdudataForm > input[name='totalPage']").val();
		var pageVal = $("#lmsEdudataForm > input[name='page']").val();
		
		if(totalPageVal == 0 || totalPageVal == pageVal) {
			$("#moreBtn").hide();
			$("#topBtn").show();
		}
	}
	
	// 검색호출
	function doSearch() {
		$("#lmsEdudataForm").attr("action", "/mobile/lms/eduResource/lms${scrData.menuCategory}.do");
		$("#lmsEdudataForm").submit();
	}
	
	// 페이지 이동
	function doPage(page) {
		
		$("#lmsEdudataForm > input[name='page']").val(page);  // 
		
		$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
		$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
		$("#lmsEdudataForm > input[name='searchType']").val("M");
		$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
		
		doSearch();
	}
	
	// 상세보기 
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		$("#lmsEdudataForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsEdudataForm").attr("action", actionUrl);
		$("#lmsEdudataForm").submit();
	}
	
	// 상세보기전 공통호출
	function fnResourceView(courseidVal) {
		var datatype = "${scrData.datatype}";
		var sortColumn = "${scrData.sortColumn}";
		var searchType = "M";
		var searchTxt = "${scrData.searchTxt}";
		var searchVal = "eduResource|" + datatype + "|" + sortColumn + "|" + searchType + "|" + searchTxt + "|";
		
		fnAccesEduView(courseidVal, searchVal);
	}

	// 더보기 
	function nextPage(){

		var urlVal = "/mobile/lms/eduResource/lmsEduResourceMoreAjax.do";
		
		var categoryidVal = $("#lmsEdudataForm > input[name='categoryid']").val();
		var menuCategoryVal = $("#lmsEdudataForm > input[name='menuCategory']").val();
		var menuCategoryNmVal = $("#lmsEdudataForm > input[name='menuCategoryNm']").val();
		
		var datatypeVal = $("#lmsEdudataForm > input[name='datatype']").val();
		var sortColumnVal = $("#lmsEdudataForm > input[name='sortColumn']").val();
		var sortOrderVal = $("#lmsEdudataForm > input[name='sortOrder']").val();
		var searchTypeVal = $("#lmsEdudataForm > input[name='searchType']").val();
		var searchTxtVal = $("#lmsEdudataForm > input[name='searchTxt']").val();
		
		var rowPerPageVal = $("#lmsEdudataForm > input[name='rowPerPage']").val();
		var totalCountVal = $("#lmsEdudataForm > input[name='totalCount']").val();
		var firstIndexVal = $("#lmsEdudataForm > input[name='firstIndex']").val();
		var totalPageVal = $("#lmsEdudataForm > input[name='totalPage']").val();
		var pageVal = $("#lmsEdudataForm > input[name='page']").val();
		
		var nextPage = Number(pageVal) + 1;
		$("#lmsEdudataForm > input[name='page']").val(nextPage);
		if(nextPage >= totalPageVal){ 	$("#nextPage").hide(); }
		
		var params = {page:nextPage, categoryid:categoryidVal, menuCategory:menuCategoryVal, menuCategoryNm:menuCategoryNmVal, datatype:datatypeVal, sortColumn:sortColumnVal, sortOrder:sortOrderVal, searchType:searchTypeVal, searchTxt:searchTxtVal, rowPerPage:rowPerPageVal, totalCount:totalCountVal, firstIndex:firstIndexVal, totalPage:totalPageVal};
		
		$.ajaxCall({
	   		url: urlVal
	   		, data: params
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

<form id="lmsEdudataForm" name="lmsEdudataForm" method="post">
	<input type="hidden" name="menuCategory"  value="${scrData.menuCategory }" />
	<input type="hidden" name="menuCategoryNm"  value="${scrData.menuCategoryNm }" />
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
	
	<input type="hidden" name="datatype"   value="${scrData.datatype }" />
	<input type="hidden" name="sortColumn"   value="${scrData.sortColumn }" />
	<input type="hidden" name="sortOrder"     value="${scrData.sortOrder }" />
	<input type="hidden" name="searchType"   value="M" />
	<input type="hidden" name="searchTxt"  value="${scrData.searchTxt }" />
	
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	<input type="hidden" name="searchClickYn" value="Y" />
	<input type="hidden" name="courseid"  value="" />
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<c:if test="${scrData.menuCategory eq 'EduResourceMusic'}"><h2 class="hide">교육자료 음원자료실</h2></c:if>
			<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}"><h2 class="hide">교육자료 </h2></c:if>
			
			<div id="pageLocationTop" class="searchWrap">
				<fieldset>
					<c:if test="${scrData.menuCategory eq 'EduResourceMusic'}"><legend>교육자료 음원자료실 검색하기</legend></c:if>
					<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}"><legend>교육자료 검색하기</legend></c:if>
					<div class="wrap">
						<span class="word">
							<input type="text" id="searchText" name="searchText" placeholder="검색어 입력" title="검색어 입력" value="${scrData.searchTxt}" maxlength="50">
							<a href="#none" id="btnSearch" name="btnSearch" class="btnSearch">검색</a>
						</span>
					</div>
				</fieldset>
			</div>
			
			<div class="listHead">
				<span class="listInfo">총 ${scrData.totalCount}개</span>
				<div class="listSearch">
					<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}">
					<select id="cbodatatype" name="cbodatatype">
						<option value=""  <c:if test="${scrData.datatype eq ''}"> selected</c:if>>모든 형식</option>
						<c:forEach items="${dataList}" var="items">
							<option value="${items.value}" <c:if test="${scrData.datatype == items.value}">selected</c:if>>${items.name}</option>
						</c:forEach>
					</select>
					</c:if>
					<select id="cboordertype" name="cboordertype">
						<option value="COURSEID" <c:if test="${scrData.sortColumn eq 'COURSEID'}"> selected</c:if>>신규순</option>
						<option value="VIEWCOUNT" <c:if test="${scrData.sortColumn eq 'VIEWCOUNT'}"> selected</c:if>>인기순</option>
						<option value="LIKECOUNT" <c:if test="${scrData.sortColumn eq 'LIKECOUNT'}"> selected</c:if>>좋아요순</option>
					</select>
				</div>
			</div>
			
			<div class="acSubWrap">
				<section id="articleSection" class="acItems">
					<c:if test="${courseList ne null and courseList.size() > 0}">
						<c:forEach var="item" items="${courseList}" varStatus="status">
							<c:set var="coursename" value="${item.coursename }" />
							<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
							
							<article class="item<c:if test="${item.finishflag eq 'Y'}"> selected</c:if>">
								<a href="#none" onClick="javascript:fnResourceView('${item.courseid}');">
									<strong class="tit">${coursename}</strong>
									<span class="category">${item.categoryname}</span>
									<span class="img">
										<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;"  />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype link">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype image">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
									<em id="likecntlab${item.courseid}">${item.likecnt}</em>
									<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
									<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									</c:if>
									<c:if test="${item.complianceflag ne 'Y'}">
									<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
									</c:if>
									<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</c:if>
								</div>
							</article>
						</c:forEach>
					</c:if>
					<c:if test="${courseList eq null or courseList.size() == 0}">
						<article class="item">
							<div class="nodata">
								<c:choose>
									<c:when test="${ scrData.searchClickYn eq 'Y' }">
										검색결과가 없습니다.
									</c:when>
									<c:otherwise>
										등록된 교육자료가 없습니다.
									</c:otherwise>
								</c:choose>	
							</div>
						</article>
					</c:if>
				</section>
				
				<c:if test="${courseList ne null and courseList.size() > 0}">
					<div id="moreBtn">
						<a href="#none" id="nextPage" class="listMore" onclick="nextPage();"><span>20개 더보기</span></a>
					</div>
					<div id="topBtn" style="display:none">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</div>
				</c:if>
			</div>
			
		</section>
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
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>