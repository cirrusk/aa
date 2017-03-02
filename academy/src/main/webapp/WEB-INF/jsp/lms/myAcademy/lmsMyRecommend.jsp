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
<title>추천콘텐츠 - ABN Korea</title>
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
		fnMemberGrade('myPin', 'css');
		
		//구독신청 카테고리 조회 및 카테고리 데이터 읽기
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2(); //TOP로 이동
		
		fnRollingImage();
		fnSubscript("");
		
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
		   		url: "/lms/myAcademy/lmsMyRecommendCategorySaveAjax.do"
		   		, data: param 
		   		, dataType: "json"
		   		, success: function( data, textStatus, jqXHR){
		   			if( data.result == "SUCCESS" ) {
		   				$("#categoryCancelButton").trigger("click");
		   				
		   				fnSubscript("");
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
		
		$("#searchtype").on("change", function(){
			if( $(this).val() == "" ) {
				for( var i=1; i<=5; i++ ) {
					if(!$("#searchtype"+i).hasClass("nodata")){
						$("#searchtype"+i).show();	
					}else{
						$("#searchtype"+i).hide();
					}
				}
			} else {
				for( var i=1; i<=5; i++ ) {
					$("#searchtype"+i).hide();	
				}
				$("#searchtype"+$(this).val()).show();
			}
			
		});
		
		$(".nodata").hide();
		
		
	});
	var fnSubscript = function( categoryTypeVal ) {
		
		//카테고리 롤링 초기화
		$('#acSlideView05').data('owlCarousel').destroy(); 
		
		var param = {
			categorytype : categoryTypeVal
		}
		$.ajaxCall({
	   		url: "/lms/myAcademy/lmsMyRecommendCategoryAjax.do"
	   		, data: param 
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			if($(data).filter("#result").html() == "LOGOUT"){
	   				fnSessionCall("");
	   				return;
	   			}
	   			
	   			if( categoryTypeVal == "" ) {
	   				$("#subscribeCate").html($(data).filter("#subscribeCate").html());
	   			}
	   			
	   			$("#acSlideView05").hide();
	   			$("#acSlideView05").html($(data).filter("#acSlideView05").html());
	   			
	   			if(data!="") $("#searchtype5_cnt").val($(data).filter("#searchtype5_cnt").html());
	   			else $("#searchtype5_cnt").val($("0").filter("#searchtype5_cnt").html());
	   			
	   			//마지막 카테고리 롤링 설정
	   			$("#acSlideView05").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
	   			$("#acSlideView05").show();
	   			
				//구독신청 설정값 세팅하기
				fnCategorySetting(categoryTypeVal);
				
				if( categoryTypeVal == "" ) {
					var categoryCnt = $(data).filter("#categoryList_cnt").html();
					if( categoryCnt == "0" ) {
						$("#subscribeCate").hide();
						$("#acSlideView05").hide();
						$("#acSlideView05None").show();
					} else {
						$("#subscribeCate").show();
						$("#acSlideView05None").hide();
					}
				}
	   		}
	   	});
	}
	var fnCategorySetting = function(categoryTypeVal) {
		fnTotalCount();
		var categoryCnt = $("input[name='mycategory']").length;
		//카테고리 세팅
		if( categoryTypeVal != "" ) {
			$("li[name='myCategoryTab']").attr("class","");
			$("#myCategoryTab_"+categoryTypeVal).attr("class","on");
		}
		
		//전체 카테고리 체크해제
		$("input[name='check_mycategory']").prop("checked",false);
		for( var i=0; i<categoryCnt; i++ ) {
			var mycategory = $("input[name='mycategory']:eq("+i+")").val();
			$("#lb_cate0"+mycategory).prop("checked",true);
		}
	}
	var fnTotalCount = function() {
		var searchtype = $("#searchtype").val();
		if( searchtype != "" ) {
			$("#totalCnt").html( "총 "+ $("#searchtype"+searchtype+"_cnt").val() + " 개");
		} else {
			var totalCnt = 0;
			for( var i=1; i<=5; i++ ) {
				totalCnt += eval($("#searchtype"+i+"_cnt").val());
			}
			$("#totalCnt").html( "총 "+ totalCnt + " 개");
		}
	}
	var fnRollingImage = function() {
		$("#acSlideView01").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
		$("#acSlideView02").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
		$("#acSlideView03").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
		$("#acSlideView04").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
		$("#acSlideView05").owlCarousel({items:3, navigation:true, itemsDesktop: false, itemsDesktopSmall : false, itemsTablet: false, itemsMobile : false, rewindNav: false});
	}
	var goViewLink = function(sCode, sMsg, courseidVal, actionUrl) {
		$("#myRecommendForm > input[name='courseid']").val(courseidVal);
		
		$("#myRecommendForm").attr("action", actionUrl);
		$("#myRecommendForm").submit();
	}
</script>
</head>
<body>
		<!-- content area | ### academy IFRAME Start ### -->
<form id="myRecommendForm" name="myRecommendForm" method="post">
<input type="hidden" name="courseid" value="" />
</form>
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100500.gif" alt="추천콘텐츠" /></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100500.gif" alt="비즈니스 현황과 소비 패턴에 따른 추천 콘텐츠를 확인할 수 있습니다." /></p>
			</div>
			
			<div class="topRange">
				<div class="rightWrap">
					<span id="totalCnt" style="display: none;">총 0 개</span>
					<select id="searchtype">
						<option value="">모든 콘텐츠</option>
						<option value="1">성장단계</option>
						<option value="2">비즈니스 성장</option>
						<option value="3">리크루팅</option>
						<option value="4">구매성향</option>
						<option value="5">구독카테고리</option>
					</select>
				</div>
			</div>

			<div class="simpleViewList recomContents">
				<div id="searchtype1" class="acSlide01 <c:if test="${pinList eq null or pinList.size() < 1  }">nodata</c:if>">
					<h3><span id="myPin"></span> ${memberGrowthLevel} 성장단계에 추천된 콘텐츠</h3>
					<c:if test="${pinList ne null and pinList.size() > 0 }">
						<div class="acItems" id="acSlideView01">
							<c:forEach var="item" items="${pinList}" varStatus="status">
							<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<span class="tit">${coursename}</span>
								</a>
								<div>
									<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
									<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
									<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabA${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlabA${item.courseid}">${item.likecnt}</em></a>
								</div>
							</div>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${pinList eq null or pinList.size() == 0 }">
						<div class="noItems">추천 콘텐츠가 없습니다.</div>
					</c:if>
				</div>

				<div id="searchtype2" class="acSlide02 <c:if test="${businessStatusList eq null or businessStatusList.size() < 1 }">nodata</c:if>">
					<h3>비즈니스 성장</h3>
					<c:if test="${businessStatusList ne null and businessStatusList.size() > 0 }">
						<div class="acItems" id="acSlideView02">
							<c:forEach var="item" items="${businessStatusList}" varStatus="status">
							<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<span class="tit">${coursename}</span>
								</a>
								<div>
									<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
									<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
									<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabB${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlabB${item.courseid}">${item.likecnt}</em></a>
								</div>
							</div>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${businessStatusList eq null or businessStatusList.size() == 0 }">
						<div class="noItems">추천 콘텐츠가 없습니다.</div>
					</c:if>
				</div>
				
				<div id="searchtype3" class="acSlide03 <c:if test="${customerList eq null or customerList.size() < 1 }">nodata</c:if>">
					<h3>리크루팅</h3>
					<c:if test="${customerList ne null and customerList.size() > 0 }">
						<div class="acItems" id="acSlideView03">
							<c:forEach var="item" items="${customerList}" varStatus="status">
							<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<span class="tit">${coursename}</span>
								</a>
								<div>
									<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
									<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
									<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabC${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlabC${item.courseid}">${item.likecnt}</em></a>
								</div>
							</div>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${customerList eq null or customerList.size() == 0 }">
						<div class="noItems">추천 콘텐츠가 없습니다.</div>
					</c:if>
				</div>
			
				<div id="searchtype4" class="acSlide04 <c:if test="${consecutiveList eq null or consecutiveList.size() < 1 }">nodata</c:if>">
					<h3>구매성향</h3>
					<c:if test="${consecutiveList ne null and consecutiveList.size() > 0 }">
						<div class="acItems" id="acSlideView04">
							<c:forEach var="item" items="${consecutiveList}" varStatus="status">
							<div class="item <c:if test="${item.viewflag eq 'Y' }">selected</c:if>">
								<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}');">
									<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
									<c:set var="coursename" value="${item.coursename }" />
									<c:if test="${fn:length(coursename) > 30}"><c:set var="coursename" value="${fn:substring(coursename,0,28) }..." /></c:if>
									<span class="tit">${coursename}</span>
								</a>
								<div>
									<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span> <span class="cate">${item.categoryname}</span></c:if>
									<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
									<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClickDual('${item.courseid}','likecntlabD${item.courseid}','');"><span class="hide">좋아요</span><em id="likecntlabD${item.courseid}">${item.likecnt}</em></a>
								</div>
							</div>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${consecutiveList eq null or consecutiveList.size() == 0 }">
						<div class="noItems">추천 콘텐츠가 없습니다.</div>
					</c:if>
				</div>
				
				<div id="searchtype5" class="acSlide05">
					<h3>구독카테고리</h3>
					<span class="btnRight">
						<a href="#uiLayerPop_settingCate" class="btnBasicAcWS" onClick="fnAnchor2();">카테고리 구독 설정</a>
					</span>
					<div id="subscribeCate" class="tabWrap">
					</div>
					<div id="acSlideView05" class="acItems">
						<div class="item">
						</div>
					</div><!-- //.acItems -->
					<div id="acSlideView05None" class="noItems" style="display:none">구독 카테고리가 없습니다. 카테고리 구독 설정을 해주세요.</div>
				</div>
				
				<input type="hidden" id="searchtype1_cnt" value="<c:if test="${pinList eq null }">0</c:if><c:if test="${pinList ne null }">${pinList.size()}</c:if>" />
				<input type="hidden" id="searchtype2_cnt" value="<c:if test="${businessStatusList eq null }">0</c:if><c:if test="${businessStatusList ne null }">${businessStatusList.size()}</c:if>" />
				<input type="hidden" id="searchtype3_cnt" value="<c:if test="${customerList eq null }">0</c:if><c:if test="${customerList ne null }">${customerList.size()}</c:if>" />
				<input type="hidden" id="searchtype4_cnt" value="<c:if test="${consecutiveList eq null }">0</c:if><c:if test="${consecutiveList ne null }">${consecutiveList.size()}</c:if>" />
				<input type="hidden" id="searchtype5_cnt" value="0" />
				
			</div><!-- //.simpleViewList -->
			
			<div class="lineBox">
				<ul class="listDot">
					<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
					<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
				</ul>
			</div>
			<br/><br/>
			
			<!-- #Layer Popup : 카테고리 구독 설정 -->
			<div class="pbLayerWrap" id="uiLayerPop_settingCate" style="width:600px; display:none;" >
				<div class="pbLayerHeader">
					<strong><img src="/_ui/desktop/images/academy/h1_w030000010_lp.gif" alt="카테고리 구독 설정"></strong>
					<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="카테고리 구독 설정 닫기"></a>
				</div>
				<div class="pbLayerContent">
					<div class="acMainPopup">
						<p class="textC">
							<strong>구독을 하시면 해당 카테고리의 업데이트 시 맞춤 알림을 받을 수 있습니다.</strong> (중복 선택 가능)</p>
						<div class="acInputWrap">
							<input type="checkbox" id="lb_cate01" name="check_mycategory" value="1" /><label for="lb_cate01">비즈니스</label>
							<input type="checkbox" id="lb_cate02" name="check_mycategory" value="2" /><label for="lb_cate02">뉴트리라이트</label>
							<input type="checkbox" id="lb_cate03" name="check_mycategory" value="3" /><label for="lb_cate03">아티스트리</label><br/>
							<input type="checkbox" id="lb_cate04" name="check_mycategory" value="4" /><label for="lb_cate04">퍼스널케어</label>
							<input type="checkbox" id="lb_cate05" name="check_mycategory" value="5" /><label for="lb_cate05">홈리빙</label>
							<input type="checkbox" id="lb_cate06" name="check_mycategory" value="6" /><label for="lb_cate06">레시피</label>	
						</div>
					</div>
					<div class="btnWrapC">
						<a href="#none" id="categoryCancelButton" class="btnBasicAcGS layerPopClose">취소</a>
						<a href="#none" id="categorySaveButton" class="btnBasicAcGNS">저장</a>
					</div>
					
				</div>
			</div>
			<!-- //#Layer Popup : 목표설정 -->
			
		</section>
	
		<!-- //content area | ### academy IFRAME Start ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>