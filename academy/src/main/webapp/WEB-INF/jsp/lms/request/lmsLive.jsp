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
<title>라이브교육 - ABN Korea</title>
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
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	fnAnchor2();
});
var goView = function(obj){
	fnAccesViewClick($(obj).attr("data-courseid"));
}
var tabSearch = function(viewtype){
	$("#searchForm input[name='viewtype']").val(viewtype);
}
var goView = function(obj){
	fnAccesViewClick($(obj).attr("data-courseid"), "request");
	setTimeout(function(){ abnkorea_resize(); }, 100);
}

//상세보기 호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#searchForm > input[name='courseid']").val(courseidVal);
	$("#searchForm").attr("action", actionUrl);
	$("#searchForm").submit();
}

</script>
</head>
<body>
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030700300.gif" alt="라이브교육"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030700300.gif" alt="언제 어디서든 모바일을 통해 라이브교육에 직접 참여하실 수 있습니다."></p>
			</div>
			
			<!-- 상세복기-간략보기 -->
			<div class="toggleViewBox">
				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeList" class="list<c:if test='${empty param.viewtype}'> on</c:if>" onclick="tabSearch('');">상세보기</a>
						<a href="#viewTypeSimple" class="simple<c:if test='${param.viewtype eq "1"}'> on</c:if>" onclick="tabSearch('1');">간략보기</a>
					</div>
				</div>
				
				<!-- 목록 -->
				<!-- 상세목록 -->
				<div class="viewWrapper viewList" id="viewTypeList">
					<table class="tblThumbView">
						<caption>상세목록</caption>
						<colgroup>
							<col style="width:245px" />
							<col style="width:auto" />
						</colgroup>
						<tbody>
						<c:if test="${empty courseList }">
							<tr class="acItems">
								<td colspan="2"><div class="noItems">등록된 라이브교육이 없습니다.</div></td>
							</tr>
							
						</c:if>
						<c:forEach items="${courseList }" var="item" varStatus="status">
							<tr class="acItems<c:if test='${item.requestflag eq "Y" }'> finish</c:if>">
								<td><a href="#none" data-courseid="${item.courseid }"  onclick="goView(this);" class="acThumbImg" ><img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" /><c:if test='${not empty item.requestflag }'><span class="off">신청완료</span></c:if></a></td>
								<td>
									<div class="contBox">
										<span class="title"><a href="#none" data-courseid="${item.courseid }"  onclick="goView(this);">${item.coursename }</a></span>
										<p class="subtext">대상 : ${item.target } <br/>
											방송 : ${item.startdate } ~ ${item.enddate }<br/>
											신청 : ${item.requeststartdate } ~ ${item.requestenddate } ${item.requestdiff }
										</p>
										<div class="snsZone">
											<!-- sns module -->
										<c:if test="${item.snsflag eq 'Y' }">
											<div class="snsLink">
												<span class="snsUrlBox">
													<a href="#snsUrlCopy" class="snsUrl" onclick=""><span class="hide">URL 복사</span></a>
													<span class="alert" id="snsUrlCopy" style="display:none;">
														<span class="alertIn">
															<!-- ie, 크롬 일 경우 :
															<em>주소가 복사되었습니다.<br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
															-->
															<!-- 사파리, 파이어폭스 일 경우 -->
															<em>복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
															<input type="text" title="URL 주소" value="${httpDomain }/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }">
															<!-- //사파리, 파이어폭스 일 경우 -->
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
											<a href="#none" class="like <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlab2${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
											<em id="likecntlab${item.courseid}">${item.likecount }</em>
										</div><!-- //snsZone -->
									
									</div>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- //상세목록 -->
				
				<!-- 간략목록 -->
				<div class="viewWrapper viewTypeSimple" id="viewTypeSimple">
					<div class="simpleViewList">
						<div class="acItems">
						<c:if test="${empty courseList }">
							<div class="noItems">등록된 라이브교육이 없습니다.</div>
						</c:if>
						<c:if test="${ not empty courseList }">
						<c:forEach items="${courseList }" var="item" varStatus="status">
							<div class="item<c:if test='${not empty item.requestflag }'> finish</c:if>">
								<a href="#none" class="acThumbImg" data-courseid="${item.courseid }"  onclick="goView(this);">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" />
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 32}">
										<c:set var="coursename" value="${fn:substring(coursename,0,30) }..." />
									</c:if>
									<span class="tit type2">${coursename}</span>
									<span class="period"><strong>신청기간</strong> ${item.requestdiff }<br/>${item.requeststartdate2 } ~ ${item.requestenddate2 }</span>
									<c:if test='${not empty item.requestflag }'>
									<span class="off">신청완료</span>
									</c:if>
								</a>
								<div>
									<a href="#none" class="scLike <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlab2${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span><em id="likecntlab2${item.courseid}">${item.likecount }</em></a>
								</div>
							</div>
						</c:forEach>
						</c:if>
						</div>
					</div>
				</div>
				<!-- //간략목록 -->
			</div>
			<!-- //상세보기-간략보기 -->

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
<form name="searchForm" id="searchForm">
	<input type="hidden" name="courseid">
	<input type="hidden" name="viewtype" value="${param.viewtype }">
</form>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>