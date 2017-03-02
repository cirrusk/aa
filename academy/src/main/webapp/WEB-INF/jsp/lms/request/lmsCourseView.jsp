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
<title>정규과정 - ABN Korea</title>
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
	var data = {courseid: courseid, apseq: apseq, togetherrequestflag: togetherrequestflag, groupflag : "${detail.item.groupflag}"};
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
function requestCourseOk(){
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
				<h1><img src="/_ui/desktop/images/academy/h1_w030700100.gif" alt="정규과정"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030700100.gif" alt="체계적인 정규 과정 프로그램을 통해 제품ㆍ비즈니스 전문가로 성장할 수 있습니다."></p>
			</div>
			
			<!-- 게시판 상세 -->
			<dl class="tblDetailHeader">
				<dt>${detail.item.coursename }</dt>
				<dd>
					<%-- <span>등록일 : ${detail.item.registrantdate }</span> --%>
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
						<a href="#snsUrlCopy" class="snsUrl"><span class="hide">URL 복사</span></a>
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
					<a href="#none" class="snsCs" ><span class="hide">카카오스토리</span></a>
					<a href="#none" class="snsBand" ><span class="hide">밴드</span></a>
					<a href="#none" class="snsFb"><span class="hide">페이스북</span></a>
				</div>
			</div>
		</c:if>
			<div class="acDetailInfoBox">
				<div class="imgBox">
					<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" alt="${detail.item.courseimagenote}"/>
				</div>
				<div class="detailInfoBox">${detail.item.coursecontent}</div>
				
				<div class="inputBtnWrap" id="reqeustButtonDiv">
				
				<c:set var="apnamestr" value="" />
				<c:if test="${not empty detail.apList }">
					<label for="apseq" class="b reqeustOptionDiv" style="display:none">참석지역</label>
					<select id="apseq" name="apseq" class="reqeustOptionDiv" style="display:none">
						<option value="">선택해주세요</option>
					<c:forEach items="${detail.apList }" var="data" varStatus="status">					
						<option value="${data.apseq }">${data.apname }</option>
						<c:if test="${status.index eq 0 }">
							<c:set var="apnamestr" value="${data.apname }" />
						</c:if>
						<c:if test="${status.index ne 0 }">
							<c:set var="apnamestr" value="${apnamestr }, ${data.apname }" />
						</c:if>
					</c:forEach>
					</select>
				</c:if>
				
				<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
					<input type="checkbox" id="togetherrequestflag"  name="togetherrequestflag" value="Y"  class="reqeustOptionDiv" style="display:none"/>
					<label for="togetherrequestflag" class="reqeustOptionDiv" style="display:none">부사업자 동반참석</label> 
				</c:if>
				
				
 				<c:set var="reqeustOptionView" value="N" />
				<fmt:parseNumber var="requestcount" value="${detail.item.requestcount}"/>
				<fmt:parseNumber var="limitcount" value="${detail.item2.limitcount }"/>
				<c:choose>
					<c:when test="${detail.item.themefinishcount > 0 }">
							<strong class="textSL">이미 수료하신 정규과정입니다.</strong>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${detail.item.requestflag eq 'Y' }">
								<a href="#none" class="btnBasicAcGXL" onclick="requestCourseOk()">신청완료</a>
								<a href="#none" class="btnBasicAcGNXL" onclick="goMyCourse()">수강하기</a>
								<p>※ 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의 아카데미 > 통합교육 신청현황</a> 메뉴에서 진행할 수 있습니다. 
								<%-- AKL ECM 1.5 AI SITAKEAISIT-1340 
								신청 취소 및 변경은 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의아카데미 &gt; 통합교육 신청현황</a> 에서 진행할 수 있습니다. 
								--%></p>
							</c:when>
							<c:when test="${requestcount >= limitcount }">
								<a href="#none" class="btnBasicAcGXL">신청마감</a>
							</c:when>
							<c:otherwise>
								<a href="#none" class="btnBasicAcGNXL" onclick="requestCourse('${detail.item.courseid }')">신청하기</a>
							<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
								<p class="reqeustOptionDiv" style="display:none">※ 배우자 동반 교육 참석 희망시 "부사업자 동반참석" 체크 박스를 선택해 주세요.</p>
							</c:if>
								<c:set var="reqeustOptionView" value="Y" />
							</c:otherwise>
						</c:choose>
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
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_01.gif" alt="교육기간 및 장소" /></div>
							<div class="eduCont">
								<p class="listDotFS">기간 : ${detail.item.startdate } ~ ${detail.item.enddate }</p>
							<c:if test="${not empty detail.apList }">
								<p class="listDotFS">장소 : ${apnamestr }</p>
							</c:if>
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_02.gif" alt="신청대상" /></div>
							<div class="eduCont">${detail.item2.targetdetail }</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_03.gif" alt="신청기간" /></div>
							<div class="eduCont">
								<ul class="listDotFS">
								<c:forEach items="${detail.reqList }" var="data" varStatus="status">
									<c:if test="${not empty data.pincodename }">
									<li>${data.pincodename } : ${data.reqdate }</li>
									</c:if>
								</c:forEach>
								</ul>
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit"><img src="/_ui/desktop/images/academy/ico_edu_07.gif" alt="수료기준" /></div>
							<div class="eduCont pre">${detail.item2.passnote }</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit vaT"><img src="/_ui/desktop/images/academy/ico_edu_04.gif" alt="교육상세내용" /></div>
							<div class="eduCont">
								<table class="tblSchedule">
									<caption>교육상세내용</caption>
									<colgroup>
										<col style="width:45px" />
										<col style="width:45px" />
										<col style="width:70px" />
										<col style="width:auto" />
										<col style="width:70px" />
										<col style="width:115px" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col">단계</th>
											<th scope="col">회차</th>
											<th scope="col">구분</th>
											<th scope="col">교육명</th>
											<th scope="col">지역</th>
											<th scope="col">일정</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${detail.unitList }" var="data" varStatus="status" >	
										<tr>
										<c:if test="${data.rownum eq '1' }">
											<td rowspan="${data.rowspan }">${data.stepseq }</td>
										</c:if>
											<td class="brd">${data.unitorder }회</td>
											<td>
											<%-- ${data.coursetypename } --%>
											<c:if test="${data.coursetype eq 'O' }">온라인</c:if><c:if test="${data.coursetype eq 'F' }">오프라인</c:if><c:if test="${data.coursetype eq 'D' }">교육자료</c:if><c:if test="${data.coursetype eq 'L' }">라이브</c:if><c:if test="${data.coursetype eq 'V' }">설문</c:if><c:if test="${data.coursetype eq 'T' }">시험</c:if>
											</td>
											<td class="title">${data.coursename }</td>
											<td>${data.apname }</td>
											<td>${data.edudate }</td>
										</tr>
									</c:forEach>
									
									</tbody>
								</table>
							</div>
						</div> 
					</td>
				</tr>
				<tr>
					<td>
						<div class="eduContWrap">
							<div class="eduTit vaT"><img src="/_ui/desktop/images/academy/ico_edu_05.gif" alt="유의사항 및 기타안내" /></div>
							<div class="eduCont">
								${detail.item2.note }
								<c:if test="${not empty detail.item2.linktitle and not empty detail.item2.linkurl }"><li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.item2.linkurl}') " class="u">${detail.item2.linktitle }</a></li></c:if>
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
							${detail.item2.penaltynote }
							</div>
						</div> 
					</td>
				</tr>
				</c:if>
				</tbody>
			</table>
			
			<div class="btnWrapC">
				<a href="/lms/request/lmsCourse.do?viewtype=${param.viewtype }" class="btnBasicAcGL"><span>목록</span></a>
			</div>
			<!-- //게시판 상세 -->
			

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>