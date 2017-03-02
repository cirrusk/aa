<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
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
	
// 	$(".btnBasicBL").on("click", function(){

		
// 	});
	
});


/*
 * 필수 입력값 체크 및 확인
 */
var mendatoryCheck = {
		
	partnerSelectbox : function(){
		
		var mendatoryCheckForSelectBox = false;
		
		$("select[name=partnerTypeCode]").each(function(){
			if(0 == $(this).val().length){
				mendatoryCheckForSelectBox = true;
			}
		});
		
		if(mendatoryCheckForSelectBox){
			alert("동반여부는필수 선택 입니다.");
			return false;
		}else{
			return true;
		}
	}
};

function expBrandInsert(){
	
	if(!mendatoryCheck.partnerSelectbox()){
		return;
	}
	
	$(".btnBasicBL").removeAttr("onclick");
	
	var param = $("#expBrandForm").serialize();
	
	$.ajax({
		url: "<c:url value='/reservation/expBrandCalendarInsertAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				var expBrandRsvInfoList = data.expBrandCalendarRsvInfoList;
				var totalCnt = data.totalCnt;
				if(expBrandRsvInfoList[0].msg == "false"){
					alert(expBrandRsvInfoList[0].reason);
					return false;
				}else{
					/* 부모창으로  예약한 데이터 전달 */
					try{
						window.opener.$("#transactionTime").val(data.transactionTime);
						window.opener.expBrandCalendarRsvDetail(expBrandRsvInfoList, totalCnt);
						self.close();
					}catch(e){
						//console.log(e);
					}
				}
				
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			
			$(".btnBasicBL").attr("onclick", "javascript:expBrandInsert()");
		}
	});
}

</script>
</head>
<body>
<form id="expBrandForm" name="expBrandForm" method="post">
	<div id="pbPopWrap">
		<header id="pbPopHeader">
			<h1><img src="/_ui/desktop/images/academy/h1_w020500080.gif" alt="예약정보 확인" /></h1>
		</header>
		<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
		<section id="pbPopContent">
				
			<span class="resvItem"><c:out value="${expBrandRsvInfoList[0].getYear}-${expBrandRsvInfoList[0].getMonth}-${expBrandRsvInfoList[0].getDay}${expBrandRsvInfoList[0].weekDay}"/></span>
			
			<table class="confirmTbl">
				<caption>예약정보 확인</caption>
				<colgroup>
					<col style="width:10%" />
					<col style="width:auto" />
					<col style="width:25%" />
					<col style="width:17%" />
				</colgroup>
				<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col">프로그램</th>
					<th scope="col">체험시간</th>
					<th scope="col">동반여부</th>
				</tr>
				</thead>
				<tfoot>
				<tr>
					<td colspan="4" class="total textR"><strong>총${totalCnt} 건</strong></td>
				</tr>
				</tfoot>
				<tbody>
				
				<c:forEach items="${expBrandRsvInfoList}" var="item">
					<tr>
						<c:if test="${item.accountType eq 'A01'}">
							<td>
								<c:out value="개인"/>
							</td>
						
						</c:if>
						<c:if test="${item.accountType ne 'A01'}">
							<td>
								<c:out value="그룹"/>
							</td>
						</c:if>
						<c:if test="${item.preparation ne 'N'}">
							<td>
								${item.productName}<br/>${item.preparation}
							</td>
						</c:if>
						<c:if test="${item.preparation eq 'N'}">
							<td>
								${item.productName}
							</td>
						</c:if>
						
						<td>
							${item.sessionTime}
							<input type="hidden" name="reservationDate" value="${item.getYear}${item.getMonth}${item.getDay}">
							<input type="hidden" name="ppSeq" value="${item.ppSeq}">
							<input type="hidden" name="ppName" value="${item.ppName}">
							<input type="hidden" name="expsessionseq" value="${item.expsessionseq}">
							<input type="hidden" name="productName" value="${item.productName}">
							<input type="hidden" name="enddatetime" value="${item.enddatetime}">
							<input type="hidden" name="startdatetime" value="${item.startdatetime}">
							<input type="hidden" name="accountType" value="${item.accountType}">
							<input type="hidden" name="expseq" value="${item.expseq}">
							<input type="hidden" name="typeseq" value="${item.typeseq}">
							<input type="hidden" name="rsvflag" value="${item.rsvflag}">
							<input type="hidden" name="sessionTime" value="${item.sessionTime}">
						</td>
						<c:if test="${item.accountType eq 'A01'}">
							<td>
								<select title="동반인 선택" class="tdSel" name="partnerTypeCode">
									<option value="">선택</option>
									<c:forEach items="${partnerTypeCodeList}" var="codeList">
										<option value="${codeList.commonCodeSeq}">${codeList.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</c:if>
						<c:if test="${item.accountType ne 'A01'}">
							<td>-</td>
						</c:if>
					</tr>
				</c:forEach>
				<tr>

					
				</tr>
				</tbody>
			</table>
			
			<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
			
			<div class="btnWrapC">
				<input type="button" class="btnBasicGL" value="예약취소" />
				<input type="button" class="btnBasicBL" onclick="javascript:expBrandInsert();" value="예약확정" />
			</div>
		
		</section>
	</div>
	
</form>

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>