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
<title>오프라인과정 - ABN Korea</title>
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
	
	if($("#reqeustOptionView").val() == "Y"){
		$(".reqeustOptionDiv").show();
	}
});
var requestCourse = function(courseid){
	var togetherrequestflag = $("#togetherrequestflag:checked").val();
	if(togetherrequestflag != "Y"){togetherrequestflag = "N";}
	var apseq = "";
	if( $("#apseq").length > 0 ){
		apseq = $("#apseq").val();
		if(apseq == ""){
			alert("참석 지역을 선택해 주세요.");
			$("#apseq").focus();
			return;
		}
	}
	if(!confirm("해당과정을 신청하겠습니까?")){return;}
	var coursename = "${detail.item.coursename }";
	var apname = "${detail.item2.apname } ${detail.item2.roomname }";
	var startdate = "${detail.item.startdate }";
	var data = {courseid: courseid, apseq: apseq, togetherrequestflag: togetherrequestflag, groupflag : "${detail.item.groupflag}", coursename : coursename, apname:apname, startdate:startdate};
	$.ajaxCall({
   		url: "/lms/request/lmsCourseRequestAjax.do"
   		, data: data
   		, dataType: "json"
   		, async : false
   		, success: function( data, textStatus, jqXHR){
   			if(data.result == "OK"){ // 성공
   				var height = 540;
   				if(data.groupflag != "Y"){
   					height = 300;
   				}
   				window.open("/lms/request/lmsCourseRequestResult.do?result=OK&groupflag="+data.groupflag,"RequestResult","width=600,height="+height+", resizable=yes");
   				//$("#reqeustButtonDiv").html('<a href="#none" class="btnBasicAcGXL" onclick="requestCourseOk()">신청완료</a><p>※ 신청 취소 및 변경은 나의아카데미 &gt; 통합교육 신청현황 에서 진행할 수 있습니다.</p>');
   				$("#reqeustButtonDiv").html('<a href="#none" class="btnBasicAcGXL" onclick="requestCourseOk()">신청완료</a><a href="#none" class="btnBasicAcGNXL" onclick="goMyCourse()">수강하기</a><p>※ 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의 아카데미 > 통합교육 신청현황</a> 메뉴에서 진행할 수 있습니다.</p>');
   				$(".reqeustOptionDiv").hide();
   				setTimeout(function(){ abnkorea_resize(); }, 100);
   			} else if(data.result == "NO"){ // 실패
   				var status = "";
   				if(data.item.penaltycount != "0"){
   					status = "1";
   				}else if(data.item.conditiontargetcount == "0"){
   					status = "2";
   				}else if(data.item.conditiondatecount == "0"){
   					status = "3";
   				}
   				var height = 300;
   				if(status == "1"){
   					height = 350;
   				}
   				window.open("/lms/request/lmsCourseRequestResult.do?result=NO&groupflag="+data.groupflag+"&status="+status,"RequestResult","width=600,height="+height+", resizable=yes");
   			} else if(data.result == "LOGOUT"){ // 로그아웃상태
   				fnSessionCall("");
   			}
   		}
   	});
};
function requestCourseEnd(){
	alert("신청마감된 과정입니다.");
}
function requestCourseStart(){
	alert("교육이 시작된 과정입니다.");
}
function requestCourseOk(){
	//alert("자세한 신청 결과 조회, 신청 취소는 나의 아카데미 > 통합교육 신청현황 메뉴에서 진행할 수 있습니다");
	alert("신청 완료되었습니다. 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 나의 아카데미 > 통합교육 신청현황 메뉴에서 진행할 수 있습니다.");
}
function gotolinkurl(url){
	if(url.indexOf("\:\/\/") < 0){
		url = "http://"+url
	}
	window.open(url);
}
function goMyCourse(){
	var courseid = "${detail.item.courseid}";
	parent.location.href = "${abnHttpDomain}/lms/myAcademy/lmsMyRequest?courseid="+courseid+"&detailyn=y";
}
</script>
</head>
<body>
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030700200.gif" alt="오프라인강의"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030700200.gif" alt="최신 트렌드에 따른 다양한 주제와 전문적인 내용을 현장에서 만나보세요."></p>
			</div>
			
			<!-- 게시판 상세 -->
			<dl class="tblDetailHeader">
				<dt>[${detail.item2.apname }]  ${detail.item.coursename }</dt>
				<dd>
					<span class="detailInfo">
						<a href="#none" class="myRecommand <c:if test="${detail.item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${detail.item.courseid}','likecntlab${detail.item.courseid}','1');"><span>좋아요</span><em id="likecntlab${detail.item.courseid}">${detail.item.likecount }</em></a>
					</span>
				</dd>
			</dl>
		<c:if test="${detail.item.snsflag eq 'Y' }">
			<div class="snsWrap">
				<div class="snsLink topSite">
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
					${detail.item.coursecontent}
				</div>
				
				<div class="inputBtnWrap" id="reqeustButtonDiv">
					<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
					<input type="checkbox" id="togetherrequestflag" value="Y"  name="togetherrequestflag" class="reqeustOptionDiv" style="display:none"/>
					<label for="togetherrequestflag" class="reqeustOptionDiv" style="display:none">부사업자 동반참석</label> 
					</c:if>

						<c:set var="reqeustOptionView" value="N" />
						<fmt:parseNumber var="requestcount" value="${detail.item.requestcount}"/>
						<fmt:parseNumber var="limitcount" value="${detail.item2.limitcount }"/>
						<c:choose>
							<c:when test="${detail.item.requestflag eq 'Y' }">
								<a href="#none" class="btnBasicAcGXL" onclick="requestCourseOk()">신청완료</a>
								<a href="#none" class="btnBasicAcGNXL" onclick="goMyCourse()">수강하기</a>
								<%-- <p>※ 신청 취소 및 변경은 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의아카데미 &gt; 통합교육 신청현황</a> 에서 진행할 수 있습니다.</p> --%>
								<p>※ 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의 아카데미 > 통합교육 신청현황</a> 메뉴에서 진행할 수 있습니다.
							</c:when>
							<c:when test="${requestcount >= limitcount }">
								<a href="#none" class="btnBasicAcGXL">신청마감</a>
							</c:when>
							<c:when test="${detail.item.startdateflag eq '1'}">
								<a href="#none" class="btnBasicAcGXL">교육시작</a>
							</c:when>
							<c:otherwise>
								<a href="#none" class="btnBasicAcGNXL" onclick="requestCourse('${detail.item.courseid }')">신청하기</a>
							<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
								<p class="reqeustOptionDiv" style="display:none">※ 배우자 동반 교육 참석 희망시 "부사업자 동반참석" 체크 박스를 선택해 주세요.</p>
							</c:if>
								<c:set var="reqeustOptionView" value="Y" />
							</c:otherwise>
						</c:choose>
				</div>
			
			</div>
			<input type="hidden" name="reqeustOptionView" id="reqeustOptionView" value="${reqeustOptionView }">
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
								<p class="listDotFS">장소 : ${detail.item2.apname } ${detail.item2.roomname }</p>
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_02.gif" alt="신청대상" /></div>
							<div class="eduCont">
								<ul class="listDotFS">
									${detail.item2.targetdetail }
								</ul>
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_03.gif" alt="신청기간" /></div>
							<div class="eduCont">
								<c:forEach items="${detail.reqList }" var="data" varStatus="status">
									<p class="listDotFS">${data.pincodename }: ${data.reqdate } </p>
								</c:forEach>
								
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_04.gif" alt="교육상세내용" /></div>
							<div class="eduCont">
								<ul class="listDotFS">
									${detail.item2.detailcontent}
								</ul>	
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_05.gif" alt="유의사항 및 기타안내" /></div>
							<div class="eduCont">
								<ul class="listDotFS">
									${detail.item2.note }
									<c:if test="${not empty detail.item2.linktitle and not empty detail.item2.linkurl }"><li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.item2.linkurl}') " class="u">${detail.item2.linktitle }</a></li></c:if>
								</ul>
							</div>
						</div> 
					</td>
				</tr>
				<c:if test="${!empty detail.item2.penaltynote }">
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_06.gif" alt="페널티" /></div>
							<div class="eduCont">
								<ul class="listDotFS">
									${detail.item2.penaltynote }
								</ul>	
							</div>
						</div> 
					</td>
				</tr>
				</c:if>
				</tbody>
			</table>
			
			<div class="btnWrapC">
				<a href="javascript:;" onclick="document.searchForm.submit();" class="btnBasicAcGL"><span>목록</span></a>
			</div>
			<!-- //게시판 상세 -->
			

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
<form name="searchForm" id="searchForm" action="/lms/request/lmsOffline.do">
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="searchyear" value="${param.searchyear}">
<input type="hidden" name="searchmonth" value="${param.searchmonth }">
<c:forEach items="${searchapseqArr }" var="data">
<input type="hidden" name="searchapseq" value="${data }">
</c:forEach>
</form>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>
