<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	$(document.body).ready(function() {
		
		// 교육비 동의 1
		$("#trainingFeeAgreeSubmit").on("click", function(){
			if($("input[name='tfAgree1']:checked").val() == "Y"){
				$("input[name='agreeflag']").val("Y");
			}else{
				alert("동의 후 이용할 수 있습니다.");
				return false;
			}
			
			// 약관 동의 후 index페이지 호출
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveAgreeText.do"/>",
				data : $("#trainingFeeAgree").serialize(),
				success : function(data, textStatus, jqXHR) {
					$("#trainingFeeAgree").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
					$("#trainingFeeAgree").submit();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});

		});
		
		$(".tabStyle2 > a")[0].click();
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		if( !isNull(document.getElementById("ptxt")) ) {
			var text = $("#ptxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#ptxt > p")[i].remove();
			}	
		}
		
		if( !isNull(document.getElementById("delegTxt")) ) {
			var text = $("#personTxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#personTxt > p")[i].remove();
			}	
		}
		
		if( !isNull(document.getElementById("personTxt")) ) {
			var text = $("#personTxt > p").length;
			for(var i=0; i < text; i++) {
				if(i>2) $("#personTxt > p")[i].remove();
			}	
		}
		
				
	});
	
	function getView(id) {
		$(".lyWrap").hide();
		$('#titleagreeDeleg').removeClass('on');
		$('#titleagreePledge').removeClass('on');
		$('#titlethirdPerson').removeClass('on');
		
		$("#"+id).show();
		
		$("#title"+id).addClass('on');
	}
	
	function fn_init() {
		$.ajaxCall({
			url : "<c:url value="/mobile/trainingFee/trainingFeeAgreeText.do"/>",
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
	
	var reload = {
			pagego : function(){
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			},
			popClose : function() {
				$("#layerMask").hide();
				$("#uiLayerPop_mTFAll").hide();
			},
			confrim : function() {
				var result = confirm("제3자 약관 동의 여부를 변경 하시겠습니까?");
				
				if(result){
					// 약관 동의 후 index페이지 호출
					$.ajaxCall({
						url : "<c:url value="/mobile/trainingFee/updateThirdpersonAgree.do"/>",
						data : $("#trainingFeeAgree").serialize(),
						success : function(data, textStatus, jqXHR) {
							alert("변경 완료 하였습니다.");
							$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
							$("#trainingFeeForm").submit();
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alert("처리도중 오류가 발생하였습니다.");
						}
					});
	
				}
			}
	}
	
</script>

</head>
<body>

<!-- content area | ### academy IFRAME Start ### -->
	<section id="pbContent">
		<form id="trainingFeeForm" name="trainingFeeForm" method="post">
			<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }"    />
			<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"      />
			<input type="hidden" name="delegtypecode" value="${scrData.delegtypecode }" />
		</form>
		<!-- 교육비 동의관리 -->
		<div class="mTrainingFee">
		
			<h2 class="titTop titTop2">교육비동의 관리 <a href="javascript:reload.pagego();" class="btnTbl">교육비관리 목록</a></h2>
							
			<c:if test="${!empty agreeDeleg}">
				<h3 class="titTop3"><span>[필수]</span> ${scrData.fiscalyear} 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의
					<a href="#uiLayerPop_mTFAll" class="btnView" onclick="layerPopupOpen(this);return false;"><span>전체보기</span></a>
				</h3>
				<div class="mAgreeWrap">
					<div class="mAgreeBox">
						${agreeDeleg.agreetext}
						<strong>&lt; 교육비 권한을 부여하는 ABO &gt;</strong>
						<table class="tblDefalut mgtS">
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
					<p class="textR">${agreeDeleg.agreedate} 동의함</p>
				</div>
			</c:if>
			
			<h3 class="titTop3"><span>[필수]</span> ${scrData.fiscalyear} 회계연도 교육비(소득세 포함) 수령에 대한 동의
				<a href="#uiLayerPop_mTFAll" class="btnView" onclick="layerPopupOpen(this);return false;"><span>전체보기</span></a>
			</h3>
			
			<div class="mAgreeWrap">
				<div class="mAgreeBox" id="ptxt">
					${agreePledge.agreetext}
				</div>
				<p class="textR">${agreePledge.agreedate} 동의함</p>
			</div>
			
			<c:if test="${!empty thirdPerson}">
				<h3 class="titTop3"><span>[선택]</span> ${scrData.fiscalyear} 회계연도 개인정보 제3자 조회 동의
					<a href="#uiLayerPop_mTFAll" class="btnView" onclick="layerPopupOpen(this);return false;"><span>전체보기</span></a>
				</h3>
				
				<div class="mAgreeWrap">
					<div class="mAgreeBox">
						${thirdPerson.agreetext}
					</div>
					<form id="trainingFeeAgree" name="trainingFeeAgree" method="post">
					<div class="agreeSec mgtS pd10">
						<p class="textR">
							<input type="radio" name="agreeflag" <c:if test="${thirdPerson.agreeflag eq 'Y'}"> checked</c:if> value="Y" class="mglM"><label for="tfAgree07">동의함</label> 
							<input type="radio" name="agreeflag" <c:if test="${thirdPerson.agreeflag eq 'N'}"> checked</c:if> value="N"><label for="tfAgree08">동의하지 않음</label>
							<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }" />
							<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"   />
						</p>
					</div>
					</form>
					<div class="btnWrap aNumb1">
						<a href="javascript:reload.confrim();" class="btnBasicBL">확인</a>
					</div>
				</div>
			</c:if>
			
			<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_mTFAll" style="display: block; top: 0px;" tabindex="0">
				<div class="pbLayerHeader">
					<strong>교육비동의 전체보기</strong>
				</div>
				<div class="pbLayerContent" style="height: 875px; overflow: auto;">
					<!-- 20160819 수정 -->
					<div class="tabStyle2">
						<c:if test="${!empty agreeDeleg}">
							<a href="javascript:getView('agreeDeleg');" id="titleagreeDeleg" class="on">[필수] ${scrData.fiscalyear} 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</a>
						</c:if>
						<a href="javascript:getView('agreePledge');" id="titleagreePledge" >[필수] ${scrData.fiscalyear} 회계연도 교육비(소득세 포함) 수령에 대한 동의</a>
						<c:if test="${!empty thirdPerson}">
							<a href="javascript:getView('thirdPerson');" id="titlethirdPerson" >[선택] ${scrData.fiscalyear} 회계연도 개인정보 제3자 조회 동의</a>
						</c:if>
					</div>
					<c:if test="${!empty agreeDeleg}">
					<section class="mAgreeWrap lyWrap" id="agreeDeleg" style="display:none">
						<h3><span>[필수]</span> ${scrData.fiscalyear} 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</h3>
						<div class="mAgreeBox" id="delegTxt">
							${agreeDeleg.agreetext}
							<div class="mgtM">
								<strong>&lt; 교육비 권한을 부여하는 ABO &gt;</strong>
								<table class="tblDefalut mgtS">
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
										<c:forEach var="item" items="${agreeDelegList}" varStatus="status">
										<tr>
											<td>${item.delegatoraboNo }</td>
											<td>${item.delegatoraboname }</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
							
						</div>
					</section>
					</c:if>
					
					<section class="mAgreeWrap lyWrap" id="agreePledge" style="display:none">
						<h3><span>[필수]</span> ${scrData.fiscalyear} 회계연도 교육비(소득세 포함) 수령에 대한 동의</h3>
						<div class="mAgreeBox" id="personTxt">
							${agreePledge.agreetext}
						</div>
					</section>
					
					<c:if test="${!empty thirdPerson}">
					<section class="mAgreeWrap lyWrap" id="thirdPerson" style="display:none">
						<h3><span>[선택]</span> ${scrData.fiscalyear} 회계연도 개인정보 제3자 조회 동의</h3>
						<table class="tblDefalut2 mgtS">
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
						<h3 class="mgtM">제공 받는 자(교육비 관리 권한 위임 ABO)</h3>
						<table class="tblDefalut mgtS">
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
								<c:forEach var="item" items="${thirdPersonList}" varStatus="status">
								<tr>
									<td>${item.thirdperson }</td>
									<td>${item.thirdpersonname }</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</section>
					</c:if>
					<div class="btnWrap aNumb1 full"><a href="javascript:reload.popClose();" class="btnBasicGL">닫기</a></div>
					<!-- //20160819 수정 -->
				</div>	<!-- // pbLayerContent-->
				<a href="#none" class="btnPopClose" id="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			
		</div>
		<!-- //교육비 동의관리 -->	
	</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
