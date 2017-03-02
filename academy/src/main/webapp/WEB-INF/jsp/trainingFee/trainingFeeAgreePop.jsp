<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>
<!-- //page unique -->
<title>교육비 관리 - ABN Korea</title>

<script type="text/javascript">
	$(document.body).ready(function() {
		$(".tabStyle2 > a")[0].click();
	});
	
	function getView(id) {
		$(".logTabSection").hide();
		
		$('#titleagreeDeleg').removeClass('on');
		$('#titleagreePledge').removeClass('on');
		$('#titlethirdPerson').removeClass('on');
		
		$("#"+id).show();
		
		$("#title"+id).addClass('on');
	}
	
	function popclose(){
		opener.close();	
	}
</script>
</head>

<body>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020400461.gif" alt="교육비동의 전체 보기" /></h1>
	</header>
	<a href="javascript:window.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
		<div class="tabStyle2">
			<c:if test="${!empty agreeDeleg}">
			<a href="javascript:getView('agreeDeleg');" id="titleagreeDeleg" class="on">[필수] ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</a>
			</c:if>
			<c:if test="${!empty agreePledge}">
			<a href="javascript:getView('agreePledge');" id="titleagreePledge" >[필수] ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의</a>
			</c:if>
			<c:if test="${!empty thirdPerson}">
			<a href="javascript:getView('thirdPerson');" id="titlethirdPerson" >[선택] ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의</a>
			</c:if>
		</div>
		
		<c:if test="${!empty agreeDeleg}">
		<section class="logTabSection" id="agreeDeleg" style="display:none">
			<h2>[필수] ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</h2>
			<div class="scrollbox">
				<div class="termsWrapper pdNone" tabindex="0">
					${agreeDeleg.agreetext}
					<strong>&lt; 교육비 권한을 부여하는 ABO &gt;</strong>
					<table class="tblList lineLeft mgtS">
					<caption>교육비 권한을 부여하는 ABO</caption>
					<colgroup>
						<col style="width:50%">
						<col style="width:50%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">ABO 번호</th>
							<th scope="col">위임자</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<c:forEach var="item" items="${agreeDelegList}" varStatus="status">
							<tr>
								<td>${item.delegatoraboNo }</td>
								<td>${item.delegatoraboname }</td>
							</tr>
							</c:forEach>
						</tr>
					</tbody>
					</table>
				</div>
			</div>
		</section>
		</c:if>
		
		<c:if test="${!empty agreePledge}">
		<section class="logTabSection" id="agreePledge" style="display:none">
			<h2>[필수] ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의</h2>
			<div class="scrollbox">
				${agreePledge.agreetext }
			</div>
		</section>
		</c:if>
		
		<c:if test="${!empty thirdPerson}">
		<section class="logTabSection" id="thirdPerson" style="display:none">
			<h2>[선택] ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의</h2>
			<div class="scrollbox">
				<table class="tblInput mgtS">
					<caption>개인정보 제3자 조회 동의</caption>
					<colgroup>
						<col style="width:100px">
						<col style="width:auto">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제공받는 자</th>
							<td>교육비 관리에 대한 권한을 위임 받은 ABO</td>
						</tr>
						<tr>
							<th scope="row">목적</th>
							<td>교육비에 관한 전체적인 관리 대행</td>
						</tr>
						<tr>
							<th scope="row">항목</th>
							<td>ABO 번호, 이름, 교육비 예산 금액, 사전 계획 내용(일자, 교육종류, 교육명, 횟수, 예상금액, 비율 외),
								지출증빙내용(영수증 등 증빙서류), 처리 현황
							</td>
						</tr>
						<tr>
							<th scope="row">보유기간</th>
							<td>해당 회계연도(1년) 또는 교육비 관리 권한 위임자 변경시까지</td>
						</tr>
					</tbody>
				</table>
					
				<p class="listDotFS fcDG mgtM">제공 받는 자(교육비 관리 권한 위임 ABO)</p>
				<table class="tblList lineLeft mgtS">
					<caption>교육비 권한을 부여하는 대상자</caption>
					<colgroup>
						<col style="width:50%">
						<col style="width:50%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">ABO 번호</th>
							<th scope="col">이름</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<c:forEach var="item" items="${thirdPersonList}" varStatus="status">
							<tr>
								<td>${item.thirdperson }</td>
								<td>${item.thirdpersonname }</td>
							</tr>
							</c:forEach>
						</tr>
					</tbody>
				</table>
			</div>
		</section>
		</c:if>
		
		<div class="btnWrapC">
			<a href="javascript:window.close();" class="btnBasicGL"><span>닫기</span></a>
		</div>
		
	</section>
</div>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>