<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<c:choose>
	<c:when test="${detail.item.coursetype eq 'D' }">

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

<meta content="website" property="og:type">
<meta content="한국암웨이" property="og:title">
<meta content="한국암웨이 아카데미" property="og:description">
<meta content="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" property="og:url">
<meta content="ABN Korea Academy" property="og:site_name">
<meta content="${httpDomain }/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" property="og:image">

<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>아카데미 - ABN Korea</title>   
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

<script type="text/javascript">
	//다운로드
	function fileDown() {
		showLoading();
		var filelink = $("#filelink").val();
		var filedown = $("#filedown").val();
		if(filedown != ""){
			
			var nameVal = filedown.split("|")[0];
			var fileVal = filedown.split("|")[1];
			var defaultParam = { name : nameVal, file : fileVal, mode : "course"};
			postGoto("/lms/common/downloadFile.do", defaultParam);
			
		}else{
			var defaultParam = { };
			postGoto(filelink, defaultParam, "_blank");			
		}

		hideLoading();
	}
	
</script>
</head>

<body>
<div class="logoPage">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w030400100.gif" alt="신규"> <em>|</em> ${detail.item.coursetypename }</h1>
	</header>
	<section id="pbContent" class="academyWrap">




		<!-- 게시판 상세 -->
		<dl class="tblDetailHeader">
			<dt>[${detail.item.categoryname }] ${detail.item.coursename }</dt>
			<dd>
				형식 : <c:if test="${detail.item.datatype eq 'M'}">동영상</c:if><c:if test="${detail.item.datatype eq 'S'}">오디오</c:if><c:if test="${detail.item.datatype eq 'F'}">문서</c:if><c:if test="${detail.item.datatype eq 'L'}">링크</c:if><c:if test="${detail.item.datatype eq 'I'}">이미지</c:if>
				<em>|</em>등록일 : ${detail.item.registrantdate}<em>|</em>조회 : ${detail.item.viewcount}
				<span class="detailInfo">
					<a href="#none" class="myRecommand"><span>좋아요</span><em>${detail.item.likecount}</em></a>
				</span>
			</dd>
		</dl>
	<c:if test="${detail.item.snsflag eq 'Y'}">
		<div class="snsWrap">
			<div class="snsLink">
				<a href="#" class="pPrint" onclick="javascript:print();"><span class="hide">페이지 인쇄</span></a>
				<span class="snsUrlBox">
					<a href="#snsUrlCopy" class="snsUrl" onclick=""><span class="hide">URL 복사</span></a>
					<span class="alert" id="snsUrlCopy" style="display:none;">
						<span class="alertIn">
							<!-- ie, 크롬 일 경우 :
							<em>주소가 복사되었습니다.<br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
							-->
							<!-- 사파리, 파이어폭스 일 경우 -->
							<em>복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
							<input type="text" title="URL 주소" value="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }">
							<!-- //사파리, 파이어폭스 일 경우 -->
						</span>
						<a href="#none" class="btnClose"><img src="/_ui/desktop/images/common/btn_close4.gif" alt="URL 복사 안내 닫기"></a>
					</span>
				</span>
				<a href="#none" class="snsCs"><span class="hide">카카오스토리</span></a>
				<a href="#none" class="snsBand"><span class="hide">밴드</span></a>
				<a href="#none" class="snsFb"><span class="hide">페이스북</span></a>
			</div>
		</div>
	</c:if>
			<c:if test="${detail.item.datatype eq 'M'}">
			<!-- 동영상 -->
			<div class="tblDetailCont">
				<div class="detailMovie">
					<c:if test="${not empty detail.item.playtime}"><p>상영시간 : ${detail.item.playtime}</p></c:if>
					<div class="movie">
						<c:if test="${not empty detail.item2.pclink}">
							<iframe src="${detail.item2.pclink}" frameborder="0" allowfullscreen width="712" height="394" title="${detail.item.coursename}"></iframe>
						</c:if>
					</div>
				</div>
				<p>${detail.item.coursecontent}</p>
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrapC">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
			</div>
			<!-- //동영상 -->
			</c:if>
			<c:if test="${detail.item.datatype eq 'S'}">
			<!-- 오디오 -->
			<div class="tblDetailCont">
				<div class="detailAudio">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
				</div>
				<p>오디오 내용샘플 : ${detail.item.coursecontent}</p>
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrapC">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
			</div>
			<!-- //오디오 -->
			</c:if>
			<c:if test="${detail.item.datatype eq 'F'}">
			<!-- 문서 -->
			<div class="tblDetailCont">
				<div class="detailDoc">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
				</div>
				<p>문서 내용샘플 : ${detail.item.coursecontent}</p>
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrapC">
					<a href="#none" class="btnBasicAcGNL"  onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
			</div>
			<!-- //문서 -->
			</c:if>
			<c:if test="${detail.item.datatype eq 'L'}">
			<!-- 외부링크 -->
			<div class="tblDetailCont">
				<div class="detailLink">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
				</div>
				<p>외부링크 내용샘플 : ${detail.item.coursecontent}</p>
			
				<div class="btnWrapC">
					<a href="${detail.item2.pclink}" target="_blank" class="btnBasicAcGNL">링크보기</a>
				</div>	
				
			</div>
			<!-- //외부링크 -->
			</c:if>
			<c:if test="${detail.item.datatype eq 'I'}">
			<!-- 이미지 -->
			<div class="tblDetailCont">
				<div class="detailImage">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
				</div>
				<p>
					이미지 내용샘플 : ${detail.item.coursecontent}
				</p>
			
				<div class="btnWrapC">
					<a href="${detail.item2.pclink}" target="_blank" class="btnBasicAcGNL">카드뉴스 보기</a>
				</div>
			</div>
			<!-- //이미지 -->
			</c:if>
		
				<input type="hidden" id="filedown" name="filedown"  value="${detail.item2.filedown }" />
				<input type="hidden" id="filelink" name="filelink"  value="${detail.item2.filelink }" />
		
		<!-- //게시판 상세 -->
		<div class="lineBox">
			<ul class="listDot">
				<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
				<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
			</ul>
		</div>

	</section>

</div>
</body>
</html>


	</c:when>
	<c:otherwise>
	
	
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

<meta content="website" property="og:type">
<meta content="한국암웨이" property="og:title">
<meta content="한국암웨이 아카데미" property="og:description">
<meta content="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" property="og:url">
<meta content="ABN Korea Academy" property="og:site_name">
<meta content="${httpDomain }/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" property="og:image">

<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>아카데미 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>

<script type="text/javascript">
</script>
</head>
<body>
<div id="pbPopWrap" class="logoPage">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w030800100.gif" alt="통합교육신청" /> <em>|</em> ${detail.item.coursetypename }</h1>
	</header>
	
	<section id="pbPopContent">
		<!-- 게시판 상세 -->
			<h3 class="tblDetailHeader">${detail.item.coursename }</h3>			
		<c:if test="${detail.item.snsflag eq 'Y'}">
			<div class="snsWrap">
				<div class="snsLink topSite2">
					<a href="#" class="pPrint" onclick="javascript:print();"><span class="hide">페이지 인쇄</span></a>
					<span class="snsUrlBox">
						<a href="#snsUrlCopy" class="snsUrl" ><span class="hide">URL 복사</span></a>
						<span class="alert" id="snsUrlCopy" style="display:none;">
							<span class="alertIn">
								<!-- ie, 크롬 일 경우 :
								<em>주소가 복사되었습니다.<br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
								-->
								<!-- 사파리, 파이어폭스 일 경우 -->
								<em>복사하기(Ctrl+C) 하여, <br>원하는 곳에 붙여넣기(Ctrl+V) 해주세요</em>
								<input type="text" title="URL 주소" value="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }">
								<!-- //사파리, 파이어폭스 일 경우 -->
							</span>
							<a href="#none" class="btnClose"><img src="/_ui/desktop/images/common/btn_close4.gif" alt="URL 복사 안내 닫기"></a>
						</span>
					</span>
					<a href="#none" class="snsCs"><span class="hide">카카오스토리</span></a>
					<a href="#none" class="snsBand"><span class="hide">밴드</span></a>
					<a href="#none" class="snsFb"><span class="hide">페이스북</span></a>
				</div>
			</div>
		</c:if>
			<div class="acDetailInfoBox">
				<div class="imgBox">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" alt="${detail.item.courseimagenote}"/>
				</div>
				<div class="detailInfoBox">
					<p>
					${detail.item.coursecontent}
					</p>
					<p class="grayBox">교육신청은 <a href="${abnHttpDomain}/academy"><strong>ABN</strong> &gt; <strong>아카데미</strong></a>에서 교육을 신청할 수 있습니다.</p>
				</div>
			</div>
			
			<table class="tblEduCont">
				<caption>강의상세내용</caption>
				<colgroup><col width="100%" /></colgroup>
				<tbody>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_09.gif" alt="교육일시 및 장소" /></div>
							<div class="eduCont">
								<p class="listDotFS">일시 : ${detail.item.startdate } ~ ${detail.item.enddate }</p>
							<c:if test="${ detail.item.coursetype eq 'F'}">
								<p class="listDotFS">장소 : ${detail.item2.apname } ${detail.item2.roomname }</p>
							</c:if>
							<c:if test="${ detail.item.coursetype eq 'R'}">
								<c:set var="apnamestr" value="" />
								<c:if test="${not empty detail.apList }">
									<c:forEach items="${detail.apList }" var="data" varStatus="status">					
										<c:if test="${status.index eq 0 }">
											<c:set var="apnamestr" value="${data.apname }" />
										</c:if>
										<c:if test="${status.index ne 0 }">
											<c:set var="apnamestr" value="${apnamestr }, ${data.apname }" />
										</c:if>
									</c:forEach>
								</c:if>							
								<p class="listDotFS">장소 : ${apnamestr }</p>
							</c:if>
							</div>
						</div> 
					</td>
				</tr>
				
			<c:if test="${ detail.item.coursetype eq 'R' or detail.item.coursetype eq 'F' or detail.item.coursetype eq 'L'}">
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_02.gif" alt="신청대상" /></div>
							<div class="eduCont">
								<p>${detail.item2.targetdetail }</p>
							</div>
						</div> 
					</td>
				</tr>
			</c:if>
				
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_03.gif" alt="신청기간" /></div>
							<div class="eduCont">
								<p class="listDotFS">${detail.item.requeststartdate } ~ ${detail.item.requestenddate }</p>
							</div>
						</div> 
					</td>
				</tr>
				</tbody>
			</table>
			
			<div class="lineBox">
				<ul class="listDot">
					<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
					<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
				</ul>
			</div>
		
	</section>
</div>
</body>
</html>
	</c:otherwise>
</c:choose>
