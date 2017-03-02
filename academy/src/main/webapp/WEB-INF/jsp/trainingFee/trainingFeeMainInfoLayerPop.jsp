<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>
</head>

<body>
	<section class="bizroom">
			
		<!-- layer popup 교육비 항목 도움말  -->
<!-- 		<div class="pbLayerWrap" id="uiLayerPop_help01" style="width: 600px; display: none;"> -->
			<div class="pbLayerHeader">
				<strong>
					<img src="/_ui/desktop/images/academy/h1_w020500400_pop.gif" alt="교육비 항목 도움말">
				</strong>
				
				<a href="javascript:$('#acdemyLayerPop').remove();$('#layerMask').remove();" class="btnPopClose" id="btnPopClose" ><img src="/_ui/desktop/images/common/btn_close.gif" alt="닫기"></a>
			</div>
			<div class="pbLayerContent">
				<ul class="listDotFS">
					<li><strong>교육비 예산</strong>
						<p>교육비 예산은 각 다이아몬드 그룹 단위 순매출액의 2%로 산정되며, 확정전에는 최근 교육비를 예상값으로 사전계획을 수립하시면 됩니다.</p>
					</li>
					<li class="mgtM"><strong>사전계획</strong>
						<p>지출증빙을 위한 필수 단계입니다. 각 단계는 다음의 경우에 발생됩니다.</p>
						<ul class="listDot pdNone">
							<li>계획조회 : 계획이 완료된 단계로 수립한 계획 조회 가능</li>
							<li>[등록] : 계획 수립이 필요한 경우 발생</li>
							<li>등록중 : 계획을 수립중이나 완료되지 않은 단계에서 발생</li>
						</ul>
					</li>
					<li class="mgtM"><strong></strong>
						<p>사전계획이 수립된 경우에만 가능하며, 영수증이 필요합니다.</p>
						<ul class="listDot pdNone">
							<li>지출조회 : 지출증빙이 완료된 단계로 제출한 증빙 조회 가능</li>
							<li>[등록] : 지출증빙이 필요한 경우 발생</li>
							<li>등록중 : 지출증빙중이나 완료되지 않은 단계에서 발생</li>
						</ul>
					</li>
					<li class="mgtM"><strong>처리현황</strong>
						<p>지출증빙 제출 후 처리현황을 알려드립니다.</p>
						<ul class="listDot pdNone">
							<li>" – " : 지출증빙 제출 불가 단계</li>
							<li>등록 : 처리 대상이나 사전계획/지출증빙이 등록 전</li>
							<li>등록전 : 등록은 하였으나 제출 전</li>
							<li>제출완료 : 지출증빙까지 제출 후 접수한 단계</li>
							<li>승인중 : 등록 후 (담당자 확인 중)</li>
							<li>승인완료(승인일자)  : 등록 후 승인완료시 발생</li>
						</ul>
					</li>
				</ul>
			</div>
<!-- 		</div> -->
		
	</section>
</body>