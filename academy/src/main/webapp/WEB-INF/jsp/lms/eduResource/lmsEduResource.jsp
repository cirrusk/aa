<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<title>교육자료 - ABN Korea</title>

<!--[if lt IE 9]>
	<script src="/_ui/desktop/common/js/html5.js"></script>
	<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->

	<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
	
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

	<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
	<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
	<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
	<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
	<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
	
	<script src="/js/front.js"></script>
	<script src="/js/lms/lmsComm.js"></script>
	
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
		
	$(document.body).ready(function() {
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2(); //TOP로 이동
		
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
			$("#lmsEdudataForm > input[name='searchType']").val($("#cbosearchtype").val());
			$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		// 신규순 콤보박스
		$("#cboordertype").on("change", function(){
			$("#lmsEdudataForm > input[name='page']").val("1");  // 소트에는 전체페이지에 영향을 받지 않는다. 페이지만 첫페이지로 변경
			
			$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
			$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsEdudataForm > input[name='searchType']").val($("#cbosearchtype").val());
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
			$("#lmsEdudataForm > input[name='searchType']").val($("#cbosearchtype").val());
			$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
			
			doSearch();
		});
		
		// 전체보기버튼 클릭
		$("#btnResetSearch").on("click", function(){
			$("#lmsEdudataForm > input[name='totalCount']").val("");
			$("#lmsEdudataForm > input[name='page']").val("");
			$("#lmsEdudataForm > input[name='firstIndex']").val("");
			
			$("#lmsEdudataForm > input[name='datatype']").val("");
			$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
			$("#lmsEdudataForm > input[name='searchType']").val("t");
			$("#lmsEdudataForm > input[name='searchTxt']").val("");
			$("#cbolecttype").val("");
			$("#searchText").val("");
			
			doSearch();
		});
		
		// tab버튼 클릭
		$("#tabTypeList").on("click", function(){
			$("#lmsEdudataForm > input[name='tabViewTypeBox']").val("viewTypeList");
			abnkorea_resize();
		});
		$("#tabTypeSimple").on("click", function(){
			$("#lmsEdudataForm > input[name='tabViewTypeBox']").val("viewTypeSimple");
			abnkorea_resize();
		});
	});
	
	
	// 검색호출
	function doSearch() {
		$("#lmsEdudataForm").attr("action", "/lms/eduResource/lms${scrData.menuCategory}.do");
		$("#lmsEdudataForm").submit();
	}
	
	// 페이지 이동
	function doPage(page) {
		$("#lmsEdudataForm > input[name='page']").val(page);  // 
		
		$("#lmsEdudataForm > input[name='datatype']").val($("#cbodatatype").val());
		$("#lmsEdudataForm > input[name='sortColumn']").val($("#cboordertype").val());
		$("#lmsEdudataForm > input[name='searchType']").val($("#cbosearchtype").val());
		$("#lmsEdudataForm > input[name='searchTxt']").val($("#searchText").val());
		
		doSearch();
	}
	
	// 상세보기 이동 
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		$("#lmsEdudataForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsEdudataForm").attr("action", actionUrl);
		$("#lmsEdudataForm").submit();
	}

	// 상세보기전 공통호출
	function fnResourceView(courseidVal) {
		var datatype = "${scrData.datatype}";
		var sortColumn = "${scrData.sortColumn}";
		var searchType = "${scrData.searchType}";
		var searchTxt = "${scrData.searchTxt}";
		var currPage = "${scrData.page}";
		var searchVal = "eduResource|" + datatype + "|" + sortColumn + "|" + searchType + "|" + searchTxt + "|" + currPage + "|";

		fnAccesEduView(courseidVal, searchVal);
	}

</script>
</head>

<body>
<form id="lmsEdudataForm" name="lmsEdudataForm" method="post">
	<input type="hidden" name="menuCategory"  value="${scrData.menuCategory }" />
	<input type="hidden" name="menuCategoryNm"  value="${scrData.menuCategoryNm }" />
	<input type="hidden" name="menuCategoryImg"  value="${scrData.menuCategoryImg }" />
	<input type="hidden" name="tabViewTypeBox"  value="${scrData.tabViewTypeBox }" />
	
	<input type="hidden" name="datatype"   value="${scrData.datatype }" />
	<input type="hidden" name="sortColumn"   value="${scrData.sortColumn }" />
	<input type="hidden" name="sortOrder"     value="${scrData.sortOrder }" />
	<input type="hidden" name="searchType"   value="${scrData.searchType }" />
	<input type="hidden" name="searchTxt"  value="${scrData.searchTxt }" />
	
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	<input type="hidden" name="searchClickYn" value="Y" />
	
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
	<input type="hidden" name="courseid"  value="" />
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/${scrData.menuCategoryImg}" alt="${scrData.menuCategoryNm}"></h1>
			<c:if test="${scrData.menuCategory eq 'EduResourceMusic'}">
				<p><img src="/_ui/desktop/images/academy/txt_w030601000.gif" alt="저작권 걱정없이 다양한 음원을 비즈니스에 활용하세요."></p>
			</c:if>
			<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}">
				<p><img src="/_ui/desktop/images/academy/txt_w030600100.gif" alt="다양한 교육자료를 통해 암웨이의 제품과 비즈니스를 전달하세요."></p>
			</c:if>
			</div>
			
			<!-- 상세보기-간략보기 -->
			<div class="toggleViewBox" id="toggleViewBox">
				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeList" class="list<c:if test="${scrData.tabViewTypeBox eq 'viewTypeList'}"> on</c:if>" id="tabTypeList">상세보기</a>
						<a href="#viewTypeSimple" class="simple<c:if test="${empty scrData.tabViewTypeBox}"> on</c:if><c:if test="${scrData.tabViewTypeBox eq 'viewTypeSimple'}"> on</c:if>" id="tabTypeSimple">간략보기</a>
					</div>
					<div class="rightWrap">
						<span>총 ${scrData.totalCount} 개</span>
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
				
				<!-- 목록 -->
				<c:set var="complianceExist" value="N"/>
				<!-- 상세목록 -->
				<div class="viewWrapper viewList" id="viewTypeList">
					<table class="tblThumbView">
						<caption>상세목록</caption>
						<colgroup>
							<col style="width:245px" />
							<col style="width:auto" />
						</colgroup>
						<tbody>
							<c:forEach var="item" items="${courseList}" varStatus="status">
							<tr class="acItems<c:if test="${item.finishflag eq 'Y'}"> selected</c:if>">
								<td><a href="#none" class="acThumbImg" onClick="javascript:fnResourceView('${item.courseid}');"><img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
								</a></td>
								<td>
									<div class="contBox">
										<c:set var="coursename" value="${item.coursename }" />
										<c:if test="${fn:length(coursename) + fn:length(item.categoryname) > 52}"><c:set var="coursename" value="${fn:substring(coursename,0,(50 - fn:length(item.categoryname)))}..." /></c:if>
										<c:set var="coursecontent" value="${item.coursecontent }" />
										<c:if test="${fn:length(coursecontent) > 110}"><c:set var="coursecontent" value="${fn:substring(coursecontent,0,108) }..." /></c:if>
										
										<a href="#none" class="title" onClick="javascript:fnResourceView('${item.courseid}');"><span class="cate">[${item.categoryname}]</span> ${coursename}
										<c:if test="${item.finishflag eq 'Y'}"><span class="checkIcon"></span></c:if>
										</a>
										<p class="subtext">${coursecontent}</p>
										<p class="date">등록일 : ${item.registrantdate}<em>|</em>조회 : ${item.viewcount}</p>
										<div class="snsZone">
											<!-- sns module -->
											<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
											<div class="snsLink">
												<span class="snsUrlBox">
													<a href="#snsUrlCopy" class="snsUrl" onclick=""><span class="hide">URL 복사</span></a>
													<span class="alert" id="snsUrlCopy" style="display:none;">
														<span class="alertIn">
															<em>복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
															<input type="text" title="URL 주소" value="${scrData.httpDomain }/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }">
														</span>
														<a href="#none" class="btnClose"><img src="/_ui/desktop/images/common/btn_close4.gif" alt="URL 복사 안내 닫기"></a>
													</span>
												</span>
												<a href="#none" class="snsCs"><span class="hide">카카오스토리</span></a>
												<a href="#none" class="snsBand"><span class="hide">밴드</span></a>
												<a href="#none" class="snsFb"><span class="hide">페이스북</span></a>
											</div>
											<!-- //sns module -->
											<a href="#none" class="share"><span class="hide">공유</span></a>
											</c:if>
											<c:if test="${item.complianceflag ne 'Y'}">
											<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
											</c:if>
											<c:if test="${item.complianceflag eq 'Y'}">
												<c:set var="complianceExist" value="Y" />
											</c:if>
											<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlable${item.courseid}','likecntlableA${item.courseid}');"><span class="hide">좋아요</span></a>
											<em id="likecntlableA${item.courseid}">${item.likecnt}</em>
										</div><!-- //snsZone -->
									</div>
								</td>
							</tr>
							</c:forEach>
							
							<c:if test="${courseList eq null or courseList.size() == 0}">
							<tr class="acItems">
								<td colspan="2">
									<div class="noItems">
										<c:choose>
											<c:when test="${ scrData.searchClickYn eq 'Y' }">
												검색결과가 없습니다.
											</c:when>
											<c:otherwise>
												등록된 교육자료가 없습니다.
											</c:otherwise>
										</c:choose>	
									</div>
								</td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				<!-- //상세목록 -->
				
				<!-- 간략목록 -->
				<div class="viewWrapper viewTypeSimple" id="viewTypeSimple">
					<div class="simpleViewList">
						<div class="acItems">
							<c:forEach var="item" items="${courseList}" varStatus="status">
							<div class="item<c:if test="${item.finishflag eq 'Y'}"> selected</c:if>">
								<a href="#none" class="acThumbImg" onClick="javascript:fnResourceView('${item.courseid}');">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<span class="tit">${coursename}</span>
								</a>
								<div>
									<!-- <span class="menu">[${item.coursetypename}]</span> -->
									<span class="cate">${item.categoryname}</span> 
									<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlable${item.courseid}','likecntlableA${item.courseid}');"><span class="hide">좋아요</span><em id="likecntlable${item.courseid}">${item.likecount}</em></a>
								</div>
							</div>
							</c:forEach>
							
							<c:if test="${courseList eq null || courseList.size() == 0}">
							<div class="noItems">
								<c:choose>
									<c:when test="${ scrData.searchClickYn eq 'Y' }">
										검색결과가 없습니다.
									</c:when>
									<c:otherwise>
										등록된 교육자료가 없습니다.
									</c:otherwise>
								</c:choose>
							</div>
							</c:if>
						</div><!-- //.acItems -->
					</div><!-- //.simpleViewList -->
				</div>
				<!-- //간략목록 -->
				
				<!-- //페이지처리 -->
				<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
					<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
					<jsp:param name="totalCount" value="${scrData.totalCount}"/>
					<jsp:param name="colNumIndex" value="10"/>
					<jsp:param name="thisIndex" value="${scrData.page}"/>
					<jsp:param name="totalPage" value="${scrData.totalPage}"/>
				</jsp:include>
				
				
				<div class="listSch">
					<fieldset>
						<legend>서식 검색</legend>
							<select id="cbosearchtype" name="cbosearchtype">
								<option value="t" <c:if test="${scrData.searchType eq 't'}"> selected</c:if>>제목</option>
								<option value="c" <c:if test="${scrData.searchType eq 'c'}"> selected</c:if>>내용</option>
								<option value="M" <c:if test="${scrData.searchType eq 'M'}"> selected</c:if>>제목+내용</option>
							</select>
							<input type="text" id="searchText" name="searchText" title="검색어" value="${scrData.searchTxt}" maxlength="50">
							<input type="button" id="btnSearch" name="btnSearch" value="검색" class="btnBasicAcGS">
							<input type="button" id="btnResetSearch" name="btnResetSearch" value="전체보기" class="btnBasicAcWS">
					</fieldset>
				</div>
				
				<div class="lineBox">
					<ul class="listDot">
						<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
						<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
					<c:if test="${complianceExist eq 'Y' or scrData.menuCategory eq 'EduResourceMusic' }">
						<li>건강영양 &middot; 음원자료실 카테고리의 자료는 ABO를 대상으로 배포된 자료로 SNS를 통한 공유 및 보관함 담기는 제한되어 있습니다.</li>
					</c:if>
					</ul>
				</div>
				
			</div>
			<!-- //상세보기-간략보기 -->

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>