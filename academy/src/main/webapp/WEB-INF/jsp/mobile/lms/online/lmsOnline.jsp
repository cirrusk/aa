<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>온라인강의 - ABN Korea</title>
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
		$("#cbolecttype").on("change", function(){
			$("#lmsOnlineForm > input[name='totalCount']").val("");
			$("#lmsOnlineForm > input[name='page']").val("");
			$("#lmsOnlineForm > input[name='firstIndex']").val("");
			
			$("#lmsOnlineForm > input[name='lectType']").val($("#cbolecttype").val());
			$("#lmsOnlineForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsOnlineForm > input[name='searchType']").val("M");
			$("#lmsOnlineForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		// 신규순 콤보박스
		$("#cboordertype").on("change", function(){
			$("#lmsOnlineForm > input[name='page']").val("1");  // 소트에는 전체페이지에 영향을 받지 않는다. 페이지만 첫페이지로 변경
			
			$("#lmsOnlineForm > input[name='lectType']").val($("#cbolecttype").val());
			$("#lmsOnlineForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsOnlineForm > input[name='searchType']").val("M");
			$("#lmsOnlineForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		
		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			$("#lmsOnlineForm > input[name='totalCount']").val("");
			$("#lmsOnlineForm > input[name='page']").val("");
			$("#lmsOnlineForm > input[name='firstIndex']").val("");
			
			$("#lmsOnlineForm > input[name='lectType']").val($("#cbolecttype").val());
			$("#lmsOnlineForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsOnlineForm > input[name='searchType']").val("M");
			$("#lmsOnlineForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		
		$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
		fnAnchor2(); //TOP로 이동

		goPageMoreBtn();
		
		//하이브리스 권한 체크
		if( $("#hybrischeck").val() == "N" ) {
			$("#hybrischeck").val("Y");
			alert("수강권한이 없습니다.");
		}
	});

	// 더보기, top 버튼 컨트롤
	function goPageMoreBtn() {
		var totalPageVal = $("#lmsOnlineForm > input[name='totalPage']").val();
		var pageVal = $("#lmsOnlineForm > input[name='page']").val();
		if(totalPageVal == 0 || totalPageVal == pageVal) {
			$("#moreBtn").hide();
			$("#topBtn").show();
		}
	}
	
	
	// 검색호출
	function doSearch() {
		$("#lmsOnlineForm").attr("action", "/mobile/lms/online/lms${scrData.menuCategory}.do");
		$("#lmsOnlineForm").submit();
	}
	
	// 페이지 이동
	function doPage(page) {
		
		$("#lmsOnlineForm > input[name='page']").val(page); 
		
		$("#lmsOnlineForm > input[name='lectType']").val($("#cbolecttype").val());
		$("#lmsOnlineForm > input[name='sortColumn']").val($("#cboordertype").val());
		$("#lmsOnlineForm > input[name='searchType']").val("M");
		$("#lmsOnlineForm > input[name='searchTxt']").val($("#searchText").val());
		
		doSearch();
	}

	//저작권동의 선택시 이벤트.
	function categoryAgreeEvent(sCategoryid) {
		var params = {'categoryid':sCategoryid};
		
		$.ajax({
			url : "/lms/categoryAgreeEvent.do",
			method : "POST",
			data : params,
			success: function(data, textStatus, jqXHR) {
				
				if(data.sCode == "1") { 
					alert(data.sMsg);		//저작권동의 되었습니다.
					$("#lmsOnlineForm > input[name='totalCount']").val("");
					doPage("1");
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("<spring:message code="errors.load"/>");
			}
		});
		
	}
	

	// 상세보기 호출
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		
		$("#lmsOnlineForm > input[name='courseid']").val(courseidVal);
			
		$("#lmsOnlineForm").attr("action", actionUrl);
		$("#lmsOnlineForm").submit();
		
	}

	// 더보기 
	function nextPage(){
		var urlVal = "/mobile/lms/online/lmsOnlineMoreAjax.do";
		
		var categoryidVal = $("#lmsOnlineForm > input[name='categoryid']").val();
		var menuCategoryVal = $("#lmsOnlineForm > input[name='menuCategory']").val();
		var menuCategoryNmVal = $("#lmsOnlineForm > input[name='menuCategoryNm']").val();
		
		var lectTypeVal = $("#lmsOnlineForm > input[name='lectType']").val();
		var sortColumnVal = $("#lmsOnlineForm > input[name='sortColumn']").val();
		var sortOrderVal = $("#lmsOnlineForm > input[name='sortOrder']").val();
		var searchTypeVal = $("#lmsOnlineForm > input[name='searchType']").val();
		var searchTxtVal = $("#lmsOnlineForm > input[name='searchTxt']").val();
		
		var rowPerPageVal = $("#lmsOnlineForm > input[name='rowPerPage']").val();
		var totalCountVal = $("#lmsOnlineForm > input[name='totalCount']").val();
		var firstIndexVal = $("#lmsOnlineForm > input[name='firstIndex']").val();
		var totalPageVal = $("#lmsOnlineForm > input[name='totalPage']").val();
		var pageVal = $("#lmsOnlineForm > input[name='page']").val();
		
		var nextPage = Number(pageVal) + 1;
		$("#lmsOnlineForm > input[name='page']").val(nextPage);
		if(nextPage >= totalPageVal){ 	$("#nextPage").hide(); }
		
		var params = {page:nextPage, categoryid:categoryidVal, menuCategory:menuCategoryVal, menuCategoryNm:menuCategoryNmVal, lectType:lectTypeVal, sortColumn:sortColumnVal, sortOrder:sortOrderVal, searchType:searchTypeVal, searchTxt:searchTxtVal, rowPerPage:rowPerPageVal, totalCount:totalCountVal, firstIndex:firstIndexVal, totalPage:totalPageVal};
		
		$.ajaxCall({
	   		url: urlVal
	   		, data: params
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			$("#articleSection").append($(data).filter("#articleSection").html());
	   			abnkorea_resize();
	   			$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
	   		}
	   	});
		
		goPageMoreBtn();
	}
</script>



</head>

<body class="uiGnbM3">

<form id="lmsOnlineForm" name="lmsOnlineForm" method="post">
	<input type="hidden" name="menuCategory"  value="${scrData.menuCategory }" />
	<input type="hidden" name="menuCategoryNm"  value="${scrData.menuCategoryNm }" />
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
	
	<input type="hidden" name="lectType"   value="${scrData.lectType }" />
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
	<input type="hidden" id="hybrischeck"  value="${scrData.hybrischeck }" />
</form>

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">온라인강의</h2>
			<div id="pageLocationTop" class="searchWrap">
				<fieldset>
					<legend>온라인강의 검색하기</legend>
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
					<select id="cbolecttype" name="cbolecttype">
						<option value=""  <c:if test="${scrData.lectType eq ''}"> selected</c:if>>모든 강의</option>
						<option value="Y" <c:if test="${scrData.lectType eq 'Y'}"> selected</c:if>>수강완료</option>
						<option value="N" <c:if test="${scrData.lectType eq 'N'}"> selected</c:if>>수강미완료</option>
					</select>
					<select id="cboordertype" name="cboordertype">
						<option value="COURSEID" <c:if test="${scrData.sortColumn eq 'COURSEID'}"> selected</c:if>>신규순</option>
						<option value="VIEWCOUNT" <c:if test="${scrData.sortColumn eq 'VIEWCOUNT'}"> selected</c:if>>인기순</option>
						<option value="LIKECOUNT" <c:if test="${scrData.sortColumn eq 'LIKECOUNT'}"> selected</c:if>>좋아요순</option>
					</select>
				</div>
			</div>
			<c:set var="complianceExist" value="N"/>
			<div class="acSubWrap">
				<section id="articleSection" class="acItems">
					<c:if test="${courseList ne null and courseList.size() > 0}">
						<c:forEach var="item" items="${courseList}" varStatus="status">
							<c:set var="coursename" value="${item.coursename }" />
							<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
							
							<article class="item<c:if test="${item.finishflag eq 'Y'}"> selected</c:if>">
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<strong class="tit">${coursename}</strong>
									<span class="category">${item.categoryname}</span>
									<span class="img">
										<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;" />
										<c:if test="${not empty item.playtime}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
									<em id="likecntlab${item.courseid}">${item.likecnt}</em>
									<c:if test="${item.complianceflag ne 'Y'}">
									<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
									</c:if>
									<c:if test="${item.complianceflag eq 'Y'}">
										<c:set var="complianceExist" value="Y" />
									</c:if>
								</div>
								<div class="itemCont"> 
									<p>${item.coursecontent}</p>
									<p class="date">등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
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
										등록된 온라인 강의가 없습니다.
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
				
				<div class="toggleBox attNote">
					<strong class="tggTit"><a href="#none" title="자세히보기 열기" onclick="javascript:setTimeout(function(){ abnkorea_resize(); }, 500);">ⓘ 유의사항</a></strong>
					<div class="tggCnt">
						<ul class="listTxt">
							<li>수강완료 결과는 다음날 <span class="checkIcon"></span>(시청) 으로 적용됩니다.</li>
							<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
							<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
						<c:if test="${complianceExist eq 'Y'}">
							<li>건강영양 &middot; 음원자료실 카테고리의 자료는 ABO를 대상으로 배포된 자료로 SNS를 통한 공유 및 보관함 담기는 제한되어 있습니다.</li>
						</c:if>	
						</ul>
					</div>
				</div>
			</div>
			
		</section>
		<!-- content ##iframe end## -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>		
</body>
</html>