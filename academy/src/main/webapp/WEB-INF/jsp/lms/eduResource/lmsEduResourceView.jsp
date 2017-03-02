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

function abnkorea_resize()
{
	var addHeight = 0;
	if($(".acReader").length > 0){
		addHeight = 12;
	}
	var topPadding = $("#pbContent").css("padding-top").replace("px","");
	var bottomPadding = $("#pbContent").css("padding-bottom").replace("px","");
	var iHeight = $("#pbContent").height();
	try{
		iHeight = Number(iHeight) + Number(topPadding) + Number(bottomPadding) + addHeight; // 탑패딩이 어딘 있고 어딘 없어서 탑 패딩 잡아서 해당 사이즈 만큼 더해줌
	}catch(e){}
	var isResize = false;
	if(iHeight == null){
		iHeight = $(document).height();
	}
	try
	{
		window.parent.postMessage(iHeight, "*");
		isResize = true;
	}
	catch(e){
		isResize = false;
	}
	if(!isResize)
	{
		try{
		}
		catch(e){
		}
	}
}

	$(document.body).ready(function() {
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2(); //TOP로 이동
	});
	
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

	// 상세보기 
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		$("#lmsEdudataForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsEdudataForm").attr("action", actionUrl);
		$("#lmsEdudataForm").submit();
	}
	
	// 목록으로 이동.
	function listClick() {
		var menuCategoryVal = $("#lmsEdudataForm > input[name='menuCategory']").val();
		if(menuCategoryVal == "") menuCategoryVal = "EduResourceNew";
		
		$("#lmsEdudataForm").attr("action", "/lms/eduResource/lms" + menuCategoryVal + ".do");
		$("#lmsEdudataForm").submit();
	}
	
	//다운로드
	function fileDown() {
		var nameVal = "";
		var fileVal = "";
		var filedownVal = $("#filedown").val();
		var arrFiledown = filedownVal.split('|');
		
		if(arrFiledown.length > 1) {
			 nameVal = arrFiledown[0];
			 fileVal = arrFiledown[1];
		}
		
		showLoading();
		var defaultParam = { name : nameVal, file : fileVal, mode : "course"};
		postGoto("/lms/common/downloadFile.do", defaultParam);
		hideLoading();
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
	
	<input type="hidden" name="courseid"  value="${scrData.courseid }" />
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
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
			
			<c:set var="viewcourseimage" value="" />
			<c:set var="viewcourseimagenote" value="" />
				
			<c:forEach var="item" items="${courseView}" varStatus="status">
				<c:set var="viewcourseimage" value="${item.courseimage}" />
				<c:set var="viewcourseimagenote" value="${item.courseimagenote}" />
			<!-- 게시판 상세 -->
			<dl class="tblDetailHeader">
				<dt>[${item.categoryname}] ${item.coursename}</dt>
				<dd>
					형식 : <c:if test="${item.datatype eq 'M'}">동영상</c:if><c:if test="${item.datatype eq 'S'}">오디오</c:if><c:if test="${item.datatype eq 'F'}">문서</c:if><c:if test="${item.datatype eq 'L'}">외부링크</c:if><c:if test="${item.datatype eq 'I'}">이미지</c:if>
					<em>|</em>등록일 : ${item.registrantdate}<em>|</em>조회 : ${item.viewcount}
					<span class="detailInfo">
					<c:if test="${item.complianceflag ne 'Y'}">
						<a href="#none" id="saveitemlab${item.courseid}" class="myDataRoom<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span>보관함</span></a>
					</c:if>
						<a href="#none" class="myRecommand <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}','1');"><span>좋아요</span><em id="likecntlab${item.courseid}">${item.likecnt}</em></a>
					</span>
				</dd>
			</dl>
			
			<div class="snsWrap">
				<div class="snsLink">
					<a href="#none" class="pPrint" onclick="javascript:print();"><span class="hide">페이지 인쇄</span></a>
				<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
				</c:if>
				</div>
			</div>
			<c:if test="${item.datatype eq 'M'}">
			<!-- 동영상 -->
			<div class="tblDetailCont">
				<div class="detailMovie">
					<c:if test="${not empty item.playtime}"><p>상영시간 : ${item.playtime}</p></c:if>
					<div class="movie">
						<c:if test="${not empty item.pclink}">
							<iframe src="${item.pclink}" frameborder="0" allowfullscreen width="712" height="394" title="${item.coursename}"></iframe>
						</c:if>
					</div>
				</div>
				<p>${item.coursecontentdetail}</p>
				
				<div class="btnWrapC">
					<c:if test="${(empty item.filelink or item.filelink eq '') and (not empty item.filedown and item.filedown ne '')}">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>	
					</c:if>
					<c:if test="${(empty item.filedown or item.filedown eq '') and (not empty item.filelink and item.filelink ne '')}">
					<a href="${item.filelink}" target="_blank" class="btnBasicAcGNL">다운로드</a>
					</c:if>
				</div>
			</div>
			<!-- //동영상 -->
			</c:if>
			<c:if test="${item.datatype eq 'S'}">
			<!-- 오디오 -->
			<div class="tblDetailCont">
				<div class="detailAudio">
					<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"   style="max-width:712px;" />
				</div>
				<!-- 20160907 수정 -->
				<div class="iframeZone">
					<iframe src="${item.pclink}" scrolling="no" frameborder="0" title="${item.coursename}"></iframe>
				</div>
				<!-- //20160907 수정 -->
				<p>${item.coursecontentdetail}</p>
				
				<div class="btnWrapC">
					<c:if test="${(empty item.filelink or item.filelink eq '') and (not empty item.filedown and item.filedown ne '')}">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>	
					</c:if>
					<c:if test="${(empty item.filedown or item.filedown eq '') and (not empty item.filelink and item.filelink ne '')}">
					<a href="${item.filelink}" target="_blank" class="btnBasicAcGNL">다운로드</a>
					</c:if>
				</div>
			</div>
			<!-- //오디오 -->
			</c:if>
			<c:if test="${item.datatype eq 'F'}">
			<!-- 문서 -->
			<c:set value="Doc" var="datatypeF" />
			<div class="tblDetailCont">
				<div class="detailDoc">
					<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="max-width:712px;"/>
				</div>
				<p>${item.coursecontentdetail}</p>
				
				<div class="btnWrapC">
					<c:if test="${(empty item.filelink or item.filelink eq '') and (not empty item.filedown and item.filedown ne '')}">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>	
					</c:if>
					<c:if test="${(empty item.filedown or item.filedown eq '') and (not empty item.filelink and item.filelink ne '')}">
					<a href="${item.filelink}" class="btnBasicAcGNL">다운로드</a>
					</c:if>
				</div>
			</div>
			<!-- //문서 -->
			</c:if>
			<c:if test="${item.datatype eq 'L'}">
			<!-- 외부링크 -->
			<div class="tblDetailCont">
				<div class="detailLink">
					<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"   style="max-width:712px;"/>
				</div>
				<p>${item.coursecontentdetail}</p>
			
				<div class="btnWrapC">
					<c:if test="${empty item.pclink or item.pclink eq ''}"><a href="#none" class="btnBasicAcGNL">링크보기</a></c:if>
					<c:if test="${not empty item.pclink and item.pclink ne ''}"><a href="${item.pclink}" target="_blank" class="btnBasicAcGNL">링크보기</a></c:if>
				</div>	
				
			</div>
			<!-- //외부링크 -->
			</c:if>
			<c:if test="${item.datatype eq 'I'}">
			<!-- 이미지 -->
			<div class="tblDetailCont">
				<div class="detailImage">
					<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"   style="max-width:712px;" />
				</div>
				<p>${item.coursecontentdetail}</p>
			
				<div class="btnWrapC">
					<c:if test="${empty item.pclink or item.pclink eq ''}"><a href="#none" class="btnBasicAcGNL">카드뉴스 보기</a></c:if>
					<c:if test="${not empty item.pclink and item.pclink ne ''}"><a href="${item.pclink}" target="_blank" class="btnBasicAcGNL">카드뉴스 보기</a></c:if>
				</div>
			</div>
			<!-- //이미지 -->
			</c:if>
			
				<input type="hidden" id="filedown" name="filedown"  value="${item.filedown }" />
			</c:forEach>
			
			<c:if test="${courseView eq null or courseView.size() == 0}">
				<div class="tblDetailCont">
					<img src="/_ui/desktop/images/academy/no_authority.gif" alt="이용 권한이 없습니다." />
					<div align="center">이용 권한이 없습니다.</div>
				</div>
			</c:if>
			
			<c:if test="${scrData.openFlag ne 'C' }">
			<div class="acEduPaging">
				<div>
				<c:forEach var="item" items="${courseViewPrev}" varStatus="status">
					<c:set var="coursenames" value="${item.coursename }" />
					<c:if test="${fn:length(coursenames) > 34}"><c:set var="coursenames" value="${fn:substring(coursenames,0,32) }..." /></c:if>
					<a href="#none" class="acThumbImg prev" title="이전" onClick="javascript:fnResourceView('${item.courseid}');">
						<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
						<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
						<span class="tit">[이전] ${coursenames}</span>
					</a>
				</c:forEach>
				<c:if test="${courseViewPrev eq null || courseViewPrev.size() == 0}">
					<a href="#none" class="acThumbImg prev" title="이전">
						<span class="bg">이전 자료가 없습니다.</span>
					</a>
				</c:if>
				</div>
				
				<div>
					<a href="#none" class="acThumbImg" title="현재">
					<c:choose>
						<c:when test="${not empty viewcourseimage and viewcourseimage ne ''}">
							<span class="bg">현재 페이지입니다.</span>
							<img src="/lms/common/imageView.do?file=${viewcourseimage}&mode=course"  alt="${viewcourseimagenote}"  />
						</c:when>
						<c:otherwise>
							<span class="bg">이용 권한이 없습니다.</span>
							<img src="/_ui/desktop/images/academy/no_authority.gif" alt="" />
						</c:otherwise>
					</c:choose>
					</a>
				</div>
				
				<div>
				<c:forEach var="item" items="${courseViewNext}" varStatus="status">
					<c:set var="coursenames" value="${item.coursename }" />
					<c:if test="${fn:length(coursenames) > 34}"><c:set var="coursenames" value="${fn:substring(coursenames,0,32) }..." /></c:if>
					<a href="#none" class="acThumbImg next" title="다음" onClick="javascript:fnResourceView('${item.courseid}');">
						<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
						<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
						<span class="tit">[다음] ${coursenames}</span>
					</a>
				</c:forEach>
				<c:if test="${courseViewNext eq null || courseViewNext.size() == 0}">
					<a href="#none" class="acThumbImg next" title="다음">
						<span class="bg">다음 자료가 없습니다.</span>
					</a>
				</c:if>
				</div>
			</div>
			</c:if>
			
			<div class="btnWrapC">
				<a href="#none" class="btnBasicAcGL" onclick="javascript:listClick();"><span>목록</span></a>
			</div>
			
			<c:if test="${datatypeF eq 'Doc'}">
			<div class="acReader">
				<span>※ 문서 자료를 보기 위해서는 Adobe Acrobat Reader가 필요합니다.</span>
				<a href="https://get.adobe.com/reader/?loc=kr" target="_blank" class="btn"><img src="/_ui/desktop/images/academy/btn_acReader.gif" alt="아크로벳리더 다운로드"></a>
			</div>
			</c:if>
			<!-- //게시판 상세 -->
			

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
	
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>