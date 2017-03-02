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
<title>통합교육 신청현황 - ABN Korea</title>
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

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	var searchcoursetypeObj = "${searchcoursetypeArr}".replace("[","").replace("]","").split(", ");
	var searchstatus = "${scrData.searchstatus}";
	var searchstartyear = "${scrData.searchstartyear}";
	var searchstartmonth = "${scrData.searchstartmonth}";
	var searchendyear = "${scrData.searchendyear}";
	var searchendmonth = "${scrData.searchendmonth}";
	var searchtext = "${scrData.searchtext}";
	var checkall = "${scrData.checkall}";
	var searchyn = "${scrData.searchyn}";
	$(document).ready(function() {
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2();
		defaultCheck();
		
		$("#searchForm input[name=searchcoursetype]").on("click", function(){
			var checkLen = $("#searchForm input[name=searchcoursetype]").length;
			var checkedLen = $("#searchForm input[name=searchcoursetype]:checked").length;
			if(checkLen == checkedLen){
				$("#searchForm input[name=checkall]").prop("checked", true);
			}else{
				$("#searchForm input[name=checkall]").prop("checked", false);
			}
		});
	});
	var viewDetail = function(coursetype, courseid){
		var url = "/lms/myAcademy/lmsMyRequestOffline.do";
		if(coursetype == "R"){
			url = "/lms/myAcademy/lmsMyRequestCourse.do";
		}else if(coursetype == "L"){
			url = "/lms/myAcademy/lmsMyRequestLive.do";
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
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm > input[name='page']").val(""); 
		$("#searchForm").submit();
	};
	var searchTab = function(viewtype){
		var oldviewtype = $("#searchForm input[name='viewtype']").val();
		$("#searchForm input[name='viewtype']").val(viewtype);
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm").submit();
		//searchGo();
	};
	var defaultCheck = function(){
		$("#searchForm input[name=checkall]").prop("checked", checkall);
		if(searchcoursetypeObj.length > 0){
			for(var i = 0 ; i < searchcoursetypeObj.length; i++){
				$("#searchForm input[name=searchcoursetype][value="+searchcoursetypeObj[i]+"]").prop("checked", true);
			}
		}
		if(searchyn==""){
			$("#searchForm input[name=checkall]").prop("checked", true);
			$("#searchForm input[name=searchcoursetype]").each(function(i){
				$(this).prop("checked", true);
			});
		}
		$("#searchForm select[name=searchstatus]").val(searchstatus);
		$("#searchForm select[name=searchstartyear]").val(searchstartyear);
		$("#searchForm select[name=searchstartmonth]").val(searchstartmonth);
		$("#searchForm select[name=searchendyear]").val(searchendyear);
		$("#searchForm select[name=searchendmonth]").val(searchendmonth);
		$("#searchForm input[name=searchtext]").val(searchtext);
	};
	var resetForm = function(){
		//$("#searchForm")[0].reset();
		//defaultCheck();
		$("#searchForm input[name=checkall]").prop("checked", true);
		$("#searchForm input[name=searchcoursetype]").each(function(i){
			$(this).prop("checked", true);
		});
		$("#searchForm select[name=searchstatus]").val("");
		$("#searchForm select[name=searchstartyear]").val("${nowyear}");
		$("#searchForm select[name=searchstartmonth]").val("${nowmonth}");
		$("#searchForm select[name=searchendyear]").val("${nowyear}");
		$("#searchForm select[name=searchendmonth]").val("${nowmonth}");
		$("#searchForm input[name=searchtext]").val("");
		searchGo();
	};
	// 페이지 이동
	function doPage(page) {
		$("#searchForm > input[name='page']").val(page);  //
		$("#searchForm").submit();
	}
	function checkallClick(){
		var checked = $("#checkall").is(":checked");
		$("input[name=searchcoursetype]").prop("checked", checked);
		
	}
</script>
</head>
<body>
<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="viewtype" value="${scrData.viewtype }">
<input type="hidden" name="courseid">
<input type="hidden" name="coursetype">

<input type="hidden" name="page"  value="${scrData.page }" />
<input type="hidden" name="searchyn"  value="Y" />
<input type="hidden" name="searchClickYn" value="Y" />

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100200.gif" alt="통합교육 신청현황"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100200.gif" alt="신청한 정규과정, 오프라인, 라이브 신청현황을 확인 할 수 있습니다."></p>
			</div>

			<!-- 상세복기-간략보기 -->
			<div class="toggleViewBox">
				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeCalender" onclick="searchTab('')" class="calender">캘린더보기</a>
						<a href="#viewTypeList" onclick="searchTab('1')" class="list2 on">리스트보기</a>
					</div>
				</div>
				
				<!-- 목록 -->
				<!-- 리스트보기 -->
				<div class="viewWrapper viewTypeList" id="viewTypeList">
					<!-- 조회 -->
						<div class="inputTypeBox">
							<strong>교육종류</strong>
							<input type="checkbox" name="checkall" id="checkall" value="Y"  onclick="checkallClick();" /><label for="checkall">전체</label>
							<input type="checkbox" name="searchcoursetype" id="check1" value="R" /><label for="check1">정규과정</label>
							<input type="checkbox" name="searchcoursetype" id="check2" value="F" /><label for="check2">오프라인강의</label>
							<input type="checkbox" name="searchcoursetype" id="check3" value="L" /><label for="check3">라이브교육</label>
							<strong class="tit2">나의현황</strong>
							<select name="searchstatus" id="searchstatus" >
								<option value="">전체</option>
							<c:forEach items="${statusList}" var="items">
								<option value="${items.value}" >${items.name}</option>
							</c:forEach>
							</select>
						</div>
						<div class="inputTypeBox">
							<strong>교육일</strong>
							<select name="searchstartyear" id="searchstartyear">
								<option value="">선택</option>
								<c:forEach begin="0" end="3" step="1" var="i">
									<option value="${nowyear + 1 - i }">${nowyear + 1 - i }년</option>
								</c:forEach>
							</select>
							<select name="searchstartmonth" id="searchstartmonth">
								<option value="">선택</option>
								<c:forEach begin="1" end="12" step="1" var="data">
									<option value="${data }">${data }월</option>
								</c:forEach>
							</select> ~
							
							<select name="searchendyear" id="searchendyear">
								<option value="">선택</option>
								<c:forEach begin="0" end="3" step="1" var="i">
									<option value="${nowyear + 1 - i }">${nowyear + 1 - i }년</option>
								</c:forEach>
							</select>
							<select name="searchendmonth" id="searchendmonth">
								<option value="">선택</option>
								<c:forEach begin="1" end="12" step="1" var="data">
									<option value="${data }">${data }월</option>
								</c:forEach>
							</select>
						</div>
						<div class="inputTypeBox">
							<strong>교육명</strong>
							<input type="text" name="searchtext" id="searchtext" style="width:333px" maxlength="50"/>
						</div>
						
						<div class="btnWrapC">
							<a href="#none" class="btnBasicAcGS" onclick="resetForm();"><span>초기화</span></a>
							<a href="#none" class="btnBasicAcGNS" onclick="searchGo();"><span>조회</span></a>
						</div>
					</div>
					<!-- //조회 -->
					
					<div class="topRange mgtS">
						<div class="rightWrap text">
							<span>총 ${scrData.totalCount} 개</span>
						</div>
					</div>
					<table class="tblSchedule">
						<caption>교육과정 표</caption>
						<colgroup>
							<col width="120px" />
							<col width="80px" />
							<col width="auto" />
							<col width="70px" />
							<col width="90px" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">교육일</th><th scope="col">교육종류</th><th scope="col">교육명</th><th scope="col">나의현황</th><th scope="col">상세보기</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${courseList}" var="item" varStatus="status">
							<tr>
								<td>${item.startdatestr } ~ ${item.enddatestr }</td>
								<td>${item.coursetypename }</td>
								<td class="title">
									<c:if test="${item.groupflag eq 'Y' }">
									<img src="/_ui/desktop/images/academy/amwaygo_flag_pc.jpg" alt="AmwayGo!" class="flag" />
									</c:if>
									<c:if test="${item.coursetype eq 'F' }">
									[${item.apname }] 
									</c:if>
									<c:if test="${item.coursetype eq 'L' }">
									${item.liverealstr } 
									</c:if>
									${item.coursename }
									<c:if test="${item.coursetype eq 'F' or item.coursetype eq 'L' }">
									<span class="fcG">[${item.themename }]</span>
									</c:if>
								</td>
								<td>${item.studystatusname }</td>
								<td>
										<a href="javascript:;" class="btnTblW" onclick="viewDetail('${item.coursetype }', '${item.courseid }');">상세보기</a>
								</td>
							</tr>
						</c:forEach>
						<c:if test="${empty courseList}">
							<tr>
								<td colspan="5">
									<c:choose>
										<c:when test="${ scrData.searchClickYn eq 'Y' }">
											조회결과가 없습니다.
										</c:when>
										<c:otherwise>
											신청내역이 없습니다.
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:if>
						</tbody>
					</table>
					
					<!-- //페이지처리 -->
					<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
						<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
						<jsp:param name="totalCount" value="${scrData.totalCount}"/>
						<jsp:param name="colNumIndex" value="10"/>
						<jsp:param name="thisIndex" value="${scrData.page}"/>
						<jsp:param name="totalPage" value="${scrData.totalPage}"/>
					</jsp:include>
					
				</div>
				<!-- //리스트보기 -->
				
			</div>
			<!-- //상세보기-간략보기 -->

		</section>
		
</form>		
		<!-- //content area | ### academy IFRAME Start ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>