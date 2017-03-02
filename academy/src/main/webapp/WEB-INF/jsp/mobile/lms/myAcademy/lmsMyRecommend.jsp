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
<title>최근 본 콘텐츠 - ABN Korea</title>
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
	$(document).ready(function() {
		 fnMemberGrade('myPin', 'css');
		 
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		$("#categoryCancelButton").on("click", function(){
			$(".btnPopClose").trigger("click");
		});
		$("#categorySaveButton").on("click", function(){
			if(!confirm("카테고리 구독 설정을 저장하시겠습니까?")) {
				return;
			}
			//체크확인
			var categorytypes = "";
			$("input[name='check_mycategory']:checked").each(function(){
				categorytypes += $(this).val() + ",";
			});
			
			if( categorytypes == "" ) {
				//alert("구독할 카테고리를 선택하세요.");
				//return;
			} else {
				categorytypes = categorytypes.substring(0,categorytypes.length-1);
			}

			var param = {
				categorytypes : categorytypes
			}
			$.ajaxCall({
		   		url: "/mobile/lms/myAcademy/lmsMyRecommendCategorySaveAjax.do"
		   		, data: param 
		   		, dataType: "json"
		   		, success: function( data, textStatus, jqXHR){
		   			if( data.result == "SUCCESS" ) {
		   				$(".btnPopClose").trigger("click");
		   				
		   				categoryStart = "N";

		   				fnSubscript(categorytypes);

		   			} else if( data.result == "FAIL" ) {
		   				alert("<spring:message code="errors.load"/>");
		   			} else if( data.result == "LOGOUT" ) {
		   				fnSessionCall("");
		   			}
		   		}
		   		, error: function( jqXHR, textStatus, errorThrown) {
		        	alert("<spring:message code="errors.load"/>");
		   		}
		   	});
		});
		$("#acflickingMenu").on("click", function(){
			abnkorea_resize();
		}).owlCarousel({
			items : 5,
			itemsDesktop : [1000, 5],
			itemsDesktopSmall : [900, 5],
			itemsMobile : [320, 3],
			itemsCustom : [
				[320, 3],
				[400, 4],
				[600, 5],
			],
			navigation : true,
			rewindNav: false
		});
		
		$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
		
	});
	
	var fnSubscript = function( categoryTypeVal ) {
		var param = {
			categorytype : categoryTypeVal
		}
		$.ajaxCall({
	   		url: "/mobile/lms/myAcademy/lmsMyRecommendCategoryAjax.do"
	   		, data: param 
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			if($(data).filter("#result").html() == "LOGOUT"){
	   				fnSessionCall("");
	   				return;
	   			}
	   			var moreCount = 0; 
	   			if(data!="") moreCount = $(data).filter("#totalCount").html();
	   			$("#totalCount5").val(moreCount);
	   			
	   			$("#categoryMap").html($(data).filter("#categoryMap").html());
	   			fnSettingCategory( $(data).filter("#categoryList").text().trim() );
				
	   			categoryStart = "Y";
	   			
	   			setTimeout(function(){ abnkorea_resize(); }, 500);
	   			$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
	   		}
	   	});
	}
	var categoryStart = "N";
	var fnTab = function( idxVal ) {
		$(".acflMenuCon").hide();
		$("#acflMenu0"+idxVal).show();
		$(".tabClass").removeClass("on");
		$("#tab0"+ idxVal).addClass("on");
		
		if( idxVal == "5" ) {
			if( categoryStart == "N" ) {
				fnSubscript("");
			}
		}
	}
	var fnSettingCategory = function( categoryVal ) {
		if( categoryVal != "" ) {
			var categoryList = categoryVal.substring(0,categoryVal.length-1).split(",");
			$("input[name='check_mycategory']").prop("checked",false);
			for( var i=0; i<categoryList.length; i++ ) {
				$("#lb_cate0"+categoryList[i]).prop("checked",true);
			}
		}
	}
	var fnMore20 = function( idxVal ) {
		var rowPerPage = Number($("#myRecommendForm > input[name='rowPerPage']").val());
		var totalCount = $("#myRecommendForm > input[name='totalCount"+ idxVal +"']").val();
		if(rowPerPage <= totalCount){
			$("#nextPage").hide();
		}
		var page = $("#myRecommendForm > input[name='page"+ idxVal +"']").val();
		var nextPage = Number(page) + 1;
		$("#myRecommendForm > input[name='page"+ idxVal +"']").val(nextPage);
		
		$.ajaxCall({
	   		url: "/mobile/lms/myAcademy/lmsMyRecommendMoreAjax.do"
	   		, data: {page: nextPage, conditiontype : idxVal}
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			
	   			var moreCount = $(data).filter("#totalCount").html(); 
	   			$("#totalCount"+idxVal).val(moreCount);
	   			
	   			$("#articleSection_"+idxVal ).append($(data).filter("#articleSection").html());
	   			setTimeout(function(){ abnkorea_resize(); }, 500);
	   			$(document).ready(function() {$(".img").find("img").load(function(){abnkorea_resize();}); });   // 이미지로드 완료시 호출.
	   		}
	   	});
	}
	var goViewLink = function(sCode, sMsg, courseidVal, actionUrl) {
		$("#myRecommendForm > input[name='courseid']").val(courseidVal);
		
		$("#myRecommendForm").attr("action", actionUrl);
		$("#myRecommendForm").submit();
	}
</script>
</head>
<body class="uiGnbM3">
<form id="myRecommendForm" name="myRecommendForm" method="post">
<input type="hidden" name="courseid" value="" />
<input type="hidden" name="rowPerPage" value="20" />

<input type="hidden" name="page1" value="1" />
<input type="hidden" name="page2" value="1" />
<input type="hidden" name="page3" value="1" />
<input type="hidden" name="page4" value="1" />
<input type="hidden" name="page5" value="1" />

<input type="hidden" id="totalCount1" value="<c:if test="${pinList eq null }">0</c:if><c:if test="${pinList ne null }">${pinList.size()}</c:if>" />
<input type="hidden" id="totalCount2" value="<c:if test="${businessStatusList eq null }">0</c:if><c:if test="${businessStatusList ne null }">${businessStatusList.size()}</c:if>" />
<input type="hidden" id="totalCount3" value="<c:if test="${customerList eq null }">0</c:if><c:if test="${customerList ne null }">${customerList.size()}</c:if>" />
<input type="hidden" id="totalCount4" value="<c:if test="${consecutiveList eq null }">0</c:if><c:if test="${consecutiveList ne null }">${consecutiveList.size()}</c:if>" />
<input type="hidden" name="totalCount5" value="0" />

</form>		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<div class="listHead nobrd">비즈니스 현황과 소비 패턴에 따른 추천 콘텐츠를 확인할 수 있습니다.</div>
			
			<div class="acflickingMenu" id="acflickingMenu">
				<div><a href="#none" id="tab01" onclick="javascript:fnTab('1');" class="tabClass on">성장단계</a></div>
				<div><a href="#none" id="tab02" onclick="javascript:fnTab('2');" class="tabClass">비즈니스성장</a></div>
				<div><a href="#none" id="tab03" onclick="javascript:fnTab('3');" class="tabClass">리크루팅</a></div>
				<div><a href="#none" id="tab04" onclick="javascript:fnTab('4');" class="tabClass">구매성향</a></div>
				<div><a href="#none" id="tab05" onclick="javascript:fnTab('5');" class="tabClass">구독카테고리</a></div>
			</div>
			
			<div class="acflMenuCon" id="acflMenu01">
				<div class="acSubTitWrap">
					<div class="acPinLevel"><span id="myPin"></span> ${memberGrowthLevel} 성장단계에 추천된 콘텐츠</div>
				</div>	
				
				<div class="acSubWrap">
					<section id="articleSection_1" class="acItems">
						<c:if test="${pinList ne null and pinList.size() > 0 }">
							<c:forEach var="item" items="${pinList}" varStatus="status">
							<article class="item<c:if test="${item.viewflag eq 'Y' }"> selected</c:if>">
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
								<strong class="tit">${coursename}</strong>
									<span class="category"><span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">cate</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">catebox</c:if>">[${item.coursetypename}]</span> ${item.categoryname}</span>
									<span class="img">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabA${item.courseid}','');"><span class="hide">좋아요</span></a>
									<em id="likecntlabA${item.courseid}">${item.likecnt}</em>
									<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									<a href="#none" id="saveitemlabA${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlabA${item.courseid}');"><span class="hide">보관함</span></a>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</div>
							</article>
							</c:forEach>
						</c:if>	
						<c:if test="${pinList eq null or pinList.size() == 0 }">
							<article class="item">
								<div class="nodata">추천 콘텐츠가 없습니다.</div>
							</article>
						</c:if>
					</section>
					
					<c:if test="${pinList ne null and pinList.size() eq 20}">
						<a href="#none" id="more20_1" class="listMore" onclick="javascript:fnMore20('1');"><span>20개 더보기</span></a>
					</c:if>
					<c:if test="${pinList.size() > 0  }">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</c:if>
				</div>
			</div>
			
			<div class="acflMenuCon" id="acflMenu02" style="display:none;">
				<div class="acSubWrap">
					<section id="articleSection_2" class="acItems">
						<c:if test="${businessStatusList ne null and businessStatusList.size() > 0 }">
							<c:forEach var="item" items="${businessStatusList}" varStatus="status">
							<article class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<strong class="tit">${item.coursename}</strong>
									<span class="category"><span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">cate</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">catebox</c:if>">[${item.coursetypename}]</span> ${item.categoryname}</span>
									<span class="img">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabB${item.courseid}','');"><span class="hide">좋아요</span></a>
									<em id="likecntlabB${item.courseid}">${item.likecnt}</em>
									<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									<a href="#none" id="saveitemlabB${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlabB${item.courseid}');"><span class="hide">보관함</span></a>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</div>
							</article>
							</c:forEach>
						</c:if>
						<c:if test="${businessStatusList eq null or businessStatusList.size() == 0 }">
							<article class="item">
								<div class="nodata">추천 콘텐츠가 없습니다.</div>
							</article>
						</c:if>
					</section>
					
					<c:if test="${businessStatusList ne null and businessStatusList.size() eq 20}">
						<a href="#none" id="more20_2" class="listMore" onclick="javascript:fnMore20('2');"><span>20개 더보기</span></a>
					</c:if>
					<c:if test="${businessStatusList.size() > 0  }">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</c:if>
				</div>
			</div>
			
			<div class="acflMenuCon" id="acflMenu03" style="display:none;">
				<div class="acSubWrap">
					<section id="articleSection_3" class="acItems">
						<c:if test="${customerList ne null and customerList.size() > 0 }">
							<c:forEach var="item" items="${customerList}" varStatus="status">
							<article class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<strong class="tit">${item.coursename}</strong>
									<span class="category"><span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">cate</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">catebox</c:if>">[${item.coursetypename}]</span> ${item.categoryname}</span>
									<span class="img">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabC${item.courseid}','');"><span class="hide">좋아요</span></a>
									<em id="likecntlabC${item.courseid}">${item.likecnt}</em>
									<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									<a href="#none" id="saveitemlabC${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlabC${item.courseid}');"><span class="hide">보관함</span></a>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</div>
							</article>
							</c:forEach>
						</c:if>
						<c:if test="${customerList eq null or customerList.size() == 0 }">
							<article class="item">
								<div class="nodata">추천 콘텐츠가 없습니다.</div>
							</article>
						</c:if>
							
					</section>
					<c:if test="${customerList ne null and customerList.size() eq 20}">
						<a href="#none" id="more20_3" class="listMore" onclick="javascript:fnMore20('3');"><span>20개 더보기</span></a>
					</c:if>
				
					<c:if test="${customerList.size() > 0  }">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</c:if>
				</div>
			</div>
			
			<div class="acflMenuCon" id="acflMenu04" style="display:none;">
				<div class="acSubWrap">
					<section id="articleSection_4" class="acItems">
						<c:if test="${consecutiveList ne null and consecutiveList.size() > 0 }">
							<c:forEach var="item" items="${consecutiveList}" varStatus="status">
							<article class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>" >
								<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<strong class="tit">${item.coursename}</strong>
									<span class="category"><span class="<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D' }">cate</c:if><c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D' }">catebox</c:if>">[${item.coursetypename}]</span> ${item.categoryname}</span>
									<span class="img">
										<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
										<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
										<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
										<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
										<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
										<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
										<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									</span>
								</a>
								<div class="snsZone">
									<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabD${item.courseid}','');"><span class="hide">좋아요</span></a>
									<em id="likecntlabD${item.courseid}">${item.likecnt}</em>
									<a href="#none" class="share" <c:if test="${item.coursetype eq 'O'}">style="display:none"</c:if> data-url="${data.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${data.httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
									<a href="#none" id="saveitemlabD${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlabD${item.courseid}');"><span class="hide">보관함</span></a>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</div>
							</article>
							</c:forEach>
						</c:if>	
						<c:if test="${consecutiveList eq null or consecutiveList.size() == 0 }">
							<article class="item">
								<div class="nodata">추천 콘텐츠가 없습니다.</div>
							</article>
						</c:if>
					</section>
					<c:if test="${consecutiveList ne null and consecutiveList.size() eq 20}">
						<a href="#none" id="more20_4" class="listMore" onclick="javascript:fnMore20('4');"><span>20개 더보기</span></a>
					</c:if>
					<c:if test="${consecutiveList.size() > 0  }">
						<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
					</c:if>
				</div>
			</div>
			
			<div class="acflMenuCon" id="acflMenu05" style="display:none;">
				<div class="acSubTitWrap textC"><a href="#uiLayerPop_acCategory" onclick="layerPopupOpen(this); return false;" class="btnBasicWS">카테고리 구독설정</a></div>
				
				<div id="categoryMap" class="acSubWrap">
				</div>
			</div>
			
			<!-- 공통 유의사항 -->
			<div class="toggleBox attNote">
				<strong class="tggTit"><a href="#none" title="자세히보기 열기" onclick="javascript:setTimeout(function(){ abnkorea_resize(); }, 500);">ⓘ 유의사항</a></strong>
				<div class="tggCnt">
					<ul class="listTxt">
						<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
						<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
					</ul>
				</div>
			</div>
				
			<!-- Layer Popup: 카테고리 구독설정 -->
			<div class="pbLayerPopup" id="uiLayerPop_acCategory">
				<div class="pbLayerHeader">
					<strong>카테고리 구독설정</strong>
				</div>
				<div class="pbLayerContent">
					<div class="acInputWrapper">
						<p>구독을 하시면 해당 카테고리의 업데이트 시 맞춤 알림을 받을 수 있습니다. (중복 선택 가능)</p>
						<div class="checkBoxWrap">
							<span><input type="checkbox" id="lb_cate01" name="check_mycategory" value="1" /><label for="lb_cate01">비즈니스</label></span>
							<span><input type="checkbox" id="lb_cate02" name="check_mycategory" value="2" /><label for="lb_cate02">뉴트리라이트</label></span>
							<span><input type="checkbox" id="lb_cate03" name="check_mycategory" value="3" /><label for="lb_cate03">아티스트리</label></span>
							<span><input type="checkbox" id="lb_cate04" name="check_mycategory" value="4" /><label for="lb_cate04">퍼스널케어</label></span>
							<span><input type="checkbox" id="lb_cate05" name="check_mycategory" value="5" /><label for="lb_cate05">홈리빙</label></span>
							<span><input type="checkbox" id="lb_cate06" name="check_mycategory" value="6" /><label for="lb_cate06">레시피</label></span>
						</div>
					</div>
					<div class="btnWrap aNumb2">
						<span><a href="#none" id="categorySaveButton" class="btnBasicGNL">저장</a></span>
						<span><a href="#none" id="categoryCancelButton" class="btnBasicGL">취소</a></span>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //Layer Popup: 카테고리 구독 설정 -->
				
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

<script type="text/javascript">
$(document).ready(function() {
	abnkorea_resize();
});
</script>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>