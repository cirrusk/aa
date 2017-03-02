<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<title>[팝업] 교육비동의 전체보기 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<!--[endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>

<script type="text/javascript">
	$(document.body).ready(function() {
		fn_init();
	});
	
	function fn_init() {
		$.ajaxCall({
			url : "<c:url value="${pageContext.request.contextPath}/trainingFee/trainingFeeAgreeText.do"/>",
			data : $("#trainingFeeAgree").serialize(),
			success : function(data, textStatus, jqXHR) {
				var html = data.dataList.agreetext;
				
				$("#agreeTxt").html(html);
				$("input[name='agreeid']").val(data.dataList.agreeid);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	function popclose(){
		opener.close();	
	}
	
	function getView(id) {
		$(".logTabSection").hide();
		
		$('#titleagreeDeleg').removeClass('on');
		$('#titleagreePledge').removeClass('on');
		$('#titlethirdPerson').removeClass('on');
		
		$("#"+id).show();
		
		$("#title"+id).addClass('on');
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
		<div class="tabWrapLogical tabStyle2">
			<c:if test="${!empty dataDeleg}">
			<section class="logTabSection">
				<h2 class="tab01"><a href="javascript:getView('agreeDeleg');" id="titleagreeDeleg">[필수] ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</a></h2>
				<div class="tabcon">
					<h3>[필수] ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</h3>
					<div class="scrollbox">
						<div class="termsWrapper pdNone" tabindex="0">
							${dataDeleg.agreetext }
							
							<p class="mgtM">&lt; 교육비 권한을 부여하는 대상자 &gt;</p>
							<table class="tblList lineLeft mgtS">
							<caption>교육비 권한을 부여하는 대상자</caption>
							<colgroup>
								<col style="width:50%" />
								<col style="width:50%" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">ABO 번호</th>
									<th scope="col">수령자</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="item" items="${dataDeleg}" varStatus="status">
								<tr>
									<td>${item.delegatoraboNo }</td>
									<td>${item.delegatoraboname }</td>
								</tr>
								</c:forEach>
							</tbody>
							</table>
						</div>
					</div>
				</div>
			</section>
			</c:if>
			<c:if test="${!empty dataPledge}">
			<section class="logTabSection on">
				<h2 class="tab02"><a href="javascript:getView('agreePledge');" id="titleagreePledge">[필수] ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의</a></h2>
				<div class="tabcon">
					<h3>[필수] ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의</h3>
					<div class="scrollbox">
						${dataDeleg.agreetext }
					</div>
				</div>
			</section>
			</c:if>
			<c:if test="${!empty dataPerson}">
			<section class="logTabSection">
				<h2 class="tab03"><a href="javascript:getView('thirdPerson');" id="titlethirdPerson">[선택] ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의</a></h2>
				<div class="tabcon">
					<h3>[선택] ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의</h3>
					<div class="scrollbox">
						<!-- 20160810 추가 -->
						<table class="tblInput mgtS">
							<caption>개인정보 제3자 조회 동의</caption>
							<colgroup>
								<col style="width:100px" />
								<col style="width:auto" />
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
								<col style="width:50%" />
								<col style="width:50%" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">ABO 번호</th>
									<th scope="col">이름</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="item" items="${dataPerson}" varStatus="status">
								<tr>
									<td>${item.thirdperson }</td>
									<td>${item.thirdpersonname }</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
						<!-- //20160810 추가 -->
					</div>
				</div>
			</section>
			</c:if>
		</div>
		
		<div class="btnWrapC pdNone">
			<a href="javascript:window.close();" class="btnBasicGL"><span>닫기</span></a>
		</div>
		
	</section>
</div>
</body>
</html>