<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	$(document.body).ready(function() {
		
		// 교육비 동의 1
		$("#trainingFeeAgreeSubmit").on("click", function(){
			if($("input[name='tfAgree1']:checked").val() == "Y"){
				$("input[name='agreeflag']").val("Y");
			}else{
				if( "${scrData.targetType}" !=  "type4" ) {
					alert("동의 후 이용할 수 있습니다.");
					$("input[name='tfAgree1']").focus();
					return false;
				}
				$("input[name='agreeflag']").val("N");
			}
			
			// 약관 동의 후 index페이지 호출
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveAgreeText.do"/>",
				data : $("#trainingFeeAgree").serialize(),
				success : function(data, textStatus, jqXHR) {
					$("#trainingFeeAgree").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
					$("#trainingFeeAgree").submit();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.agreesave.false"/>';
					alert(mag);
				}
			});

		});
		
		$("input[name=tfAgree1]").on("")
		
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
				//스크롤 사이즈
				abnkorea_resize();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="trfee.errors.agreeselect.false"/>';
				alert(mag);
			}
		});
	}
	
</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->

<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1>
			<img src="/_ui/desktop/images/academy/h1_w020400430.gif" alt="교육비 동의관리" />
		</h1>
		<p>
			<img src="/_ui/desktop/images/academy/txt_w020400430.gif" alt="교육비 관리에 필요한 교육비 권한 부여, 교육비 수령, 개인 정보 제3자 조회 동의를 관리합니다" />
		</p>
	</div>
	<!-- 교육비 동의관리 -->
	<div id="trainingFee">
		<c:if test="${scrData.targetType eq 'type1' }"> <p class="topBoxUpper"><strong>[필수]</strong> ${scrData.fiscalyear } 회계연도 교육비(소득세 포함) 수령에 대한 동의</p> </c:if>
		<c:if test="${scrData.targetType eq 'type2' }"> <p class="topBoxUpper"><strong>[필수]</strong> ${scrData.fiscalyear } 회계연도 교육비 권한 부여(소득세 포함)에 대한 동의</p> </c:if>
		<c:if test="${scrData.targetType eq 'type3' }"> <p class="topBoxUpper"><strong>[필수]</strong> ${scrData.fiscalyear } 회계연도 교육비 권한 <c:if test="${scrData.delegtypecode eq '1' }">수령</c:if><c:if test="${scrData.delegtypecode eq '2' }">부여</c:if>(소득세 포함)에 대한 동의</p> </c:if>
		<c:if test="${scrData.targetType eq 'type4' }"> <p class="topBoxUpper">[선택] ${scrData.fiscalyear } 회계연도 개인정보 제3자 조회 동의</p> </c:if>
		
		<div id="agreeTxt" class="mgtM ptxt">
		</div>
		
		<div class="agreeCWrap">
			
			<form id="trainingFeeAgree" name="trainingFeeAgree" method="post">
			<c:if test="${scrData.targetType eq 'type2' }">
				<p>&lt; 교육비 권한 부여에 대한 동의 &gt;</p>
				<table class="tblList lineLeft mgtS">
					<caption>교육비 권한 부여에 대한 동의</caption>
					<colgroup>
						<col style="width: 50%" />
						<col style="width: 50%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">ABO 번호</th>
							<th scope="col">위임자</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${agreeTarget}" varStatus="status">
						<tr>
							<td>${item.delegatoraboNo }</td>
							<td>${item.depaboname }
								<input type="hidden" name="delegatoraboNo" value="${item.delegatoraboNo }">
								<input type="hidden" name="delegaboNo" value="${item.delegaboNo }">
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			<c:if test="${scrData.targetType eq 'type3' }">
				<p>&lt; 교육비 권한을 부여하는 ABO &gt;</p>
				<table class="tblList lineLeft mgtS">
					<caption>교육비 권한을 부여하는 ABO</caption>
					<colgroup>
						<col style="width: 50%" />
						<col style="width: 50%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">ABO 번호</th>
							<th scope="col"><c:if test="${scrData.delegtypecode eq '1' }">위임자</c:if><c:if test="${scrData.delegtypecode eq '2' }">피위임자</c:if></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${agreeTarget}" varStatus="status">
						<tr>
							<c:if test="${scrData.delegtypecode eq '1' }">
								<td>${item.delegatoraboNo }</td>
								<td>${item.depaboname }
									<input type="hidden" name="delegatoraboNo" value="${item.delegatoraboNo }">
									<input type="hidden" name="delegaboNo" value="${item.delegaboNo }">
								</td>
							</c:if>							
							<c:if test="${scrData.delegtypecode eq '2' }">
								<td>${item.delegaboNo }</td>
								<td>${item.depaboname }
									<input type="hidden" name="delegatoraboNo" value="${item.delegatoraboNo }">
									<input type="hidden" name="delegaboNo" value="${item.delegaboNo }">
								</td>
							</c:if>							
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			<c:if test="${scrData.targetType eq 'type4' }">
				<table class="tblInput mgtS">
					<caption>개인정보 제3자 조회 동의</caption>
					<colgroup>
						<col style="width:150px">
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
				<div class="agreeCWrap">
					<p class="listDotFS fcDG">제공 받는 자(교육비 관리 권한 위임 ABO)</p>
					<table class="tblList lineLeft mgtS">
						<caption>교육비 권한을 부여받는 대상자</caption>
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
							<c:forEach var="item" items="${agreeTarget}" varStatus="status">
							<tr>
								<td>${item.depaboNo }
									<input type="hidden" name="thirdperson" value="${item.depaboNo }" />
								</td>
								<td>${item.depaboname }</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</c:if>
			
			<div class="agreeSec">
				본인은 위 내용을 읽고 명확히 이해하였으며 이에
				 <input type="radio" name="tfAgree1" class="mglM" value="Y" checked>
				 <label for="tfAgree01">동의함</label>
				 
				<input type="radio" name="tfAgree1" value="N">
				<label for="tfAgree02">동의하지 않음</label>
			</div>
			<div class="btnWrapC">
				
					<a href="#none" class="btnBasicBL" id="trainingFeeAgreeSubmit">확인</a>	
					<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }" />
					<input type="hidden" name="giveyear"      value="${scrData.giveyear }"   />
					<input type="hidden" name="givemonth"     value="${scrData.givemonth }"  />
					<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"   />
					<input type="hidden" name="agreetypecode" value="${scrData.agreetypecode }"   />
					<input type="hidden" name="delegtypecode" value="${scrData.delegtypecode }"   />
					<input type="hidden" name="agreeid"       value=""   />
					<input type="hidden" name="agreeflag"     value=""   />
			</div>
			</form>
		</div>

	</div>
	<!-- //교육비 동의관리 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
