<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
	$(".btnBasicGL").on("click", function(){
		
		try{
// 			window.opener.location.reload();
			self.close();
		}catch(e){
			//console.log(e);
		}
	});
});

function detailCultureIntro(obj){
	if($(obj).parent().is(".active") == true){
		$(obj).parent().removeClass("active");
		$(obj).parent().next().removeClass("active");
	}else{
		$(".programList").children().removeClass("active");
		
		$(obj).parent().addClass("active");
		$(obj).parent().next().addClass("active");
	}

}

</script>
</head>
<body>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500311.gif" alt="문화체험 소개" /></h1>
	</header>
	<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">

		<div class="programWrap">
			<!-- @edit 20160627 프로그램 이미지 삭제  -->
			<dl class="programList mgNone">
				<c:set value="" var="expSeq"/>
				<c:forEach var="itemFirst" items="${expCultureIntroduceList}" varStatus="status">
					<c:if test="${itemFirst.expseq ne expSeq}">
						<c:set value="${itemFirst.expseq}" var="expSeq"/>
						<c:if test="${itemFirst.expseq eq tempexpseq}">
						<dt class="active"><a href="#none" onclick="javascript:detailCultureIntro(this);"><strong>${itemFirst.themename}</strong><br/><span class="normal">[${itemFirst.ppname}] ${itemFirst.productname}</span><span class="btn">내용보기</span></a></dt>
						<dd class="active">
						</c:if>
						<c:if test="${itemFirst.expseq ne tempexpseq}">
						<dt><a href="#none"  onclick="javascript:detailCultureIntro(this);"><strong>${itemFirst.themename}</strong><br/><span class="normal">[${itemFirst.ppname}] ${itemFirst.productname}</span><span class="btn">내용보기</span></a></dt>
						<dd>
						</c:if>
						
						<section class="programInfoWrap">
							<div class="programInfo">
								<p>${itemFirst.intro}</p>
								<p>${itemFirst.content}</p>
							</div>
							<table class="roomInfoDetail">
								<colgroup>
									<col width="20%" />
									<col width="auto" />
									<col width="20%" />
									<col width="auto" />
								</colgroup>
								<tr>
									<td class="title"><span class="icon6">장소</span></td>
									<td>${itemFirst.ppname}</td>
									<td class="title"><span class="icon7">일정</span></td>
									<td>
										
									<c:set value="" var="expSessionSeq"/>
									<c:set value="" var="setTypeCode"/>
									<c:set value="true" var="renderFlag"/>
									<c:set value="0" var="renderCnt"/>
									<c:forEach var="itemSecond" items="${expCultureIntroduceList}" varStatus="status">
										<c:if test="${itemSecond.expseq eq expSeq}">
											<c:if test="${itemSecond.expsessionseq ne expSessionSeq}">
												<c:set value="${itemSecond.expsessionseq}" var="expSessionSeq"/>
												<c:set value="${itemSecond.settypecode}" var="setTypeCode"/>
												<c:set value="true" var="renderFlag"/>
												<c:set value="0" var="renderCnt"/>
											</c:if>
											<c:if test="${itemSecond.settypecode ne setTypeCode
														|| itemSecond.worktypecode eq 'R02'
														|| itemSecond.standbynumber eq 1}">
												<c:set value="false" var="renderFlag"/>
											</c:if>
											<c:if test="${renderFlag eq 'true' && renderCnt eq '0'}">
														${itemSecond.month}월 ${itemSecond.day}일(${itemSecond.krweekday}) ${fn:substring(itemSecond.startdatetime, 0, 2)}시<br/>
												<c:set value="1" var="renderCnt"/>
											</c:if>
										</c:if>
									</c:forEach>
									</td>
								</tr>
								<tr>
									<td class="title"><span class="icon1">정원</span></td>
									<td>${itemFirst.seatcount}</td>
									<td class="title"><span class="icon2">체험시간</span></td>
									<td>${itemFirst.usetime}</td>
								</tr>
								<tr>
									<td class="title"><span class="icon3">예약자격</span></td>
									<td>${itemFirst.role}<br/><span class="normal">${itemFirst.rolenote}</span></td>
									<td class="title"><span class="icon5">준비물</span></td>
									<td>${itemFirst.preparation}</td>
								</tr>
							</table>
						</section>
					</dd>
					</c:if>
				</c:forEach>

			</dl>
		</div>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="닫기" />
		</div>
	
	</section>
</div>

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>