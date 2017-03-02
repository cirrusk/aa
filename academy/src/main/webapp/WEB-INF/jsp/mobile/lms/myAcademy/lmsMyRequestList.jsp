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
<title>통합교육신청현황 - ABN Korea</title>
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
	var searchcoursetypeObj = "${searchcoursetypeArr}".replace("[","").replace("]","").split(", ");
	var searchstatus = "${scrData.searchstatus}";
	var searchstartdate = "${scrData.searchstartdate}";
	var searchenddate = "${scrData.searchenddate}";
	var searchstartyear = "${scrData.searchstartyear}";
	var searchstartmonth = "${scrData.searchstartmonth}";
	var searchendyear = "${scrData.searchendyear}";
	var searchendmonth = "${scrData.searchendmonth}";
	var searchtext = "${scrData.searchtext}";
	$(document).ready(function() {
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2();
		defaultCheck();
	});
	var viewDetail = function(coursetype, courseid){
		var url = "/mobile/lms/myAcademy/lmsMyRequestOffline.do";
		if(coursetype == "R"){
			url = "/mobile/lms/myAcademy/lmsMyRequestCourse.do";
		}else if(coursetype == "L"){
			url = "/mobile/lms/myAcademy/lmsMyRequestLive.do";
		}
		$("#searchForm input[name=courseid]").val(courseid);
		$("#searchForm").attr("action", url);
		$("#searchForm").submit();
	};
	
	var searchGo = function(){
		
		var searchstartyear = $("#searchForm select[name=searchstartyear]").val();
		var searchstartmonth = $("#searchForm select[name=searchstartmonth]").val();
		if(searchstartmonth.length==1){
			searchstartmonth = "0" + searchstartmonth;
		} 
		var searchstartdate = searchstartyear + searchstartmonth;
		
		var searchendyear = $("#searchForm select[name=searchendyear]").val();
		var searchendmonth = $("#searchForm select[name=searchendmonth]").val();
		if(searchendmonth.length==1){
			searchendmonth = "0" + searchendmonth;
		} 
		var searchenddate = searchendyear + searchendmonth;
		if(searchstartdate > searchenddate){
			alert("검색 교육 시작일이 종료일보다 이후입니다.");
			return;
		}

		var viewtype = $("#searchForm input[name='viewtype']").val();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm > input[name='page']").val(""); 
		$("#searchForm").submit();
	};
	var searchTab = function(viewtype){
		var oldviewtype = $("#searchForm input[name='viewtype']").val();
		$("#searchForm input[name='viewtype']").val(viewtype);
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm > input[name='page']").val(""); 
		$("#searchForm").submit();
		//searchGo();
	};
	var defaultCheck = function(){
		if(searchcoursetypeObj.length > 0){
			for(var i = 0 ; i < searchcoursetypeObj.length; i++){
				$("#searchForm select[name=searchcoursetype]").val(searchcoursetypeObj[i]);
			}
		}
		$("#searchForm select[name=searchstatus]").val(searchstatus);
		//$("#searchForm input[name=searchstartdate]").val(searchstartdate);
		//$("#searchForm input[name=searchenddate]").val(searchenddate);
		$("#searchForm select[name=searchstartyear]").val(searchstartyear);
		$("#searchForm select[name=searchstartmonth]").val(searchstartmonth);
		$("#searchForm select[name=searchendyear]").val(searchendyear);
		$("#searchForm select[name=searchendmonth]").val(searchendmonth);
		$("#searchForm input[name=searchtext]").val(searchtext);
	};
	var resetForm = function(){
		//$("#searchForm")[0].reset();
		$("#searchForm select[name=searchcoursetype]").val("");
		$("#searchForm select[name=searchstatus]").val("");
		//$("#searchForm input[name=searchstartdate]").val("${scrData.defaultstartdate}");
		//$("#searchForm input[name=searchenddate]").val("${scrData.defaultenddate}");
		$("#searchForm select[name=searchstartyear]").val("${nowyear}");
		$("#searchForm select[name=searchstartmonth]").val("${nowmonth}");
		$("#searchForm select[name=searchendyear]").val("${nowyear}");
		$("#searchForm select[name=searchendmonth]").val("${nowmonth}");
		$("#searchForm input[name=searchtext]").val("");
		searchGo();
		
	};

	// 다음 20개 더보기
	function nextPage(){
		var page = $("#searchForm > input[name='page']").val();
		var nextPage = Number(page) + 1;
		$("#searchForm > input[name='page']").val(nextPage);
		var back = $("#searchForm > input[name='back']").val();
		$("#searchForm > input[name='back']").val("");
		var totalPage = $("#searchForm > input[name='totalPage']").val();
		if(nextPage >= totalPage){
			$("#nextPage").hide();
		}
		callList(nextPage, back);
	}
	function callList(page, back){
		$.ajaxCall({
	   		url: "/mobile/lms/myAcademy/lmsMyRequestList.do"
	   		, data: $("#searchForm").serialize()
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			$("#articleSection").append($(data).find("#articleSection"));
	   			abnkorea_resize();
	   		}
	   	});
	}
	
</script>
</head>
<body class="uiGnbM3">
<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="viewtype" value="${scrData.viewtype }">
<input type="hidden" name="courseid" value="${scrData.courseid }">
<input type="hidden" name="page" value="${scrData.page }">
<input type="hidden" name="back" value="${scrData.back }">
<input type="hidden" name="totalPage" value="${scrData.totalPage }">
<input type="hidden" name="coursetype">
<input type="hidden" name="searchyn" value="Y">
<input type="hidden" name="searchClickYn" value="Y" />

<input type="hidden" name="page"  value="${scrData.page }" />
		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			
			<div class="tabWrap">
				<span class="hide">탭 메뉴</span>
				<ul class="tabDepth1 tNum2">
					<li><a href="#none" onclick="searchTab('')">캘린더보기</a></li>
					<li class="on"><strong>교육목록</strong></li>
				</ul>
			</div>
			<!-- search -->	
			<div class="toggleBox acToggleBox on">
				<h2 class="tggTit"><a href="#none">조건검색</a></h2>
				<div class="tggCnt">
					<div class="srcBox">
						<div class="inputSel">
							<label for="searchcoursetype">교육종류</label>
							<span>
								<select name="searchcoursetype" id="searchcoursetype" title="교육종류 선택">
									<option value="">전체</option>
									<option value="R">정규과정</option>
									<option value="F">오프라인강의</option>
									<option value="L">라이브교육</option>
								</select>
							</span>
						</div>
						<div class="inputSel">
							<label for="searchstatus">나의현황</label>
							<span>
								<select title="나의현황 선택" name="searchstatus" id="searchstatus">
								<option value="">전체</option>
							<c:forEach items="${statusList}" var="items">
								<option value="${items.value}" >${items.name}</option>
							</c:forEach>
								</select>
							</span>
						</div>
						<div class="inputSel">
							<label for="edudate">교육일</label>
							<span class="tablecell">
								<span class="fl">	
									<select title="교육일 시작년" class="year" name="searchstartyear" id="searchstartyear">
									<c:forEach begin="0" end="3" step="1" var="i">
										<option value="${nowyear + 1 - i }">${nowyear + 1 - i }</option>
									</c:forEach>
									</select>
									<select title="교육일 시작월"  class="month" name="searchstartmonth" id="searchstartmonth">
									<c:forEach begin="1" end="12" step="1" var="data">
										<option value="${data }">${data }</option>
									</c:forEach>
									</select>
								</span>
								<span class="center">~</span>
								<span class="fr">
									<select title="교육일 종료년"  class="year" name="searchendyear" id="searchendyear">
									<c:forEach begin="0" end="3" step="1" var="i">
										<option value="${nowyear + 1 - i }">${nowyear + 1 - i }</option>
									</c:forEach>
									</select>
									<select title="교육일 종료월" class="month" name="searchendmonth" id="searchendmonth">
									<c:forEach begin="1" end="12" step="1" var="data">
										<option value="${data }">${data }</option>
									</c:forEach>
									</select>
								</span>
							</span>
							
							<%-- 20161107 달력을 월단위로 수정 AKL ECM 1.5 AI SITAKEAISIT-1343
							<span>
								<em><input type="date" title="교육일 시작일" class="inputDate"  name="searchstartdate" id="searchenddate" /></em>
								<em>~</em>
								<em><input type="date" title="교육일 종료일" class="inputDate"  name="searchenddate" id="searchenddate" /></em>
							</span>
							 --%>
						</div>
						<div class="inputSel">
							<label for="eduname">교육명</label>
							<span><input type="text" name="searchtext" id="searchtext" title="교육명"  maxlength="50"/></span>
						</div>
					</div>
					
					<div class="btnWrap aNumb2">
						<span><a href="javascript:;" class="btnBasicGNL" onclick="searchGo();">조회</a></span>
						<span><a href="javascript:;" class="btnBasicGL" onclick="resetForm();">초기화</a></span>
					</div>
				</div>

			</div>
			<!-- //search -->

			<div class="acSubWrap" id="articleSection">
				
			<c:forEach items="${courseList}" var="item" varStatus="status">
				<dl class="eduSummary">
					<dt>
						<a href="javascript:;" onclick="viewDetail('${item.coursetype }', '${item.courseid }');">
						<strong>
							<c:if test="${item.coursetype eq 'F' }">[${item.apname }] </c:if>
							<c:if test="${item.coursetype eq 'L' }">${item.liverealstr } </c:if>
							${item.coursename }</strong>
						<c:if test="${item.coursetype eq 'F' or item.coursetype eq 'L'  }">
						<span class="category">${item.themename }</span>
						</c:if>
						<c:if test="${item.groupflag eq 'Y' }">
						<img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" />
						</c:if>
						<span class="btn">상세보기</span></a>
					</dt>
					<dd>
						<div><span class="tit">교육일</span>${item.startdatestr2 } ~ ${item.enddatestr2 }</div>
						<div><span class="tit">교육종류</span>${item.coursetypename }</div>
						<div><span class="tit">나의현황</span>${item.studystatusname }</div>
					</dd>
				</dl>
			</c:forEach>
			
			<c:if test="${empty courseList and scrData.totalPage eq '1'}">
				<dl class="eduSummary">
					<dd>
						<div class="nodata">
						<c:choose>
							<c:when test="${ scrData.searchClickYn eq 'Y' }">
								조회결과가 없습니다.
							</c:when>
							<c:otherwise>
								신청내역이 없습니다.
							</c:otherwise>
						</c:choose>
						</div>
					</dd>
				</dl>
			</c:if>
			
			</div>
		<c:if test="${scrData.totalPage ne scrData.page }">
			<a href="#none" class="listMore" id="nextPage" onclick="nextPage();"><span>20개 더보기</span></a>
		</c:if>
		<c:if test="${scrData.totalCount ne '0'  }">
			<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
		</c:if>
		</section>
		<!-- content ##iframe end## -->
</form>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>