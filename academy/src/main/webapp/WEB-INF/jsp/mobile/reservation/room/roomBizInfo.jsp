<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/framework/include/mobile/top.jsp" %>

<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<link rel="stylesheet" href="/_ui/mobile/common/css/main.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/pbCommon.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/_ui/mobile/common/js/jquery.touchSlider.js"></script>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function(){
		
			var lastPp = "${ppRsvRoomCodeList.get(0).ppseq}";
		
			<c:forEach items="${ppRsvRoomCodeList }" var="ppList">
				<c:if test="${ppList.ppseq eq lastPp.ppseq}">
						lastPp = "${lastPp.ppseq}";
				</c:if>
			</c:forEach>
			
			setRoomList(lastPp,"${ppRsvRoomCodeList.get(0).typeseq}");
	});

	
//해당 교육장의 룸 정보 가져오기
function setRoomList(getPpseq,typeSeq){
	
	
	$("#getPpSeq").val(getPpseq);
	$("#getRoomTypeSeq").val(typeSeq);
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".selectArea.local>a").each(function () {
		$(this).removeClass("active");
	});
	 
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+getPpseq).addClass("active");
	
	var farm = {typeseq : typeSeq
			, ppseq : getPpseq};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomEduRoomInfoListAjax.do' />"
		, type : "POST"
		, data: farm
		, success: function(data, textStatus, jqXHR){
			var roomList = data.rsvRoomInfoList;
			
			var  html = "";
			
			for(var i = 0; i < roomList.length; i++){
				html += "<a href=\"javascript:void(0);\" id=\"detailRoomSeq"+roomList[i].roomseq+"\" name=\"detailRoomSeq\" onclick=\"javascript:detailRoom('"+roomList[i].roomseq+"','"+roomList[i].roomname+"');\">"+roomList[i].roomname+" ("+roomList[i].seatcount+")</a>";
			}
			
			$(".selectArea.room").empty();
			$(".selectArea.room").append(html);
			
			$(".selectArea.room").parent().next().slideUp();
			$(".selectArea.local").parent().next().slideDown();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 해당 pp의 준비물, 이용자격 등을 조회 */
function detailRoom(getRoomseq, getRoomName){
	
	$("#getRoomSeq").val(getRoomseq);
	$("#getRoomName").val(getRoomName);
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".selectArea.room>a").each(function () {
		$(this).removeClass("active");
	});
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailRoomSeq"+getRoomseq).addClass("active");
	
	var param = {roomseq : getRoomseq};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomEduRsvRoomDetailInfoAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var detailCode = data.roomEduRsvRoomDetailInfo;
			
			$("#getPpName").val(detailCode.ppname);
			
			$(".selectArea.room").parent().next().find(".tit").empty();
			$(".selectArea.room").parent().next().find(".tit").append(detailCode.ppname + " " + detailCode.roomname);
			$(".selectArea.room").parent().next().find(".roomSubText").empty();
			$(".selectArea.room").parent().next().find(".roomSubText").append(detailCode.intro);
			
			var html = "<dt class=\"noneBdT\"><span class=\"bizIcon icon1\"></span>정원</dt>"
			         + "<dd class=\"noneBdT\">"+detailCode.seatcount+"</dd>"
			         + "<dt><span class=\"bizIcon icon2\"></span>이용시간</dt>"
			         + "<dd>"+detailCode.usetime+"</dd>"
			         + "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"
			         + "<dd>"+detailCode.role+"<br/><span class=\"fsS\">("+detailCode.rolenote+")</span></dd>"
			         + "<dt><span class=\"bizIcon icon4\"></span>부대시설</dt>"
			         + "<dd>"+detailCode.facility+"</dd>";
			$(".selectArea.room").parent().next().find(".roomTbl").empty();
			$(".selectArea.room").parent().next().find(".roomTbl").append(html);
			
			$("#selectedPpInfo").text(detailCode.ppname+" | "+detailCode.roomname+"("+detailCode.seatcount+")");
			
			if(detailCode.filekey == null){
				/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
				$(".selectArea.room").parent().next().slideDown(function(){
//	 					touchsliderFn();
				});
				
				setTimeout(function(){ abnkorea_resize(); }, 500);
				
				touchsliderFn();
			}else{
				/* 해당 시설 이미지 파일 조회 */
				roomImageListAjax(detailCode.filekey);
			}
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}


/* 해당 시설 이미지 파일 조회 */
function roomImageListAjax(fileKey) {
	var param = {"fileKey" : fileKey};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomImageUrlListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var urlList = data.roomImageUrlList;
			
			var html = "";
			for(var num in urlList){
//  				html += "<li><img src=\"/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION""\" alt="+urlList[num].roomname+" /></li>";
				html += "<li><img src='/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION' alt="+urlList[num].roomname+" /></li>";
			}
			$("#touchSlider ul").empty();
			$("#touchSlider ul").append(html);
			
			/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
			$(".selectArea.room").parent().next().slideDown(function(){
// 					touchsliderFn();
			});
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			touchsliderFn();
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}
</script>
<body>
<input type="hidden" id="getRoomTypeSeq">
<input type="hidden" id="getRoomSeq">
<input type="hidden" id="getRoomName">
<input type="hidden" id="getPpSeq">
<input type="hidden" id="getPpName">
			<div class="result" id="roomBiz_step1_result">
				<div class="tWrap">
					<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong>
					<span id="selectedPpInfo"></span>
				</div>
			</div>  
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong><span>지역 선택 후 룸 타입을 선택하세요.</span></div></dt>
					<dd>
						<div class="hWrap">
							<p class="tit">지역 선택</p>
							<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen">
								<span>AP 안내</span>
							</a>
						</div>
						<!-- 지역선택 -->
						<div class="selectArea local">
							<c:forEach items="${ppRsvRoomCodeList }" var="ppList">
								<c:choose>
									<c:when test="${ppList.ppseq eq lastPp.ppseq }">
										<a href="javascript:void(0);" class="active"  id="detailPpSeq${ppList.ppseq }" name="detailPpSeq" onclick="javascript:setRoomList('${ppList.ppseq}','${ppList.typeseq }');">${ppList.ppname}</a>
									</c:when>
									<c:otherwise>
										<a href="javascript:void(0);"  id="detailPpSeq${ppList.ppseq }"  name="detailPpSeq"  onclick="javascript:setRoomList('${ppList.ppseq}','${ppList.typeseq }');">${ppList.ppname}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</dd>
					<dd>
						<p class="tit">룸 선택</p>
						<!-- 룸선택 -->
						<div class="selectArea sizeM room"></div>
					</dd>
					<dd class="dashed">
						<p class="tit">강서 AP 비전센타 1</p>
						<div class="roomInfo">
							<!-- @edit 2016.07.18 갤러리 형태로 수정-->
							<div class="roomImg touchSliderWrap">
								<a href="#none" class="btnPrev"><img src="/_ui/mobile/images/common/ico_slidectrl_prev2.png" alt="이전"></a>
								<a href="#none" class="btnNext"><img src="/_ui/mobile/images/common/ico_slidectrl_next2.png" alt="다음"></a>
								<div class="touchSlider" id="touchSlider">
									<ul>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_001.jpg" alt="강서 AP 퀸룸" /></li>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_002.jpg" alt="강서 AP 퀸룸" /></li>
									</ul>
								</div>
								<div class="sliderPaging"></div>
							</div>
							<!-- //@edit 2016.07.18 갤러리 형태로 수정-->
							<div class="roomSubText"></div>
							<dl class="roomTbl"></dl>
						</div>
						<div class="btnWrap">
							<a href="#none" id="step1Btn" class="btnBasicBL">다음</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
</body>